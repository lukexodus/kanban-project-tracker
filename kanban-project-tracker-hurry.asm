# Kanban Project Progress Tracker
# Menu System and Input Handling

.data
# Menu display strings
menu_header:     .asciiz "\n-----------------------------------------------\n          PROJECT PROGRESS TRACKER\n-----------------------------------------------\n"
menu_option1:    .asciiz "[1] View Board\n"
menu_option2:    .asciiz "[2] Add Task\n"
menu_option3:    .asciiz "[3] Move Task\n"
menu_option4:    .asciiz "[4] Delete Task\n"
menu_option5:    .asciiz "[5] View Task History\n"
menu_option6:    .asciiz "[6] Save Board\n"
menu_option7:    .asciiz "[7] Load Board\n"
menu_option0:    .asciiz "[0] Exit\n"
menu_prompt:     .asciiz "Choose an option: "
invalid_option:  .asciiz "\nInvalid option. Please try again.\n"
exit_message:    .asciiz "\nExiting Kanban Project Progress Tracker. Goodbye!\n"

# Function not implemented message
not_implemented: .asciiz "\nThis feature is not yet implemented.\n"

# Add Task strings
add_task_header:     .asciiz "\n----- ADD NEW TASK -----\n"
title_prompt:        .asciiz "Enter Task Title: "
priority_prompt:     .asciiz "Enter Priority (0=Low, 1=Medium, 2=High): "
deadline_prompt:     .asciiz "Enter Deadline (DD-MM): "
priority_invalid:    .asciiz "\nInvalid priority. Please enter 0, 1, or 2.\n"
deadline_format:     .asciiz "\nInvalid date format. Please use DD-MM (e.g., 15-10).\n"
task_added:          .asciiz "\n? Task added to TO DO"
priority_suffix:     .asciiz " with "
low_priority:        .asciiz "low"
medium_priority:     .asciiz "medium"
high_priority:       .asciiz "high"
priority_end:        .asciiz " priority.\n"

# Delete Task strings
delete_task_header:  .asciiz "\n----- DELETE TASK -----\n"
no_tasks_message:    .asciiz "\nThere are no tasks to delete.\n"
task_prompt:         .asciiz "Enter Task Number to Delete: "
confirm_delete:      .asciiz "\nAre you sure you want to delete this task? (1=Yes, 0=No): "
task_deleted:        .asciiz "\n? Task \""
task_deleted_mid:    .asciiz "\" has been deleted.\n"
delete_cancelled:    .asciiz "\n? Delete operation cancelled.\n"

# Move Task strings
move_task_header:       .asciiz "\n----- MOVE TASK -----\n"
no_tasks_message_move:  .asciiz "\nThere are no tasks to move.\n"
task_prompt_move:	.asciiz "Enter Task Number to Move: "
move_task_where:	.asciiz "Enter which field to move to (0 = TO DO,1 = IN PROGRESS,2 = REVIEW,3 = DONE: "
invalid_task_field:	.asciiz "\nInvalid stage field. Please try again:\n"
confirm_move:		.asciiz "\n Are you sure you want to move this task? (1=Yes, 0=No): "
task_moved:		.asciiz "\n? Task \""
task_moved_mid:		.asciiz "\" has been moved.\n"
move_cancelled:		.asciiz "\n? Move operation cancelled.\n"

# Universal Strings
invalid_task_id:     .asciiz "\nInvalid task number. Please try again.\n"

# Buffers for user input
input_buffer:        .space 4
title_buffer:        .space 41   # 40 chars + null terminator
deadline_buffer:     .space 6    # 5 chars (DD-MM) + null terminator

# Task storage
# Maximum 100 tasks, each task structure is:
# - ID (int)
# - Title (40 chars)
# - Priority (0=Low, 1=Medium, 2=High)
# - Stage (0=To Do, 1=In Progress, 2=Review, 3=Done)
# - Deadline (10 chars)
# - Status (0=Active, 1=Deleted)

MAX_TASKS:           .word 100
task_count:          .word 0     # Current number of tasks

# Task arrays
task_ids:            .space 400  # 100 * 4 bytes
task_titles:         .space 4000 # 100 * 40 bytes
task_priorities:     .space 100  # 100 * 1 byte
task_stages:         .space 100  # 100 * 1 byte
task_deadlines:      .space 1000 # 100 * 10 bytes
task_statuses:       .space 100  # 100 * 1 byte

# View Board strings
view_board_header: 	.asciiz "\n----- VIEW BOARD -----\n"
to_do: 			.asciiz "TO DO: "
in_progress: 		.asciiz "IN PROGRESS: "
review: 		.asciiz "REVIEW: "
done: 			.asciiz "DONE: "
deadline_prefix: 	.asciiz "(Due: "

.text
.globl main

main:
    # Display welcome message when program first starts
    jal display_menu
    
    # Main program loop
    main_loop:
        # Get user choice
        jal get_user_choice
        
        # Process user choice (stored in $v0)
        beq $v0, 0, exit_program    # Exit
        beq $v0, 1, view_board      # View Board
        beq $v0, 2, add_task        # Add Task
        beq $v0, 3, move_task       # Move Task
        beq $v0, 4, delete_task     # Delete Task
        beq $v0, 5, view_history    # View Task History
        beq $v0, 6, save_board      # Save Board
        beq $v0, 7, load_board      # Load Board
        
        # If we get here, it was an invalid option (should not happen with input validation)
        li $v0, 4
        la $a0, invalid_option
        syscall
        
        j main_loop    # Return to main loop
    
