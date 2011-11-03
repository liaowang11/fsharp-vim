" Vim filetype plugin
" Language:     F#
" Last Change:  Fri 04 Nov 2011 12:16:49 AM CET
" Maintainer:   Gregor Uhlenheuer <kongo2002@googlemail.com>

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" enable syntax based folding
setl fdm=syntax

" comment settings
setl formatoptions=croql
setl commentstring=(*%s*)
setl comments=s0:*\ -,m0:*\ \ ,ex0:*),s1:(*,mb:*,ex:*),:\/\/\/,:\/\/

let s:candidates = [ 'fsi',
            \ 'fsi.exe',
            \ 'fsharpi',
            \ 'fsharpi.exe' ]

if !exists('g:fsharp_interactive_bin')
    let g:fsharp_interactive_bin = ''
    for c in s:candidates
        if executable(c)
            let g:fsharp_interactive_bin = c
        endif
    endfor
endif

if !executable(g:fsharp_interactive_bin)
    echohl WarningMsg
    echom 'fsharp.vim: no fsharp interactive binary found'
    echom 'fsharp.vim: set g:fsharp_interactive_bin appropriately'
    echohl None
    finish
endif

function! s:launchInteractive(from, to)
    let tmpfile = tempname()
    echo tmpfile
    exec a:from . ',' . a:to . 'w! ' . tmpfile
    exec '!' . g:fsharp_interactive_bin '--gui- --nologo --use:"'.tmpfile.'"'
endfunction

com! -buffer -range=% Interactive call s:launchInteractive(<line1>, <line2>)

let &cpo = s:cpo_save

" vim: sw=4 et sts=4
