.ORIG x3000
; skyblock-generator-lc3 - Minimal island creator using mcpp TRAPs
; This program teleports the player to a basepoint and builds a small
; "island" using the mcpp-enabled LC3 VM TRAPs. It's intentionally
; compact: the heavy lifting is done by CREATE_ISLAND subroutine.
;
; Register usage conventions:
;  R0-R3: used for trap arguments and local values
;  R4-R6: temporaries inside loops and when calculating positions
;  R7: used for subroutine return; saved/restored when calling other TRAPs that clobber it

    LEA R0, TELEPORT_MESSAGE ; message to inform player we will teleport
    CHAT

    ; Load the desired teleport destination from memory and set player
    LD R0, TELEPORT_X
    LD R1, TELEPORT_Y
    LD R2, TELEPORT_Z
    SETP

    LEA R0, CREATE_ISLAND_MESSAGE ; announce island creation
    CHAT
    JSR CREATE_ISLAND ; build the island
    HALT
TELEPORT_MESSAGE      .STRINGZ "Teleporting player to the skyblock island location..."
CREATE_ISLAND_MESSAGE .STRINGZ "Creating island..."
TELEPORT_X            .FILL #10
TELEPORT_Y            .FILL #70
TELEPORT_Z            .FILL #10

; CREATE_ISLAND builds an L-SHAPE island by iterating
; over Z, X, and Y coordinates relative to a BASEPOINT. It uses loop
; counters stored in memory to stay within LC3 immediate limits.
CREATE_ISLAND
    ST R7, MAIN_R7_SAVE ; save return address as SETB modifies it
    AND R0, R0, #0
    ST R0, Z_CUR ; initialize Z loop counter to 0

Z_LOOP
    ; Determine active width for this Z row. The island is symmetric
    ; across Z; for the first half we use WIDTH_FULL, second half WIDTH_HALF
    LD R0, Z_CUR
    LD R1, LENGTH_NEG
    ADD R2, R0, R1
    BRzp Z_LOOP_END

    LD R1, LENGTH_HALF_NEG
    ADD R2, R0, R1
    BRn Z_LESS_THAN_HALF

Z_GREATER_EQUAL_HALF
    LD R0, WIDTH_HALF
    ST R0, W_CUR
    BR Z_CONTINUE

Z_LESS_THAN_HALF
    LD R0, WIDTH_FULL
    ST R0, W_CUR

Z_CONTINUE
    AND R0, R0, #0
    ST R0, X_CUR ; initialize X loop counter for this Z row

X_LOOP
    ; X loop: iterate from 0 to (W_CUR - 1) using signed compare via addition
    LD R0, X_CUR
    LD R1, W_CUR
    ; Compute R0 - W_CUR by adding R0 + (-W_CUR)
    NOT R1, R1
    ADD R1, R1, #1
    ADD R2, R0, R1
    BRzp X_LOOP_END

    AND R0, R0, #0
    ST R0, Y_CUR ; initialize Y loop counter for this X column

Y_LOOP
    ; Y loop: decide if this vertical position should be dirt or grass.
    ; Use two boundary checks: bottom (fill with dirt) and top (grass).
    LD R0, Y_CUR
    LD R1, HEIGHT_NEG
    ADD R2, R0, R1
    BRzp Y_LOOP_END

    LD R1, HEIGHT_MINUS_ONE_NEG
    ADD R2, R0, R1
    BRz Y_IS_TOP

Y_IS_BOTTOM
    LD R3, DIRT_BLOCK ; place dirt for lower levels
    BR Y_PLACE_BLOCK

Y_IS_TOP
    LD R3, GRASS_BLOCK ; top layer gets grass

Y_PLACE_BLOCK
    ; Compute absolute world coordinates for SETB: basepoint + current offsets
    LD R0, BASEPOINT_X
    LD R4, X_CUR
    ADD R0, R0, R4

    LD R1, BASEPOINT_Y
    LD R4, Y_CUR
    ADD R1, R1, R4

    LD R2, BASEPOINT_Z
    LD R4, Z_CUR
    ADD R2, R2, R4

    ST R7, SETB_R7_SAVE
    SETB
    LD R7, SETB_R7_SAVE

    ; Increment Y and continue the vertical stack
    LD R0, Y_CUR
    ADD R0, R0, #1
    ST R0, Y_CUR
    BR Y_LOOP

Y_LOOP_END
    ; Finished Y for this (X,Z). Increment X and continue.
    LD R0, X_CUR
    ADD R0, R0, #1
    ST R0, X_CUR
    BR X_LOOP

X_LOOP_END
    ; Finished this row; advance Z and repeat until LENGTH_NEG threshold
    LD R0, Z_CUR
    ADD R0, R0, #1
    ST R0, Z_CUR
    BR Z_LOOP

Z_LOOP_END
    LD R7, MAIN_R7_SAVE
    RET

MAIN_R7_SAVE         .BLKW 1 ; storage for R7 while CREATE_ISLAND runs
SETB_R7_SAVE         .BLKW 1 ; storage for R7 while calling SETB

; Loop Counters stored in memory to allow larger loops without complex immediates
Z_CUR                .FILL #0
X_CUR                .FILL #0
Y_CUR                .FILL #0
W_CUR                .FILL #0 ; Holds the active width for the current Z row

; Constants negative values used for signed comparisons via addition
LENGTH_NEG           .FILL #-6
LENGTH_HALF_NEG      .FILL #-3

WIDTH_FULL           .FILL #6
WIDTH_HALF           .FILL #3

HEIGHT_NEG           .FILL #-3
HEIGHT_MINUS_ONE_NEG .FILL #-2

; Basepoint in world coordinates where the island is centered
BASEPOINT_X          .FILL #0
BASEPOINT_Y          .FILL #60
BASEPOINT_Z          .FILL #0

; Block IDs used by SETB
GRASS_BLOCK          .FILL #2
DIRT_BLOCK           .FILL #3
.END
