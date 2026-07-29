.DEFAULT_GOAL := all
add-remote:
	flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak-builder:
	flatpak install --user flathub org.flatpak.Builder
install:
	flatpak run org.flatpak.Builder --force-clean --user --install-deps-from=flathub --repo=repo --install build ./com.mcleodgaming.FrayTools.yaml
clean:
	rm -rf ./repo
	rm -rf ./build


all: add-remote flatpak-builder clean install

