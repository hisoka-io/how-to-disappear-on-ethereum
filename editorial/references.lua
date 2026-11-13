-- Keep Markdown notes beside their claims in the source. In the book,
-- replace them with linked superscripts and collect them at the back.
-- One primary-source URL per entry; reuse its number across chapters.
local sources = {}
local file = assert(io.open('research/sources.md', 'r'))
for line in file:lines() do
  local id, description = line:match('^%- %[(%u%d+)%] (.*)')
  if id then
    sources[id] = sources[id] or {}
    for url in description:gmatch('https?://[^%s]+') do
      url = url:gsub('[,;%.%)]+$', '')
      table.insert(sources[id], url)
    end
  end
end
file:close()

function Pandoc(doc)
  local entries, numbers = {}, {}
  local function collect(note)
    local ids = {}
    local plain = pandoc.utils.stringify(note.content)
    for id in plain:gmatch('%[(%u%d+)%]') do
      ids[#ids + 1] = id
    end
    assert(#ids == 1, 'Each reference must name exactly one source ID: ' .. plain)
    local source = sources[ids[1]]
    assert(source and #source == 1,
      'Source [' .. ids[1] .. '] must have exactly one URL')
    local url = source[1]
    -- Match the source, not the wording of a note or its chapter-local ID.
    local key = url:gsub('/+$', '')
    local number = numbers[key]
    if not number then
      number = #entries + 1
      numbers[key] = number
      local content = pandoc.Div(note.content):walk({
        Link = function(link)
          error('Use a source ID rather than an inline link in a reference')
        end,
        Str = function(str)
          assert(not str.text:match('https?://'),
            'Use a source ID rather than a bare URL in a reference')
          str.text = str.text:gsub('%[(%u%d+)%]', '')
          if str.text == '' then return {} end
          return str
        end
      }).content
      -- One clickable, printable address; fuller claim maps stay in research.
      content:insert(pandoc.Para({pandoc.Link({pandoc.Str(url)}, url)}))
      -- Keep a reference's description and addresses on the same page.
      content:insert(1, pandoc.RawBlock('latex', '\\begin{minipage}[t]{\\linewidth}'))
      content:insert(pandoc.RawBlock('latex', '\\end{minipage}'))
      entries[number] = {pandoc.Div(content,
        pandoc.Attr('reference-' .. number))}
    end
    return pandoc.Superscript({pandoc.Link(
      {pandoc.Str(tostring(number))}, '#reference-' .. number)})
  end

  -- Walk top-level blocks sequentially; the default type-wise walk would
  -- otherwise make first-appearance numbering harder to reason about.
  for i, block in ipairs(doc.blocks) do
    doc.blocks[i] = block:walk({Note = collect})
  end
  if #entries == 0 then return doc end
  doc.blocks:insert(pandoc.RawBlock('latex', [[
\chapter*{References}
\phantomsection
\addcontentsline{toc}{chapter}{References}
\markboth{References}{}
\begingroup
\small
\setstretch{1.03}
\raggedright
\setlist[enumerate]{itemsep=0.2em,parsep=0pt,topsep=0.5em}
\setlength{\parskip}{0.3em}
\urlstyle{same}
]]))
  doc.blocks:insert(pandoc.OrderedList(entries))
  doc.blocks:insert(pandoc.RawBlock('latex', '\\endgroup'))
  return doc
end
