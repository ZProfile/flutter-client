{
  description = "Mobile application for ZProfile";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    devenv-root,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # NOTE: Unfree packages
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };

        devenv.shells.default = {
          name = "Mobile application for ZProfile";
          secretspec.enable = true;

          # NOTE: First do devenv shell
          git-hooks.hooks = {
            actionlint = {
              enable = true;
              excludes = ["docker-publish.yaml"];
            };
          };

          android = {
            enable = true;
            flutter.enable = true;
            platforms.version = ["36" "35" "34" "33"];
            systemImageTypes = ["google_apis_playstore"];
            abis = ["arm64-v8a" "x86_64"];
            cmake.version = ["4.0.2"];
            cmdLineTools.version = "19.0";
            tools.version = "26.1.1";
            platformTools.version = "36.0.0";
            buildTools.version = ["36.0.0" "34.0.0" "33.0.0"];
            emulator = {
              enable = true;
              version = "36.1.2";
            };
            sources.enable = true;
            systemImages.enable = true;
            ndk = {
              enable = true;
              version = ["28.2.13676358"];
            };
            googleAPIs.enable = true;
            googleTVAddOns.enable = true;
            extras = ["extras;google;gcm"];
            extraLicenses = [
              "android-sdk-preview-license"
              "android-googletv-license"
              "android-sdk-arm-dbt-license"
              "google-gdk-license"
              "intel-android-extra-license"
              "intel-android-sysimage-license"
              "mips-android-sysimage-license"
            ];
          };

          devenv.root = let
            devenvRootFileContent = builtins.readFile devenv-root.outPath;
          in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          packages = with pkgs; [
            sops
          ];
        };
      };
    };
}
