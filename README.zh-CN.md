[English](D:/Coding/hanzi_Roblox/README.md) | [简体中文](D:/Coding/hanzi_Roblox/README.zh-CN.md)

# Rogue Survivor 配置审计

这个仓库目前还没有导出 Roblox 的源码树。当前真正的配置与脚本来源，仍然在 Roblox Studio 里的活动项目 `Rogue Survivor` 中。

这份文档记录了我在 `2026-03-25` 通过 MCP 对 Studio 现状做的实时检查结果。

## 仓库现状

- 文件系统里的仓库状态：
  - `ROBLOX_MIGRATION_CHECKLIST.md` 是当前的迁移记录。
  - 真实生效的 Roblox 脚本和资源，仍然主要保存在 Studio 中，而不是已提交的 `.lua` 文件。
- 实际影响：
  - 目前大多数玩法调参仍需要直接在 Roblox Studio 里完成。
  - 这份 README 应该视为“当前配置快照”，而不是自动导出的源码文档。

## 当前生效的系统地图

下面这些 Studio 路径，是当前真正驱动这套 run 的核心部分：

| Studio 路径 | 作用 |
| --- | --- |
| `ServerScriptService.RunConfig` | 主配置入口：阶段、计时、开局职业、路线、奖励、药水数值 |
| `ServerScriptService.GameDirector` | 控制主循环，创建运行时状态与 remotes，应用玩家加成，生成敌人与奖励 |
| `Workspace.Round.EnemyVariantDirector` | 控制敌人原型、运行时敌人变体、波次缩放、AI 行为、敌人视觉风格 |
| `StarterPlayer.StarterPlayerScripts.RunClient` | HUD、选人弹窗、路线/过场 UI、双语展示、阶段视觉主题 |
| `ServerStorage.RunAssets` | 当前生效的武器模板与敌人模板 |
| `ServerStorage.ProjectCleanup` | 旧系统归档区，不应该作为当前 run 的主驱动来源 |

## 当前阶段流程

`GameDirector` 当前主循环实际在跑的是：

`Waiting -> Loadout -> Intermission -> Wave -> Interlude -> Route`

另外还有一些仍然存在的阶段枚举：

- `Reward`
- `Defeat`

需要特别注意：

- `Reward` 仍然在 `RunConfig` 里定义着。
- `RunClient` 里也仍然保留了 `Reward` 的表现逻辑。
- `GameDirector` 里也还存在 `runRewardPhase` 这个函数。
- 但主循环本身 **没有调用** `runRewardPhase`，所以 `Reward` 目前更像是遗留流程或暂时停用的流程，而不是当前真正生效的主流程。

## 服务器运行时创建的对象

这些对象由 `GameDirector` 在运行时创建，因此在纯编辑态下不一定一开始就存在：

### `ReplicatedStorage.RunState`

- `Phase`（`StringValue`）
- `Wave`（`IntValue`）
- `TimeLeft`（`IntValue`）
- `EnemiesAlive`（`IntValue`）
- `EnemiesTotal`（`IntValue`）

### `ReplicatedStorage.RunRemotes`

- `ShowRewardChoices`
- `ChooseReward`
- `ShowLoadoutSelection`
- `ChooseLoadout`
- `RestartRun`

### `Workspace.Round`

- 会创建 `RunDrops` 文件夹，用来放治疗药水掉落物

## RunConfig 核心配置

### 玩家基础默认值

| 配置项 | 当前值 |
| --- | --- |
| `BaseWalkSpeed` | `16` |
| `BaseMaxHealth` | `100` |
| `BaseLoadout` | 空 |
| `DefaultLoadoutId` | `scribe` |
| `WeaponOrder` | `ClassicSword`, `Pistol`, `AR` |

### 开局职业选择

| Id | 标题 | 初始武器 | 加成 |
| --- | --- | --- | --- |
| `scribe` | `Ink Scribe` | `Pistol` | `fireRateMultiplier = 0.95`, `ammoBonus = 2` |
| `xia` | `Wandering Xia` | `ClassicSword` | `maxHealthBonus = 18`, `walkSpeedBonus = 1`, `damageMultiplier = 1.08` |

