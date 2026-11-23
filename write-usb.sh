#!/usr/bin/env bash
set -euo pipefail
ISO="${1:-}"
DEV="${2:-}"
[[ -f "$ISO" && -b "$DEV" ]] || { echo "Usage: sudo $0 image.iso /dev/sdX"; exit 2; }
echo "WARNING: This will erase ALL data on $DEV"
lsblk "$DEV"
read -r -p "Type ERASE to continue: " answer
[[ "$answer" == "ERASE" ]] || exit 1
dd if="$ISO" of="$DEV" bs=4M status=progress conv=fsync
sync
echo "USB written."
