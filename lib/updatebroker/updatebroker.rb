#
# (c) 2011, 2012 Sourdough Labs Research and Development Corp
#

require 'rubygems'
require 'em-hiredis'
require 'goliath'

class UpdateBroker < Goliath::API

  use Goliath::Rack::Params

  attr_accessor :redis

  def initialize(opts = {})
    @channels = {}
  end

  def add_channel_handler(channel, handler)
    handlers = @channels[channel] || []
    handlers << handler
    @channels[channel] = handlers
  end

  # Don't call unless add_channel_stream has been called at least once for the given channel
  def remove_channel_handler(channel, handler)
    handlers = @channels[channel]
    handlers.delete(handler) unless handlers.nil?
  end

  def send_message_to_handlers(channel, msg)   
    handlers = @channels[channel]
    unless handlers.nil?
      handlers.each do |e|
        res = e.stream_send("data:#{msg}\n\n")
      end
    end
  end

  def response(env)
    path = env[Goliath::Request::REQUEST_PATH]
    return [404, {}, "Not found"] unless path == "/events"

    channel = env.params[:channel] || env.params['channel']
    return [404, {}, "Channel required"] if channel.nil? || channel == ""

    if self.redis.nil?
      env.logger.info "Redis connection is down, Connecting to @#{options[:redis]}"
      self.redis = EM::Hiredis.connect(options[:redis]) 
      redis.on(:message) do |chn, msg|
        env.logger.info "Message for channel '#{chn}':"        
        send_message_to_handlers(chn,msg) 
      end
    end

    env.logger.info "subscribing to channel '#{channel}' for updates"
    redis.subscribe(channel)
    add_channel_handler(channel, env)

    streaming_response(200, {'Content-Type' => 'text/event-stream'})
  end

  def on_close(env)
    path = env[Goliath::Request::REQUEST_PATH]
    return unless path === "/events"

    channel = env.params[:channel]
    return if channel.nil? || channel == ""

    env.logger.info "Connection closed, Unsubscribing."
    redis.unsubscribe(channel)
    remove_channel_handler(channel, env)
  end

  def options_parser(opts, options)
    opts.on('-r', '--redis URI', "Redis URI") { |val| options[:redis] = val }
  end

end
