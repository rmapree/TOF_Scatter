#!/usr/bin/env bash
set -euo pipefail

# Folder you want in the final paths (matches your example)
OUTPUT_DIR="/home/treeves/devel/build/sources/STIR/src/SimSET/examples/TOF_Scatter_Simulation"

# Escape / and & for safe sed replacement
escape() { printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'; }
OUT_ESC="$(escape "$OUTPUT_DIR")"

for alpha in $(seq 360 20 520); do
  sed -E \
    -e "s/ALPHA/${alpha}/g" \
    -e "s#(\$\{DIR_OUTPUT\}|\$DIR_OUTPUT|\{DIR_OUTPUT\}|OUTPUT_DIRECTORY|DIR_OUTPUT)#$OUT_ESC#g" \
    -e "s#rec_minALPHA\.weight2#rec_min${alpha}.weight2#g" \
    -e "s#rec_minALPHA\.weight#rec_min${alpha}.weight#g" \
    -e "s#rec_minALPHA\.count#rec_min${alpha}.count#g" \
    template_bin_EW.rec > "bin_min${alpha}.rec"
  echo "Wrote bin_min${alpha}.rec"
done

