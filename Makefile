# configuration variables
USER = dakom
REPO = gae-launcher

build:
	docker build -t $(USER)/$(REPO) .

push: build
	docker push $(USER)/$(REPO)