#----------------------------------------------------
# Displays the main menu
#----------------------------------------------------
display_menu:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Print menu header
    li $v0, 4
    la $a0, menu_header
    syscall
    
    # Print menu options
    la $a0, menu_option1
    syscall
    la $a0, menu_option2
    syscall
    la $a0, menu_option3
    syscall
    la $a0, menu_option4
    syscall
    la $a0, menu_option5
    syscall
    la $a0, menu_option6
    syscall
    la $a0, menu_option7
    syscall
    la $a0, menu_option0
    syscall
    
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#----------------------------------------------------
# Gets the user's menu choice with validation
# Returns: $v0 = user's choice (0-7)
#----------------------------------------------------
get_user_choice:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display prompt
    li $v0, 4
    la $a0, menu_prompt
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    # $v0 now contains the user's input
    
    # Validate input (must be between 0 and 7)
    blt $v0, 0, invalid_input
    bgt $v0, 7, invalid_input
    
    # Input is valid, return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
invalid_input:
    # Display error message
    li $v0, 4
    la $a0, invalid_option
    syscall
    
    # Try again
    j get_user_choice

#----------------------------------------------------
# Menu option handlers (placeholders for now)
#----------------------------------------------------
view_board:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # HEADER    
    li $v0, 4
    la $a0, view_board_header
    syscall
    
    # TO DO
    li $v0, 4
    la $a0, to_do
    syscall
    
    li $v0, 11
    li $a0, 10
    syscall
    
    jal print_to_do_list
    
    li $v0, 11
    li $a0, 10
    syscall
    	
    # IN PROGRESS
    li $v0, 4
    la $a0, in_progress
    syscall
    
    li $v0, 11
    li $a0, 10
    syscall
    
    jal print_in_progress_list
    
    li $v0, 11
    li $a0, 10
    syscall
    	
    # REVIEW
    li $v0, 4
    la $a0, review
    syscall
    
    li $v0, 11
    li $a0, 10
    syscall
    
    jal print_review_list
    
    li $v0, 11
    li $a0, 10
    syscall
   
    #DONE
    li $v0, 4
    la $a0, done
    syscall
    
    li $v0, 11
    li $a0, 10
    syscall
    
    jal print_done_list
    
    li $v0, 11
    li $a0, 10
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

add_task:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display add task header
    li $v0, 4
    la $a0, add_task_header
    syscall
    
    # Get task title
    jal get_task_title
    
    # Get task priority
    jal get_task_priority
    # Priority is in $v0 (0=Low, 1=Medium, 2=High)
    move $t8, $v0    # Store priority in $t8		--- Changed $t0 to $t8
    
    # Get task deadline
    jal get_task_deadline
    
    # Add task to "To Do" stage (0)
    # Create a new task
    jal create_new_task
    
    # Display confirmation message
    li $v0, 4
    la $a0, task_added
    syscall
    
    la $a0, priority_suffix
    syscall
    
    # Display priority text based on $t0
    beq $t0, 0, display_low
    beq $t0, 1, display_medium
    beq $t0, 2, display_high
    j end_priority_display
    
display_low:
    la $a0, low_priority
    j print_priority
    
display_medium:
    la $a0, medium_priority
    j print_priority
    
display_high:
    la $a0, high_priority
    
print_priority:
    syscall
    la $a0, priority_end
    syscall
    
end_priority_display:
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

#----------------------------------------------------
# Get task title from user
#----------------------------------------------------
get_task_title:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display prompt
    li $v0, 4
    la $a0, title_prompt
    syscall
    
    # Read string (title)
    li $v0, 8
    la $a0, title_buffer
    li $a1, 41       # 40 chars + null terminator
    syscall
    
    # Remove newline if present (replace with null)
    la $t0, title_buffer      # Load address of buffer
    
remove_newline_loop:
    lb $t1, 0($t0)            # Load byte from buffer
    beqz $t1, newline_done    # If null, we're done
    bne $t1, 10, continue     # If not newline, continue
    sb $zero, 0($t0)          # Replace newline with null
    j newline_done
    
continue:
    addi $t0, $t0, 1          # Move to next character
    j remove_newline_loop
    
newline_done:
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#----------------------------------------------------
# Get task priority from user (0=Low, 1=Medium, 2=High)
# Returns: $v0 = priority value
#----------------------------------------------------
get_task_priority:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display prompt
    li $v0, 4
    la $a0, priority_prompt
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    # $v0 now contains the priority value
    
    # Validate priority (must be 0, 1, or 2)
    blt $v0, 0, invalid_priority
    bgt $v0, 2, invalid_priority
    
    # Priority is valid, return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
invalid_priority:
    # Display error message
    li $v0, 4
    la $a0, priority_invalid
    syscall
    
    # Try again
    j get_task_priority

#----------------------------------------------------
# Get task deadline from user
#----------------------------------------------------
get_task_deadline:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display prompt
    li $v0, 4
    la $a0, deadline_prompt
    syscall
    
    # Read string (deadline)
    li $v0, 8
    la $a0, deadline_buffer
    li $a1, 6        # 5 chars (DD-MM) + null terminator
    syscall
    
    # TODO: Validate deadline format (DD-MM)
    # For now, we'll just accept anything the user enters
    
    # Remove newline if present (replace with null)
    la $t0, deadline_buffer   # Load address of buffer
    
deadline_remove_newline_loop:
    lb $t1, 0($t0)            # Load byte from buffer
    beqz $t1, deadline_newline_done  # If null, we're done
    bne $t1, 10, deadline_continue   # If not newline, continue
    sb $zero, 0($t0)          # Replace newline with null
    j deadline_newline_done
    
