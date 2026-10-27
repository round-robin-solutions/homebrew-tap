cask "bridgey-rr" do
  version "0.6.0-rr.1-beta.13"
  sha256 "fe7652de8aba3e0e7fb32feb0adaf96396f34e4a0cd75c8aa6b6a3d2391a3e13"

  url "https://github.com/round-robin-solutions/bridgey/releases/download/v#{version}/Bridgey-RR-#{version}-macOS.dmg",
      verified: "github.com/round-robin-solutions/bridgey/"
  name "Bridgey by Round Robin"
  desc "Connects an Android phone and a Mac over your own Wi-Fi (Round Robin edition)"
  homepage "https://github.com/round-robin-solutions/bridgey"

  # Prefer the newest Stable release. Until one exists, the newest beta is the
  # newest build, so betas are accepted as a fallback.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+-rr\.\d+(?:-beta\.\d+)?)$/i)
    strategy :github_releases do |json, regex|
      releases = json.reject { |release| release["draft"] }
      stable = releases.reject { |release| release["prerelease"] }
      (stable.presence || releases).filter_map do |release|
        match = release["tag_name"]&.match(regex)
        match[1] if match
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Bridgey by Round Robin.app"

  postflight do
    # The app is ad-hoc signed (no Apple Developer membership yet), so Gatekeeper
    # would block the first launch of a quarantined copy. Clear the flag here.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Bridgey by Round Robin.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/in.roundrobin.bridgey",
    "~/Library/Caches/in.roundrobin.bridgey",
    "~/Library/HTTPStorages/in.roundrobin.bridgey",
    "~/Library/Preferences/in.roundrobin.bridgey.plist",
    "~/Library/Saved Application State/in.roundrobin.bridgey.savedState",
    "~/Library/WebKit/in.roundrobin.bridgey",
  ]
end
