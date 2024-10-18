#!/usr/bin/env zsh

typeset -g BATTERY_LOW_THRESHOLD=20
typeset -g BATTERY_STAGES=(
  $'\UF008E' # 0%
  $'\UF007A' # 10%
  $'\UF007B' # 20%
  $'\UF007C' # 30%
  $'\UF007D' # 40%
  $'\UF007E' # 50%
  $'\UF007F' # 60%
  $'\UF0080' # 70%
  $'\UF0081' # 80%
  $'\UF0082' # 90%
  $'\UF0079' # 100%
)

typeset -gA colors=(
  [charging]="fg=#859900"
  [charged]="fg=#859900"
  [disconnected]="fg=#dc322f"
  [low]="fg=#b58900"
  [bg]="bg=#073642"
  [reset]="default"
)

# Cache the battery path to avoid repeated glob operations
function get_battery_path() {
    typeset -g BATTERY_PATH
    if [[ -z $BATTERY_PATH ]]; then
        if [[ "$OSTYPE" == linux* && -d "/sys/class/power_supply" ]]; then
            for battery in /sys/class/power_supply/BAT*; do
                if [[ -d $battery ]]; then
                    BATTERY_PATH=$battery
                    break
                fi
            done
        fi
    fi
    echo $BATTERY_PATH
}

# Read both status and capacity in one function to reduce I/O
function read_battery_info() {
    local battery_path=$(get_battery_path)
    if [[ -n $battery_path ]]; then
        local capacity_file="$battery_path/capacity"
        local status_file="$battery_path/status"
        
        if [[ -f $capacity_file && -f $status_file ]]; then
            # Read both files at once to reduce I/O operations
            local capacity=$(< $capacity_file)
            local statusf=$(< $status_file)
            echo "$capacity:$statusf"
        fi
    fi
}

function get_battery_stage() {
    local bat_percent=$1
    local stage_idx=$(( (bat_percent * $#BATTERY_STAGES) / 100 ))
    (( stage_idx = stage_idx < 1 ? 1 : stage_idx ))
    (( stage_idx = stage_idx > $#BATTERY_STAGES ? $#BATTERY_STAGES : stage_idx ))
    echo ${BATTERY_STAGES[stage_idx]}
}

function battery_prompt_string() {
    local battery_info=$(read_battery_info)
    if [[ -n $battery_info ]]; then
        local bat_percent=${battery_info%:*}
        local charging_status=${battery_info#*:}
        
        bat_percent = bat_percent + 1
        local color stage
        stage=$(get_battery_stage $bat_percent)
        
        if [[ "$charging_status" == "Charging" || "$charging_status" == "Unknown" ]]; then
            color=$colors[charging]
            stage=$'\UF0084'
        else
            if (( bat_percent == 100 )); then
                color=$colors[charged]
            elif (( bat_percent < 100 && bat_percent >= $BATTERY_LOW_THRESHOLD )); then
                color=$colors[low]
            else
                color=$colors[disconnected]
            fi
        fi
        
        echo "#[${color},${colors[bg]}]${bat_percent}% ${stage}"
    fi
}

battery_prompt_string
