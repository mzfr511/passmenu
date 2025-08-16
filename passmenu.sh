#!/usr/bin/env bash

# ابزار مورد نیاز: pass, rofi, xclip

PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

# تابع انتخاب entry (حذف ├── و └──)
select_entry() {
    pass list \
	| sed '1d' \
        | sed -e 's/^[[:space:]]*├── //' -e 's/^[[:space:]]*└── //' \
        | xargs -n1 \
        | rofi -dmenu -p "Select entry:"
}

# منوی اصلی
action=$(printf "Generate\nStore\nRead\nEdit\nRemove" | rofi -dmenu -p "Password Manager:")

case "$action" in

    "Generate")
        entry=$(rofi -dmenu -p "Entry name:")
        [[ -z $entry ]] && exit 0

        length=$(rofi -dmenu -p "Password length:" -filter "16")
        [[ -z $length ]] && exit 0

        username=$(rofi -dmenu -p "Username (optional):")
        url=$(rofi -dmenu -p "URL (optional):")

        new_pass=$(openssl rand -base64 48 | tr -d '\n' | head -c "$length")

        tmpfile=$(mktemp)
        echo "$new_pass" > "$tmpfile"
        echo "" >> "$tmpfile"
        [[ -n $username ]] && echo "username: $username" >> "$tmpfile"
        [[ -n $url ]] && echo "url: $url" >> "$tmpfile"

        pass insert -m "$entry" < "$tmpfile"
        rm "$tmpfile"

        echo -n "$new_pass" | xclip -selection clipboard
        notify-send "Password Manager" "✅ New password generated & copied for $entry"
        ;;

    "Store")
        entry=$(rofi -dmenu -p "Entry name:")
        [[ -z $entry ]] && exit 0

        password=$(rofi -dmenu -p "Password:")
        [[ -z $password ]] && exit 0

        username=$(rofi -dmenu -p "Username (optional):")
        url=$(rofi -dmenu -p "URL (optional):")

        tmpfile=$(mktemp)
        echo "$password" > "$tmpfile"
        echo "" >> "$tmpfile"
        [[ -n $username ]] && echo "username: $username" >> "$tmpfile"
        [[ -n $url ]] && echo "url: $url" >> "$tmpfile"

        pass insert -m "$entry" < "$tmpfile"
        rm "$tmpfile"

        notify-send "Password Manager" "✅ Password stored for $entry"
        ;;

    "Read")
        entry=$(select_entry)
        [[ -z $entry ]] && exit 0

        read_action=$(printf "Copy Password\nCopy Username" | rofi -dmenu -p "Action for $entry:")
        case "$read_action" in
            "Copy Password")
                pass show "$entry" | head -n1 | tr -d '\r' | xclip -selection clipboard
                notify-send "Password Manager" "📋 Password for $entry copied!"
                ;;
            "Copy Username")
                pass show "$entry" | grep -i "^username:" | cut -d' ' -f2- | tr -d '\r' | xclip -selection clipboard
                notify-send "Password Manager" "📋 Username for $entry copied!"
                ;;
        esac
        ;;

    "Edit")
        entry=$(select_entry)
        [[ -z $entry ]] && exit 0

        # خواندن پسورد و اطلاعات فعلی
        old_pass=$(pass show "$entry" | head -n1)
        old_username=$(pass show "$entry" | grep -i "^username:" | cut -d' ' -f2-)
        old_url=$(pass show "$entry" | grep -i "^url:" | cut -d' ' -f2-)

        # گرفتن مقادیر جدید
        new_pass=$(rofi -dmenu -p "New password (leave empty to keep old one)")
        [[ -z $new_pass ]] && new_pass="$old_pass"

        new_username=$(rofi -dmenu -p "Username (leave empty to keep old one)" -filter "$old_username")
        [[ -z $new_username ]] && new_username="$old_username"

        new_url=$(rofi -dmenu -p "URL (leave empty to keep old one)" -filter "$old_url")
        [[ -z $new_url ]] && new_url="$old_url"

        tmpfile=$(mktemp)
        echo "$new_pass" > "$tmpfile"
        echo "" >> "$tmpfile"
        [[ -n $new_username ]] && echo "username: $new_username" >> "$tmpfile"
        [[ -n $new_url ]] && echo "url: $new_url" >> "$tmpfile"

        pass insert -f -m "$entry" < "$tmpfile"
        rm "$tmpfile"

        notify-send "Password Manager" "✏️ $entry updated"
        ;;

    "Remove")
        entry=$(select_entry)
        [[ -z $entry ]] && exit 0
        confirm=$(echo -e "No\nYes" | rofi -dmenu -p "Really delete $entry?")
        [[ "$confirm" == "Yes" ]] && pass rm "$entry"
        ;;

    *)
        exit 0
        ;;
esac

