{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";

    freetype_src.url = "https://download.savannah.gnu.org/releases/freetype/freetype-2.13.1.tar.gz";
    freetype_src.flake = false;
  };

  outputs = { self, nixpkgs, tinycmmc, freetype_src }:
    tinycmmc.lib.eachWin32SystemWithPkgs (pkgs:
      {
        packages = rec {
          default = freetype;

          freetype = pkgs.stdenv.mkDerivation rec {
            pname = "freetype";
            version = "2.13.0";

            src = freetype_src;

            # Nix includes "---build=x86_64-unknown-linux-gnu" by
            # default, which makes freetype fail with "native C
            # compiler is not working"
            configurePhase = ''
              ./configure --prefix=$out --host=i686-w64-mingw32
            '';

            nativeBuildInputs = [
              # FIXME: What's the difference between the two?
              # pkgs.buildPackages.gcc
              nixpkgs.legacyPackages.x86_64-linux.gcc
            ];

            buildInputs = [
            ];

            propagatedBuildInputs = [
            ];
          };
        };
      }
    );
}
