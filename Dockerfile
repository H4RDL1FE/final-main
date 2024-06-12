# Используем официальный образ Golang как базовый
FROM golang:1.21 as build

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем go.mod и go.sum и устанавливаем зависимости
COPY go.mod ./
COPY go.sum ./
RUN go mod download

# Копируем исходный код в контейнер
COPY . .

# Сборка приложения
RUN go build -o main .

# Используем минимальный образ для запуска приложения
FROM gcr.io/distroless/base-debian10

# Копируем собранное приложение из предыдущего этапа
COPY --from=build /app/main /app/main

# Устанавливаем команду запуска по умолчанию
ENTRYPOINT ["/app/main"]
