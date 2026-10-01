FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    chromium \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    tini \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash exotic

COPY start.sh /start.sh

RUN chmod +x /start.sh \
    && chown exotic:exotic /start.sh

USER exotic

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/start.sh"]