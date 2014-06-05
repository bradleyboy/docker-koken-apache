FROM ubuntu:14.04
MAINTAINER Brad Daily <brad@koken.me>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# FFMpeg PPA
RUN echo "deb http://ppa.launchpad.net/jon-severinsson/ffmpeg/ubuntu trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/jon-severinsson/ffmpeg/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1DB8ADC1CFCA9579

RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
RUN apt-get -y install supervisor mysql-server mysql-client apache2 libapache2-mod-php5 php5-mysql pwgen curl unzip

# Koken Requirements
RUN apt-get -y install php5-curl php5-imagick php5-mcrypt ffmpeg

# mysql config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# PHP config
RUN sed -i -e"s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /etc/php5/apache2/php.ini
RUN sed -i -e"s/post_max_size = 8M/post_max_size = 101M/" /etc/php5/apache2/php.ini

# Apache conf
ADD ./conf/apache/ports.conf /etc/apache2/ports.conf
ADD ./conf/apache/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite

# Supervisor Config
ADD ./conf/supervisord.conf /etc/supervisor/supervisord.conf

# Koken installer helpers
ADD ./php/index.php /index.php
ADD ./php/pclzip.lib.php /pclzip.lib.php
ADD ./php/database.php /database.php

# CRON
ADD ./shell/koken.sh /etc/cron.d/koken

# Initialization and Startup Script
ADD ./shell/start.sh /start.sh
RUN chmod 755 /start.sh

# private expose
EXPOSE 8080

# If SSH is needed
# RUN apt-get -y install openssh-server
# RUN mkdir -p /var/run/sshd
# EXPOSE 22

CMD ["/bin/bash", "/start.sh"]
