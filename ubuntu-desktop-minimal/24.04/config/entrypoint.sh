#!/bin/bash
# ============================================
# Minimal Desktop Entrypoint with KasmVNC
# ============================================

set -e

echo "=========================================="
echo "Minimal Ubuntu Desktop - Starting Services"
echo "=========================================="

# VNC password (default: ubuntu)
VNC_PASSWORD=${VNC_PASSWORD:-ubuntu}

# ============================================
# Start SSH Server
# ============================================
echo "Starting SSH server..."
/usr/sbin/sshd

# ============================================
# Configure KasmVNC
# ============================================
echo "Configuring KasmVNC..."

# Initialize KasmVNC for the user
su - ${USER} -c "vncserver -configure ${DISPLAY}"

# Set VNC password
su - ${USER} -c "echo '${VNC_PASSWORD}' | vncpasswd -file > ~/.vnc/passwd"
chmod 600 /home/${USER}/.vnc/passwd

# ============================================
# Start KasmVNC
# ============================================
echo "Starting KasmVNC on port ${KASMVNC_PORT}..."
su - ${USER} -c "vncserver ${DISPLAY} -localhost no -cert none -plainport ${KASMVNC_PORT}"

echo "=========================================="
echo "Services started successfully!"
echo "=========================================="
echo "SSH:      ssh ${USER}@<host> -p <port>"
echo "KasmVNC:  https://<host>:${KASMVNC_PORT}"
echo "User:     ${USER}"
echo "Password: ${PASSWORD} (system), ${VNC_PASSWORD} (VNC)"
echo "=========================================="

# Keep container running
tail -f /dev/null
