#!/bin/bash
# Sets up the Omarchy-to-game theme sync. The game itself stays unaware;
# it only watches ~/.config/skifree/theme.toml.
set -euo pipefail

PLUGIN_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
STATE_HOME=${XDG_STATE_HOME:-"$HOME/.local/state"}
RUNTIME_DIR="$DATA_HOME/skifree-theme-sync"
THEMED_DIR="$CONFIG_HOME/omarchy/themed"
HOOK_PATH="$CONFIG_HOME/omarchy/hooks/theme-set.d/skifree-theme-sync"
TEMPLATE_PATH="$THEMED_DIR/skifree.toml.tpl"
GAME_CONFIG_DIR="$CONFIG_HOME/skifree"

install -d "$RUNTIME_DIR" "$THEMED_DIR" "$(dirname -- "$HOOK_PATH")" "$GAME_CONFIG_DIR"
install -Dm755 "$PLUGIN_DIR/scripts/skifree-theme-sync" \
  "$RUNTIME_DIR/skifree-theme-sync"
install -Dm644 "$PLUGIN_DIR/templates/skifree.toml.tpl" "$TEMPLATE_PATH"

cat >"$HOOK_PATH" <<EOF
#!/bin/bash
# Self-cleaning: removing the plugin orphans this hook, so on the next
# theme switch it takes the template and runtime dir with it, then stands
# down. (The game's own theme file is user config and stays.)
PLUGIN_DIR="\$HOME/.config/omarchy/plugins/jasondoc3.skifree-theme"
if [[ ! -d "\$PLUGIN_DIR" ]]; then
  rm -f -- "\$0" "$TEMPLATE_PATH"
  rm -rf -- "$RUNTIME_DIR"
  exit 0
fi
exec "$RUNTIME_DIR/skifree-theme-sync" "\$@"
EOF
chmod 755 "$HOOK_PATH"

# First install: the template has never rendered (that happens on theme
# switch), so refresh the current theme to render it, then sync.
[ -f "$STATE_HOME/omarchy/current/theme/skifree.toml" ] \
  || omarchy theme refresh >/dev/null 2>&1 || true
"$RUNTIME_DIR/skifree-theme-sync"
