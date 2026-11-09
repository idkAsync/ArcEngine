#!/bin/bash
# ==========================================================================
#  ArcEngine - code check: types (tsc via npx) and unit tests (node --test)
#
#    check.command            -> types and tests
#    check.command --types    -> types only
#    check.command --tests    -> tests only
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
  echo "  [x] Node.js not found in PATH. Install it from https://nodejs.org/"
  echo ""
  pause
  exit 1
fi

node tools/check.mjs "$@"
RC=$?

echo ""
pause
exit $RC
