FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y wget git build-essential cmake libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        wget https://github.com/ethereum/solidity/releases/download/v0.8.18/solc-static-linux -O /usr/local/bin/solc && \
        chmod +x /usr/local/bin/solc; \
    elif [ "$ARCH" = "aarch64" ]; then \
        git clone --recursive https://github.com/ethereum/solidity.git && \
        cd solidity && \
        git checkout v0.8.18 && \
        git submodule update --init --recursive && \
        mkdir build && \
        cd build && \
        cmake .. && \
        make && \
        cp solc/solc /usr/local/bin/solc && \
        cd ../.. && \
        rm -rf solidity; \
    else \
        echo "Unsupported Architecture: $ARCH" && exit 1; \
    fi

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt
RUN python -c 'from solcx import install_solc; install_solc("0.8.18")'

RUN git submodule init && git submodule update

EXPOSE 80

CMD ["python", "bench.py"]