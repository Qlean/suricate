class Suricate < Sinatra::Base

require 'jaeger/client'
require 'opentracing'

OpenTracing.global_tracer = Jaeger::Client.build(
  # service_name: Rails.application.class.parent_name,
  service_name: 'suricate',
  host: 'tracing-jaeger-0.staging.node.dc3.consul',
  port: 6831)

  helpers Sinatra::Param

  helpers do
    def ip_regexp
      block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
      /\A#{block}\.#{block}\.#{block}\.#{block}\z/
    end
  end

  get '/lookup' do
    param :ip, String, required: true, format: ip_regexp
    param :language, String, in: %w(en ru), default: 'ru'

    OpenTracing.inject(OpenTracing.active_span.context, OpenTracing::FORMAT_RACK, {} )
    ret = self.class.db.lookup(params[:ip])
    halt 404 unless ret.found?
    halt 404 if ret.country.name.nil? || ret.city.name.nil?

    result = {
      country: ret.country.name(params[:language]),
      city:    ret.city.name(params[:language]),
      latitude: ret.location.latitude,
      longitude: ret.location.longitude,
      time_zone: ret.location.time_zone
    }
    content_type 'application/json; charset=utf-8'
    halt 200, JSON.dump(result)
  end

  get '/health' do
    halt 200 unless self.class.db.lookup('8.8.8.8').country.name.nil?
    halt 400
  end

  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), %w(..)))
  end

  def self.db
    @db ||= MaxMindDB.new(File.join(root, %w(maxminddb GeoLite2-City.mmdb)))
  end
end
