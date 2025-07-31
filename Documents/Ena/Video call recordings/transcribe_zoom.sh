#!/bin/bash

set -e

MODEL="small"  # small < base < medium
LANG="English"
OUTPUT_DIR="./output"
mkdir -p "$OUTPUT_DIR"

# Argument parsing
ZOOM_URL=""
INPUT_FILE=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --file) INPUT_FILE="$2"; shift ;;
        *) ZOOM_URL="$1" ;;
    esac
    shift
done

# Filename setup
if [[ -n "$INPUT_FILE" ]]; then
    VIDEO_FILE="$INPUT_FILE"
    BASE_NAME=$(basename "$INPUT_FILE" .mp4)
else
    VIDEO_FILE="$OUTPUT_DIR/call.mp4"
    yt-dlp "$ZOOM_URL" -o "$VIDEO_FILE"
    BASE_NAME="call"
fi

# Step 2: Transcribe to JSON
echo "Running Whisper on $VIDEO_FILE..."
whisper "$VIDEO_FILE" --model "$MODEL" --language "$LANG" --output_format json --output_dir "$OUTPUT_DIR"

# Step 3: Convert JSON to SRT using Python
echo "Converting JSON to SRT..."
python3 json_to_srt.py "$OUTPUT_DIR/$BASE_NAME.json" "$OUTPUT_DIR/$BASE_NAME.srt"

