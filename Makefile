OPENCV_LIB_PATH=/home/suvam/opencv33/lib
OPENCV_DIR=/home/suvam/opencv33/include
EIGEN_INCLUDE_PATH=/usr/include/eigen3
BA_LIBS_PATH=./ba_libs
CAM_LOC=./CameraLocation
CAM_LOC_INC=./CameraLocation/cereal/include
CUDA_ART=/usr/lib/x86_64-linux-gnu/
		
all:
	g++ -std=c++11 -g3 -O2 RefineClusters.cpp -o RefineClusters -ldl -I/usr/include -I${EIGEN_INCLUDE_PATH}  -L/usr/lib/ -L/usr/local/lib  -lglog 

	cd ../Optimizer/pba/ && $(MAKE)
	cp ../Optimizer/pba/bin/libpba_no_gpu.a ../Optimizer/lib/libpba.a
	cd ../Optimizer/Thirdparty/g2o/build && cmake ..
	cd ../Optimizer/Thirdparty/g2o/build && $(MAKE)

	cd ../VocabTree2/VocabLearn/ && $(MAKE)

	cp ../VocabTree2/VocabLearn/VocabLearn .

	cd ../VocabTree2/VocabBuildDB/ && $(MAKE)

	cp ../VocabTree2/VocabBuildDB/VocabBuildDB .

	cd ../VocabTree2/VocabMatch/ && $(MAKE)

	cp ../VocabTree2/VocabMatch/VocabMatch .

	g++ -std=c++11 -g3 -O2  DataGeneration.cpp -o DataGeneration -ldl  -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack
	
	g++  -g3 -w -std=c++11 -Wall -fopenmp -o getPose  -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH}  -L/usr/local/lib -L/usr/lib   RT.cpp -lceres -lglog -lpthread -lopencv_core  -lcholmod -llapack -lblas

	g++ -g -std=c++11 -Wall -fopenmp -o cameraLoc -I${CAM_LOC_INC} -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${OPENCV_DIR} -L/usr/local/lib -L/usr/lib  CameraLocation/camera.cc CameraLocation/camera_intrinsics_model.cc CameraLocation/cameraLocation.cpp CameraLocation/create_loss_function.cc CameraLocation/fisheye_camera_model.cc CameraLocation/fov_camera_model.cc CameraLocation/fundamental_matrix_util.cc CameraLocation/optimize_relative_position_with_known_rotation.cc CameraLocation/pinhole_camera_model.cc CameraLocation/pinhole_radial_tangential_camera_model.cc CameraLocation/projection_matrix_utils.cc CameraLocation/random.cc CameraLocation/test_util.cc CameraLocation/triangulation.cc CameraLocation/util.cc -lceres -lglog -lpthread 
	cp ./cameraLoc ../bin/

	g++ -std=c++11 -g3 -O2  Merge3D3D.cpp -o Merge3D3D -ldl  -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack
	
	g++ -std=c++11 -g3 -O2  Merge2D2D_R.cpp -o Merge2D2D_R -ldl  -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack

	g++ -std=c++11 -g3 -O2  Merge3D3D_withR.cpp -o Merge3D3D_withR -ldl  -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack
	
	g++ -std=c++11 -g3 -O2  Merge3D2D.cpp -o Merge3D2D -ldl -I${OPENCV_DIR} -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack -L${OPENCV_LIB_PATH} -lopencv_calib3d -lopencv_core -lopencv_features2d -lopencv_highgui -lopencv_imgproc -lopencv_video -lopencv_videostab -lopencv_imgcodecs

	g++ -std=c++11 -g3 -O2  MergeClusters.cpp -o MergeClusters -ldl  -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack

	g++ -std=c++11 -g3 -O2  ClusterReconstruction.cpp -o ClusterReconstruct -ldl  -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix -L/usr/local/lib -L${BA_LIBS_PATH}/lib -L/usr/lib ./FivePoint/eight_point_fundamental_matrix.cc ./FivePoint/estimate_twoview_info.cc ./FivePoint/fundamental_matrix_util.cc ./FivePoint/random.cc ./FivePoint/essential_matrix_utils.cc ./FivePoint/estimate_uncalibrated_relative_pose.cc ./FivePoint/sequential_probability_ratio.cc ./FivePoint/estimate_relative_pose.cpp ./FivePoint/five_point.cpp ./FivePoint/pose_util.cc ./FivePoint/triangulation.cc -lceres -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack
	
	g++ -std=c++11 -g3 -O2  ExtractSiftFeatures.cpp -o SiftExtractor -ldl -I${OPENCV_DIR} -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -L/usr/local/lib -L/usr/lib ./FivePoint/eight_point_fundamental_matrix.cc ./FivePoint/estimate_twoview_info.cc ./FivePoint/fundamental_matrix_util.cc ./FivePoint/random.cc ./FivePoint/essential_matrix_utils.cc ./FivePoint/estimate_uncalibrated_relative_pose.cc ./FivePoint/sequential_probability_ratio.cc ./FivePoint/estimate_relative_pose.cpp ./FivePoint/five_point.cpp ./FivePoint/pose_util.cc ./FivePoint/triangulation.cc -lceres -lglog -L${OPENCV_LIB_PATH} -lopencv_core -lopencv_imgproc -lopencv_imgcodecs

	g++ -std=c++11 -g3 -O2  MatchSiftFeatures.cpp -o MatchSift -ldl -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -L/usr/local/lib -L/usr/lib ./FivePoint/eight_point_fundamental_matrix.cc ./FivePoint/estimate_twoview_info.cc ./FivePoint/fundamental_matrix_util.cc ./FivePoint/random.cc ./FivePoint/essential_matrix_utils.cc ./FivePoint/estimate_uncalibrated_relative_pose.cc ./FivePoint/sequential_probability_ratio.cc ./FivePoint/estimate_relative_pose.cpp ./FivePoint/five_point.cpp ./FivePoint/pose_util.cc ./FivePoint/triangulation.cc -lceres -lglog

	g++ -std=c++11 -g3 -O2  TriangulationMultiStep.cpp -o TriangulateMulti -ldl  -I${OPENCV_DIR} -I./FivePoint -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib ./FivePoint/eight_point_fundamental_matrix.cc ./FivePoint/estimate_twoview_info.cc ./FivePoint/fundamental_matrix_util.cc ./FivePoint/random.cc ./FivePoint/essential_matrix_utils.cc ./FivePoint/estimate_uncalibrated_relative_pose.cc ./FivePoint/sequential_probability_ratio.cc ./FivePoint/estimate_relative_pose.cpp ./FivePoint/five_point.cpp ./FivePoint/pose_util.cc ./FivePoint/triangulation.cc -lceres -lglog -lmatrix -lz -llapack -lblas -lcblas -lminpack -L${OPENCV_LIB_PATH} -lopencv_calib3d -lopencv_core -lopencv_features2d -lopencv_highgui -lopencv_imgproc -lopencv_video -lopencv_videostab -lopencv_imgcodecs

	g++ -std=c++11 -g3 -O2  Merge2D2D_C.cpp -o Merge2D2D_C -ldl -I./CameraLocation -I${CAM_LOC_INC} -I/usr/local/include -I/usr/include -I${EIGEN_INCLUDE_PATH} -I${BA_LIBS_PATH}/lib/matrix/ -L/usr/lib/ -L/usr/local/lib -L${BA_LIBS_PATH}/lib  CameraLocation/camera.cc CameraLocation/camera_intrinsics_model.cc CameraLocation/create_loss_function.cc CameraLocation/fisheye_camera_model.cc CameraLocation/fov_camera_model.cc CameraLocation/fundamental_matrix_util.cc CameraLocation/optimize_relative_position_with_known_rotation.cc CameraLocation/pinhole_camera_model.cc CameraLocation/pinhole_radial_tangential_camera_model.cc CameraLocation/projection_matrix_utils.cc CameraLocation/random.cc CameraLocation/test_util.cc CameraLocation/triangulation.cc CameraLocation/util.cc -lceres -lglog -lpthread -lmatrix -lz -llapack -lblas -lcblas -lminpack
 
	
