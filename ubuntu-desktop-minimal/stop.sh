#!/bin/bash
# ============================================
# 停止并清理
# ============================================

echo "停止容器..."
docker-compose down

echo "✓ 容器已停止"
echo ""
echo "如需删除数据卷，请运行:"
echo "  docker-compose down -v"
