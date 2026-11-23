# QuickCrate

A small WoW Forever addon that fills Waylaid Crates and applies Forged Delivery Receipts with one click each.

## Use

- `/qc` or `/quickcrate` opens or closes the window.
- The window also opens when you right-click a Waylaid Crate or a Forged Delivery Receipt in your bags.
- Each crate row says what the next fill uses, for example "Fills with 20× Tin Ore". If your bags can't cover any bundle, it says what's missing and Fill is greyed out.
- With receipts in your bags, each crate row gets a Receipt button that puts one receipt on that crate.
- Unlabelled crates and other "Waylaid" items QuickCrate doesn't know are listed as "Fill by hand".
- The window can't open or close during combat. `/qc` in combat opens it as soon as combat ends.

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
