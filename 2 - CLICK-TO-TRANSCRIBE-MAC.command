#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# pick a modern Python
if [ -x /usr/local/bin/python3.13 ]; then PY=/usr/local/bin/python3.13
elif [ -x /usr/local/bin/python3.12 ]; then PY=/usr/local/bin/python3.12
elif [ -x /usr/local/bin/python3.11 ]; then PY=/usr/local/bin/python3.11
else PY=$(command -v python3); fi

# sanity check ≥ 3.10
VER=$($PY - <<'PY'
import sys; print(".".join(map(str, sys.version_info[:3])))
PY
)
MAJOR=${VER%%.*}; MINOR=${VER#*.}; MINOR=${MINOR%%.*}
if [ "$MAJOR" -lt 3 ] || [ "$MINOR" -lt 10 ]; then
  echo "ERROR: Need Python ≥ 3.10. Installed: $VER"
  echo "Install Python 3.13 from python.org, then re-run."
  read -n 1 -s -p "Press any key to close…"
  exit 1
fi

echo "Using Python: $PY ($VER)"
mkdir -p "1 - Put-Audio-Files-Here" "3 - Read-Your-Transcripts-Here" "4 - Finished-Audio-Moved-Here" "5 - Ignore-This-Folder"
cd "5 - Ignore-This-Folder"

# venv with the chosen Python ($PY)
if [ -d ".venv" ]; then
  OK=$(.venv/bin/python - <<'PY'
import sys; print(sys.version_info >= (3,10))
PY
)
  [ "$OK" = "True" ] || rm -rf .venv
fi

if [ ! -d ".venv" ]; then
  "$PY" -m venv .venv
  source .venv/bin/activate
  python -m pip install --upgrade pip
  pip install assemblyai
else
  source .venv/bin/activate
fi

python transcribe_all.py

echo
echo "Done. Open '3 - Read-Your-Transcripts-Here'."
read -n 1 -s -p "Press any key to close…"