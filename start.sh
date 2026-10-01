#!/bin/bash
set -e

PORT="${PORT:-10000}"

echo "Starting virtual display..."

Xvfb :99 -screen 0 1280x800x24 &
export DISPLAY=:99

sleep 2

echo "Starting Chromium..."

mkdir -p /tmp/chromium

chromium \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --start-maximized \
    --user-data-dir=/tmp/chromium \
    --no-first-run \
    --no-default-browser-check \
    "https://www.google.com" &

sleep 5

echo "Starting VNC..."

x11vnc \
    -display :99 \
    -forever \
    -shared \
    -nopw \
    -listen 127.0.0.1 \
    -rfbport 5900 &

sleep 2

echo "Starting noVNC on port ${PORT}..."

exec websockify \
    --web=/usr/share/novnc \
    "0.0.0.0:${PORT}" \
    "127.0.0.1:5900"