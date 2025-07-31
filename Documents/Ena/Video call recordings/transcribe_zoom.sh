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
python3 <<EOF
import json
from pathlib import Path

json_path = Path("$OUTPUT_DIR") / f"{$BASE_NAME}.json"
srt_path = Path("$OUTPUT_DIR") / f"{$BASE_NAME}.srt"

with open(json_path, "r", encoding="utf-8") as f:
    data = json.load(f)

def format_timestamp(seconds):
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = int(seconds % 60)
    ms = int((seconds - int(seconds)) * 1000)
    return f"{h:02}:{m:02}:{s:02},{ms:03}"

with open(srt_path, "w", encoding="utf-8") as f:
    for i, seg in enumerate(data["segments"], 1):
        start = format_timestamp(seg["start"])
        end = format_timestamp(seg["end"])
        text = seg["text"].strip()
        f.write(f"{i}\n{start} --> {end}\n{text}\n\n")
print(f"SRT written to {srt_path}")
EOF
