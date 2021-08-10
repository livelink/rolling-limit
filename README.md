# Rolling::Limit

A redis-backed rate limiter, using redis sorted sets.

The operations are not guaranteed to be atomic, so this will be subject to race conditions - but it should be good enough for most uses where the intent is to prevent high usage, rather than to accurately count the exact number of operations within a particular time period.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rolling-limit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rolling-limit

## Usage

Instantiate a `Rolling::Limit` object and then use `#remaining` to determine if an operation may be performed within the specified limits.

e.g.
```ruby
require 'rolling/limit'


limit = Rolling::Limit.new(redis: redis, key: "u:#{user.id}:api", max_operations: 100, timespan: 60)

if limit.remaining
  perform_api_operation(user)
else
  raise "Limit exceeded - try again soon"
end

```

or

e.g

```ruby
require 'rolling/limit'

limit = Rolling::Limit.new(redis: connection, key: "unique key",
                        max_operations: 5, timespan: 60)

limit.remaining # => 4
limit.remaining # => 3
limit.remaining # => 2
limit.remaining # => 1
limit.remaining # => 0
limit.remaining # => false
# ... 61s later
limit.remaining # => 4

```

```ruby
  # Rolling::Limit is a class that maintains a rolling limit of no more than
  # <max_operations> operations for a given <key> within <timespan> seconds.
  class Rolling::Limit
    def initialize(redis:, key:, max_operations:, timespan:)

    # Increments the counter and returns truthy (with number of remaining
    # operations)
    def remaining

    # Resets this counter
    def reset!

    # Returns true if there are remaining operations, without incrementing
    def remaining?
```

## Development

Run `docker-compose build` to build a Docker image. You can then run `docker-compose run --rm app bundle exec rspec` to run automated tests.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/livelink/rolling-limit.
