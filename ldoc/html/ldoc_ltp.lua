return [==[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=$(ldoc.doc_charset)"/>
<head>
    <title>$(ldoc.title)</title>
    <link rel="stylesheet" href="$(ldoc.css)" type="text/css" />
</head>
<body>

<div id="container">

<div id="product">
	<div id="product_logo"></div>
	<div id="product_name"><big><b></b></big></div>
	<div id="product_description"></div>
</div> <!-- id="product" -->


<div id="main">

# local no_spaces = ldoc.no_spaces
# local use_li = ldoc.use_li
# local display_name = ldoc.display_name
# local iter = ldoc.modules.iter
# ---local M = ldoc.markup
# local function M(txt,item) return ldoc.markup(txt,item,ldoc.plain) end
# local nowrap = ldoc.wrap and '' or 'nowrap'

<!-- Menu -->

<div id="navigation">
<br/>
<h1>$(ldoc.project)</h1>

# if not ldoc.single and module then -- reference back to project index
<ul>
  <li><a href="../$(ldoc.output).html">Index</a></li>
</ul>
# end

# --------- contents of module -------------
# if module and not ldoc.no_summary and #module.items > 0 then
<h2>Contents</h2>
<ul>
# for kind,items in module.kinds() do
<li><a href="#$(no_spaces(kind))">$(kind)</a></li>
# end
</ul>
# end


# if ldoc.no_summary and module and not ldoc.one then -- bang out the functions on the side
# for kind, items in module.kinds() do
<h2>$(kind)</h2>
<ul>
# for item in items() do
    <li><a href="#$(item.name)">$(display_name(item))</a></li>
# end
</ul>
# end
# end
# -------- contents of project ----------
# -- if not ldoc.no_summary then
# local this_mod = module and module.name
# for kind, mods, type in ldoc.kinds() do
#  if not ldoc.kinds_allowed or ldoc.kinds_allowed[type] then
<h2>$(kind)</h2>
<ul>
#  for mod in mods() do
#   if mod.name == this_mod then -- highlight current module, link to others
  <li><strong>$(mod.name)</strong></li>
#   else
  <li><a href="$(ldoc.ref_to_module(mod))">$(mod.name)</a></li>
#   end
#  end
# end
# -- end
</ul>
# end

</div>

<div id="content">

#if module then
<h1>$(ldoc.titlecase(module.type)) <code>$(module.name)</code></h1>
# end

# if ldoc.body then -- verbatim HTML as contents; 'non-code' entries
    $(ldoc.body)
# elseif module then -- module documentation
<p>$(M(module.summary,module))</p>
<p>$(M(module.description,module))</p>
#   if module.usage then
#     local li,il = use_li(module.usage)
    <h3>Usage:</h3>
    <ul>
#     for usage in iter(module.usage) do
        $(li)<pre class="example">$(ldoc.escape(usage))</pre>$(il)
#     end -- for
    </ul>
#   end -- if usage
#   if module.info then
    <h3>Info:</h3>
    <ul>
#     for tag, value in ldoc.pairs(module.info) do
        <li><strong>$(tag)</strong>: $(value)</li>
#     end
    </ul>
#   end -- if module.info


# if not ldoc.no_summary then
# -- bang out the tables of item types for this module (e.g Functions, Tables, etc)
# for kind,items in module.kinds() do
<h2><a href="#$(no_spaces(kind))">$(kind)</a></h2>
<table class="function_list">
#  for item in items() do
	<tr>
	<td class="name" $(nowrap)><a href="#$(item.name)">$(display_name(item))</a></td>
	<td class="summary">$(M(item.summary,item))</td>
	</tr>
#  end -- for items
</table>
#end -- for kinds

<br/>
<br/>

#end -- if not no_summary

# --- currently works for both Functions and Tables. The params field either contains
# --- function parameters or table fields.
# local show_return = not ldoc.no_return_or_parms
# local show_parms = show_return
# for kind, items in module.kinds() do
#   local kitem = module.kinds:get_item(kind)
    <h2><a name="$(no_spaces(kind))"></a>$(kind)</h2>
#--    $(M(module.kinds:get_section_description(kind),nil))
#   if kitem then
        $(M(ldoc.descript(kitem),kitem))
#       if kitem.usage then
            <h3>Usage:</h3>
            <pre class="example">$(ldoc.prettify(kitem.usage[1]))</pre>
#        end
#   end
    <dl class="function">
#  for item in items() do
    <dt>
    <a name = "$(item.name)"></a>
    <strong>$(display_name(item))</strong>
    </dt>
    <dd>
    $(M(ldoc.descript(item),item))

#  if show_parms and item.params and #item.params > 0 then
    <h3>$(module.kinds:type_of(item).subnames):</h3>
    <ul>
#   for parm in iter(item.params) do
#     local param,sublist = item:subparam(parm)
#     if sublist then
        <li><span class="parameter">$(sublist)</span>$(M(item.params[sublist],item))
        <ul>
#     end
#     for p in iter(param) do
#        local name,tp = item:display_name_of(p), ldoc.typename(item:type_of_param(p))
        <li><span class="parameter">$(name)</span>
#       if tp ~= '' then
            <span class="types">$(tp)</span>
#        end
        $(M(item.params[p],item))</li>
#     end
#     if sublist then
        </li></ul>
#     end
#   end -- for
    </ul>
#   end -- if params

#   if show_return and item.ret then
#     local li,il = use_li(item.ret)
    <h3>Returns:</h3>
    <ol>
#     for i,r in ldoc.ipairs(item.ret) do
        $(li)
#       local tp = ldoc.typename(item:type_of_ret(i))
#       if tp ~= '' then
          <span class="types">$(tp)</span>
#       end
        $(M(r,item))$(il)
#     end -- for
    </ol>
#   end -- if returns

#   if show_return and item.raise then
    <h3>Raises:</h3>
    $(M(item.raise,item))
#   end

#   if item.see then
#     local li,il = use_li(item.see)
    <h3>see also:</h3>
    <ul>
#     for see in iter(item.see) do
         $(li)<a href="$(ldoc.href(see))">$(see.label)</a>$(il)
#    end -- for
    </ul>
#   end -- if see

#   if item.usage then
#     local li,il = use_li(item.usage)
    <h3>Usage:</h3>
    <ul>
#     for usage in iter(item.usage) do
        $(li)<pre class="example">$(ldoc.prettify(usage))</pre>$(il)
#     end -- for
    </ul>
#   end -- if usage

</dd>
# end -- for items
</dl>
# end -- for kinds

# else -- if module; project-level contents

# if ldoc.description then
  <h2>$(M(ldoc.description,nil))</h2>
# end
# if ldoc.full_description then
  <p>$(M(ldoc.full_description,nil))</p>
# end

# for kind, mods in ldoc.kinds() do
<h2>$(kind)</h2>
# kind = kind:lower()
<table class="module_list">
# for m in mods() do
	<tr>
		<td class="name"  $(nowrap)><a href="$(no_spaces(kind))/$(m.name).html">$(m.name)</a></td>
		<td class="summary">$(M(m.summary,m))</td>
	</tr>
#  end -- for modules
</table>
# end -- for kinds
# end -- if module

</div> <!-- id="content" -->
</div> <!-- id="main" -->
<div id="about">
<i>generated by <a href="http://github.com/stevedonovan/LDoc">LDoc 1.3.12</a></i>
</div> <!-- id="about" -->
</div> <!-- id="container" -->
</body>
</html>
]==]

