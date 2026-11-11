#!/usr/bin/env bash
#
# Parses all templates from examples/ with the VTL grammar and reports files
# that produce tree-sitter ERROR/MISSING nodes.
#
# Requires the tree-sitter CLI (once):
#   (cd tree-sitter-vtl && npm install)
#
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
grammar="$root/tree-sitter-vtl"

if [[ -x "$grammar/node_modules/.bin/tree-sitter" ]]; then
  tree_sitter="$grammar/node_modules/.bin/tree-sitter"
elif command -v tree-sitter >/dev/null 2>&1; then
  tree_sitter="$(command -v tree-sitter)"
else
  echo "tree-sitter CLI not found. Install it first:" >&2
  echo "  (cd \"$grammar\" && npm install)" >&2
  exit 2
fi

files=()
while IFS= read -r file; do
  files+=("$file")
done < <(
  find "$root/examples" -maxdepth 1 -type f \
    \( -name '*.vm' -o -name '*.vtl' -o -name '*.velocity' \) 2>/dev/null | sort
)

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No templates found in examples/."
  exit 0
fi

failed=0

for file in "${files[@]}"; do
  relative="${file#"$root"/}"

  if output="$(cd "$grammar" && "$tree_sitter" parse "$file" 2>&1)"; then
    echo "✓ $relative"
    continue
  fi

  failed=$((failed + 1))
  problems="$(printf '%s\n' "$output" | grep -E '\((ERROR|MISSING)' || true)"

  if [[ -n "$problems" ]]; then
    echo "✗ $relative"
    printf '%s\n' "$problems" | sed 's/^/    /'
  else
    echo "✗ $relative: could not run the parser"
    printf '%s\n' "$output" | head -5 | sed 's/^/    /'
  fi
done

echo

if [[ $failed -gt 0 ]]; then
  echo "$failed template(s) contain syntax errors."
  exit 1
fi

echo "All templates parsed without errors."
