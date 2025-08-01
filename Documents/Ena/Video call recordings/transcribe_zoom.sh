#!/bin/bash

set -e

MODEL="medium" # Options: tiny, base, small, medium, large
LANG="English"

# Argument parsing
ZOOM_URL=""
INPUT_FILE=""
CALL_DATE=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --file) INPUT_FILE="$2"; shift ;;
        --date) CALL_DATE="$2"; shift ;;
        *) ZOOM_URL="$1" ;;
    esac
    shift
done

# Validate arguments
if [[ -z "$INPUT_FILE" && -z "$ZOOM_URL" ]]; then
    echo "❌ Error: You must provide either a Zoom URL or --file input."
    exit 1
fi

if [[ -z "$INPUT_FILE" && -z "$CALL_DATE" ]]; then
    echo "❌ Error: --date YYYYMMDD must be provided when using a Zoom URL."
    exit 1
fi

# Determine input and base name
if [[ -n "$INPUT_FILE" ]]; then
    VIDEO_FILE="$INPUT_FILE"
    BASE_NAME=$(basename "$VIDEO_FILE")
    BASE_NAME="${BASE_NAME%.*}"
else
    BASE_NAME="$CALL_DATE"
    VIDEO_FILE="${BASE_NAME}.mp4"

    # Prevent accidental overwrite
    if [[ -f "$VIDEO_FILE" ]]; then
        echo "❌ Error: File $VIDEO_FILE already exists. Aborting to avoid overwrite."
        exit 1
    fi

    echo "📥 Downloading Zoom video to: $VIDEO_FILE"
    yt-dlp "$ZOOM_URL" -o "$VIDEO_FILE"
fi

OUTPUT_DIR=$(dirname "$VIDEO_FILE")

# Step 2: Transcribe to JSON
echo "📝 Transcribing $VIDEO_FILE to JSON..."
echo "   → Output: $OUTPUT_DIR/$BASE_NAME.json"
whisper "$VIDEO_FILE" \
    --model "$MODEL" \
    --language "$LANG" \
    --output_format json \
    --output_dir "$OUTPUT_DIR"

# Validate Whisper output
if [[ ! -f "$OUTPUT_DIR/$BASE_NAME.json" ]]; then
    echo "❌ Transcription failed: JSON file was not created."
    exit 1
fi

# Step 3: Convert JSON to SRT
echo "🎬 Converting JSON to SRT..."
echo "   → Output: $OUTPUT_DIR/$BASE_NAME.srt"
python3 json_to_srt.py "$OUTPUT_DIR/$BASE_NAME.json" "$OUTPUT_DIR/$BASE_NAME.srt"

echo "✅ Done. Transcript and captions saved alongside $VIDEO_FILE"
