# Compiler and flags
CXX = g++
CXXFLAGS = -O3 -std=c++11 -Wall

# Libraries
LIBS = -lpthread -lssl -lcrypto

# Directories
SRC_DIR = src
BUILD_DIR = build

# Sources and objects
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

# Output binary
TARGET = miner

# Default rule
all: $(TARGET)

# Create output directory if not exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile sources to object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Link the object files to create the executable
$(TARGET): $(OBJECTS)
	$(CXX) $(OBJECTS) $(LIBS) -o $(TARGET)

# Clean up build files
clean:
	rm -rf $(BUILD_DIR) $(TARGET)

# Install (example for termux)
install:
	cp $(TARGET) /data/data/com.termux/files/home/

.PHONY: all clean install
