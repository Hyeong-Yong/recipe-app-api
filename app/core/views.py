"""
Core views for app.
"""
from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view(["GET"])
def health_check(request):
    """Returns successful response..."""
    return Response({"healthy": True})


@api_view(["GET"])
def test_check(request):
    """Return test_check response.."""
    return Response(
        {
            "name": "Hyeongyong",
            "email": "hyeongyong@gmail.com",
        },
    )
