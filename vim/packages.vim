command! PackUpdate packadd minpac | source $MYVIMRC | redraw | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

if !exists('*minpac#init')
  finish
endif

call minpac#init()

call minpac#add('k-takata/minpac', {'type':'opt'})

call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-endwise')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-rsi')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-vinegar')
"Plug 'tpope/vim-surround'

call minpac#add('machakann/vim-sandwich')

call minpac#add('w0rp/ale')

call minpac#add('romainl/vim-qf')
call minpac#add('romainl/vim-qlist')
" call minpac#add('romainl/vim-cool')
call minpac#add('romainl/vim-tinyMRU')

call minpac#add('tommcdo/vim-lion')

call minpac#add('Rip-Rip/clang_complete')

" When I start writing html again
" Plug 'rstacruz/sparkup'

call minpac#add('elzr/vim-json')
call minpac#add('Vimjas/vim-python-pep8-indent')

call minpac#add('SirVer/ultisnips')
call minpac#add('honza/vim-snippets')

call minpac#add('kana/vim-textobj-user')
call minpac#add('kana/vim-textobj-indent')    " i
call minpac#add('sgur/vim-textobj-parameter') " ,

call minpac#add('junegunn/fzf')

" Colorschemes
call minpac#add('robertmeta/nofrils', {'type':'opt'})
call minpac#add('romainl/Apprentice', {'type':'opt'})
call minpac#add('altercation/vim-colors-solarized', {'type':'opt'})
call minpac#add('lifepillar/vim-solarized8', {'type':'opt'})