deadline_continue:
    addi $t0, $t0, 1          # Move to next character
    j deadline_remove_newline_loop
    
deadline_newline_done:
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#----------------------------------------------------
# Create a new task and add it to the task arrays
#----------------------------------------------------
create_new_task:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if we've reached the maximum number of tasks
    lw $t0, task_count
    lw $t1, MAX_TASKS
    bge $t0, $t1, task_limit_reached
    
    # Get current task_count (this will be our new task ID)
    lw $t0, task_count
    
    # Store task ID
    la $t1, task_ids
    sll $t2, $t0, 2           # Multiply by 4 (size of int)
    add $t1, $t1, $t2         # Offset into array
    sw $t0, 0($t1)            # Store ID
    
    # Store task stage (0 = To Do)
    la $t1, task_stages
    add $t1, $t1, $t0         # Offset into array
    li $t2, 0                 # Stage 0 (To Do)
    sb $t2, 0($t1)            # Store stage
    
    # Store task priority
    la $t1, task_priorities
    add $t1, $t1, $t0         # Offset into array
    sb $t8, 0($t1)            # Store priority (from $t8)
    
    # Store task status (0 = Active)
    la $t1, task_statuses
    add $t1, $t1, $t0         # Offset into array
    li $t2, 0                 # Status 0 (Active)
    sb $t2, 0($t1)            # Store status
    
    # Store task title (copy from title_buffer)
    la $t1, task_titles
    li $t2, 40                # Each title is 40 bytes
    mul $t3, $t0, $t2         # Offset into array
    add $t1, $t1, $t3         # Address to store title
    
    la $t2, title_buffer      # Source address
    li $t3, 0                 # Counter
    
copy_title_loop:
    beq $t3, 40, copy_title_done  # If we've copied 40 bytes, we're done
    lb $t4, 0($t2)            # Load byte from source
    beqz $t4, pad_null      # If null, pad with null
    sb $t4, 0($t1)            # Store byte in destination
    addi $t1, $t1, 1          # Increment destination address
    addi $t2, $t2, 1          # Increment source address
    addi $t3, $t3, 1          # Increment counter
    j copy_title_loop
    
pad_null:
    li $t4, 0                # null character
    sb $t4, 0($t1)            # Store space in destination
    addi $t1, $t1, 1          # Increment destination address
    addi $t3, $t3, 1          # Increment counter
    bne $t3, 40, pad_null   # Continue padding until we've done 40 bytes
    
copy_title_done:
    # Store task deadline (copy from deadline_buffer)
    la $t1, task_deadlines
    li $t2, 10                # Each deadline is 10 bytes
    mul $t3, $t0, $t2         # Offset into array
    add $t1, $t1, $t3         # Address to store deadline
    
    la $t2, deadline_buffer   # Source address
    li $t3, 0                 # Counter
    
copy_deadline_loop:
    beq $t3, 10, copy_deadline_done  # If we've copied 10 bytes, we're done
    lb $t4, 0($t2)            # Load byte from source
    beqz $t4, pad_deadline_null    # If null, store
    sb $t4, 0($t1)            # Store byte in destination
    addi $t1, $t1, 1          # Increment destination address
    addi $t2, $t2, 1          # Increment source address
    addi $t3, $t3, 1          # Increment counter
    blt $t3, 10, copy_deadline_loop
    j copy_deadline_loop
    
pad_deadline_null:
    li $t4, 0                # null character
    sb $t4, 0($t1)            # Store null in destination
    addi $t1, $t1, 1          # Increment destination address
    addi $t3, $t3, 1          # Increment counter
    blt $t3, 10, pad_deadline_null	# pad till  10 bytes
    
copy_deadline_done:
    # Increment task_count
    lw $t0, task_count
    addi $t0, $t0, 1
    sw $t0, task_count
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
task_limit_reached:
    # TODO: Display error message
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

move_task:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display move task header
    li $v0, 4
    la $a0, move_task_header
    syscall
    
    # Check if there are any tasks
    lw $t0, task_count
    bgtz $t0, have_tasks_move
    
    # No tasks to move
    li $v0, 4
    la $a0, no_tasks_message_move
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop
    
have_tasks_move:
    # Display all active tasks
    jal display_task_list
    
    # Get task ID to move
    li $v0, 4
    la $a0, task_prompt_move
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    # $v0 contains the task ID to move
    
    jal validate_task_id
    # If invalid, validate_task_id will loop back to get input
    # If valid, $v0 contains the index of the task in our arrys
    
    # Store task index in $t0
    move $t0, $v0
    
    # Display confirmation prompt
    li $v0, 4
    la $a0, confirm_move
    syscall
    
    # Read integer (confirmation)
    li $v0, 5
    syscall
    # $v0 contains confirmation (1=Yes, 0=No)
    
    # If confirmation is not 1, cancel move
    bne $v0, 1, cancel_move
    
    # Get user choice, which field to move
    li $v0, 4
    la $a0, move_task_where
    syscall
    
    # Get integer
    li $v0, 5
    syscall
    # $v0 contains which task field to be moved to
    
    jal validate_task_field
    
    # $t1 contains which stage field to move to
    move $t1, $v0
    
    # Moving proper
    la $t2, task_stages
    
    # Calculate offset
    mul $t3, $t0, 68	# Task size is 68 bytes	
    add $t4, $t2, $t3	# Add offset to base adress to get task's stage
    
    sb $t1, 0($t4)	# Stage field in t1 will replace old stage field
   
    # Display move confirmation with task title
    li $v0, 4
    la $a0, task_moved
    syscall
    
    # Display task title
    la $t1, task_titles
    li $t2,  40
    mul $t3, $t0, $t2
    add $t1, $t1, $t3
    
    # Find the length of the title 
    move $t2, $t1
    li $t3, 0
    
