#!/bin/bash
set -e

PORT="${PORT:-10000}"

echo "Starting Xvfb..."

Xvfb :99 -screen 0 1280x800x24 -ac &
export DISPLAY=:99

sleep 2

echo "Starting Chromium..."

mkdir -p /tmp/chromium

chromium \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --start-maximized \
    --no-first-run \
    --no-default-browser-check \
    --user-data-dir=/tmp/chromium \
    about:blank &

sleep 5

echo "Starting x11vnc..."

x11vnc \
    -display :99 \
    -localhost \
    -forever \
    -shared \
    -nopw \
    -rfbport 5900 &

sleep 3

echo "Starting noVNC on port ${PORT}..."

exec /usr/share/novnc/utils/novnc_proxy \
    --vnc 127.0.0.1:5900 \
    --listen 0.0.0.0:${PORT}