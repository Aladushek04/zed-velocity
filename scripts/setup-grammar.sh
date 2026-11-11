#!/usr/bin/env bash
#
# Points extension.toml at the bundled tree-sitter grammar and pins the grammar
# commit that Zed checks out (`rev` is mandatory in the extension manifest).
#
# Usage:
#   ./scripts/setup-grammar.sh
#       Use the bundled grammar from the local filesystem (file:// URL).
#       This is what you want for local development.
#
#   ./scripts/setup-grammar.sh https://github.com/<you>/tree-sitter-vtl
#       Use a published grammar repository. Push the contents of
#       tree-sitter-vtl/ to that repository first.
#
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
grammar="$root/tree-sitter-vtl"
manifest="$root/extension.toml"
repository="${1:-file://$grammar}"

if [[ ! -d "$grammar/.git" ]]; then
  git -C "$grammar" init -q
fi

if ! git -C "$grammar" rev-parse --verify HEAD >/dev/null 2>&1; then
  git -C "$grammar" add -A
  git -C "$grammar" \
    -c user.name="Velocity VTL grammar" \
    -c user.email="vtl-grammar@example.invalid" \
    commit -q -m "Add tree-sitter grammar for the Velocity Template Language"
fi

rev="$(git -C "$grammar" rev-parse HEAD)"

python3 - "$manifest" "$repository" "$rev" <<'PY'
import re
import sys

manifest, repository, rev = sys.argv[1:4]
text = open(manifest, encoding="utf-8").read()

start = text.index("[grammars.vtl]")
head, section = text[:start], text[start:]

section = re.sub(r'(?m)^repository = ".*"$', f'repository = "{repository}"', section, count=1)
section = re.sub(r'(?m)^rev = ".*"$', f'rev = "{rev}"', section, count=1)

open(manifest, "w", encoding="utf-8").write(head + section)
print(f"grammar repository: {repository}")
print(f"grammar rev:        {rev}")
PY

cat <<EOF

Done. Install the extension in Zed with the "zed: install dev extension"
command and select:

  $root
EOF
