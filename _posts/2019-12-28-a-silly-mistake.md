---
layout: post
title: A silly mistake
date: 2019-12-28 14:45 -0800
tags:
  - AI
  - Mistakes
  - Testing
  - Learning
---

I was working on an assignment whose problem statement was like this - 
> You are writing a program that guides a robot over terrain from a starting location to a destination. The program gets a two-dimensional matrix where the indexes define the x and y coordinates. The elements represent the elevation of the terrain. I was to use different search algorithms such as A*, BFS, and UCS.

I finished my assignment well on time and was also happy with the design. I used the strategy pattern and would choose the relevant algorithm based on the input. I spent days designing the right heuristic for A* search. Though I invested a lot of time and effort into the assignment, I got a meager 22%. It turns out that I read the input incorrectly for reading the elevation (swapped places of X and Y). Here's the two letter change which would fix my code - 

```diff
-        landing.setZ(terrainMap.get(landing.getX()).get(landing.getY()));
+        landing.setZ(terrainMap.get(landing.getY()).get(landing.getX()));
```

Although I was initially frustrated with myself, I realized the consequences of code which has on people. For me, it was almost harmless, since I lost a few marks. However, code can also affect the lives of a lot of people. This assignment taught me more about the effects of code that have on the world than about the search algorithms. I feel that it is important for every person who writes code to understand its implications on the world and proceed with caution.

Another aspect is about testing. Although it is not possible to test every possible scenario for all non-trivial code, it shows that there is a need for improving my testing. In my next assignment, I stuck to Test-driven development (TDD) which took a bit of extra time but ensured that I covered almost all major scenarios.

I end this blog post by a slightly modified quote of Martin golding - 
> Always code as if the person who ends up using or maintaining your code is a violent psychopath who knows where you live
