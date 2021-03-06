package org.fracturedatlas {

  import flash.display.*
  import flash.events.*
  import org.osflash.thunderbolt.Logger
  
  public class FV {
    
    public static var get:Object = [];

    public function FV() {
      trace ("FV is a static class and should not be instantiated.")
    }

    public static function process(document_root) {
      var flash_vars = LoaderInfo(MovieClip(document_root).root.loaderInfo).parameters
			
			// Set string defaults
			var strings:Object = {
        // base_url:"http://localhost:3000",
				feed_url:"http://localhost:9393/photos/favorites/all.json",
				image_size: "medium", // small, medium, large, original
      	align_horizontal: "center", // left, center, right
      	align_vertical: "middle" // top, middle, bottom
			}

			// Set boolean defaults
      var booleans:Object = {
			}

			// Set number defaults
      var numbers:Object = {
				appear_time: 3,
				display_time: 2,
				fade_out_time: 3,
				throbber_color: 0xFFFFFF
      }

      var temp:Object = [];
      
			// Load any received FlashVars
      for (var k in flash_vars) {
        temp[k] = flash_vars[k];
      }

      // Load String, Boolean, Number defaults and
      // coerce non-strings into their appropriate datatype
			for (k in strings) {
  			if (temp[k] == undefined) temp[k] = strings[k]
			}

			for (k in booleans) {
  			if (temp[k] == undefined) temp[k] = booleans[k]
        temp[k] = (temp[k] == "true" || temp[k] == "1"|| temp[k] == 1) ? true : false
			}
			
			for (k in numbers) {
  			if (temp[k] == undefined) temp[k] = numbers[k]
        temp[k] = Number(temp[k])
			}
			
			// Transfer massaged values over to 'get' container
			for (k in temp) {
			  FV.get[k] = temp[k]
        // Logger.info("FlashVar: " + k + " = " + FV.get[k])
      }

    }
        
  }
}