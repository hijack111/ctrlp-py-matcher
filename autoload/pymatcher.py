import vim
import re

RE_ESCAPE_QUOTE = re.compile(r'(?=\\|")')


def CtrlPPyMatch():
    items = vim.eval('a:items')  # ... List
    input = vim.eval('a:input')
    limit = int(vim.eval('a:limit'))
    mmode = vim.eval('a:mmode')
    regex_flag = int(vim.eval('a:regex_flag'))

    if regex_flag == 1:
        # BUG: We use Python's regex engine here instead of VIM
        regex = [re.compile(input)]
    else:
        words = input.split()
        words = map(re.escape, words)
        # regex[0]: Immitating Fasd's behavior -- the filename must be matched
        # by the last word.
        # regex[1]: CtrlP's default matching strategy.
        regex = [re.compile('.*'.join(words) + '[^/]*$', re.I),
                 re.compile('.*'.join(words) + '.*$', re.I)]

    res = []
    # Generators generating matched lines
    for i in range(len(regex)):
        r = regex[i]
        if mmode == 'filename-only':
            # Only the part after the last / is checked
            res_gen = (l for l in items if r.search(l.split('/')[-1]))
        elif mmode == 'first-non-tab':
            # Only the part before the first \t is checked
            res_gen = (l for l in items if r.search(l.split('\t')[0]))
        elif mmode == 'until-last-tab':
            # Only the part before the last \t is checked
            res_gen = (l for l in items if r.search(l.rsplit('\t', 1)[0]))
        else:
            # A full line match
            res_gen = (l for l in items if r.search(l))

        # res_gen.next() consums most of the time
        for l in res_gen:
            if l not in res:
                res.append(l)
                if len(res) == limit:
                    break

        if len(res) == limit:
            break

    # Use double quoted vim strings and escape \
    res_quoted = ['"' + RE_ESCAPE_QUOTE.sub(r'\\', l) + '"' for l in res]

    vim.command('let s:res = [{0}]'.format(','.join(res_quoted)))
