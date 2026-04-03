# devkit

YuujiKamura プロジェクト群の開発環境セットアップ。

## 方法は3つ

| 方法 | 対象 | 所要時間 |
|------|------|----------|
| `setup-dev.ps1` | Windows ネイティブ開発 | 5-15分 |
| Dev Container / Codespaces | Go, Rust, Zig (Linux) | 2-3分 |
| Docker Compose | ローカル Linux コンテナ | 2-3分 |

## 前提条件

| 方法 | 必要なもの |
|------|-----------|
| `setup-dev.ps1` | Windows 10/11, PowerShell 5.1+, 管理者権限 |
| Dev Container / Codespaces | GitHub アカウント, ブラウザ (または VS Code + Dev Containers 拡張) |
| Docker Compose | Docker Desktop (Windows/macOS) または Docker Engine (Linux) |

## 1. Windows ネイティブ (setup-dev.ps1)

```powershell
# 最小構成 (Go + gh + git — deckpilot 開発向け)
powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1 -Minimal

# 標準構成 (+ Zig + Rust + Python — ghostty ビルド含む)
powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1

# フル構成 (+ VS Build Tools + .NET SDK — XAML 変更時のみ必要)
powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1 -Full
```

管理者権限が必要。

**Ghostty は標準構成（Zig のみ）でビルドできる。** リポに同梱された prebuilt XBF/PRI/DLL を使うため VS は不要。VS Build Tools が必要になるのは XAML ファイル自体を変更するときだけ。

## 2. GitHub Codespaces (推奨: ブラウザだけで開発)

1. このリポを GitHub で開く
2. Code → Codespaces → Create codespace
3. 起動後 `~/repos/` にプロジェクトがクローンされている

**注意:** Ghostty WinUI3 の Windows ネイティブビルドは Codespaces では不可。CI アーティファクトを使うこと。

## 3. Docker Compose (ローカル)

```bash
docker compose -f docker/docker-compose.yml up -d
docker compose -f docker/docker-compose.yml exec dev bash
```

## 対象プロジェクト

| リポ | 言語 | 概要 | Windows ネイティブ必須 |
|------|------|------|----------------------|
| [ghostty (fork)](https://github.com/YuujiKamura/ghostty) | Zig | GPU ターミナルエミュレータ (WinUI3 対応) | Yes |
| [deckpilot](https://github.com/YuujiKamura/deckpilot) | Go | Stream Deck プラグイン | No |
| [control-plane-server](https://github.com/YuujiKamura/control-plane-server) | Rust | コントロールプレーン API サーバ | No |
| [zig-control-plane](https://github.com/YuujiKamura/zig-control-plane) | Zig | コントロールプレーン Zig クライアント | No |
| [win-zig-bindgen](https://github.com/YuujiKamura/win-zig-bindgen) | Zig | WinMD → Zig COM バインディング生成 | Yes |

## トラブルシューティング

| 症状 | 原因 | 対処 |
|------|------|------|
| `setup-dev.ps1` が実行できない | ExecutionPolicy でブロック | `Set-ExecutionPolicy Bypass -Scope Process` を先に実行 |
| Docker Compose でポート衝突 | ホスト側で同じポートが使用中 | `docker compose down` 後、競合プロセスを停止してから再実行 |
| Codespaces でビルドが遅い | デフォルトの 2-core マシン | Codespace 作成時に 4-core 以上を選択 |
| Zig ビルドで DLL が見つからない | prebuilt ファイル未取得 | `git submodule update --init` を実行 |
