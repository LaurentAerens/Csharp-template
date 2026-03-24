#!/usr/bin/env bash
# start.sh — application entrypoint / startup script
# Replace or extend this script with any pre-launch tasks
# (e.g. database migrations, config file templating, health pre-checks).

set -euo pipefail

echo "Starting MyProject..."
exec dotnet /app/MyProject.dll
