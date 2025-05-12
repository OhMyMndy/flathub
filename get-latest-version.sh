#!/usr/bin/env bash


download_url="$(curl -LsI -o /dev/null -w %{url_effective}  https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop)"
current_version="$(echo $download_url | grep -Eo '[0-9.]+[0-9]+')"

echo $current_version