{ stdenv, pythonPackages, fetchurl, callPackage, nix, ronn }:

pythonPackages.buildPythonApplication rec {
  pname = "vulnix";
  version = "1.6.1";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0j6v6phq3naqnpvzxxnynsyv9y7bhig1gzvg594qpknqgyzj16bf";
  };

  buildInputs = [ ronn ];

  checkInputs = with pythonPackages; [ freezegun pytest pytestcov pytest-flake8 ];

  propagatedBuildInputs = [
    nix
  ] ++ (with pythonPackages; [
    click
    colorama
    lxml
    pyyaml
    requests
    toml
    zodb
  ]);

  outputs = [ "out" "doc" ];

  postBuild = ''
    make -C doc
  '';

  checkPhase = "py.test src/vulnix";

  postInstall = ''
    install -D -t $out/share/man/man1 doc/vulnix.1
    install -D -t $out/share/man/man5 doc/vulnix-whitelist.5
    install -D -t $doc/share/doc/vulnix README.rst CHANGES.rst
    gzip $doc/share/doc/vulnix/*.rst
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "NixOS vulnerability scanner";
    homepage = https://github.com/flyingcircusio/vulnix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ckauhaus plumps ];
  };
}
