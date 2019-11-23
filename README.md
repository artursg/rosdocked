## rospod

📦 ❤️ 🤖

Run ROS Melodic / Ubuntu Bionic within podman on any platform with a shared username,
home directory, and X11.

This enables you to build and run a persistent ROS Melodic workspace as long as
you can run oci images.

Note that any changes made outside of your home directory from within the container environment will not persist. If you want to add additional binary packages or remove some of the dependencies that are currently installed, change the Dockerfile accordingly and rebuild.

For more info on podman see here: [https://podman.io/](https://podman.io/)

### Install podman and buildah

Install _podman_ and _buildah_ on your system.

### Build

This will create the image with your user/group ID and home directory.

```
./build
```

### Run

This will start the oci image with podman.

```
./start
```

This will connect a shell to the podman image

```
./connect
```

The container will use your own shell configuration. To provide different settings inside and outside of the container, you can make use of the `$CONTAINER` environment variable that is set to `1` inside of the image. To make use of this put something like

```
if [[ -n "$CONTAINER" ]]; then
    # Settings for inside of the docker
    export PROMPT="PODMAN $PROMPT"  # Prefix the prompt with PODMAN
    # source workspace, etc.
else
    # Settings for outside of the container
fi
```

in your `.bashrc` or `.zshrc`.
