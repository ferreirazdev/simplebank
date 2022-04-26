postgres:
	docker run --name postgres12 -p 25432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

execdb:
	docker start postgres12

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:25432/simple_bank?sslmode=disable" -verbose up
	
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:25432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/ferreirazdev/simplebank/db/sqlc Store

.PHONY: postgres createdb execdb dropdb migrateup migratedown sqlc test server mock