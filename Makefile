EMULATOR_NAME := zprofile
DEVICE := pixel_7
EMULATOR_ID := emulator-5554

.PHONY: all run
all: run

run: ## Run the app
	flutter run -d $(EMULATOR_ID) --hot

.PHONY: help
help:  ## help target to show available commands with information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: emulate-create
emulate-create: # Create an avd emulator
	avdmanager create avd \
	  --force \
	  --name $(EMULATOR_NAME) \
	  --package 'system-images;android-36;google_apis_playstore;x86_64' \
	  --device "$(DEVICE)" \
	  --abi x86_64

.PHONY: emulate
emulate: # Start emulator
	emulator -avd $(EMULATOR_NAME) \
	  -gpu host \
	  -accel on \
	  -cores 4 \
	  -memory 4096 \
	  -no-snapshot-load \
	  -no-snapshot-save &
