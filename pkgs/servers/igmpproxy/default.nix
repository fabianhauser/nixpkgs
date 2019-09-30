{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "igmpproxy";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "igmpproxy";
    rev = version;
    sha256 = "13zn4q24drbhpqmcmqh1jg7ind5iqn11wj3xvczlc8w35vyqssyf";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  configureFlags = [ ];

  meta = with stdenv.lib; {
    description = "Simple mulitcast router that only uses the IGMP protocol";
    homepage = https://github.com/pali/igmpproxy;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fabianhauser ];
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
  };
}
