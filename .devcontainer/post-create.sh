#!/bin/bash
set -e

echo "=== Post-create setup ==="

# Clone repos if not already present
REPOS=(
    "YuujiKamura/deckpilot"
    "YuujiKamura/ghostty"
)

mkdir -p ~/repos
for repo in "${REPOS[@]}"; do
    name=$(basename "$repo")
    if [ ! -d ~/repos/"$name" ]; then
        echo "Cloning $repo ..."
        gh repo clone "$repo" ~/repos/"$name" -- --depth 1 || echo "WARN: clone $repo failed (auth needed?)"
    fi
done

echo "=== Done. Repos in ~/repos/ ==="
