.PHONY: lint test run

lint:
	golangci-lint run -c .golangci.yaml

test:
	go test -v -race ./...

run:
	go run cmd/app/main.go