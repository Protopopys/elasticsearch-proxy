FROM golang:1.17.4-buster AS builder
ENV REMOTE_SOURCE=${REMOTE_SOURCE:-.}

RUN apt-get install --no-install-recommends -y  \
        make

WORKDIR  /go/src/github.com/openshift/elasticsearch-proxy
COPY ${REMOTE_SOURCE} .

RUN make

FROM redhat/ubi8-micro:8.5-437
COPY --from=builder /go/src/github.com/openshift/elasticsearch-proxy/bin/elasticsearch-proxy /usr/bin/
ENTRYPOINT ["/usr/bin/elasticsearch-proxy"]

LABEL \
        io.k8s.display-name="OpenShift ElasticSearch Proxy" \
        io.k8s.description="OpenShift ElasticSearch Proxy component of OpenShift Cluster Logging" \
        io.openshift.tags="openshift,logging,elasticsearch" \
        License="Apache-2.0" \
        maintainer="AOS Logging <aos-logging@redhat.com>" \
        name="openshift-logging/elasticsearch-proxy-rhel8" \
        com.redhat.component="elasticsearch-proxy-container" \
        io.openshift.maintainer.product="OpenShift Container Platform" \
        io.openshift.maintainer.component="Logging"
