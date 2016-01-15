# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./chur-hardware-configuration.nix
      ./modules/users.nix
      ./modules/lab-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Disable IOMMU for Snabb Switch.
  # chur has a Sandy Bridge CPU and these are known to have
  # performance problems in their IOMMU.
  boot.kernelPackages = pkgs.linuxPackages_4_2;
  boot.kernelParams = [ "intel_iommu=pt" "hugepages=4096" "panic=60"];
  boot.blacklistedKernelModules = [ "i40e" ];

  # Enable kernel MSR module
  nixpkgs.config = {
    packageOverrides = pkgs: {
      stdenv = pkgs.stdenv // {
        kernelExtraConfig = "X86_MSR m" ;
      };
    };
  };

  networking.hostName = "chur"; # Define your hostname.
  networking.hostId = "1ab1e8b1";
  # networking.wireless.enable = true;  # Enables wireless.

  security.sudo.wheelNeedsPassword = false;

  nix.nrBuildUsers = 32;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    gcc git gnumake wget
    emacs vim
    docker
  ];

}
