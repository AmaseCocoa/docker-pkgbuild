# docker-pkgbuild

A simple Docker container to build Arch Linux packages using `makepkg`.

This container provides a clean Arch Linux environment with `base-devel` installed, allowing you to build packages from a `PKGBUILD` file. It also includes `paru` to automatically install and build dependencies from the Arch User Repository (AUR).

## Usage

The primary way to use this image is to mount your package's source directory (containing the `PKGBUILD`) into the `/pkg` volume in the container. The built package will be created in this directory.

```bash
docker run --rm -v "/path/to/your/pkgbuild/dir:/pkg" ghcr.io/AmaseCocoa/docker-pkgbuild
```

### Creating Signed Builds

To create a signed package, you need to provide your GPG private key to the container. This can be done by passing the key content through the `GPG_KEY` environment variable.

First, export your GPG private key:

```bash
export GPG_PRIVATE_KEY=$(gpg --export-secret-keys --armor YOUR_GPG_KEY_ID)
```

Then, run the container with the `GPG_KEY` environment variable set.

If your key is protected by a passphrase, you must also provide it via the `GPG_PASSPHRASE` environment variable.

```bash
docker run --rm \
  -v "/path/to/your/pkgbuild/dir:/pkg" \
  -e GPG_KEY="$GPG_PRIVATE_KEY" \
  -e GPG_PASSPHRASE="your-passphrase" \
  ghcr.io/AmaseCocoa/docker-pkgbuild
```

If your key does not have a passphrase, you can omit the `GPG_PASSPHRASE` variable. The entrypoint script will automatically import the key and use it to sign the package with `makepkg --sign`.

> [!WARNING]
> **Security Note:** Using environment variables for secrets like GPG keys and passphrases can be insecure, as they may be exposed in container inspection commands or logs. Use this method with caution, especially in shared or production environments. For CI/CD systems like GitHub Actions, it is recommended to use the platform's built-in secret management features.

### Installing AUR Dependencies

If your package depends on other packages from the AUR, you can specify them using the `AUR_DEPS` environment variable. Provide a space-separated list of package names.

```bash
docker run --rm \
  -v "/path/to/your/pkgbuild/dir:/pkg" \
  -e AUR_DEPS="dependency1 another-dependency" \
  ghcr.io/AmaseCocoa/docker-pkgbuild
```

The entrypoint script will use `paru` to install these dependencies before running `makepkg`. Dependencies from the official repositories will be handled automatically by `makepkg`.

## Building the Image Locally

If you prefer to build the image yourself instead of pulling it from the registry, you can clone this repository and use the `docker build` command.

```bash
git clone https://github.com/AmaseCocoa/docker-pkgbuild.git
cd docker-pkgbuild
docker build -t docker-pkgbuild .
```

## Image Registry

This image is automatically built and pushed to the GitHub Container Registry (`ghcr.io`) upon a new release.

The image is available at: `ghcr.io/AmaseCocoa/docker-pkgbuild`

Tags are created based on the release version (e.g., `v1.0.0`) and `latest` is updated with each new release.