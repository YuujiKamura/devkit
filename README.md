# devkit

YuujiKamura プロジェクト群の開発環境セットアップ。

## 方法は3つ

| 方法 | 対象 | 所要時間 |
|------|------|----------|
| `setup-dev.ps1` | Windows ネイティブ開発 | 5-15分 |
| Dev Container / Codespaces | Go, Rust, Zig (Linux) | 2-3分 |
| Docker Compose | ローカル Linux コンテナ | 2-3分 |

## 1. Windows ネイティブ (setup-dev.ps1)

Ghostty WinUI3 のビルドを含む全ツールチェーン。

```powershell
# 最小構成 (Go + gh + git — deckpilot 開発向け)
powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1 -Minimal

# 拡張構成 (+ Zig + Rust + Python)
powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1

# フル構成 (+ VS Build Tools + .NET SDK — ghostty ビルド向け)
powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1 -Full
```

管理者権限が必要。

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

| リポ | 言語 | Windows ネイティブ必須 |
|------|------|----------------------|
| ghostty (fork) | Zig | Yes (WinUI3 ビルド) |
| deckpilot | Go | No |
| control-plane-server | Rust | No |
| zig-control-plane | Zig | No |
| win-zig-bindgen | Zig | Yes |
