FROM rust:latest AS builder

RUN cargo install --git https://github.com/alexheretic/ab-av1

FROM linuxserver/ffmpeg:latest AS runtime

COPY --from=builder /usr/local/cargo/bin/ab-av1 /usr/local/bin/ab-av1

# Set working directory
WORKDIR /data

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]