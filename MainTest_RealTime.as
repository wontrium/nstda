package  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	
	public class MainTest_RealTime extends MovieClip {

		public function MainTest_RealTime() {
			Security.allowDomain("*");
    		Security.allowInsecureDomain("*");
			Security.loadPolicyFile("http://mapnstda.16mb.com/crossdomain.xml");
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//trace("Hello World!");
 
			//in your class or ActionScript 3
			//Security.loadPolicyFile("http://localhost:8080/nstdamap/crossdomain.xml");
			
			var BOUND_LAT_TOP = 14.081491;
			var BOUND_LAT_BOTTOM = 14.075257;
			var BOUND_LNG_LEFT = 100.599641;
			var BOUND_LNG_RIGHT = 100.606238;
			//var BOUND_PER_PIXEL_X = 0.00000940547;
			//var BOUND_PER_PIXEL_Y = 0.00000926368;
			
			
			//var urlRequest:URLRequest = new URLRequest("http://localhost:8080/nstdamap/getPlaces.php?"+ new Date().getTime());
			var urlRequest:URLRequest = new URLRequest("http://mapnstda.16mb.com/getPlaces.php?"+ new Date().getTime());
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandlerAsyncErrorEvent);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerIOErrorEvent);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSecurityErrorEvent);
			//urlLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
			//urlLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, infoIOErrorEvent);
			//urlLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressListener);
			
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.load(urlRequest);
			
			var squareCO:Object = {};
			var squareCO2:Object = {};
			//var bus1Group:Object = {};
			var bus1;
			
			var lastLocationX = 0;
			var lastLocationY = 0;
			
			 
			function urlLoader_complete(evt:Event):void {
				//var greenBG_data:BitmapData = new greenBG(0,0) as BitmapData;
				//var greenBG_bitmap = new Bitmap(greenBG_data);
				
				//addChild(greenBG_bitmap);
				
				var result:String = urlLoader.data;  
				var places:Array = result.split('#');  
				//var number_places = places.length;
				var places_detail:Array = new Array(3);
				  
				// remove empty last element  
				places.pop();
				
				for each(var p:String in places) {  
					//data_txt.appendText(p + "\n");
					//trace(p);
					//trace("Hello World Again!");
					
					
					var RATIO_MAP_X = road.width / 2195;
					var RATIO_MAP_Y = road.height / 2106;
					
					var BOUND_PER_PIXEL_X = 0.006597/road.width;
					var BOUND_PER_PIXEL_Y = 0.006234/road.height;
					
					
					places_detail = p.split('&'); 
					for(var pd = 0; pd < 3; pd++) {
						//trace(places_detail[1]);
						places_detail[0] = places_detail[0].replace(/^\s+|\s+$/g, "");
						places_detail[0] = places_detail[0].replace(" ", "_");
						
						if (places_detail[0] == "7-11") {
							places_detail[0] = "SEVEN";
						}
						
						if (places_detail[0] !== "IMG_PARKING") {
							//trace(places_detail[pd]);

							//var FlagFranceClass:Class = getDefinitionByName("FlagFrance");
							//var o:* = new FlagFranceClass();
							
							var type:Class = getDefinitionByName(places_detail[0]) as Class;
							var instance:DisplayObject = new type();
							
			
							instance.width = instance.width * RATIO_MAP_X;
							instance.height = instance.height * RATIO_MAP_Y;
							
							instance.x = road.localToGlobal(new Point()).x + ((places_detail[2] - BOUND_LNG_LEFT) / BOUND_PER_PIXEL_X) - (instance.width/2);
							instance.y = road.localToGlobal(new Point()).y + ((BOUND_LAT_TOP - places_detail[1]) / BOUND_PER_PIXEL_Y) - (instance.height/2);
							
							addChild(instance);

						}
					}
				}
				
				
				
				for (var row = 1; row <= 8; row++) {
					for (var column = 1; column <= 8; column++) {
						squareCO[row + "_" + column] = new InvisibleCO();
						squareCO[row + "_" + column].width = road.width / 8;
						squareCO[row + "_" + column].height = road.height / 8;
						squareCO[row + "_" + column].x = road.x + ((column-1) * (road.width/8));
						squareCO[row + "_" + column].y = road.y + ((row-1) * (road.height/8));
						
						addChild(squareCO[row + "_" + column]);
						
						
						squareCO2[row + "_" + column] = new InvisibleCO2();
						squareCO2[row + "_" + column].width = road.width / 8;
						squareCO2[row + "_" + column].height = road.height / 8;
						squareCO2[row + "_" + column].x = road.x + ((column-1) * (road.width/8));
						squareCO2[row + "_" + column].y = road.y + ((row-1) * (road.height/8));
						
						addChild(squareCO2[row + "_" + column]);
					}
				}
				
				/*for (var idbus1 = 0; idbus1 <= 6; idbus1++) {
					bus1Group[idbus1] = new Car();

					bus1Group[idbus1].width *= RATIO_MAP_X;
					bus1Group[idbus1].height *= RATIO_MAP_Y;
					
					//bus1Group[idbus1].x = 100;
					//bus1Group[idbus1].y = 100;
					
					//trace(bus1Group[2].x);
					
					//addChild(bus1Group[idbus1]);
				}*/
				
				bus1 = new Car();
				bus1.width *= RATIO_MAP_X;
				bus1.height *= RATIO_MAP_Y;
			}
			
			
			
			function errorHandlerAsyncErrorEvent( e:AsyncErrorEvent ) :void{
			  	trace( 'errorHandlerAsyncErrorEvent ' + e.toString() );
			}
			
			function errorHandlerIOErrorEvent( e:IOErrorEvent ):void{
			  	trace( 'errorHandlerIOErrorEvent ' + e.toString() );
			}
			
			function errorHandlerSecurityErrorEvent( e:SecurityErrorEvent ):void{
			  	trace( 'errorHandlerSecurityErrorEvent ' + e.toString());
			}
			
			function initHandler( e:Event ):void{
			  	trace( 'load init' );
			}
			
			function infoIOErrorEvent( e:IOErrorEvent ):void{
			  	trace( 'infoIOErrorEvent ' + e.toString() );
			}
			
			function progressListener (e:ProgressEvent):void{
			   trace("Downloaded " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");
			}
			
			
			
			
			
			//var urlRequest_car:URLRequest = new URLRequest("http://localhost:8080/nstdamap/getCarLocation.php?"+ new Date().getTime());
			
			//urlLoader_car.load(urlRequest_car);
			
			var countRequest:int = 1;
			var urlRequest_car:URLRequest;
			var urlLoader_car:URLLoader;
			
			function onTimer_request(e:TimerEvent):void {
				urlRequest_car = new URLRequest("http://mapnstda.16mb.com/getRealTimeCarLocation.php?"+ new Date().getTime());
				//urlRequest_car = new URLRequest("http://localhost:8080/nstdamap/getRealTimeCarLocation.php?"+ new Date().getTime());
				urlLoader_car = new URLLoader();
				
				urlLoader_car.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandlerAsyncErrorEvent);
				urlLoader_car.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerIOErrorEvent);
				urlLoader_car.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSecurityErrorEvent);
				urlLoader_car.addEventListener(Event.COMPLETE, urlLoader_complete_car);
				urlLoader_car.dataFormat = URLLoaderDataFormat.TEXT;
				urlLoader_car.load(urlRequest_car);
				
				//trace(">>>>>>>>>>>>>>  " + countRequest + "  <<<<<<<<<<<<<<");
				//countRequest++;
				
			}
			
			var timer_request:Timer = new Timer(5000);
			timer_request.addEventListener(TimerEvent.TIMER, onTimer_request);
			timer_request.start();
			
			
			
			var currentFrameCount:int;
			var totalFrameCount:int = 120;
			var destinationX:Number;
			var destinationY:Number;
			var destinationRotation:Number;
			var initialX:Number;
			var initialY:Number;
			var initialRotation:Array = new Array(6);
			var distanceX:Number;
			var distanceY:Number;
			var distanceRotation:Number = 0;
			var location_detail:Array = [];
			var a:int = 14415;
			
			function urlLoader_complete_car(evt:Event):void {
				
				if (!bus1.stage) {
					stage.addChild(bus1);
				}
				
				var result_car:String = urlLoader_car.data;
				//trace(result_car);
				//var location_car:Array = result_car.split('#');
				//var location_car:Array = [];
				//location_car.push(result_car);
				//var number_location = location_car.length;
				
				var location_detail:Array = [];
				
				//location_car.pop();
				
				//var id = 1;
				
				//var type:Class = getDefinitionByName("Car") as Class;
				//var bus1:DisplayObject = new type();
				
				var BOUND_PER_PIXEL_X = 0.006597/road.width;
				var BOUND_PER_PIXEL_Y = 0.006234/road.height;
				
				var RATIO_MAP_X = road.width / 2195;
				var RATIO_MAP_Y = road.height / 2106;
				
				//bus1:Car = new Car();
				
				location_detail = result_car.split('&');
				//trace("A");
				location_detail[0] = location_detail[0].replace(/^\s+|\s+$/g, "");
				location_detail[1] = location_detail[1].replace(/^\s+|\s+$/g, "");
				//location_detail.push(location_spilt);
				//trace("B");
				
				/*for each(var p:String in location_car) {
					
					var location_spilt = p.split('&');
					trace("A");
					location_spilt[1] = location_spilt[1].replace(/^\s+|\s+$/g, "");
					location_detail.push(location_spilt);
					trace("B");
					//for(var pd = 0; pd < 2; pd++) {
						//trace(places_detail[1]);
						
						
						//trace(location_detail[p]);
	
					//}
					
					
					/*var countdown:Timer = new Timer(1000);
					countdown.addEventListener(TimerEvent.TIMER, timerHandler);
					countdown.start();
					
					function timerHandler(e:TimerEvent):void
					{
						var bus1:Car = new Car();
						addChild(bus1);
						bus1.x = road.localToGlobal(new Point()).x + ((location_detail[1] - BOUND_LNG_LEFT) / BOUND_PER_PIXEL_X) - (bus1.width/2);
						bus1.y = road.localToGlobal(new Point()).y + ((BOUND_LAT_TOP - location_detail[0]) / BOUND_PER_PIXEL_Y) - (bus1.height/2);
					}
				}*/
				
				//bus1Group[idbus1].x = 100;
				//bus1Group[idbus1].y = 100;
				
				//trace(bus1Group[2].x);
				
				//addChild(bus1);
					
				
				//trace(bus1.width + " " + bus1.height);
				//bus1.width = bus1.width * RATIO_MAP_X;
				//bus1.height = bus1.height * RATIO_MAP_Y;
				//trace("C");
				//trace(location_detail);
				//trace(location_detail[5]);
				//addChild(bus1);
				
				//trace(location_detail[1]);
				//trace(bus1.width);
				//trace(bus1.height);
				//trace(bus1.width * RATIO_MAP_X);
				//trace(bus1.height * RATIO_MAP_Y);
				
				//trace("D");
				var justPassSquareX:Array = new Array(7);
				var justPassSquareY:Array = new Array(7);
				var lastRotation:Array = new Array(7);
				
				//trace("E");
				for (var idbus1 = 1; idbus1 <= 6; idbus1++) {
					lastRotation[idbus1] = 0;
					initialRotation[idbus1] = 0;
					justPassSquareX[idbus1] = 0;
					justPassSquareY[idbus1] = 0;
				}
				
				onTimer();

				//trace("F");
				//function onTimer(e:TimerEvent):void {
				function onTimer():void {
					if (location_detail[0] != 0 && location_detail[1] != 0) {
						//trace("bus1 Width = " + bus1.width);

						destinationX = road.localToGlobal(new Point()).x + ((location_detail[1] - BOUND_LNG_LEFT) / BOUND_PER_PIXEL_X) - (bus1.width/2);
						destinationY = road.localToGlobal(new Point()).y + ((BOUND_LAT_TOP - location_detail[0]) / BOUND_PER_PIXEL_Y) - (bus1.height/2);
						
						currentFrameCount = 0;

						//initialX = bus1.x;
						//initialY = bus1.y;
						
						initialX = lastLocationX;
						initialY = lastLocationY;

						distanceX = destinationX - initialX;
						distanceY = destinationY - initialY;
						
						//trace("G");
						bus1.addEventListener(Event.ENTER_FRAME, animateMoveTo);

						var detectSquareCoX:int;
						var detectSquareCoY:int;
						
						var centerOfCarX:int = initialX + (bus1.width/2);
						var centerOfCarY:int = initialY + (bus1.height/2);
						
						if (centerOfCarX < 0) {
							centerOfCarX = 0;
						}
						
						if (centerOfCarY < 0) {
							centerOfCarY = 0;
						}
						
						trace(centerOfCarX + " " + centerOfCarY);
						
						detectSquareCoX = ((int)((centerOfCarX - road.x) / (road.width/8)))+1;
						detectSquareCoY = ((int)((centerOfCarY - road.y) / (road.height/8)))+1;
						
						trace(detectSquareCoX + " " + detectSquareCoY);
						//detectSquareCoX = ((int)((centerOfCarX - road.x) / (road.width/8)));
						//detectSquareCoY = ((int)((centerOfCarY - road.y) / (road.height/8)));
						//trace("H");
						if (justPassSquareX[location_detail[5]] == 0 && justPassSquareY[location_detail[5]] == 0) {
							justPassSquareX[location_detail[5]] = detectSquareCoX;
							justPassSquareY[location_detail[5]] = detectSquareCoY;
							//trace("justPassSquareX = " + justPassSquareX);
							//trace("justPassSquareY = " + justPassSquareY);
							
						} else {
							if (justPassSquareX[location_detail[5]] != detectSquareCoX) {
								if (justPassSquareX[location_detail[5]] < detectSquareCoX) {
									// To Right
									//trace("Now going to Right!");
									initialRotation[location_detail[5]] = bus1.rotation - lastRotation[location_detail[5]];
									initialRotation[location_detail[5]] += 0;
									lastRotation[location_detail[5]] = 0;
									
									//bus1.x = destinationX;
									//bus1.y = destinationY;
									
								} else {
									// To Left
									if (detectSquareCoX != 1) {
										initialRotation[location_detail[5]] = bus1.rotation - lastRotation[location_detail[5]];
										initialRotation[location_detail[5]] += 180;
										lastRotation[location_detail[5]] = 180;
										
										//destinationX += bus1.width;
										//destinationY += bus1.height;
									}
									//trace("Now going to Left!");
									
								}
								
							} else if (justPassSquareY[location_detail[5]] != detectSquareCoY) {
								if (justPassSquareY[location_detail[5]] < detectSquareCoY) {
									// To Down
									//trace("Now going to Down!");
									initialRotation[location_detail[5]] = bus1.rotation - lastRotation[location_detail[5]];
									initialRotation[location_detail[5]] += 90;
									lastRotation[location_detail[5]] = 90;
									
									//destinationX += (bus1.width/2) + (-bus1.height/2);
									//destinationY += (-bus1.width/2) + (bus1.height/2);
									
								} else {
									// To Up
									//trace("Now going to Up!");
									initialRotation[location_detail[5]] = bus1.rotation - lastRotation[location_detail[5]];
									initialRotation[location_detail[5]] += -90;
									lastRotation[location_detail[5]] = -90;
									
								}
								
							}
							justPassSquareX[location_detail[5]] = detectSquareCoX;
							justPassSquareY[location_detail[5]] = detectSquareCoY;
							
						}
						//trace("I");
						//trace(initialRotation);
						//trace(bus1.rotation);
						//trace(lastRotation);
						
						var tempPositionCO_X:int;
						var tempPositionCO_Y:int;
						var tempPositionCO2_X:int;
						var tempPositionCO2_Y:int;
						
						trace(location_detail[3] + " " + location_detail[4]);
						
						if (location_detail[3] >= 0) {
							
							if (location_detail[3] <= 70) {
								//trace(detectSquareCoX + " " + detectSquareCoY);
							
								tempPositionCO_X = squareCO[detectSquareCoY + "_" + detectSquareCoX].x;
								tempPositionCO_Y = squareCO[detectSquareCoY + "_" + detectSquareCoX].y;
								
								squareCO[detectSquareCoY + "_" + detectSquareCoX].parent.removeChild(squareCO[detectSquareCoY + "_" + detectSquareCoX]);
								squareCO[detectSquareCoY + "_" + detectSquareCoX] = new GreenCO();
								squareCO[detectSquareCoY + "_" + detectSquareCoX].width = road.width / 8;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].height = road.height / 8;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].x = tempPositionCO_X;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].y = tempPositionCO_Y;
								
								addChild(squareCO[detectSquareCoY + "_" + detectSquareCoX]);
								
							} else if (location_detail[3] <= 150) {
								//trace(detectSquareCoX + " " + detectSquareCoY);
							
								tempPositionCO_X = squareCO[detectSquareCoY + "_" + detectSquareCoX].x;
								tempPositionCO_Y = squareCO[detectSquareCoY + "_" + detectSquareCoX].y;
								
								squareCO[detectSquareCoY + "_" + detectSquareCoX].parent.removeChild(squareCO[detectSquareCoY + "_" + detectSquareCoX]);
								squareCO[detectSquareCoY + "_" + detectSquareCoX] = new YellowCO();
								squareCO[detectSquareCoY + "_" + detectSquareCoX].width = road.width / 8;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].height = road.height / 8;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].x = tempPositionCO_X;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].y = tempPositionCO_Y;
								
								addChild(squareCO[detectSquareCoY + "_" + detectSquareCoX]);
								
							} else {
								tempPositionCO_X = squareCO[detectSquareCoY + "_" + detectSquareCoX].x;
								tempPositionCO_Y = squareCO[detectSquareCoY + "_" + detectSquareCoX].y;
								
								squareCO[detectSquareCoY + "_" + detectSquareCoX].parent.removeChild(squareCO[detectSquareCoY + "_" + detectSquareCoX]);
								squareCO[detectSquareCoY + "_" + detectSquareCoX] = new RedCO();
								squareCO[detectSquareCoY + "_" + detectSquareCoX].width = road.width / 8;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].height = road.height / 8;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].x = tempPositionCO_X;
								squareCO[detectSquareCoY + "_" + detectSquareCoX].y = tempPositionCO_Y;
								
								addChild(squareCO[detectSquareCoY + "_" + detectSquareCoX]);
								
							}
						}
						
						//trace("J");
						
						if (location_detail[4] >= 0) {
							if (location_detail[4] <= 450) {
								//trace("HELLO! " + detectSquareCoX + " " + detectSquareCoY);
							
								tempPositionCO2_X = squareCO2[detectSquareCoY + "_" + detectSquareCoX].x;
								tempPositionCO2_Y = squareCO2[detectSquareCoY + "_" + detectSquareCoX].y;
								
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].parent.removeChild(squareCO2[detectSquareCoY + "_" + detectSquareCoX]);
								squareCO2[detectSquareCoY + "_" + detectSquareCoX] = new GreenCO2();
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].width = road.width / 8;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].height = road.height / 8;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].x = tempPositionCO2_X;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].y = tempPositionCO2_Y;
								
								addChild(squareCO2[detectSquareCoY + "_" + detectSquareCoX]);
								
							} else if (location_detail[4] <= 5000) {
								//trace("HELLO! " + detectSquareCoX + " " + detectSquareCoY);
							
								tempPositionCO2_X = squareCO2[detectSquareCoY + "_" + detectSquareCoX].x;
								tempPositionCO2_Y = squareCO2[detectSquareCoY + "_" + detectSquareCoX].y;
								
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].parent.removeChild(squareCO2[detectSquareCoY + "_" + detectSquareCoX]);
								squareCO2[detectSquareCoY + "_" + detectSquareCoX] = new YellowCO2();
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].width = road.width / 8;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].height = road.height / 8;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].x = tempPositionCO2_X;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].y = tempPositionCO2_Y;
								
								addChild(squareCO2[detectSquareCoY + "_" + detectSquareCoX]);
								
							} else {
								//trace("HELLO! " + detectSquareCoX + " " + detectSquareCoY);
							
								tempPositionCO2_X = squareCO2[detectSquareCoY + "_" + detectSquareCoX].x;
								tempPositionCO2_Y = squareCO2[detectSquareCoY + "_" + detectSquareCoX].y;
								
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].parent.removeChild(squareCO2[detectSquareCoY + "_" + detectSquareCoX]);
								squareCO2[detectSquareCoY + "_" + detectSquareCoX] = new RedCO2();
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].width = road.width / 8;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].height = road.height / 8;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].x = tempPositionCO2_X;
								squareCO2[detectSquareCoY + "_" + detectSquareCoX].y = tempPositionCO2_Y;
								
								addChild(squareCO2[detectSquareCoY + "_" + detectSquareCoX]);
							}
						}
						//a++;
						trace("/////////////////////");
					}
				}
				
				//trace("K");
				
				/*var timer:Timer = new Timer(5000);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();*/
				
			}
			
			//function moveCar() {
				
			//}
	
			function rotateAroundCenter (ob:*, angleDegrees:Number, ptRotationPoint:Point) {
				  var m:Matrix=ob.transform.matrix;
				  m.tx -= ptRotationPoint.x;
				  m.ty -= ptRotationPoint.y;
				  m.rotate (angleDegrees*(Math.PI/180));
				  m.tx += ptRotationPoint.x;
				  m.ty += m.ty;
				  m.ty += ptRotationPoint.y;
				  ob.transform.matrix=m;
			 }
			 
			 function animateMoveTo (evt:Event):void
			{
				// each frame, increment the frame count
				// to move the animation forward
				currentFrameCount++;
				// if the frame count has not yet reached the
				// final frame of the animation, myObject
				// needs to be moved to the next location
				if (currentFrameCount < totalFrameCount){
					// find the progress by comparing current frame
					// with the total frames of the animation
					var progress:Number = currentFrameCount/totalFrameCount;
					// set myObject's position to include the new
					// distance from the original location as
					// defined by the distance to the destination
					// times the progress of the animation
					bus1.x = initialX + distanceX*progress;
					bus1.y = initialY + distanceY*progress;
					bus1.rotation = initialRotation[location_detail[5]];
					//rotateAroundCenter(bus1, initialRotation[location_detail[5]], new Point(bus1.x, bus1.y));
					//bus1.rotation = initialRotation + distanceRotation*progress;
				} else {
					// when the animation is complete, set the
					// position of myObject to the destination
					bus1.x = destinationX;
					bus1.y = destinationY;
					bus1.rotation = initialRotation[location_detail[5]];
					// remove the enterFrame event handler so the 
					// animation ceases to run
					lastLocationX = bus1.x;
					lastLocationY = bus1.y;
					bus1.removeEventListener(Event.ENTER_FRAME, animateMoveTo);
					//bus1.parent.removeChild(bus1);
				}
				
			}
		}
	}
}
