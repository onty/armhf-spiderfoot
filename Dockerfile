#
# Spiderfoot Dockerfile 
#
# http://www.spiderfoot.net
#
# Written by: Michael Pellon <m@pellon.io>
#
# Usage:
#
#   sudo docker build -t spiderfoot .
#   sudo docker run -it -p 8080:8080 spiderfoot
# 
# @Lintang Jati 
# 	Build adapted and executed on arm64 machine (pine64)
# 
# 
# Pull the base image.
FROM arm32v6/alpine:latest

# Install pre-requisites.
RUN apk update && apk add \
  g++ \
  make \
  curl \
  git \ 
  python2 \
  libressl-dev \
  libxml2-dev \
  libxslt-dev \
  py2-pip  \
  python2-dev \
  py2-setuptools \
  py2-lxml \
  py2-crypto \
  py2-requests \
  swig 

RUN pip install cherrypy lxml mako netaddr

# Create a dedicated/non-privileged user to run the app.
RUN addgroup spiderfoot && \
    adduser -D -G spiderfoot -h /home/spiderfoot -s /sbin/nologin -g "SpiderFoot User" spiderfoot

ENV SPIDERFOOT_VERSION 2.10

# Download the specified release.
WORKDIR /home
RUN curl -sSL https://github.com/smicallef/spiderfoot/archive/v$SPIDERFOOT_VERSION-final.tar.gz \
  | tar -v -C /home -xz \
  && mv /home/spiderfoot-$SPIDERFOOT_VERSION-final /home/spiderfoot \
  && chown -R spiderfoot:spiderfoot /home/spiderfoot

USER spiderfoot
WORKDIR /home/spiderfoot

EXPOSE 8080

# Run the application.
ENTRYPOINT ["/usr/bin/python"] 
CMD ["sf.py", "0.0.0.0:8080"]
