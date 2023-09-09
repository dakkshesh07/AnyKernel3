#Kernel Name
NAME := Parallax-Kernel

#Build Date
DATE := $(shell date "+%Y%m%d-%H%M")

#Device Name
DEVICE := RMX1921

# Check if required arguments are provided
ifeq ($(strip $(BUILD_VERSION)),)
$(error BUILD_VERSION is not defined.)
endif

ifeq ($(strip $(RELEASE_BUILD)),)
$(error RELEASE_BUILD is not defined.)
endif

ifeq ($(strip $(COMPILER)),)
$(error COMPILER is not defined.)
endif

#Zip Name format, $RELEASE_BUILD, $COMPILER and $BUILD_VERSION handled by build script
ifeq ($(RELEASE_BUILD),1)
ZIP := $(NAME)-$(BUILD_VERSION)-$(DEVICE)-$(DATE)
else
ZIP := $(NAME)-$(DEVICE)-$(COMPILER)-$(DATE)-$(BUILD_VERSION)
endif

#Files to be excluded while zipping
EXCLUDE := Makefile *.git* zipsigner-3.0-dexed.jar *placeholder* *.md*

#Create build zip
zip: $(ZIP)

$(ZIP):
	@echo "Creating ZIP: $(ZIP)"
	@zip -r9 "$@.zip" . -x $(EXCLUDE)
	@echo "Signing zip with aosp keys..."
	@java -jar zipsigner-3.0-dexed.jar "$@.zip" "$@-signed.zip"
	@echo "Generating SHA1..."
	@sha1sum "$@-signed.zip" > "$@-signed.zip.sha1"
	@cat "$@-signed.zip.sha1"
	@echo "Done."

#Clean previous build leftovers
clean:
	@rm -vf dtbo.img
	@rm -vf *.zip*
	@rm -vf zImage
	@rm -vf Image*
	@rm -vf parallax-kernel/image/Image*
	@echo "Cleaned Up."
