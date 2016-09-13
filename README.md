# EasyElasticache

Automatically start and configure an AWS ElastiCache cluster from an Elastic Beanstalk environment.

## Installation

Add this line to your application's Gemfile:

    gem 'auto_elasticache'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install auto_elasticache

### Configuration

Execute the following command to create the `.ebextensions/elasticache.config` and `config/auto_elasticache.yml` files

```bash
$ auto_elasticache
```

Change the names of the created resources to match your application and environment, and change the cache size to the appropriate value.

```yaml
Resources:
  AppNameEnvironmentElastiCache:                          <<<<<------
    Type: AWS::ElastiCache::CacheCluster
    Properties:
      CacheNodeType: cache.m1.small                       <<<<<------
      NumCacheNodes: 1
      Engine : memcached
      CacheSecurityGroupNames:
        - Ref: AppNameEnvironmentCacheSecurityGroup       <<<<<------
  AppNameEnvironmentCacheSecurityGroup:                   <<<<<------
    Type: AWS::ElastiCache::SecurityGroup
    Properties:
      Description: "Lock cache down to webserver access only"
  AppNameEnvironmentCacheSecurityGroupIngress:            <<<<<------
    Type: AWS::ElastiCache::SecurityGroupIngress
    Properties:
      CacheSecurityGroupName: 
        Ref: AppNameEnvironmentCacheSecurityGroup         <<<<<------
      EC2SecurityGroupName:
        Ref: AWSEBSecurityGroup
```

Add the AWS credentials for a IAM user/group that has the access to read Elastic Beanstalk data and create Elasticache instances to the `config/auto_elasticache.yml` file

```yaml
staging:
  access_key_id: 'my_key_id'
  secret_access_key: 'my_secret_key'
```

## Usage

Add the following to your environment config file (e.g. `config/environments/staging.rb`)

```ruby
elasticache = AutoElasticache::Elasticache.new
config.cache_store = :dalli_store, elasticache.servers
```

You can also add options

```ruby
elasticache = AutoElasticache::Elasticache.new
config.cache_store = :dalli_store,
  elasticache.servers,
  {
    :expires_in => 1.day,
    :socket_timeout => 1,
    :down_retry_delay => 2
  }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
