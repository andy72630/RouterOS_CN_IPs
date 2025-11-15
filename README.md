# RouterOS CN IPv4 List

This repository generates a RouterOS `.rsc` script containing all China IPv4 CIDR ranges.

The file is created by `generator.bash` and saved to:

dist/cn_ip_cidr.rsc

A GitHub Action updates the list automatically.

## MikroTik Usage

/tool fetch url="https://raw.githubusercontent.com/andy72630/RouterOS_CN_IPs/main/dist/cn_ip_cidr.rsc" dst-path=cn.rsc

/import file-name=cn.rsc

## Source

https://ispip.clang.cn/all_cn.txt
