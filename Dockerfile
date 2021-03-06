FROM ubuntu:14.04
MAINTAINER Jeremy Hardin <jeremy@codingzen.net>

RUN apt-get update

# Install ruby dependencies
RUN apt-get install -yq wget curl \
    build-essential git git-core \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev

# Install ruby-install
RUN cd /tmp &&\
  wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz &&\
  tar -xzvf ruby-install-0.6.0.tar.gz &&\
  cd ruby-install-0.6.0/ &&\
  make install

# Install MRI Ruby 2.3.1
RUN ruby-install -M https://ftp.ruby-lang.org/pub/ruby ruby 2.3.1

# Add Ruby binaries to $PATH
ENV PATH /opt/rubies/ruby-2.3.1/bin:$PATH

# Add options to gemrc
RUN echo "gem: --no-document" > ~/.gemrc

# Install bundler
RUN gem install bundler

# Install nodejs
RUN apt-get install -qq -y nodejs

# Intall software-properties-common for add-apt-repository
RUN apt-get install -qq -y software-properties-common

# Install the latest postgresql lib for pg gem
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --force-yes libpq-dev
