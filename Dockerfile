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

# Apache foreground script (used by supervisor)
ADD ./shell/apache-foreground.sh /etc/apache2/foreground.sh
RUN chmod 755 /etc/apache2/foreground.sh

# Supervisor Config
ADD ./conf/supervisord.conf /etc/supervisor/supervisord.conf

# Koken installer helpers
ADD ./php/index.php /installer.php
ADD ./php/pclzip.lib.php /pclzip.lib.php
ADD ./php/database.php /database.php

# CRON
ADD ./shell/koken.sh /etc/cron.d/koken

# Initialization and Startup Script
ADD ./shell/start.sh /start.sh
RUN chmod 755 /start.sh

# private expose
EXPOSE 8888

# If SSH is needed
# RUN apt-get -y install openssh-server
# RUN mkdir -p /var/run/sshd
# EXPOSE 22

CMD ["/bin/bash", "/start.sh"]
