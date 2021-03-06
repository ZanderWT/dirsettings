"
" Plugin: dirsettings
"
" Version: 1.0
"
" Description:
"
"   This is a very simple plugin that allows for directory tree-specific vim
"   settings.  For every file edited, it searches upward from that file's
"   directory for a file named '.vimdir' and sources it.
"
" Original Author: Tye Z. < z d r o @ y a h o o . c o m >
"
" 

if version < 700
    finish
endif

" Define a group so we can delete them when this file is sourced, and we don't
" end up with multiple autocmd entries if this file is sourced more than once.
augroup dirsettings
au! dirsettings
au dirsettings BufNew,BufNewFile,BufReadPost,VimEnter * call SourceFileUpward('.vimdir')

"
" Search upward for the given file and source it. Also lcd to the closest
" parent directory containing a matching file.
func! SourceFileUpward(fname)
    try
        exe 'lcd ' . escape(expand("%:p:h"), ' ')
        let l:flist=FindFileUpward(a:fname)
        for l:fname in reverse(l:flist)
            if filereadable(l:fname)
                exe 'sou ' . l:fname
                exe 'lcd ' . fnamemodify(l:fname, ":h")
            endif
        endfor
    catch
      "Just fail silently in buffers without a working directory.
    endtry
endfunc

"
" Search upward for the given file.
"
func! FindFileUpward(fname)
    let l:flist=findfile(a:fname, '.;', -1)
    " force the full path of the file if there's a .vimdir in the current
    " working directory
    if l:flist[0] == ".vimdir"
        let l:flist[0] = getcwd() . '/.vimdir'
    endif
    return l:flist
endfunc
