
#!/bin/bash

echo "Running application tests..."

if [ -f app.sh ]; then
    echo "PASS: Application file exists"
else
    echo "FAIL: Application file missing"
    exit 1
fi

echo "All tests completed successfully!"
