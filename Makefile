VERSION=$(shell git describe --tags --dirty --always)

.PHONY: build
build:
	sed -i '/specification:/,/version:/ s/version: .*/version: '"${VERSION}"'/' connector.yaml
	go build -o conduit-connector-s3 cmd/connector/main.go

.PHONY: test
test:
	go test $(GOTEST_FLAGS) -race ./...

.PHONY: lint
lint:
	golangci-lint run

.PHONY: generate
generate:
	go generate ./...

.PHONY: install-tools
install-tools:
	@echo Installing tools from tools.go
	@go list -e -f '{{ join .Imports "\n" }}' tools.go | xargs -I % go list -f "%@{{.Module.Version}}" % | xargs -tI % go install %
	@go mod tidy
