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
menu_option0:    .asciiz "[0] Exit (Autosave)\n"
menu_prompt:     .asciiz "Choose an option: "
invalid_option:  .asciiz "\nInvalid option. Please try again.\n"
exit_message:    .asciiz "\nSaving data... Exiting Kanban Project Progress Tracker. Goodbye!\n"
task_limit_message: .asciiz "\nMaximum task limit reached. Cannot add more tasks.\n"

# Function not implemented message
not_implemented: .asciiz "\nThis feature is not yet implemented.\n"

# Add Task strings
add_task_header:     .asciiz "\n----- ADD NEW TASK -----\n"
title_prompt:        .asciiz "Enter Task Title: "
priority_prompt:     .asciiz "Enter Priority (0=Low, 1=Medium, 2=High): "
deadline_prompt:     .asciiz "Enter Deadline (MM-DD-YYYY): "
priority_invalid:    .asciiz "\nInvalid priority. Please enter 0, 1, or 2.\n"
deadline_format:     .asciiz "\nInvalid date format. Please use MM-DD-YYYY (e.g., 07-21-2025).\n"
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
invalid_task_id:     .asciiz "\nInvalid task number. Please try again.\n"
confirm_delete:      .asciiz "\nAre you sure you want to delete this task? (1=Yes, 0=No): "
task_deleted:        .asciiz "\n? Task \""
task_deleted_mid:    .asciiz "\" has been deleted.\n"
delete_cancelled:    .asciiz "\n? Delete operation cancelled.\n"

# View Board strings
board_header:        .asciiz "\n-----------------------------------------------------\n                   KANBAN BOARD\n-----------------------------------------------------\n"
board_footer:        .asciiz "-----------------------------------------------------\n"
todo_header:         .asciiz "TO DO:    \n"
inprogress_header:   .asciiz "IN PROGRESS:\n"
review_header:       .asciiz "REVIEW:\n"
done_header:         .asciiz "DONE:\n"
empty_stage:         .asciiz " (empty)\n"
no_tasks_board:      .asciiz "\nThere are no tasks on the board.\n"
press_enter:         .asciiz "\nPress Enter to continue..."
priority_high:       .asciiz "[!] "
priority_medium:     .asciiz "[-] "
priority_low:        .asciiz "[ ] "
due_marker:          .asciiz " (Due: "
done_marker:         .asciiz " (Done: "
close_paren:         .asciiz ")"

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

# Buffers for user input
input_buffer:        .space 4
title_buffer:        .space 41   # 40 chars + null terminator
deadline_buffer:     .space 12   # 10 chars (MM-DD-YYYY) + newline + null terminator
continue_buffer:     .space 2    # For "press enter to continue"
task_id_buffer:      .space 12   # Buffer for task ID input

# Task storage
# Maximum 100 tasks, each task structure is:
# - ID (2 bytes)
# - Title (40 bytes)
# - Priority (1 byte)
# - Stage (1 byte)
# - Deadline (10 bytes)
# - Status (1 byte)
# Total: 55 bytes per task

MAX_TASKS:           .word 100
task_count:          .word 0     # Current number of tasks

# Task arrays - organized for proper alignment
# .align 2
task_ids:            .space 400  # 100 * 4 bytes (id stored as word)
# .align 2
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
view_board_updated:	.asciiz "\nView Board Updated! Choose option 1 to view\n"

# CSV Files
save_file:		.asciiz "C:/Documents/ASM/data.csv"
load_file:		.asciiz "C:/Documents/ASM/data.csv"
log_file:		.asciiz "C:/Documents/ASM/log.txt"
csv_header:		.asciiz "ID,TITLE,PRIORITY,STAGE,DEADLINE,STATUS\r\n"
file_saved:		.asciiz "\nData has been saved.\n"
file_loaded:    .asciiz "\nData has been loaded.\n"
file_not_found: .asciiz "\nNo save file found. Starting with empty board.\n"
comma:			.byte 44
converted_int:	.space 12
newline:		.asciiz "\r\n"
buffer: .space 100       # Buffer for reading CSV lines
cr_char:        .byte 13  # Carriage Return character (\r)
lf_char:        .byte 10  # Line Feed character (\n)

# Validation messages
title_invalid_length: .asciiz "\nTitle length should be between 1 - 40.\n"
title_invalid_comma:  .asciiz "\nTitle cannot contain commas as they are used as delimiters.\n"
invalid_input_chars:  .asciiz "\nInvalid characters in input. Please enter a valid number.\n"
task_id_too_long:     .asciiz "\nTask ID is too long. Please enter a valid number.\n"

# Additional buffer for file loading
file_buffer: .space 8192  # 8KB buffer to hold entire file

# Buffer size for loading
FILE_BUFFER_SIZE: .word 8192

.text
.globl main

main:
    # Load board data from file at startup
    jal load_board
    
    # Display welcome message when program first starts
    jal display_menu
    
    # Main program loop
    main_loop:
        # Get user choice
        jal get_user_choice
        
        # Process user choice (stored in $v0)
        beq $v0, 0, exit_program    # Exit (with autosave)
        beq $v0, 1, view_board      # View Board
        beq $v0, 2, add_task        # Add Task
        beq $v0, 3, move_task       # Move Task
        beq $v0, 4, delete_task     # Delete Task
        beq $v0, 5, view_history    # View Task History
        
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
    
get_choice_retry:
    # Display prompt
    li $v0, 4
    la $a0, menu_prompt
    syscall
    
    # Read string instead of integer to handle invalid input
    li $v0, 8
    la $a0, input_buffer
    li $a1, 4
    syscall
    
    # Parse the first character
    la $t0, input_buffer
    lb $t1, 0($t0)
    
    # Check if it's a valid digit (0-5)
    blt $t1, 48, invalid_input    # Less than '0'
    bgt $t1, 53, invalid_input    # Greater than '5'
    
    # Convert ASCII to integer
    addi $v0, $t1, -48
    
    # Check if second character is newline or null (single digit input)
    lb $t2, 1($t0)
    beq $t2, 10, valid_input     # Newline
    beq $t2, 13, valid_input     # Carriage return
    beqz $t2, valid_input        # Null terminator
    
    # If we get here, there are extra characters - invalid input
    j invalid_input
    
valid_input:
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
    j get_choice_retry

#----------------------------------------------------
# Validate task ID with string parsing first
# Returns: $v0 = validated task ID (index in arrays)
#----------------------------------------------------
validate_task_id:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
validate_task_id_retry:
    # Read task ID as string first
    li $v0, 8
    la $a0, task_id_buffer
    li $a1, 12
    syscall
    
    # Parse and validate the string
    jal parse_task_id_string
    # $v0 now contains the parsed integer, or -1 if invalid
    
    # Check if parsing failed
    beq $v0, -1, invalid_task_id_input
    
    # Store the parsed task ID
    move $t0, $v0
    
    # Check if task ID is valid (within range and active)
    lw $t1, task_count
    blt $t0, 0, invalid_task_id_range      # If ID < 0, invalid
    bge $t0, $t1, invalid_task_id_range    # If ID >= task_count, invalid
    
    # Check if the task is active
    la $t1, task_statuses
    add $t1, $t1, $t0           # Offset to task status
    lb $t2, 0($t1)              # Load status
    bnez $t2, invalid_task_id_deleted      # If status is not 0 (Active), invalid
    
    # Task ID is valid, return it in $v0
    move $v0, $t0
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
invalid_task_id_input:
    # Display error message for invalid characters
    li $v0, 4
    la $a0, invalid_input_chars
    syscall
    
    # Get task ID again
    li $v0, 4
    la $a0, task_prompt
    syscall
    j validate_task_id_retry

