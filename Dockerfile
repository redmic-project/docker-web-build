FROM selenium/node-chrome

LABEL maintainer="info@redmic.es"

USER root

ENV WORK_PATH=/opt/redmic \
	CACHE_PATH=/opt/cache

WORKDIR ${WORK_PATH}

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		apt-transport-https \
		bzip2 \
		curl \
		git

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
	curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		yarn \
		nodejs

RUN npm install -g grunt-cli && \
	yarn config set cache-folder ${CACHE_PATH}

ENTRYPOINT []
