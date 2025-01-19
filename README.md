# Unofficial Fraytools Flatpak

## Installation Instructions
```sh
flatpak install --user https://shifterbit.gitlab.io/fraytools-flatpak/fraytools.flatpakref
```

## Differences from Running the Linux Build Directly
### Filesystem Permissions
Given that this is a flatpak, it is also sandboxed so by default it won't have permissions to read your entire home-directory by default, to alleviate this you can use `flatpak override` as such:
```
flatpak override --user com.mcleodgaming.FrayTools --filesystem=path-to-directory
```
alternatively, you can use a Graphical Tool such as [Flatseal](https://flathub.org/apps/com.github.tchx84.Flatseal) to do so

