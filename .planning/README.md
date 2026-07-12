# Persistent Planning

This repository uses the shared Codex/Claude persistent-planning protocol.

<!-- persistent-planning:managed:start -->
## Persistent Planning Quick Start

`plan list` is the dynamic task index. It reads each task's `metadata.json`, so it
is the current source for task id, title, and status.
Do not maintain a manual task-status index in this README.

```bash
# One-time repository setup
plan enable

# Create and find tasks
plan init <task-id> --title "..." --alias "..." --tag "..."
plan list
plan resolve "<task reference>" --json
plan status [task-id]

# Verify and complete
plan verify-run <task-id> -- <verification command>
plan sync-head <task-id>
plan complete <task-id>
```

In Codex or Claude prompts:

```text
任务列表
继续认证任务
当前进度
退出当前任务
/plan attach <task-id>
/plan detach
```

Only a unique exact task-id or alias auto-attaches. Ambiguous, title/tag/fuzzy,
and completed-task matches require confirmation. Reference-only language does
not change session bindings. Session bindings stay local; `.planning/tasks/`
and `.planning/knowledge/` are the Git-backed durable state.
<!-- persistent-planning:managed:end -->
