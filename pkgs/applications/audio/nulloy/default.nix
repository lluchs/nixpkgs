{ stdenv, fetchFromGitHub
, getopt, which, pkgconfig, zip
, qt4
, withTaglib ? true, taglib
, withGstreamer ? false, gst_all_1
, withPhonon ? false, phonon
, withVlc ? true, vlc}:

let
  inherit (stdenv.lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  name = "nulloy-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "nulloy";
    repo = "nulloy";
    rev = version;
    sha256 = "0g049gqhxj6cl6z0shd7x1q4nvk1f35i57j6lpbd7q4kk550y2is";
  };

  nativeBuildInputs = [ getopt which pkgconfig zip ];
  buildInputs = [ qt4 ]
    ++ (optional withTaglib taglib)
    ++ (optionals withGstreamer [ gst_all_1.gstreamer gst_all_1.gst-plugins-base ])
    ++ (optional withPhonon phonon)
    ++ (optional withVlc vlc);

  configureFlags = [
    "--no-update-check"
    "--force-version ${version}" # avoid git dependency
    (optionalString withTaglib "--taglib")
    (optionalString withPhonon "--phonon")
    (optionalString withVlc "--vlc")
  ] ++ (optionals (!withGstreamer) [ "--no-gstreamer" "--no-gstreamer-tagreader" ]);

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A music player with a waveform progress bar";
    homepage = http://nulloy.com/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lluchs ];
  };
}
