#!/usr/bin/env zsh

# First declare the icons array
declare -A icons=(
        APPLE_ICON                     '\uf179'               #  
        WINDOWS_ICON                   '\uf17a'               #  
        FREEBSD_ICON                   '\uf30c'               #  
        ANDROID_ICON                   '\uf17b'               #  
        LINUX_ARCH_ICON                '\uf303'               #  
        LINUX_CENTOS_ICON              '\uf304'               #  
        LINUX_COREOS_ICON              '\uf305'               #  
        LINUX_DEBIAN_ICON              '\uf306'               #  
        LINUX_RASPBIAN_ICON            '\uf315'               #  
        LINUX_ELEMENTARY_ICON          '\uf309'               #  
        LINUX_FEDORA_ICON              '\uf30a'               #  
        LINUX_GENTOO_ICON              '\uf30d'               #  
        LINUX_MAGEIA_ICON              '\uf310'               #  
        LINUX_MINT_ICON                '\uf30e'               #  
        LINUX_NIXOS_ICON               '\uf313'               #  
        LINUX_MANJARO_ICON             '\uf312'               #  
        LINUX_DEVUAN_ICON              '\uf307'               #  
        LINUX_ALPINE_ICON              '\uf300'               #  
        LINUX_AOSC_ICON                '\uf301'               #  
        LINUX_OPENSUSE_ICON            '\uf314'               #  
        LINUX_SABAYON_ICON             '\uf317'               #  
        LINUX_SLACKWARE_ICON           '\uf319'               #  
        LINUX_VOID_ICON                '\uf32e'               #  
        LINUX_ARTIX_ICON               '\uf31f'               #  
        LINUX_UBUNTU_ICON              '\uf31b'               #  
        LINUX_KALI_ICON                '\uf327'               #  
        LINUX_RHEL_ICON                '\uf111b'              # 󱄛 
        LINUX_AMZN_ICON                '\uf270'               #  
        LINUX_ENDEAVOUROS_ICON         '\uf322'               #  
        LINUX_ROCKY_ICON               '\uf32b'               #  
        LINUX_GUIX_ICON                '\uf325'               #  
        LINUX_NEON_ICON                '\uf17c'               #  
        LINUX_ICON                     '\uf17c'               #  
)

# Function to get the OS icon name
function os_icon_name() {
    local uname="$(uname)"
    
    if [[ $uname == Linux && "$(uname -o 2>/dev/null)" == Android ]]; then
        echo ANDROID_ICON
    else
        case $uname in
            SunOS)                     echo SUNOS_ICON;;
            Darwin)                    echo APPLE_ICON;;
            CYGWIN_NT-*|MSYS_NT-*|MINGW64_NT-*|MINGW32_NT-*)   echo WINDOWS_ICON;;
            FreeBSD|OpenBSD|DragonFly) echo FREEBSD_ICON;;
            Linux)
                local os_release_id
                if [[ -r /etc/os-release ]]; then
                    local lines=(${(f)"$(</etc/os-release)"})
                    lines=(${(@M)lines:#ID=*})
                    (( $#lines == 1 )) && os_release_id=${(Q)${lines[1]#ID=}}
                elif [[ -e /etc/artix-release ]]; then
                    os_release_id=artix
                fi
                case $os_release_id in
                    *arch*)                  echo LINUX_ARCH_ICON;;
                    *raspbian*)              echo LINUX_RASPBIAN_ICON;;
                    *debian*)
                        if [[ -f /etc/apt/sources.list.d/raspi.list ]]; then
                            echo LINUX_RASPBIAN_ICON
                        else
                            echo LINUX_DEBIAN_ICON
                        fi
                        ;;
                    *ubuntu*)                echo LINUX_UBUNTU_ICON;;
                    *elementary*)            echo LINUX_ELEMENTARY_ICON;;
                    *fedora*)                echo LINUX_FEDORA_ICON;;
                    *coreos*)                echo LINUX_COREOS_ICON;;
                    *kali*)                  echo LINUX_KALI_ICON;;
                    *gentoo*)                echo LINUX_GENTOO_ICON;;
                    *mageia*)                echo LINUX_MAGEIA_ICON;;
                    *centos*)                echo LINUX_CENTOS_ICON;;
                    *opensuse*|*tumbleweed*) echo LINUX_OPENSUSE_ICON;;
                    *sabayon*)               echo LINUX_SABAYON_ICON;;
                    *slackware*)             echo LINUX_SLACKWARE_ICON;;
                    *linuxmint*)             echo LINUX_MINT_ICON;;
                    *alpine*)                echo LINUX_ALPINE_ICON;;
                    *aosc*)                  echo LINUX_AOSC_ICON;;
                    *nixos*)                 echo LINUX_NIXOS_ICON;;
                    *devuan*)                echo LINUX_DEVUAN_ICON;;
                    *manjaro*)               echo LINUX_MANJARO_ICON;;
                    *void*)                  echo LINUX_VOID_ICON;;
                    *artix*)                 echo LINUX_ARTIX_ICON;;
                    *rhel*)                  echo LINUX_RHEL_ICON;;
                    amzn)                    echo LINUX_AMZN_ICON;;
                    endeavouros)             echo LINUX_ENDEAVOUROS_ICON;;
                    rocky)                   echo LINUX_ROCKY_ICON;;
                    guix)                    echo LINUX_GUIX_ICON;;
                    neon)                    echo LINUX_NEON_ICON;;
                    *)                       echo LINUX_ICON;;
                esac
                ;;
        esac
    fi
}

# Main function to print the icon
function print_os_icon() {
    local icon_name=$(os_icon_name)
    local os_icon=${(g::)icons[$icon_name]}
    echo -e "$os_icon"
}

# Call the main function
print_os_icon
