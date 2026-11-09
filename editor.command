#!/bin/bash
# ==========================================================================
#  ArcEngine - editor launch (_utils/editor)
#  Starts the editor server (location, camera, render settings) and opens a browser.
#  Needs Node.js only - zero dependencies, same as the kit itself.
#
#    editor.command                 -> port 8090 (or the next free one), opens browser
#    editor.command 9100            -> custom port
#    editor.command 9100 --no-open  -> do not open a browser
# ==========================================================================
cd "$(dirname "$0")" || exit 1

# Ensure Homebrew and standard PATHs are available on macOS
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

pause() {
  if [ -t 0 ]; then
    read -n 1 -s -r -p "Press any key to continue..."
    echo ""
  fi
}

if ! command -v node >/dev/null 2>&1; then
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  fi
fi

if ! command -v node >/dev/null 2>&1; then
  echo ""
  echo "  [x] Node.js not found in PATH."
  echo "      Install it from https://nodejs.org/ (LTS) and run this file again."
  echo ""
  pause
  exit 1
fi

ARGS=()
for arg in "$@"; do
  if [[ "$arg" =~ ^[0-9]+$ ]]; then
    ARGS+=("--port=$arg")
  else
    ARGS+=("$arg")
  fi
done

node _utils/editor/server.mjs "${ARGS[@]}"
RC=$?

if [ $RC -ne 0 ] && [ $RC -ne 130 ]; then
  echo ""
  echo "  [x] The server exited with an error - see the message above."
  pause
fi

exit $RC
