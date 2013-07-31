package com.hcsn.kidbook.firstgrademath;

import com.hcsn.kidbook.framework.BasicWebView2;
import com.hcsn.kidbook.framework.BasicWebView;
import android.os.Bundle;
import com.google.ads.*;

public class StartActivity extends BasicWebView2
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        setLaunchURL("http://hcsn34.appspot.com/firstgrademath/index.html");
        super.onCreate(savedInstanceState);
    }

}
