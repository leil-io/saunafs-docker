#! /bin/bash

set -e # Exit on error

TARGET_CONF_DIR="/etc/saunafs"
DEFAULT_CONF_SRC_DIR="/usr/share/doc/saunafs-metalogger/examples"
TARGET_DATA_DIR="/var/lib/saunafs"
SAUNAFS_USER="saunafs"

echo "Ensuring SaunaFS Metalogger directories and configurations..."

mkdir -p "${TARGET_CONF_DIR}"

# Check if main config file exists, if not, copy the default
if [ ! -f "${TARGET_CONF_DIR}/sfsmetalogger.cfg" ]; then
	echo "'${TARGET_CONF_DIR}/sfsmetalogger.cfg' not found. Copying default configuration from '${DEFAULT_CONF_SRC_DIR}'..."
	if [ -f "${DEFAULT_CONF_SRC_DIR}/sfsmetalogger.cfg" ]; then
		cp -v "${DEFAULT_CONF_SRC_DIR}/sfsmetalogger.cfg" "${TARGET_CONF_DIR}/sfsmetalogger.cfg"
		echo "Default sfsmetalogger.cfg copied."
	else
		echo "ERROR: Default configuration source file '${DEFAULT_CONF_SRC_DIR}/sfsmetalogger.cfg' does not exist."
		exit 1
	fi
else
	echo "Existing '${TARGET_CONF_DIR}/sfsmetalogger.cfg' found."
fi

mkdir -p "${TARGET_DATA_DIR}"

# Set ownership
echo "Setting final ownership for '${TARGET_CONF_DIR}' and '${TARGET_DATA_DIR}' to '${SAUNAFS_USER}'..."
chown -R "${SAUNAFS_USER}:${SAUNAFS_USER}" "${TARGET_CONF_DIR}"
chown -R "${SAUNAFS_USER}:${SAUNAFS_USER}" "${TARGET_DATA_DIR}"

echo "Starting SaunaFS Metalogger..."
# Replace shell with sfsmetalogger process
exec sfsmetalogger -d -u start
