#!/bin/zsh

set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
findings="$repo_root/.planning/tasks/workspace-history/findings.md"
database="$HOME/.codex/state_5.sqlite"
workspace_cwd=$(pwd -P | sed "s/'/''/g")
db_ids=$(mktemp)
plan_ids=$(mktemp)
trap 'rm -f "$db_ids" "$plan_ids"' EXIT

db_count=$(sqlite3 "$database" "SELECT count(*) FROM threads WHERE cwd='$workspace_cwd';")
row_count=$(rg -c '^\| [0-9]+ \|' "$findings")

test "$db_count" -eq 30
test "$row_count" -eq 30

sqlite3 "$database" "SELECT id FROM threads WHERE cwd='$workspace_cwd' ORDER BY id;" > "$db_ids"
awk -F'|' '/^\| [0-9]+ \|/ { id=$4; gsub(/[` ]/, "", id); print id }' "$findings" | sort > "$plan_ids"
diff -u "$db_ids" "$plan_ids"

test -f "$repo_root/.planning/enabled"
test -f "$repo_root/.planning/tasks/workspace-history/.attestation"

echo "workspace-history verification passed: 30/30 Session IDs match"
