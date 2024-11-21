# Compiler setup
CXX = g++
MPICXX = mpicxx
CXXFLAGS = -std=c++14 -march=native -O3
PTHREAD_FLAGS = -pthread
MPI_CXXFLAGS = -std=c++14 -march=native -O3
LDFLAGS = -lpthread

# Source files
SERIAL_SRC = Fast_Fourier_Transform_Serial.cpp
PARALLEL_SRC = Fast_Fourier_Transform_Parallel.cpp
DISTRIBUTED_SRC = Fast_Fourier_Transform_Distributed.cpp

# Executable names
SERIAL_EXEC = fft_serial
PARALLEL_EXEC = fft_parallel
DISTRIBUTED_EXEC = fft_distributed

# Common headers
# COMMON = common/utils.h common/cxxopts.h common/get_time.h

# Default target
all: $(SERIAL_EXEC) $(PARALLEL_EXEC) $(DISTRIBUTED_EXEC)

# Serial FFT
$(SERIAL_EXEC): $(SERIAL_SRC) $(COMMON)
	$(CXX) $(CXXFLAGS) $< $(LDFLAGS) -o $@

# Parallel FFT (uses pthreads)
$(PARALLEL_EXEC): $(PARALLEL_SRC) $(COMMON)
	$(CXX) $(CXXFLAGS) $(PTHREAD_FLAGS) $< $(LDFLAGS) -o $@

# Distributed FFT (uses MPI)
$(DISTRIBUTED_EXEC): $(DISTRIBUTED_SRC) $(COMMON)
	$(MPICXX) $(MPI_CXXFLAGS) -DMPI_ENABLED $< $(LDFLAGS) -o $@

# Clean targets
.PHONY: clean
clean:
	rm -f $(SERIAL_EXEC) $(PARALLEL_EXEC) $(DISTRIBUTED_EXEC)
