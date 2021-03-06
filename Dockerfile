FROM ubuntu:18.04

MAINTAINER rizaudo <rizaudo@users.noreply.github.com>

#ARG BUILD_DATE
#ARG VCS_REF
#ARG VERSION
LABEL org.label-schema.name="chisel3-docker" \
#      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.description="Container for run chisel3 CI/CD(with verilator support)." \
      org.label-schema.url="https://github.com/rizaudo/chisel3-docker" \
#      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/rizaudo/chisel3-docker" \
      org.label-schema.vendor="rizaudo" \
#      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"


ENV VERILATOR_DEPS \
    autoconf \
    bc \
    bison \
    build-essential \
    ca-certificates \
    flex \
    git \
    libfl-dev \
    perl \
    python3

ENV SBT_DEPS \
    openjdk-11-jdk \
    sbt 

RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg ca-certificates wget && \
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add -

RUN apt-get update && \
    apt-get install -y --no-install-recommends $VERILATOR_DEPS && \
    apt-get install -y --no-install-recommends $SBT_DEPS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Specify verilator version
ARG REPO=https://github.com/verilator/verilator
ARG SOURCE_CHECKOUT=stable

WORKDIR /tmp

RUN git clone "${REPO}" verilator && \
    cd verilator && \
    git checkout "${SOURCE_CHECKOUT}" && \
    autoconf && \
    ./configure && \
    make -j "$(nproc)" && \
    make install && \
    cd .. && rm -r verilator

VOLUME ["/chisel"]
WORKDIR /chisel
