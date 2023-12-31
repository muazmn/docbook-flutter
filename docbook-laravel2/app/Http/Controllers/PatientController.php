<?php

namespace App\Http\Controllers;

use App\Models\Appointment;
use App\Models\Comment;
use App\Models\Doctor;
use App\Models\Patient;
use App\Models\Specialization;
use App\Models\TmpComment;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class PatientController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Patient $patient)
    {
        $appointmentData = DB::table('appointments')->where('patient_id', $patient->patient_id)
            ->join('users', 'users.id', '=', 'appointments.doctor_id')->select('appointments.*', 'users.name as doctor_name')->latest()->get();
        return view('check-appointment', [
            "title" => "search record",
            "container" => "generalContainer",
            "patients" => $appointmentData
        ]);
    }


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function showDetails()
    {
        echo json_encode(Appointment::where('appointments.id', $_POST['id'])->get()[0]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Patient $patient)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    // mobile 
    public function update(Request $request)
    {
        $user = User::where('id', Auth::user()->id)->first();
        $patient = Patient::where('patient_id', Auth::user()->id)->first();
        $user->update([
            'name' => $request->name
        ]);
        $patient->update([
            'phone_no' => $request->phone_no
        ]);

        return response()->json(['message' => 'Data updated successfully']);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Patient $patient)
    {
        //
    }
    public function showData()
    {
        $user = array();
        $user = Auth::user();
        $doctor = User::where('type', 'doctor')->get();
        $specializations = Specialization::all();
        $comments = Comment::all();
        $doctorData = Doctor::all();
        $patientData = Patient::where('patient_id', Auth::user()->id)->get();

        foreach ($doctorData as $data) {
            foreach ($specializations as $specialization) {
                // foreach ($comments as $comment) {
                // && $data['doc_id'] == $comment['doctor_id']
                foreach ($doctor as $info) {
                    if ($data['doc_id'] == $info['id'] && $data['specialization_id'] == $specialization['id']) {
                        $data['doctor_name'] = $info['name'];
                        $data['doctor_profile'] = $info['profile_photo_path'];
                        $data['specialization_name'] = $specialization['name'];
                        // $data['comments'] = $comment['comment'];
                        // $data['commentDate'] = $comment['created_at'];
                    }
                }
                foreach ($patientData as $pd) {
                    $user['mobile_number'] = $pd['phone_no'];
                    // }
                    // }
                }
            }
        }

        $user['doctor'] = $doctorData;
        return $user;
    }

    public function storeComment(Request $request)
    {
        $comments = new TmpComment();

        $comments->patient_id = Auth::user()->id;
        $comments->doctor_id = $request->get('doctor_id');
        $comments->comment = $request->get('comment');
        $comments->save();

        return response()->json(200);
    }

    public function deleteAppointment(Appointment $appointment)
    {
        $appointment->delete();
        return redirect('patient-record/' . Auth::guard('patient')->user()->user_name)->with('success', 'Appointment deleted succesfully');;
    }
    public function updateAppointmentToComplete(Appointment $appointment)
    {
        $appointment->update(['status' => 'completed']);
        return redirect('patient-record/' . Auth::guard('patient')->user()->user_name)->with('success', 'Appointment updated succesfully');;
    }
}
