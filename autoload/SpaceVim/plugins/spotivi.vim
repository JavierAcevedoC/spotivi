"=============================================================================
"" spotivi.vim --- spotivi layer file for SpaceVim
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" " Author: Javier Acevedo C < javier.iacevedoc@gmail.com >
" " URL: https://spacevim.org
" " License: GPLv3
" "=============================================================================
"
let s:JOB = SpaceVim#api#import('job')

function! SpaceVim#plugins#spotivi#init() abort
    " let g:_spacevim_mappings_space.S = get(g:_spacevim_mappings_space, 'S',  {'name' : '+Spotivi'})
    " call SpaceVim#mapping#space#def('noremap', ['S','n'], 'call spotivi#nextSong()', 'Next Song', 1)
    " call SpaceVim#mapping#space#def('noremap', ['S','p'], 'call spotivi#previousSong()','Prev Song', 1)
    " call SpaceVim#mapping#space#def('noremap', ['S','[SPC]'], 'call spotivi#toggle()', 'Toggle Play/Pause', 1)
    " call SpaceVim#mapping#space#def('noremap', ['S','a'], 'call spotivi#addToMontly()', 'Add to my montly playlist', 1)
    echom 'Starting!'
    call SpaceVim#custom#SPCGroupName(['S'], '+Spotivi')
    call SpaceVim#custom#SPC('nore', ['S','n'], 'call s:nextSong()', 'Next Song', 1)
    call SpaceVim#custom#SPC('nore', ['S','p'], 'call s:previousSong()','Prev Song', 1)
    call SpaceVim#custom#SPC('nore', ['S','[SPC]'], 'call s:toggle()', 'Toggle Play/Pause', 1)
    call SpaceVim#custom#SPC('nore', ['S','a'], 'call s:addToMontly()', 'Add to my montly playlist', 1)
    echom 'Initialized!'
endfunction

function! s:on_stdout(id, data, event) abort
    echom 'Playing ♩ ♪ ♫ ♬ ' . a:data[0]
endfunction

function! s:on_stderr(id, data, event) abort
    echo 'Error!'
endfunction

function! s:on_exit(id, data, event) abort
endfunction

function! s:onchange() abort
    redraw
    let timerid = timer_start(2000,{-> execute('call s:getSong()') })
endfunction

function! s:getSong() abort
    let cmd = ['spotibar', '--get-currently-playing']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! s:nextSong() abort
    let cmd = ['spotibar', '--next-track']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : spotivi#onchange(),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! s:previousSong() abort
    let cmd = ['spotibar', '--previous-track']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : spotivi#onchange(),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! s:toggle() abort
    let cmd = ['spotibar', '--toggle-playback']
    call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : spotivi#getSong(),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! s:addToMontly() abort
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
