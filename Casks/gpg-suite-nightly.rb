cask "gpg-suite-nightly" do
  version "3136n"
  sha256 "1435dfbaee643b7c95926583dfc66eb1856a358174ff12de790e3e61ef7638dc"

  url "https://releases.gpgtools.org/nightlies/GPG_Suite-#{version}.dmg"
  name "GPG Suite Nightly"
  desc "Tools to protect your emails and files"
  homepage "https://gpgtools.org/"

  livecheck do
    url "https://releases.gpgtools.org/nightlies/"
    regex(/href=.*?GPG_Suite-([0-9a-z]+)\.dmg/i)
  end

  conflicts_with cask: "gpg-suite"

  pkg "Install.pkg"

  uninstall_postflight do
    ["gpg", "gpg2", "gpg-agent"].map { |exec_name| Pathname("/usr/local/bin")/exec_name }.each do |exec|
      exec.unlink if exec.exist? && exec.readlink.to_s.include?("MacGPG2")
    end
  end

  uninstall script:    {
              executable: "#{staged_path}/Uninstall.app/Contents/Resources/GPG Suite Uninstaller.app/Contents/Resources/uninstall.sh",
              sudo:       true,
            },
            pkgutil:   "org.gpgtools.*",
            quit:      [
              "com.apple.mail",
              "org.gpgtools.gpgkeychain",
              "org.gpgtools.gpgkeychainaccess",
              "org.gpgtools.gpgmail.upgrader",
              "org.gpgtools.gpgservices",
              # TODO: add "killall -kill gpg-agent"
            ],
            launchctl: [
              "org.gpgtools.gpgmail.enable-bundles",
              "org.gpgtools.gpgmail.patch-uuid-user",
              "org.gpgtools.gpgmail.user-uuid-patcher",
              "org.gpgtools.gpgmail.uuid-patcher",
              "org.gpgtools.Libmacgpg.xpc",
              "org.gpgtools.macgpg2.fix",
              "org.gpgtools.macgpg2.gpg-agent",
              "org.gpgtools.macgpg2.shutdown-gpg-agent",
              "org.gpgtools.macgpg2.updater",
              "org.gpgtools.updater",
            ],
            delete:    [
              "/Library/Application Support/GPGTools",
              "/Library/Frameworks/Libmacgpg.framework",
              "/Library/Mail/Bundles.gpgmail*",
              "/Library/Mail/Bundles/GPGMail.mailbundle",
              "/Library/PreferencePanes/GPGPreferences.prefPane",
              "/Library/Services/GPGServices.service",
              "/Network/Library/Mail/Bundles/GPGMail.mailbundle",
              "/private/etc/manpaths.d/MacGPG2",
              "/private/etc/paths.d/MacGPG2",
              "/private/tmp/gpg-agent",
              "/usr/local/MacGPG2",
            ]

  zap trash: [
    "~/Containers/com.apple.mail/Data/Library/Frameworks/Libmacgpg.framework",
    "~/Library/Application Support/GPGTools",
    "~/Library/Caches/org.gpgtools.gpg*",
    "~/Library/Containers/com.apple.mail/Data/Library/Preferences/org.gpgtools.*",
    "~/Library/Frameworks/Libmacgpg.framework",
    "~/Library/HTTPStorages/org.gpgtools.*",
    "~/Library/LaunchAgents/org.gpgtools.*",
    "~/Library/Mail/Bundles/GPGMail.mailbundle",
    "~/Library/PreferencePanes/GPGPreferences.prefPane",
    "~/Library/Preferences/org.gpgtools.*",
    "~/Library/Services/GPGServices.service",
  ]

  caveats do
    files_in_usr_local
  end
end
