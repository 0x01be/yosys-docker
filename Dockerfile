FROM 0x01be/base as build

ENV REVISION=master
WORKDIR /yosys
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
    bash &&\
    git clone --depth 1 --branch ${REVISION} https://github.com/YosysHQ/yosys.git /yosys &&\
    make
RUN PREFIX=/opt/yosys make install

FROM 0x01be/base

COPY --from=build /opt/yosys/ /opt/yosys/

RUN apk --no-cache add --virtual yosys-runtime-dependencies \
    python3 \
    tcl \
    graphviz \
    readline \
    libffi \
    zlib \
    libstdc++ &&\
    adduser -D -u 1000 yosys &&\
    chown yosys:yosys /workspace

USER yosys
WORKDIR /workspace
ENV PATH=${PATH}:/opt/yosys/bin/

