GOFMT_FILES?=$$(find . -name '*.go' | grep -v vendor)
OUTPUT ?= bin/darwin/amd64/dockerfilepp-labels

all: build

tools:
	go get -u github.com/golang/lint/golint
	go get -u github.com/kisielk/errcheck

deps:
	glide up

check:
	errcheck


dirs:
	mkdir -p releases
	mkdir -p bin/linux/amd64
	mkdir -p bin/windows/amd64
	mkdir -p bin/darwin/amd64

build_deps: deps dirs

build: darwin linux windows

darwin: build_deps
	go build -v -o $(CURDIR)/${OUTPUT}
	tar -cvzf releases/dockerfilepp-labels-darwin-amd64.tar.gz bin/darwin/amd64/dockerfilepp-labels

linux: build_deps
	env GOOS=linux GOAARCH=amd64 go build -v -o $(CURDIR)/bin/linux/amd64/dockerfilepp-labels
	tar -cvzf releases/dockerfilepp-labels-linux-amd64.tar.gz bin/linux/amd64/dockerfilepp-labels

windows: build_deps
	env GOOS=windows GOAARCH=amd64 go build -v -o $(CURDIR)/bin/windows/amd64/dockerfilepp-labels
	tar -cvzf releases/dockerfilepp-labels-windows-amd64.tar.gz bin/windows/amd64/dockerfilepp-labels

example: darwin
	cat example/Dockerfile | ./${OUTPUT}

diff: darwin
	cat example/Dockerfile | ./${OUTPUT} > Dockerfile.result
	-colordiff -y example/Dockerfile Dockerfile.result
	rm Dockerfile.result

lint:
	golint main.go

test:
	go test

cover:
	go test -coverprofile=coverage.out
	go tool cover -html=coverage.out
	rm coverage.out

clean:
	rm -fr releases bin

fmt:
	gofmt -w $(GOFMT_FILES)
