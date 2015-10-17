ctrlp-py-matcher
================

Fast CtrlP matcher based on python

To get more information on compatibility and installation issue, please see the original [ctrlp-py-matcher](https://github.com/FelikZ/ctrlp-py-matcher).

Difference with the original ctrp-py-matcher
----------------------------

+ Use word-by-word matching style instead of [CtrlP](https://github.com/kien/ctrlp.vim)'s char-by-char style. Word-by-word matching imitates behaviors of [Fasd](https://github.com/clvv/fasd) and [Z](https://github.com/rupa/z), and makes [ctrlp-z](https://github.com/amiorin/ctrlp-z) works in a more natural way.

+ Provide better highlighting in CtrlP's selection window. Courtesy to the highlighting algorithm of [ctrlp-cmatcher](https://github.com/JazzCore/ctrlp-cmatcher/blob/master/autoload/matcher.vim).


Installation
------------
To install this plugin you **need** Vim compiled with `+python` flag:

```
vim --version | grep python
```

This plugin should be compatible with vim **7.x** and [NeoVIM](http://neovim.io) as well.

**If you still have performance issues, it can be caused by [bufferline](https://github.com/bling/vim-bufferline) or alike plugins. So if, for example, it caused by bufferline you can switch to [airline](https://github.com/bling/vim-airline) and setup this option:**

```
let g:airline#extensions#tabline#enabled = 1
```


### Pathogen (https://github.com/tpope/vim-pathogen)
```
git clone https://github.com/hijack111/ctrlp-py-matcher ~/.vim/bundle/ctrlp-py-matcher
```

### Vundle (https://github.com/gmarik/vundle)
```
Plugin 'hijack111/ctrlp-py-matcher'
```

### NeoBundle (https://github.com/Shougo/neobundle.vim)
```
NeoBundle 'hijack111/ctrlp-py-matcher'
```

### ~/.vimrc setup

    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
