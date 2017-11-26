NAME            := cmd-test
VERSION         := v0.0.1
REVISION        := $(shell git rev-parse --short HEAD)
OSARCH          := "darwin/amd64 linux/amd64"
PROJECTROOT			:= "./"

ifndef GOBIN
GOBIN := $(shell echo "$${GOPATH%%:*}/bin")
endif

LINT := $(GOBIN)/golint
GOX := $(GOBIN)/gox
ARCHIVER := $(GOBIN)/archiver
DEP := $(GOBIN)/dep
JUNITREPORT := $(JUNITREPORT)/dep

$(LINT): ; @go get github.com/golang/lint/golint
$(GOX): ; @go get github.com/mitchellh/gox
$(ARCHIVER): ; @go get github.com/mholt/archiver/cmd/archiver
$(DEP): ; @go get github.com/golang/dep/cmd/dep
$(JUNITREPORT): ; @go get github.com/jstemmer/go-junit-report

.DEFAULT_GOAL := build

.PHONY: deps
deps: $(DEP)
		dep ensure

.PHONY: build
build: deps
		go build -o bin/$(NAME) ${PROJECTROOT}

.PHONY: install
install: deps
		go install ${PROJECTROOT}

.PHONY: cross-build
cross-build: deps $(GOX)
		rm -rf ./out && \
 		gox -osarch $(OSARCH) -output "./out/${NAME}_${VERSION}_{{.OS}}_{{.Arch}}/{{.Dir}}" ${PROJECTROOT}

.PHONY: package
package: cross-build $(ARCHIVER)
		rm -rf ./pkg && mkdir ./pkg && \
		cd out && \
		find * -type d -exec archiver make ../pkg/{}.tar.gz {}/$(NAME) \; && \
		cd ../

.PHONY: lint
lint: $(LINT)
		@golint $(PROJECTROOT)/cmd/...

.PHONY: vet
vet:
		@go vet $(PROJECTROOT)/cmd/...

.PHONY: test
test: deps
		@go test -v $(PROJECTROOT)/cmd/...

.PHONY: test-junit
test-junit: deps $(JUNITREPORT)
		@go test -v $(PROJECTROOT)/cmd/... 2>&1 | go-junit-report > report.xml

.PHONY: check
check: lint vet test build

.PHONY: check-job
check-job: lint vet test-junit build
