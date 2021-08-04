# Rolling::Limit

A redis-backed rate limiter, using redis sorted sets.

````ruby
require 'rolling/limit'

rl = Rolling::Limit.new(redis: connection, key: "unique key",
                        max_operations: 5, timespan: 60)

rl.remaining # => 4
rl.remaining # => 3
rl.remaining # => 2
rl.remaining # => 1
rl.remaining # => 0
rl.remaining # => false
# ... 61s later
rl.remaining # => 4
````

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

TODO: Write usage instructions here

## Development

Run `docker-compose build` to build a Docker image. You can then run `docker-compose run --rm app bundle exec rspec` to run automated tests.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/livelink/rolling-limit.
