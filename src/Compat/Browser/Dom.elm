module Compat.Browser.Dom exposing
    ( focus, blur, Error
    , getViewport, Viewport, getViewportOf
    , setViewport, setViewportOf
    , getElement, Element
    )

{-| Dom


# Focus

@docs focus, blur, Error


# Get Viewport

@docs getViewport, Viewport, getViewportOf


# Set Viewport

@docs setViewport, setViewportOf


# Position

@docs getElement, Element

-}

import Dom
import Native.Compat.Browser
import Task exposing (Task)


{-| type alias Error
-}
type alias Error =
    Dom.Error


{-| focus
-}
focus : String -> Task Error ()
focus =
    Dom.focus


{-| blur
-}
blur : String -> Task Error ()
blur =
    Dom.focus



-- VIEWPORT


{-| Get information on the current viewport of the browser.
![getViewport](https://elm.github.io/browser/v1/getViewport.svg)
If you want to move the viewport around (i.e. change the scroll position) you
can use [`setViewport`](#setViewport) which change the `x` and `y` of the
viewport.
-}
getViewport : Task x Viewport
getViewport =
    Native.Compat.Browser.withWindow Native.Compat.Browser.getViewport


{-| All the information about the current viewport.
![getViewport](https://elm.github.io/browser/v1/getViewport.svg)
-}
type alias Viewport =
    { scene :
        { width : Float
        , height : Float
        }
    , viewport :
        { x : Float
        , y : Float
        , width : Float
        , height : Float
        }
    }


{-| Just like `getViewport`, but for any scrollable DOM node. Say we have an
application with a chat box in the bottow right corner like this:
![chat](https://elm.github.io/browser/v1/chat.svg)
There are probably a whole bunch of messages that are not being shown. You
could scroll up to see them all. Well, we can think of that chat box is a
viewport into a scene!
![getViewportOf](https://elm.github.io/browser/v1/getViewportOf.svg)
This can be useful with [`setViewportOf`](#setViewportOf) to make sure new
messages always appear on the bottom.
The viewport size _does not_ include the border or margins.
**Note:** This data is collected from specific fields in JavaScript, so it
may be helpful to know that:

  - `scene.width` = [`scrollWidth`][sw]
  - `scene.height` = [`scrollHeight`][sh]
  - `viewport.x` = [`scrollLeft`][sl]
  - `viewport.y` = [`scrollTop`][st]
  - `viewport.width` = [`clientWidth`][cw]
  - `viewport.height` = [`clientHeight`][ch]
    Neither [`offsetWidth`][ow] nor [`offsetHeight`][oh] are available. The theory
    is that (1) the information can always be obtained by using `getElement` on a
    node without margins, (2) no cases came to mind where you actually care in the
    first place, and (3) it is available through ports if it is really needed.
    If you have a case that really needs it though, please share your specific
    scenario in an issue! Nicely presented case studies are the raw ingredients for
    API improvements!

[sw]: https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollWidth
[sh]: https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollHeight
[st]: https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollTop
[sl]: https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollLeft
[cw]: https://developer.mozilla.org/en-US/docs/Web/API/Element/clientWidth
[ch]: https://developer.mozilla.org/en-US/docs/Web/API/Element/clientHeight
[ow]: https://developer.mozilla.org/en-US/docs/Web/API/Element/offsetWidth
[oh]: https://developer.mozilla.org/en-US/docs/Web/API/Element/offsetHeight

-}
getViewportOf : String -> Task Error Viewport
getViewportOf =
    Native.Compat.Browser.getViewportOf



-- SET VIEWPORT


{-| Change the `x` and `y` offset of the browser viewport immediately. For
example, you could make a command to jump to the top of the page:
import Browser.Dom as Dom
import Task
type Msg = NoOp
resetViewport : Cmd Msg
resetViewport =
Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
This sets the viewport offset to zero.
This could be useful with `Browser.application` where you may want to reset
the viewport when the URL changes. Maybe you go to a &ldquo;new page&rdquo;
and want people to start at the top!
-}
setViewport : Float -> Float -> Task x ()
setViewport =
    Native.Compat.Browser.setViewport


{-| Change the `x` and `y` offset of a DOM node&rsquo;s viewport by ID. This
is common in text messaging and chat rooms, where once the messages fill the
screen, you want to always be at the very bottom of the message chain. This
way the latest message is always on screen! You could do this:
import Browser.Dom as Dom
import Task
type Msg = NoOp
jumpToBottom : String -> Cmd Msg
jumpToBottom id =
Dom.getViewportOf id
|> Task.andThen (\\info -> Dom.setViewportOf id 0 info.scene.height)
|> Task.perform (\_ -> NoOp)
So you could call `jumpToBottom "chat-box"` whenever you add a new message.
**Note 1:** What happens if the viewport is placed out of bounds? Where there
is no `scene` to show? To avoid this question, the `x` and `y` offsets are
clamped such that the viewport is always fully within the `scene`. So when
`jumpToBottom` sets the `y` offset of the viewport to the `height` of the
`scene` (i.e. too far!) it relies on this clamping behavior to put the viewport
back in bounds.
**Note 2:** The example ignores when the element ID is not found, but it would
be great to log that information. It means there may be a bug or a dead link
somewhere!
-}
setViewportOf : String -> Float -> Float -> Task Error ()
setViewportOf =
    Native.Compat.Browser.setViewportOf



{--SLIDE VIEWPORT
{-| Change the `x` and `y` offset of the viewport with an animation. In JS,
this corresponds to setting [`scroll-behavior`][sb] to `smooth`.
This can definitely be overused, so try to use it specifically when you want
the user to be spatially situated in a scene. For example, a &ldquo;back to
top&rdquo; button might use it:
    import Browser.Dom as Dom
    import Task
    type Msg = NoOp
    backToTop : Cmd Msg
    backToTop =
      Task.perform (\_ -> NoOp) (Dom.slideViewport 0 0)
Be careful when paring this with `Browser.application`. When the URL changes
and a whole new scene is going to be rendered, using `setViewport` is probably
best. If you are moving within a scene, you may benefit from a mix of
`setViewport` and `slideViewport`. Sliding to the top is nice, but sliding
around everywhere is probably annoying.
[sb]: https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior
-}
slideViewport : Float -> Float -> Task x ()
slideViewport =
  Debug.todo "slideViewport"
slideViewportOf : String -> Float -> Float -> Task Error ()
slideViewportOf =
  Debug.todo "slideViewportOf"
--}
-- ELEMENT


{-| Get position information about specific elements. Say we put
`id "jesting-aside"` on the seventh paragraph of the text. When we call
`getElement "jesting-aside"` we would get the following information:
![getElement](https://elm.github.io/browser/v1/getElement.svg)
This can be useful for:

  - **Scrolling** &mdash; Pair this information with `setViewport` to scroll
    specific elements into view. This gives you a lot of control over where exactly
    the element would be after the viewport moved.
  - **Drag and Drop** &mdash; As of this writing, `touchmove` events do not tell
    you which element you are currently above. To figure out if you have dragged
    something over the target, you could see if the `pageX` and `pageY` of the
    touch are inside the `x`, `y`, `width`, and `height` of the target element.
    **Note:** This corresponds to JavaScript&rsquo;s [`getBoundingClientRect`][gbcr],
    so **the element&rsquo;s margins are included in its `width` and `height`**.
    With scrolling, maybe you want to include the margins. With drag-and-drop, you
    probably do not, so some folks set the margins to zero and put the target
    element in a `<div>` that adds the spacing. Just something to be aware of!

[gbcr]: https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect

-}
getElement : String -> Task Error Element
getElement =
    Native.Compat.Browser.getElement


{-| A bunch of information about the position and size of an element relative
to the overall scene.
![getElement](https://elm.github.io/browser/v1/getElement.svg)
-}
type alias Element =
    { scene :
        { width : Float
        , height : Float
        }
    , viewport :
        { x : Float
        , y : Float
        , width : Float
        , height : Float
        }
    , element :
        { x : Float
        , y : Float
        , width : Float
        , height : Float
        }
    }
