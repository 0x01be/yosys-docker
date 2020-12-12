FROM 00x01ne/base as build

RUN apk --no-cache add --virtual yosys-build-dependencies \
    git \
    build-base \
    python3-dev \
    clang \
    bison \
    flex \
    readline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    git \
    graphviz \
    pkgconfig \
    boost-filesystem \
    boost-dev \
    zlib-dev \
    bash

ENV YOSYS_REVISION master
RUN git clone --depth 1 --branch ${YOSYS_REVISION} https://github.com/YosysHQ/yosys.git /yosys

WORKDIR yosys

RUN make
RUN PREFIX=/opt/yosys make install

FROM alpine

COPY --from=build /opt/yosys/ /opt/yosys/

RUN apk --no-cache add --virtual yosys-runtime-dependencies \
    python3 \
    tcl \
    graphviz \
    readline \
    libffi \
    zlib \
    libstdc++

RUN adduser -D -u 1000 yosys

WORKDIR /workspace

RUN chown yosys:yosys /workspace

USER yosys

ENV PATH $PATH:/opt/yosys/bin/

