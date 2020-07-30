FROM x11docker/lxde

MAINTAINER Admatic Engineering Team@ADMATIC.IN
ENV DEBIAN_FRONTEND=noninteractive

# Default jdk

ENV VERSION 8
ENV UPDATE 111
ENV BUILD 14
ENV LANG zh_CN.UTF-8  
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

# update apt ali source
#ADD sources.list /etc/apt/
RUN  sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && sed -i s@/security.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get clean

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y \
  gcc git openssh-client less curl ca-certificates zip unzip \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  lib32stdc++6 libmagic1 libpulse0 \
  libglu1-mesa libgl1-mesa-dri mesa-utils libpci3 pciutils usbutils file \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen zh_CN && locale-gen zh_CN.utf8 && apt-get install -y ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy

# 32-bit dependencies of android and utils
# Download and unzip Android Studio for Linux
#COPY android-studio-ide-193.6626763-linux.zip /opt/android-studio.zip
#RUN cd /opt/ && unzip android-studio.zip
#CMD /opt/android-studio/bin/studio.sh


ENV JAVA_HOME /usr/lib/jvm/java-${VERSION}-oracle
ENV JRE_HOME ${JAVA_HOME}/bin

COPY jdk-14.0.2_linux-x64_bin.tar.gz /tmp

RUN cd /tmp && tar -zxvf jdk-14.0.2_linux-x64_bin.tar.gz && \
    mkdir -p "${JAVA_HOME}" && mkdir -p "${JRE_HOME}" && mv /tmp/jdk-14.0.2/* "${JAVA_HOME}" && \
    rm -rf /tmp/*

RUN update-alternatives --install "/usr/bin/java" "java" "${JRE_HOME}/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
    update-alternatives --set java "${JRE_HOME}/java" && \
    update-alternatives --set javac "${JAVA_HOME}/bin/javac"

