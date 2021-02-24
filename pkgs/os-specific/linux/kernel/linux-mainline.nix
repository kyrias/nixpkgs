{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.11.0";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = builtins.fetchGit {
    url = "https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux.git";
    rev = "c03c21ba6f4e95e406a1a7b4c34ef334b977c194";
    ref = "master";
  };

  ignoreConfigErrors = true;
} // (args.argsOverride or {}))
