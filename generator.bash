#! /bin/bash
set -euo pipefail

WORK_DIR=$(cd "$(dirname "$0")"; pwd)

# Ensure tmp and dist directories exist
mkdir -p "$WORK_DIR/tmp"
mkdir -p "$WORK_DIR/dist"

# Download CN IPv4 CIDR list
curl -s https://ispip.clang.cn/all_cn.txt -o "$WORK_DIR/tmp/all_cn.txt"

# Generate RouterOS script (IPv4 only)
cat > "$WORK_DIR/dist/cn_ip_cidr.rsc" << 'EOF'
/log info "Import cn ipv4 cidr list..."
/ip firewall address-list remove [/ip firewall address-list find list=cn_ip_cidr]
/ip firewall address-list
EOF

# Append address-list entries
awk '{ printf(":do {add address=%s list=cn_ip_cidr} on-error={}\n",$0) }' \
  "$WORK_DIR/tmp/all_cn.txt" >> "$WORK_DIR/dist/cn_ip_cidr.rsc"
