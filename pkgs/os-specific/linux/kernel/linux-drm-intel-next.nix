{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.11.0-rc2";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersionArg = version;
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = builtins.fetchGit {
    url = "https://anongit.freedesktop.org/git/drm/drm-intel.git";
    rev = "2bbd6dba84d44219387df051a1c799b7bac46099";
    ref = "drm-intel-next";
  };
} // (args.argsOverride or {}))
