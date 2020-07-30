FROM registry.access.redhat.com/ubi7 as build

MAINTAINER Alex Osadchyy

WORKDIR /workspace

#ENV ARCH=`arch`
# Install dependencies
RUN yum install -y git lksctp-tools lksctp-tools-devel autoconf automake binutils gcc gcc-c++ gdb glibc-devel libtool make pkgconf &&\
    export ARCH=`arch` && echo -e "\n Architecture: ${ARCH} \n"
RUN git clone https://github.com/sctp/lksctp-tools.git && cp ./lksctp-tools/src/include/netinet/sctp.h.in /usr/include/netinet/sctp.h

# Pull uperf source code
RUN git clone https://github.com/uperf/uperf.git
# Build uperf binary
RUN cd uperf && chmod a+x ./configure && ./configure --disable-dependency-tracking && make && chmod a+x ./src/uperf


FROM registry.access.redhat.com/ubi7/ubi
#FROM clefos:7

WORKDIR /app

ARG DEPENDENCY=/workspace/uperf/src
COPY --from=build ${DEPENDENCY}/uperf /app
COPY perf_conf.xml /app

RUN chmod -R a+w /app
RUN yum install -y https://download.sinenomine.net/epel/epel-7/noarch/epel-release-7-12.noarch.rpm
RUN yum install -y bind-utils net-tools nmap iputils tcpdump whois
EXPOSE 5201/tcp 5001/udp

# usage: 
#   server#>uperf -s 
#   client#>uperf -m perf_conf.xml -a -i 30; sleep 3600

CMD ["./uperf"]