### 路线选择

| Id | 标题 | 方向 | 加成 |
| --- | --- | --- | --- |
| `ember_blade` | `Ember Edge` | 爆发 / 近战压制 | `damageMultiplier = 1.12` |
| `ink_ward` | `Ink Ward` | 续航 / 血量 | `maxHealthBonus = 20` |
| `storm_lattice` | `Storm Lattice` | 远程压制 / 攻速 / 弹药 | `fireRateMultiplier = 0.9`, `ammoBonus = 2` |
| `wayfarer` | `Wayfarer Script` | 机动 / 走位 | `walkSpeedBonus = 2` |

### 计时与波次参数

| 配置项 | 当前值 |
| --- | --- |
| `RouteMilestoneWaves` | `4, 8, 12` |
| `RouteChoiceDuration` | `18` 秒 |
| `LoadoutSelectionDuration` | `15` 秒 |
| `IntermissionDuration` | `10` 秒 |
| `InterludeDuration` | `20` 秒 |
| `DefeatRestartDelay` | `4` 秒 |
| `InterludeEveryNWaves` | `1` |
| `WaveBaseEnemyCount` | `6` |
| `WaveEnemyGrowth` | 每波 `+3` |
| `WaveSpawnDelay` | `0.4` 秒 |
| `PostWaveHealPercent` | `0.25` |
| `EliteEveryNWaves` | `5` |
| `EliteSpawnCount` | `1` |
| `RewardChoicesPerSet` | `3` |
| `PotionHealPercent` | `0.3` |
| `PotionDropMeterStep` | `0.24` |
| `PotionLifetimeSeconds` | `18` |
| `MaxPotionDrops` | `2` |

## Interlude 内容结构

### 事件祝福

| Id | 代价 | 条件 | 加成 |
| --- | --- | --- | --- |
| `ember_pact` | 失去 `14%` 最大生命 | 倾向 `ember_blade` | `damageMultiplier = 1.25`, `walkSpeedBonus = 1` |
| `warding_ink` | 失去 `10%` 最大生命 | 倾向 `ink_ward` | `maxHealthBonus = 30` |
| `storm_contract` | 失去 `12%` 最大生命 | 倾向 `storm_lattice`，需要 `Pistol` 或 `AR` | `fireRateMultiplier = 0.85`, `ammoBonus = 4` |
| `traveler_vow` | 失去 `12%` 最大生命 | 倾向 `wayfarer` | `walkSpeedBonus = 3`, `fireRateMultiplier = 0.9` |

### 休整选项

| 标题 | 效果 | 路线偏好 |
| --- | --- | --- |
| `Short Rest` | 回复 `35%` 最大生命，并获得 `fireRateMultiplier = 0.95` | `ink_ward`, `wayfarer` |

### 奖励池

| Id | 效果 | 备注 |
| --- | --- | --- |
| `vitality` | `+25` 最大生命并回满血 | 偏向 `ink_ward` |
| `quick_hands` | `15%` 更快攻速 | 偏向 `storm_lattice`, `wayfarer`, `ember_blade` |
| `high_caliber` | `20%` 更高武器伤害 | 偏向 `ember_blade`, `storm_lattice` |
| `fleet_footed` | `+2` 移动速度 | 偏向 `wayfarer` |
| `ammo_stockpile` | 枪械 `+4` 弹容量 | 需要 `Pistol` 或 `AR` |
| `unlock_ar` | 本局解锁 `AR` | 已拥有时不会出现 |

## 武器模板审计

当前生效的武器模板位于 `ServerStorage.RunAssets.WeaponTemplates`。

### 枪械

| 武器 | 伤害 | 冷却 | 弹容量 | 备注 |
| --- | --- | --- | --- | --- |
| `Pistol` | `20` | `0.2` | `10` | `GravityFactor = 0.5`，`MaxSpread = 2`，使用手枪抛壳效果 |
| `AR` | `14` | `0.125` | `30` | `FireMode = Automatic`，`GravityFactor = 0.5`，`MaxSpread = 0.6`，使用步枪抛壳效果 |

