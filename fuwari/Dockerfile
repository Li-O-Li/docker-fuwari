# Stage 1: build and compress Fuwari
FROM node:22-alpine AS builder

WORKDIR /fuwari

RUN apk add --no-cache git bash curl socat openssh rsync xz \
 && npm install -g pnpm \
 && mkdir -p /root/.ssh \
 && ssh-keyscan -p 22 github.com >> /root/.ssh/known_hosts 2>/dev/null \
 && git clone https://github.com/saicaca/fuwari.git . \
 && pnpm install \
 && touch .delete_me_to_restore \
 && tar -cJf /fuwari_backup.tar.xz .

# Stage 2: Clean runtime image
FROM node:22-alpine

# copy compressed backup and known_hosts
RUN mkdir -p /root/.ssh
COPY --from=builder /fuwari_backup.tar.xz /fuwari_backup.tar.xz
COPY --from=builder /root/.ssh/known_hosts /root/.ssh/known_hosts
# install runtime dependencies
RUN apk add git bash curl socat openssh rsync xz \
    && npm install -g pnpm

# copy scripts.
COPY auto_deploy.sh auto_pull_and_build.sh handle_webhook.sh entry.sh ssh_setup.sh webhook_listener.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/auto_deploy.sh && \
    chmod +x /usr/local/bin/auto_pull_and_build.sh && \
    chmod +x /usr/local/bin/handle_webhook.sh && \
    chmod +x /usr/local/bin/entry.sh && \
    chmod +x /usr/local/bin/ssh_setup.sh && \
    chmod +x /usr/local/bin/webhook_listener.sh

# default workdir
WORKDIR /fuwari

# setup environment.
ENV REPO_SSH_PORT="22"
ENV DEPLOY_SSH_PORT="22"

# start entrance script
ENTRYPOINT ["/usr/local/bin/entry.sh"]
