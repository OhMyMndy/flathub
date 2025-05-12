#!/usr/bin/env bash

versions="$(xmlstarlet sel -t -v '/component/releases/release/@version' com.automattic.beeper.metainfo.xml)"

current_version=$(./get-latest-version.sh)

if ! grep "$current_version" <<<"$versions" &>/dev/null; then
  echo "Updating to version $current_version"
  date="$(date +"%Y-%m-%d")"
  xmlstarlet ed -L -i "/component/releases/release[1]" -t elem -n release -v "" \
    -i "/component/releases/release[1]" -t attr -n version -v "$current_version" \
    -i "/component/releases/release[1]" -t attr -n date -v "$date"  com.automattic.beeper.metainfo.xml

else
  echo "Not updating, version $current_version already in manifest"
fi