title_length_loop_move:
    lb $t4, 0($t2)          # Load character
    beqz $t4, title_length_move_done     # If null, we're done
    beq $t4, 32, check_space_move        # Check if it's a space
    addi $t3, $t3, 1        # Increment counter
    addi $t2, $t2, 1        # Move to next character
    blt $t3, 40, title_length_loop_move  # If less than 40, continue
    j title_length_move_done
    
check_space_move:
    # See if the rest of the string is spaces
    move $t5, $t2           # Copy current position
    li $t6, 0               # Counter
    
check_space_loop_move:
    lb $t7, 0($t5)          # Load character
    beqz $t7, title_is_all_spaces_move   # If null, the rest is spaces
    bne $t7, 32, not_all_spaces_move     # If not space, continue
    addi $t5, $t5, 1        # Move to next character
    addi $t6, $t6, 1        # Increment counter
    add $t8, $t3, $t6       # Total characters processed
    blt $t8, 40, check_space_loop_move   # If less than 40, continue
    
title_is_all_spaces_move:
    # The rest of the string is spaces, so we can stop here
    j title_length_move_done
    
not_all_spaces_move:
    # Continue counting
    addi $t3, $t3, 1        # Increment counter
    addi $t2, $t2, 1        # Move to next character
    blt $t3, 40, title_length_loop_move  # If less than 40, continue
    
title_length_move_done:
    # Now $t3 contains the length of the title (excluding trailing spaces)
    # Print the title (up to the length we calculated)
    move $a0, $t1           # Address of title
    move $a1, $t3           # Length of title
    li $v0, 11              # Print character syscall
    
print_title_move_loop:
    beqz $a1, print_title_move_done  # If length is 0, we're done
    lb $a0, 0($t1)              # Load character
    syscall                     # Print character
    addi $t1, $t1, 1            # Move to next character
    addi $a1, $a1, -1           # Decrement counter
    j print_title_move_loop
    
print_title_move_done:
    # Print the rest of the message
    li $v0, 4
    la $a0, task_moved_mid
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop
    
cancel_move:
    # Display cancellation message
    li $v0, 4
    la $a0, move_cancelled
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop
    
delete_task:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display delete task header
    li $v0, 4
    la $a0, delete_task_header
    syscall
    
    # Check if there are any tasks
    lw $t0, task_count
    bgtz $t0, have_tasks
    
    # No tasks to delete
    li $v0, 4
    la $a0, no_tasks_message
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop
    
have_tasks:
    # Display all active tasks first
    jal display_task_list
    
    # Get task ID to delete
    li $v0, 4
    la $a0, task_prompt
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    # $v0 now contains the task ID to delete
    
    # Validate task ID
    jal validate_task_id
    # If invalid, validate_task_id will loop back to get input
    # If valid, $v0 contains the index of the task in our arrays
    
    # Store task index in $t0
    move $t0, $v0
    
    # Display confirmation prompt
    li $v0, 4
    la $a0, confirm_delete
    syscall
    
    # Read integer (confirmation)
    li $v0, 5
    syscall
    # $v0 now contains the confirmation (1=Yes, 0=No)
    
    # If confirmation is not 1, cancel deletion
    bne $v0, 1, cancel_delete
    
    # Mark the task as deleted (status = 1)
    la $t1, task_statuses
    add $t1, $t1, $t0       # Offset to task status
    li $t2, 1               # 1 = Deleted
    sb $t2, 0($t1)          # Set status to Deleted
    
    # Display deletion confirmation with task title
    li $v0, 4
    la $a0, task_deleted
    syscall
    
    # Display task title
    la $t1, task_titles
    li $t2, 40              # Each title is 40 bytes
    mul $t3, $t0, $t2       # Calculate offset
    add $t1, $t1, $t3       # Address of title
    
    # Find the length of the title (first null or up to 40 chars)
    move $t2, $t1           # Copy address to $t2
    li $t3, 0               # Counter
    
title_length_loop:
    lb $t4, 0($t2)          # Load character
    beqz $t4, title_length_done     # If null, we're done
    beq $t4, 32, check_space        # Check if it's a space
    addi $t3, $t3, 1        # Increment counter
    addi $t2, $t2, 1        # Move to next character
    blt $t3, 40, title_length_loop  # If less than 40, continue
    j title_length_done
    
check_space:
    # See if the rest of the string is spaces
    move $t5, $t2           # Copy current position
    li $t6, 0               # Counter
    
check_space_loop:
    lb $t7, 0($t5)          # Load character
    beqz $t7, title_is_all_spaces   # If null, the rest is spaces
    bne $t7, 32, not_all_spaces     # If not space, continue
    addi $t5, $t5, 1        # Move to next character
    addi $t6, $t6, 1        # Increment counter
    add $t8, $t3, $t6       # Total characters processed
    blt $t8, 40, check_space_loop   # If less than 40, continue
    
title_is_all_spaces:
    # The rest of the string is spaces, so we can stop here
    j title_length_done
    
not_all_spaces:
    # Continue counting
    addi $t3, $t3, 1        # Increment counter
    addi $t2, $t2, 1        # Move to next character
    blt $t3, 40, title_length_loop  # If less than 40, continue
    
title_length_done:
    # Now $t3 contains the length of the title (excluding trailing spaces)
    # Print the title (up to the length we calculated)
    move $a0, $t1           # Address of title
    move $a1, $t3           # Length of title
    li $v0, 11              # Print character syscall
    
