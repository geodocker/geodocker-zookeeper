BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := $(word 1, ${BASE})
REPO := $(word 2, ${BASE})
IMG  := quay.io/${ORG}/${REPO}
TAG  := latest

build:
	docker build -t ${IMG}:${TAG}	.

publish: build
	docker push ${IMG}:${TAG}
	@if [ "${TAG}" != "latest" ]; then docker tag ${IMG}:${TAG} ${IMG}:latest && docker push ${IMG}:latest; fi

test: build
	docker run -it --rm ${IMG}:${TAG} bash -c "zkServer.sh start; zkCli.sh stat /zookeeper"
