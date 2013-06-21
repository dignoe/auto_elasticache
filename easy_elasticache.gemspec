# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_elasticache/version'

Gem::Specification.new do |gem|
  gem.name          = "easy_elasticache"
  gem.version       = EasyElasticache::VERSION
  gem.authors       = ["Chad McGimpsey"]
  gem.email         = ["chad.mcgimpsey@gmail.com"]
  gem.description   = %q{Automatically start and configure an AWS ElastiCache cluster from an Elastic Beanstalk environment}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/dignoe/auto_elasticache"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
