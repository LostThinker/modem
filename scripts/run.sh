#!/bin/bash

seed_default=0
seed=${1:-$seed_default}

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/qianlong/.mujoco/mujoco210/bin:/usr/lib/nvidia

pretrain_envs=(
  'box-close'
  'coffee-push'
  'coffee-pull'
  'hammer'
  'peg-insert-side'
  'peg-unplug-side'
  'stick-push'
  'sweep-into'
)

metaworld_envs=(
  'assembly'
  'basketball'
  'box-close'
  'coffee-push'
  'hand-insert'
  'peg-insert-side'
  'pick-place'
  'pick-place-wall'
  'push'
  'push-wall'
  'soccer'
  'stick-pull'
  'stick-push'
  'sweep'
  'sweep-into'
)

maniskill_envs=(
  'peg-insert-side'
  'pick-cube'
  'poke-cube'
  'pull-cube'
  'pull-cube-tool'
  'lift-peg-upright'
  'push-cube'
  'place-sphere'
)

# set tasks
envs=("${metaworld_envs[@]}")

# set GPU
GPUs=(0 1 2 3 4 5 6 7)
gpus_num=${#GPUs[@]}

suite="mw"
#domain="ms-"

time=$(date +"%Y%m%d_%H%M%S")

folder_name=./logs/nohup_out/$time


mkdir -p $folder_name

for index in "${!envs[@]}"; do
  env="${envs[index]}"
  TASK=$suite-$env
  gpu_idx=$((index % gpus_num))
  gpuid=${GPUs[gpu_idx]}
  export CUDA_VISIBLE_DEVICES=$gpuid
  nohup python3 train.py suite=$suite task=$TASK log_time=$time seed=$seed >$folder_name/$TASK.log 2>&1 &
  echo "PID: $!" >$folder_name/$TASK.pid
done
