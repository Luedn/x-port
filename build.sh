#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [[ $EUID -ne 0 ]]; then echo "Run with sudo: sudo ./build.sh"; exit 1; fi
command -v lb >/dev/null || { apt-get update; apt-get install -y live-build debootstrap squashfs-tools xorriso; }
mkdir -p out
lb clean --purge || true
lb config \
  --architectures amd64 \
  --distribution bookworm \
  --binary-images iso-hybrid \
  --bootappend-live "boot=live components quiet splash" \
  --debian-installer live \
  --debian-installer-gui true \
  --archive-areas "main contrib non-free non-free-firmware" \
  --apt-recommends true \
  --iso-application "X-Console OS" \
  --iso-volume "XCONSOLE_OS"
lb build
find . -maxdepth 1 -type f -name '*.iso' -exec cp -v {} out/x-console-os-amd64.hybrid.iso \;
if [[ -f out/x-console-os-amd64.hybrid.iso ]]; then
  sha256sum out/x-console-os-amd64.hybrid.iso | tee out/SHA256SUMS
  echo "ISO created: out/x-console-os-amd64.hybrid.iso"
else
  echo "Build completed but ISO output was not found." >&2; exit 1
fi
