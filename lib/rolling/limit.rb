require 'rolling/limit/version'
require 'redis'

module Rolling
  # Rolling::Limit is a class that maintains a rolling limit of no more than
  # <max_operations> operations for a given <key> within <timespan> seconds.
  class Limit
    def initialize(redis:, key:, max_operations:, timespan:)
      @redis = redis
      @key = "rlmt:#{key}"
      @timespan = timespan
      @max_operations = max_operations.to_i
    end

    # Increments the counter and returns truthy (with number of remaining
    # operations)
    def remaining
      cleanup
      return false if count >= max_operations
      increment
      max_operations - count
    end

    # Resets this counter
    def reset!
      redis.del(key)
    end

    # Shows numbers of remaining operations without incrementing
    def remaining?
      cleanup
      return false if count >= max_operations
      true
    end

    private

    attr_reader :key, :timespan, :max_operations, :redis

    # Ensure this key lives for at least <timespan>
    def autoexpire
      redis.expire(key, timespan)
    end

    # Delete operations that are older than time - timespan
    def cleanup
      redis.zremrangebyscore(key, '-inf', time - timespan)
    end

    def time
      Time.now.to_i
    end

    def unique_key
      "#{Time.now.to_f}.#{rand}"
    end

    def count
      redis.zcard(key)
    end

    def increment
      redis.zadd(key, time, unique_key)
      autoexpire
    end
  end
end
