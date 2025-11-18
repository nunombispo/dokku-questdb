#!/bin/bash
# Script to fix file permissions for Dokku plugin
# 
# USAGE:
#   1. Copy this script to your Dokku server
#   2. Navigate to the plugin directory: cd /var/lib/dokku/plugins/enabled/questdb
#   3. Run: sudo bash fix-permissions.sh
#
# OR run directly from plugin root:
#   sudo bash /var/lib/dokku/plugins/enabled/questdb/fix-permissions.sh

set -e

PLUGIN_DIR="${1:-$(pwd)}"
cd "$PLUGIN_DIR"

echo "Fixing permissions for Dokku plugin files in: $PLUGIN_DIR"

# Make main plugin files executable
chmod +x install
chmod +x commands
chmod +x functions
chmod +x config
chmod +x common-functions
chmod +x help-functions
chmod +x service-list
[ -f update ] && chmod +x update

# Make hook files executable
[ -f pre-start ] && chmod +x pre-start
[ -f pre-delete ] && chmod +x pre-delete
[ -f pre-restore ] && chmod +x pre-restore
[ -f post-app-clone-setup ] && chmod +x post-app-clone-setup
[ -f post-app-rename-setup ] && chmod +x post-app-rename-setup

# Make all subcommands executable
if [ -d subcommands ]; then
    chmod +x subcommands/*
fi

# Make scripts executable
if [ -d scripts ]; then
    chmod +x scripts/*.sh 2>/dev/null || true
fi

if [ -d tests ]; then
    chmod +x tests/*.sh 2>/dev/null || true
    chmod +x tests/*.bash 2>/dev/null || true
fi

echo "✓ Permissions fixed successfully!"
echo ""
echo "You can now test the plugin with:"
echo "  dokku questdb:help"

