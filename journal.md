# 8/25/25

- started with an idea, have no idea how to get there

- decided by going through the page on how to learn verilog, and watched things like the video, and after that I moved on to HDLbits for the rest of the hour, and I feel quite confused
- One of the things at the end of this hour that really confused me were vectors, especially the second problem related to them which introduces things like implicit wires and vector directions in endianness
- I'm also not used to it being possible to have a higher number for values towards the left (little endian)

<img width="1398" height="837" alt="image" src="https://github.com/user-attachments/assets/551ff2ef-bf6a-4439-be51-a47b9898ca3d" />

**time: 1h**

# 8/26/25

- Went through more of the vector stuff, and it's slowly starting to get clearer, but one of the things that was challenging was figuring out what a 4 input xor gate was.
- This would've been so much easier if I had known that there was a prebuilt xor operator in verilog, so I spent quite a bit of time trying to understand it.
- Otherwise, I feel that my progress is pretty good.

<img width="1321" height="756" alt="image" src="https://github.com/user-attachments/assets/738ed784-1b9a-456d-ba1b-712886625a50" />

**time: 1h**

- started on making new modules, and this part was actually pretty easy
- the most challenging part was creating my own full-adder, which was just me having to search up the truth table for one

- I also kept forgetting to create wires to have more than one bit, which makes my success rate REALLY low

<img width="1322" height="125" alt="image" src="https://github.com/user-attachments/assets/227be143-ac0e-4701-b665-3944fa8395e5" />


**time: 1h**

# 8/29/25

- Finished up the section for modules and breezed through the procedure section
- It did take a bit of research to understand nonblocking vs blocking assignments since hdlbits doesn't dive into the details, but since I was curious I decided to understand why one would be used in a different case

- If using blocking operators with registors and a clock, it updates a value before moving on, so a=b followed by b=a doesn't swap the values but instead makes both of them equal to b's initial
- If using nonblocking operators, all assignments are in parallel, so the above code would swap the values

- Anyways, next time should be where I can start working on the project

<img width="1311" height="705" alt="image" src="https://github.com/user-attachments/assets/619ef57f-743b-4119-9bf4-44163f7a2cff" />
