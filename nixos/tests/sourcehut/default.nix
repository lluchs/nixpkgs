{ system, pkgs, ... }:

let
  setupHutSubtest = { domain, userName }:
    let
      userPass = "AutoNixosTestPwd";
      hutConfig = pkgs.writeText "hut-config" ''
        instance "${domain}" {
          # Will be replaced at runtime with the generated token
          access-token "OAUTH-TOKEN"
        }
      '';
    in ''
      with subtest("Create a new user account ${userName} and OAuth access key"):
           machine.succeed("echo ${userPass} | metasrht-manageuser -ps -e ${userName}@${domain}\
                            -t active_paying ${userName}");
           (_, token) = machine.execute("srht-gen-oauth-tok -i ${domain} -q ${userName} ${userPass}")
           token = token.strip().replace("/", r"\\/") # Escape slashes in token before passing it to sed
           machine.execute("mkdir -p ~/.config/hut/")
           machine.execute("sed s/OAUTH-TOKEN/" + token + "/ ${hutConfig} > ~/.config/hut/config")
    '';
in {
  git = import ./git.nix { inherit system pkgs setupHutSubtest; };
  builds = import ./builds.nix { inherit system pkgs setupHutSubtest; };
}
