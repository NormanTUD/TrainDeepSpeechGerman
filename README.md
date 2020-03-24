# TrainDeepSpeechGerman
This contains singularity Container in which you can train the DeepSpeech Neural Network.

You can build the container via

> sudo singularity build test.img recipe

By using this container, you agree to the Mozilla-DeepSpeech and CommonVoice-License-agreements. 

# Size of this container

This container is nearly 90GB large! Be careful to have enough free space left before building it.

# Will the container itself be available for download?

Yes, I'll try to upload this once it finished building it on my PC. It'll likely be split into
many zip parts, since github does not allow single files to be larger than 100MB.

# How to extract the files?

You can use the `merge.pl` in the `image` folder to create a big zip that can be extracted with
`unzip merged.zip`. You can to that with

> zip -F deepspeech.zip --out fixed.zip

# How to runs this for training then?

> singularity exec ds.img python3 /ds/DeepSpeech.py --train_files /dstrain/clips/train.csv --dev_files /dstrain/clips/dev.csv --test_files /dstrain/clips/test.csv --alphabet_config_path /dstrain/alphabet.txt --automatic_mixed_precision=True
