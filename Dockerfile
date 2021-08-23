FROM golang:1 AS builder

RUN mkdir -p /tmp/gopath/

ENV GOPATH /tmp/gopath/

RUN go install github.com/bazelbuild/bazelisk@latest

FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y \
  git \
  python \
  python-pip \
  python3 \
  python3-pip \
  curl \
  build-essential \
  g++ \
  zip \
  unzip \
  openjdk-11-jdk-headless \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/

RUN mkdir -p /usr/local/bin

COPY --from=builder /tmp/gopath/bin/bazelisk /usr/local/bin/bazelisk

RUN ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel

# This both verifies that bazel is in $PATH,
# and also caches the latest bazel release at the time of docker build.
RUN bazel version

RUN mkdir -p /opt

WORKDIR /opt/
