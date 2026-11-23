#!/usr/bin/env bash
#
# Install firmware blobs from the ctx directory into the root filesystem,
# tagging them as non-free Bazzite components.
#
set -xeuo pipefail

echo "::group::Install non-free firmware blobs"
trap 'echo "::endgroup::"' EXIT

# -- Copy firmware into temporary staging area --
# Extract firmware files to /tmp/firmware for processing.
echo "==> Copying firmware files..."
cp -a /ctx/firmware/. /tmp/firmware

# -- Tag firmware as non-free --
# Mark each firmware file with the 'bazzite-nonfree' component attribute.
echo "==> Tagging firmware as non-free..."
find /tmp/firmware -type f -exec setfattr -n user.component -v "bazzite-nonfree" {} +
find /tmp/firmware -type f -exec setfattr -n user.update-interval -v "yearly" {} +

# -- Remove git metadata --
# Clean up git history to keep the image size minimal.
echo "==> Removing git metadata..."
rm -rf /tmp/firmware/.git || true

# Given the circumstances, linux-firmware doesn't have the blob needed for BT to work on WiFI7+BT Boards. So I'm doing this.

echo "==> Installing BT patch for WiFI7+BT boards from MediaTek"
wget https://raw.githubusercontent.com/jetm/mediatek-mt7927-dkms/ad1f3e4d19fe540aaa1f449ddba86c65db9bfc82/download-driver.sh
chmod +x download-driver.sh
./download-driver.sh
wget https://raw.githubusercontent.com/jetm/mediatek-mt7927-dkms/ad1f3e4d19fe540aaa1f449ddba86c65db9bfc82/extract_firmware.py
chmod +x extract_firmware.py
./extract_firmware.py DRV_WiFi_MTK_MT7925_MT7927_TP_W11_64_V5603998_20250709R.zip .
mkdir /tmp/firmware/mediatek/mt7927
cp BT_RAM_CODE_MT6639_2_1_hdr.bin /tmp/firmware/mediatek/mt7927/.

# -- Install firmware into root filesystem --
# Copy processed firmware files into /usr/lib/firmware or equivalent.
echo "==> Installing firmware..."
cp -a /tmp/firmware/. /

# -- Cleanup --
rm -rf /tmp/firmware || true
