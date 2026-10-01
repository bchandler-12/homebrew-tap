# Public Homebrew formula for the contrast-cns CLI, published as `contrast-cli`
# (the name `contrast` is taken by the legacy CodeSec formula in this tap).
# Binaries are pulled anonymously from the already-public Artifactory path, the
# same host the legacy `contrast` formula uses. No download strategy, no token.
#
# Pinned to a VERSIONED Artifactory path (stable sha256). Never point at latest/.
# Bump `version` and the four sha256 values on each release.
class ContrastCli < Formula
  desc "Contrast security CLI (self-contained, pathfinder bundled)"
  homepage "https://github.com/Contrast-Security-Inc/contrast-cns"
  version "0.0.47"

  base = "https://contrastsecurity.jfrog.io/artifactory/pathfinder-beta-distro/contrast-cns"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/0.0.47/contrast-cns-darwin-arm64.tar.gz"
      sha256 "80f6949df97df3b1f6dc02bc746aed62238570a25d319736f0f166bfe48f9fc4"
    else
      url "#{base}/0.0.47/contrast-cns-darwin-amd64.tar.gz"
      sha256 "e5a28bdebb803b2e11b7c5d0b64ac214feb2433f216d22397e782c70af35604b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/0.0.47/contrast-cns-linux-arm64.tar.gz"
      sha256 "c84c3edf616bd1d911c6a7229b6ba9731d7efa553c78b9e9ca8eceab6f7bd86f"
    else
      url "#{base}/0.0.47/contrast-cns-linux-amd64.tar.gz"
      sha256 "54c2f8bbc0b0c88cc6c4366fa5f65ba8f14aca578557c7e318cd163ad0623b33"
    end
  end

  def install
    # The tarball is a PyInstaller onedir bundle: one top-level dir with the
    # contrast-cli exe beside an _internal/ dir. Homebrew descends into the
    # single dir, so Dir["*"] here is the exe + _internal/. Install the whole
    # thing to libexec and expose the exe on PATH via a symlink.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"contrast-cli" => "contrast-cli"
  end

  test do
    system bin/"contrast-cli", "--version"
  end
end
