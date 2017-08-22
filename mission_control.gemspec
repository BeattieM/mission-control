# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mission_control/version"

Gem::Specification.new do |spec|
  spec.name          = "mission_control"
  spec.version       = MissionControl::VERSION
  spec.authors       = ["Michael Beattie"]
  spec.email         = ["michaelebeattie@gmail.com"]

  spec.summary       = "A Ruby command line game"
  spec.description   = "Run space mission from your computer"
  spec.homepage      = "https://github.com/BeattieM/mission-control"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = ["mission_control"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'tty-prompt', '~> 0.12.0'
  spec.add_dependency 'pastel', '~> 0.7.1'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "flog", "~> 4.6"
  spec.add_development_dependency "flay", "~> 2.10"
  spec.add_development_dependency "rubocop", '~> 0.48'
  spec.add_development_dependency "reek", '~> 4.6'
end
