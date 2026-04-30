from argparse import ArgumentParser
from itertools import product
from pathlib import Path

from generate import SbatchGenerator
from generate_local import LocalScriptGenerator


parser = ArgumentParser()
parser.add_argument('--gen', type=str, default='brc', help='where to run the script')
parser.add_argument('--num_jobs_per_gpu', type=int, default=1, help='the number of jobs to allocate per gpu')
parser.add_argument('--gpu_limit', type=int, default=100)
args = parser.parse_args()


run_group = '2026-04-30-fql-02'
output_dir = Path(__file__).resolve().parents[1] / 'sbatch'
output_dir.mkdir(parents=True, exist_ok=True)
run_file = 'main.py'
priority = 'high'


def make_command(
    env_name,
    alpha,
    seed,
    debug,
):
    flag_args = {
        'env_name': env_name,
        'agent.alpha': alpha,
        'agent.discount': 0.999,
        'agent.n_step': 25,
        'agent.batch_size': 1024,
        'agent.actor_hidden_dims': "'(1024, 1024, 1024, 1024)'",
        'agent.value_hidden_dims': "'(1024, 1024, 1024, 1024)'",
        'seed': seed,
        'run_group': run_group + '_debug' if debug else run_group,
    }
    command = [
        'MUJOCO_GL=egl',
        f'python {run_file}',
        *(f'--{key}={value}' for key, value in flag_args.items()),
    ]
    return ' '.join(command)


def build_commands(debug):
    if debug:
        configs = [
            dict(
                env_name='humanoidmaze-giant-navigate-singletask-task1-v0',
                alpha=100,
                seed=0,
            )
        ]
    else:
        env_names = [
            f'humanoidmaze-giant-navigate-singletask-task{task_id}-v0'
            for task_id in [1, 2, 3, 4, 5]
        ]
        alphas = [100]
        seeds = [0, 1]

        configs = []
        for env_name, alpha, seed in product(env_names, alphas, seeds):
            configs.append(dict(
                env_name=env_name,
                alpha=alpha,
                seed=seed,
            ))

    return [make_command(debug=debug, **config) for config in configs]


for debug in [True, False]:
    commands = build_commands(debug)
    if not commands:
        raise ValueError(f'No runs generated for debug={debug}.')

    if args.gen == 'local':
        gen = LocalScriptGenerator(prefix=())
    else:
        gen = SbatchGenerator(
            j=args.num_jobs_per_gpu,
            limit=args.gpu_limit,
            prefix=(),
            comment=run_group,
            priority=priority,
        )
    gen.commands = commands

    generated = gen.generate_str()
    script_strs = [generated] if isinstance(generated, str) else generated
    name_prefix = f'{run_group}_{args.gen}_debug' if debug else f'{run_group}_{args.gen}'
    multi_part = len(script_strs) > 1

    for i, script_str in enumerate(script_strs, start=1):
        part_suffix = f'_part{i}' if multi_part else ''
        output_path = output_dir / f'{name_prefix}{part_suffix}.sh'
        with open(output_path, 'w') as f:
            f.write(script_str)
        print(f'Wrote {len(commands)} commands to {output_path}')
