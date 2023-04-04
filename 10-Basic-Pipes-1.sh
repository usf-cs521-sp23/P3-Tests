source "${TEST_LIB}/funcs.bash"

run_timeout=5

script=$(cat <<EOM
ls -1 -- / | sort -r
echo -----
seq 10000000 | wc -l
EOM
)

reference_run sh <(echo "${script}") 2> /dev/null

test_start "Basic pipe support (single pipe, large data pipe)"

# ---------- Test Script ----------
echo "${script}"
# -------------- End --------------

run ./$SHELL_NAME < <(echo "${script}")

# If the first command works but the second fails, you are most likely calling
# wait() on processes in the pipe. You don't want to wait() here -- all the
# commands should be running at the same time, with data flowing through them
# from the left to right.

compare_outputs

test_end
