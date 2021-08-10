"=============================================================================
"" spotivi.vim --- spotivi layer file for SpaceVim
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" " Author: Javier Acevedo C < javier.iacevedoc@gmail.com >
" " URL: https://spacevim.org
" " License: GPLv3
" "=============================================================================
"
let s:JOB = SpaceVim#api#import('job')

function! SpaceVim#layers#spotivi#plugins() abort
    let plugins = []
    call add(plugins, ['Shougo/vimproc',   { 'merged' : 0}])
    return plugins
endfunction

function! SpaceVim#layers#spotivi#config() abort
    let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'S',  {'name' : '+Spotivi'})
    call SpaceVim#mapping#space#def('noremap', ['S','n'], 'Next Song','call spotivi#nextSong()', 1)
    call SpaceVim#mapping#space#def('noremap', ['S','p'], 'Prev Song','call spotivi#previousSong()', 1)
    call SpaceVim#mapping#space#def('noremap', ['S','[SPC]'], 'Toggle Play/Pause','call spotivi#toggle()', 1)
    call SpaceVim#mapping#space#def('noremap', ['S','a'], 'Add to my montly playlist', 'call spotivi#addToMontly()', 1)
endfunction

function! s:on_stdout(id, data, event) abort
    echom 'Playing ♩ ♪ ♫ ♬ ' . a:data[0]
endfunction

function! s:on_stderr(id, data, event) abort
    echo 'Error!'
endfunction

function! s:on_exit(id, data, event) abort
endfunction

function! spotivi#onchange() abort
    redraw
    let timerid = timer_start(2000,{-> execute('call spotivi#getSong()') })
endfunction

function! spotivi#getSong() abort
    let cmd = ['spotibar', '--get-currently-playing']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! spotivi#nextSong() abort
    let cmd = ['spotibar', '--next-track']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : spotivi#onchange(),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! spotivi#previousSong() abort
    let cmd = ['spotibar', '--previous-track']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : spotivi#onchange(),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! spotivi#toggle() abort
    let cmd = ['spotibar', '--toggle-playback']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : spotivi#getSong(),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! spotivi#addToMontly() abort
    let cmd = ['spotibar', '--add-track-to-monthly-playlist']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : spotivi#getSong(),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

" vim:set et sw=2 cc=80
