## Buoyviz dashboard implemented in R and Shiny

This repository implements the visualization of buoy data that is already developed in python in the [buoyviz](https://bitbucket.org/AIAscience/buoyviz) repository but in this case we use R and shiny.

For this purpose we use the same server.py script that exist in the buoyviz repository to load real-time data, convert them to JSON or CSV and serve it. 


To run the example run:
         
         FLASK_APP=server.py flask run --reload
   and then run the .r script 
