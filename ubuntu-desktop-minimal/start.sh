#!/bin/bash
# ============================================
# 快速启动脚本
# ============================================

set -e

echo "=========================================="
echo "Minimal Ubuntu Desktop - 快速启动"
echo "=========================================="

# 检查 .env 文件
if [ ! -f ".env" ]; then
    echo "创建 .env 配置文件..."
    cp .env.example .env
    echo "✓ .env 文件已创建（使用默认配置）"
fi

# 创建共享目录
SHARED_DIR="${HOME}/desktop-share"
if [ ! -d "$SHARED_DIR" ]; then
    mkdir -p "$SHARED_DIR"
    echo "✓ 共享目录已创建: $SHARED_DIR"
fi

# 构建并启动
echo ""
echo "构建并启动容器..."
docker-compose up -d --build

echo ""
echo "=========================================="
echo "启动成功！"
echo "=========================================="
echo ""
echo "访问方式："
echo ""
echo "  1. SSH 访问:"
echo "     ssh ubuntu@localhost -p ${SSH_PORT:-10022}"
echo "     密码: ${PASSWORD:-ubuntu}"
echo ""
echo "  2. VNC 客户端:"
echo "     地址: localhost:${VNC_PORT:-15901}"
echo "     密码: ${VNC_PASSWORD:-ubuntu}"
echo ""
echo "  3. Web 浏览器 (noVNC):"
echo "     地址: https://localhost:${NOVNC_PORT:-16901}"
echo "     密码: ${VNC_PASSWORD:-ubuntu}"
echo ""
echo "管理命令："
echo "  查看日志: docker-compose logs -f"
echo "  停止容器: docker-compose down"
echo "  重启容器: docker-compose restart"
echo "  进入容器: docker exec -it ubuntu-desktop bash"
echo ""
echo "共享目录: $SHARED_DIR"
echo "=========================================="
