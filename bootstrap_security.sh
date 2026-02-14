#!/usr/bin/env bash

###############################################################################
# README — SECURITY BASELINE BOOTSTRAP
#
# Purpose:
# Rebuild a hardened Linux workstation with encryption tools, monitoring,
# intrusion prevention, and admin utilities.
#
# What this installs:
# - VeraCrypt (portable encryption)
# - Fail2ban (intrusion prevention)
# - AppArmor utilities
# - Network analysis tools
# - System monitoring tools
# - Logging utilities
# - Developer essentials
#
# Usage:
#   sudo bash bootstrap_security.sh
#
# Safe to re-run:
#   Yes — package installs are idempotent.
#
###############################################################################

set -e

echo "[+] Starting Security Bootstrap..."

# ---------- System Update ----------
echo "[+] Updating system..."
apt update && apt upgrade -y

# ---------- Core Tools ----------
echo "[+] Installing base utilities..."
apt install -y \
    curl wget git build-essential \
    net-tools htop btop tree \
    ufw gufw \
    python3 python3-pip \
    vim nano

# ---------- Security Tools ----------
echo "[+] Installing security tools..."
apt install -y \
    fail2ban \
    apparmor apparmor-utils apparmor-profiles \
    auditd audispd-plugins \
    rkhunter \
    chkrootkit

# ---------- Network Tools ----------
echo "[+] Installing network tools..."
apt install -y \
    nmap \
    tcpdump \
    wireshark \
    iptables \
    iptables-persistent \
    traceroute \
    dnsutils

# ---------- Enable Services ----------
echo "[+] Enabling services..."
systemctl enable fail2ban
systemctl start fail2ban

systemctl enable auditd
systemctl start auditd

# ---------- VeraCrypt Install ----------
echo "[+] Installing VeraCrypt..."

cd /tmp

VERA_URL="https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Ubuntu-24.04-amd64.deb"

wget -q $VERA_URL -O veracrypt.deb
apt install -y ./veracrypt.deb

echo "[+] VeraCrypt Version:"
veracrypt --version || true

# ---------- Firewall ----------
echo "[+] Configuring firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw --force enable

# ---------- Final ----------
echo ""
echo "[✓] Bootstrap Complete"
echo ""
echo "Next Steps:"
echo "1. Reboot recommended"
echo "2. Create VeraCrypt containers"
echo "3. Configure Fail2ban rules"
echo ""

