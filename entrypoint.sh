#!/bin/bash

# Ensure input arguments are provided
if [ "$#" -lt 1 ]; then
    echo "Usage: entrypoint.sh <input_file> [samples]"
    exit 1
fi

INPUT_FILE=$1
SAMPLES=$2 # Optional

BASENAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
OUTPUT_FILE="$BASENAME.txt"

# Ensure input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file not found: $INPUT_FILE"
    exit 1
fi

# Determine how many samples to take. Default is 5
if [ -z "$SAMPLES" ]; then
    SAMPLES="5"
fi

echo "$BASENAME" >> "$OUTPUT_FILE"

# Run ab-av1 crf-search
ab-av1 crf-search --min-xpsnr 42 --crf-increment 0.5 --max-crf 24 --min-crf 12 --samples "$SAMPLES" --keep --encoder libx265 --preset "slow" --pix-format yuv420p10le --enc x265-params=high-tier=1:repeat-headers=1:aud=1:hrd=1:deblock=-3,-3:no-open-gop=1:no-sao=1 --input "$INPUT_FILE" >> "$OUTPUT_FILE"

# Inform user of output
echo "CRF seach complete."
cat "$OUTPUT_FILE"