#!/bin/sh

KEY_PATH="/root/.ssh/id_ed25519"
mkdir -p /root/.ssh
# Generate SSH Key.
if [ ! -f "$KEY_PATH" ]; then
  echo "[`date`] Generating SSH key pair..."
  ssh-keygen -t ed25519 -N "" -f "$KEY_PATH" > /dev/null

  # read using docker logs.
  echo "[`date`] SSH key pair generated at $KEY_PATH. "
else
  echo "[`date`] SSH key pair already exists at $KEY_PATH, skipping generation."
fi

echo "public key="
cat ${KEY_PATH}.pub
echo

# Add repo keys and deploy server keys(if configured) to known host.
if [ -f "/root/.ssh/known_hosts" ]; then 
  rm -f /root/.ssh/known_hosts
fi
touch /root/.ssh/known_hosts
ssh-keyscan -p $REPO_SSH_PORT $REPO_IP >> /root/.ssh/known_hosts 2>/dev/null
echo "[`date`]Added Repo server keys to known hosts."
if [ "$WILL_DEPLOY" = "1" ]; then
  ssh-keyscan -p $DEPLOY_SSH_PORT $DEPLOY_IP >> /root/.ssh/known_hosts 2>/dev/null
  echo "[`date`]Added Deploy server keys to known hosts."
fi
sort -u /root/.ssh/known_hosts -o /root/.ssh/known_hosts
echo "[`date`]SSH setup completed."
echo
