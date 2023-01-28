# Line Based Configuration Parser
import tables
import strutils

type Cfg* = OrderedTableRef[string, OrderedTableRef[string, string]]
proc newCfg*: Cfg = return newOrderedTable[string, OrderedTableRef[string,
        string]]()

proc setSectionValue*(cfg: var Cfg, section, key, value: string) =
    let
        s_section = section.strip()
        s_key = key.strip()
    if not cfg.hasKey(s_section): cfg[s_section] = newOrderedTable[string,
            string]()
    cfg[s_section][s_key] = value.strip()

proc delSection*(cfg: var Cfg, section: string) =
    cfg.del(section.strip())

proc delSectionKey*(cfg: var Cfg, section, key: string) =
    cfg[section.strip()].del(key.strip())

proc getSectionValue*(cfg: Cfg, section, key: string,
        default: string = ""): string =
    let s_section = section.strip()
    if cfg.hasKey(s_section):
        if cfg[s_section].hasKey(key):
            return cfg[s_section][key.strip()]
    return default

proc loadCfg*(str: string, caseSensitive: bool = true,
        delimiter: char = '=', comments: openArray[char] = [';']): Cfg =

    var
        cfg = newCfg()
        section: string

    # Create a reserved section.
    cfg[""] = newOrderedTable[string, string]()

    for i in str.splitLines():
        let line = i.strip()

        if line.len == 0 or comments.contains(line[0]): continue

        # Parse the section.
        elif [line[0], line[^1]] == ['[', ']']:
            section = line.strip(chars = {'[', ']', ' '})
            if not case_sensitive: section = section.toLower()
            cfg[section] = newOrderedTable[string, string]()

        else:
            let
                keyvalue = line.split(delimiter, 1)
                key = keyvalue[0].strip()
                value = keyvalue[1].strip()
            if key != "" or value != "":
                if not case_sensitive: cfg[section][key.toLower()] = value
                else: cfg[section][key] = value

    return cfg

proc readCfg*(filename: string, caseSensitive: bool = true,
        delimiter: char = '=', comments: openArray[char] = [';']): Cfg =
    return loadCfg(readFile(filename))

proc dumpCfg*(cfg: Cfg, delimiter: char = '='): string =
    var content: seq[string]
    for section in cfg.keys:
        if section != "": content.add("[" & section & "]")
        for key in cfg[section].keys:
            let value = cfg[section][key]
            if key != "" or value != "":
                content.add(key & delimiter & value)
        content.add("")
    return content.join("\n").strip(chars = {'\n'})

proc writeCfg*(cfg: Cfg, filename: string, delimiter: char = '=') =
    writeFile(filename, dumpCfg(cfg, delimiter))

proc `$`*(cfg: Cfg): string =
    return dumpCfg(cfg)
