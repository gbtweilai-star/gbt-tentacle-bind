#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_tentacle_bind info
PYTHONPATH=src python -m gbt_tentacle_bind check --payload '{}'
PYTHONPATH=src python -m gbt_tentacle_bind run   --payload '{}'
