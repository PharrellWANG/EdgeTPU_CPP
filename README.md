# Edge TPU in CPP
## Target environment
- Coral Dev Board
- Jetson Nano + USB Accelerator
- Raspberry Pi 3,4 + USB Accelerator
- Linux (x64)
- Windows (x64)

## How to build application code
```
# the following command is needed only once for a system
sudo apt install curl cmake

# the following commands are needed only once when you clone the code
cd EdgeTPU_CPP
git submodule init
git submodule update
cd third_party/tensorflow
chmod +x tensorflow/lite/tools/make/download_dependencies.sh
tensorflow/lite/tools/make/download_dependencies.sh
# [This causes error ->] sh tensorflow/tensorflow/lite/tools/make/download_dependencies.sh

cd ../../project_classification_tflite
mkdir build && cd build
cmake .. -DUSE_EDGETPU=on							## For x64 PC (Windows, Linux)
# cmake .. -DARCH_TYPE=armv7   -DUSE_EDGETPU=on		## For Raspberry Pi
# cmake .. -DARCH_TYPE=aarch64 -DUSE_EDGETPU=on 	## For Jetson Nano, Coral Dev Board
# cmake .. -DARCH_TYPE=armv7   -DUSE_EDGETPU=off	## without Edge TPU (use TensorflowLite)
make

./main
# cp ../../third_party/edgetpu/libedgetpu/direct/armv7a/libedgetpu.so.1.0 libedgetpu.so.1
# mv libedgetpu.so.1.0 libedgetpu.so.1
# sudo LD_LIBRARY_PATH=./ ./main

```

### Notice for Windows users
I noticed running with `Debug` causes exception, so use `Release` or `RelWithDebInfo` in Visual Studio.


## How to create pre-built TensorflowLite library
### Common
```
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow

## https://github.com/google-coral/edgetpu/issues/44#issuecomment-589170013
git checkout d855adfc5a0195788bf5f92c3c7352e638aa1109
git cherry-pick e8376142f50982e2bc22fae2d62f8fcfc6e88df7
git cherry-pick 72cd947f231950d7ecd1406b5a67388fef7133ea

./tensorflow/lite/tools/make/download_dependencies.sh
```

### For Linux (x64, ARM), static library
```
# on Ubuntu (PC Linux)
# Install tools
# sudo dpkg --add-architecture armhf
# sudo dpkg --add-architecture arm64
sudo apt update
sudo apt install -y build-essential crossbuild-essential-armhf crossbuild-essential-arm64
sudo apt install -y libusb-1.0-0-dev
sudo apt install -y zlib1g-dev
# sudo apt install -y libusb-1.0-0-dev libusb-1.0-0-dev:arm64 libusb-1.0-0-dev:armhf

./tensorflow/lite/tools/make/build_generic_aarch64_lib.sh
./tensorflow/lite/tools/make/build_rpi_lib.sh 
./tensorflow/lite/tools/make/build_lib.sh

# You may error to build "minimal", but just ignore it.

ls ./tensorflow/lite/tools/make/gen/generic-aarch64_armv8-a/lib
ls ./tensorflow/lite/tools/make/gen/rpi_armv7l/lib
ls ./tensorflow/lite/tools/make/gen/linux_x86_64/lib
```

### For Windows (x64), shared library
Add `bazel.exe` (bazel-1.2.1-windows-x86_64.zip) to windows path.

```
# On Anaconda Powershell prompt (Miniconda3)
conda create -n build_tflite
conda activate build_tflite
conda install python
conda install numpy

cd path-to-tensorflow

# modify bazel script
nano tensorflow/lite/build_def.bzl 
###
# --- a/tensorflow/lite/build_def.bzl
# +++ b/tensorflow/lite/build_def.bzl
# @@ -159,6 +159,7 @@ def tflite_cc_shared_object(
#      tf_cc_shared_object(
#          name = name,
#          copts = copts,
# +        features = ["windows_export_all_symbols"],
#          linkstatic = linkstatic,
#          linkopts = linkopts + tflite_jni_linkopts(),
#          framework_so = [],
###

python configure.py
bazel build -c opt //tensorflow/lite:tensorflowlite
ls ./bazel-bin/tensorflow/lite/tensorflowlite.dll
ls ./bazel-bin/tensorflow/lite/tensorflowlite.dll.if.lib
```

## Acknowledge
### External libraries
- third_party/tensorflow_prebuilt/
	- prebuilt libraries are generated from https://github.com/tensorflow/tensorflow 
- third_party/edgetpu_runtime/
	- is copied from https://dl.google.com/coral/edgetpu_api/edgetpu_runtime_20200128.zip

### Models
The models are retrieved from:

- https://coral.withgoogle.com/models/
	- https://dl.google.com/coral/canned_models/mobilenet_v2_1.0_224_quant_edgetpu.tflite
	- http://download.tensorflow.org/models/tflite_11_05_08/mobilenet_v2_1.0_224_quant.tgz
- https://www.tensorflow.org/lite/guide/hosted_models
	- https://storage.googleapis.com/download.tensorflow.org/models/tflite_11_05_08/mobilenet_v2_1.0_224.tgz
- https://www.tensorflow.org/lite/models/object_detection/overview
	- https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip
- https://github.com/google-coral/edgetpu/tree/master/test_data
	- https://github.com/google-coral/edgetpu/blob/master/test_data/deeplabv3_mnv2_dm05_pascal_quant.tflite
	- https://github.com/google-coral/edgetpu/blob/master/test_data/deeplabv3_mnv2_dm05_pascal_quant_edgetpu.tflite
