FROM alpine:3.4

MAINTAINER Thonatos.Yang <thonatos.yang@gmail.com>
LABEL vendor=implements.io
LABEL io.implements.version=0.1.0

# Build config
ENV GOPATH /usr/local
ENV DRONE_PATH github.com/drone/drone
ENV DRONE_REPO git://github.com/drone/drone.git
ENV DRONE_BRANCH master
ENV GO15VENDOREXPERIMENT=1

# Run config
ENV DATABASE_DRIVER=sqlite3
ENV DATABASE_PATH = /var/lib/drone
ENV DATABASE_CONFIG=$DATABASE_PATH/drone.sqlite
ENV GODEBUG=netdns=go

# Compile
RUN apk update \
    && apk add build-base git go \   
    && mkdir -p $DATABASE_PATH \
    && git clone $DRONE_REPO $GOPATH/src/$DRONE_PATH \
    && cd $GOPATH/src/$DRONE_PATH \
    && make deps \
    && make gen \
    && make build \
    && cp release/drone /drone

# Clean
RUN apk del build-base git \
    && rm -rf /usr/include /usr/share/man /tmp/* /var/cache/apk/* /root/build/     
    
EXPOSE 8000

ENTRYPOINT ["/drone"]
CMD ["server"]    
