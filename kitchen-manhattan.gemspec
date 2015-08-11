# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/provisioner/manhattan_version'

Gem::Specification.new do |spec|
  spec.name          = "kitchen-manhattan"
  spec.version       = Kitchen::Provisioner::MANHATTAN_VERSION
  spec.authors       = ["Thom May"]
  spec.email         = ["thom@may.lt"]

  spec.summary       = %q{A test kitchen provisioner for chef's manhattan CI pipeline}
  spec.homepage      = "https://chef.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
