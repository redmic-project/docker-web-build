ARG SELENIUM_NODE_CHROME_VERSION=3.12.0-boron
FROM selenium/node-chrome:${SELENIUM_NODE_CHROME_VERSION}

LABEL maintainer="info@redmic.es"

USER root

ARG APT_TRANSPORT_HTTPS_VERSION=1.2.32ubuntu0.2 \
	BZIP2_VERSION=1.0.6-8ubuntu0.2 \
	CURL_VERSION=7.47.0-1ubuntu2.18 \
	GIT_VERSION=1:2.7.4-0ubuntu1.9 \
	YARN_VERSION=1.22.5-1 \
	NODEJS_VERSION=9.11.2-1nodesource1 \
	GRUNT_CLI_VERSION=1.3.2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		"apt-transport-https=${APT_TRANSPORT_HTTPS_VERSION}" \
		"bzip2=${BZIP2_VERSION}" \
		"curl=${CURL_VERSION}" \
		"git=${GIT_VERSION}" && \
	curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		"yarn=${YARN_VERSION}" \
		"nodejs=${NODEJS_VERSION}" && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG HOME_PATH=/redmic \
	ORIGINAL_UID=1200

SHELL ["/bin/sh", "-c"]
RUN mkdir -m 777 ${HOME_PATH} && \
	npm install -g "grunt-cli@${GRUNT_CLI_VERSION}"

USER ${ORIGINAL_UID}

WORKDIR ${HOME_PATH}

ENV HOME=${HOME_PATH}

ENTRYPOINT []
