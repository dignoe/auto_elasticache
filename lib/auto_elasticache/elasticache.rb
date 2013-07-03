require "version"
require 'dalli-elasticache'

module AutoElasticache
  class Elasticache
    ENVIRONMENT_NAME_FILE = "/var/app/support/env_name"
    SERVERS_FILE = "/var/app/support/elasticache_servers"
    attr_accessor :config_endpoint

    def initialize
      @config_endpoint = config_endpoint
    end

    def servers
      if File.exists?(SERVERS_FILE)
        return File.read(SERVERS_FILE)
      else
        elasticache = Dalli::ElastiCache.new(configuration_endpoint)
        File.open(SERVERS_FILE, 'w') {|f| f.write(elasticache.servers) }
        return elasticache.servers
      end
    end

    def refresh_servers
      elasticache = Dalli::ElastiCache.new(configuration_endpoint)
      File.open(SERVERS_FILE, 'w') {|f| f.write(elasticache.servers) }
      return elasticache.servers
    end


    private

    def configuration_endpoint
      aws_config

      # Find the stack
      cf = AWS::CloudFormation.new
      env_name = environment_name
      stack_name = cf.stacks.each {|s| break s.name if s.parameters["AWSEBEnvironmentName"] == env_name}

      # Find the ElastiCache resource physical id
      ec_id = cf.stacks[stack_name].resources.each {|r| break r.physical_resource_id if r.resource_type == "AWS::ElastiCache::CacheCluster"}

      # Find the ElastiCache configuration endpoint
      ec = AWS::ElastiCache.new
      config_endpoint = ec.client.describe_cache_clusters(:cache_cluster_id => ec_id)[:cache_clusters].first[:configuration_endpoint]
      "#{config_endpoint[:address]}:#{config_endpoint[:port]}"
    end

    def environment_name
      if File.exists?(ENVIRONMENT_NAME_FILE)
        return File.read(ENVIRONMENT_NAME_FILE)
      else
        instance_id = `/opt/aws/bin/ec2-metadata -i | awk '{print $2}'`.strip
        aws_config
        ec2 = AWS::EC2.new
        env_name = ec2.instances[instance_id].tags["elasticbeanstalk:environment-name"]
        File.open(ENVIRONMENT_NAME_FILE, 'w') {|f| f.write(env_name) }
        env_name
      end
    end

    def aws_config
      @aws_config ||= AWS.config(YAML.load_file("config/auto_elasticache.yml")[Rails.env])
    end
  end
end