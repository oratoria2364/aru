{ self, ... }: {
  flake.nixosModules.feature-base = { pkgs, ... }: {
    # Use the systemd-boot EFI boot loader.
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    console.keyMap = "fr";

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

    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
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
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [
      "flakes"
      "nix-command"
    ];

    # Install firefox.
    programs.firefox.enable = true;

    # Enable the X11 windowing system + KDE Plasma Desktop Environment.
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "fr";
      variant = "";
    };

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
    };

    # Set your time zone.
    time.timeZone = "Europe/Paris";
  };
}
