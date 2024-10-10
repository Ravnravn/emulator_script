# Alias for listing available emulators and filter out unwanted info
emulator:list() {
    $ANDROID_HOME/emulator/emulator -list-avds | grep -v "INFO"
}

# Alias for adb reverse command
adb:reverse() {
    adb reverse tcp:8081 tcp:8081
}

# Function to list and start an emulator, remember to brew install fzf
emulator:start() {
    # Check if fzf is installed
    if ! command -v fzf >/dev/null 2>&1; then
        echo "fzf is not installed. Please install it to use this feature."
        return 1
    fi

    # Use the emulator:list function to get the list of available emulators
    emulators=$(emulator:list)

    # Check if any emulators are available
    if [ -z "$emulators" ]; then
        echo "No emulators found!"
        return 1
    fi

    # Use fzf for interactive selection with arrow keys
    selected_emulator=$(echo "$emulators" | fzf --height 10 --prompt="Select an emulator: " --border)

    # If an emulator is selected, start it
    if [ -n "$selected_emulator" ]; then
        echo "Starting emulator: $selected_emulator"
        $ANDROID_HOME/emulator/emulator -avd "$selected_emulator" -no-snapshot-load -wipe-data
    else
        echo "No emulator selected!"
    fi
}
