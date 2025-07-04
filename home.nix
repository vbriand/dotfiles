{
  config,
  pkgs,
  zen-browser,
  ...
}:

{
  imports = [
    zen-browser.homeModules.beta
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

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.vscode =
    let
      commonExtensions = with pkgs.vscode-extensions; [
        johnpapa.winteriscoming
        # leodevbro.blockman
        pkief.material-icon-theme
        streetsidesoftware.code-spell-checker
        tuttieee.emacs-mcx
      ];
      commonUserSettings = {
        "editor.formatOnSave" = true;
        "terminal.integrated.allowChords" = false;
        "workbench.colorTheme" = "Winter is Coming (Dark Blue)";
      };
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
          extensions = with pkgs.vscode-extensions; [
            james-yu.latex-workshop
          ];
          userSettings = commonUserSettings;
        };
        Nix = {
          extensions =
            with pkgs.vscode-extensions;
            [
              jnoortheen.nix-ide
            ]
            ++ commonExtensions;
          userSettings = commonUserSettings;
        };
        React-Native = {
          extensions =
            with pkgs.vscode-extensions;
            [
              aaron-bond.better-comments
              davidanson.vscode-markdownlint
              dbaeumer.vscode-eslint
              esbenp.prettier-vscode
              # expo.vscode-expo-tools
              johnpapa.vscode-peacock
              # kruemelkatze.vscode-dashboard
              mikestead.dotenv
              # streetsidesoftware.code-spell-checker-french-reforme
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
      };
      # Dealabs
      # DeepL
      # SpotiAds
      # Tab Session Manager
      # Tampermonkey
      # wanteeed
    };
  };
}
