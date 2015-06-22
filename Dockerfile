FROM ubuntu:12.04
MAINTAINER Sicco van Sas <sicco@openstate.eu>

# Use bash as default shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Add multiverse to sources
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ precise multiverse' >> etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y \
        python-software-properties \
        openjdk-7-jre-headless \
        wget \
        curl \
        poppler-utils

RUN add-apt-repository -y ppa:rwky/redis > /dev/null \
    && apt-get update \
    && apt-get install -y redis-server

# Instructions from: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
RUN wget -qO - https://deb.nodesource.com/setup | bash -

# Instructions from: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

# Instructions from: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html
RUN wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/elasticsearch/0.90/debian stable main' | tee /etc/apt/sources.list.d/elasticsearch.list

# Set Dutch locale, needed to parse Dutch time data
RUN locale-gen nl_NL.UTF-8

#Set Timezone
RUN echo "Europe/Amsterdam" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# Install elasticsearch
# ENV ES_VERSION 1.4.2
# RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.deb
# RUN dpkg -i elasticsearch-${ES_VERSION}.deb > /dev/null
# RUN service elasticsearch start
# RUN rm elasticsearch-${ES_VERSION}.deb

# TODO: modify config file to disable zen discovery

RUN apt-get update

RUN apt-get install -y \
        make \
        libxml2-dev \
        libxslt1-dev \
        libssl-dev \
        libffi-dev \
        libtiff4-dev \
        libjpeg8-dev \
        liblcms2-dev \
        python-dev \
        python-setuptools \
        python-virtualenv \
        git \
        nodejs build-essential \
        mongodb-org \
        openjdk-6-jre elasticsearch \
        git imagemagick graphicsmagick postfix rubygems ruby-bundler

RUN easy_install pip

##########

WORKDIR /opt/popit
# Create a virtualenv project
RUN echo 'ok'
RUN virtualenv -q /opt
RUN echo "source /opt/bin/activate; cd /opt/popit;" >> ~/.bashrc

# Temporarily add all NPO Backstage files on the host to the container
# as it contains files needed to finish the base installation
ADD . /opt/popit

RUN bundle install
RUN COMPASS=/var/lib/gems/1.8/bin/compass make

RUN if [[ ! -f config/development.js ]]; then cp config/development.js-example config/development.js; fi
