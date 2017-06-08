FROM nickbreen/cron:v1.0.0

MAINTAINER Narongdej Sarnsuwan <narongdej@sarnsuwan.com>

RUN apt-get -qqy update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qqy install mysql-client apache2-utils python-pip && \
  apt-get -qqy clean

RUN apt-get update
RUN apt-get install -y curl lsb-release

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN ls -l /etc/apt/sources.list.d
RUN cat /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y google-cloud-sdk

RUN mkdir -p /backup/data
RUN mkdir -p /app

ENV BUCKET="" DBS="" MYSQL_ROOT_PWD=""

ENV CRON_D_BACKUP="0 1,9,17    * * * root   /backup.sh | logger\n"

COPY backup.sh /

RUN chmod 777 /backup.sh