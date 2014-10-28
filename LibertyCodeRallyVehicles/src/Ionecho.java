import java.util.List;

import org.jbox2d.common.Vec2;

import com.ibm.coderally.agent.DefaultCarAIAgent;
import com.ibm.coderally.api.agent.AIUtils;
import com.ibm.coderally.entity.agent.Entity;
import com.ibm.coderally.entity.cars.agent.Car;
import com.ibm.coderally.entity.obstacle.agent.Obstacle;
import com.ibm.coderally.geo.agent.CheckPoint;
import com.ibm.coderally.geo.agent.Point;
import com.ibm.coderally.track.Race;
import com.ibm.coderally.track.agent.Track;

public class Ionecho extends DefaultCarAIAgent {
	
	/**** BASE OVERRIDES ****/	
	
	@Override
	public void init(Car car, Track track) {
		// Provide custom logic or remove method for default implementation.
		
		double maxangle = getCar().calculateMaximumTurning(0);
		System.out.println("Car maximum angle: " + maxangle);
		
		/*List<CheckPoint> checkpoints = track.getCheckpoints();
		for (int i=0; i < checkpoints.size(); i++)
		{
			CheckPoint cp = checkpoints.get(i);
			System.out.println(cp.getStart().getX() + "," + cp.getStart().getY());
		}*/
	}
	
	@Override
	public void onRaceStart() {
		getCar().setAccelerationPercent(100);
		getCar().setBrakePercent(0);
		getCar().setTarget(getCar().getCheckpoint().getCenter());
	}

	@Override
	public void onCheckpointUpdated(CheckPoint oldCheckpoint) {
		// Replace with custom logic or remove method for default implementation.
		getCar().setAccelerationPercent(100);
		getCar().setBrakePercent(0);
		CheckPoint cp = getCar().getCheckpoint();
		getCar().setTarget(cp.getCenter());
	}

	@Override
	public void onObstacleInProximity(Obstacle obstacle) {
		// Provide custom logic or remove method for default implementation.		
	}

	@Override
	public void onOffTrack() {
		// Provide custom logic or remove method for default implementation.		
	}

	@Override
	public void onOpponentInProximity(Car car) {
		// Provide custom logic or remove method for default implementation.	
		//int dist = (int) distance(getCar().getPosition(), car.getPosition());
		//System.out.println("Opponent within " + dist + "!");
		getCar().setTarget(AIUtils.getAlternativeLane(getCar().getCheckpoint(), getCar().getPosition()));
	}

	@Override
	public void onTimeStep() {
		// Recalculate heading
		AIUtils.recalculateHeading(getCar());
		
		// Head towards closest checkpoint
		CheckPoint cp = getCar().getCheckpoint();
		
		double heading = IonUtils.angle(getCar().getVelocity());

		//get differences in angle, smallest wins
		double center = Math.abs(heading - IonUtils.angle(getCar().getPosition(), cp.getCenter()));
		double end = Math.abs(heading - IonUtils.angle(getCar().getPosition(), cp.getEnd()));
		double start = Math.abs(heading - IonUtils.angle(getCar().getPosition(), cp.getStart()));
		
		// Get closest checkpoint
		Point closest = cp.getCenter();
		double closestd = center; //closest angle
		if (end < closestd) { closestd = end; closest = cp.getEnd(); }
		if (start < closestd) { closestd = start; closest = cp.getStart(); }
		
		// Go to closest checkpoint
		getCar().setTarget(closest);
		
		// Brake to scale acceleration to certain amount (greater angle, lower acceleration)
		
		// Later, try difference between current heading vector and current acceleration vector
		// to change speed: more current turning, slower car
		
		double accelheading = IonUtils.angle(getCar().getAcceleration());
		double headingdiff = 45 - Math.abs(heading - accelheading);
		double accel = 100 * Math.cos(Math.abs(headingdiff) / 180 * Math.PI);
		
		double v = getCar().getVelocity().normalize();
		double a = getCar().getAcceleration().normalize();
		double t = 1;
		
		double framedist = (v*t) + (0.5*a*t*t);
		
		if (framedist > 200)
		{
			getCar().setAccelerationPercent(0);
			getCar().setBrakePercent(0);
		}
		else
		{
			getCar().setAccelerationPercent((int) accel);
			getCar().setBrakePercent((int) (100 - accel));
		}		
		
		// Recalculate heading
		AIUtils.recalculateHeading(getCar());
	}

	@Override
	public void onCarCollision(Car other) {
		// Provide custom logic or remove method for default implementation.		
	}
	
	@Override
	public void onObstacleCollision(Obstacle obstacle) {
		// Similar to onCarCollision, this will help you reorient
		// yourself if an obstacle does affect your position
	}

	@Override
	public void onStalled() {
		// If your vehicle stops moving for any reason, this event is called so you can
		// adjust whatever you need to.
	}
	
	
	/**** LOGIC METHODS ****/
	
	public Point avoidTarget(Entity entity) {
		CheckPoint point = getCar().getCheckpoint();
		Point target;
		//Find the closer target
		if (point.getEnd().getDistanceSquared(entity.getPosition()) < point.getStart().getDistanceSquared(entity.getPosition())) {
			//The closer target is not better if it requires > 2x turning
			if (getCar().calculateHeading(point.getEnd()) * 2 < getCar().calculateHeading(point.getStart())) {
				target = point.getEnd();
			} else {
				target = point.getStart();
			}
		} else {
			//The closer target is not better if it requires > 2x turning
			if (getCar().calculateHeading(point.getStart()) * 2 < getCar().calculateHeading(point.getEnd())) {
				target = point.getStart();
			} else {
				target = point.getEnd();
			}
		}
		return target;
	}
	
}
