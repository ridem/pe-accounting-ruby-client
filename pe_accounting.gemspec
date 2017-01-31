# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pe_accounting/version'

Gem::Specification.new do |spec|
  spec.name          = 'pe_accounting'
  spec.version       = PeAccounting::VERSION
  spec.author        = 'Mehdi Rejraji'
  spec.email         = 'mehdi.rejraji@gmail.com'

  spec.summary       = "A simple Ruby wrapper for PE Accounting's public API."
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/ridem/pe-accounting-ruby-client'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'multi_json', '~> 1.3', '>= 1.3.0'
  spec.add_runtime_dependency 'rest-client', '~> 2.0'
end
