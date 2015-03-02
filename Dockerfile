FROM ubuntu:trusty
MAINTAINER Exequiel Pierotto <exequiel.pierotto@gmail.com>

# Install sensu
RUN \
	apt-get update &&\
        apt-get install wget -y && \
	wget -qO - http://repos.sensuapp.org/apt/pubkey.gpg | apt-key add - && \
	echo "deb     http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y sensu

# Add the sensu-server config files
COPY files/server.json /etc/sensu/server.json
ADD files/conf.d /etc/sensu/conf.d/
ADD files/handlers /etc/sensu/handlers
ADD files/extensions /etc/sensu/extensions
ADD files/mutators /etc/sensu/mutators
ADD files/plugins /etc/sensu/plugins

# SSL sensu-server settings
ADD files/ssl /etc/sensu/ssl


RUN chgrp -R sensu /etc/sensu

# Sync with a local directory or a data volume container
#VOLUME /etc/sensu

CMD /opt/sensu/bin/sensu-server -d /etc/sensu/
