# Fast Fourier Transform

Three implementations of the **Fast Fourier Transform (FFT)** in C++, each targeting a different execution model: single-threaded, shared-memory parallel, and distributed. The project demonstrates the performance trade-offs between serial simplicity, multi-core parallelism, and distributed scalability on large datasets.

All three variants operate on a generated sine wave input and output the frequency-domain representation using the **Cooley-Tukey radix-2 algorithm**.

---

## Implementations

### Serial
File: `Fast_Fourier_Transform_Serial.cpp`

Two independent implementations of Cooley-Tukey FFT:
- **Recursive** — classic divide-and-conquer, splits the input into even/odd halves at each level
- **Iterative** — in-place Cooley-Tukey with bit-reversal permutation; avoids recursion overhead for large inputs

Choose between them at runtime with `--algorithm Recursive` or `--algorithm Iterative`.

### Parallel
File: `Fast_Fourier_Transform_Parallel.cpp`

Iterative FFT distributed across multiple C++ threads using `std::thread` and a custom barrier:
- Thread 0 handles the bit-reversal permutation
- All threads cooperate on the butterfly stages, each working on a contiguous range of the signal
- Per-thread wall-clock timing is recorded and reported
- Synchronisation between butterfly stages uses a barrier to prevent data races

### Distributed
File: `Fast_Fourier_Transform_Distributed.cpp`

Iterative FFT scaled across multiple processes using **MPI** (Message Passing Interface):
- Each MPI rank processes a local slice of the signal
- Results are gathered back to rank 0
- Designed for signals too large for a single node's memory or where inter-node distribution is required

---

## Build

**Requirements:** `g++` (C++14), `make`, and `mpicxx` / OpenMPI for the distributed variant.

```bash
# Build all three executables
make

# Or build individually
make Fast_Fourier_Transform_Serial
make Fast_Fourier_Transform_Parallel
make Fast_Fourier_Transform_Distributed

# Clean
make clean
```

Compiled with `-O3 -march=native` for maximum optimisation.

---

## Usage

All executables accept the same core CLI arguments (parsed with `cxxopts`):

| Flag | Description | Default |
|---|---|---|
| `--n_samples` | Number of input samples (must be a power of 2) | `1024` |
| `--amplitude` | Sine wave amplitude | `1.0` |
| `--frequency` | Sine wave frequency in Hz | `50.0` |
| `--sampling_rate` | Sampling rate in Hz | `1000.0` |

### Serial

```bash
# Iterative FFT, 4096 samples
./Fast_Fourier_Transform_Serial --n_samples 4096 --algorithm Iterative

# Recursive FFT with custom signal parameters
./Fast_Fourier_Transform_Serial --n_samples 1024 --amplitude 2.0 --frequency 100.0 --sampling_rate 2000.0 --algorithm Recursive
```

### Parallel

```bash
# 4 threads (default), 8192 samples
./Fast_Fourier_Transform_Parallel --n_samples 8192 --num_threads 4

# 8 threads
./Fast_Fourier_Transform_Parallel --n_samples 8192 --num_threads 8
```

### Distributed

```bash
# 4 MPI processes, 16384 samples
mpirun -np 4 ./Fast_Fourier_Transform_Distributed --n_samples 16384

# 8 processes across nodes
mpirun -np 8 --hostfile hosts ./Fast_Fourier_Transform_Distributed --n_samples 65536
```

---

## Design Notes

**Why three variants?** Each execution model has a different sweet spot. The serial version is the simplest to reason about and fastest for small inputs due to zero synchronisation overhead. The parallel version scales well on multi-core machines for mid-size inputs but is bounded by shared memory bandwidth. The distributed version is intended for large-scale workloads where the dataset is partitioned across nodes — the communication cost of MPI only pays off at high sample counts.

**Input generation:** All variants generate a synthetic sine wave internally rather than reading from a file, keeping the focus on the FFT computation itself and making benchmarking reproducible.

**Correctness:** The sample count must be a power of two — this is enforced with a validation check at startup. The iterative variant uses bit-reversal permutation to reorder the input before the butterfly passes.

---

## Project Structure

```
FAST_FOURIER_TRANSFORM/
├── Fast_Fourier_Transform_Serial.cpp       # Recursive + iterative single-threaded FFT
├── Fast_Fourier_Transform_Parallel.cpp     # Multi-threaded FFT with C++ Threads
├── Fast_Fourier_Transform_Distributed.cpp  # Distributed FFT with MPI
├── Makefile
└── core/
    ├── cxxopts.h      # CLI argument parsing
    ├── get_time.h     # Wall-clock timer utility
    └── utils.h        # Shared utilities (custom barrier, helpers)
```

---

## Tech Stack

- **Language:** C++ (C++14)
- **Parallelism:** `std::thread`, custom barrier synchronisation
- **Distribution:** MPI (OpenMPI / MPICH)
- **Build:** GNU Make, g++ / mpicxx
- **CLI parsing:** cxxopts
