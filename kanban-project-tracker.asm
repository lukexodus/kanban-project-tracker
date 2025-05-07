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

# Buffer for user input
input_buffer:    .space 4

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
    
    # Display "not implemented" message
    li $v0, 4
    la $a0, not_implemented
    syscall
    
    # Return to main loop
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j main_loop

add_task:
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

move_task:
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

delete_task:
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