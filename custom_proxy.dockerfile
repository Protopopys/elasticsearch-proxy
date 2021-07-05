FROM golang:1.16.5-alpine3.14 AS builder
ENV REMOTE_SOURCE=${REMOTE_SOURCE:-.}

RUN apk add --no-cache --update make

WORKDIR  /go/src/github.com/openshift/elasticsearch-proxy
COPY ${REMOTE_SOURCE} .

RUN make

FROM alpine:3.14.0
COPY --from=builder /go/src/github.com/openshift/elasticsearch-proxy/bin/elasticsearch-proxy /usr/bin/
ENTRYPOINT ["/usr/bin/elasticsearch-proxy"]

LABEL \
        io.k8s.display-name="OpenShift ElasticSearch Proxy" \
        io.k8s.description="OpenShift ElasticSearch Proxy component of OpenShift Cluster Logging" \
        name="openshift/ose-elasticsearch-proxy" \
        com.redhat.component="ose-elasticsearch-proxy-container" \
        io.openshift.maintainer.product="OpenShift Container Platform" \
        io.openshift.maintainer.component="Logging"
