#!/bin/sh
set -euo pipefail

: "${GIT_USER_NAME:?"GIT_USER_NAME is not set"}"
: "${GIT_USER_EMAIL:?"GIT_USER_EMAIL is not set"}"
: "${REPO_USER_NAME:?"REPO_USER_NAME is not set"}"
: "${REPO_IP:?"REPO_IP is not set"}"
: "${REPO_NAME:?"REPO_NAME is not set"}"

# restore /fuwari (mount point) from backup if .delete_me_to_restore not exist.
echo "[`date`]Repo URL is ssh://${REPO_USER_NAME}@${REPO_IP}:${REPO_SSH_PORT}/${REPO_NAME}.git"

echo "[`date`]Writing into /fuwari folder, may take a while..."
if [ ! -f "/fuwari/.delete_me_to_restore" ]; then
  cd /fuwari && rm -rf ./* .[!.]* && \
  tar -xJf /fuwari_backup.tar.xz -C /fuwari
fi
echo "[`date`]Writing /fuwari folder done!"

# Autodeploy if All environment variables are set.
export WILL_DEPLOY="0";
if [ -z "$DEPLOY_USER_NAME" ] || [ -z "${DEPLOY_IP}" ] || [ -z "${DEPLOY_FOLDER}" ]; then
  echo "[`date`]Deployment is not fully configured. Skipping deployment setup."; \
else
  echo "[`date`]Deployment is configured,remote URL=ssh://${DEPLOY_USER_NAME}@${DEPLOY_IP}:${DEPLOY_FOLDER}";
  export WILL_DEPLOY="1";
fi

# Setup git.
git config --global user.name ${GIT_USER_NAME}
git config --global user.email ${GIT_USER_EMAIL}

# Setup ssh.
/usr/local/bin/ssh_setup.sh

exec "/usr/local/bin/webhook_listener.sh"