.PHONY: deps fmt test

IMPORT_BASE := github.com/alphagov
IMPORT_PATH := $(IMPORT_BASE)/performanceplatform-client.go
VENDOR_DIR := _vendor

all: deps _vendor fmt test

deps:
	go get github.com/mattn/gom
	go get github.com/onsi/ginkgo/ginkgo
	go get golang.org/x/tools/cmd/cover

fmt:
	gofmt -w=1 *.go

test:
	GO15VENDOREXPERIMENT=0 gom exec ginkgo -cover .
	# rewrite the generated .coverprofile files so that you can run the command
	# gom tool cover -html=./pkg/handlers/handlers.coverprofile and other lovely stuff
	find . -name '*.coverprofile' -type f -exec sed -i '' 's|_'$(CURDIR)'|\.|' {} \;

clean:
	rm -rf $(VENDOR_DIR)

_vendor: Gomfile _vendor/src/$(IMPORT_PATH)
	GO15VENDOREXPERIMENT=0 gom -test install
	touch $(VENDOR_DIR)

_vendor/src/$(IMPORT_PATH):
	rm -f $(VENDOR_DIR)/src/$(IMPORT_PATH)
	mkdir -p $(VENDOR_DIR)/src/$(IMPORT_BASE)
	ln -s $(CURDIR) $(VENDOR_DIR)/src/$(IMPORT_PATH)
