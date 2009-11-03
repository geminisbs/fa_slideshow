package {
	import flash.display.*
	import flash.events.*
	import flash.net.*

  import de.popforge.events.*
	import caurina.transitions.Tweener
	import org.osflash.thunderbolt.Logger
	import com.serialization.json.JSON
	
  import org.fracturedatlas.*

	public class Slideshow extends MovieClip {
		
		public var _images_json:Object
		public var _images:Array = new Array()

		public function Slideshow() {
      FV.process(this)
      configureStage()
      showSpinner()
      loadFeed()
		}

		private function configureStage() {
      stage.align = StageAlign.TOP_LEFT
      stage.scaleMode = StageScaleMode.NO_SCALE
		}
		
	  private function showSpinner() {
      var spinner = new Spinner()
      addChild(spinner)
	  }
	
		function loadFeed() {
			var loader:URLLoader = new URLLoader()
			loader.addEventListener(Event.COMPLETE, loadImages)
			loader.load(new URLRequest(FV.get.feed_url))
		}
				
    function loadImages(event:Event):void {
			_images_json = JSON.deserialize(event.target.data as String)
			var i = 0
			for each (var image_json in _images_json) {
				var image:Image = new Image(i, image_json)
				this.addChild(image)
				_images.push(image)
				i++
			}
    }
		
	}
}