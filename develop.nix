{ pkgs }: with pkgs; let

  ghcCharged =  haskellPackages.ghcWithHoogle (p: with p; [
                  haskell-language-server
                  ghcid
                ]);
  ghcid-bin = haskellPackages.ghcid.bin;

  ghcid-lib = let
    ghcid = "${ghcid-bin}/bin/ghcid";
    out = "$out/bin/ghcid-lib";
  in runCommand "ghcid-lib" { buildInputs = [ makeWrapper ]; } ''
    makeWrapper ${ghcid} ${out} --add-flags "--command='cabal repl'"
  '';

  ghcid-test = let
    ghcid = "${ghcid-bin}/bin/ghcid";
    out = "$out/bin/ghcid-test";
  in runCommand "ghcid-test" { buildInputs = [ makeWrapper ]; } ''
    makeWrapper ${ghcid} ${out} --add-flags "--command='cabal repl test:quickcheck' --test 'Main.main'"
  '';

in mkShell {
  buildInputs =  haskellPackages.cassava-conduit.env.nativeBuildInputs ++
                 [ ghcCharged
                   ghcid-lib
                   ghcid-test
                   cabal-install
                 ];

}
