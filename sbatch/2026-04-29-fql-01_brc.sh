#!/bin/bash
#SBATCH --job-name=aorl
#SBATCH --open-mode=append
#SBATCH -o /global/scratch/users/jenniferzhao/logs/%A_%a.out
#SBATCH -e /global/scratch/users/jenniferzhao/logs/%A_%a.err
#SBATCH --time=24:00:00
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:A5000:1
#SBATCH --account=co_rail
#SBATCH --partition=savio4_gpu
#SBATCH --qos=rail_gpu4_high
#SBATCH --requeue
#SBATCH --array=1-60%100
#SBATCH --comment=2026-04-29-fql-01-part1

TASK_ID=$((SLURM_ARRAY_TASK_ID-1))
PARALLEL_N=1
JOB_N=60

COM_ID_S=$((TASK_ID * PARALLEL_N + 1))
# module load gnu-parallel
source ~/.bashrc
micromamba activate aorl


declare -a commands=(
  [1]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task1-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [2]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task1-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [3]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task1-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [4]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task1-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [5]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task1-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [6]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task1-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [7]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task2-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [8]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task2-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [9]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task2-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [10]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task2-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [11]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task2-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [12]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task2-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [13]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task3-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [14]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task3-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [15]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task3-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [16]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task3-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [17]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task3-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [18]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task3-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [19]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task4-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [20]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task4-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [21]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task4-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [22]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task4-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [23]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task4-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [24]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task4-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [25]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task5-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [26]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task5-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [27]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task5-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [28]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task5-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [29]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task5-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [30]='MUJOCO_GL=egl python main.py --env_name=humanoidmaze-giant-navigate-singletask-task5-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [31]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task1-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [32]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task1-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [33]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task1-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [34]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task1-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [35]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task1-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [36]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task1-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [37]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task2-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [38]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task2-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [39]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task2-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [40]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task2-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [41]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task2-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [42]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task2-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [43]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task3-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [44]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task3-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [45]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task3-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [46]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task3-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [47]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task3-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [48]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task3-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [49]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task4-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [50]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task4-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [51]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task4-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [52]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task4-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [53]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task4-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [54]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task4-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [55]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task5-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [56]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task5-v0 --agent.alpha=30 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [57]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task5-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [58]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task5-v0 --agent.alpha=300 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
  [59]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task5-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=0 --run_group=2026-04-29-fql-01'
  [60]='MUJOCO_GL=egl python main.py --env_name=cube-quadruple-singletask-task5-v0 --agent.alpha=600 --agent.discount=0.999 --agent.n_step=25 --seed=1 --run_group=2026-04-29-fql-01'
)

parallel --delay 5s --linebuffer -j 1 {1} ::: "${commands[@]:$COM_ID_S:$PARALLEL_N}"
            