# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'encookie'
  spec.version       = '0.0.1'
  spec.authors       = ['Aidan Steele']
  spec.email         = ['aidan.steele@glassechidna.com.au']

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  # spec.homepage      = 'TODO: Put your gem's website or public repo URL here.'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'rack'
  spec.add_dependency 'multi_json'
end
