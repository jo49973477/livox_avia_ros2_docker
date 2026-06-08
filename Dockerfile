# 1. ROS Humble 공식 이미지 기반
FROM osrf/ros:humble-desktop

# 2. 필수 빌드 도구 설치
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    make \
    git \
    libapr1-dev \
    libboost-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Livox SDK 빌드 및 설치
WORKDIR /root
RUN git clone https://github.com/Livox-SDK/Livox-SDK.git || true && \
    cd Livox-SDK && \
    sed -i '29i #include <memory>' sdk_core/src/base/thread_base.h && \
    rm -rf build && \
    mkdir build && cd build && \
    # 핵심 옵션 추가!!
    cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    make -j$(nproc) && make install

WORKDIR /root
# 기존에 꼬인 폴더가 있다면 무시/삭제하고 매뉴얼대로 정확하게 src라는 이름으로 클론!
RUN rm -rf ws_livox/src && \
    git clone https://github.com/Livox-SDK/livox_ros2_driver.git ws_livox/src

# 빌드는 워크스페이스 최상단에서!
WORKDIR /root/ws_livox
RUN /bin/bash -c "source /opt/ros/humble/setup.sh && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release"

# 5. 환경 변수 설정
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc && \
    echo "source /root/ws_livox/install/setup.bash" >> /root/.bashrc

WORKDIR /root/ws_livox
CMD ["/bin/bash"]