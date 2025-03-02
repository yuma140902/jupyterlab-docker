FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    build-essential \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV RUST_HOME="/usr/local/rustup" \
    CARGO_HOME="/usr/local/cargo" \
    PATH="/mise/shims:$PATH:/usr/local/cargo/bin" \
    RUST_VERSION="stable" \
    MISE_DATA_DIR="/mise" \
    MISE_CONFIG_DIR="/mise" \
    MISE_CACHE_DIR="/mise/cache" \
    MISE_INSTALL_PATH="/usr/local/bin/mise"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain ${RUST_VERSION}

RUN rustup component add rust-analyzer rust-src \
&&  rustup --version \
&&  cargo --version \
&&  rustc --version

RUN cargo install evcxr_jupyter \
&&  evcxr_jupyter --install

RUN curl https://mise.run | sh
RUN mise use -g uv \
&&  mise use -g node@20 \
&&  mise install

WORKDIR /app
RUN uv python install 3.12
RUN npm init -y \
&&  npm install --save-dev \
    pyright \
    vscode-json-languageserver-bin \
    yaml-language-server
RUN uv init \
&&  uv add \
    jupyterlab \
    jupyterlab-lsp \
    jupyterlab_code_formatter \
    isort \
    black \
    ipywidgets \
    import-ipynb

RUN uv add \
    numpy \
    matplotlib \
    japanize_matplotlib \
    pandas \
    polars \
    pyarrow \
    plotly \
    seaborn
