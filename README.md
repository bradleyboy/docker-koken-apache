# docker-koken-apache

*This is a work in progress and used mostly for testing. We recommend using the official [Koken Docker image](https://github.com/koken/docker-koken-lemp) for production installs.*.

## Features

* Automatically sets up and configures the database for Koken and skips that step in the installation process.
* Adds a cron job to do periodic cleanup of the image cache.
* Apache/PHP configured for best Koken performance.
* Can be used on any machine with Docker installed.

## Usage

1. Install [Docker](https://www.docker.io/gettingstarted/#h_installation). Some hosts like Digital Ocean already have Docker available.
2. Start up a Koken container:

~~~bash
sudo docker run -p 80:8080 -d bradleyboy/docker-koken-apache
~~~

This forwards port 80 on your host machine to the instance of Koken running on port 8080 inside the container. You can now access your new Koken install by loading the IP address or domain name for your host in a browser.
