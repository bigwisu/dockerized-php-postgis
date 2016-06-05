FROM ubuntu:12.04.5
MAINTAINER Wisu Suntoyo <wisu@devel.web.id>

# Install apache, PHP, and supplimentary programs.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install \
	supervisor \
    apache2 \
	curl \
	wget \
	php5-curl \
	php5-fpm \
	php5-gd \
	php5-memcached \
	php5-memcache \
	php5-pgsql \
	php5-mcrypt \
	php5-sqlite \
	php5-xdebug \
	php-apc \
	libapache2-mod-php5 \
	tcpdump 

# Enable apache mods.
RUN a2enmod rewrite

# Prevent PHP Warning: 'xdebug' already loaded.
# XDebug loaded with the core
# RUN sed -i '/.*xdebug.so$/s/^/;/' /etc/php5/mods-available/xdebug.ini

# Add configuration files
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/conf.d/custom.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# remove default vhost
RUN rm -rf /etc/apache2/sites-enabled/*

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND