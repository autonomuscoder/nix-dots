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
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.efi.canTouchEfiVariables = true;
	
  boot.kernelPackages = pkgs.linuxPackages_6_4;


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
    windowManager.dwm.enable = true;
  };

  services.xserver.displayManager = {
     lightdm.enable = true;
  };

  nixpkgs.overlays = [
          (final: prev: {
	          dwm = prev.dwm.overrideAttrs (old: { src = /home/xero/github/Dwm/dwm ;});
	          myslstatus = final.slstatus.overrideAttrs (_: { src = /home/xero/github/Dwm/slstatus;});
		  })
	];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xero = {
    isNormalUser = true;
    description = "xero";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "storage" "optical" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    kitty
    alacritty
    nitrogen
    picom
    lxappearance
    cbatticon
    pcmanfm
    xarchiver
    unzip
		unrar
		gnutar
    rofi
    brave
    neofetch 
    htop
    exa
    bat
    tldr
    brightnessctl
    slstatus
    gcc
    ripgrep
    gnumake
    materia-theme
    colloid-icon-theme
    nordic
    dunst
    numlockx
    gh
    ninja
    gnugrep
    curl
    vim
    xclip
    nodejs_18
    zoxide
    starship
    capitaine-cursors
    networkmanagerapplet
    volumeicon
    vlc
    vscodium
		zathura
		tmux
		xfce.ristretto
		pipes
		fish
		betterlockscreen
		flameshot
		transmission-gtk
		pavucontrol
  ];

  # Fonts
    fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

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
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };


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
  system.stateVersion = "23.05"; # Did you read the comment?

}
