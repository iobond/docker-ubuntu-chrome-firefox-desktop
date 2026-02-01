#!/bin/bash
# ============================================
# Minimal Desktop Entrypoint
# ============================================

set -e

echo "=========================================="
echo "Minimal Ubuntu Desktop - Starting Services"
echo "=========================================="

# VNC password (default: ubuntu)
VNC_PASSWORD=${VNC_PASSWORD:-ubuntu}

# Configure VNC password for user
echo "Configuring VNC..."
su - ${USER} -c "echo '${VNC_PASSWORD}' | vncpasswd -f > /home/${USER}/.vnc/passwd"
chmod 600 /home/${USER}/.vnc/passwd

# Start SSHD
echo "Starting SSH server..."
/usr/sbin/sshd

# Start VNC server
echo "Starting VNC server on display ${DISPLAY}..."
su - ${USER} -c "vncserver ${DISPLAY} -geometry 1920x1080 -depth 24"

# Start noVNC (web-based VNC client)
echo "Starting noVNC on port ${NOVNC_PORT}..."
/usr/share/novnc/utils/launch.sh --vnc localhost:${VNC_PORT} --listen ${NOVNC_PORT} &

echo "=========================================="
echo "Services started successfully!"
echo "=========================================="
echo "SSH:      ssh ${USER}@<host> -p <port>"
echo "VNC:      <host>:${VNC_PORT}"
echo "noVNC:    https://<host>:${NOVNC_PORT}"
echo "User:     ${USER}"
echo "Password: ${PASSWORD}"
echo "=========================================="

# Keep container running
tail -f /dev/null