枪械的更多参数来自 `Configuration` 下的值对象，例如后坐力、枪口火焰尺寸、散布、弹道效果等。

### 近战

`ClassicSword` 没有像枪械那样使用单独的 `Configuration` 文件夹。它的关键运行时数值是由 `GameDirector` 在克隆武器时直接注入的：

- `DamageMultiplier`
- `AttackCooldown`
- `ComboWindow`

当前剑的运行时默认规则是：

- `AttackCooldown = max(0.15, 0.45 * fireRateMultiplier)`
- `ComboWindow = 0.2`

## 敌人系统审计

当前生效的敌人模板位于 `ServerStorage.RunAssets.EnemyTemplates`：

- `BasicEnemy`
- `EliteEnemy`

这里有一个非常重要的实现细节：

- 模板本身并不是最终的敌人数值来源。
- `EnemyVariantDirector` 会在敌人生成后，重新覆盖它们的生命、移动、AI、视觉风格和敌人身份。
- 也就是说，当前敌人平衡实际上分散在“模板资源”和“运行时导演脚本”两处。

### 地图刷怪布局

`Workspace.Round.GameBricks` 当前包含 `4` 个刷怪标记点。

### 运行时敌人原型

`EnemyVariantDirector` 当前定义了 4 种运行时原型：

| 原型 | 移速 | 生命 | 核心攻击方式 |
| --- | --- | --- | --- |
| `raider` | `9` | `95` | 近战 |
| `mage` | `7` | `72` | 远程施法 + 弱近战 |
| `lancer` | `10` | `118` | 近战 + 冲锋 |
| `elite` | `11` | `260` | 冲锋 + 远程投射物 |

### 详细敌人参数

| 原型 | 关键参数 |
| --- | --- |
| `raider` | 近战伤害 `10`，近战距离 `4.5`，近战冷却 `1.1` |
| `mage` | 近战伤害 `6`，近战距离 `3`，近战冷却 `1.4`，理想距离 `28`，后撤距离 `16`，施法距离 `64`，施法冷却 `2.6`，投射物伤害 `14`，投射物速度 `72`，投射物尺寸 `0.9` |
| `lancer` | 近战伤害 `12`，冲锋伤害 `22`，近战距离 `5`，近战冷却 `0.95`，冲锋距离 `12-68`，冲锋冷却 `4.4`，冲锋速度 `52`，冲锋持续时间 `0.7` |
| `elite` | 近战伤害 `18`，冲锋伤害 `30`，近战距离 `5.5`，近战冷却 `0.85`，冲锋距离 `10-72`，冲锋冷却 `3.5`，冲锋速度 `60`，冲锋持续时间 `0.9`，施法距离 `72`，施法冷却 `4.2`，投射物伤害 `20`，投射物速度 `80`，投射物尺寸 `1.2` |

### EnemyVariantDirector 应用的波次缩放

- 每波生命缩放：`1 + (wave - 1) * 0.16`
- 每波伤害缩放：`1 + (wave - 1) * 0.08`

### 变体晋升规则

即使 `GameDirector` 表面上只生成 `BasicEnemy` 和按计划生成的 `EliteEnemy` 模板，`EnemyVariantDirector` 仍然会把生成出来的敌人“升级”为更强原型：

- `mage`：从第 `2` 波开始，或累计生成 `4` 个敌人后可出现
- `lancer`：从第 `3` 波开始，或累计生成 `6` 个敌人后可出现
- `elite`：从第 `4` 波开始，或累计生成 `14` 个敌人后可提前出现

这意味着：

- 最终敌人组成 **并不只由** `RunConfig` 控制。
- 如果后面要调敌人平衡，通常需要同时改 `RunConfig` 和 `EnemyVariantDirector`。

## 场景与环境结构

`Workspace.Round` 当前包含：

- `EnemyVariantDirector`
- `GameBricks`
- `LobbyBricks`
- `AtmosphereRunes`
- `WallGlyphPlaques`
- `GatehouseArchiveBanners`

可以这样理解：

- `GameBricks` 是主要战斗区域 / 刷怪区域
- `LobbyBricks` 是战斗区域外的过渡走廊或表现区域
- 其他文件夹主要用于当前的氛围层与客户端视觉包装

