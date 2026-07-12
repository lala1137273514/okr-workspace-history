# Task Plan: Workspace Session 历史与后续计划

## Goal

把当前 Workspace 的 Codex Session 历史整理为 Git 可版本控制的任务账本，并持续记录后续工作、证据边界和恢复入口。任何设备拉取同一 Git 仓库后，都能从本任务文件恢复上下文；本地 session binding 仍需在每台设备重新 attach。

## Source References

- Specification: none
- Implementation plan: none
- Session source: local Codex state database, exact `cwd` match
- Historical workspace source: existing `.planning/` ledgers, reports, deliverables, and cached evidence

## Current Phase

Phase 3

## Phases

### Phase 1: 建立历史基线

- [x] 确认 Workspace 当前不是 Git 仓库
- [x] 从本机 Codex 数据库按精确 `cwd` 统计 Session
- [x] 区分主任务、并行采集任务、工具调研和当前 Plan 任务
- **Status:** completed

### Phase 2: 建立持久化任务

- [x] 初始化 Git 仓库
- [x] 执行 `plan enable`
- [x] 初始化并 attach `workspace-history`
- [x] 将 30 个 Session 汇总写入 `findings.md`
- **Status:** completed

### Phase 3: 验证与跨设备交接

- [x] 验证 30 个 Session ID 无遗漏、无重复
- [x] 验证 attestation、task status 和文件结构
- [ ] 用户授权后配置 Git remote、commit 并 push，使任务真正跨设备可用
- **Status:** in_progress

### Phase 4: 持续维护

- [ ] 每次周报、OKR 或产品工作形成阶段结论后更新 `findings.md`
- [ ] 在 `progress.md` 记录真实命令、结果和缺口
- [ ] 新设备执行 `plan attach workspace-history --session <session-id> --platform codex`
- [ ] 历史任务稳定后，按主题拆分独立任务，主账本仅保留索引
- **Status:** pending

## 后续任务池

| 优先级 | 工作流 | 下一步 | 完成证据 |
|---|---|---|---|
| P0 | 跨设备同步 | 配置 remote、首次 commit/push | 第二台设备可 clone/pull 并通过 `plan status workspace-history` 读取 |
| P0 | 周报真实闭环 | 用 W14 做 `lark-weekly-report` 首次真实运行 | 全源采集、缺口登记、草稿、用户确认、发布后读回 |
| P1 | 周报自动化 | 仅在权限预检和非发布演练后启用定时草稿 | 定时生成草稿；不自动发布 |
| P1 | Q2 OKR 归档 | 固化收尾证据、score 字段限制和文档索引 | OKR 状态、证据文档、未解决 API 限制可追溯 |
| P1 | 历史账本更新 | 补录旧 `.planning/ledger/codex.md` 中 4–5 月历史 | 与现有 30 条新式 Session 账本分层，不重复计算 |
| P2 | 飞书权限缺口 | 复核文档搜索、消息搜索和会议产物权限 | 当前 token scope 与实际只读命令结果一致 |
| P2 | 工具能力跟踪 | 记录 lark-cli 版本与“原生汇报”能力边界 | live CLI help/schema 和只读验证 |

## Acceptance Checks

- [x] 数据库精确 `cwd` 计数为 30
- [x] `findings.md` 包含 30 个唯一 Session ID
- [x] 日期分布合计为 30
- [x] 主题分布合计为 30
- [x] `plan verify workspace-history` 通过
- [x] `plan status workspace-history` 无 gate error
- [x] `zsh .planning/tasks/workspace-history/verify.sh` 输出 30/30 匹配
- [x] `git diff --check` 通过
- [x] 跨设备同步未执行前，状态明确为“本地已持久化，尚未远端同步”

## Decisions

| Decision | Rationale | Evidence |
|---|---|---|
| 使用单一 `workspace-history` 总账本 | 当前目标是任务历史与恢复入口，不是重建每个旧任务的完整实施计划 | 30 个 Session 多数属于同一周报/OKR证据链 |
| Session 目标与完成事实分开 | 部分 Session 只有任务意图或不完整最终输出 | rollout 末尾信息质量不一致 |
| 不存原始私密消息、token、认证信息 | Plan 将进入 Git 并跨设备同步 | persistent planning security contract |
| 暂不 complete | Git remote、commit、push 未获授权，跨设备目标尚未闭环 | 当前仓库无 commit、无已验证远端 |

## Errors

| Error | Attempt | Resolution |
|---|---:|---|
| `plan: current directory is not inside a Git repository` | 1 | 用户授权后执行 `git init`，再启用 Plan |
| `list_threads received invalid arguments` | 1 | 改用本机 Codex 数据库按精确 `cwd` 全量查询 |
| zsh 循环内 `tail/tr/cut: command not found` | 1 | 避免使用 zsh 特殊变量名 `path`，改为 `filepath` |
