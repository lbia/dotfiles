# number-toggle.kak

declare-option -docstring 'add line highlighter' bool show_lines "false"

declare-option -docstring 'line number highlighter parameters' str-list number_toggle_params

declare-option -hidden str number_toggle_internal_state '-relative'

define-command -hidden number-toggle-refresh %{
    reg p %opt{show_lines}
    evaluate-commands %sh{
        if [ "$kak_main_reg_p" = "true" ]; then
            printf '%s' "add-highlighter -override window/number-toggle number-lines $kak_quoted_opt_number_toggle_params $kak_opt_number_toggle_internal_state"
        elif [ "$kak_main_reg_p" = "false" ]; then
            printf '%s' "remove-highlighter window/number-toggle"
        fi
    }
}

define-command -hidden number-toggle-install-focus-hooks %{
    hook -group number-toggle-focus window FocusOut .* %{
        set-option window number_toggle_internal_state ''
        number-toggle-refresh
    }
    hook -group number-toggle-focus window FocusIn .* %{
        set-option window number_toggle_internal_state '-relative'
        number-toggle-refresh
    }
}

define-command -hidden number-toggle-uninstall-focus-hooks %{
    remove-hooks window number-toggle-focus
}

# display relative line numbers when starting Kakoune in normal mode
hook -always global WinCreate .* %{
    set-option window number_toggle_internal_state '-relative'
    number-toggle-refresh
    number-toggle-install-focus-hooks
}

# display absolute line numbers when entering insert mode
hook -always global ModeChange push:.*:insert %{
    set-option window number_toggle_internal_state ''
    number-toggle-refresh
    number-toggle-uninstall-focus-hooks
}

# display relative line numbers when leaving insert mode
hook -always global ModeChange pop:insert:.* %{
    set-option window number_toggle_internal_state '-relative'
    number-toggle-refresh
    number-toggle-install-focus-hooks
}

define-command -override ui-line-numbers-toggle -docstring 'toggle line numbers' %{
    reg p %opt{show_lines}
    evaluate-commands %sh{
        if [ "$kak_main_reg_p" = "false" ]; then
            printf 'set-option global show_lines true\n'
            printf 'echo -markup "{Information}line numbers enabled"\n'
        elif [ "$kak_main_reg_p" = "true" ]; then
            printf "set-option global show_lines false\n"
            printf 'echo -markup "{Information}line numbers disabled"\n'
        fi
    }
    number-toggle-refresh
    trigger-user-hook ui-hl-changed
}