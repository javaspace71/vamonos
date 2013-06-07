#_require ../common.coffee


class ControlButtons

    PLAY  = "&#x25b6;"
    PAUSE = "&#x25ae;&#x25ae;"
    STOP  = "stop"
    RUN   = "run"
    NEXT  = "&#x25ae;&#x25B6;"
    PREV  = "&#x25c0;&#x25ae;"

    constructor: ({container, noRunStopButton, @autoPlay}) ->
        @$container = Common.jqueryify(container)

        @$runStopButton   = $("<button>", {class: "controls-button", html: RUN})
        @$prevButton      = $("<button>", {class: "controls-button", html: PREV})
        @$nextButton      = $("<button>", {class: "controls-button", html: NEXT})
        @$playPauseButton = $("<button>", {class: "controls-button", html: PLAY})

        @playInterval = null
        @atLastFrame  = no

        @$container.append(@$runStopButton) unless noRunStopButton
        @$container.append(@$prevButton, @$nextButton, @$playPauseButton)

        @$nextButton.on("click", => @visualizer.trigger("nextFrame"))
        @$prevButton.on("click", => @visualizer.trigger("prevFrame"))
        @$runStopButton.on("click", =>
            if @mode is "edit"
                @visualizer.trigger("runAlgorithm")
            else if @mode is "display"
                @visualizer.trigger("editMode")
        )
        @$playPauseButton.on("click", =>
            if @playInterval? then @stopPlaying() else @startPlaying()
        )

    startPlaying: ->
        return if @playInterval? or @atLastFrame
        @$playPauseButton.html(PAUSE)
        @playInterval = setInterval( (=> @visualizer.trigger("nextFrame")), 1000)

    stopPlaying: ->
        return unless @playInterval?
        clearTimeout(@playInterval)
        @playInterval = null
        @$playPauseButton.html(PLAY)
                    
    event: (event, options...) -> switch event
        when "setup"
            [stash, @visualizer] = options
        
        when "editStart"
            @$runStopButton.html(RUN)
            @$prevButton.attr("disabled", "true");
            @$nextButton.attr("disabled", "true");
            @$playPauseButton.attr("disabled", "true");
            @$container.addClass("controls-disabled")
            @mode = "edit"

        when "displayStart"
            @$runStopButton.html(STOP)
            @$prevButton.removeAttr("disabled");
            @$nextButton.removeAttr("disabled");
            @$playPauseButton.removeAttr("disabled");
            @$container.removeClass("controls-disabled")
            @mode = "display"
            @startPlaying() if @autoPlay

        when "displayStop"
            @stopPlaying()

        when "render"
            [frame, type] = options

            @atLastFrame = (frame._frameNumber is frame._numFrames)

            if @atLastFrame
                @$nextButton.attr("disabled", "true")
                @$playPauseButton.attr("disabled", "true")
                @stopPlaying()
            else
                @$nextButton.removeAttr("disabled")
                @$playPauseButton.removeAttr("disabled")

            if frame._frameNumber is 1
                @$prevButton.attr("disabled", "true")
            else
                @$prevButton.removeAttr("disabled")
        

Common.VamonosExport { Widget: { ControlButtons } }