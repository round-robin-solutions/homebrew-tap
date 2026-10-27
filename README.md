# Homebrew tap for Round Robin

Casks published by [Round Robin](https://roundrobin.in).

## Bridgey by Round Robin

[Bridgey by Round Robin](https://github.com/round-robin-solutions/bridgey) connects an Android phone
and a Mac over your own Wi-Fi. This cask installs the Mac app.

```sh
brew install --cask round-robin-solutions/tap/bridgey-rr
```

That taps this repository and installs `Bridgey by Round Robin.app` into `/Applications`. The app
needs macOS 13 (Ventura) or later.

To remove it:

```sh
brew uninstall --cask bridgey-rr          # keep settings and paired devices
brew uninstall --cask --zap bridgey-rr    # also delete them
```

### How updates work

The app updates itself. In-app updates use Sparkle with an EdDSA signature check, on the channel you
choose in Settings (Stable, Beta or Nightly), so the cask declares `auto_updates true`. Plain
`brew upgrade` skips the cask for that reason; use `brew upgrade --cask --greedy bridgey-rr` if you
prefer Homebrew to do it.

The cask itself is pinned to one release (a `version` and a `sha256`). It is updated after each
release by `scripts/rr/bump-cask.py` in the Bridgey repository, so a fresh `brew install` gets a
recent build, and the app then keeps itself current.

### Which release the cask points at

The cask points at the newest Stable release. No Stable release exists yet, so for now it points at
the newest beta (currently `0.6.0-rr.1-beta.13`). This note goes away when the first Stable release
is out. Beta releases are pinned only when the release is made with `--bump-cask`.

### Ad-hoc signing and the quarantine flag

The Mac app is ad-hoc signed: Round Robin has no Apple Developer membership yet, so it is not
notarised. A quarantined copy would be stopped by Gatekeeper on first launch. The cask therefore
runs `xattr -dr com.apple.quarantine` on the installed app in its `postflight` step. That removes
only the download flag from this one app. The download is still checked against the `sha256` in the
cask. If you would rather keep Gatekeeper's prompt, install the DMG by hand from the
[releases page](https://github.com/round-robin-solutions/bridgey/releases), then right-click the app
and choose **Open**.

### What `zap` removes

`~/Library/Application Support/in.roundrobin.bridgey`, `~/Library/Caches/in.roundrobin.bridgey`,
`~/Library/Preferences/in.roundrobin.bridgey.plist`, and the app's HTTP storage, WebKit and saved
window state.

## Licence

The cask files are MIT licensed, like Bridgey.
