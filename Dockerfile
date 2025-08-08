FROM alpine:3.20

# 安装 dropbear 和 bash（bash 可选）
RUN apk add --no-cache dropbear bash

# 设置 root 公钥（请替换为你自己的）
ENV SSH_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbr+E0NZokDSjt3MWeQ5ICgU9DdfIQzbzvE+QOQZ5vFzGLlmMlTLAKq5WvjnfKGUfgCSoBGZXMZ3HfQX9ClvSbnlJvD5mEyeOymb41K7K3c1AgRkOiW+veTkHsiqjLm7emx2M+W0gOw6EaCmiaJNUuaru7z9VlGQdMn/4gr2WKNdhwO3IwP+NT4sJNdcdqTH4rBmCWZTmznLbA5iD33dmsBv22X4C5Ir6eaRVRiR7LvAugEpiMMZBc7jyAWxph/SBGcQ26tCLhjkg0AxeMquwrS39UXnTDg8UPw0jJ/an6XrXG2mEr99jHz+nqDjNKfvP6PlutPfVE9VpdvYMIJeb9 root@deploy-develop"

# 写入 root 公钥
RUN mkdir -p /root/.ssh && \
    echo "$SSH_PUBKEY" > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# 创建 Dropbear 主机密钥
RUN mkdir -p /etc/dropbear && \
    dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key && \
    dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key && \
    dropbearkey -t ed25519 -f /etc/dropbear/dropbear_ed25519_host_key

# 暴露 SSH 端口
EXPOSE 22

# 启动 Dropbear（前台、记录日志、监听 22 端口）
CMD ["/usr/sbin/dropbear", "-F", "-E", "-p", "22"]
