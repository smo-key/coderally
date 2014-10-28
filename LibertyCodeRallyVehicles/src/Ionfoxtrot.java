import com.ibm.coderally.agent.CRSFileLog;
import com.ibm.coderally.agent.DefaultCarAIAgent;
import com.ibm.coderally.api.agent.AIUtils;
import com.ibm.coderally.entity.agent.Entity;
import com.ibm.coderally.entity.cars.agent.Car;
import com.ibm.coderally.entity.obstacle.agent.Obstacle;
import com.ibm.coderally.geo.agent.CheckPoint;
import com.ibm.coderally.geo.agent.Point;
import com.ibm.coderally.geo.agent.Rotation;
import com.ibm.coderally.track.agent.Track;
import com.ibm.coderally.api.CodeRallyOptions;

public class Ionfoxtrot extends DefaultCarAIAgent {

	Track track = null;
	IonUtils.RaceStrategy racestrategy = IonUtils.RaceStrategy.RACE;
	Entity avoiditem = null;
	
	@Override
	public void init(Car car, Track track) {
		// Create Track Bezier Curve
		this.track = track;
		prevPosition = car.getPosition();
	}
	
	@Override
	public void onRaceStart() {
		getCar().setBrakePercent(0);
		getCar().setTarget(IonUtils.getClosestLane(getCar().getCheckpoint(), getCar().getPosition()));
		getCar().setAccelerationPercent(100);
	}
	
	@Override
	public void onTimeStep() {
		// Replace with custom logic or remove method for default implementation.
		
		// Variable preparation
		CheckPoint cp = getCheckpointTarget(); //get closest checkpoint path
		Point pos = getCar().getPosition();
		Rotation rot = getCar().getRotation();
		
		CodeRallyOptions options = new CodeRallyOptions();
		long t = options.getMovementTimestep();
		
		Point target = IonUtils.getClosestLane(cp, pos);
		
		/*if (avoiditem != null)
		{
			if (Math.sqrt(avoiditem.getPosition().getDistanceSquared(pos)) < 100)
			{
				
			}
		}*/
				
		//avoid the item
		getCar().setTarget(IonUtils.avoidTarget(getCar(), cp, avoiditem));
		IonUtils.recalculateHeading(getCar(), target, 0.5D); // 0.5 bias to force the car to turn sharply to avoid
		prevPosition = getCar().getPosition();
		
		// Acceleration and Turning
		// 100% Accel, 50% Turning Radius (/2)
		// 100% Brake, 200% Turning Radius (x2)
		
		// Checkpoint handling
		// You can be within 40 pixels of a checkpoint
	}
	
	public CheckPoint getCheckpointTarget()
	{
		// Variable preparation
		CheckPoint cp = getCar().getCheckpoint();
		Point pos = getCar().getPosition();
		Rotation rot = getCar().getRotation();
		//Point target = IonUtils.getClosestLane(cp, pos);
		
		// Move toward next points to calculate speed
		if (Math.sqrt(IonUtils.cpdist(pos, rot, cp)) < 140)
		{
			if (Math.sqrt(IonUtils.cpdist(pos, rot, cp)) < 80)
			{
				//turn somewhat toward next checkpoint if current is within reach
				cp = track.getNextCheckpoint(track.getNextCheckpoint(cp));
				//target = IonUtils.getClosestLane(cp, pos);
			}
			else
			{
				//turn somewhat toward next checkpoint if current is within reach
				cp = track.getNextCheckpoint(IonUtils.getNextCheckpoint(track, cp, 2));
				//target = IonUtils.getClosestLane(cp, pos);
			}
		}
		
		//recalculate speed from a heading of four checkpoints away
		IonUtils.recalculateHeading(getCar(), IonUtils.getClosestLane(
				IonUtils.getNextCheckpoint(track, cp, 4), 
				pos), 0.8); //higher bias, faster turns
		
		return cp;
	}
	
	@Override
	public void onCheckpointUpdated(CheckPoint oldCheckpoint) {
		// Replace with custom logic or remove method for default implementation.
		getCar().setBrakePercent(0);
		getCar().setAccelerationPercent(100);
		getCar().setTarget(IonUtils.getClosestLane(getCar().getCheckpoint(), getCar().getPosition()));
	}
	
	@Override
	public void onOpponentInProximity(Car car) {
		// Check if opponent directly in front of movement path
		// If so, move to avoid it
		
		// TODO Add all opponents to a list, check if already exist then add
		// Every frame, check if path intersects with them
		
		Point pos = getCar().getPosition();
		CheckPoint cp = getCheckpointTarget();
		Point target = IonUtils.getClosestLane(cp, pos);
		
		avoiditem = car;
		getCar().setTarget(IonUtils.avoidTarget(getCar(), cp, avoiditem));
		IonUtils.recalculateHeading(getCar(), target, 0.5D);
	}
	
	@Override
	public void onObstacleInProximity(Obstacle obstacle) {
		/*Point pos = getCar().getPosition();
		CheckPoint cp = getCheckpointTarget();
		Point target = IonUtils.getClosestLane(cp, pos);
		
		avoiditem = obstacle;
		getCar().setTarget(IonUtils.avoidTarget(getCar(), cp, avoiditem));
		// 0.5 bias to force the car to turn sharply to avoid
		IonUtils.recalculateHeading(getCar(), target, 0.5D);*/
	}
	
	@Override
	public void onCarCollision(Car other) {
		
	}
	
	@Override
	public void onObstacleCollision(Obstacle obstacle) {
		// Provide custom logic or remove method for default implementation.		
	}

	@Override
	public void onOffTrack() {
		// Provide custom logic or remove method for default implementation.		
	}

	@Override
	public void onStalled() {
		// Provide custom logic or remove method for default implementation.		
	}

}
