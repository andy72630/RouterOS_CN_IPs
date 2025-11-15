#! /bin/bash
set -euo pipefail

WORK_DIR=$(cd "$(dirname "$0")"; pwd)

mkdir -p "$WORK_DIR/tmp"
mkdir -p "$WORK_DIR/dist"

PRIMARY_URL="https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute.txt"
FALLBACK_URL="https://www.ipdeny.com/ipblocks/data/aggregated/cn-aggregated.zone"

TMP_FILE="$WORK_DIR/tmp/cn_ipv4.txt"

echo "[generator] downloading CN IPv4 list..."

if curl -fsSL "$PRIMARY_URL" -o "$TMP_FILE"; then
  echo "[generator] using mayaxcn/china-ip-list (chnroute.txt)"
else
  echo "[generator] primary source failed, falling back to ipdeny cn-aggregated.zone" >&2
  curl -fsSL "$FALLBACK_URL" -o "$TMP_FILE"
fi

# Build RouterOS script
OUT_FILE="$WORK_DIR/dist/cn_ip_cidr.rsc"

cat > "$OUT_FILE" << 'EOF'
/log info "Import cn ipv4 cidr list..."
/ip firewall address-list remove [/ip firewall address-list find list=cn_ip_cidr]
/ip firewall address-list
EOF

# Skip empty lines and comments that start with '#'
awk 'NF && $1 !~ /^#/ { printf(":do {add address=%s list=cn_ip_cidr} on-error={}\n", $1) }' \
  "$TMP_FILE" >> "$OUT_FILE"

echo "[generator] generated $OUT_FILE"
