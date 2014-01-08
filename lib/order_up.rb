require 'resque'
require 'active_support'
module OrderUp
  extend ActiveSupport::Autoload
  autoload :Resque
  def self.config
      @@config ||= Configuration.new
      yield @@config if block_given?
      return @@config
  end

  def self.push(val)
    instance.push(val)
  end

  private 
  def self.instance
    @@instance ||= config.queue.new('hydra')
  end

  class Configuration
    attr_writer :queue

    def queue
      @queue || OrderUp::Resque
    end
  end
end