print_title_loop:
    beqz $a1, print_title_done  # If length is 0, we're done
    lb $a0, 0($t1)              # Load character
    syscall                     # Print character
    addi $t1, $t1, 1            # Move to next character
    addi $a1, $a1, -1           # Decrement counter
    j print_title_loop
    
print_title_done:
    # Print the rest of the message
    li $v0, 4
    la $a0, task_deleted_mid
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop
    
cancel_delete:
    # Display cancellation message
    li $v0, 4
    la $a0, delete_cancelled
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

#----------------------------------------------------
# Display list of active tasks
#----------------------------------------------------

display_task_list:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Initialize variables
    li $t0, 0               # Counter
    lw $t1, task_count      # Total number of tasks
    
    # Loop through tasks
    task_list_loop:
        beq $t0, $t1, task_list_done  # If we've processed all tasks, we're done
        
        # Check if the task is active
        la $t2, task_statuses
        add $t2, $t2, $t0       # Offset to task status
        lb $t3, 0($t2)          # Load status
        bnez $t3, skip_task     # If status is not 0 (Active), skip this task
        
        # Print task ID
        li $v0, 11              # Print character syscall
        li $a0, 91              # '[' character
        syscall
        
        li $v0, 1               # Print integer syscall
        move $a0, $t0           # Task ID
        syscall
        
        li $v0, 11              # Print character syscall
        li $a0, 93              # ']' character
        syscall
        
        li $a0, 32              # Space character
        syscall
        
        # Print task title (up to first 20 chars)
        la $t2, task_titles
        li $t3, 40              # Each title is 40 bytes
        mul $t4, $t0, $t3       # Calculate offset
        add $t2, $t2, $t4       # Address of title
        
        # Print up to 20 chars of the title
        li $t3, 0               # Counter for printed chars
        
        print_title_short_loop:
            beq $t3, 20, print_title_short_done  # If we've printed 20 chars, we're done
            lb $a0, 0($t2)                       # Load character
            beqz $a0, print_title_short_done     # If null, we're done
            beq $a0, 32, check_if_all_spaces     # If space, check if the rest is spaces
            
            # Print the character
            li $v0, 11          # Print character syscall
            syscall
            
            addi $t2, $t2, 1    # Move to next character
            addi $t3, $t3, 1    # Increment counter
            j print_title_short_loop
            
        check_if_all_spaces:
            # Check if the rest of the string (up to 20 chars) is spaces
            move $t5, $t2       # Copy current position
            li $t6, 0           # Counter
            
        check_if_all_spaces_loop:
            add $t7, $t3, $t6   # Total characters processed
            beq $t7, 20, print_title_short_done  # If we've processed 20 chars, we're done
            lb $t7, 0($t5)      # Load character
            beqz $t7, print_title_short_done     # If null, we're done
            bne $t7, 32, not_all_spaces_short    # If not space, continue printing
            addi $t5, $t5, 1    # Move to next character
            addi $t6, $t6, 1    # Increment counter
            j check_if_all_spaces_loop
            
        not_all_spaces_short:
            # Print the space and continue
            li $v0, 11          # Print character syscall
            li $a0, 32          # Space character
            syscall
            
            addi $t2, $t2, 1    # Move to next character
            addi $t3, $t3, 1    # Increment counter
            j print_title_short_loop
            
        print_title_short_done:
            # Print newline
            li $v0, 11          # Print character syscall
            li $a0, 10          # Newline character
            syscall
        
        skip_task:
            addi $t0, $t0, 1    # Move to next task
            j task_list_loop
    
    task_list_done:
        # Return
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra


