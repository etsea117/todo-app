FROM rust:1.61 as builder
RUN USER=root

RUN mkdir todo-app
WORKDIR /todo-app
ADD . ./
RUN cargo clean && cargo build --release

FROM debian:bullseye
ARG APP=/user/src/app
RUN mkdir -p {$APP}

# Copy the compiiled binaries into the new container.
COPY --from=builder /todo-app/target/release/todo-app ${APP}/todo-app
COPY --from=builder /todo-app/Rocket.toml ${APP}/Rocket.toml

WORKDIR ${APP}

EXPOSE 8000

CMD ["./todo-app"]