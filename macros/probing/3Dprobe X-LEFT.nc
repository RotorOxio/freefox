;****************************************************
;*	Created by: 		@pacochorobo on 11/6/2024	*
;*	Last modified by: 	@pacochorobo on 02/9/2024	*
;*	Units: G21 milimeters							*
;*  IMPORTANT: USE ONLY NORMALLY OPEN PROBES        *
;****************************************************	

;Simple macro to probe X LEFT size of a part using a 3D probe. You can use a known diam end mill also.
;This 3D probe has a stylus end ball of 1mm 
;My unit has a yaw displacement is 0.02mm over the lenght of the tip. Please calculate yours for maximum accuracy
;X offset after probing is end ball radius - yaw displacement
;If you plan on using an end mill or calibrated rod, please adjust the offset accordingly

#<X_OFFSET> = -0.98
#<MAX_PROBE_DISTANCE> = 25 ;Maximum distance for probing.
#<RAPID_PROBING> = 50 ;Max speed for probing


M70 ;Save modal state
G21 G91 ;Set units to mm and activate relative mode
M0 (MSG, Please make sure the probe is connected and working.)  ;Safety message

G38.2 X[#<MAX_PROBE_DISTANCE>] F[#<RAPID_PROBING>] ;Probing rapid. IMPORTANT!! This is only for Normally OPEN devices!!!!
G0 X-1 ;Retract and start kissing routine ;)
G38.2 X2 F40	
G4 P.25
G38.4 X-2 F20
G4 P.25
G38.2 X2 F10
G4 P.25
G38.4 X-2 F5
G4 P.25

G10 L20 P0 #<X_OFFSET>
G90 ;Back to absolute mode
M72 ;Restore modal state and end of macro