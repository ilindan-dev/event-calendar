SERVICES := api auth-service calendar-service

.PHONY: install-tools lint test proto

install-tools:
	@echo "Installing dependencies..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/yoheimuta/protolint/cmd/protolint@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
	go install github.com/pressly/goose/v3/cmd/goose@latest
	@echo "checking protobuf compiler, if it fails follow guide at https://protobuf.dev/installation/"
	@command -v protoc >/dev/null 2>&1 && echo "protoc is installed" || (echo "ERROR: protoc is missing!" && exit 1)
	@echo "Tools installed successfully!"

protolint:
	protolint .

protobuf:
	protoc --go_out=. --go_opt=paths=source_relative \
               --go-grpc_out=. --go-grpc_opt=paths=source_relative \
               proto/auth/auth.proto
	protoc --go_out=. --go_opt=paths=source_relative \
               --go-grpc_out=. --go-grpc_opt=paths=source_relative \
               proto/calendar/calendar.proto

lint:
	@for dir in $(SERVICES); do \
		echo "Linting $$dir..."; \
		$(MAKE) -C $$dir lint || exit 1; \
	done

test:
	@for dir in $(SERVICES); do \
		echo "Testing $$dir..."; \
		$(MAKE) -C $$dir test || exit 1; \
	done

