FROM alpine as builder

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

RUN git clone --depth 1 https://github.com/YosysHQ/yosys.git /yosys

WORKDIR yosys

RUN make
RUN PREFIX=/opt/yosys make install

FROM alpine

COPY --from=builder /opt/yosys/ /opt/yosys/

ENV PATH $PATH:/opt/yosys/bin/

