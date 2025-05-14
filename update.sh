#!/usr/bin/env bash

set -e

versions="$(xmlstarlet sel -t -v '/component/releases/release/@version' com.automattic.beeper.metainfo.xml)"
download_url="$(curl -LsI -o /dev/null -w %{url_effective}  https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop)"
current_version="$(echo $download_url | grep -Eo '[0-9.]+[0-9]+')"

if ! grep "$current_version" <<<"$versions" &>/dev/null; then
  echo "Updating to version $current_version"
  curl -SsL "$download_url" -o /tmp/beeper.appimage
  sha256="$(sha256sum /tmp/beeper.appimage | cut -f1 -d' ')"
  rm -f /tmp/beeper.appimage

  date="$(date +"%Y-%m-%d")"
  xmlstarlet ed -L -i "/component/releases/release[1]" -t elem -n release -v "" \
    -i "/component/releases/release[1]" -t attr -n version -v "$current_version" \
    -i "/component/releases/release[1]" -t attr -n date -v "$date"  com.automattic.beeper.metainfo.xml

  yq e -i ".modules[0].sources[0].url = \"$download_url\"" com.automattic.beeper.yml
  yq e -i ".modules[0].sources[0].sha256 = \"$sha256\"" com.automattic.beeper.yml

else
  echo "Not updating, version $current_version already in manifest"
fi
