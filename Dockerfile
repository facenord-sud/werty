FROM debian:jessie

ADD setup/ /usr/setup

WORKDIR /usr/setup

ENV http_proxy=http://172.17.0.2:3128 \
    https_proxy=http://172.17.0.2:3128 \
    ftp_proxy=http://172.17.0.2:3128

RUN ./live-build.sh

RUN http_proxy="" gpg --keyserver hkps.pool.sks-keyservers.net --recv-key C7988EA7A358D82E && gpg --export C7988EA7A358D82E | apt-key add -
#RUN dockerhost=`ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{ print $2 }'`
RUN  echo "Acquire::http { Proxy \"http://172.17.0.3:3142\"; };" >> /etc/apt/apt.conf.d/01proxy


RUN apt-get update

RUN apt-get -y install apt-utils

# Those are needed to build Tails
RUN apt-get -y install \
  dpkg-dev \
  eatmydata \
  gettext \
  intltool \
  libfile-slurp-perl \
  liblist-moreutils-perl \
  libyaml-libyaml-perl \
  libyaml-perl \
  libyaml-syck-perl \
  perlmagick \
  po4a \
  syslinux-utils \
  time \
  whois \
  ack-grep \
  man

# Be sure to get all the modules we need for our Ikiwiki
RUN apt-get install -y \
  debootstrap/jessie-backports \
  ikiwiki/jessie-backports

RUN apt-get install -y live-build/builder-jessie

# Add build script
RUN install -o root -g root -m 755 assets/build-tails /usr/local/bin

ENTRYPOINT /usr/bin/bash
