root = exports ? window
root.Vamonos = 

    # assigns arguments and default arguments inside widgets. warns when
    # required arguments are not present. warns when unused arguments are
    # present. type-checks arguments.
    handleArguments: ({
        widgetName,         # a string containing the name of the widget for errors

        widgetObject,       # "this"/"@" from widget object
                            
        givenArgs,          # the args object passed to widget constructor

        ignoreExtraArgs,    # optional argument: whether or not to check for extra args.
                            # for use when using constructor args multiple times.
        }) ->

        ignoreExtraArgs ?= false

        throw Error "handleArguments: widgetName required" unless widgetName?
        throw Error "handleArguments: widgetObject required for #{widgetName} widget" unless widgetObject?
        throw Error "handleArguments: givenArgs required for #{widgetName} widget" unless givenArgs?
        throw Error "handleArguments: no spec for #{widgetName} widget" unless widgetObject.constructor.spec?

        # The spec object is required for all widgets. It is an object mapping arg
        # names to objects of the form:
        #
        #            { type, description, [defaultValue] }
        #
        #    args without a default value are required and will cause an error.
        #    optional arguments can be created by using a defaultValue of
        #    undefined. 
        #
        #    type can be a string ("String", "Integer", "Function", etc) or an
        #    array when an argument can be one of many types.

        for argName, specs of widgetObject.constructor.spec
            { type, description, defaultValue } = specs
            throw Error "handleArguments: no type provided for #{widgetName}.#{argName}" unless type?
            type = @arrayify(type)
            if givenArgs[argName]?
                # type-check
                unless givenArgs[argName].constructor.name in type
                    throw TypeError "WIDGET #{widgetName}: constructor argument " +
                        "'#{argName}' expects type '#{type}' but got " +
                        "type '#{givenArgs[argName].constructor.name}'"
                # type-check passed: assign value in widget object
                widgetObject[argName] = givenArgs[argName]
                delete givenArgs[argName] unless ignoreExtraArgs
            else
                if specs.hasOwnProperty("defaultValue")
                    widgetObject[argName] = defaultValue
                else
                    throw Error "#{widgetName}: required argument #{argName} missing."

        unless ignoreExtraArgs
            @warn(widgetName, "unused argument \"#{arg}\"") for arg of givenArgs

    warn: (objName, str) ->
        console.log("### WARNING ### #{objName}: #{str}")

    formatObject: (object, attributes = []) ->
        tbl  = "<table>"
        rows = (for attribute in attributes
            "<tr><td>#{attribute}</td><td>&nbsp=&nbsp" + 
                Vamonos.rawToTxt(object[attribute]) + "</td></tr>")
        tbl += rows.join("") + "</table>"
        tbl

    editableValue: ($elem, valFunc, returnFunc) ->
        # $elem is the element that needs to change into a input box
        # valFunc is a function that takes an $elem and returns its value
        # returnFunc is a function that takes the final value from the input box
        #   and returns the new value for the uneditable element
        doneEditing = () =>
            newVal = returnFunc($editor.val())
            $elem.html(if newVal.length then newVal else oldVal)

        oldVal = valFunc($elem)
        $editor = $("<input class='inline-input'>")
            .hide()
            .width($elem.width())
            .val(oldVal)
            .on "keydown.vamonos-graph", (event) =>
                return unless event.keyCode in [13, 32, 9, 27]
                doneEditing()
                false
            .on "blur.vamonos-graph something-was-selected", (event) =>
                doneEditing()
                true

        $elem.html($editor)
        $editor.fadeIn("fast").focus().select()

    moveToTop: ($elem, $container = $("*")) ->
        $elem.css("z-index", @highestZIndex($container) + 1)

    highestZIndex: ($sel) -> 
        index_highest = 0
        $sel.each ->
            index_current = parseInt($(this).css("zIndex"), 10)
            if index_current > index_highest
                index_highest = index_current
        return index_highest

    insertSet: (item, arraySet) ->
        arraySet.push item unless item in arraySet

    txtToRaw: (txt) ->
        return Infinity if txt.match(/^\+?(inf(inity)?|\u221E)$/i)
        return -Infinity if txt.match(/^-(inf(inity)?|\u221E)$/i)
        if isNaN(parseInt(txt)) then null else parseInt(txt)

    rawToTxt: (raw) ->
        return "" unless raw?
        return "\u221E"       if raw is Infinity
        return "-\u221E"      if raw is -Infinity
        return raw.name       if typeof raw is 'object' and raw.type is 'vertex'
        return raw.id         if typeof raw is 'object' and raw.type is 'edge'
        return "G"            if typeof raw is 'object' and raw.type is 'graph'
        return raw.toString() if typeof raw is 'object' and raw.type is 'queue'
        return "" + raw        

    txtValid: (txt) -> @txtToRaw(txt)?

    isNumber: (val) ->
        return ! isNaN(parseInt(val))
    
    funcify: (arg) ->
        return arg if typeof(arg) is "function"
        return -> arg

    arrayify: (obj) ->
        if obj instanceof Array then obj else [obj]

    jqueryify: (obj) ->
        if typeof obj is 'string' then $("#" + obj) else obj

    export: (obj) ->
        root = exports ? window
        root.Vamonos or= {}
        @mixin( root.Vamonos, obj )

    mixin: (dest, src, f) ->
        for name, val of src
            if (typeof dest[name] is 'object') and (typeof src[name] is 'object')
                @mixin(dest[name], val)
            else
                dest[name] = if f? then f(val) else val
        return dest

    clone: (obj) ->
        return unless obj?
        return obj if (typeof obj).match /number|string|boolean/
        return obj.clone() if obj.type is 'queue'
        if obj.type is 'stash'
            r = {}
            r[k] = Vamonos.clone(v) for k,v of obj
            return r

        return $.extend(true, [], obj) if obj instanceof Array
        return $.extend(true, {}, obj)

