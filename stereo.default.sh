### Stereo 2.2.0 Default File
## Modified to include all parameters by Jon Walmsley July 2013
## Modified by FF May25 to test ASP 2.6
# -*- mode: sh -*-

# Pre-Processing / stereo_pprc
################################################################

# Pre-alignment options
#
# Available choices are (however not all are supported by all sessions):
#    NONE           (Recommended for anything map projected)
#    EPIPOLAR       (Recommended for Pinhole Sessions)
#    HOMOGRAPHY     (Recommended for ISIS wide-angle shots)
#    AFFINEEPIPOLAR (Recommended for ISIS narrow-angle and DG sessions)
alignment-method NONE

# Force-Use-Entire-Range (default = false)
#
# False - Normalizes ISIS images to +/- 2 standard deviations from a mean value of 1.0
# True - Disables normalization and forces the raw values to pass directly to stereo
force-use-entire-range false

# Select a preprocessing filter:
#
# 0 - None
# 1 - Subtracted Mean
# 2 - Laplacian of Gaussian (recommended)
prefilter-mode 2

# Kernel size (1-sigma) for pre-processing
#
# Recommend 1.4 px for Laplacian of Gaussian
# Recommend 25 px for Subtracted Mean
prefilter-kernel-width 1.4

# Integer Correlation / stereo_corr
################################################################

# Select a cost function to use for initialization:
#
# 0 - absolute difference (fast)
# 1 - squared difference  (faster .. but usually bad)
# 2 - normalized cross correlation (recommended)
# 3 - census transform (Need SGM stereo-algorithm)
# 4 - ternary census transform (Need SGM stereo-algorithm)
cost-mode 4

# Initialization step: correlation kernel size
corr-kernel 9 9 

# Initializaion step: correlation window size
 #corr-search -80 -2 20 2

#stereo-algorithm (default = 0)
# 0 - Local Search Window
# - The default option searches for the best match for a local window
# around each window using the selected cost mode. This is the fastest algorithm and works well
# for similar images with good texture coverage.
# 1 - Semi-Global Matching
# This algorithm is slow and has high memory requirements but it performs better in images with less texture. See section 7.2.4
# for important details on using this algorithm.
# 2 - Smooth Semi-Global Matching
#  Uses the MGM variant of the SGM algorithm [24] to reduce
# high frequency artifacts in the output image at the cost of increased run time. See section 7.2.4
# for important details on using this algorithm.
stereo-algorithm 2

# Corr-tile-size - supposedly important (default= 1024)
#corr-tile-size 1024


# Subpixel Refinement / stereo_rfne
################################################################

# Subpixel step: subpixel modes
#
# 0 - disable subpixel correlation (fastest)
# 1 - parabola fitting (draft mode - not as accurate)
# 2 - affine adaptive window, bayes EM weighting (slower, but much more accurate)
# 3 - affine window, (intermediate speed, results similar to bayes EM)
# 4 - Lucas-Kanade method (experimental)
# 5 - affine adaptive window, Bayes EM with Gamma Noise Distribution (experimental)
subpixel-mode 3

# Subpixel step: correlation kernel size
subpixel-kernel 35 35

# Post Filtering / stereo_fltr
################################################################

# Fill in holes up to 100,000 pixels in size with an inpainting method
# disable-fill-holes

# Automatic "erode" low confidence pixels
filter-mode 1
rm-half-kernel 5 5
max-mean-diff 3
rm-min-matches 60
rm-threshold 3
rm-cleanup-passes 1

# Triangulation / stereo_tri
################################################################

# Size max of the universe in meters and altitude off the ground.
# Setting both values to zero turns this post-processing step off.
near-universe-radius 0.0
far-universe-radius 0.0
