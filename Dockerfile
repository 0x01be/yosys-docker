FROM alpine:3.12.0 as builder

RUN apk --no-cache add \
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

RUN git clone https://github.com/YosysHQ/yosys.git /yosys

WORKDIR yosys

RUN make
RUN PREFIX=/opt/yosys make install

FROM alpine:3.12.0

COPY --from=builder /opt/yosys/ /opt/yosys/

ENV PATH $PATH:/opt/yosys/bin/

