FROM ruby:2.3.1-alpine
MAINTAINER Code Climate <hello@codeclimate.com>

RUN apk --update add curl git build-base autoconf automake libtool ruby-dev ruby-bundler snappy openjdk8 && \
  rm -fr /usr/share/ri

ENV KAFKA_SRC=http://apache.cs.utah.edu/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz
ENV KAFKA_PATH=/usr/src/kafka

RUN curl "$KAFKA_SRC" | tar xvzf - && mv kafka_* "$KAFKA_PATH"

WORKDIR /usr/src/poseidon/

COPY .git/ /usr/src/poseidon/
COPY Gemfile* /usr/src/poseidon/
COPY poseidon.gemspec /usr/src/poseidon/
COPY lib/poseidon/version.rb /usr/src/poseidon/lib/poseidon/

RUN bundle install -j 4

COPY . /usr/src/poseidon/
