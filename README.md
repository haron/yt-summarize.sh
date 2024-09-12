# yt-summarize.sh

`yt-summarize.sh` is a Bash script that summarizes Youtube videos by extracting and processing subtitles.

## Prerequisites

`uv` installed ([docs](https://docs.astral.sh/uv/#getting-started))

[OpenAI key](https://platform.openai.com/api-keys) set for `llm` tool with the command:

    uvx llm keys set openai

## Usage

    ./yt-summarize.sh https://youtube.com/watch?v=dQw4w9WgXcQ

The script will:

1. Download English subtitles from the specified Youtube video using [yt-dlp](https://github.com/yt-dlp/yt-dlp)
2. Remove timestamps and other non-essential information
3. Strip the text to fit the token limit using [ttok](https://github.com/simonw/ttok)
4. Summarize the subtitles into a bullet list using OpenAI API and Simon Willison's great [llm](https://llm.datasette.io/) tool.

## Advanced usage

You can add `yt-dlp` [options](https://github.com/yt-dlp/yt-dlp#usage-and-options) to the end of the command, or
create a persistent [config file](https://github.com/yt-dlp/yt-dlp#configuration). Especially useful options:

    --cookies-from-browser ... # try `chrome` or `safari` as a value
    --sub-langs ...            # set to your preferred language

To change the prompt, set `YT_SUMMARIZE_PROMPT` environment variable. Example:

    export YT_SUMMARIZE_PROMPT="summarize video transcript in 2 paragraphs"
    ./yt-summarize.sh ...
