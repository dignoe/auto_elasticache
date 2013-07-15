# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auto_elasticache/version'

Gem::Specification.new do |gem|
  gem.name          = "auto_elasticache"
  gem.version       = AutoElasticache::VERSION
  gem.authors       = ["Chad McGimpsey"]
  gem.email         = ["chad.mcgimpsey@gmail.com"]
  gem.description   = %q{Automatically start and configure an AWS ElastiCache cluster from an Elastic Beanstalk environment}
  gem.summary       = %q{AutoElasticache automatically starts an AWS ElastiCache cluster and configures Rails to use it. This gem requires that you are using AWS Elastic Beanstalk.}
  gem.homepage      = "https://github.com/dignoe/auto_elasticache"
  gem.license       = 'MIT'

  gem.add_dependency('aws-sdk')
  gem.add_dependency('dalli-elasticache')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
