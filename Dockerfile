FROM ruby:2.3.6-alpine
MAINTAINER anton.osenenko@gmail.com

ENV LANG C.UTF-8
ENV TERM xterm-256color

RUN apk add --update --no-cache \
    bash \
    git \
    curl \
    build-base

WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install --deployment

ADD config.ru Rakefile /app/
ADD config /app/config
ADD maxminddb /app/maxminddb
ADD lib /app/lib

EXPOSE 3000
CMD bundle exec rackup --host 0.0.0.0 --port 3000
