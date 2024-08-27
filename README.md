# Unofficial Fraytools Flatpak

## Installation Instructions
```sh
flatpak install --user https://shifterbit.gitlab.io/fraytools-flatpak/fraytools.flatpakref
```

## Differences from Running the Linux Build Directly
### Location of FrayToolsData
When running the non-flatpak build, the FrayToolsData folder would be located at `~/FrayToolsData/` or `/home/yourusername/FrayToolsData`.

When running this flatpak build, it will be located at `~/.var/app/com.mcleodgaming.FrayTools/FrayToolsData/` or `/home/yourusername/.var/app/com.mcleodgaming.FrayTools/FrayToolsData/`

Note: `/home/yourusername` and `~` are equivalent


### Filesystem Permissions
Given that this is a flatpak, it is also sandboxed so by default it won't have permissions to read your entire home-directory by default, to alleviate this you can use `flatpak override` as such:
```
flatpak override --user com.mcleodgaming.FrayTools --filesystem=path-to-directory
```
alternatively, you can use a Graphical Tool such as [Flatseal](https://flathub.org/apps/com.github.tchx84.Flatseal) to do so

