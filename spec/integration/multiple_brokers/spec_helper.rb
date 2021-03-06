require 'spec_helper'

require 'test_cluster'

class ThreeBrokerCluster
  attr_reader :brokers, :zookeeper

  def initialize(partitions, properties = {})
    @zookeeper = ZookeeperRunner.new
    @brokers = (9092..9094).map { |port| BrokerRunner.new(port - 9092, port,
                                                          partitions,
                                                          2,
                                                          properties) }
  end

  def start
    @zookeeper.start
    @brokers.each(&:start)
    sleep 5
  end

  def stop
    SPEC_LOGGER.info "Stopping three broker cluster"
    SPEC_LOGGER.info "Stopping brokers"
    @brokers.each(&:stop)
    sleep 5

    SPEC_LOGGER.info "Stopping ZK"
    @zookeeper.stop
    sleep 5
  end

  def stop_first_broker
    SPEC_LOGGER.info "Stopping first broker"
    @brokers.first.stop
    sleep 5
  end

  def start_first_broker
    SPEC_LOGGER.info "Starting first broker"
    @brokers.first.start
  end
end

RSpec.shared_context "a multiple broker cluster" do
  let(:kafka_partitions) { 3 }

  before(:each) do
    JavaRunner.remove_tmp
    JavaRunner.set_kafka_path!
    $tc = ThreeBrokerCluster.new(kafka_partitions)
    $tc.start
    SPEC_LOGGER.info "Waiting on cluster"
    sleep 10 # wait for cluster to come up
  end

  after(:each) do
    $tc.stop if $tc
  end
end
