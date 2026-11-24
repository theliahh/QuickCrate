#!/usr/bin/env bash
# Prepares a release commit and tag for the commit just merged to main.
#
# Version: package.version in wowlua.json is released as it is if it has no
# v<version> tag yet (so a hand-made minor or major bump is kept); otherwise
# the patch number goes up by one.
# Changelog: the "## Unreleased" section of CHANGELOG.md becomes the
# version's section. With no Unreleased entries, the merged commit's title is
# the entry.
#
# Prints the version on stdout. Leaves the commit and tag local; the workflow
# pushes them.
set -euo pipefail

manifest=wowlua.json
changelog=CHANGELOG.md

current=$(sed -n 's/^    "version": "\([0-9]*\.[0-9]*\.[0-9]*\)",\{0,1\}$/\1/p' "$manifest" | head -n 1)
if [ -z "$current" ]; then
    echo "prepare-release: no package.version in $manifest" >&2
    exit 1
fi

if git rev-parse -q --verify "refs/tags/v$current" > /dev/null; then
    IFS=. read -r major minor patch <<< "$current"
    version="$major.$minor.$((patch + 1))"
else
    version=$current
fi
if git rev-parse -q --verify "refs/tags/v$version" > /dev/null; then
    echo "prepare-release: tag v$version already exists" >&2
    exit 1
fi

sed -i "0,/^    \"version\": \"$current\"/s//    \"version\": \"$version\"/" "$manifest"

# The entries under "## Unreleased", up to the next "## " heading.
entries=$(awk '/^## /{inside = ($0 == "## Unreleased"); next} inside && NF' "$changelog")
if [ -z "$entries" ]; then
    entries="- $(git log -1 --format=%s)"
fi

# Rewrite: drop the Unreleased section, then put the new version's section
# above the first remaining "## " heading (or at the end).
awk -v version="$version" -v entries="$entries" '
    function emit() { print "## " version; print ""; print entries; print ""; done = 1 }
    /^## Unreleased$/ { skipping = 1; next }
    /^## / { skipping = 0; if (!done) emit() }
    skipping { next }
    { print }
    END { if (!done) { print ""; emit() } }
' "$changelog" > "$changelog.new"
# Squeeze the blank lines the removed section leaves behind.
cat -s "$changelog.new" > "$changelog"
rm "$changelog.new"

git add "$manifest" "$changelog"
git commit -q -m "Release $version"
git tag "v$version"
echo "$version"
