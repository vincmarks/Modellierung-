"""
Modellierung I -- Blatt 3, Aufgabe 2
Template fuer implizite und explizite Kurven.

Aufgabe: Implementieren Sie die mit `pass` markierten Funktionen.
Plot-Helfer und Beispielausgaben sind bereits vollstaendig vorgegeben.
"""

import matplotlib.pyplot as plt
import numpy as np

RESOLUTION = 128


# ---------- Plot-Helfer (vorgegeben) ---------------------------------
def plot_implicit(f, eps=1e-2):
    """Setzt Pixel auf 1 wenn |f(x,y)| < eps -- nahe der Niveaumenge {f=0}."""
    x = np.linspace(-2, 2, RESOLUTION)
    y = np.linspace(-2, 2, RESOLUTION)
    X, Y = np.meshgrid(x, y)
    Z = f(X, Y)
    return np.abs(Z) < eps


def plot_explicit(f, step_size=1e-3):
    """Folgt der Parametrisierung f: [0,1] -> R^2 und setzt Pixel."""
    Z = np.zeros((RESOLUTION, RESOLUTION))
    for t in np.arange(0, 1, step_size):
        x, y = f(t)
        ix = int(x * RESOLUTION / 4 + RESOLUTION / 2)
        iy = int(y * RESOLUTION / 4 + RESOLUTION / 2)
        if 0 <= ix < RESOLUTION and 0 <= iy < RESOLUTION:
            Z[ix, iy] = 1
    return Z


# ---------- Implizite Funktionen ------------------------------------
def circle_implicit(x, y):
    """Niveaumenge x^2 + y^2 - 1 = 0 (Einheitskreis)."""
    return x**2 + y**2 - 1


def square_implicit(x, y):
    """Rand des Quadrats mit Ecken bei (+/-1, +/-1)."""
    return np.maximum(np.abs(x), np.abs(y)) - 1


def mandelbrot_implicit(x, y):
    """1 ausserhalb, 0 innerhalb des Mandelbrot-Sets.

    Iteriere f_0 = 0, f_{n+1} = f_n^2 + (x + i y); innerhalb wenn |f_10| < 2.
    Tipp: in Python ist  c = x + 1j*y  ein komplexer NumPy-Array.
    """
    c = x + 1j * y
    f = np.zeros_like(c)
    for _ in range(50):
        f = np.where(np.abs(f) < 2, f**2 + c, f) # Gibt 0 an der Grenze zurück (wo |f| ≈ 2)
    return np.abs(f) - 2


# ---------- Explizite Funktionen ------------------------------------
def circle_explicit(t):
    """Parametrisierung des Einheitskreises fuer t in [0, 1]."""
    return np.cos(2 * np.pi * t), np.sin(2 * np.pi * t)


def square_explicit(t):
    """Lauf entlang der Quadratseiten -- Ecken (+/-1, +/-1) -- fuer t in [0, 1]."""
    t = 4 * t % 4
    if 0 <= t < 1:
        return -1, -1 + t
    elif 1 <= t < 2:
        return -1 + (t - 1), 1
    elif 2 <= t < 3:
        return 1, 1 - (t - 2)
    else:
        return 1 - (t - 3), -1


def spiral_explicit(t):
    """Spirale, die im Ursprung startet und mind. 3 Umdrehungen macht."""
    r = t
    theta = 2 * np.pi * 3 * t
    return r * np.cos(theta), r * np.sin(theta)


# ---------- Plotten -------------------------------------------------
if __name__ == "__main__":
    fig, ax = plt.subplots(3, 2, figsize=(5, 8))
    for a in ax.flatten():
        a.axis("off")

    ax[0, 0].imshow(plot_implicit(circle_implicit))
    ax[0, 0].set_title("Circle Implicit")
    ax[0, 1].imshow(plot_explicit(circle_explicit))
    ax[0, 1].set_title("Circle Explicit")

    ax[1, 0].imshow(plot_implicit(square_implicit))
    ax[1, 0].set_title("Square Implicit")
    ax[1, 1].imshow(plot_explicit(square_explicit))
    ax[1, 1].set_title("Square Explicit")

    ax[2, 0].imshow(plot_implicit(mandelbrot_implicit))
    ax[2, 0].set_title("Mandelbrot Implicit")
    ax[2, 1].imshow(plot_explicit(spiral_explicit))
    ax[2, 1].set_title("Spiral Explicit")

    plt.tight_layout()
    plt.show()
