ARG SELENIUM_NODE_CHROME_VERSION
FROM selenium/node-chrome:${SELENIUM_NODE_CHROME_VERSION}

LABEL maintainer="info@redmic.es"

ENTRYPOINT []

USER root

ARG APT_TRANSPORT_HTTPS_VERSION \
	BZIP2_VERSION \
	CURL_VERSION \
	GIT_VERSION \
	NODEJS_SOURCE \
	NODEJS_VERSION

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

ARG NPM_VERSION \
	GRUNT_CLI_VERSION \
	HOME_PATH \
	ORIGINAL_UID

SHELL ["/bin/sh", "-c"]
RUN mkdir -m 777 "${HOME_PATH}" && \
	npm install -g \
		"npm@${NPM_VERSION}" \
		"grunt-cli@${GRUNT_CLI_VERSION}"

USER ${ORIGINAL_UID}

WORKDIR ${HOME_PATH}

ENV HOME=${HOME_PATH}

SHELL ["/bin/sh", "-c"]
RUN git config --global --add safe.directory "*" && \
	git config --global url."https://".insteadOf ssh://
