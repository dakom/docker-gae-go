FROM debian:jessie
MAINTAINER David Komer <david.komer@gmail.com>

RUN apt-get update && apt-get install -y \
	gcc \
	python \
	curl \
	unzip

ENV GAE_VERSION "1.9.40"

# Google App Engine SDK
RUN curl https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-${GAE_VERSION}.zip > /appengine.zip
RUN unzip -q /appengine.zip -d /appengine

# update the appserver config to allow fast rebuilds
COPY go_application.py /appengine/go_appengine/google/appengine/tools/devappserver2/go_application.py

# configure the SDK to not check for updates
RUN printf 'opt_in: false\ntimestamp: 0.0\n' > ~/.appcfg_nag
# configure the PATH to make the SDK tools available
ENV PATH $PATH:/appengine/go_appengine

ENV GO_VERSION "1.6.2"

RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz
ENV PATH $PATH:/usr/local/go/bin

# configure GOPATH
RUN mkdir -p /go
ENV GOPATH /go

# Start commands
WORKDIR "/go"
VOLUME ["/go"]
EXPOSE 8000 8080-8090

# ENTRYPOINT ["dev_appserver.py"]
