{ config, pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- Nix ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # --- Boot ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ---
  networking.hostName = "othrys";
  networking.networkmanager.enable = true;

  # --- Locale ---
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Desktop (KDE Plasma) ---
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ kate ];

  # --- Audio (pipewire) ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- User ---
  users.users."cronos" = {
    isNormalUser = true;
    description = "Ebad Khan";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # --- Editor (nano removed, vim is the replacement) ---
  programs.nano.enable = false;
  environment.variables.EDITOR = "vim";

  # --- Packages ---
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    vim
    tmux
    htop
    kitty
    ansible
    gobuster
    fastfetch
    cmatrix
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # --- Shell aliases ---
  environment.shellAliases = {
    twist = "sudo nixos-rebuild switch";
  };

  # Never change after first install
  system.stateVersion = "26.05";
}
