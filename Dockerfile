FROM alpine:3.5

# Install OpenSSH server and Gitolite
# Unlock the automatically-created git user
RUN set -x \
 && apk add --update \
    gitolite \
    openssh \
    dumb-init \
 && rm -rf /var/cache/apk/* \
 && deluser git \
 && addgroup -g 1001 git \
 && adduser -u 1001 -G git -h /git -s /bin/sh -D git

# Volume used to store SSH host keys, generated on first run
VOLUME /etc/ssh/keys

# Volume used to store all Gitolite data (keys, config and repositories), initialized on first run
VOLUME /git
VOLUME /git/repositories

# Entrypoint responsible for SSH host keys generation, and Gitolite data initialization
COPY docker-entrypoint.sh /
ENTRYPOINT ["dumb-init"]

# Expose port 22 to access SSH
EXPOSE 22

# Default command is to run the SSH server
CMD ["/docker-entrypoint.sh", "sshd"]
