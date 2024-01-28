/* auxiliary rules for agents */

i_am_winning(Art)   // check if I placed the current best bid on auction artifact Art
   :- currentWinner(W)[artifact_id(Art)] &
      .my_name(Me) & .term2string(Me,MeS) & W == MeS.

/* auxiliary plans for Cartago */


//send to gicamo for every company

+!start : true
   <- for ( my_task(Task) ) {
          .concat("auction_for_",Task,Result);
          !discover_art(Result);
          !present_skills;
      }.


+winner(Skill) : true
   <-
      .my_name(Me);
      out("Winner", Me, Skill);
      .print(Me, " wins A ", Skill);
      rd("Winner", You, Os);
      .print(Me, "Win B", Skill, " and ", You, " win ", Os).
 
      
+winner(Task) : true
   <-
      .my_name(Me);
      out("Winner", Me, Task);
      .print("A wins ", Task);
      !!readOtherTous(Task);
. 

+!readOtherTous(Task): true
      <-
      +knownTask(Task);
      for (task_roles(T,R)){
         if (not knownTask(T)){
            +knownTask(Task);
            !!readOneTask(T);
            .print("B ", " read ", T);
         }
      }
   .

+!readOneTask(Task) : true
<-
   rd("Winner", You, Task);
   .print("C ", You, " Wins ", Task  );
.

+!present_skills
   <- .print("Presenting skills to giacomo");
      ?my_task(Task); // Retrieve the task the company can perform
      .send(giacomo, tell, my_skill(Task)). // Send the skill (task) to giacomo


// try to find a particular artifact and then focus on it
+!discover_art(ToolName)
   <- lookupArtifact(ToolName,ToolId);
      focus(ToolId).
// keep trying until the artifact is found
-!discover_art(ToolName)
   <- .wait(100);
      !discover_art(ToolName).