#----------------------------------------------------
# Print tasks for board
#----------------------------------------------------
#----PRINT TO DO LIST-----
print_to_do_list:
   addi $sp, $sp, -4
   sw $ra, 0($sp)
	
   li $t0, 2	# Priority level start
   lw $t2, task_count	# Total number of tasks
	
   priority_shift_loop_to_do:
      blt $t0, 0, print_to_do_list_done
      
      li $t1, 0	# Counter
   
   to_do_list_loop:
      bge $t1, $t2, next_priority_to_do
      
      # Load Task Stage
      la $t6, task_stages
      add $t7, $t6, $t1 # Offset = Index
      lb $t3, 0($t7)	#  t3 = stage
      bne $t3, 0, skip_to_do_task  # skip if wrong stage(to do)
      
      # Load Task Priority
      la $t6, task_priorities
      add $t7, $t6, $t1
      lb $t4, 0($t7)
      bne $t4, $t0, skip_to_do_task   # skip if wrong priority
      
      #Load Task ID
      la $t6, task_ids
      sll $t7, $t1, 2
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lw $a0, 0($t7)	# Load ID into a0
      li $v0, 1
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Priority
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      li $v0, 1
      move $a0, $t4	# Load priority into a0
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Task Title
      la $t6, task_titles
      li $s0, 40		# s0 = 40
      mul $t7, $t1, $s0		# offset = index * 40
      add $t6, $t6, $t7		# address of title
      
      li $t9, 0		# Counter for printed chars
      
      print_to_do_title_short_loop:
         beq $t9, 20, print_to_do_title_short_done
      	 lb $a0, 0($t6)
      	 beqz $a0, print_to_do_title_short_done
      	 beq $a0, 32, check_if_all_space_to_do
      	 
      	 li $v0, 11
      	 syscall
      	 
      	 addi $t6, $t6, 1
      	 addi $t9, $t9, 1
      	 j print_to_do_title_short_loop
      	 
      check_if_all_space_to_do:
         move $t5, $t6
         li $t7, 0
         
      check_if_all_space_to_do_loop:
         add $t8, $t9, $t7
         beq $t8, 20, print_to_do_title_short_done
         lb $t8, 0($t5)
         beqz $t8, print_to_do_title_short_done
      	 bne $t8, 32, not_all_to_do_space_short
      	 addi $t5, $t5, 1
      	 addi $t7, $t7, 1
      	 j check_if_all_space_to_do_loop
      	  
      not_all_to_do_space_short:
         li $v0, 11
         li $a0, 32
         syscall
         
         addi $t6, $t6, 1
         addi $t9, $t9, 1
         j print_to_do_title_short_loop
         
      print_to_do_title_short_done:
         li $v0, 11
         li $a0, 32		# space
         syscall
         
      # DEADLINE
   	li $v0, 4                    # Print string syscall
   	la $a0, deadline_prefix      # Load "Due: " prefix
   	syscall

   	li $t6, 6                   # Size of string (deadline length)
   	mul $t7, $t1, $t6            # Calculate offset for task's deadline (based on task index)
   	la $t6, task_deadlines       # Load base address of task_deadlines
   	add $t6, $t6, $t7            # Add offset to get correct address for the current task

   	li $t8, 0                    # Counter for printing chars

   	print_to_do_deadline_loop:
      	lb $a0, 0($t6)             # Load a byte from the deadline string
      	beqz $a0, print_to_do_deadline_done  # If null byte (end of string), stop printing
      	li $v0, 11                 # Print character syscall
      	syscall                    # Print the character
      	addi $t6, $t6, 1           # Move to the next character
      	addi $t8, $t8, 1           # Increment counter
      	j print_to_do_deadline_loop      # Continue the loop

   	print_to_do_deadline_done:
      	li $v0, 11
      	li $a0, 41		# ')' character
      	syscall
      	
      	li $v0, 11
      	li $a0, 10
      	syscall

   skip_to_do_task:		# Skip current task
      addi $t1, $t1, 1
      j to_do_list_loop
   
   next_priority_to_do:		# Move to lower priority
      addi $t0, $t0, -1
      j priority_shift_loop_to_do
	  	
   print_to_do_list_done:
      # Return
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra

#---- PRINT IN PROGRESS LIST----
print_in_progress_list:
   addi $sp, $sp, -4
   sw $ra, 0($sp)
	
   li $t0, 2	# Priority level start
   lw $t2, task_count	# Total number of tasks
	
   priority_shift_loop_in_progress:
      blt $t0, 0, print_in_progress_list_done
      
      li $t1, 0	# Counter
   
   in_progress_list_loop:
      bge $t1, $t2, next_priority_in_progress
      
      # Load Task Stage
      la $t6, task_stages
      add $t7, $t6, $t1 # Offset = Index
      lb $t3, 0($t7)	#  t3 = stage
      bne $t3, 1, skip_in_progress_task  # skip if wrong stage(to do)
      
      # Load Task Priority
      la $t6, task_priorities
      add $t7, $t6, $t1
      lb $t4, 0($t7)
      bne $t4, $t0, skip_in_progress_task   # skip if wrong priority
      
      #Load Task ID
      la $t6, task_ids
      sll $t7, $t1, 2
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lw $a0, 0($t7)	# Load ID into a0
      li $v0, 1
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Priority
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      li $v0, 1
      move $a0, $t4	# Load priority into a0
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Task Title
      la $t6, task_titles
      li $s0, 40		# s0 = 40
      mul $t7, $t1, $s0		# offset = index * 40
      add $t6, $t6, $t7		# address of title
      
      li $t9, 0		# Counter for printed chars
      
      print_in_progress_title_short_loop:
         beq $t9, 20, print_in_progress_title_short_done
      	 lb $a0, 0($t6)
      	 beqz $a0, print_in_progress_title_short_done
      	 beq $a0, 32, check_if_all_space_in_progress
      	 
      	 li $v0, 11
      	 syscall
      	 
      	 addi $t6, $t6, 1
      	 addi $t9, $t9, 1
      	 j print_in_progress_title_short_loop
      	 
      check_if_all_space_in_progress:
         move $t5, $t6
         li $t7, 0
         
      check_if_all_space_in_progress_loop:
         add $t8, $t9, $t7
         beq $t8, 20, print_in_progress_title_short_done
         lb $t8, 0($t5)
         beqz $t8, print_in_progress_title_short_done
      	 bne $t8, 32, not_all_in_progress_space_short
      	 addi $t5, $t5, 1
      	 addi $t7, $t7, 1
      	 j check_if_all_space_in_progress_loop
      	  
      not_all_in_progress_space_short:
         li $v0, 11
         li $a0, 32
         syscall
         
         addi $t6, $t6, 1
         addi $t9, $t9, 1
         j print_in_progress_title_short_loop
         
      print_in_progress_title_short_done:
      	 li $v0, 11
         li $a0, 32		# space
         syscall
         
        # DEADLINE
   	li $v0, 4                    # Print string syscall
   	la $a0, deadline_prefix      # Load "Due: " prefix
   	syscall

   	li $t6, 6                   # Size of string (deadline length)
   	mul $t7, $t1, $t6            # Calculate offset for task's deadline (based on task index)
   	la $t6, task_deadlines       # Load base address of task_deadlines
   	add $t6, $t6, $t7            # Add offset to get correct address for the current task

   	li $t8, 0                    # Counter for printing chars

   	print_in_progress_deadline_loop:
      	lb $a0, 0($t6)             # Load a byte from the deadline string
      	beqz $a0, print_in_progress_deadline_done  # If null byte (end of string), stop printing
      	li $v0, 11                 # Print character syscall
      	syscall                    # Print the character
      	addi $t6, $t6, 1           # Move to the next character
      	addi $t8, $t8, 1           # Increment counter
      	j print_in_progress_deadline_loop      # Continue the loop

   	print_in_progress_deadline_done:
      	li $v0, 11
      	li $a0, 41		# ')' character
      	syscall
      	
      	li $v0, 11
      	li $a0, 10
      	syscall

   skip_in_progress_task:		# Skip current task
      addi $t1, $t1, 1
      j to_do_list_loop
   
   next_priority_in_progress:		# Move to lower priority
      addi $t0, $t0, -1
      j priority_shift_loop_in_progress
	  	
   print_in_progress_list_done:
   # Return
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   jr $ra
   
