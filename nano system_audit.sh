#!/usr/bin/env bash

# ==========================================================
# SYSTEM SECURITY + ENVIRONMENT AUDIT
# Author: You
# Purpose:
#   One-command visibility into system security posture,
#   services, encryption, and tooling state.
# ==========================================================

echo "========================================="
echo " SYSTEM AUDIT START"
echo "========================================="
echo

# ---------- Root Check ----------
if [ "$EUID" -ne 0 ]; then
    echo "[!] Not running as root"
    echo "[*] Some checks may be limited"
else
    echo "[OK] Running as root"
fi
echo

# ---------- OS Info ----------
echo "---- OS INFO ----"
uname -a
lsb_release -a 2>/dev/null
echo

# ---------- AppArmor ----------
echo "---- APPARMOR STATUS ----"
if command -v aa-status >/dev/null 2>&1; then
    aa-status
else
    echo "[!] AppArmor not installed"
fi
echo

# ---------- Firewall ----------
echo "---- FIREWALL STATUS ----"

if command -v ufw >/dev/null 2>&1; then
    ufw status verbose
else
    echo "[!] UFW not installed"
fi

echo
echo "IPTABLES RULES:"
iptables -L -n -v 2>/dev/null
echo

# ---------- Fail2Ban ----------
echo "---- FAIL2BAN STATUS ----"

if command -v fail2ban-client >/dev/null 2>&1; then
    fail2ban-client status
else
    echo "[!] Fail2Ban not installed"
fi
echo

# ---------- Disk + Encryption ----------
echo "---- DISK & MOUNTS ----"
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,TYPE
echo

echo "---- LUKS DEVICES ----"
lsblk -f | grep -i luks
echo

# ---------- Memory ----------
echo "---- MEMORY ----"
free -h
echo

# ---------- CPU Load ----------
echo "---- CPU LOAD ----"
uptime
echo

# ---------- Running Security Services ----------
echo "---- SECURITY SERVICES ----"
systemctl list-units --type=service | grep -E "apparmor|fail2ban|ufw"
echo

# ---------- VeraCrypt ----------
echo "---- VERACRYPT ----"
if command -v veracrypt >/dev/null 2>&1; then
    echo "[OK] VeraCrypt installed"
else
    echo "[!] VeraCrypt NOT installed"
fi
echo

# ---------- Updates ----------
echo "---- PACKAGE UPDATES ----"
apt list --upgradable 2>/dev/null | head
echo

echo "========================================="
echo " AUDIT COMPLETE"
echo "========================================="
