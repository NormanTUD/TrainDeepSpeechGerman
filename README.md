# TrainDeepSpeechGerman
This contains singularity Container in which you can train the DeepSpeech Neural Network.

You can build the container via

> sudo singularity build test.img recipe

By using this container, you agree to the Mozilla-DeepSpeech and CommonVoice-License-agreements. 

# Size of this container

This container is nearly 90GB large! Be careful to have enough free space left before building it.

# How to runs this for training then?

> singularity exec ds.img python3 /ds/DeepSpeech.py --train_files /dstrain/clips/train.csv --dev_files /dstrain/clips/dev.csv --test_files /dstrain/clips/test.csv --alphabet_config_path /dstrain/alphabet.txt --automatic_mixed_precision=True

Also, there's the `run_sbatch.sh` which will handle most stuff automatically.

> sbatch --time="20:00:00" run_sbatch.sh
