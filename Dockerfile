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

COPY Gemfile Gemfile.lock /app/

RUN bundle install --deployment

COPY maxminddb /app/maxminddb

COPY crontab /etc/crontabs/root

COPY entrypoint.sh /docker-entrypoint.sh
COPY crontab config.ru Rakefile update_db.sh /app/
COPY config /app/config
COPY lib /app/lib

EXPOSE 3000
ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD bundle exec rerun --dir /app/maxminddb --background  --pattern  "**/*.mmdb" "rackup --host 0.0.0.0 --port 3000"
