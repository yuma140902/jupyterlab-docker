FROM python:3.12-bookworm

RUN python3 -m pip install --upgrade pip \
&&  pip install --no-cache-dir \
    jupyterlab \
    ipywidgets \
    import-ipynb \
    numpy \
    matplotlib \
    japanize_matplotlib \
    pandas \
    polars \
    pyarrow \
    plotly \
    seaborn

