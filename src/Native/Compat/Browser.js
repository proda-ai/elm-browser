/*

Scheduler  =>  _elm_lang$core$Native_Scheduler.
Scheduler  =>  _elm_lang$core$Native_Scheduler.
import Elm.Kernel.Scheduler as Scheduler
Scheduler  =>  _elm_lang$core$Native_Scheduler.
Scheduler  =>  _elm_lang$core$Native_Scheduler.
import Elm.Kernel.Scheduler as Scheduler
Browser  =>  _elm_lang$core$Compat_Browser$
Browser  =>  _elm_lang$core$Compat_Browser$
import Compat.Browser as Browser

*/

var _proda_ai$elm_browser$Native_Compat_Browser = function() { 

   var _cancelAnimationFrame =
       typeof cancelAnimationFrame !== 'undefined'
           ? cancelAnimationFrame
           : function(id) { clearTimeout(id); };
   
   var _requestAnimationFrame =
       typeof requestAnimationFrame !== 'undefined'
           ? requestAnimationFrame
           : function(callback) { return setTimeout(callback, 1000 / 60); };
   
   
   var fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
   var doc = typeof document !== 'undefined' ? document : fakeNode;
   var window = typeof window !== 'undefined' ? window : fakeNode;
   
   function withNode(id, doStuff)
   {
       return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
       {
           _requestAnimationFrame(function() {
               var node = document.getElementById(id);
               callback(node
                   ? _elm_lang$core$Native_Scheduler.succeed(doStuff(node))
                   : _elm_lang$core$Native_Scheduler.fail(__Dom_NotFound(id))
               );
           });
       });
   }
   
   
   function withWindow(doStuff)
   {
       return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
       {
           _requestAnimationFrame(function() {
               callback(_elm_lang$core$Native_Scheduler.succeed(doStuff()));
           });
       });
   }
   
   
   // FOCUS and BLUR
   
   
   var call = F2(function(functionName, id)
   {
       return withNode(id, function(node) {
           node[functionName]();
           return __Utils_Tuple0;
       });
   });
   
   
   
   // WINDOW VIEWPORT
   
   
   function getViewport()
   {
       return {
           scene: getScene(),
           viewport: {
               x: window.pageXOffset,
               y: window.pageYOffset,
               width: doc.documentElement.clientWidth,
               height: doc.documentElement.clientHeight
           }
       };
   }
   
   function getScene()
   {
       var body = doc.body;
       var elem = doc.documentElement;
       return {
           width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
           height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
       };
   }
   
   var setViewport = F2(function(x, y)
   {
       return withWindow(function()
       {
           window.scroll(x, y);
           return __Utils_Tuple0;
       });
   });
   
   
   
   // ELEMENT VIEWPORT
   
   
   function getViewportOf(id)
   {
       return withNode(id, function(node)
       {
           return {
               scene: {
                   width: node.scrollWidth,
                   height: node.scrollHeight
               },
               viewport: {
                   x: node.scrollLeft,
                   y: node.scrollTop,
                   width: node.clientWidth,
                   height: node.clientHeight
               }
           };
       });
   }
   
   
   var setViewportOf = F3(function(id, x, y)
   {
       return withNode(id, function(node)
       {
           node.scrollLeft = x;
           node.scrollTop = y;
           return __Utils_Tuple0;
       });
   });
   
   
   
   // ELEMENT
   
   
   function getElement(id)
   {
       return withNode(id, function(node)
       {
           var rect = node.getBoundingClientRect();
           var x = window.pageXOffset;
           var y = window.pageYOffset;
           return {
               scene: getScene(),
               viewport: {
                   x: x,
                   y: y,
                   width: doc.documentElement.clientWidth,
                   height: doc.documentElement.clientHeight
               },
               element: {
                   x: x + rect.left,
                   y: y + rect.top,
                   width: rect.width,
                   height: rect.height
               }
           };
       });
   }

    return {
        setViewport: setViewport,
        getScene: getScene,
        window: window,
        getViewportOf: getViewportOf,
        getViewport: getViewport,
        fakeNode: fakeNode,
        getElement: getElement,
        doc: doc,
        call: call,
        withNode: withNode,
        withWindow: withWindow,
        setViewportOf: setViewportOf
   }
}();
