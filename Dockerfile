ARG SELENIUM_NODE_CHROME_VERSION=90.0.4430.85-20210422
FROM selenium/node-chrome:${SELENIUM_NODE_CHROME_VERSION}

LABEL maintainer="info@redmic.es"

USER root

ARG APT_TRANSPORT_HTTPS_VERSION=2.0.5 \
	BZIP2_VERSION=1.0.8-2 \
	CURL_VERSION=7.68.0-1ubuntu2.5 \
	GIT_VERSION=1:2.25.1-1ubuntu3.1 \
	YARN_VERSION=1.22.5-1 \
	NODEJS_VERSION=12.22.1-deb-1nodesource1

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
	curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
	apt-get update && \
	apt-cache madison \
		yarn \
		nodejs && \
	apt-get install -y --no-install-recommends \
		"yarn=${YARN_VERSION}" \
		"nodejs=${NODEJS_VERSION}" && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG HOME_PATH=/redmic \
	ORIGINAL_UID=1200 \
	GRUNT_CLI_VERSION=1.4.2

SHELL ["/bin/sh", "-c"]
RUN mkdir -m 777 ${HOME_PATH} && \
	npm install -g "grunt-cli@${GRUNT_CLI_VERSION}"

USER ${ORIGINAL_UID}

WORKDIR ${HOME_PATH}

ENV HOME=${HOME_PATH}

ENTRYPOINT []
