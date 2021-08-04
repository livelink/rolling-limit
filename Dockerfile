FROM ruby:3.0

WORKDIR /usr/local/src/rolling-limit

COPY lib/rolling/limit/version.rb ./lib/rolling/limit/
# Preinstall latest gems specified by gemspec; note that they may be overwritten by Gemfile.lock from mounted app dir
COPY Gemfile rolling-limit.gemspec ./

RUN bundle install
