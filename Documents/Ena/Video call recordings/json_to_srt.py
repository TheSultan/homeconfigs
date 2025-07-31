#!/usr/bin/env python3

import json
import sys
from pathlib import Path

def format_timestamp(seconds):
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = int(seconds % 60)
    ms = int((seconds - int(seconds)) * 1000)
    return f"{h:02}:{m:02}:{s:02},{ms:03}"

def convert_json_to_srt(json_file, srt_file):
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    with open(srt_file, "w", encoding="utf-8") as f:
        for i, seg in enumerate(data["segments"], 1):
            start = format_timestamp(seg["start"])
            end = format_timestamp(seg["end"])
            text = seg["text"].strip()
            f.write(f"{i}\n{start} --> {end}\n{text}\n\n")

    print(f"SRT file written to: {srt_file}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python json_to_srt.py input.json output.srt")
        sys.exit(1)

    json_path = Path(sys.argv[1])
    srt_path = Path(sys.argv[2])
    convert_json_to_srt(json_path, srt_path)
