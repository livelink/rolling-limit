require 'spec_helper'

describe Rolling::Limit do
  it 'has a version number' do
    expect(Rolling::Limit::VERSION).not_to be nil
  end

  let(:redis_config) do
    config = {}
    config[:host] = ENV['REDIS_HOST'] if ENV['REDIS_HOST']
    config
  end
  let(:redis) { Redis.new(redis_config) }
  let(:subject) do
   described_class.new(redis: redis,
                       key: 'test-rate-limit',
                       max_operations: 3,
                       timespan: 5)
  end

  before do
    redis.del('rlmt:test-rate-limit')
  end

  after do
    redis.del('rlmt:test-rate-limit')
  end

  describe '#remaining' do
    context 'with no previous use' do
      it 'should return the number of remaining tries' do
        expect(subject.remaining).to eql(2)
      end
    end

    context 'with some previous use' do
      it 'should return the number of remaining tries' do
        2.times { subject.remaining }

        expect(subject.remaining).to eql(0)
      end
    end

    context 'with previous use' do
      it 'should return false' do
        3.times { subject.remaining }

        expect(subject.remaining).to be(false)
      end
    end

    context 'after expiry' do
      it 'should auto reset' do
        3.times { subject.remaining }
        expect(subject.remaining).to be(false)
        sleep 5.5
        expect(subject.remaining?).to be_truthy
      end
    end
  end

  describe '#remaining?' do
    context 'in normal use' do
      it 'should return true without changing remaining quota' do
        3.times { subject.remaining? }

        expect(subject.remaining?).to be_truthy
      end
    end
  end


  describe '#reset!' do
    context 'in normal use' do
      it 'should reset the rate limiter' do
        3.times { subject.remaining }
        expect(subject.remaining?).to be(false)
        subject.reset!
        expect(subject.remaining?).to be_truthy
      end
    end
  end

end
