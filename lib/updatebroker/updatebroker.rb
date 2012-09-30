#
# (c) 2011 Sourdough Labs Research and Development Corp
#

require 'rubygems'
require 'em-hiredis'
require 'goliath'

class UpdateBroker < Goliath::API

  use Goliath::Rack::Params

  attr_accessor :redis

  def response(env)
    path = env[Goliath::Request::REQUEST_PATH]
    env.logger.info "Request for '#{path}'"
    return [404, {}, "Not found"] unless path == "/events"

    channel = env.params[:channel] || env.params['channel']
    env.logger.info "On channel '#{channel}'"
    return [404, {}, "Channel required"] if channel.nil? || channel == ""

    env.logger.info "Connecting to channel '#{channel}'@#{options[:redis]} for updates"

    env['redis'] = EM::Hiredis.connect(options[:redis])
    env['redis'].subscribe(channel)
    env['redis'].on(:message) do |chn, msg|
      env.logger.info "Message received from channel #{chn}: #{msg} (We're looking for #{channel})"
      if chn === channel
        res = env.stream_send("data:#{msg}\n\n")
      end
    end

    streaming_response(200, {'Content-Type' => 'text/event-stream'})
  end

  def on_close(env)
    path = env[Goliath::Request::REQUEST_PATH]
    return unless path === "/events"

    channel = env.params[:channel]
    return if channel.nil? || channel == ""

    env.logger.info "Connection closed, Unsubscribing."
    unless env['redis'].nil?
      env['redis'].unsubscribe(channel)
      env['redis'].quit
      env['redis'].close_connection
    end
  end

  def options_parser(opts, options)
    opts.on('-r', '--redis URI', "Redis URI") { |val| options[:redis] = val }
  end

end
