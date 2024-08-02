#!/bin/bash

# Define variables
XKB_LAYOUT_FILE="bn"
XKB_LAYOUT_NAME="bn"
SHORT_DESCRIPTION="bd"
DESCRIPTION="Bangla (Unijoy)"
ISO3166ID="BD"
ISO639ID="ben"

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Copy the custom XKB layout file to the appropriate directory
echo -e "${YELLOW}Copying the custom XKB layout file to /usr/share/X11/xkb/symbols/...${NC}"
sudo cp $XKB_LAYOUT_FILE /usr/share/X11/xkb/symbols/

# Check if the file was copied successfully
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to copy the custom XKB layout file. Exiting.${NC}"
    exit 1
fi

# Edit the evdev.xml file to include the new layout
EVDEV_XML="/usr/share/X11/xkb/rules/evdev.xml"

echo -e "${YELLOW}Editing $EVDEV_XML to include the new layout...${NC}"
sudo sed -i "/<\/layoutList>/i \
  <layout>\n\
    <configItem>\n\
      <name>$XKB_LAYOUT_NAME</name>\n\
      <!-- Keyboard indicator for Bangla layouts -->\n\
      <shortDescription>$SHORT_DESCRIPTION</shortDescription>\n\
      <description>$DESCRIPTION</description>\n\
      <countryList>\n\
        <iso3166Id>$ISO3166ID</iso3166Id>\n\
      </countryList>\n\
      <languageList>\n\
        <iso639Id>$ISO639ID</iso639Id>\n\
      </languageList>\n\
    </configItem>  \n\
  </layout>" $EVDEV_XML

# Check if the evdev.xml file was edited successfully
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to edit $EVDEV_XML. Exiting.${NC}"
    exit 1
fi

echo -e "${GREEN}The custom XKB layout has been integrated successfully.${NC}"
echo -e "${YELLOW}You can set the layout temporarily using: setxkbmap $XKB_LAYOUT_NAME${NC}"
echo -e "${YELLOW}Reboot your system or restart your Xorg session to apply the changes.${NC}"
