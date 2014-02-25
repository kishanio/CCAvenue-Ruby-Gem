# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ccavenue/version'

Gem::Specification.new do |spec|
  spec.name          = "ccavenue"
  spec.version       = Ccavenue::VERSION
  spec.authors       = ["Kishan Thobhani"]
  spec.email         = ["thobhanikishan@gmail.com"]
  spec.description   = %q{CCAvenue Payment Gateway.}
  spec.summary       = %q{Encryption & Decryption in core ruby itself. Request data, Response}
  spec.homepage      = "http://kishanio.github.io/CCAvenue-Ruby-Gem/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
