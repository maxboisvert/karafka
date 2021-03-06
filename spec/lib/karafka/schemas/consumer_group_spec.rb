# frozen_string_literal: true

RSpec.describe Karafka::Schemas::ConsumerGroup do
  let(:schema) { described_class }

  let(:topics) do
    [
      {
        id: 'id',
        name: 'name',
        backend: :inline,
        controller: Class.new,
        parser: Class.new,
        max_bytes_per_partition: 1,
        start_from_beginning: true,
        batch_consuming: true,
        persistent: false
      }
    ]
  end
  let(:config) do
    {
      id: 'id',
      topic_mapper: Karafka::Routing::TopicMapper,
      seed_brokers: ['kafka://localhost:9092'],
      offset_commit_interval: 1,
      offset_commit_threshold: 1,
      heartbeat_interval: 1,
      session_timeout: 1,
      ssl_ca_cert: 'ca_cert',
      ssl_client_cert: 'client_cert',
      ssl_client_cert_key: 'client_cert_key',
      max_bytes_per_partition: 1_048_576,
      offset_retention_time: 1000,
      start_from_beginning: true,
      connect_timeout: 10,
      socket_timeout: 10,
      pause_timeout: 10,
      max_wait_time: 10,
      batch_fetching: true,
      topics: topics,
      min_bytes: 1
    }
  end

  context 'config is valid' do
    it { expect(schema.call(config)).to be_success }
  end

  it 'topics is an empty array' do
    config[:topics] = []
    expect(schema.call(config)).not_to be_success
  end

  it 'topics is not an array' do
    config[:topics] = nil
    expect(schema.call(config)).not_to be_success
  end

  context 'id validator' do
    it 'id is nil' do
      config[:id] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'id is not a string' do
      config[:id] = 2
      expect(schema.call(config)).not_to be_success
    end

    it 'id is an invalid string' do
      config[:id] = '%^&*('
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'seed_brokers validator' do
    it 'seed_brokers is nil' do
      config[:seed_brokers] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'seed_brokers is an empty array' do
      config[:seed_brokers] = []
      expect(schema.call(config)).not_to be_success
    end

    it 'seed_brokers is not an array' do
      config[:seed_brokers] = 'timeout'
      expect(schema.call(config)).not_to be_success
    end

    it 'when seed_broker does not have a proper uri schema' do
      config[:seed_brokers] = ['https://github.com/karafka:80']
      expect(schema.call(config)).not_to be_success
    end

    it 'when seed_broker does not have a port defined' do
      config[:seed_brokers] = ['kafka://github.com/karafka']
      expect(schema.call(config)).not_to be_success
    end

    it 'when seed_broker is not an uri' do
      config[:seed_brokers] = ['#$%^&*()']
      expect(schema.call(config)).not_to be_success
      expect { schema.call(config).errors }.not_to raise_error
    end
  end

  context 'session_timeout validator' do
    it 'session_timeout is nil' do
      config[:session_timeout] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'session_timeout is not integer' do
      config[:session_timeout] = 's'
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'offset_commit_interval validator' do
    it 'offset_commit_interval is nil' do
      config[:offset_commit_interval] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'offset_commit_interval is not integer' do
      config[:offset_commit_interval] = 's'
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'offset_commit_threshold validator' do
    it 'offset_commit_threshold is nil' do
      config[:offset_commit_threshold] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'offset_commit_threshold is not integer' do
      config[:offset_commit_threshold] = 's'
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'offset_retention_time validator' do
    it 'offset_retention_time is not integer' do
      config[:offset_retention_time] = 's'
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'heartbeat_interval validator' do
    it 'heartbeat_interval is nil' do
      config[:heartbeat_interval] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'heartbeat_interval is not integer' do
      config[:heartbeat_interval] = 's'
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'connect_timeout validator' do
    it 'connect_timeout is nil' do
      config[:connect_timeout] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'connect_timeout is not integer' do
      config[:connect_timeout] = 's'
      expect(schema.call(config)).not_to be_success
    end

    it 'connect_timeout is 0' do
      config[:connect_timeout] = 0
      expect(schema.call(config)).not_to be_success
    end

    it 'connect_timeout is less than 0' do
      config[:connect_timeout] = -1
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'socket_timeout validator' do
    it 'socket_timeout is nil' do
      config[:socket_timeout] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'socket_timeout is not integer' do
      config[:socket_timeout] = 's'
      expect(schema.call(config)).not_to be_success
    end

    it 'socket_timeout is 0' do
      config[:socket_timeout] = 0
      expect(schema.call(config)).not_to be_success
    end

    it 'socket_timeout is less than 0' do
      config[:socket_timeout] = -1
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'max_wait_time validator' do
    it 'max_wait_time is nil' do
      config[:max_wait_time] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'max_wait_time is not integer' do
      config[:max_wait_time] = 's'
      expect(schema.call(config)).not_to be_success
    end

    it 'max_wait_time is less than 0' do
      config[:max_wait_time] = -1
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'min_bytes validator' do
    it 'min_bytes is nil' do
      config[:min_bytes] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'min_bytes is not integer' do
      config[:min_bytes] = 's'
      expect(schema.call(config)).not_to be_success
    end

    it 'min_bytes is less than 1' do
      config[:min_bytes] = 0
      expect(schema.call(config)).not_to be_success
    end

    it 'min_bytes is a float' do
      config[:min_bytes] = rand(100) + 0.1
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'batch_fetching validator' do
    it 'batch_fetching is nil' do
      config[:batch_fetching] = nil
      expect(schema.call(config)).not_to be_success
    end

    it 'batch_fetching is not a bool' do
      config[:batch_fetching] = 2
      expect(schema.call(config)).not_to be_success
    end
  end

  context 'max_wait_time bigger than socket_timeout' do
    it 'expect to disallow' do
      config[:max_wait_time] = 2
      config[:socket_timeout] = 1
      expect(schema.call(config)).not_to be_success
    end
  end

  %i[
    ssl_ca_cert
    ssl_ca_cert_file_path
    ssl_client_cert
    ssl_client_cert_key
    sasl_plain_authzid
    sasl_plain_username
    sasl_plain_password
    sasl_gssapi_principal
    sasl_gssapi_keytab
  ].each do |encryption_attribute|
    context "#{encryption_attribute} validator" do
      it "#{encryption_attribute} is nil" do
        config[encryption_attribute] = nil
        expect(schema.call(config)).to be_success
      end

      it "#{encryption_attribute} is not a string" do
        config[encryption_attribute] = 2
        expect(schema.call(config)).not_to be_success
      end
    end
  end
end
