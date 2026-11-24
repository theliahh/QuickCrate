# QuickCrate

A small WoW Forever addon that fills Waylaid Crates and applies Forged Delivery Receipts with one click each.

## Use

- `/qc` or `/quickcrate` opens or closes the window.
- The window also opens when you right-click a Waylaid Crate or a Forged Delivery Receipt in your bags.
- Each crate row says what the next fill uses, for example "Fills with 20× Tin Ore". If your bags can't cover any bundle, it says what's missing and Fill is greyed out.
- Fill uses the crate and puts that material in with one click. If the crate takes a moment before asking for the material, the button changes to "Put in": click it again to finish.
- With receipts in your bags, each crate row gets a Receipt button that puts one receipt on that crate.
- Unlabelled crates and other "Waylaid" items QuickCrate doesn't know are listed as "Fill by hand".
- Esc closes the window (and the settings window with it), like Blizzard's own panels.
- The window can't open or close during combat, so Esc leaves it alone while you're fighting. `/qc` in combat opens it as soon as combat ends.

## Skins

Click the cogwheel next to the close button to open the settings window, then pick a skin from the dropdown: **Metal** (the default), **Portrait**, **Parchment**, **Slate** or **Plain**. The window changes straight away, and the choice is remembered for every character. A skin picked during combat takes effect when combat ends.

To see every skin without starting the game, run `wowlua test gallery --game-data`. It saves a screenshot per skin to `dist/screenshots/gallery.test.wowlua/`.

## Checking the game's behavior

`/qc debug` lists every Waylaid item and receipt in your bags with its item ID, slot and use spell.
`/qc debug log` toggles logging of spellcast, gossip and popup events, to see what the game does when a crate or receipt is used.

## Development

Built with [wowlua](https://github.com/DomenikIrrgang/wowlua) for the `camelot` (WoW Forever) flavor.

```sh
wowlua test
```

```sh
wowlua dev
```

`wowlua dev` installs the addon into the game's `AddOns/QuickCrate` folder and rebuilds it on every save. `/reload` in game to pick up changes.

## Releasing

GitHub Actions (`.github/workflows/ci.yml`) checks, tests and builds every pull request and every push to `main`. **Every merge to `main` is a full release**, uploaded to every enabled target in `wowlua.json` under `publish.targets` (CurseForge and GitHub). After the tests pass, `.github/scripts/prepare-release.sh` does the following:

- **Version:** if `package.version` has no `v<version>` tag yet, that version is released as it is. Otherwise the patch number goes up by one. To release a minor or major version, set `package.version` to it in the pull request.
- **Release notes:** the entries under `## Unreleased` in `CHANGELOG.md` become the new version's section. With no entries there, the merged commit's title is the one entry. Add a line under `## Unreleased` in each pull request to write the notes yourself.
- **Commit and tag:** it commits "Release <version>" to `main`, tags it `v<version>`, pushes both, and publishes.

Pull local `main` after a merge to get the release commit.

A `v*` tag pushed by hand still publishes, for a release outside this flow. The tag must match `package.version`, or the build stops. A tag containing `alpha` or `beta` is uploaded as that release type.

`wowlua publish --dry-run` builds and packages everything and shows what each site would receive, without uploading. The zip goes to `dist/packages/`. It contains only the generated TOC, the bundled Lua and a license notice: no docs, tests or source files.

### CurseForge setup

The `curseforge` target uploads to CurseForge project 1827165. It needs a CurseForge API token, created at <https://legacy.curseforge.com/account/api-tokens> and saved in the GitHub repository's secrets as `CF_API_TOKEN` (Settings → Secrets and variables → Actions).

The project page's description is kept in `CURSEFORGE.md`, to paste into CurseForge's description editor.
