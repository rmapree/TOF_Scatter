#!/usr/bin/env bash
# make_tomos.sh
# Uses tomo_min360.rec as a template and generates tomo_minALPHA_crystal.rec
# with the bin_params_file path updated to bin_minALPHA_crystal.rec

set -euo pipefail

# Template tomo file containing your pasted content
template_tomo="tomo_min360.tomo"

# Base path used in your template
base="/home/treeves/devel/build/sources/STIR/src/SimSET/examples"

if [[ ! -f "$template_tomo" ]]; then
  echo "Error: $template_tomo not found. Save your 360 tomo content into this file." >&2
  exit 1
fi

for alpha in $(seq 360 20 520); do
  out="tomo_min${alpha}
.tomo"
  new_bin_path="${base}/bin_min${alpha}.rec"

  # 1) Update the header line to reflect the current alpha
  # 2) Update bin_params_file line to point to the new *_crystal.rec file
  sed -E \
    -e "s/(Tomograph file for min_e = )[0-9]+/\1${alpha}/" \
    -e "s#^(STR[[:space:]]+bin_params_file[[:space:]]*=[[:space:]]*\").*(\")#\1${new_bin_path}\2#" \
    "$template_tomo" > "$out"

  echo "Created $out → bin_params_file = ${new_bin_path}"
done