## 玩家状态模型

`GameDirector` 当前维护的每个玩家状态包括：

- 已选择的开局职业
- 已拥有武器
- 永久解锁
- 路线亲和度
- 路线历史
- 最近一次 boon 的种类 / 标题
- 一组属性修正：
  - `maxHealthBonus`
  - `walkSpeedBonus`
  - `damageMultiplier`
  - `fireRateMultiplier`
  - `ammoBonus`

这些信息还会同步回玩家 Attribute，例如：

- `SelectedLoadoutId`
- `SelectedLoadoutTitle`
- `OwnedWeapons`
- `OwnedWeaponsDisplay`
- `PrimaryRouteId`
- `PrimaryRouteTitle`
- `RouteHistory`
- `LatestBoonKind`
- `LatestBoonTitle`

`RunClient` 会读取这些 Attribute 来驱动 HUD 和 run 身份信息面板。

## 深入分析

### 1. 游戏已经可玩，但配置很分散

当前已经有一条明确的可运行玩法主线，但真正的平衡配置分散在多个地方：

- `RunConfig`：控制 run 节奏和奖励逻辑
- `GameDirector`：控制运行时对象创建与武器属性注入
- `EnemyVariantDirector`：控制敌人平衡与 AI
- 武器 `Configuration` 值对象：控制枪械细节数值
- `RunClient`：控制展示文案与各阶段的客户端体验

这种结构对快速迭代是能工作的，但对长期维护和审计不够友好。

### 2. `Reward` 很像半退役流程

证据如下：

- `RunConfig.Phases.Reward` 仍然存在
- `RunClient` 仍然保留了 `Reward` 的表现分支
- `GameDirector` 仍然保留了 `runRewardPhase`
- `GameDirector` 引用了 `RewardDuration`
- `RunConfig` 中 **没有定义** `RewardDuration`
- 主循环没有调用 `runRewardPhase`

目前更合理的理解是：

- 现在真正生效的“选奖励/事件/休整”流程已经并入 `Interlude`
- `Reward` 更像暂时搁置或尚未完全清理掉的旧流程

### 3. 敌人数值没有玩家数值那么集中

玩家侧的主要配置还算集中在 `RunConfig`。

敌人侧则不是：

- 基础波次数量在 `RunConfig`
- 敌人原型数值在 `EnemyVariantDirector`
- 敌人模板骨架在 `ServerStorage.RunAssets.EnemyTemplates`
- 显式的精英怪刷出规则在 `RunConfig`
- 隐式的提前精英晋升逻辑也在 `EnemyVariantDirector`

如果后面要优先做一轮结构整理，敌人配置是最值得先抽离出来的部分。

### 4. 仓库还没有真正纳管“当前游戏源码”

这是目前项目层面最大的限制。

只要当前真正生效的 Studio 脚本还没导出到仓库：

- 代码审查会更困难
- diff 会更困难
- 数值改动追踪会更困难
- README 也只能靠人工维护同步

## 已知风险与后续关注点

- `GameDirector` 引用了 `RunConfig.RewardDuration`，但它当前并不存在。
- `Reward` 阶段看起来像死流程或未完成流程。
- `ServerStorage.ProjectCleanup` 里仍然保留了大量旧系统，后续容易误用。
- 客户端展示配置大量嵌在 `RunClient` 里。
- 敌人平衡被放在 `Workspace.Round.EnemyVariantDirector` 里，这个位置对核心服务器配置来说并不理想。

## 推荐的下一步重构方向

1. 先把当前生效的 Studio 脚本导出到仓库，让文件系统成为真正的源码来源。
2. 把 `EnemyVariantDirector` 里的敌人数值抽成独立配置模块。
3. 决定 `Reward` 是否还要恢复；如果不恢复，就删除这条死流程和缺失的 `RewardDuration` 引用。
4. 保留 `ProjectCleanup` 作为归档，但明确写清哪些 live 系统仍然依赖复制过来的旧资源。
5. 把最常改的武器和平衡参数集中到更少、更明显的配置入口里。
