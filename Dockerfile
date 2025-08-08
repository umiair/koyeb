FROM alpine:3.20

RUN apk add --no-cache dropbear bash

# 创建 SSH 用户
RUN adduser -D testuser && \
    mkdir -p /home/testuser/.ssh && \
    chown -R testuser:testuser /home/testuser/.ssh

# 设置 SSH 公钥
ENV SSH_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbr+E0NZokDSjt3MWeQ5ICgU9DdfIQzbzvE+QOQZ5vFzGLlmMlTLAKq5WvjnfKGUfgCSoBGZXMZ3HfQX9ClvSbnlJvD5mEyeOymb41K7K3c1AgRkOiW+veTkHsiqjLm7emx2M+W0gOw6EaCmiaJNUuaru7z9VlGQdMn/4gr2WKNdhwO3IwP+NT4sJNdcdqTH4rBmCWZTmznLbA5iD33dmsBv22X4C5Ir6eaRVRiR7LvAugEpiMMZBc7jyAWxph/SBGcQ26tCLhjkg0AxeMquwrS39UXnTDg8UPw0jJ/an6XrXG2mEr99jHz+nqDjNKfvP6PlutPfVE9VpdvYMIJeb9 root@deploy-develop"

RUN echo "$SSH_PUBKEY" > /home/testuser/.ssh/authorized_keys && \
    chmod 600 /home/testuser/.ssh/authorized_keys && \
    chown testuser:testuser /home/testuser/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/dropbear", "-F", "-E", "-p", "22"]
