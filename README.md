[README.md](https://github.com/user-attachments/files/22548594/README.md)
Stackjack - Enhanced Lottery Contract

A secure and feature-rich lottery smart contract built on the Stacks blockchain using Clarity.

Overview

Stackjack is a decentralized lottery system where users can purchase tickets with STX tokens and a random winner is selected to receive the prize pool. The contract includes comprehensive access controls, payment mechanisms, and administrative functions.

Features

Core Functionality

Ticket Purchase

: Users can buy lottery tickets with STX payments

Random Winner Selection

: Cryptographically secure random winner selection

Prize Pool Management

: Automatic prize pool accumulation and distribution

House Edge

: 10% house edge, 90% goes to winner

Security & Access Control

Owner-Only Administration

: Critical functions restricted to contract owner

Emergency Controls

: Ability to stop lottery in emergency situations

Input Validation

: Comprehensive error handling and validation

State Management

: Proper lottery round lifecycle management

Administrative Features

Configurable Ticket Price

: Owner can adjust ticket prices between rounds

Minimum Ticket Requirements

: Configurable minimum tickets before draw

Ownership Transfer

: Ability to transfer contract ownership

Round Management

: Start new lottery rounds after completion

Contract Structure

Data Storage

tickets

: Maps ticket numbers to owner addresses

ticket-count

: Total number of tickets sold

ticket-price

: Price per ticket (default: 1 STX)

prize-pool

: Accumulated STX from ticket sales

lottery-active

: Current lottery state

contract-owner

: Contract administrator

min-tickets-for-draw

: Minimum tickets required for draw

Error Codes

u100

: Not authorized

u101

: Lottery inactive

u102

: Insufficient tickets

u103

: No winner found

u104

: Transfer failed

u105

: Lottery already active

u106

: Invalid block info

u107

: Zero tickets

Public Functions

User Functions

buy-ticket()

: Purchase a lottery ticket for the current price

get-lottery-info()

: View current lottery status and statistics

get-ticket-owner(ticket-id)

: Check who owns a specific ticket

get-current-prize-pool()

: View current prize pool amount

get-ticket-price()

: Check current ticket price

is-lottery-active()

: Check if lottery is currently active

Admin Functions (Owner Only)

draw()

: Select random winner and distribute prize

start-new-round()

: Initialize a new lottery round

set-ticket-price(new-price)

: Update ticket price (only when inactive)

set-min-tickets(new-min)

: Update minimum ticket requirement

transfer-ownership(new-owner)

: Transfer contract ownership

emergency-stop()

: Immediately stop the current lottery

How It Works

1. Ticket Purchase

: Users call buy-ticket()

and pay the ticket price in STX

2. Prize Accumulation

: Each payment is added to the prize pool

3. Winner Selection

: Owner calls draw()

to randomly select a winner

4. Prize Distribution

: 90% of prize pool is transferred to winner

5. Round Reset

: Lottery becomes inactive, ready for new round

Randomness Generation

The contract uses a combination of blockchain data for pseudo-randomness:

Current Stacks block height

Current ticket count

Modulo operation to ensure fair distribution

Getting Started

Prerequisites

Clarinet CLI

Stacks wallet

STX tokens for testing

Deployment

1. Clone the repository

2. Run clarinet check

to validate the contract

3. Deploy using clarinet deploy

Usage

1. Call buy-ticket()

to participate in the lottery

2. Wait for minimum tickets to be reached

3. Owner calls draw()

to select winner

4. Winner receives 90% of the prize pool

5. Owner can start a new round with start-new-round()

Security Considerations

Only contract owner can draw lottery and manage settings

Lottery must be active for ticket purchases

Minimum ticket requirements prevent premature draws

Emergency stop functionality for critical situations

Comprehensive error handling prevents unexpected failures

License

This project is open source and available under standard licensing terms.
