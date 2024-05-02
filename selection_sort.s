.section .text
.global selection_sort

selection_sort:

	// copy x29, x30
        stp     x29, x30, [sp, #-16]!
        // prolog
        sub     sp, sp, 16      // move stack pointer
        mov     x29, sp
		str     x19, [sp]
        str     x20, [sp, 8]

        mov     x19, x0
        mov     x20, x1

	// main body --------------------------------------------------

	// Check if array size is less than 2
	mov	x5, #2
	cmp 	x1, x5
	blt 	end_sort

	mov 	x2, #0       							// x2 = i

sort_outer_loop:
	// Set the current minimum to the current i position
	mov 	x3, x2
	add 	x4, x0, x2, lsl #2

	// Initialize j = i (inner loop)
	mov 	x5, x2

sort_inner_loop:
	cmp 	x5, x1
	bgt 	check_end_outer  // If j >= n, end inner loop

	// Calculate address of arr[j] for comparison
	add 	x6, x0, x5, lsl #2

    	// Load values of arr[min_idx] and arr[j]
    	ldr 	w7, [x4]
    	ldr 	w8, [x6]

    	// Compare to find new minimum
    	cmp 	w7, w8
    	bgt 	update_min   // If arr[min_idx] > arr[j], update min_idx
    	b 	skip_update

update_min:
    	// Update min_idx
    	mov 	x3, x5
    	mov 	x4, x6

skip_update:
    	// Increment j and continue inner loop
    	add 	x5, x5, #1
    	b 	sort_inner_loop

check_end_outer:
    	// Compare i with min_idx, if not the same, swap
    	cmp 	x2, x3
    	beq 	skip_swap

    	// Perform swap between arr[i] and arr[min_idx]
    	ldr 	w9, [x4]     // w9 = arr[min_idx]
    	ldr 	w10, [x0, x2, lsl #2]  // w10 = arr[i]
    	str 	w9, [x0, x2, lsl #2]
    	str 	w10, [x4]

skip_swap:
    	// Increment i and continue outer loop
    	add 	x2, x2, #1         	// Increment i
    	cmp 	x2, x1		     	// Compare i with n (consider i reaches up to n-2)
    	blt 	sort_outer_loop

end_sort:
	// epilog ------------------------------------------------------
        ldr     x19, [sp]
        ldr     x20, [sp, 8]
        add     sp, sp, 16      // reset stack pointer

        ldp     x29, x30, [sp], #16

        ret
