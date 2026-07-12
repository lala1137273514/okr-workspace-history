#!/bin/zsh

set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
findings="$repo_root/.planning/tasks/workspace-history/findings.md"
database="$HOME/.codex/state_5.sqlite"
workspace_cwd=$(pwd -P | sed "s/'/''/g")
db_ids=$(mktemp)
plan_ids=$(mktemp)
trap 'rm -f "$db_ids" "$plan_ids"' EXIT

row_count=$(rg -c '^\| [0-9]+ \|' "$findings")
test "$row_count" -eq 30

awk -F'|' '/^\| [0-9]+ \|/ { id=$4; gsub(/[` ]/, "", id); print id }' "$findings" | sort > "$plan_ids"
test "$(sort -u "$plan_ids" | wc -l | tr -d ' ')" -eq 30

if [[ "${1:-}" == "--with-local-db" ]]; then
  db_count=$(sqlite3 "$database" "SELECT count(*) FROM threads WHERE cwd='$workspace_cwd';")
  test "$db_count" -eq 30
  sqlite3 "$database" "SELECT id FROM threads WHERE cwd='$workspace_cwd' ORDER BY id;" > "$db_ids"
  diff -u "$db_ids" "$plan_ids"
fi

test -f "$repo_root/.planning/enabled"
test -f "$repo_root/.planning/tasks/workspace-history/.attestation"

echo "workspace-history portable verification passed: 30 unique Session IDs"
