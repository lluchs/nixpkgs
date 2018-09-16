{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kcoreaddons, kdeclarative, ki18n, kitemviews,
  kcmutils, kio, knewstuff, ktexteditor, kwidgetsaddons, kwindowsystem,
  kxmlgui,
  kqtquickcharts,
  qtscript, qtx11extras, qtquickcontrols, qtgraphicaleffects,
  libxkbfile, libxcb
}:

mkDerivation {
  name = "ktouch";
  meta = {
    license = with lib.licenses; [ gpl2plus ];
    maintainers = with lib.maintainers; [ lluchs ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    # KDE Frameworks
    kconfig kconfigwidgets kcoreaddons kdeclarative ki18n kitemviews kcmutils
    kio knewstuff ktexteditor kwidgetsaddons kwindowsystem kxmlgui
    kqtquickcharts

    qtscript qtx11extras qtquickcontrols qtgraphicaleffects
    # optional, for keyboard layout auto-detection
    libxkbfile libxcb
  ];
}