invalid_task_id_range:
    # Display error message for out of range
    li $v0, 4
    la $a0, invalid_task_id
    syscall
    
    # Get task ID again
    li $v0, 4
    la $a0, task_prompt
    syscall
    j validate_task_id_retry

invalid_task_id_deleted:
    # Display error message for deleted task
    li $v0, 4
    la $a0, invalid_task_id
    syscall
    
    # Get task ID again
    li $v0, 4
    la $a0, task_prompt
    syscall
    j validate_task_id_retry

#----------------------------------------------------
# Parse task ID string and convert to integer
# Input: task_id_buffer contains the string
# Returns: $v0 = parsed integer, or -1 if invalid
#----------------------------------------------------
parse_task_id_string:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, task_id_buffer    # Load buffer address
    li $t1, 0                 # Character counter
    li $t2, 0                 # Accumulated value
    li $t3, 0                 # Non-whitespace character counter
    
    # First pass: check for invalid characters and count length
validate_chars_loop:
    lb $t4, 0($t0)            # Load character
    beqz $t4, check_string_validity    # If null, done checking
    beq $t4, 10, check_string_validity # If newline, done checking
    beq $t4, 13, check_string_validity # If carriage return, done checking
    beq $t4, 32, skip_space   # If space, skip but don't count as invalid
    
    # Check if character is a digit (0-9)
    blt $t4, 48, invalid_char # Less than '0'
    bgt $t4, 57, invalid_char # Greater than '9'
    
    # Valid digit, increment counters
    addi $t1, $t1, 1          # Increment total character counter
    addi $t3, $t3, 1          # Increment non-whitespace counter
    
skip_space:
    addi $t0, $t0, 1          # Move to next character
    j validate_chars_loop
    
invalid_char:
    # Invalid character found
    li $v0, -1
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
check_string_validity:
    # Check if string is empty (no digits)
    beqz $t3, empty_string
    
    # Check if string is too long (more than 10 digits)
    bgt $t3, 10, string_too_long
    
    # String is valid, now convert to integer
    la $t0, task_id_buffer    # Reset buffer address
    li $t2, 0                 # Reset accumulated value
    
convert_to_int_loop:
    lb $t4, 0($t0)            # Load character
    beqz $t4, conversion_done # If null, done
    beq $t4, 10, conversion_done # If newline, done
    beq $t4, 13, conversion_done # If carriage return, done
    beq $t4, 32, skip_convert_space # If space, skip
    
    # Convert digit to integer
    addi $t4, $t4, -48        # Convert ASCII to integer
    
    # Update accumulated value
    mul $t2, $t2, 10          # Multiply current value by 10
    add $t2, $t2, $t4         # Add new digit
    
skip_convert_space:
    addi $t0, $t0, 1          # Move to next character
    j convert_to_int_loop
    
conversion_done:
    # Return the converted integer
    move $v0, $t2
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
empty_string:
    # Empty string
    li $v0, -1
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
string_too_long:
    # String too long
    li $v0, 4
    la $a0, task_id_too_long
    syscall
    
    li $v0, -1
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#----------------------------------------------------
# Menu option handlers (placeholders for now)
#----------------------------------------------------
view_board:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if there are any active tasks
    jal count_active_tasks
    # $v0 now contains the number of active tasks
    
    beqz $v0, no_active_tasks
    
    # Display board header
    li $v0, 4
    la $a0, board_header
    syscall
    
    # Display each stage
    li $a0, 0     # Stage 0: To Do
    jal display_stage_tasks
    
    li $a0, 1     # Stage 1: In Progress
    jal display_stage_tasks
    
    li $a0, 2     # Stage 2: Review
    jal display_stage_tasks
    
    li $a0, 3     # Stage 3: Done
    jal display_stage_tasks
    
    # Display board footer
    li $v0, 4
    la $a0, board_footer
    syscall
    
    # Wait for user to press Enter to continue
    la $a0, press_enter
    syscall
    
    li $v0, 8
    la $a0, continue_buffer
    li $a1, 2
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop
    
no_active_tasks:
    # Display message
    li $v0, 4
    la $a0, no_tasks_board
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

#----------------------------------------------------
# Count active tasks
# Returns: $v0 = number of active tasks
#----------------------------------------------------
count_active_tasks:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Initialize counter
    li $v0, 0     # Active task counter
    li $t0, 0     # Task index
    lw $t1, task_count  # Total number of tasks
    
    # Loop through tasks
    count_active_loop:
        beq $t0, $t1, count_active_done  # If we've processed all tasks, we're done
        
        # Check if the task is active
        la $t2, task_statuses
        add $t2, $t2, $t0       # Offset to task status
        lb $t3, 0($t2)          # Load status
        bnez $t3, skip_count    # If status is not 0 (Active), skip this task
        
        # Task is active, increment counter
        addi $v0, $v0, 1
        
    skip_count:
        addi $t0, $t0, 1        # Move to next task
        j count_active_loop
        
    count_active_done:
        # Return - $v0 already contains the count
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

#----------------------------------------------------
# Display tasks for a specific stage
# Parameters: $a0 = stage (0=To Do, 1=In Progress, 2=Review, 3=Done)
#----------------------------------------------------
display_stage_tasks:
    # Save return address and stage
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
    # Display stage header based on $a0
    beq $a0, 0, display_todo_header
    beq $a0, 1, display_inprogress_header
    beq $a0, 2, display_review_header
    beq $a0, 3, display_done_header
    j stage_header_done         # Should never happen
    
display_todo_header:
    li $v0, 4
    la $a0, todo_header
    syscall
    j stage_header_done
    
display_inprogress_header:
    li $v0, 4
    la $a0, inprogress_header
    syscall
    j stage_header_done
    
display_review_header:
    li $v0, 4
    la $a0, review_header
    syscall
    j stage_header_done
    
display_done_header:
    li $v0, 4
    la $a0, done_header
    syscall
    
