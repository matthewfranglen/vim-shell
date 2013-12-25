" shell.vim - Shell commands write to a vim buffer
" Maintainer: Matthew Franglen
" Version:    0.0.0

if exists('g:loaded_shell') || &compatible
  finish
else
  let g:loaded_shell = 1
endif

" Execute shell commands as :Shell <CMD> and they will be written to a buffer.
" Slight adjustment to:
" http://vim.wikia.com/wiki/Display_shell_commands%27_output_on_Vim_window
"
" This does preserve buffers, but realise that new buffers are created for
" different commands. Inside the buffer for a command you can rerun the
" command that generated that buffer with <leader>r.

function! s:ExecuteInShell(command)
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command

    " This resizes to the length of the output, but no more than one third of
    " the screen.
    let one_third = &lines / 3
    let command_size = line('$')
    let window_size = command_size < one_third ? command_size : one_third
    silent! execute 'resize ' . window_size

    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
    echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
