FROM docker:19.03.8
MAINTAINER docker@northscaler.com

LABEL version=0.2.2-rc.0

# Install node
ARG NODE_VERSION=12.18.2

COPY install-node.sh .
RUN ./install-node.sh
RUN rm install-node.sh

RUN npm install -g ymlx   # smoke test
&& ymlx --version

# Install helm

ENV HELM_VERSION=3.1.2
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

RUN apk add --update --no-cache curl ca-certificates
RUN curl -sSL ${BASE_URL}/${TAR_FILE} | tar xvz
RUN mv linux-amd64/helm /usr/bin/helm
RUN chmod +x /usr/bin/helm
RUN rm -rf linux-amd64
RUN apk del curl
RUN rm -f /var/cache/apk/*

RUN adduser -S -D -u 1001 -G root user
USER 1001
