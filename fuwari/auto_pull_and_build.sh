#!/bin/sh

# recreate /fuwari_build directory and clone /fuwari into it to avoid mount permission issues.
cd /fuwari

# del clone directory if exists
if [ -d "/tmp/source_files" ]; then
  rm -rf /tmp/source_files
fi

# clone source files from Gitea repository
echo "[`date`]Cloning repo into /tmp/source_files..."
REPO_URL="ssh://${REPO_USER_NAME}@${REPO_IP}:${REPO_SSH_PORT}/${REPO_NAME}.git"
git clone --depth=1 $REPO_URL /tmp/source_files

# move files to hexo folder.
echo "[`date`]Syncing repo files from /tmp/source_files/ to build folder..."
rsync -a --no-o --no-g --exclude='.git' --remove-source-files /tmp/source_files/ ./
rm -rf /tmp/source_files
echo "[`date`]Syncing done!..."

echo "[`date`]Starting html generation..."
pnpm build
echo "[`date`]Html generation done!"