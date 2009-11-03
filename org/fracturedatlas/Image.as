package org.fracturedatlas {
	import flash.display.*
	import flash.events.*
	import flash.net.*
  import flash.system.LoaderContext

  import org.osflash.thunderbolt.Logger	
  import de.popforge.events.*
  import caurina.transitions.Tweener
  import caurina.transitions.properties.FilterShortcuts

	import org.fracturedatlas.*

	public class Image extends MovieClip {

    public var _id:Number
		public var _json:Object
    public var _url:String
    public var _loaded:Boolean = false
    public var _num_images:Number
    public var _loader:Loader
    
		public function Image(id, json) {
			name = "image_" + id
			_id = id
			_json = json
      addEventListener(Event.ADDED_TO_STAGE, init)
		}

    function init(e:Event) {
      var context = new LoaderContext()
      context.checkPolicyFile = true
		  
			_loader = new Loader()
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded)
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError)
			var request:URLRequest = new URLRequest(image_url())
			_loader.load(request,context)
    }

		public function onIoError(e:IOErrorEvent):void {
		   Logger.debug(e.toString())
		}

		protected function onImageLoaded(e:Event):void {
			addChild(_loader)
			_loaded = true
			scale()
			position()
			isFirst() ? appearAndFadeIn() : hide()
		}
		
		public function image_url() {
			var s = FV.get.image_size
			return _json[s+"_url"]
		}

		// function chooseImageSizeByStage() {
		// 	chooseImageSizeByStage
		// }
    		
    function scale() {
			var stage_aspect = stage.stageWidth / stage.stageHeight
			var image_aspect = width / height
			
			if (image_aspect > stage_aspect) {
			  var x_scale = width / stage.stageWidth
			  if (x_scale > 1) scaleX = scaleY = 1/x_scale
			} else {
			  var y_scale = height / stage.stageHeight
			  if (y_scale > 1) scaleX = scaleY = 1/y_scale
			}
    }
    
    function position() {
      
      switch (FV.get.align_horizontal) {
      case "left":
        x = 0
        break
      case "right":
        x = stage.stageWidth - width
      break
      default: // center
        x = stage.stageWidth/2 - width/2
        break
      }
      
      switch (FV.get.align_vertical) {
      case "top":
        y = 0
        break
      case "bottom":
        y = stage.stageHeight - height
      break
      default: // middle
        y = stage.stageHeight/2 - height/2
        break
      }            
    }
        
    function appearAndFadeIn() {
			Logger.debug("appearAndFadeIn: " + _json.medium_url)
			var s= Slideshow(this.root)
			Spinner(s.getChildByName("spinner")).fadeOut()
      
      visible = true
      alpha = 0
      Tweener.addTween(this, {alpha:1, time:FV.get.appear_time, transition:"easeInCubic"})
      Tweener.addTween(this, {rotation:0, time:FV.get.appear_time + FV.get.display_time, onComplete:tryShowingNext})
    }
    
    function tryShowingNext() {
      var next_image = next()
      if (next_image._loaded) {
        fadeOut()
        next_image.appearAndFadeIn()
      } else {
        // This is a fudged way of checking every five half second for the next image to loaded
        Tweener.addTween(this, {alpha:1, time:1, onComplete:tryShowingNext})
      }
    }

    function fadeOut() {
      Tweener.addTween(this, {alpha:0, time:FV.get.fade_out_time, transition:"easeOutCubic", onComplete:hide})
    }
    
    function hide() {
			Logger.debug("hide: " + _json.medium_url)
      visible = false
    }
		
		function previous() {
		  var id = (this.isFirst()) ? _num_images-1 : _id-1
		  return MovieClip(parent.getChildByName("image_"+id))
		}

		function next() {
		  var id = (this.isLast()) ? 0 : _id+1
		  return MovieClip(parent.getChildByName("image_"+id))
		}
		
		function isFirst() {
		  return _id == 0
		}
		
		function isLast() {
		  return _id == MovieClip(parent)._images.length-1
		}
	}
}