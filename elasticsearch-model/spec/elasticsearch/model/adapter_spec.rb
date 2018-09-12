require 'spec_helper'

describe Elasticsearch::Model::Adapter do

  before(:all) do
    class ::DummyAdapterClass; end
    class ::DummyAdapterClassWithAdapter; end
    class ::DummyAdapter
      Records   = Module.new
      Callbacks = Module.new
      Importing = Module.new
    end
  end

  after(:all) do
    Elasticsearch::Model::Adapter::Adapter.adapters.delete(DummyAdapterClassWithAdapter)
    Elasticsearch::Model::Adapter::Adapter.adapters.delete(DummyAdapterClass)
    Elasticsearch::Model::Adapter::Adapter.adapters.delete(DummyAdapter)
    Object.send(:remove_const, :DummyAdapterClass) if defined?(DummyAdapterClass)
    Object.send(:remove_const, :DummyAdapterClassWithAdapter) if defined?(DummyAdapterClassWithAdapter)
    Object.send(:remove_const, :DummyAdapter) if defined?(DummyAdapter)
  end

  describe '#from_class' do

    it 'should return an Adapter instance' do
      expect(Elasticsearch::Model::Adapter.from_class(DummyAdapterClass)).to be_a(Elasticsearch::Model::Adapter::Adapter)
    end
  end

  describe 'register' do

    before do
      expect(Elasticsearch::Model::Adapter::Adapter).to receive(:register).and_call_original
      Elasticsearch::Model::Adapter.register(:foo, lambda { |c| false })
    end

    it 'should register an adapter' do
      expect(Elasticsearch::Model::Adapter::Adapter.adapters[:foo]).to be_a(Proc)
    end

    context 'when a specific adapter class is set' do

      before do
        expect(Elasticsearch::Model::Adapter::Adapter).to receive(:register).and_call_original
        Elasticsearch::Model::Adapter::Adapter.register(DummyAdapter,
                                                        lambda { |c| c == DummyAdapterClassWithAdapter })
      end

      let(:adapter) do
        Elasticsearch::Model::Adapter::Adapter.new(DummyAdapterClassWithAdapter)
      end

      it 'should register the adapter' do
        expect(adapter.adapter).to eq(DummyAdapter)
      end
    end
  end

  describe 'default adapter' do

    let(:adapter) do
      Elasticsearch::Model::Adapter::Adapter.new(DummyAdapterClass)
    end

    it 'sets a default adapter' do
      expect(adapter.adapter).to eq(Elasticsearch::Model::Adapter::Default)
    end
  end

  describe '#records_mixin' do

    before do
      Elasticsearch::Model::Adapter::Adapter.register(DummyAdapter,
                                                      lambda { |c| c == DummyAdapterClassWithAdapter })

    end

    let(:adapter) do
      Elasticsearch::Model::Adapter::Adapter.new(DummyAdapterClassWithAdapter)
    end

    it 'returns a Module' do
      expect(adapter.records_mixin).to be_a(Module)
    end
  end

  describe '#callbacks_mixin' do

    before do
      Elasticsearch::Model::Adapter::Adapter.register(DummyAdapter,
                                                      lambda { |c| c == DummyAdapterClassWithAdapter })

    end

    let(:adapter) do
      Elasticsearch::Model::Adapter::Adapter.new(DummyAdapterClassWithAdapter)
    end

    it 'returns a Module' do
      expect(adapter.callbacks_mixin).to be_a(Module)
    end
  end

  describe '#importing_mixin' do

    before do
      Elasticsearch::Model::Adapter::Adapter.register(DummyAdapter,
                                                      lambda { |c| c == DummyAdapterClassWithAdapter })

    end

    let(:adapter) do
      Elasticsearch::Model::Adapter::Adapter.new(DummyAdapterClassWithAdapter)
    end

    it 'returns a Module' do
      expect(adapter.importing_mixin).to be_a(Module)
    end
  end
end
