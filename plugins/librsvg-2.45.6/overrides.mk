$(info == General overrides: $(lastword $(MAKEFILE_LIST)))

# upstream version is 1.37.4
pango_VERSION  := 1.38.1
pango_CHECKSUM := 1320569f6c6d75d6b66172b2d28e59c56ee864ee9df202b76799c4506a214eb7
pango_SUBDIR   := pango-$(pango_VERSION)
pango_FILE     := pango-$(pango_VERSION).tar.xz
pango_URL      := https://download.gnome.org/sources/pango/$(call SHORT_PKG_VERSION,pango)/$(pango_FILE)

# upstream version is 2.40.5
librsvg_VERSION  := 2.45.6
librsvg_CHECKSUM := 0e6e26cb5c79cfa73c0ddab06808ace4d10c4a626b81c31a75ead37c6cb4df41
librsvg_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/librsvg-[0-9]*.patch)))
librsvg_SUBDIR   := librsvg-$(librsvg_VERSION)
librsvg_FILE     := librsvg-$(librsvg_VERSION).tar.xz
librsvg_URL      := https://download.gnome.org/sources/librsvg/$(call SHORT_PKG_VERSION,librsvg)/$(librsvg_FILE)

# compile with the Rust toolchain 
define librsvg_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-introspection \
        LIBS="-lws2_32 -luserenv" \
        RUST_TARGET=$(firstword $(subst -, ,$(TARGET)))-pc-windows-gnu

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(INSTALL_STRIP_LIB)
endef
