Scriptname ObjectDistractionScript extends Quest Conditional

ObjectReference ObjectDetection
Actor closest
float radius = 200.0
int distanceCheckTicks = 0

Event onInit()
	Debug.Trace("ObjectDistractionScript - onInit")
	StartTimer(1, 0)
	Debug.Trace("ObjectDistractionScript - StartTimer")
endEvent

Event OnTimer(int timerID)

	If (timerID == 0)
		ObjectReference curObject = Game.GetPlayerGrabbedRef()

		If curObject != None
			RegisterForRemoteEvent(curObject, "OnRelease")
			Debug.Trace("ObjectDistractionScript - curObject = " + curObject)
		Else
			StartTimer(1, 0)
		EndIf
	ElseIf (timerID == 1)
		If (ObjectDetection != None)

			Debug.Trace("ObjectDistractionScript timer 1")

			closest = Game.FindClosestActorFromRef(ObjectDetection, radius)

			Debug.Trace("ObjectDistractionScript - radius = " + radius)

			If (radius >= 4000)
				radius = 200.0
			ElseIf (closest == None)
				Debug.Trace("ObjectDistractionScript - finding closest actor")
				radius += 500
				StartTimer(0, 1)
			Else
				StartTimer(0, 2)
				Debug.Trace("ObjectDistractionScript - StartTimer 2 radius = " + radius)
				radius = 200.0
			EndIf
		EndIf
	ElseIf (timerID == 2)
		Debug.Trace("ObjectDistractionScript timer 2")
		Debug.Trace("closest =" + closest + " - GetDistance = " + ObjectDetection.GetDistance(closest))

		; Todo RegisterForDistanceLessThanEvent
		If (ObjectDetection.GetDistance(closest) <= 2000)
			ObjectDetection.CreateDetectionEvent(Game.GetPlayer(), 100)			
			Debug.Trace("ObjectDistractionScript - CreateDetectionEvent")
			ObjectDetection = None
			closest = None
			StartTimer(1, 0)
		ElseIf (distanceCheckTicks >= 20)
			Debug.Trace("ObjectDistractionScript - distanceCheckTicks >= 20")
			distanceCheckTicks = 0
		Else
			Debug.Trace("ObjectDistractionScript - Checking distance")
			distanceCheckTicks += 1
			StartTimer(0, 2)
		EndIf
	EndIf
EndEvent

Event ObjectReference.OnRelease(ObjectReference source)
	Debug.Trace("ObjectDistractionScript - OnRelease = " + source)

	ObjectDetection = source
	Utility.Wait(1)
	StartTimer(0, 1)

	UnRegisterForRemoteEvent(source, "OnRelease")
EndEvent

;/Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
	akObj1.CreateDetectionEvent(Game.GetPlayer(), 100)
	Debug.Trace("ObjectDistractionScript - OnDistanceLessThan - afDistance =  " + afDistance + " units. - " + akObj1 + " - " + akObj2)
endEvent/;
