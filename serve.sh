#!/bin/sh
# Serve the CandyBot page on port 8000. Run this again after a reboot.
cd "$(dirname "$0")" && exec python3 -m http.server 8000 --bind 0.0.0.0
