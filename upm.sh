#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo -e "\
\033[1mUniversal Package Manager\033[0m    
Usage: $0 <package> [--verbose] \
   "
  exit 1
fi

set -euo pipefail

if [[ "$@" == *"--verbose"* ]]; then
  set -x
fi

echo "♻️  Prepating environment..."

mkdir -p ~/.upm/installed/ &&
  cd ~/.upm/ || exit 1

echo "⬇️  Downloading $1..."

mkdir -p /tmp/upm || (
  echo "⚠️  Unable to create temporary directory!" && exit 1
)

cd /tmp/upm

apt-get install --print-uris "$1" | grep http | awk '{ print $1 };' | sed "s/^'//" | sed "s/'$//" | xargs wget -nc

INSTALL_PATH="$HOME/.upm/installed" # No trailing slash!

mkdir -p $INSTALL_PATH
mkdir -p $INSTALL_PATH/usr/{lib,bin,sbin}
mkdir -p $INSTALL_PATH/{lib,bin,sbin}

DEB_PATHS=$(find . -type f -name "*.deb")

for DEB_PATH in $DEB_PATHS; do {
  dpkg -x "$DEB_PATH" "$INSTALL_PATH"
}; done

ADD_TO_PATH="$INSTALL_PATH/usr/bin:$INSTALL_PATH/bin:$INSTALL_PATH/sbin:$INSTALL_PATH/usr/sbin:"
ADD_TO_LIB_PATH="$(find "$INSTALL_PATH/usr/lib" -type d | tr "\n" ":")$(find "$INSTALL_PATH/lib" -type d | tr "\n" ":")"

echo "Run this in your terminal to activate installed apps (or restart your shell): "

if ! [[ $PATH == *"$ADD_TO_PATH"* ]]; then
  echo -e "\033[94m export PATH=\"$ADD_TO_PATH\$PATH\" \033[0m"
fi

set +u
if ! [[ $LD_LIBRARY_PATH == *"$ADD_TO_LIB_PATH"* ]]; then
  echo -e "\033[94m export LD_LIBRARY_PATH=\"$ADD_TO_LIB_PATH\$LD_LIBRARY_PATH\""
fi
set -u

echo "☑️  Successfully installed $1!"

echo -n "🗑️  Cleaning up temporary files..."
rm -rf /tmp/upm/
echo " Done"

echo "♻️  Finishing..."
# Write the file that will be executed in .bashrc, .zshrc, etc.
cat > ~/.upm/run.sh <<EOL
  
EOL
