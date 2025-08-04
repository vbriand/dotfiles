{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.zen-browser.homeModules.beta
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "valou";
  home.homeDirectory = "/home/valou";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nixfmt-rfc-style # Nix formatter

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".kodi/userdata/addon_data/pvr.hts/instance-settings-1.xml".source = conf/kodi-pvr.hts.xml;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/valou/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.vscode =
    let
      commonExtensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        johnpapa.winteriscoming
        leodevbro.blockman
        pkief.material-icon-theme
        streetsidesoftware.code-spell-checker
        tuttieee.emacs-mcx
      ];
      commonUserSettings =
        let
          blockmanSettings = {
            "editor.inlayHints.enabled" = "off";
            "editor.guides.indentation" = false;
            "editor.guides.bracketPairs" = false;
            "editor.wordWrap" = "off";
            "diffEditor.wordWrap" = "off";
            "workbench.colorCustomizations" = {
              "editor.lineHighlightBorder" = "#9fced11f";
              "editor.lineHighlightBackground" = "#1073cf2d";
            };
          };
        in
        {
          "editor.formatOnSave" = true;
          "git.blame.editorDecoration.enabled" = true;
          "terminal.integrated.allowChords" = false;
          "workbench.colorTheme" = "Winter is Coming (Dark Blue)";
          "workbench.iconTheme" = "material-icon-theme";
        }
        // blockmanSettings;
    in
    {
      enable = true;
      profiles = {
        default = {
          enableExtensionUpdateCheck = false;
          enableUpdateCheck = false;
          userSettings = {
            "telemetry.telemetryLevel" = "off";
          };
        };
        LaTeX = {
          extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
            james-yu.latex-workshop
          ];
          userSettings = commonUserSettings;
        };
        Nix = {
          extensions =
            with pkgs.nix-vscode-extensions.vscode-marketplace;
            [
              jnoortheen.nix-ide
            ]
            ++ commonExtensions;
          userSettings = commonUserSettings;
        };
        React-Native = {
          extensions =
            with pkgs.nix-vscode-extensions.vscode-marketplace;
            [
              aaron-bond.better-comments
              davidanson.vscode-markdownlint
              dbaeumer.vscode-eslint
              esbenp.prettier-vscode
              expo.vscode-expo-tools
              johnpapa.vscode-peacock
              kruemelkatze.vscode-dashboard
              mikestead.dotenv
              streetsidesoftware.code-spell-checker-french-reforme
              wix.vscode-import-cost
              yoavbls.pretty-ts-errors
            ]
            ++ commonExtensions;
          userSettings = commonUserSettings;
        };
      };
    };
  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      SearchSuggestEnabled = true;
      ExtensionSettings = {
        "firefox@betterttv.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/betterttv/latest.xpi";
          installation_mode = "force_installed";
        };
        "jetpack-extension@dashlane.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dashlane/latest.xpi";
          installation_mode = "force_installed";
        };
        "reddit-url-redirector@kichkoupi.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddituntranslate/latest.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{458160b9-32eb-4f4c-87d1-89ad3bdeb9dc}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-anti-translate/latest.xpi";
          installation_mode = "force_installed";
        };
        "firefox-extension@steamdb.info" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/steam-database/latest.xpi";
          installation_mode = "force_installed";
        };
        "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/augmented-steam/latest.xpi";
          installation_mode = "force_installed";
        };
        "{dbac9680-d559-4cd4-9765-059879e8c467}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/igraal/latest.xpi";
          installation_mode = "force_installed";
        };
        "{188e9a6d-0e71-49ad-b1f2-0b78519512e0}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dealabs/latest.xpi";
          installation_mode = "force_installed";
        };
        "firefox@tampermonkey.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tampermonkey/latest.xpi";
          installation_mode = "force_installed";
        };
        "{EDB6A15C-5F8C-4531-92FA-98E988CF233C}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/wanteeed/latest.xpi";
          installation_mode = "force_installed";
        };
        "twitchnosub@besuper.com" = {
          install_url = "https://github.com/besuper/TwitchNoSub/releases/latest/download/TwitchNoSub-firefox.0.9.2.xpi";
          installation_mode = "force_installed";
        };
      };
      SearchEngines = {
        Add = [
          {
            Alias = "@hm";
            Description = "Search in Home Manager options";
            IconURL = "https://mynixos.com/favicon-32x32.png";
            Method = "GET";
            Name = "Home Manager";
            URLTemplate = "https://mynixos.com/search?q=home-manager+{searchTerms}";
          }
          {
            Alias = "@np";
            Description = "Search in NixOS packages";
            IconURL = "https://nixos.org/favicon.ico";
            Method = "GET";
            Name = "NixOS packages";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
          }
          {
            Alias = "@no";
            Description = "Search in NixOS options";
            IconURL = "https://nixos.org/favicon.ico";
            Method = "GET";
            Name = "NixOS options";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
          }
          {
            Alias = "@nw";
            Description = "Search in NixOS wiki";
            IconURL = "https://nixos.org/favicon.ico";
            Method = "GET";
            Name = "NixOS wiki";
            URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}&title=Special%3ASearch&wprov=acrw1_-1";
          }
          {
            Alias = "@pc";
            Description = "Search in PCGamingWiki";
            IconURL = "https://static.pcgamingwiki.com/favicons/pcgamingwiki.png";
            Method = "GET";
            Name = "PCGamingWiki";
            URLTemplate = "https://www.pcgamingwiki.com/w/index.php?search={searchTerms}&title=Special%3ASearch";
          }
          {
            Alias = "@pdb";
            Description = "Search in ProtonDB";
            IconURL = "https://www.protondb.com/sites/protondb/images/site-logo.svg";
            Method = "GET";
            Name = "ProtonDB";
            URLTemplate = "https://www.protondb.com/search?q={searchTerms}";
          }
          {
            Alias = "@w";
            Description = "Search in Wikipedia (en)";
            IconURL = "https://wikipedia.org/static/favicon/wikipedia.ico";
            Method = "GET";
            Name = "Wikipedia EN";
            URLTemplate = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&search={searchTerms}&language=en&go=Go";
          }
          {
            Alias = "@wfr";
            Description = "Search in Wikipedia (fr)";
            IconURL = "https://wikipedia.org/static/favicon/wikipedia.ico";
            Method = "GET";
            Name = "Wikipedia FR";
            URLTemplate = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&search={searchTerms}&language=fr&go=Go";
          }
          {
            Alias = "@yt";
            Description = "Search in Youtube";
            IconURL = "https://www.youtube.com/s/desktop/33ae93e9/img/logos/favicon.ico";
            Method = "GET";
            Name = "Youtube";
            URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
          }
        ];
        Remove = [
          "Bing"
          "Wikipedia (en)"
        ];
      };
    };
    profiles = {
      valentin = {
        isDefault = true;
        settings = {
          "services.sync.engine.workspaces" = true;
          "zen.welcome-screen.seen" = true;
          "zen.workspaces.container-specific-essentials-enabled" = true;
          "zen.workspaces.continue-where-left-off" = true;
        };
        extensions = {
          force = true;
          settings = {
            "uBlock0@raymondhill.net".settings = {
              advancedUserEnabled = true;
              hiddenSettings.userResourcesLocation = "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/f5594de4ef5eadd8d3aa156c24cbc53f17ab606c/video-swap-new/video-swap-new-ublock-origin.js";
              user-filters = "twitch.tv##+js(twitch-videoad)";
            };
          };
        };
        containersForce = true;
        containers = {
          personal = {
            name = "Personal";
            color = "blue";
            icon = "fingerprint";
            id = 1;
          };
          work = {
            name = "Work";
            color = "orange";
            icon = "briefcase";
            id = 2;
          };
        };
      };
    };
  };
  programs.kodi = {
    enable = true;
    package = pkgs.kodi-gbm.withPackages (addOns: with addOns; [ pvr-hts ]);
  };
  programs.plasma = {
    enable = true;
    workspace = {
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/SafeLanding/contents/images/5120x2880.jpg";
    };
    panels = [
      {
        location = "top";
        height = 30;
        hiding = "autohide";
        screen = 0;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.showdesktop"
        ];
      }
      {
        floating = true;
        lengthMode = "fit";
        location = "bottom";
        height = 52;
        hiding = "autohide";
        screen = 0;
        widgets = [ "org.kde.plasma.icontasks" ];
      }
    ];
  };
  programs.git = {
    enable = true;
    userName = "Valentin Briand";
    userEmail = "678530+vbriand@users.noreply.github.com";
    signing = {
      key = "2708255FFF876F95";
      signByDefault = true;
    };
    aliases = {
      br = "branch";
      ci = "commit";
      co = "checkout";
      st = "status";
      # Stash only untracked files
      su = "!f() { git stash; git stash -u; git stash pop stash@{1}; }; f";
      # Stash changes not staged for commit and untracked files
      snsu = "!f() { git stash push --staged; git stash -u; git stash pop stash@{1}; }; f";
      # Stash changes not staged for commit
      sns = "!f() { git stash push --staged; git stash; git stash pop stash@{1}; }; f";
      sw = "switch";
      wta = "worktree add";
      wtl = "worktree list";
      wtr = "worktree remove";
    };
    extraConfig = {
      core = {
        editor = "emacs";
      };
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true; # https://stackoverflow.com/a/17096880/10927329
    };
    includes = [
      {
        path = conf/gitconfig_mazarine;
        condition = "hasconfig:remote.*.url:git@gitlab.mzrn.net:*/**";
      }
    ];
    # https://discourse.nixos.org/t/home-manager-what-is-the-best-way-to-use-a-long-global-gitignore-file/24986
    ignores = import conf/gitignore_global.nix;
  };
  services.syncthing = {
    enable = true;
    extraOptions = [ "--no-default-folder" ]; # Don't create default ~/Sync folder
    tray.enable = true;
    settings = {
      devices = {
        Gringotts = {
          id = "ANJBTRA-BXCRHCH-HDMWTWZ-3F2BRR3-SS7R4TW-KNM3L7F-WTTDOTP-TCASSAG";
        };
      };
      folders = {
        "Steam grid" = {
          devices = [ "Gringotts" ];
          id = "cjnuh-vcntm";
          label = "Steam grid images";
          path = "~/.steam/steam/userdata/11938770/config/grid";
        };
      };
      options = {
        # Disable global discovery to prevent making the IP address public
        # https://docs.syncthing.net/users/faq.html#should-i-keep-my-device-ids-secret
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        urAccepted = -1; # Refuse to submit anonymous usage data
      };
    };
    overrideDevices = true;
    overrideFolders = true;
  };
}
