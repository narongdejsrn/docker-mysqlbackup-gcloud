FROM phusion/baseimage:latest

MAINTAINER Narongdej Sarnsuwan <narongdej@sarnsuwan.com>

ENV TZ Asia/Bangkok

RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

ADD crontab /etc/cron.d/BACKUP
RUN chmod 0644 /etc/cron.d/BACKUP
RUN touch /var/log/cron.log

RUN apt-get -qqy update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qqy install rsyslog curl lsb-release cron mysql-client apache2-utils python-pip && \
  apt-get -qqy clean

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN ls -l /etc/apt/sources.list.d
RUN cat /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y google-cloud-sdk

RUN mkdir -p /backup/data
RUN mkdir -p /app

ADD start-cron.sh /usr/bin/start-cron.sh
RUN chmod +x /usr/bin/start-cron.sh

ENV BUCKET="" DBS="" MYSQL_ROOT_PWD=""

COPY backup.sh /

RUN chmod 777 /backup.sh

CMD /sbin/my_init
