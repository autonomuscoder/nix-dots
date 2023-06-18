# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{

  nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1u"
		"python-2.7.18.6"
              ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

 # Kernel
   boot.kernelPackages = pkgs.linuxPackages_6_3;
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

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
    enable = true;
    layout = "us";
    xkbVariant = "";

   displayManager = {
       sddm.enable = true;
       defaultSession = "none+awesome";
       };

   windowManager.awesome = {
       enable = true;
       luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
        ];
      };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nuhas = {
    isNormalUser = true;
    description = "nuhas";
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
     brave
     alacritty
     xterm
     brightnessctl
     rofi
     dmenu
     nitrogen
     picom
     volumeicon
     xfce.thunar
     vscodium
     git
     neofetch
     dunst
     xclip
     numlockx
     htop
     cbatticon
     mate.atril
     mate.eom
     gnome.file-roller
     lxappearance
     tldr
     ripgrep
     curl
     gh
     gcc
     github-desktop
     gnugrep
     gnumake
     ninja
     vlc
     micro

  ];

 # Storage configs
   programs.thunar.plugins = with pkgs.xfce; [
   thunar-archive-plugin
   thunar-volman
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


 # Fonts
   fonts = {
    fonts = with pkgs; [
      noto-fonts
      font-awesome
      fantasque-sans-mono
      jetbrains-mono
      cascadia-code
      source-han-sans
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
	      monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
	      serif = [ "Noto Serif" "Source Han Serif" ];
	      sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
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
    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

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
