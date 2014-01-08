require 'spec_helper'
require 'active_support/core_ext/class/attribute'

describe OrderUp do
  before do
    OrderUp.config do |config|
      config.queue = OrderUp::Resque
    end
  end
  class TestJob
    class_attribute :worked
    attr_accessor :name

    def initialize(name)
      self.name = name
    end

    def run
      self.class.worked = name
    end
  end
  it "should do work in the background" do
    OrderUp.push TestJob.new('test message')
    TestJob.worked.should == 'test message'

  end
end
