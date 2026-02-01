# Minimal Ubuntu Desktop for Remote Debugging

极简、纯净的 Ubuntu 桌面 Docker 镜像，专为远程调试设计。

## 特性

- **极简纯净**: 从零构建，只安装必要组件
- **最新 Ubuntu**: 基于 Ubuntu 24.04 Server（可选用其他版本）
- **xfce4 桌面**: 轻量级桌面环境
- **双浏览器支持**: Firefox + Google Chrome
- **多种远程访问方式**:
  - SSH (端口 22)
  - VNC (端口 5901)
  - noVNC Web 界面 (端口 6901)
- **无多余组件**: 不包含 NoMachine、KasmVNC、code-server 等额外软件

## 组件清单

### 核心组件（最小化安装）
- xfce4 桌面环境
- TigerVNC Server
- noVNC (Web VNC 客户端)
- OpenSSH Server
- Google Chrome
- 字体和基础 X11 组件

### 不包含的组件
- NoMachine
- KasmVNC
- code-server
- CUDA
- 其他不必要的工具和插件

## 快速开始

### 构建镜像

```bash
# 使用 Ubuntu 24.04（默认）
./docker_build.sh

# 使用其他版本
./docker_build.sh 22.04
./docker_build.sh 20.04
```

### 运行容器

```bash
docker run -d --restart=unless-stopped \
    --name my-desktop \
    -p 10022:22 \
    -p 15901:5901 \
    -p 16901:6901 \
    ubuntu-desktop-minimal:24.04
```

### 访问桌面

#### 方式 1: SSH
```bash
ssh ubuntu@<your-host> -p 10022
# 密码: ubuntu
```

#### 方式 2: VNC 客户端
- 地址: `<your-host>:15901`
- 密码: `ubuntu`
- 推荐客户端: Remmina, TigerVNC, RealVNC

#### 方式 3: Web 浏览器 (noVNC)
- 地址: `https://<your-host>:16901`
- 密码: `ubuntu`
- 推荐使用 Chrome 浏览器访问

## 自定义配置

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `USER` | ubuntu | 用户名 |
| `PASSWORD` | ubuntu | 用户密码 |
| `VNC_PASSWORD` | ubuntu | VNC 密码 |
| `TZ` | Asia/Shanghai | 时区 |

### 示例：自定义用户和密码

```bash
docker run -d --name my-desktop \
    -p 10022:22 -p 15901:5901 -p 16901:6901 \
    -e USER=developer \
    -e PASSWORD=mypassword \
    -e VNC_PASSWORD=vncpass \
    ubuntu-desktop-minimal:24.04
```

## 目录结构

```
ubuntu-desktop-minimal/
├── 24.04/
│   ├── Dockerfile          # Docker 镜像定义
│   └── config/
│       ├── vncxstartup     # VNC 启动脚本
│       └── entrypoint.sh   # 容器入口脚本
└── docker_build.sh         # 构建脚本
```

## 技术细节

### Dockerfile 构建步骤

1. **系统更新和基础依赖** - 安装最小必需包
2. **SSH Server** - 远程命令行访问
3. **xfce4 桌面** - 轻量级图形界面
4. **TigerVNC Server** - VNC 服务
5. **noVNC** - Web VNC 客户端
6. **Google Chrome** - Chrome 浏览器
7. **用户配置** - 创建用户和权限
8. **VNC 配置** - 设置密码和启动脚本

### 安全说明

- 默认密码仅供测试使用，生产环境请务必修改
- 建议配合 SSH 密钥认证使用
- Web VNC 连接未启用 HTTPS（需自行配置证书）

## 与原项目对比

| 特性 | 原项目 | 极简版 |
|------|--------|--------|
| 远程桌面 | NoMachine, KasmVNC, noVNC | VNC + noVNC |
| 编辑器 | code-server | 无（可自行安装） |
| CUDA | 支持 | 不支持 |
| 体积 | ~2-3GB | ~1-1.5GB |
| 组件数量 | 较多 | 最小化 |

## 故障排除

### VNC 连接失败
检查容器日志:
```bash
docker logs my-desktop
```

### Chrome 无法启动
添加 `--no-sandbox` 参数:
```bash
google-chrome --no-sandbox
```

### 中文显示乱码
进入容器安装中文字体:
```bash
docker exec -it my-desktop bash
apt-get update && apt-get install -y fonts-wqy-zenhei
```

## License

MIT

## 作者

temple <temple@iobond.com>
