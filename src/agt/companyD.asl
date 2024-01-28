// This company bids for all tasks
// Strategy: bids a random value

// Inclusion of standards agent's behavior to make agents able to work in an JaCaMo environment
{ include("$jacamoJar/templates/common-cartago.asl") }
// Inclusion of common behaviors for this application
{ include("common.asl") }

// initial belief
my_task("SitePreparation").
my_task("Floors").
my_task("Walls").
my_task("Roof").
my_task("WindowsDoors").
my_task("Plumbing").
my_task("ElectricalSystem").
my_task("Painting").

reputation(8).

// initial goal to discover artifact
!start.

+task(S)[artifact_id(Art)]
   <- .wait(math.random(500)+50);
      Bid = math.floor(math.random(10000))+800;
      //.print("my bid in auction artifact ", Art, " is ",Bid);
      bid( Bid )[artifact_id(Art)]. // recall that the artifact ignores if this
                                    // agent places a bid that is higher than
                                    // the current bid




// Plan to handle invitation
+message(content, senderName)[performative(request)]
   : content == "You are invited to participate in auctions based on your reputation"
   <- .print("Received invitation from ", senderName, " to participate in auctions");
      !prepare_for_auction.

// Plan to prepare for auction
+!prepare_for_auction
   <- .print("Preparing for auction participation");
      // Assuming the agent knows the tasks it can perform
      for ( my_task(Task) ) {
          .concat("auction_for_", Task, AuctionName);
          .print("Looking for auction: ", AuctionName);
          !discover_art(AuctionName); // Discover and focus on the auction artifact
      }.


/* plans for execution phase */

{ include("org_code.asl") }
{ include("skills.asl") }
