# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Dhaka";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bn_BD";
    LC_IDENTIFICATION = "bn_BD";
    LC_MEASUREMENT = "bn_BD";
    LC_MONETARY = "bn_BD";
    LC_NAME = "bn_BD";
    LC_NUMERIC = "bn_BD";
    LC_PAPER = "bn_BD";
    LC_TELEPHONE = "bn_BD";
    LC_TIME = "bn_BD";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;
    windowManager.qtile.enable = true;
    displayManager.lightdm.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abir = {
    isNormalUser = true;
    description = "abir";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "optical" "storage" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     python3
     nitrogen
     wget
     brave
     alacritty
     xterm
     rofi
     xfce.thunar
     xfce.thunar-volman
     xfce.thunar-archive-plugin
     brightnessctl
     git
     gh
     dunst
     cbatticon
     xclip
     zoxide
     starship
     volumeicon
     picom
     lxappearance
     xarchiver
     unzip
     unrar
     gnutar
     neofetch
     htop
     eza
     bat
     tldr
     gcc
     ripgrep
     gnumake
     nordic
     capitaine-cursors
     curl
     networkmanagerapplet
     tmux
     zathura
     vscodium
     pavucontrol
     flameshot
     fish
     xfce.ristretto
     ninja
     numlockx
     fd
     fzf
     vlc
     nodejs_20
     upscayl
  ];

 # Fonts
    fonts.packages= with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    services.gvfs.enable = true;
    services.tumbler.enable = true;

     # Sound configs
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.support32Bit = true;
    nixpkgs.config.pulseaudio = true;
    hardware.pulseaudio.extraConfig = "load-module module-combine-sink unload-module module-suspend-on-idle"; #Enabling modules 

# Polkit
    security.polkit.enable = true;

    systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
};

 # Video Driver
    hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

 # laptop specific
   services.tlp.enable = true;

 # Microcode
   hardware.cpu.intel.updateMicrocode = true;

 # gtk themes
   programs.dconf.enable = true;

  services.dbus.enable = true;

  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ "xdg-desktop-portal-gtk" ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
