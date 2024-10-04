;********************************************************
;*	Created by: 		@pacochorobo on 16/07/2024	    *
;*	Last modified by: 	@pacochorobo on 04/10/2024	    *
;*	Units: G21 milimeters							    *
;* This macro is based on the wonderful code by         *
;* https://github.com/neilferreri originally written    *
;* for CNCjs. Adapted to LinuxCNC by @pacochorobo       *
;********************************************************	

;This macro is used to find a hole or square/rectangle center

; Set user-defined variables
#<PROBE_DISTANCE> = 70      ;Maximum expected diameter or side lenght
#<PROBE_FEEDRATE_A> = 75    ;Rapid probing
#<PROBE_FEEDRATE_B> = 25    ;Slow probing to increase precision
#<PROBE_MAJOR_RETRACT> = 2  ;Distance of retract before probing opposite side


M70 ;Save modal state

G91 ; Relative positioning
G21 ; Use millimeters

;Probe toward right side of hole with a maximum probe distance
G38.2 X[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 X-1 ;retract 1mm
G38.2 X2 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
G4 P.250
#<X_RIGHT> = #<_X>
G0 X-[#<PROBE_MAJOR_RETRACT>]	;retract

; Probe toward Left side of hole with a maximum probe distance
G38.2 X-[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 X1 ;retract 1mm
G38.2 X-5 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
G4 P.250

; Calculate X dimension and set X0 in the active WCS
#<X_LEFT> = #<_X>
#<X_CHORD> = #<X_RIGHT> - #<X_LEFT>
(PRINT, X dimension #<X_CHORD>)
G0 X[#<X_CHORD>/2]
#<X_CENTER> = #<_X> ;Store X center G53 coordinate just in case
G4 P1   ;A dwell time of one second to make sure the planner queue is empty
G10 L20 P0 X0 ;Set current position as X0 in the active WCS

; Probe toward top side of hole with a maximum probe distance
G38.2 Y[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 Y-1 ;retract 1mm
G38.2 Y2 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
G4 P.250
#<Y_TOP> = #<_Y>
G0 Y-[#<PROBE_MAJOR_RETRACT>]	;retract

; Probe toward bottom side of hole with a maximum probe distance
G38.2 Y-[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 Y1 ;retract 1mm
G38.2 Y-5 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
G4 P.250

; Calculate Y dimension and set Y0 in the active WCS
#<Y_BTM> = #<_Y>
#<Y_CHORD> = #<Y_TOP> - #<Y_BTM>
(PRINT, Y dimension #<Y_CHORD>)
G0 Y[#<Y_CHORD>/2]
#<Y_CENTER> = #<_Y> ;Store Y center G53 coordinate just in case
; A dwell time of one second to make sure the planner queue is empty
G4 P1
G10 L20 P0 Y0 ;Set current position as Y0 in the active WCS

G90 ;restore absolute mode
M72 ;restore unit and distance modal state