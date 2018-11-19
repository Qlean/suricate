#!/usr/bin/env bash
set -ex
crond -L  /proc/1/fd/1 || exit 1
exec "$@"