stage_header_done:
    # Restore stage to $a0
    lw $a0, 4($sp)
    
    # Count tasks in this stage
    jal count_tasks_in_stage
    # $v0 now contains the number of tasks in the stage
    
    beqz $v0, stage_empty
    
    # There are tasks in this stage, display them
    # Initialize variables
    li $t0, 0                   # Task index
    lw $t1, task_count          # Total number of tasks
    li $t9, 1                   # Task number counter (for display)
    
    # Loop through tasks
    stage_tasks_loop:
        beq $t0, $t1, stage_tasks_done  # If we've processed all tasks, we're done
        
        # Check if the task is active and in the current stage
        la $t2, task_statuses
        add $t2, $t2, $t0       # Offset to task status
        lb $t3, 0($t2)          # Load status
        bnez $t3, skip_stage_task  # If status is not 0 (Active), skip this task
        
        la $t2, task_stages
        add $t2, $t2, $t0       # Offset to task stage
        lb $t3, 0($t2)          # Load stage
        lw $t4, 4($sp)          # Load stage parameter
        bne $t3, $t4, skip_stage_task  # If not in current stage, skip this task
        
        # Task is active and in the current stage, display it
        # Print task number
        li $v0, 11              # Print character syscall
        li $a0, 32              # Space character
        syscall
        li $a0, 91              # '[' character
        syscall
        
        li $v0, 1               # Print integer syscall
        move $a0, $t9           # Task number for display
        syscall
        
        li $v0, 11              # Print character syscall
        li $a0, 93              # ']' character
        syscall
        li $a0, 32              # Space character
        syscall
        
        # Print priority indicator
        la $t2, task_priorities
        add $t2, $t2, $t0       # Offset to task priority
        lb $t3, 0($t2)          # Load priority
        
        li $v0, 4               # Print string syscall
        beq $t3, 0, print_low_priority
        beq $t3, 1, print_medium_priority
        beq $t3, 2, print_high_priority
        j priority_printed      # Should never happen
        
    print_low_priority:
        la $a0, priority_low
        syscall
        j priority_printed
        
    print_medium_priority:
        la $a0, priority_medium
        syscall
        j priority_printed
        
    print_high_priority:
        la $a0, priority_high
        syscall
        
    priority_printed:
        # Print task title
        la $t2, task_titles
        li $t3, 40              # Each title is 40 bytes
        mul $t4, $t0, $t3       # Calculate offset
        add $t2, $t2, $t4       # Address of title
        
        # Find the length of the title (exclude trailing spaces)
        move $t3, $t2           # Copy address to $t3
        li $t4, 0               # Counter
        li $t5, 39              # Maximum title length - 1
        
    find_title_end:
        beq $t4, $t5, title_end_found  # If we've checked all chars, we're done
        add $t6, $t3, $t5       # Address of last character
        lb $t7, 0($t6)          # Load character
        bne $t7, 32, title_end_found  # If not space, we've found the end
        addi $t5, $t5, -1       # Move backward
        j find_title_end
        
    title_end_found:
        # Now $t5 contains the index of the last non-space character
        # Print the title (up to the length we calculated)
        li $t4, 0               # Counter
        
    print_title_loop:
        bgt $t4, $t5, title_printed  # If we've printed all chars, we're done
        lb $a0, 0($t2)          # Load character
        li $v0, 11              # Print character syscall
        syscall
        addi $t2, $t2, 1        # Move to next character
        addi $t4, $t4, 1        # Increment counter
        j print_title_loop
        
    title_printed:
        # Print deadline
        lw $t4, 4($sp)          # Load stage parameter
        beq $t4, 3, print_done_date  # If stage is Done, print Done instead of Due
        
        li $v0, 4               # Print string syscall
        la $a0, due_marker
        syscall
        j print_date
        
    print_done_date:
        li $v0, 4               # Print string syscall
        la $a0, done_marker
        syscall
        
    print_date:
        # Print deadline date (MM-DD-YYYY format)
        la $t2, task_deadlines
        li $t3, 10              # Each deadline is 10 bytes
        mul $t4, $t0, $t3       # Calculate offset
        add $t2, $t2, $t4       # Address of deadline
        
        # Print the full date (MM-DD-YYYY)
        li $t3, 0               # Character counter
        
    print_deadline_char_loop:
        beq $t3, 10, print_deadline_done  # If we've printed 10 chars, done
        lb $a0, 0($t2)          # Load character
        beqz $a0, print_deadline_done     # If null, done
        li $v0, 11              # Print character syscall
        syscall
        addi $t2, $t2, 1        # Next character
        addi $t3, $t3, 1        # Increment counter
        j print_deadline_char_loop
        
    print_deadline_done:
        # Print closing parenthesis
        li $v0, 4               # Print string syscall
        la $a0, close_paren
        syscall
        
        # Print newline
        li $v0, 4
        la $a0, newline
        syscall
        
        # Increment task number counter
        addi $t9, $t9, 1
        
    skip_stage_task:
        addi $t0, $t0, 1        # Move to next task
        j stage_tasks_loop
        
    stage_tasks_done:
        # Return
        lw $ra, 0($sp)
        addi $sp, $sp, 8
        jr $ra
        
    stage_empty:
        # Print empty stage message
        li $v0, 4
        la $a0, empty_stage
        syscall
        
        # Return
        lw $ra, 0($sp)
        addi $sp, $sp, 8
        jr $ra

#----------------------------------------------------
# Count tasks in a specific stage
# Parameters: $a0 = stage (0=To Do, 1=In Progress, 2=Review, 3=Done)
# Returns: $v0 = number of active tasks in the stage
#----------------------------------------------------
count_tasks_in_stage:
    # Save return address
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)         # Save stage parameter
    
    # Initialize counter
    li $v0, 0              # Tasks in stage counter
    li $t0, 0              # Task index
    lw $t1, task_count     # Total number of tasks
    
    # Loop through tasks
    count_stage_loop:
        beq $t0, $t1, count_stage_done  # If we've processed all tasks, we're done
        
        # Check if the task is active and in the current stage
        la $t2, task_statuses
        add $t2, $t2, $t0       # Offset to task status
        lb $t3, 0($t2)          # Load status
        bnez $t3, skip_stage_count  # If status is not 0 (Active), skip this task
        
        la $t2, task_stages
        add $t2, $t2, $t0       # Offset to task stage
        lb $t3, 0($t2)          # Load stage
        lw $t4, 4($sp)          # Load stage parameter
        bne $t3, $t4, skip_stage_count  # If not in current stage, skip this task
        
        # Task is active and in the current stage, increment counter
        addi $v0, $v0, 1
        
    skip_stage_count:
        addi $t0, $t0, 1        # Move to next task
        j count_stage_loop
        
    count_stage_done:
        # Return - $v0 already contains the count
        lw $ra, 0($sp)
        addi $sp, $sp, 8
        jr $ra

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
    
    li $v0, 4
    la $a0, view_board_updated	# Display update
    syscall
    
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
    
get_title_retry:
    # Display prompt
    li $v0, 4
    la $a0, title_prompt
    syscall
    
    # Read string (title)
    li $v0, 8
    la $a0, title_buffer
    li $a1, 41       # 40 chars + null terminator
    syscall
    
    # Validate title (check length and no commas)
    la $t0, title_buffer      # Load address of buffer
    li $t1, 0                 # Character counter
    li $t3, 0                 # Non-whitespace character counter
    
title_validation_loop:
    lb $t2, 0($t0)            # Load byte from buffer
    beqz $t2, check_title_length    # If null, validation is done
    beq $t2, 10, check_title_length # If newline, validation is done
    beq $t2, 13, check_title_length # If carriage return, validation is done
    beq $t2, 44, title_has_comma    # If comma (ASCII 44), title is invalid
    
    # Check if character is not a space
    bne $t2, 32, increment_non_whitespace  # If not space (ASCII 32), increment non-whitespace counter
    j continue_validation
    
increment_non_whitespace:
    addi $t3, $t3, 1          # Increment non-whitespace counter
    
continue_validation:
    addi $t1, $t1, 1          # Increment character counter
    addi $t0, $t0, 1          # Move to next character
    j title_validation_loop
    
check_title_length:
    # Check if the title is empty (no non-whitespace characters)
    beqz $t3, title_empty
    
    # Check if the title is too long (> 40 chars)
    bgt $t1, 40, title_too_long
    
    # Title is valid, remove newline if present
    la $t0, title_buffer      # Load address of buffer
    
# Replace newline with null terminator
remove_newline_loop:
    lb $t1, 0($t0)            # Load byte from buffer
    beqz $t1, newline_done    # If null, we're done
    beq $t1, 10, remove_cr    # If LF, check for CR
    beq $t1, 13, remove_cr    # If CR, check for LF
    addi $t0, $t0, 1          # Move to next character
    j remove_newline_loop
    
