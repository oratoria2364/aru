{self, inputs, ...}: {
  flake.nixosModules.Aru_fixConfiguration = {pkgs, ...}: let
    bizhawk = import inputs.bizhawk {
      inherit pkgs;
      system = pkgs.stdenv.hostPlatform.system;
    };
  in {
    imports = [
      self.nixosModules.Aru_fixHardware
      self.nixosModules.feature-vr
      inputs.roxysu.nixosModules.default
    ];

    programs.roxysu.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "aru_fix"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "fr";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "fr";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."aruf" = {
      isNormalUser = true;
      description = "aru_fix";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        kdePackages.kate
        vesktop
        vlc
        libreoffice
        opencode
        git
        protonplus
        osu-lazer-bin
        gh
        vscode-fhs
        bs-manager
        fastfetch
        archipelago
        bizhawk.emuhawk-latest-bin
        prismlauncher
        olympus
        signal-desktop
      ];
    };

    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # Install firefox.
    programs.firefox.enable = true;

    fonts = {
      fontDir.enable = true;

      fontconfig = {
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Roboto Mono"
            "RobotoMono Nerd Font"
          ];
          sansSerif = [
            "Noto Sans CJK JP"
            "Roboto"
          ];
          serif = [
            "Noto Serif CJK JP"
            "Roboto Serif"
          ];
        };
        enable = true;
      };

      packages = with pkgs; [
        nerd-fonts.roboto-mono
        nerd-fonts.symbols-only
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        roboto
        roboto-mono
        roboto-serif
      ];
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;

    environment.shellAliases = {
      aru = "cd /home/aruf/code/aru/ && sudo nixos-rebuild switch --flake ./#aru_fix";
      clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
      pc = "kate /home/aruf/code/aru/modules/hosts/aru_fix/configuration.nix";
    };

    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "26.05"; # Did you read the comment?
    nix.settings.experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
}
