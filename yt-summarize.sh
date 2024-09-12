#!/usr/bin/env bash

YT_SUMMARIZE_PROMPT="${YT_SUMMARIZE_PROMPT:-Above are the subtitles from Youtube video. Please summarize it in a bullet list of 5-10 key points. Be concise, but do not omit important details.}"
URL="${1:-""}"
shift

if [[ -z "$URL" ]]; then
    echo "Usage: $0 https://youtube.com/watch... [yt-dlp options...]"
    exit
fi

if ! which uvx >/dev/null 2>&1; then
    echo "Error: uv tool is requied. Start at https://docs.astral.sh/uv/#getting-started"
    exit 1
fi

if ! uvx llm keys | grep -q openai; then
    echo "Set your OpenAI API key with the following command: uvx llm keys set openai"
    exit 1
fi

TEMPDIR="$(mktemp -d)"
# To use cookies from your browser, use `--cookies-from-browser ...` (more info in `yt-dlp --help`)
uvx -q \
    yt-dlp --paths "$TEMPDIR" --quiet --no-warnings --skip-download --write-auto-subs --convert-subs srt "$URL" "$@"

cat "$TEMPDIR/"*.srt \
    | tr -d '\r' \
    | grep -Ev '^[0-9]{2}:.* -->' \
    | grep -Ev '^[0-9]*$' \
    | grep -Ev '^ *$' \
    | uniq \
    | uvx -q ttok -t 15000 \
    | uvx -q llm -s "$YT_SUMMARIZE_PROMPT"
# 15 000 tokens is roughly 1 hour of talking head

rm -rf "$TEMPDIR"