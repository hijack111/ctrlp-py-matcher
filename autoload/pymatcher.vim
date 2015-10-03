" Python Matcher

if !has('python') && !has('python3')
    echo 'In order to use pymatcher plugin, you need +python or +python3 compiled vim'
endif

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')

if has('python3')
  execute 'py3file ' . s:plugin_path . '/pymatcher.py'
else
  execute 'pyfile ' . s:plugin_path . '/pymatcher.py'
endif

" Credit: CtrlP C matching extension
"
" By: Stanislav Golovanov <stgolovanov@gmail.com>
"     MaxSt <https://github.com/MaxSt>
"     Aaron Jensen <aaronjensen@gmail.com>

fu! s:escapewords(words)
  if exists('+ssl') && !&ssl
    cal map(a:words, 'escape(v:val, ''\'')')
  en
  for each in ['^', '$', '.']
    cal map(a:words, 'escape(v:val, each)')
  endfo

  return a:words
endfu

fu! s:highlight(input, mmode, regex)
    " highlight matches
    cal clearmatches()
    if a:regex
      let pat = ""
      if a:mmode == "filename-only"
        let pat = substitute(a:input, '\$\@<!$', '\\ze[^\\/]*$', 'g')
      en
      if empty(pat)
        let pat = substitute(a:input, '\\\@<!\^', '^> \\zs', 'g')
      en
      cal matchadd('CtrlPMatch', '\c'.pat)
    el
      let words = split(a:input)
      let words = s:escapechars(words)

      " Build a pattern like /a.*b.*c/ from abc (but with .\{-} non-greedy
      " matchers instead)
      let pat = join(words, '.\{-}')
      " Ensure we match the last version of our pattern
      let ending = '\(.*'.pat.'\)\@!'
      " Case insensitive
      let beginning = '\c^.*'
      if a:mmode == "filename-only"
        " Make sure there are no slashes in our match
        let beginning = beginning.'\([^\/]*$\)\@='
      end

      for i in range(len(words))
        " Surround our current target letter with \zs and \ze so it only
        " actually matches that one letter, but has all preceding and trailing
        " letters as well.
        " \zsa.*b.*c
        " a\(\zsb\|.*\zsb)\ze.*c
"         let words = copy(words)
        if i == 0
          let words[i] = '\zs'.words[i].'\ze'
          let middle = join(words, '.\{-}')
        else
          let before = join(words[0:i-1], '.\{-}')
          let after = join(words[i+1:-1], '.\{-}')
          let c = words[i]
          " for abc, match either ab.\{-}c or a.*b.\{-}c in that order
          let cpat = '\(\zs'.c.'\|'.'.*\zs'.c.'\)\ze.*'
          let middle = before.cpat.after
        endif

        " Now we matchadd for each letter, the basic form being:
        " ^.*\zsx\ze.*$, but with our pattern we built above for the letter,
        " and a negative lookahead ensuring that we only highlight the last
        " occurrence of our letters. We also ensure that our matcher is case
        " insensitive.
        cal matchadd('CtrlPMatch', beginning.middle.ending)
      endfor
    en
    cal matchadd('CtrlPLinePre', '^>')
endf

function! pymatcher#PyMatch(items, query, limit, mmode, ispath, crfile, regex_flag)
    cal s:highlight(a:query, a:mmode, a:regex_flag)

    let g:pym_debug = a:query
"   CtrlPyMatch will write matched line into list s:res
    execute 'python' . (has('python3') ? '3' : '') . ' ctrlp_py_matcher()'

    return s:res
endfunction
