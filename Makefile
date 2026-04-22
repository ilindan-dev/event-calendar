SERVICES := api auth-service calendar-service

.PHONY: install-tools lint test proto

install-tools:
	@echo "Installing dependencies..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
	go install github.com/pressly/goose/v3/cmd/goose@latest
	@echo "Tools installed successfully!"
	@echo "Note: golangci-lint v2 should be installed manually or via your package manager."

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