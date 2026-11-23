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

GitHub Actions (`.github/workflows/ci.yml`) checks, tests and builds every push to `main` and every pull request. When a `v*` tag is pushed, it also runs `wowlua publish`, which uploads the release to every enabled target in `wowlua.json` under `publish.targets`. The release notes are the section of `CHANGELOG.md` whose heading matches the version.

1. Set `package.version` in `wowlua.json`, and add a `## <version>` section to `CHANGELOG.md`.
2. Commit, then tag and push. The tag must match the version, or the build stops:

   ```sh
   git tag v0.2.0
   git push origin main v0.2.0
   ```

A tag containing `alpha` or `beta` is uploaded as that release type. Any other tag is a full release.

`wowlua publish --dry-run` builds and packages everything and shows what each site would receive, without uploading. The zip goes to `dist/packages/`. It contains only the generated TOC, the bundled Lua and a license notice: no docs, tests or source files.

### CurseForge setup

The `curseforge` target is a placeholder and is turned off. To turn it on:

1. Create the project on CurseForge and copy its project ID from the project page.
2. In `wowlua.json`, set the target's `project-id` to that number and remove `"enabled": false`.
3. Create an API token at <https://legacy.curseforge.com/account/api-tokens>, and add it to the GitHub repository's secrets as `CF_API_TOKEN` (Settings → Secrets and variables → Actions).
