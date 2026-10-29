#!/bin/sh
# Pull the pieces the page uses out of a Figma developer-handoff folder
# into img/, converted to WebP. Needs ImageMagick (convert) with WebP.
#
#   scripts/import-assets.sh ~/candybot-developer-handoff-v2
set -e
HANDOFF=${1:?usage: import-assets.sh <handoff folder>}
cd "$(dirname "$0")/.."
mkdir -p img

PNGS="trick or treat ghost robots-title-complete
date-paper-texture address-paper-texture fairy-robot-sticker-full
vampire-robot-sticker-full lollipop wrapped-candy-purple
wrapped-candy-striped bat-upper bat-lower candy-corn-upper candy-corn-lower"
for name in $PNGS; do
  convert "$HANDOFF/assets/png/$name.png" -quality 85 \
    -define webp:alpha-quality=90 "img/$name.webp"
done

for name in orange-glow-middle orange-glow-lower-right orange-glow-footer; do
  cp "$HANDOFF/assets/svg/$name.svg" img/
done

# The torn black paper becomes an opaque tile for the header background
# plus a strip holding just the torn edge (rows 636 to 901 of 1060).
convert "$HANDOFF/assets/png/torn-black-paper.png" -crop 1190x636+0+0 \
  +repage -quality 80 img/paper-tile.webp
convert "$HANDOFF/assets/png/torn-black-paper.png" -crop 1190x265+0+636 \
  +repage -quality 85 -define webp:alpha-quality=90 img/tear-edge.webp

# The poster's grunge overlay sits at 35% color-burn, rotated -90 degrees.
# Pre-rotate it and lighten it so the page can blend it at full opacity.
convert "$HANDOFF/assets/originals/texture-grunge-221L.jpeg" -rotate -90 \
  -resize 1000x -fill white -colorize 60% -quality 45 -strip img/grunge.jpg

cp "$HANDOFF/reference/poster.png" poster.png
echo "imported into img/ and poster.png"
