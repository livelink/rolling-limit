# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rolling/limit/version'

Gem::Specification.new do |spec|
  spec.name          = "rolling-limit"
  spec.version       = Rolling::Limit::VERSION
  spec.authors       = ["Geoff Youngs"]
  spec.email         = ["git@intersect-uk.co.uk"]
  spec.licenses      = ['MIT']

  spec.summary       = %q{A redis-based rolling rate limiter}
  spec.description   = %q{Uses redis sorted sets to allow easy rate limiting}
  spec.homepage      = "https://github.com/livelink/rolling-limit"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org/"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", '>= 3.0.0', '< 5.0'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
