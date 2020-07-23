FROM registry.redhat.io/ubi8/ubi as build

MAINTAINER Alex Osadchyy

WORKDIR /workspace

# Install dependencies
RUN yum install -y git lksctp-tools lksctp-tools-devel
# Pull uperf source code
RUN git clone https://github.com/uperf/uperf.git && cd uperf
# Build uperf binary
RUN ./configure && make && make install


FROM registry.redhat.io/ubi8/ubi-minimal
RUN groupadd uperf && useradd -g uperf uperf
VOLUME /tmp
USER uperf
ARG DEPENDENCY=/workspace/uperf
COPY --from=build ${DEPENDENCY}/uperf /
COPY perf_conf.xml /

EXPOSE 5201/tcp 5001/udp

# usage: 
#   server#>uperf -s 
#   client#>uperf -m perf_conf.xml -a -i 30; sleep 3600

CMD ["uperf"]