remove_cr:
    sb $zero, 0($t0)          # Replace with null
    j newline_done
    
newline_done:
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

title_empty:
    # Display error message for empty title
    li $v0, 4
    la $a0, title_invalid_length  # Reuse existing message or create new one
    syscall
    j get_title_retry         # Ask for the title again

title_has_comma:
    # Display error message for comma
    li $v0, 4
    la $a0, title_invalid_comma
    syscall
    j get_title_retry         # Ask for the title again

title_too_long:
    # Display error message for too long
    li $v0, 4
    la $a0, title_invalid_length
    syscall
    j get_title_retry         # Ask for the title again

#----------------------------------------------------
# Get task priority from user (0=Low, 1=Medium, 2=High)
# Returns: $v0 = priority value
#----------------------------------------------------
get_task_priority:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
get_priority_retry:
    # Display prompt
    li $v0, 4
    la $a0, priority_prompt
    syscall
    
    # Read string instead of integer to handle invalid input
    li $v0, 8
    la $a0, input_buffer
    li $a1, 4
    syscall
    
    # Parse the first character
    la $t0, input_buffer
    lb $t1, 0($t0)
    
    # Check if it's a valid digit (0-2)
    blt $t1, 48, invalid_priority    # Less than '0'
    bgt $t1, 50, invalid_priority    # Greater than '2'
    
    # Convert ASCII to integer
    addi $v0, $t1, -48
    
    # Check if second character is newline or null (single digit input)
    lb $t2, 1($t0)
    beq $t2, 10, priority_valid     # Newline
    beq $t2, 13, priority_valid     # Carriage return
    beqz $t2, priority_valid        # Null terminator
    
    # If we get here, there are extra characters - invalid input
    j invalid_priority
    
priority_valid:
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
# Get task deadline from user (MM-DD-YYYY format)
#----------------------------------------------------
get_task_deadline:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
get_deadline_retry:
    # Display prompt
    li $v0, 4
    la $a0, deadline_prompt
    syscall
    
    # Read string (deadline)
    li $v0, 8
    la $a0, deadline_buffer
    li $a1, 12        # 10 chars (MM-DD-YYYY) + 1 newline + null terminator
    syscall
    
    # Validate deadline format (MM-DD-YYYY)
    la $t0, deadline_buffer   # Load address of buffer
    
    # Check length first
    li $t1, 0                 # Character counter
deadline_length_loop:
    lb $t2, 0($t0)            # Load byte from buffer
    beqz $t2, check_deadline_length    # If null, validation is done
    beq $t2, 10, check_deadline_length # If newline, validation is done
    beq $t2, 13, check_deadline_length # If carriage return, validation is done
    
    addi $t1, $t1, 1          # Increment counter
    addi $t0, $t0, 1          # Move to next character
    j deadline_length_loop
    
