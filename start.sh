#!/bin/bash
set -e

PORT="${PORT:-10000}"

mkdir -p /tmp/chromium

Xvfb :99 -screen 0 1280x800x24 &
sleep 2

export DISPLAY=:99

x11vnc \
  -display :99 \
  -forever \
  -shared \
  -nopw \
  -rfbport 5900 &

chromium \
  --no-sandbox \
  --disable-dev-shm-usage \
  --start-maximized \
  --user-data-dir=/tmp/chromium \
  about:blank &

sleep 3

websockify \
  --web=/usr/share/novnc/ \
  "0.0.0.0:${PORT}" \
  localhost:5900