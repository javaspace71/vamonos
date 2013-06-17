class Stash
    constructor: () ->
        @_breakpoints = {}
        @_inputVars   = []
        @_watchVars   = []
        @_type        = "stash"
        @_callStack   = []

    _initialize: () ->
        @_context = proc: "os", args: ""
        for v of this
            @[v] = undefined unless v.match(/^_/) or v in @_inputVars

    _clone: () ->
        Vamonos.mixin(new Stash(), this, Vamonos.clone)

    _subroutine: ({name, argnames, locals, procedure, visualizer}) ->
        name     ?= "main"
        argnames ?= []
        locals   ?= []
        
        throw "Stash: need routine for _subroutine method" unless procedure?
        throw "Stash: need visualizer for _subroutine method" unless visualizer?

        @[name] = (args...) =>
            # save local vars and args
            save = {}
            save[k] = @[k] for k in locals.concat(argnames)

            # bind arguments (positional only)
            @[k] = v for [n, v] in ([argnames[i], args[i]] for i in [0..args.length-1])

            # push old context and bindings
            @_callStack.push(
                context: @_context
                bindings: (k for k in @ when k[0] isnt "_")
            )

            # set new context
            @_context = 
                proc: name
                args: (Vamonos.rawToTxt(a) for a in args)

            # call routine
            ret = procedure(visualizer)

            # clean up: pop call stack, restore overwritten locals and args
            {bindings, context} = @_callStack.pop()
            @[key] = val for key, val of save
            delete @[key] for key of @ when not key in bindings
            @_context = context

            return ret


Vamonos.export { DataStructure: { Stash } }
