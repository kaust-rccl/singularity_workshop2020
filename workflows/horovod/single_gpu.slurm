#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --constraint=v100
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=64G
#SBATCH --time=00:30:00

module load openmpi/4.0.3-cuda10.1
module load singularity

export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/horovod_gpu_0192.sif

echo "PyTorch with Horovod"
mpirun -np 1  singularity exec --nv $IMAGE python ./pytorch_synthetic_benchmark.py --model resnet50 --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >>pytorch_1GPU.log

echo "Tensorflow2 with Horovod"
mpirun -np 1  singularity exec --nv $IMAGE python ./tensorflow2_synthetic_benchmark.py --model ResNet50  --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >> TF2_1GPU.log

