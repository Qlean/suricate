require 'jaeger/client'

OpenTracing.global_tracer = Jaeger::Client.build(
  service_name: Rails.application.class.parent_name,
  host: 'tracing-jaeger-0.staging.node.dc3.consul',
  port: 6831)
