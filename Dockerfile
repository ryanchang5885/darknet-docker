ARG BASE_IMAGE=nvidia/cuda:10.0-cudnn7-devel
FROM $BASE_IMAGE
LABEL maintainer="Ryan Chang <ryan.jy06@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

ARG ADDITIONAL_PACKAGES="libopencv-dev"

RUN apt-get update \
      && apt-get install --no-install-recommends --no-install-suggests -y gnupg2 ca-certificates \
            git build-essential $ADDITIONAL_PACKAGES \
      && rm -rf /var/lib/apt/lists/*

COPY configure.sh /tmp/

ARG SOURCE_BRANCH=HEAD
ENV SOURCE_BRANCH $SOURCE_BRANCH

ARG SOURCE_COMMIT=HEAD
ENV SOURCE_COMMIT $SOURCE_COMMIT

ARG CONFIG

RUN git clone https://github.com/ryanchang5885/darknet.git && cd darknet \
      && git checkout $SOURCE_BRANCH \
      && git reset --hard $SOURCE_COMMIT \
      && /tmp/configure.sh $CONFIG && make \
      && cp darknet /usr/local/bin \
      && cd .. && rm -rf darknet
