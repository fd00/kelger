# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kelger/version'

Gem::Specification.new do |spec|
  spec.name          = 'kelger'
  spec.version       = Kelger::VERSION
  spec.authors       = ['Daisuke Fujimura (fd0)']
  spec.email         = ['booleanlabel@gmail.com']

  spec.summary       = 'Generate yacp summary for repology'
  spec.description   = 'Generate yacp summary for repology'
  spec.homepage      = 'https://github.com/fd00/kelger'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.7'

  spec.add_development_dependency 'bundler', '>= 1.15.3'
  spec.add_development_dependency 'fasterer', '>= 0.8.3'
  spec.add_development_dependency 'rake', '>= 13.0'
  spec.add_development_dependency 'rubocop', '>= 0.90.0'
  spec.add_development_dependency 'rubocop-performance', '>= 1.8.0'
end
