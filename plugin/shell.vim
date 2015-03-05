" shell.vim - Shell commands write to a vim buffer
" Maintainer: Matthew Franglen
" Version:    0.0.1

if exists('g:loaded_shell') || &compatible
  finish
endif
let g:loaded_shell = 1


function! g:ExecuteInShell(arguments)
    let command = s:MakeCommandString(a:arguments)
    call s:CreateOrFindBuffer(command)
    echo 'Execute ' . command . '...'
    call s:ExecuteCommand(command)
    call s:LimitBufferHeightToOneThirdOfTheScreen()
    echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call g:ExecuteInShell(<q-args>)

function s:MakeCommandString(command)
    return join(map(split(a:command), 'expand(v:val)'))
endfunction

function s:CreateOrFindBuffer(name)
    if s:BufferIsPresent(a:name)
        call s:MoveToBuffer(a:name)
    else
        call s:CreateBuffer(a:name)
    endif
endfunction

function s:BufferIsPresent(name)
    let window_number = bufwinnr('^' . a:name . '$')

    return window_number >= 0
endfunction

function s:CreateBuffer(name)
    silent! execute 'botright new ' . fnameescape(a:name)
    silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call g:ExecuteInShell(''' . a:name . ''')<CR>'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
endfunction

function s:MoveToBuffer(name)
    let window_number = bufwinnr('^' . a:name . '$')
    silent! execute window_number . 'wincmd w'
endfunction

function s:ExecuteCommand(command)
    silent! execute 'silent %!'. a:command
endfunction

function s:LimitBufferHeightToOneThirdOfTheScreen()
    let one_third_of_screen = &lines / 3
    let command_size = line('$')
    let window_size = command_size < one_third_of_screen ? command_size : one_third_of_screen
    silent! execute 'resize ' . window_size
    silent! redraw
endfunction