#---PRINT REVIEW LIST----
print_review_list:
   addi $sp, $sp, -4
   sw $ra, 0($sp)
	
   li $t0, 2	# Priority level start
   lw $t2, task_count	# Total number of tasks
	
   priority_shift_loop_review:
      blt $t0, 0, print_review_list_done
      
      li $t1, 0	# Counter
   
   review_list_loop:
      bge $t1, $t2, next_priority_review
      
      # Load Task Stage
      la $t6, task_stages
      add $t7, $t6, $t1 # Offset = Index
      lb $t3, 0($t7)	#  t3 = stage
      bne $t3, 2, skip_review_task  # skip if wrong stage(to do)
      
      # Load Task Priority
      la $t6, task_priorities
      add $t7, $t6, $t1
      lb $t4, 0($t7)
      bne $t4, $t0, skip_review_task   # skip if wrong priority
      
      #Load Task ID
      la $t6, task_ids
      sll $t7, $t1, 2
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lw $a0, 0($t7)	# Load ID into a0
      li $v0, 1
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Priority
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      li $v0, 1
      move $a0, $t4	# Load priority into a0
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Task Title
      la $t6, task_titles
      li $s0, 40		# s0 = 40
      mul $t7, $t1, $s0		# offset = index * 40
      add $t6, $t6, $t7		# address of title
      
      li $t9, 0		# Counter for printed chars
      
      print_review_title_short_loop:
         beq $t9, 20, print_review_title_short_done
      	 lb $a0, 0($t6)
      	 beqz $a0, print_review_title_short_done
      	 beq $a0, 32, check_if_all_space_review
      	 
      	 li $v0, 11
      	 syscall
      	 
      	 addi $t6, $t6, 1
      	 addi $t9, $t9, 1
      	 j print_review_title_short_loop
      	 
      check_if_all_space_review:
         move $t5, $t6
         li $t7, 0
         
      check_if_all_space_review_loop:
         add $t8, $t9, $t7
         beq $t8, 20, print_review_title_short_done
         lb $t8, 0($t5)
         beqz $t8, print_review_title_short_done
      	 bne $t8, 32, not_all_review_space_short
      	 addi $t5, $t5, 1
      	 addi $t7, $t7, 1
      	 j check_if_all_space_review_loop
      	  
      not_all_review_space_short:
         li $v0, 11
         li $a0, 32
         syscall
         
         addi $t6, $t6, 1
         addi $t9, $t9, 1
         j print_review_title_short_loop
         
      print_review_title_short_done:
         li $v0, 11
         li $a0, 32		# space
         syscall
         
         # DEADLINE
   	li $v0, 4                    # Print string syscall
   	la $a0, deadline_prefix      # Load "Due: " prefix
   	syscall

   	li $t6, 6                   # Size of string (deadline length)
   	mul $t7, $t1, $t6            # Calculate offset for task's deadline (based on task index)
   	la $t6, task_deadlines       # Load base address of task_deadlines
   	add $t6, $t6, $t7            # Add offset to get correct address for the current task

   	li $t8, 0                    # Counter for printing chars

   	print_review_deadline_loop:
      	lb $a0, 0($t6)             # Load a byte from the deadline string
      	beqz $a0, print_review_deadline_done  # If null byte (end of string), stop printing
      	li $v0, 11                 # Print character syscall
      	syscall                    # Print the character
      	addi $t6, $t6, 1           # Move to the next character
      	addi $t8, $t8, 1           # Increment counter
      	j print_review_deadline_loop      # Continue the loop

   	print_review_deadline_done:
      	li $v0, 11
      	li $a0, 41		# ')' character
      	syscall
      	
      	li $v0, 11
      	li $a0, 10
      	syscall

   skip_review_task:		# Skip current task
      addi $t1, $t1, 1
      j review_list_loop
   
   next_priority_review:		# Move to lower priority
      addi $t0, $t0, -1
      j priority_shift_loop_review
	  	
   print_review_list_done:
   # Return
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   jr $ra
   
