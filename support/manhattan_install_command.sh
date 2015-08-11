echo "Installing Chef ${install_file} for ${install_platform}"

case "$install_platform" in
  "el")
    echo "installing with RPM"
    $sudo rpm -Uvh --oldpackage --replacepkgs "$install_file"
    ;;
  "debian" | "ubuntu")
    echo "Installing with DPKG"
    $sudo dpkg -i "$install_file"
    ;;
  "freebsd")
    echo "installing with sh"
    $sudo sh "$install_file"
    ;;
  *)
    echo "no platform found"
    ;;
esac
