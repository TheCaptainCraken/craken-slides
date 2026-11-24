#!/bin/sh
# Installs the Captain Craken slides for Typst (Linux and macOS):
#   • the package, so `@preview/craken-slides:0.1.0` works offline and `typst init` can start new talks
#   • the fonts, so you never need --font-path
# Run it again after updating the template; it overwrites the old copy.
# It installs into the preview namespace, so the template's @preview imports
# work offline too (Typst checks this folder before downloading).
#
# DM Mono and STIX Two Math are skipped when they are already installed (the
# Captain Craken book template ships its own copies), so the two templates
# never fight over the same family name.
set -e
here="$(cd "$(dirname "$0")" && pwd)"

case "$(uname)" in
  Darwin) data="$HOME/Library/Application Support"; fonts="$HOME/Library/Fonts/craken-slides" ;;
  *)      data="${XDG_DATA_HOME:-$HOME/.local/share}"; fonts="$data/fonts/craken-slides" ;;
esac
dest="$data/typst/packages/preview/craken-slides/0.1.0"

mkdir -p "$dest" "$fonts"
if [ "$here" != "$(cd "$dest" && pwd)" ]; then cp -R "$here/." "$dest/"; fi

for f in "$here"/fonts/*.ttf; do
  case "$(basename "$f")" in
    DMMono-*)      family="DM Mono" ;;
    STIXTwoMath-*) family="STIX Two Math" ;;
    *)             family="" ;;
  esac
  if [ -n "$family" ] && command -v fc-list >/dev/null 2>&1 && fc-list "$family" | grep -q .; then
    continue
  fi
  cp "$f" "$fonts/"
done
if command -v fc-cache >/dev/null 2>&1; then fc-cache -f "$fonts" >/dev/null; fi

echo "Captain Craken slides installed."
echo "  package: $dest"
echo "  fonts:   $fonts"
echo
echo "Start a new talk with:"
echo "  typst init @preview/craken-slides:0.1.0 my-talk"
