#!/bin/bash

set -euo pipefail

geni_get_parameter() {
    local param="$1"
    local full_param="emulab.net.parameter.${param}"

    if ! command -v geni-get >/dev/null 2>&1; then
        echo "Error: geni-get is not installed or not in PATH" >&2
        exit 1
    fi

    if command -v xpath >/dev/null 2>&1; then
        geni-get manifest | xpath -q -e "string(//*[local-name()='data_item' and @name='${full_param}'])" 2>/dev/null
        return
    fi

    if command -v xmllint >/dev/null 2>&1; then
        geni-get manifest | xmllint --xpath "string(//*[local-name()='data_item' and @name='${full_param}'])" - 2>/dev/null
        return
    fi

    if command -v python3 >/dev/null 2>&1; then
        geni-get manifest | python3 - "$full_param" <<'PY'
import sys
import xml.etree.ElementTree as ET

param = sys.argv[1]
xml_data = sys.stdin.read()
root = ET.fromstring(xml_data)

value = ""
for elem in root.iter():
    if elem.tag.endswith("data_item") and elem.attrib.get("name") == param:
        value = (elem.text or "").strip()
        break

print(value)
PY
        return
    fi

    echo "Error: need one of xpath, xmllint, or python3 to parse manifest" >&2
    exit 1
}

n_servers="$(geni_get_parameter n_servers)"
n_clients="$(geni_get_parameter n_clients)"

if [[ -z "${n_servers}" ]]; then
    echo "Error: failed to read n_servers from manifest" >&2
    exit 1
fi

if [[ -z "${n_clients}" ]]; then
    echo "Error: failed to read n_clients from manifest" >&2
    exit 1
fi

if ! [[ "${n_servers}" =~ ^[0-9]+$ ]]; then
    echo "Error: n_servers is not numeric: ${n_servers}" >&2
    exit 1
fi

if ! [[ "${n_clients}" =~ ^[0-9]+$ ]]; then
    echo "Error: n_clients is not numeric: ${n_clients}" >&2
    exit 1
fi

nvms="${n_servers}"

echo "n_servers=${n_servers}"
echo "n_clients=${n_clients}"