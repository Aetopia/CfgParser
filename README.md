# CfgParser
An alternative `parsecfg` configuration parser for Nim.

## Aim
Aim of this project is the following:

1. Resolve unintended interpretation of configuration files.   
    `parsecfg` sometimes doesn't parse key-value pairs correctly depending on how the key and value are represented in the file.

    Example:  
    **Key Value Pair**
    ```ini
    NamedCounts=(("DiscoveryLobbyMatchmakingPlay", 23),("DiscoveryLobbyMatchmakingPlay_HotfixVer", 0),("lastfrontendflow_Fortnite", 23),("lastfrontendflow_Fortnite_HotfixVer", 0),("UEnableMultiFactorModal::ShouldShowMFASplashScreen", 23),("UEnableMultiFactorModal::ShouldShowMFASplashScreen_HotfixVer", 0),("FrontendContext:ShouldShowSocialImport", 23),("FrontendContext:ShouldShowSocialImport_HotfixVer", 0))
    ```

    **What it is parsed as**
    ```ini
    namedcounts="""(("DiscoveryLobbyMatchmakingPlay", 23),("DiscoveryLobbyMatchmakingPlay_HotfixVer", 0),("lastfrontendflow_Fortnite", 23),("lastfrontendflow_Fortnite_HotfixVer", 0),("UEnableMultiFactorModal::ShouldShowMFASplashScreen", 23),("UEnableMultiFactorModal::ShouldShowMFASplashScreen_HotfixVer", 0),("FrontendContext:ShouldShowSocialImport", 23),("FrontendContext:ShouldShowSocialImport_HotfixVer", 0))"""
    ```

2. Implement customizable parsing arguments.
3. Implement similar functions present in `parsecfg`.


## Functions and Objects

1. Configuration File Object.
    ```nim
    type Cfg* = OrderedTableRef[string, OrderedTableRef[string, string]]
    ```

2. Create a new Configuration File Object.
    ```nim
    proc newCfg*: Cfg
    ```

3. Load a Configuration File Object using a string or file.

    - String Representation

        ```nim
        proc loadCfg*(str: string, case_sensitive: bool = true, delimiter: char = '=', comments: openArray[char] = [';']): Cfg
        ```
        - `str`: String representation of the configuration file.
        - `case_sensitive`: Whether keys and sections should be case_senstive.
        - `delimiter`: The character used to separate keys from values.
        - `comments`: A sequence of characters used to indicate comments.
    
    - Filename

        ```nim
        proc readCfg*(str: string, case_sensitive: bool = true, delimiter: char = '=', comments: openArray[char] = [';']): Cfg
        ```
        - `filename`: Name of the file to read from.
        - `case_sensitive`: Whether keys and sections should be case_senstive.
        - `delimiter`: The character used to separate keys from values.
        - `comments`: A sequence of characters used to indicate comments.

4. Dump/Write a Configuration File Object as a string or file.

    - String Representation

        ```
        proc dumpCfg*(cfg: Cfg, delimiter: char = '='): string
        ```
        - `cfg`: Configuration File Object
        - `delimiter`: The character used to separate keys from values.
    
    - File

        ```nim
        proc writeCfg*(cfg: Cfg, filename: string, delimiter: char = '=')
        ```
        - `cfg`: Configuration File Object
        - `filename`: Name of the file write.
        - `delimiter`: The character used to separate keys from values.






