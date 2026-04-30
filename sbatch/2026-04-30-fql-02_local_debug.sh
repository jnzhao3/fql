#!/bin/bash

# List of scripts to run
scripts=(
  "MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task1-v0 --agent.alpha=100 --agent.discount=0.999 --agent.n_step=25 --agent.batch_size=1024 --agent.actor_hidden_dims='(1024, 1024, 1024, 1024)' --agent.value_hidden_dims='(1024, 1024, 1024, 1024)' --seed=0 --run_group=2026-04-30-fql-02_debug"
)

# List of available GPU IDs (modify as needed)
gpus=(0 1 2 4 5 6 7)

num_gpus=${#gpus[@]}
num_scripts=${#scripts[@]}

# Store PIDs of background jobs
pids=()

# Function to handle Ctrl+C
cleanup() {
  echo "Terminating all running processes..."
  for pid in "${pids[@]}"; do
    kill "$pid" 2>/dev/null
  done
  wait
  exit 1
}

# Trap SIGINT (Ctrl+C) and call cleanup
trap cleanup SIGINT

# Function to run scripts sequentially on a given GPU
run_on_gpu() {
  local gpu_id=$1
  shift
  local gpu_scripts=("$@")

  for script in "${gpu_scripts[@]}"; do
    echo "Running $script on GPU $gpu_id"
    CUDA_VISIBLE_DEVICES=$gpu_id eval "$script" &
    pids+=($!)  # Store PID of the process
    wait ${pids[-1]}  # Wait for the process to finish before moving to the next
  done
}

# Distribute scripts among GPUs
for ((i=0; i<num_gpus; i++)); do
  gpu_scripts=()

  # Assign every nth script to this GPU
  for ((j=i; j<num_scripts; j+=num_gpus)); do
    gpu_scripts+=("${scripts[j]}")
  done

  if [ ${#gpu_scripts[@]} -gt 0 ]; then
    run_on_gpu ${gpus[i]} "${gpu_scripts[@]}" &
    pids+=($!)  # Store PID of background process
  fi
done

wait  # Wait for all background jobs
echo "All scripts finished."