check_deadline_length:
    # Length should be exactly 10 (MM-DD-YYYY)
    bne $t1, 10, deadline_invalid_format
    
    # Check format: MM-DD-YYYY
    la $t0, deadline_buffer
    
    # Check if position 0-1 are digits (MM)
    lb $t2, 0($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    lb $t2, 1($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    # Check if position 2 is a hyphen
    lb $t2, 2($t0)
    bne $t2, 45, deadline_invalid_format  # Not a hyphen '-'
    
    # Check if positions 3-4 are digits (DD)
    lb $t2, 3($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    lb $t2, 4($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    # Check if position 5 is a hyphen
    lb $t2, 5($t0)
    bne $t2, 45, deadline_invalid_format  # Not a hyphen '-'
    
    # Check if positions 6-9 are digits (YYYY)
    lb $t2, 6($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    lb $t2, 7($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    lb $t2, 8($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    lb $t2, 9($t0)
    blt $t2, 48, deadline_invalid_format  # Less than '0'
    bgt $t2, 57, deadline_invalid_format  # Greater than '9'
    
    # Format is valid, remove newline if present
    la $t0, deadline_buffer
    
deadline_remove_newline_loop:
    lb $t1, 0($t0)            # Load byte from buffer
    beqz $t1, deadline_newline_done  # If null, we're done
    beq $t1, 10, deadline_remove_cr   # If LF, check for CR
    beq $t1, 13, deadline_remove_cr   # If CR, check for LF
    addi $t0, $t0, 1          # Move to next character
    j deadline_remove_newline_loop
    
deadline_remove_cr:
    sb $zero, 0($t0)          # Replace with null
    j deadline_newline_done
    
deadline_newline_done:
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

deadline_invalid_format:
    # Display error message
    li $v0, 4
    la $a0, deadline_format
    syscall
    
    # Try again
    j get_deadline_retry

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
    sll $t2, $t0, 2           # Multiply by 4 (word size)
    add $t1, $t1, $t2         # Offset into array
    sw $t0, 0($t1)            # Store ID as word
    
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
    # Display error message for maximum tasks reached
    li $v0, 4
    la $a0, task_limit_message
    syscall
    
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
    
    # Validate task ID (now handles string input internally)
    jal validate_task_id
    # If invalid, validate_task_id will loop back to get input
    # If valid, $v0 contains the index of the task in our arrays
    
    # Store task index in $t0
    move $t0, $v0
    
    # Get user confirmation with validation
    confirm_move_retry:
        # Display confirmation prompt
        li $v0, 4
        la $a0, confirm_move
        syscall
        
        # Read string instead of integer to handle invalid input
        li $v0, 8
        la $a0, input_buffer
        li $a1, 4
        syscall
        
        # Parse the first character
        la $t2, input_buffer
        lb $t3, 0($t2)
        
        # Check if it's a valid digit (0 or 1)
        blt $t3, 48, invalid_confirm_input    # Less than '0'
        bgt $t3, 49, invalid_confirm_input    # Greater than '1'
        
        # Convert ASCII to integer
        addi $t3, $t3, -48
        
        # Check if second character is newline or null (single digit input)
        lb $t4, 1($t2)
        beq $t4, 10, confirm_valid     # Newline
        beq $t4, 13, confirm_valid     # Carriage return
        beqz $t4, confirm_valid        # Null terminator
        
        # If we get here, there are extra characters - invalid input
        j invalid_confirm_input
        
    confirm_valid:
        # Confirmation is valid, check value
        move $v0, $t3
        
        # If confirmation is not 1, cancel move
        bne $v0, 1, cancel_move
        j confirmation_done
        
    invalid_confirm_input:
        # Display error message for invalid characters
        li $v0, 4
        la $a0, invalid_input_chars
        syscall
        
        # Try again
        j confirm_move_retry
        
    confirmation_done:
    
    # Get user choice, which field to move
    li $v0, 4
    la $a0, move_task_where
    syscall
    
    # Get integer
    li $v0, 5
    syscall
    # $v0 contains which task field to be moved to
    
    # $t1 contains which stage field to move to
    move $t1, $v0
    
    # Moving proper
    la $t2, task_stages
    
    # Calculate offset - task stages are stored as bytes, not 57-byte structures
    add $t4, $t2, $t0      # Simple byte offset: base address + task index
    
    sb $t1, 0($t4)         # Store new stage value
   
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
    
    # Validate task ID (now handles string input internally)
    jal validate_task_id
    # If invalid, validate_task_id will loop back to get input
    # If valid, $v0 contains the index of the task in our arrays
    
    # Store task index in $t0
    move $t0, $v0
    
    # Get user confirmation with validation
    confirm_delete_retry:
        # Display confirmation prompt
        li $v0, 4
        la $a0, confirm_delete
        syscall
        
        # Read string instead of integer to handle invalid input
        li $v0, 8
        la $a0, input_buffer
        li $a1, 4
        syscall
        
        # Parse the first character
        la $t2, input_buffer
        lb $t3, 0($t2)
        
        # Check if it's a valid digit (0 or 1)
        blt $t3, 48, invalid_confirm_delete_input    # Less than '0'
        bgt $t3, 49, invalid_confirm_delete_input    # Greater than '1'
        
        # Convert ASCII to integer
        addi $t3, $t3, -48
        
        # Check if second character is newline or null (single digit input)
        lb $t4, 1($t2)
        beq $t4, 10, confirm_delete_valid     # Newline
        beq $t4, 13, confirm_delete_valid     # Carriage return
        beqz $t4, confirm_delete_valid        # Null terminator
        
        # If we get here, there are extra characters - invalid input
        j invalid_confirm_delete_input
        
    confirm_delete_valid:
        # Confirmation is valid, check value
        move $v0, $t3
        
        # If confirmation is not 1, cancel deletion
        bne $v0, 1, cancel_delete
        j confirmation_delete_done
        
    invalid_confirm_delete_input:
        # Display error message for invalid characters
        li $v0, 4
        la $a0, invalid_input_chars
        syscall
        
        # Try again
        j confirm_delete_retry
        
    confirmation_delete_done:
    
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
    
delete_task_print_title_loop :
    beqz $a1, print_title_done  # If length is 0, we're done
    lb $a0, 0($t1)              # Load character
    syscall                     # Print character
    addi $t1, $t1, 1            # Move to next character
    addi $a1, $a1, -1           # Decrement counter
    j delete_task_print_title_loop 
    
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
            li $v0, 4
            la $a0, newline
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
   
   priority_shift_loop_to_do:
      blt $t0, -1, print_to_do_list_done
      
      li $t1, 0	# Counter
      lw $t2, task_count	# Total number of tasks
   to_do_list_loop:
      bge $t1, $t2, next_priority_to_do
      li $t3, 0
      # Load Task Stage
      la $t6, task_stages
      add $t7, $t6, $t1 # Offset = Index
      lb $t3, 0($t7)	#  t3 = stage
 
      bne $t3, 0, skip_to_do_task  # skip if wrong stage
      
      # Load Task Priority
      la $t6, task_priorities
      add $t7, $t6, $t1
      lb $t4, 0($t7)
      bne $t4, $t0, skip_to_do_task   # skip if wrong priority
      #Load Task ID
      la $t6, task_ids
      sll $t7, $t1, 2           # Multiply by 4 (word size)
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lw $a0, 0($t7)	# Load ID into a0
      lh $a0, 0($t7)	# Load ID into a0
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
   	la $a0, deadline_prefix      # Load 'Due: ' prefix
   	syscall

   	li $t6, 10                   # Size of byte (deadline length)
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
      	li $v0, 4
      	la $a0, newline
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
      li $t3, 0
      # Load Task Stage
      la $t6, task_stages
      add $t7, $t6, $t1 # Offset = Index
      lb $t3, 0($t7)	#  t3 = stage
      bne $t3, 1, skip_in_progress_task  # skip if wrong stage
      
      # Load Task Priority
      la $t6, task_priorities
      add $t7, $t6, $t1
      lb $t4, 0($t7)
      bne $t4, $t0, skip_in_progress_task   # skip if wrong priority
      
      #Load Task ID
      la $t6, task_ids
      sll $t7, $t1, 2           # Multiply by 4 (word size)
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lh $a0, 0($t7)	# Load ID into a0
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
   	la $a0, deadline_prefix      # Load 'Due: ' prefix
   	syscall

   	li $t6, 10                   # Size of byte (deadline length)
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
      	li $v0, 4
      	la $a0, newline
      	syscall

   skip_in_progress_task:		# Skip current task
      addi $t1, $t1, 1
      j in_progress_list_loop
   
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
      li $t3, 0
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
      
      # Load Task ID
      la $t6, task_ids
      sll $t7, $t1, 2           # Multiply by 4 (word size)
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lh $a0, 0($t7)	# Load ID into a0
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
   	la $a0, deadline_prefix      # Load 'Due: ' prefix
   	syscall

   	li $t6, 10                   # Size of byte (deadline length)
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
      	li $v0, 4
      	la $a0, newline
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
      li $t3, 0
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
      sll $t7, $t1, 2           # Multiply by 4 (word size)
      add  $t7, $t6, $t7
      
      # Printing proper
      # ID
      li $v0, 11	# Print '[' character
      li $a0, 91
      syscall
      
      lh $a0, 0($t7)	# Load ID into a0
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
   	la $a0, deadline_prefix      # Load 'Due: ' prefix
   	syscall

   	li $t6, 10                   # Size of byte (deadline length)
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
      	li $v0, 4
      	la $a0, newline
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

# Save board function
save_board:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 13        # Open a file
    la $a0, save_file    # Address of the file name
    li $a1, 1        # Write-only mode
    li $a2,  0
    syscall

    move $t0, $v0    # store fd to $t0
    move $a0, $t0    # store fd to $a0
    la $a1, csv_header    # Address of header
    li $a2, 40        # Header length
    li $v0, 15
    syscall

    li $t1, 0        # Counter
    lw $t2, task_count    # No. of tasks

save_task_loop:
    bge $t1, $t2, save_task_done  # If counter >= task_count, we're done
    
    # ID - handle single or double digit IDs
    la $t3, task_ids
    sll $t5, $t1, 2   # Multiply by 4 (word size)
    add $t5, $t3, $t5
    lw $a0, 0($t5)    # $a0 = Task ID
    jal int_to_str

    # Check if ID is single digit (0-9) or double digit (10+)
    move $a1, $a0    # $a1 contains converted int string
    move $a0, $t0    # $a0 contains file descriptor
    
    # Load the second character to check if it's null
    la $t6, converted_int
    lb $t7, 1($t6)    # Load second byte
    
    # If second byte is null, it's a single digit ID
    beqz $t7, write_single_digit_id
    
    # Otherwise, it's a two digit ID
    li $a2, 2        # Write 2 chars
    j write_id
    
write_single_digit_id:
    li $a2, 1        # Write only 1 char
    
write_id:
    li $v0, 15
    syscall

    la $a1, comma    # Write comma
    li $a2, 1
    li $v0, 15
    syscall

    # TITLE - no fixed length, write actual content
    la $t3, task_titles
    mul $t4, $t1, 40
    add $t5, $t3, $t4
    
    # Determine actual length of title (exclude null and trailing spaces)
    move $t6, $t5    # Copy start address
    li $t7, 0        # Counter for title length
    li $t8, 40       # Maximum title length

save_title_length_count_loop:
    beq $t7, $t8, save_title_length_done    # If reached max length, done
    lb $t9, 0($t6)                     # Load byte
    beqz $t9, save_title_length_done        # If null, done
    addi $t6, $t6, 1                   # Move to next byte
    addi $t7, $t7, 1                   # Increment counter
    j save_title_length_count_loop

save_title_length_done:
    # Find end of title without trailing spaces
    addi $t6, $t6, -1                  # Move back to last character
    addi $t7, $t7, -1                  # Adjust length
    
    # Trim trailing spaces
save_trim_spaces_loop:
    bltz $t7, save_title_empty         # If length < 0, title was all spaces
    lb $t9, 0($t6)                     # Load last byte
    bne $t9, 32, save_trimming_done    # If not space, done trimming
    addi $t6, $t6, -1                  # Move backward
    addi $t7, $t7, -1                  # Reduce length
    j save_trim_spaces_loop

save_title_empty:
    li $t7, 0                          # Set length to 0

save_trimming_done:
    addi $t7, $t7, 1                   # Adjust length (add 1 since we subtracted earlier)
    
    # Write title with actual length
    move $a0, $t0                      # File descriptor
    move $a1, $t5                      # Title address
    move $a2, $t7                      # Actual length
    li $v0, 15
    syscall
    
    move $a0, $t0
    la $a1, comma
    li $a2, 1
    li $v0, 15
    syscall

    # PRIORITY - should be 1 character
    la $t3, task_priorities
    add $t5, $t3, $t1
    lb $a0, 0($t5)
    jal int_to_str
    
    move $a1, $a0    # $a1 contains converted int
    move $a0, $t0    # $a0 contains fd
    li $a2, 1        # Write exactly 1 character
    li $v0, 15
    syscall

    move $a0, $t0
    la $a1, comma
    li $a2, 1
    li $v0, 15
    syscall

    # STAGE - should be 1 character
    la $t3, task_stages
    add $t5, $t3, $t1
    lb $a0, 0($t5)
    jal int_to_str
    
    move $a1, $a0    # $a1 contains converted int
    move $a0, $t0    # $a0 contains fd
    li $a2, 1        # Write exactly 1 character
    li $v0, 15
    syscall

    move $a0, $t0
    la $a1, comma
    li $a2, 1
    li $v0, 15
    syscall

    # DEADLINE - should be 10 characters
    la $t3, task_deadlines
    mul $t4, $t1, 10
    add $t5, $t3, $t4
    
    # Check if deadline is null-terminated before 10 chars
    move $t6, $t5    # Copy address
    li $t7, 0        # Counter
    li $t8, 10       # Maximum deadline length
    
save_deadline_length_loop:
    beq $t7, $t8, save_deadline_full_length   # If at max length, it's full length
    lb $t9, 0($t6)                            # Load byte
    beqz $t9, save_deadline_needs_padding     # If null byte found, need padding
    addi $t6, $t6, 1                          # Move to next byte
    addi $t7, $t7, 1                          # Increment counter
    j save_deadline_length_loop

save_deadline_needs_padding:
    # Write the actual deadline content first
    move $a0, $t0                         # File descriptor
    move $a1, $t5                         # Deadline address
    move $a2, $t7                         # Actual length
    li $v0, 15
    syscall
    
    # Calculate how many characters to pad
    sub $t8, $t8, $t7                     # Padding needed = 10 - actual length
    
    # Pad with spaces
    la $t9, buffer                         # Use buffer for padding
save_deadline_padding_loop:
    beqz $t8, save_deadline_padding_done   # If no more padding needed, done
    li $t7, 32                             # ASCII space
    sb $t7, 0($t9)                         # Store space in buffer
    addi $t9, $t9, 1                       # Next position
    addi $t8, $t8, -1                      # Decrement padding counter
    j save_deadline_padding_loop
    
save_deadline_padding_done:
    # Write the padding
    move $a0, $t0                          # File descriptor
    la $a1, buffer                          # Buffer with spaces
    li $t9, 10                             # Load constant 10
    sub $t8, $t9, $t7                      # Calculate padding length (10 - actual length)
    move $a2, $t8                          # Padding length
    li $v0, 15
    syscall
    j save_deadline_write_done

save_deadline_full_length:
    # Deadline is already 10 chars, write it directly
    move $a0, $t0                          # File descriptor
    move $a1, $t5                          # Deadline address
    li $a2, 10                             # Always 10 characters
    li $v0, 15
    syscall

save_deadline_write_done:
    move $a0, $t0
    la $a1, comma
    li $a2, 1
    li $v0, 15
    syscall

    # STATUS - should be 1 character
    la $t3, task_statuses
    add $t5, $t3, $t1
    lb $a0, 0($t5)
    jal int_to_str
    
    move $a1, $a0    # $a1 contains converted int
    move $a0, $t0    # $a0 contains fd
    li $a2, 1        # Write exactly 1 character
    li $v0, 15
    syscall

    la $a1, newline    # Write newline
    li $a2, 2
    li $v0, 15
    syscall
    
    addi $t1, $t1, 1    # Increment task counter
    j save_task_loop

save_task_done:
    li $v0, 16        # Close file
    move $a0, $t0    
    syscall
    
    li $v0, 4        # Data has been saved notif
    la $a0, file_saved
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

int_to_str:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
     
    la $t6, converted_int	# Load address of buffer
    li $t7, 12			# Size of bytes
    
    # Clear converted_int buffer
clear_loop:
    sb $zero, 0($t6)		# Store null byte in the buffer
    addi $t6, $t6, 1		# Buffer pointer to next position
    addi $t7, $t7, -1		# Decrease count
    bnez $t7, clear_loop	# Continue clearing if counter is not zero
    
    li $t6, 10			# Base 10
    la $t7, converted_int		# POINTER
    move $t8, $a0			# TEMP
    li $t9, 0				# STRLEN
    beqz $t8, int_zero_case	# If number is 0, jump to label
    
    # Conversion proper
    convert:	
       divu $t8, $t6		# Divide by 10
       mflo $t8			# Quotient
       mfhi $s0			# Remainder
       
       addi $s0, $s0, 48	# Convert digit into its ASCII counterpart
       sb $s0, 0($t7)		# Store char in the buffer
       addi $t7, $t7, 1		# Buffer pointer to next position
       addi $t9, $t9, 1		# Increment strlen counter
       bnez $t8, convert	# if quotient not zero, loop
       j reverse
       
    int_zero_case:
       li $s0, 48
       sb $s0, 0($t7)
       addi $t7, $t7, 1 
       li $t9, 1
       
    # Reverse string to correct order  
    reverse:
       sb $zero, 0($t7)		# Store null terminator at the end
       la $s0, converted_int	# $s0 points to start of string
       move $s1, $s0		# $s0=$s1
       add $s2, $s0, $t9	# $s2 points to end of string
       addi $s2 $s2, -1		# move $s2 backwards
    
    # Swapping loop 
    rev_loop:
       bge $s1, $s2, int_to_str_done	# If $s1 >= $s2, done
       
       lb $t6, 0($s1)	# lb from start of string
       lb $t7, 0($s2)	# lb from end of string
       
       sb $t7, 0($s1)	# sb from $t7 to start
       sb $t6, 0($s2)	# sb from $t6 to end
       
       addi $s1, $s1, 1   # Increment start pointer
       addi $s2, $s2, -1  # Decrement end pointer
       j rev_loop
       
    int_to_str_done:
    la $a0, converted_int
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
load_board:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Try to open the file
    li $v0, 13            # Open file syscall
    la $a0, load_file     # File path
    li $a1, 0             # Read-only mode (0)
    li $a2, 0             # No special permissions
    syscall
    
    # Check if file was opened successfully
    bltz $v0, file_not_found_error
    
    # File opened successfully
    move $t0, $v0         # Save file descriptor
    
    # Reset task_count to 0
    li $t1, 0
    sw $t1, task_count
    
    # Read the entire file at once
    move $a0, $t0         # File descriptor
    la $a1, file_buffer   # File buffer
    lw $a2, FILE_BUFFER_SIZE # Buffer size (8KB)
    li $v0, 14            # Read file syscall
    syscall
    
    # $v0 now contains number of bytes read
    move $s0, $v0         # Save bytes read for bounds checking
    
    # Initialize cursor to start of buffer
    la $s1, file_buffer   # $s1 is our cursor pointer
    
    # Skip the header line (find first newline)
    move $t1, $s1         # Start of buffer
skip_header_loop:
    lb $t2, 0($t1)        # Load byte at cursor
    beq $t2, 10, header_skipped    # If LF, we've found the end of the header
    beq $t2, 13, check_crlf_header # Check if CR+LF
    addi $t1, $t1, 1      # Move cursor forward
    sub $t3, $t1, $s1     # Calculate position
    bge $t3, $s0, read_tasks_done  # If beyond bytes read (header is not complete), we're done
    j skip_header_loop

check_crlf_header:
    # Check if next byte is LF
    addi $t3, $t1, 1      # Next byte
    lb $t4, 0($t3)        # Load the byte
    beq $t4, 10, header_crlf   # If LF, it's CRLF
    # Otherwise just CR
    addi $t1, $t1, 1      # Skip CR
    j header_skipped

header_crlf:
    addi $t1, $t1, 2      # Skip CR+LF
    j header_skipped
    
header_skipped:
    # Position cursor after header
    addi $t1, $t1, 1      # Move past LF or CR
    move $s1, $t1         # Update cursor to start of first data row
    
    # Set row counter for debug output
    li $s7, 1             # Row counter (starts at 1, after header)
    
    # Start parsing rows
parse_rows_loop:
    # Check if we've reached the end of the buffer
    la $t4, file_buffer     # Get the start address of buffer
    sub $t3, $s1, $t4       # Calculate offset: current_position - buffer_start
    bge $t3, $s0, read_tasks_done  # If offset >= bytes_read, we're done
    
    # Check if line is empty (just CRLF or LF)
    lb $t2, 0($s1)
    beq $t2, 10, skip_empty_line  # LF - empty line
    beq $t2, 13, check_empty_crlf # CR - might be CRLF
    beqz $t2, read_tasks_done     # If null terminator, we're done
    
    # Parse the line at cursor position
    # Parse function will update $s1 to next line
    move $a0, $s1          # Pass cursor position as argument
    jal parse_csv_line
    
    # Increment row counter for debug output
    addi $s7, $s7, 1
    
    # Continue parsing
    j parse_rows_loop

check_empty_crlf:
    # Check if line is just CRLF
    addi $t4, $s1, 1      # Next byte
    lb $t5, 0($t4)        # Load byte
    beq $t5, 10, skip_empty_crlf # CRLF - empty line
    # Not empty line, continue parsing
    move $a0, $s1          # Pass cursor position as argument
    jal parse_csv_line
    # Increment row counter for debug output
    addi $s7, $s7, 1
    j parse_rows_loop
    
skip_empty_line:
    # Skip empty line with LF
    addi $s1, $s1, 1      # Move past LF
    j parse_rows_loop
    
skip_empty_crlf:
    # Skip empty line with CRLF
    addi $s1, $s1, 2      # Move past CRLF
    j parse_rows_loop
    
read_tasks_done:
    # Close the file
    li $v0, 16            # Close file syscall
    move $a0, $t0         # File descriptor
    syscall
    
    # Report success
    li $v0, 4
    la $a0, file_loaded
    syscall
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
file_not_found_error:
    # Display error message
    li $v0, 4
    la $a0, file_not_found
    syscall
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Parse a CSV line starting at the position in $a0
# Updates $s1 to point to the next line
parse_csv_line:
    # Save registers (NOTE: Don't save $s1 since we need to update it)
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    
    # $a0 contains the cursor position (start of the line)
    move $t2, $a0          # Current pointer to start of line
    
    # Get task_count for array indexing
    lw $t1, task_count
    
    # Parse the ID field (field 1)
    # Calculate address for task_ids[task_count]
    la $t3, task_ids       # Load base address of task_ids
    sll $t4, $t1, 2        # Multiply by 4 (word size)
    add $t3, $t3, $t4      # Address of task_ids[task_count]
    
    # Initialize temp variables
    li $t5, 0              # Accumulated ID value
    
parse_id_loop:
    lb $t4, 0($t2)         # Load byte from cursor
    beq $t4, 44, id_done   # If comma, we're done
    beq $t4, 10, id_done   # If LF, we're done (end of line)
    beq $t4, 13, id_done   # If CR, we're done (end of line, possible CRLF)
    beqz $t4, id_done      # If null, we're done (end of buffer)
    
    # Convert ASCII digit to integer (ASCII - 48)
    addi $t4, $t4, -48     # Convert '0'-'9' to 0-9
    
    # Check if digit is valid (0-9)
    bltz $t4, parse_id_error
    bgt $t4, 9, parse_id_error
    
    # Update accumulated value
    mul $t5, $t5, 10       # Current value * 10
    add $t5, $t5, $t4      # Add new digit
    
    # Move to next character
    addi $t2, $t2, 1
    j parse_id_loop

# Accumulation processed
# Initial state:
# $t5 = 0 (accumulated value)
# $t2 points to '1'

# # Iteration 1: Processing '1'
# lb $t4, 0($t2)         # $t4 = '1' (ASCII 49)
# addi $t4, $t4, -48     # $t4 = 49 - 48 = 1
# mul $t5, $t5, 10       # $t5 = 0 * 10 = 0
# add $t5, $t5, $t4      # $t5 = 0 + 1 = 1

# # Iteration 2: Processing '2'
# lb $t4, 0($t2)         # $t4 = '2' (ASCII 50)
# addi $t4, $t4, -48     # $t4 = 50 - 48 = 2
# mul $t5, $t5, 10       # $t5 = 1 * 10 = 10
# add $t5, $t5, $t4      # $t5 = 10 + 2 = 12
    
parse_id_error:
    # Handle invalid digit
    li $v0, 4
    
id_done:
    # Store ID in task_ids array
    sh $t5, 0($t3)
    
    # Skip comma if present
    lb $t4, 0($t2)
    beq $t4, 44, skip_id_comma
    j title_field_start
    
skip_id_comma:
    addi $t2, $t2, 1       # Move past comma
    
title_field_start:
    # Parse the title field (field 2)
    # Calculate address for task_titles[task_count]
    la $t3, task_titles    # Load base address of task_titles
    li $t4, 40             # Each title is 40 bytes
    mul $t4, $t1, $t4      # task_count * 40
    add $t3, $t3, $t4      # Address of task_titles[task_count]
    
    # Initialize counter
    li $t4, 0              # Character counter (max 40)
    
parse_title_loop:
    lb $t5, 0($t2)         # Load byte from cursor
    beq $t5, 44, title_done   # If comma, we're done
    beq $t5, 10, title_done   # If LF, we're done
    beq $t5, 13, title_done   # If CR, we're done
    beqz $t5, title_done      # If null, we're done
    
    # Store the character in task_titles
    sb $t5, 0($t3)
    addi $t3, $t3, 1      # Next destination character (in task_titles)
    addi $t2, $t2, 1      # Next source character      (cursor)
    addi $t4, $t4, 1      # Increment counter
    
    # If we've copied 40 bytes, stop
    beq $t4, 40, title_done
    j parse_title_loop
    
title_done:
    # Null-terminate title if we have space
    bge $t4, 40, title_skip_null
    sb $zero, 0($t3)
    
title_skip_null:
    # Skip comma if present
    lb $t4, 0($t2)
    beq $t4, 44, skip_title_comma
    j priority_field_start
    
skip_title_comma:
    addi $t2, $t2, 1       # Move past comma
    
priority_field_start:
    # Parse the priority field (field 3)
    # Calculate address for task_priorities[task_count]
    la $t3, task_priorities
    add $t3, $t3, $t1      # Address of task_priorities[task_count]
    
    # Load the priority (single digit)
    lb $t5, 0($t2)
    addi $t5, $t5, -48     # Convert ASCII to integer
    
    # Check if priority is valid (0-2)
    bltz $t5, parse_priority_error
    bgt $t5, 2, parse_priority_error
    
    # Store the priority
    sb $t5, 0($t3)
    
    # Move past the priority digit
    addi $t2, $t2, 1
    
    # Skip comma if present
    lb $t4, 0($t2)
    beq $t4, 44, skip_priority_comma
    j stage_field_start
    
skip_priority_comma:
    addi $t2, $t2, 1       # Move past comma
    j stage_field_start
    
parse_priority_error:
    # Default to medium priority
    li $t5, 1
    sb $t5, 0($t3)
    
    # Move past invalid character
    addi $t2, $t2, 1
    
    # Skip comma if present
    lb $t4, 0($t2)
    beq $t4, 44, skip_priority_comma
    
stage_field_start:
    # Parse the stage field (field 4)
    # Calculate address for task_stages[task_count]
    la $t3, task_stages
    add $t3, $t3, $t1      # Address of task_stages[task_count]
    
    # Load the stage (single digit)
    lb $t5, 0($t2)
    addi $t5, $t5, -48     # Convert ASCII to integer
    
    # Check if stage is valid (0-3)
    bltz $t5, parse_stage_error
    bgt $t5, 3, parse_stage_error
    
    # Store the stage
    sb $t5, 0($t3)
    
    # Move past the stage digit
    addi $t2, $t2, 1
    
    # Skip comma if present
    lb $t4, 0($t2)
    beq $t4, 44, skip_stage_comma
    j deadline_field_start
    
skip_stage_comma:
    addi $t2, $t2, 1       # Move past comma
    j deadline_field_start
    
parse_stage_error:
    # Default to "To Do" stage
    li $t5, 0
    sb $t5, 0($t3)
    
    # Move past invalid character
    addi $t2, $t2, 1
    
    # Skip comma if present
    lb $t4, 0($t2)
    beq $t4, 44, skip_stage_comma
    
deadline_field_start:
    # Parse the deadline field (field 5)
    # Calculate address for task_deadlines[task_count]
    la $t3, task_deadlines
    li $t4, 10             # Each deadline is 10 bytes (changed from 12)
    mul $t4, $t1, $t4
    add $t3, $t3, $t4      # Address of task_deadlines[task_count]
    
    # Initialize counter
    li $t4, 0              # Character counter (max 10)
    
parse_deadline_loop:
    lb $t5, 0($t2)         # Load byte from cursor
    beq $t5, 44, deadline_done   # If comma, we're done
    beq $t5, 10, deadline_done   # If LF, we're done
    beq $t5, 13, deadline_done   # If CR, we're done
    beqz $t5, deadline_done      # If null, we're done
    
    # Store the character in task_deadlines
    sb $t5, 0($t3)
    addi $t3, $t3, 1      # Next destination character
    addi $t2, $t2, 1      # Next source character
    addi $t4, $t4, 1      # Increment counter
    
    # If we've copied 10 bytes, stop
    beq $t4, 10, deadline_done
    j parse_deadline_loop
    
deadline_done:
    # Null-terminate deadline if we have space
    bge $t4, 10, deadline_skip_null
    sb $zero, 0($t3)
    
deadline_skip_null:
    # Skip comma if present
    lb $t4, 0($t2)
    beq $t4, 44, skip_deadline_comma
    j status_field_start
    
skip_deadline_comma:
    addi $t2, $t2, 1       # Move past comma
    
status_field_start:
    # Parse the status field (field 6)
    # Calculate address for task_statuses[task_count]
    la $t3, task_statuses
    add $t3, $t3, $t1      # Address of task_statuses[task_count]
    
    # Load the status (single digit)
    lb $t5, 0($t2)
    addi $t5, $t5, -48     # Convert ASCII to integer
    
    # Check if status is valid (0-1)
    bltz $t5, parse_status_error
    bgt $t5, 1, parse_status_error
    
    # Store the status
    sb $t5, 0($t3)
    
    # Move past the status digit
    addi $t2, $t2, 1
    
    # Find the end of the line
    j find_line_end
    
parse_status_error:
    # Default to active status
    li $t5, 0
    sb $t5, 0($t3)
    
    # Move past invalid character
    addi $t2, $t2, 1
    
find_line_end:
    # Find the end of the current line
    lb $t5, 0($t2)
    beq $t5, 10, line_end_lf      # LF
    beq $t5, 13, line_end_cr      # CR (might be CR+LF)
    beqz $t5, line_end_null       # End of buffer
    
    # Move to next character
    addi $t2, $t2, 1
    j find_line_end
    
line_end_cr:
    # Check if CR+LF
    addi $t6, $t2, 1
    lb $t5, 0($t6)
    beq $t5, 10, line_end_crlf    # CR+LF
    
    # Just CR, move past it
    addi $t2, $t2, 1
    j line_end_done
    
line_end_crlf:
    # Move past CR+LF
    addi $t2, $t2, 2
    j line_end_done
    
line_end_lf:
    # Move past LF
    addi $t2, $t2, 1
    j line_end_done
    
line_end_null:
    # Don't move past null
    
line_end_done:
    # Update the cursor for the next line
    move $s1, $t2
    
    # Increment task_count
    lw $t1, task_count
    addi $t1, $t1, 1
    sw $t1, task_count
    
    # Restore registers (NOTE: Don't restore $s1)
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    addi $sp, $sp, 16
    
    jr $ra

# Helper function to find the next comma in the buffer
# Input: $t2 = current position in buffer
# Output: $t2 = position of the next comma or end of string
find_next_comma:
    lb $t5, 0($t2)        # Load byte from buffer
    beq $t5, 44, found_comma  # If comma, we're done
    beq $t5, 13, check_crlf   # Check for CR (might be CRLF)
    beq $t5, 10, found_comma  # If LF, we're done
    beqz $t5, found_comma     # If null, we're done
    addi $t2, $t2, 1      # Move to next character
    j find_next_comma

check_crlf:
    # Check if next byte is LF
    addi $t6, $t2, 1      # Look ahead one byte
    lb $t7, 0($t6)        # Load the byte
    beq $t7, 10, found_crlf   # Found CR+LF
    j found_comma         # Just CR, treat like delimiter

found_crlf:
    move $t2, $t6         # Skip past both CR and LF
    j found_comma
    
found_comma:
    jr $ra                # Return

#----------------------------------------------------
# Exit program
#----------------------------------------------------
exit_program:
    # Save board automatically before exiting
    jal save_board
    
    # Display exit message
    li $v0, 4
    la $a0, exit_message
    syscall
    
    # Exit program
    li $v0, 10
    syscall
