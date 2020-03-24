#!/bin/bash

#SBATCH --gres=gpu:1
#SBATCH -J "DeepSpeech-Test-Training"

CLIPDIR=/dstrain/clips/

TRAINBATCHSIZE=64
TESTBATCHSIZE=64
DEVBATCHSIZE=64
LIMITTRAIN=0
LIMITDEV=0
LIMITTEST=0
EPOCHS=75
LEARNINGRATE=0.0001

for i in "$@"; do
    case $i in
        --train=*)
        TRAINBATCHSIZE="${i#*=}"
        ;;

        --test=*)
        TESTBATCHSIZE="${i#*=}"
        ;;

        --dev=*)
        DEVBATCHSIZE="${i#*=}"
        ;;

        --epochs=*)
        EPOCHS="${i#*=}"
        ;;

        --limittrain=*)
        LIMITTRAIN="${i#*=}"
        ;;

        --limittest=*)
        LIMITTEST="${i#*=}"
        ;;

        --limitdev=*)
        LIMITDEV="${i#*=}"
        ;;

        --learning=*)
        LEARNINGRATE="${i#*=}"
        ;;

        *)
                # unknown option
        ;;
    esac
done

SCRATCHDIR=/scratch/ws/s3811141-ds/TrainDeepSpeechGerman/

CHECKPOINTS=$SCRATCHDIR/checkpoints_${TRAINBATCHSIZE}_${TESTBATCHSIZE}_${DEVBATCHSIZE}_${LEARNINGRATE}/
MODELS=$SCRATCHDIR/models_${TRAINBATCHSIZE}_${TESTBATCHSIZE}_${DEVBATCHSIZE}_${LEARNINGRATE}/
TENSORBOARD=$SCRATCHDIR/tensorboard_${TRAINBATCHSIZE}_${TESTBATCHSIZE}_${DEVBATCHSIZE}_${LEARNINGRATE}/

echo "CLIPDIR = ${CLIPDIR}"
echo "TRAINBATCHSIZE = ${TRAINBATCHSIZE}"
echo "TESTBATCHSIZE = ${TESTBATCHSIZE}"
echo "DEVBATCHSIZE = ${DEVBATCHSIZE}"
echo "EPOCHS = ${EPOCHS}"
echo "LIMITTRAIN = ${LIMITTRAIN}"
echo "LIMITTEST = ${LIMITTEST}"
echo "LIMITDEV = ${LIMITDEV}"
echo "SCRATCHDIR = ${SCRATCHDIR}"
echo "CHECKPOINTS = ${CHECKPOINTS}"
echo "MODELS = ${MODELS}"
echo "TENSORBOARD = ${TENSORBOARD}"

mkdir -p $CHECKPOINTS
mkdir -p $MODELS
mkdir -p $TENSORBOARD

singularity exec --nv ds.img \
    python3 /ds/DeepSpeech.py \
    --train_files $CLIPDIR/train.csv \
    --dev_files $CLIPDIR/dev.csv \
    --test_files $CLIPDIR/test.csv \
    --alphabet_config_path /dstrain/alphabet.txt \
    --automatic_mixed_precision=True \
    --checkpoint_dir $CHECKPOINTS \
    --export_dir $MODELS \
    --test_batch_size $TESTBATCHSIZE \
    --train_batch_size $TRAINBATCHSIZE \
    --show_progressbar true \
    --learning_rate $LEARNINGRATE \
    --checkpoint_secs 60 \
    --summary_dir $TENSORBOARD \
    --epochs $EPOCHS \
    --limit_dev $LIMITDEV \
    --limit_train $LIMITTRAIN \
    --limit_test $LIMITTEST \
    --log_level 0 \
    --dev_batch_size $DEVBATCHSIZE
