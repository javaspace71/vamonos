---
layout: main
title: "Vamonos API Reference"
header: Vamonos API Reference
---


Vamonos.Widget.Graph
====================

[Back](index.html)

The Graph widget provides graph input functionality. It uses GraphDisplay for functionality that is not related to input.


### Arguments are shared with inner objects:

 * [Vamonos.Widget.GraphDisplay](widget-graphdisplay.html)


### Constructor Arguments

 * **container** :: *String* | *jQuery Selector* -- **required**

    The id or a jQuery selector of the div in which this widget should draw itself.



 * **varName** :: *String* -- **required**

    the name of variable that this widget represents



 * **arrowLength** :: *Number* -- default value: `6`

    the length of arrows in directed graphs



 * **arrowWidth** :: *Number* -- default value: `6`

    the width of arrows in directed graphs



 * **bezierCurviness** :: *Number* -- default value: `15`

    the curviness of bezier curves in this graph



 * **containerMargin** :: *Number* -- default value: `30`

    how close vertices can get to the container edge



 * **defaultEdgeAttrs** :: *Object* -- optional

    A mapping of attribute names to default values for new edges created in edit mode.



 * **defaultGraph** :: *Graph* -- optional

    the initial graph, as a Vamonos.DataStructure.Graph



 * **draggable** :: *Boolean* -- default value: `true`

    whether vertices can be moved



 * **edgeCssAttributes** :: *Object* -- default value: `{}`

    provides a way to change CSS classes of edges based upon the values of variables or the edges themselves. You provide a mapping of classnames to functions or strings. The function simply needs to take an edge and return a boolean (whether to apply the class). The string is a pairing of variable names in the form `'u->v'` or `'u<->v'` for undirected graphs.

    Example:

>     edgeCssAttributes: {
>         green: function(edge){
>             return (edge.target.pred === edge.source.name)
>                 || (edge.source.pred === edge.target.name)
>         },
>         red: "u->v",
>     }



 * **edgeLabel** :: *String* | *Function* | *Object* -- optional

    a string, containing the name of the edge attribute to displayor a function taking an edge and returning a string to display. one can also specify whether to show certain things in edit or display mode by using an object.

    Example:

>     edgeLabel: { display: 'w', edit: function(e){ return e.w } },
>     edgeLabel: 'w',
>     edgeLabel: function(e){ return e.w + "!" },



 * **editable** :: *Boolean* -- default value: `true`

    whether the graph allows user input



 * **editableEdgeAttrs** :: *Boolean* -- default value: `true`

    whether edge attributes are modifiable in edit mode.



 * **highlightChanges** :: *Boolean* -- default value: `true`

    whether vertices will get the css class 'changed' when they are modified



 * **inputVars** :: *Object* -- default value: `{}`

    a mapping of variable names to vertex ids of the form                `{ var1: 'node1' }` for displaying variables that contain                vertices.



 * **minX** :: *Number* -- default value: `100`

    minimum width of the graph widget



 * **minY** :: *Number* -- default value: `100`

    minimum height of the graph widget



 * **persistentDragging** :: *Boolean* -- default value: `true`

    whether the positions resulting from dragging vertices are persistent across frames in display mode.



 * **resizable** :: *Boolean* -- default value: `true`

    whether the graph widget is resizable



 * **showChanges** :: *String* | *Array* -- default value: `"next"`

    type of frame shifts to highlight changes at, can be multiple types with an array of strings



 * **styleEdges** :: *Array* -- optional

    Provides a way to add styles to path objects. Functions must return an array whose first element is an attribute name, and second element is the value.

    Example:

>     styleEdges: [
>         function(e){
>             if (e.f !== undefined && (e.f > 0)) {
>                 var width = 2 + e.f;
>                 return ["stroke-width", width];
>             }
>         },
>     ],



 * **vertexCssAttributes** :: *Object* -- default value: `{}`

    provides a way to change CSS classes of vertices based on vertex attributes. takes an object of the form `{ attribute: value | [list of values] }`. in the case of a single value,  the vertex will simply get a class with the same name as the attribute. in the case of a list of values, the css class will be of the form 'attribute-value' when its value matches. You can also provide a function that takes a vertex and returns a class to apply to it.

    Example:

>     vertexCssAttributes: {
>         done: true,
>         color: ['white', 'gray', 'black'],
>         magic: function(vtx){ return "class-" + vtx.magicAttr },
>     },



 * **vertexHeight** :: *Number* -- default value: `30`

    the height of vertices in the graph



 * **vertexLabels** :: *Object* -- default value: `{}`

    an object containing a mapping of label positions (inner, nw, sw, ne, se) to labels. Labels can display simple variable names (corresponding to inputVars). This must be provided in the form: `{ label: ['var1', 'var2'] }`. It can be more complicated, as a function that takes a vertex and returns some html. if we give a label an object, we can control what is shown in edit/display mode in the form: `{ label : { edit: function{}, display: function{} } }`

    Example:

>     vertexLabels: {
>         inner : {
>             edit: function(vtx){return vtx.name},
>             display: function(vtx){return vtx.d}
>         },
>         sw    : function(vtx){return vtx.name},
>         ne    : ['u', 'v'],
>         nw    : ['s'],
>     }



 * **vertexWidth** :: *Number* -- default value: `40`

    the width of vertices in the graph


