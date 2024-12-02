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
SERIAL_EXEC = Fast_Fourier_Transform_Serial
PARALLEL_EXEC = Fast_Fourier_Transform_Parallel
DISTRIBUTED_EXEC = Fast_Fourier_Transform_Distributed

# Core headers
CORE = core/cxxopts.h core/get_time.h core/utils.h

# Default target
all: $(SERIAL_EXEC) $(PARALLEL_EXEC) $(DISTRIBUTED_EXEC)

# Serial FFT
$(SERIAL_EXEC): $(SERIAL_SRC) $(CORE)
	$(CXX) $(CXXFLAGS) $< $(LDFLAGS) -o $@

# Parallel FFT (uses pthreads)
$(PARALLEL_EXEC): $(PARALLEL_SRC) $(CORE)
	$(CXX) $(CXXFLAGS) $(PTHREAD_FLAGS) $< $(LDFLAGS) -o $@

# Distributed FFT (uses MPI)
$(DISTRIBUTED_EXEC): $(DISTRIBUTED_SRC) $(CORE)
	$(MPICXX) $(MPI_CXXFLAGS) -DMPI_ENABLED $< $(LDFLAGS) -o $@

# Clean targets
.PHONY: clean
clean:
	rm -f $(SERIAL_EXEC) $(PARALLEL_EXEC) $(DISTRIBUTED_EXEC)
