package com.hcsn.kidbook.framework;

import com.phonegap.DroidGap;

import android.os.Bundle;


public class BasicWebView extends DroidGap
{
    String launchURL = null;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        
        System.out.println("here0");
        if(this.appView == null)
        {
        	init();
        }
        
        System.out.println("here1");
        this.appView.getSettings().setAppCacheMaxSize(1024*1024*5);
        System.out.println("here2");
        this.appView.getSettings().setAppCacheEnabled(true);
        System.out.println("here3");
        this.appView.getSettings().setAppCachePath("/data/data/com.hcsn.kidbook.firstgrademath/cache");
        System.out.println("here4");
        this.appView.getSettings().setAllowFileAccess(true);
        System.out.println("here5");
        super.loadUrl(launchURL);
    }

    public String getLaunchURL()
    {
        return launchURL;
    }

    public void setLaunchURL(String launchURL)
    {
        this.launchURL = launchURL;
    }
}
