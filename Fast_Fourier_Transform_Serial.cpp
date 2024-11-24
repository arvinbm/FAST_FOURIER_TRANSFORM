#include "common/cxxopts.h"
#include <iostream>
#include <vector>
#include <complex>
#include <cmath>

#define DEFAULT_NUMBER_OF_SAMPLES "1024"
#define DEFAULT_AMPLITUDE "1.0"
#define DEFAULT_FREQUENCY "50.0"
#define DEFAULT_SAMPLING_RATE "1000.0"

/** 
 * (This comment has been generated by GenAI based on the implementation of the function).
 * @brief Generates a sine wave sampled at regular intervals.
 * 
 * This function creates a sine wave based on the specified number of samples, amplitude,
 * frequency, and sampling rate. The resulting sine wave is represented as a vector of
 * complex numbers, where the real part contains the sine wave values, and the imaginary 
 * part is set to 0.0 (useful for FFT processing).
 * 
 * @param n_samples The total number of samples to generate.
 * @param amplitude The amplitude of the sine wave (peak value).
 * @param frequency The frequency of the sine wave in Hz (cycles per second).
 * @param sampling_rate The rate at which the sine wave is sampled in Hz (samples per second).
 * @return std::vector<std::complex<double>> A vector containing the sampled sine wave values 
 *         as complex numbers with 0.0 as the imaginary part.
 */
std::vector<std::complex<double>> generateSineWave(uint n_samples, double amplitude, double frequency, double sampling_rate) {
    // Vector to store the samples from the sine wave
    std::vector<std::complex<double>> sine_wave(n_samples);

    for (uint n = 0; n < n_samples; ++n) {
        double time_step = n / sampling_rate;
        // Compute the value of the sine wave at the current time step
        double value = amplitude * std::sin(2 * M_PI * frequency * time_step);
        sine_wave[n] = {value, 0.0};
    }

    return sine_wave;
}

/**
 * 
 */
std::vector<std::complex<double>> performFastFourierTransformSerial (const std::vector<std::complex<double>>& input_data) {
    // TODO PERFORM THE FFT SERIALLY
}


int main(int argc, char *argv[]) {
    cxxopts::Options options(
        "Fast_Fourier_Transfrom",
        "Calculate the Fourier Transform of a sine wave using serial execution.");
    options.add_options(
        "",
        {
            {"nSamples", "Number of Samples", 
            cxxopts::value<uint>()->default_value(DEFAULT_NUMBER_OF_SAMPLES)},
            {"amplitude", "Amplitude of the Sine Wave",
            cxxopts::value<double>()->default_value(DEFAULT_AMPLITUDE)},
            {"frequency", "Frequency of the Sine Wave",
            cxxopts::value<double>()->default_value(DEFAULT_FREQUENCY)},
            {"samplingRate", "Sampling Rate",
            cxxopts::value<double>()->default_value(DEFAULT_SAMPLING_RATE)}
        });

        auto cl_options = options.parse(argc, argv);
        uint n_samples = cl_options["nSamples"].as<uint>();
        double amplitude = cl_options["amplitude"].as<double>();
        double frequency = cl_options["frequency"].as<double>();
        double sampling_rate = cl_options["samplingRate"].as<double>();

        // Print the command line inputs
        std::cout << "Number of Samples: " << n_samples << std::endl;
        std::cout << "Amplitude: " << amplitude << std::endl;
        std::cout << "Frequency: " << frequency << " Hz" << std::endl;
        std::cout << "Sampling Rate: " << sampling_rate << " Hz" << std::endl;

        // Generate a sine wave to be used for Fast Fourier Transform
        auto sine_wave = generateSineWave(n_samples, amplitude, frequency, sampling_rate);

        // Perform Fast Fourier Transform serially
        auto fast_fourier_transform_result = performFastFourierTransformSerial(sine_wave);
}