#---PRINT DONE LIST----
print_done_list:
   addi $sp, $sp, -4
   sw $ra, 0($sp)
	
   li $t0, 2	# Priority level start
   lw $t2, task_count	# Total number of tasks
	
   priority_shift_loop_done:
      blt $t0, 0, print_done_list_done
      
      li $t1, 0	# Counter
   
   done_list_loop:
      bge $t1, $t2, next_priority_done
      
      # Load Task Stage
      la $t6, task_stages
      add $t7, $t6, $t1 # Offset = Index
      lb $t3, 0($t7)	#  t3 = stage
      bne $t3, 3, skip_done_task  # skip if wrong stage(to do)
      
      # Load Task Priority
      la $t6, task_priorities
      add $t7, $t6, $t1
      lb $t4, 0($t7)
      bne $t4, $t0, skip_done_task   # skip if wrong priority
      
      #Load Task ID
      la $t6, task_ids
      sll $t7, $t1, 2
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lw $a0, 0($t7)	# Load ID into a0
      li $v0, 1
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Priority
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      li $v0, 1
      move $a0, $t4	# Load priority into a0
      syscall
      
      li $v0, 11	# Print ']' character
      li $a0, 93
      syscall
      
      li $a0, 32	# Print space
      syscall
      
      # Task Title
      la $t6, task_titles
      li $s0, 40		# s0 = 40
      mul $t7, $t1, $s0		# offset = index * 40
      add $t6, $t6, $t7		# address of title
      
      li $t9, 0		# Counter for printed chars
      
      print_done_title_short_loop:
         beq $t9, 20, print_done_title_short_done
      	 lb $a0, 0($t6)
      	 beqz $a0, print_done_title_short_done
      	 beq $a0, 32, check_if_all_space_done
      	 
      	 li $v0, 11
      	 syscall
      	 
      	 addi $t6, $t6, 1
      	 addi $t9, $t9, 1
      	 j print_done_title_short_loop
      	 
      check_if_all_space_done:
         move $t5, $t6
         li $t7, 0
         
      check_if_all_space_done_loop:
         add $t8, $t9, $t7
         beq $t8, 20, print_done_title_short_done
         lb $t8, 0($t5)
         beqz $t8, print_done_title_short_done
      	 bne $t8, 32, not_all_done_space_short
      	 addi $t5, $t5, 1
      	 addi $t7, $t7, 1
      	 j check_if_all_space_done_loop
      	  
      not_all_done_space_short:
         li $v0, 11
         li $a0, 32
         syscall
         
         addi $t6, $t6, 1
         addi $t9, $t9, 1
         j print_done_title_short_loop
         
      print_done_title_short_done:
         li $v0, 11
         li $a0, 32		# space
         syscall
         
         # DEADLINE
   	li $v0, 4                    # Print string syscall
   	la $a0, deadline_prefix      # Load "Due: " prefix
   	syscall

   	li $t6, 6                   # Size of string (deadline length)
   	mul $t7, $t1, $t6            # Calculate offset for task's deadline (based on task index)
   	la $t6, task_deadlines       # Load base address of task_deadlines
   	add $t6, $t6, $t7            # Add offset to get correct address for the current task

   	li $t8, 0                    # Counter for printing chars

   	print_done_deadline_loop:
      	lb $a0, 0($t6)             # Load a byte from the deadline string
      	beqz $a0, print_done_deadline_done  # If null byte (end of string), stop printing
      	li $v0, 11                 # Print character syscall
      	syscall                    # Print the character
      	addi $t6, $t6, 1           # Move to the next character
      	addi $t8, $t8, 1           # Increment counter
      	j print_done_deadline_loop      # Continue the loop

   	print_done_deadline_done:
      	li $v0, 11
      	li $a0, 41		# ')' character
      	syscall
      	
      	li $v0, 11
      	li $a0, 10
      	syscall

   skip_done_task:		# Skip current task
      addi $t1, $t1, 1
      j done_list_loop
   
   next_priority_done:		# Move to lower priority
      addi $t0, $t0, -1
      j priority_shift_loop_done
	  	
   print_done_list_done:
   # Return
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   jr $ra

#----------------------------------------------------
# Validate task ID
# Returns: $v0 = validated task ID (index in arrays)
#----------------------------------------------------
validate_task_id:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # $v0 contains the task ID entered by the user
    move $t0, $v0
    
    # Check if task ID is valid (within range and active)
    lw $t1, task_count
    blt $t0, 0, invalid_id      # If ID < 0, invalid
    bge $t0, $t1, invalid_id    # If ID >= task_count, invalid
    
    # Check if the task is active
    la $t1, task_statuses
    add $t1, $t1, $t0           # Offset to task status
    lb $t2, 0($t1)              # Load status
    bnez $t2, invalid_id        # If status is not 0 (Active), invalid
    
    # Task ID is valid, return it in $v0
    move $v0, $t0
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
invalid_id:
    # Display error message
    li $v0, 4
    la $a0, invalid_task_id
    syscall
    
    # Get task ID again
    la $a0, task_prompt
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    
    # Try to validate again
    j validate_task_id

#----------------------------------------------------------
# Validate Stage Field
#----------------------------------------------------------
validate_task_field:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t3, $v0
    
    # Check if fielf is within range and active
    blt $t3, 0, invalid_field	# if field < 0, invaklid
    bgt $t3, 3, invalid_field	# if field > 3, invalid
    
    # Field valid, return to $v0
    move $v0, $t3
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

invalid_field:
    # Display error message
    li $v0, 4
    la $a0, invalid_task_field
    syscall
    
    # Get stage field again
    la $a0, move_task_where
    syscall
    
    li $v0, 5
    syscall
    
    j validate_task_field
    
view_history:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display "not implemented" message
    li $v0, 4
    la $a0, not_implemented
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

save_board:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display "not implemented" message
    li $v0, 4
    la $a0, not_implemented
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

load_board:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display "not implemented" message
    li $v0, 4
    la $a0, not_implemented
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

#----------------------------------------------------
# Exit program
#----------------------------------------------------
exit_program:
    # Display exit message
    li $v0, 4
    la $a0, exit_message
    syscall
    
    # Exit program
    li $v0, 10
    syscall
