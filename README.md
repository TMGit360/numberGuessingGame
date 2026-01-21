# Number Guessing Game

PostgreSQL-backed number guessing game implemented with a Bash script that tracks user statistics across sessions.

Completed as part of the FreeCodeCamp Relational Database certification.

## Competencies

- PostgreSQL database design with primary and foreign keys
- SQL queries for inserting, aggregating, and retrieving user data
- Bash scripting for user input, loops, and conditional logic
- Integrating shell scripts with databases using `psql`

## Files

- `number_guess.sql` – database schema and seed data
- `number_guess.sh` – Bash script implementing the game logic

## Database Tables

- `usernames`
- `games`

## Run

```bash
psql -U postgres -f number_guess.sql
bash number_guess.sh
