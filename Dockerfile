ARG SELENIUM_NODE_CHROME_VERSION=101.0.4951.41-chromedriver-101.0.4951.41-grid-4.1.4-20220427
FROM selenium/node-chrome:${SELENIUM_NODE_CHROME_VERSION}

LABEL maintainer="info@redmic.es"

USER root

ARG APT_TRANSPORT_HTTPS_VERSION=2.0.6 \
	BZIP2_VERSION=1.0.8-2 \
	CURL_VERSION=7.68.0-1ubuntu2.10 \
	GIT_VERSION=1:2.25.1-1ubuntu3.4 \
	NODEJS_SOURCE=18 \
	NODEJS_VERSION=18.0.0-deb-1nodesource1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	apt-cache madison \
		apt-transport-https \
		bzip2 \
		curl \
		git && \
	apt-get install -y --no-install-recommends \
		"apt-transport-https=${APT_TRANSPORT_HTTPS_VERSION}" \
		"bzip2=${BZIP2_VERSION}" \
		"curl=${CURL_VERSION}" \
		"git=${GIT_VERSION}" && \
	curl -fsSL "https://deb.nodesource.com/setup_${NODEJS_SOURCE}.x" | bash - && \
	apt-get update && \
	apt-cache madison \
		nodejs && \
	apt-get install -y --no-install-recommends \
		"nodejs=${NODEJS_VERSION}" && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG NPM_VERSION=8.8.0 \
	YARN_VERSION=1.22.18 \
	GRUNT_CLI_VERSION=1.4.3 \
	HOME_PATH=/redmic \
	ORIGINAL_UID=1200

SHELL ["/bin/sh", "-c"]
RUN mkdir -m 777 "${HOME_PATH}" && \
	npm install -g \
		"npm@${NPM_VERSION}" \
		"yarn@${YARN_VERSION}" \
		"grunt-cli@${GRUNT_CLI_VERSION}"

USER ${ORIGINAL_UID}

WORKDIR ${HOME_PATH}

ENV HOME=${HOME_PATH}

SHELL ["/bin/sh", "-c"]
RUN git config --global --add safe.directory *

ENTRYPOINT []
