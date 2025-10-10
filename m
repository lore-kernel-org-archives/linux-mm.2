Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E5CCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 16:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26A88E0045; Fri, 10 Oct 2025 12:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD77B8E002C; Fri, 10 Oct 2025 12:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13BA8E0045; Fri, 10 Oct 2025 12:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE18F8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:06:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AD6D8511D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:06:29 +0000 (UTC)
X-FDA: 83982682098.15.EB83733
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3883F14001C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:06:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=orange.fr header.s=t20230301 header.b="ENVThVq/";
	spf=pass (imf26.hostedemail.com: domain of pierre.juhen@orange.fr designates 80.12.242.28 as permitted sender) smtp.mailfrom=pierre.juhen@orange.fr;
	dmarc=pass (policy=quarantine) header.from=orange.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760112387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9LKz9TfatzR5oj0sRGOBIERUL/UsRRQbmE8TQHM27A=;
	b=7AOLCAxywl6nuPwaRWhaOuKzOQMaFuZGcUKsCXJL55p7t4wpoE6u9rjVBKBrd1z6k2z7/+
	6M/OX96x/ixHV4R384KgZE7LK+pglKxqChL0TZt2HG/7AQvYUj15iN66tmFW0HK3wGYIdb
	Icc36VC2qXrNsCiUetDITOEhzGBqlnk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=orange.fr header.s=t20230301 header.b="ENVThVq/";
	spf=pass (imf26.hostedemail.com: domain of pierre.juhen@orange.fr designates 80.12.242.28 as permitted sender) smtp.mailfrom=pierre.juhen@orange.fr;
	dmarc=pass (policy=quarantine) header.from=orange.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760112387; a=rsa-sha256;
	cv=none;
	b=4w7PpN3hgiFLajZd7JDoE7657hfWpV3qVNtUf0CbvSCs6j7txzPswxnCC1kO2q+ZO7NB81
	79qePSFcO6U9+BOa5zIJEJcdb2aqVc4JBG2dBNgPkjgZoAz8X3ZobKINOrhr9QfFf5mAMr
	fPuMlfZ57SSiYTAFacV4PBwLDzyPp4M=
Received: from [192.168.1.7] ([82.125.151.155])
	by smtp.orange.fr with ESMTPA
	id 7FdQvFkdNU6ij7FdQvRy4l; Fri, 10 Oct 2025 18:06:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.fr;
	s=t20230301; t=1760112385;
	bh=q9LKz9TfatzR5oj0sRGOBIERUL/UsRRQbmE8TQHM27A=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=ENVThVq//jUpbwkB8DJB96i8YSvBX19nb68f9LsvzXXoRLIr9ASg4Dskru2EIjR0g
	 6eCKuXyUtypSpWsgM2q7ni7razHBhbcnX2EuGAF8hHdRYIpuOaZ//uCFgqiPBlWN5r
	 1q+rGGfhxKY08/INu16l38EMrSRvyMDYwzcQ9dOWVWPUtjGSlzpixSfAWQeKpyZDjg
	 xh0TBuIsi71u1iCytUx0uKvwSvj8J30GmremxU181RaEvOYa3XsurRVskrVfEkdL0p
	 +VtLo2oRWVJ1NjSqCExbYeC98EOWJ/pFlqVN7Dj9YcKWwcOSM+KSQ0ZbbIJiYsd8x+
	 gRPhhB5d1361g==
X-ME-Helo: [192.168.1.7]
X-ME-Auth: cGllcnJlLmp1aGVuQG9yYW5nZS5mcg==
X-ME-Date: Fri, 10 Oct 2025 18:06:25 +0200
X-ME-IP: 82.125.151.155
Content-Type: multipart/alternative;
 boundary="------------Zbj4dXx6pCs05ft0UEs0zgOl"
Message-ID: <d2729b26-1bde-41aa-8e2e-b6ca861185b3@orange.fr>
Date: Fri, 10 Oct 2025 18:06:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 220605] New: Very slow access on HDD when a swap partition
 is used on this HDD on kernel 6.16
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bugzilla-daemon@kernel.org, linux-mm@kvack.org
References: <bug-220605-27@https.bugzilla.kernel.org/>
 <20250929160727.a0119e93688378c570a3c550@linux-foundation.org>
Content-Language: fr, en-GB, en-US
From: Pierre Juhen <pierre.juhen@orange.fr>
In-Reply-To: <20250929160727.a0119e93688378c570a3c550@linux-foundation.org>
X-Rspamd-Queue-Id: 3883F14001C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: k5wyrxpn6akk6j3gh5tnmb9jyy4qgtym
X-HE-Tag: 1760112386-150414
X-HE-Meta: U2FsdGVkX19fPsJvHd3dpsXgMlFbLONtGk0XLoP61JpjpiVxJ/Rmon33pNUDDJWjwlF3/36P89eRavHCDMX/9uNNMLQEpZ8I1giMrFsBq/cNdhNlMDZs3+NhQFCFqLCNAVHUbnTf6yKMDTBZWImtByAmY/qG0gcQNlNlPqwMKoAJdoVfJarDf3GbKyCu580Kq38G5YY0uQH7HC39wfual0QaZz7DP4coOK4mpfRVnb1/2GcIUlxTMpuTebaEfh6CTkyTcqxNOzElT90iDyB3tFEc7LpwwGQdT99D+hvcT4CWhBhVuKGRpotyKI8Sw/p/SSIy/YsLdELJtGETH0uq19fefndJQfOrrtfzWjdh1G0iAqx266MV3km+YL83f2KTsttZ/iVlWkLXL2e7htJ4tVFD2AXx+EVSEduilHamHID7u099lpc/Z/CJjiE1GcXMM52HUUsAJsgGxVOTwFVL3og9Ta/g7YGNNqY71t/nZGB64HmLkdjOPhnUQgG0zP7e8CYrAtDsUbi3lS8/h1fhtVcwkxJzBiqa3BbOinBiDARdiWyZaptAET7eV4PHffXO2E4YskvR+xdJN//Le6FUOagaA0z7S5m/7BFWv7UrKxd0k+PgbBZhEJ+iV6djKJmNJl/rEMgiSO0R6qUV8edlqQLtroUO4kR9q7wjKlMUdSdBYmSfBzfakWdjMtoWT5t6NipNwJa6/XdtjjSWkEle+9aG4BhSfsRcGHckU5gCjyNxH564VRoG3ZKiqho0UjJ45QR2Q7t6XkIkQamj7s82x+AQ698BoYNeDReuhng59MrYncNA4FcOcuMOaiSTjG7fIXOJt/dP5Ilgwdxue9f28NahJZO6Vpe4m1ChTT9kX6vqFjVmJaI+wM4yHUSEm4kI6jd1tF0U7EEwlSd2ncnRdXc1yPtDHK/fm+y3IQuzd5pS0DTNxOQlLmaZOMzKvj4nj6nlolLp11dec3KemQl
 YjZu1Ep+
 5moBApk8L1wmzyO3loSTCCJlSRBiEz1WDYHWKoVIZJFK3emBQ7dizZan3Abr7OIS5KEfSLkxtwqaTqPuV2oOehuf13lGzElsSm7D3IUbBxv3RDuJiFYojAY4DW7YW7qn+dhGTGkPazjeVFaKEjawKSwNZr0pEcJxmzS0ExT86GPfbHMuEbRZACDiilurH1sbbiiL9vhlQ7WeEvJWNU+O9XtIfPqykjhVH1CuE1LrFmyXUQn2GUXYV7HP0BGC+eAIg8tB2tSnM4F+LoJaDfodQCjuyT4C5adti8LhemNNDuCN2Ys2xYcNv896ZtTDGyCTfu/AkFPzErV1ST/TU7SyFFKvC9L29SAnu+2DjkuNoN6NUqUrZkuVuEsC/foQQWudEzqP7a0+fLxfkfQvh6hd4O8OH/jIbusF59ZtLvw30pF/dHKzMFx7RAvCSvZKhIl4dnVDScl1mc7GDGeEtsxib8JZx5mniwEL0ZxXnRX12FqzkJbnh1O3RaGKNPVUhGerfuAWEZ1zpBC+Tv13+xqzDa/Qwhhotn0yTT/HCQbkZiePxFJNSaOF9gPrro5twQZnDbG0KJ9VuewtHjeiuAY422wlRXopdOR33p2y9tGEa5aAy8ACVlX9m9TN8rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------Zbj4dXx6pCs05ft0UEs0zgOl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Andrew and people reading those lists,

I still struggle to understand what is wrong with me.

I rebuilt my mdadm + bcache array to be sure it was not something linked 
to a (too) old configuration. Upgrading to 6.16.10 didn't change anything.

One symptom of the problem I identified is the time of the swapoff 
command (I have 32G, 12G are free and there is less than 1G in the swap)

MiB Mem : 31952,0 total, 12646,2 free,  2226,8 used, 17587,5 buff/cache
MiB Swap: 36000,0 total, 35212,2 free,   787,8 used. 29725,2 avail Mem


*$ time sudo swapoff -a
* *
real6m41,276s
user0m0,005s
sys0m0,028s*

Waiting for more than  6 minutes elapsed for 33 ms of work is bizarre.

During that time, if I try to launch another tab with *iotop*, nothing 
is displayed during at least one minute.

During that time, my computer is almost idle.

So it looks like swapoff and iotop are stucked, waiting for some kind of 
a semaphore inside the kernel.

Any idea  to dig further ?

Thanks,

Pierre

Le 30/09/2025 à 01:07, Andrew Morton a écrit :
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Sat, 27 Sep 2025 08:07:59 +0000bugzilla-daemon@kernel.org wrote:
>
>> https://bugzilla.kernel.org/show_bug.cgi?id=220605
>>
>>              Bug ID: 220605
>>             Summary: Very slow access on HDD when a swap partition is used
>>                      on this HDD on kernel 6.16
>>             Product: Memory Management
>>             Version: 2.5
>>            Hardware: Intel
>>                  OS: Linux
>>              Status: NEW
>>            Severity: high
>>            Priority: P3
>>           Component: Page Allocator
>>            Assignee:akpm@linux-foundation.org
>>            Reporter:pierre.juhen@orange.fr
>>          Regression: No
>>
>> Hello everybody,
>>
>> I have a strange behavior on my system (Fedora 42 up to date => kernel 6.16.8).
> You certainly do.  I wonder what we did to cause this.
>
> I'll cc the MM development list.  Please prefer to report issues over
> email this way - we don't use bugzilla and it's rather annoying that MM
> bugzilla even exists.
>
>
>> I have many disks but but my two swap partitions are on 2 HDD, sda and sdb,
>> which are identical (SEAGATE Barracuda 2To). Swap partition on sda has a higher
>> priority than the one on sdb.
>>
>> I don't use zram.
>>
>> When a swap partion is used, the disk on wich it seats is very slow.
>>
>> $ sudo hdparm -t /dev/sda
>> /dev/sda:
>>   Timing buffered disk reads:  24 MB in  3.72 seconds =   6.46 MB/sec
>>
>> $ sudo hdparm -t /dev/sdb
>> /dev/sdb:
>>   Timing buffered disk reads: 540 MB in  3.16 seconds = 170.85 MB/sec
>> pierre@pierre:~$
>>
>> Sometimes, speed gets down to less than 2 MB/s.
>>
>> Lets turn swap off => swapoff -a
>>
>> $ sudo hdparm -t /dev/sdb
>> /dev/sdb:
>>   Timing buffered disk reads: 462 MB in  3.00 seconds = 153.75 MB/sec
>>
>> $ sudo hdparm -t /dev/sda
>>
>> /dev/sda:
>>   Timing buffered disk reads: 474 MB in  3.00 seconds = 157.84 MB/sec
>> pierre@pierre:~$
>>
>> Now speed is normal.
>>
>> Lets put swap on again => sudo swapon -a
>>
>> Speed is still normal :
>>
>> $ sudo hdparm -t /dev/sda
>> /dev/sda:
>>   Timing buffered disk reads: 612 MB in  3.01 seconds = 203.56 MB/sec
>> $ sudo hdparm -t /dev/sdb
>> /dev/sdb:
>>   Timing buffered disk reads: 570 MB in  3.00 seconds = 189.95 MB/sec
>> pierre@pierre:~$
>>
>> But swap is not used
>>
>> MiB Mem :  31952,0 total,  27091,7 free,   3057,6 used,   2343,0 buff/cache
>> MiB Swap:  36000,0 total,  36000,0 free,      0,0 used.  28894,4 avail Mem
>>
>>
>> So I suspect that, when the swap is used, there is some sort of lock that slows
>> the whole disk that contains the swap partition that is being used.
>>
>> Logically, the system becomes very slow.
>>
>> There is nothing in the journal that seems related to this problem.
>>
>> Since the virtual memory has been modified in 6.16, I suspect a nasty bug.
>>
>> This affects 6.16.5 to 6.16.8.
>>
>> This appeared "recently", probably with 6.16
>>
>> Thanks,
>>
>> Regards,
>>
>> Pierre
>>
>> -- 
>> You may reply to this email to add a comment.
>>
>> You are receiving this mail because:
>> You are the assignee for the bug.
--------------Zbj4dXx6pCs05ft0UEs0zgOl
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="Carlito" size="4">Hi Andrew and people reading those
        lists,</font></p>
    <p><font face="Carlito" size="4">I still struggle to understand what
        is wrong with me.</font></p>
    <p><font face="Carlito" size="4">I rebuilt my mdadm + bcache array
        to be sure it was not something linked to a (too) old
        configuration. Upgrading to 6.16.10 didn't change anything.</font></p>
    <p><font face="Carlito" size="4">One symptom of the problem I
        identified is the time of the swapoff command (I have 32G, 12G
        are free and there is less than 1G in the swap)</font></p>
    <p>
      <span style="font-family:monospace"><span
          style="color:#000000;background-color:#ffffff;">MiB Mem :</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
           31952,0 </span><span
          style="color:#000000;background-color:#ffffff;">total,</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
           12646,2 </span><span
          style="color:#000000;background-color:#ffffff;">free,</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
            2226,8 </span><span
          style="color:#000000;background-color:#ffffff;">used,</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
           17587,5 </span><span
          style="color:#000000;background-color:#ffffff;">buff/cache
              </span><span
          style="color:#000000;background-color:#ffffff;"> </span><br>
        <span style="color:#000000;background-color:#ffffff;">MiB Swap:</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
           36000,0 </span><span
          style="color:#000000;background-color:#ffffff;">total,</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
           35212,2 </span><span
          style="color:#000000;background-color:#ffffff;">free,</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
             787,8 </span><span
          style="color:#000000;background-color:#ffffff;">used.</span><span
style="font-weight:bold;color:#000000;background-color:#ffffff;">
           29725,2 </span><span
          style="color:#000000;background-color:#ffffff;">avail Mem </span><br>
        <span style="color:#000000;background-color:#ffffff;">
        </span><br>
      </span>
      <br>
    </p>
    <p><b><font face="Carlito" size="4"><span
            style="color:#000000;background-color:#ffffff;">$ time sudo
            swapoff -a</span><span
            style="color:#000000;background-color:#ffffff;">
          </span></font><br>
      </b>
      <b><br>
        <font face="Carlito" size="4"><span
            style="color:#000000;background-color:#ffffff;">real</span><span
            style="color:#000000;background-color:#ffffff;">    </span><span
            style="color:#000000;background-color:#ffffff;">6m41,276s</span><span
            style="color:#000000;background-color:#ffffff;">
          </span></font><br>
        <font face="Carlito" size="4"><span
            style="color:#000000;background-color:#ffffff;">user</span><span
            style="color:#000000;background-color:#ffffff;">    </span><span
            style="color:#000000;background-color:#ffffff;">0m0,005s</span><span
            style="color:#000000;background-color:#ffffff;">
          </span></font><br>
        <font face="Carlito" size="4"><span
            style="color:#000000;background-color:#ffffff;">sys</span><span
            style="color:#000000;background-color:#ffffff;">     </span><span
            style="color:#000000;background-color:#ffffff;">0m0,028s</span></font></b><br>
      <font face="Carlito" size="4"><span
          style="color:#000000;background-color:#ffffff;"></span><br>
        Waiting for more than  6 minutes elapsed for 33 ms of work is
        bizarre. </font></p>
    <p><font face="Carlito" size="4">During that time, if I try to
        launch another tab with <b>iotop</b>, nothing is displayed
        during at least one minute.</font></p>
    <p><font face="Carlito" size="4">During that time, my computer is
        almost idle.</font></p>
    <p><font face="Carlito" size="4">So it looks like swapoff and iotop
        are stucked, waiting for some kind of a semaphore inside the
        kernel.</font></p>
    <p><font size="4" face="Carlito">Any idea  to dig further ?</font></p>
    <p><font face="Carlito" size="4">Thanks,</font></p>
    <p><font face="Carlito" size="4">Pierre</font></p>
    <div class="moz-cite-prefix">Le 30/09/2025 à 01:07, Andrew Morton a
      écrit :<br>
    </div>
    <blockquote type="cite"
cite="mid:20250929160727.a0119e93688378c570a3c550@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sat, 27 Sep 2025 08:07:59 +0000 <a class="moz-txt-link-abbreviated" href="mailto:bugzilla-daemon@kernel.org">bugzilla-daemon@kernel.org</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre"><a class="moz-txt-link-freetext" href="https://bugzilla.kernel.org/show_bug.cgi?id=220605">https://bugzilla.kernel.org/show_bug.cgi?id=220605</a>

            Bug ID: 220605
           Summary: Very slow access on HDD when a swap partition is used
                    on this HDD on kernel 6.16
           Product: Memory Management
           Version: 2.5
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: Page Allocator
          Assignee: <a class="moz-txt-link-abbreviated" href="mailto:akpm@linux-foundation.org">akpm@linux-foundation.org</a>
          Reporter: <a class="moz-txt-link-abbreviated" href="mailto:pierre.juhen@orange.fr">pierre.juhen@orange.fr</a>
        Regression: No

Hello everybody,

I have a strange behavior on my system (Fedora 42 up to date =&gt; kernel 6.16.8).
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
You certainly do.  I wonder what we did to cause this.

I'll cc the MM development list.  Please prefer to report issues over
email this way - we don't use bugzilla and it's rather annoying that MM
bugzilla even exists.


</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">I have many disks but but my two swap partitions are on 2 HDD, sda and sdb,
which are identical (SEAGATE Barracuda 2To). Swap partition on sda has a higher
priority than the one on sdb.

I don't use zram.

When a swap partion is used, the disk on wich it seats is very slow.

$ sudo hdparm -t /dev/sda
/dev/sda:
 Timing buffered disk reads:  24 MB in  3.72 seconds =   6.46 MB/sec

$ sudo hdparm -t /dev/sdb
/dev/sdb:
 Timing buffered disk reads: 540 MB in  3.16 seconds = 170.85 MB/sec
pierre@pierre:~$ 

Sometimes, speed gets down to less than 2 MB/s.

Lets turn swap off =&gt; swapoff -a 

$ sudo hdparm -t /dev/sdb
/dev/sdb:
 Timing buffered disk reads: 462 MB in  3.00 seconds = 153.75 MB/sec

$ sudo hdparm -t /dev/sda

/dev/sda:
 Timing buffered disk reads: 474 MB in  3.00 seconds = 157.84 MB/sec
pierre@pierre:~$ 

Now speed is normal.

Lets put swap on again =&gt; sudo swapon -a 

Speed is still normal :

$ sudo hdparm -t /dev/sda
/dev/sda:
 Timing buffered disk reads: 612 MB in  3.01 seconds = 203.56 MB/sec
$ sudo hdparm -t /dev/sdb
/dev/sdb:
 Timing buffered disk reads: 570 MB in  3.00 seconds = 189.95 MB/sec
pierre@pierre:~$ 

But swap is not used 

MiB Mem :  31952,0 total,  27091,7 free,   3057,6 used,   2343,0 buff/cache     
MiB Swap:  36000,0 total,  36000,0 free,      0,0 used.  28894,4 avail Mem 


So I suspect that, when the swap is used, there is some sort of lock that slows
the whole disk that contains the swap partition that is being used.

Logically, the system becomes very slow.

There is nothing in the journal that seems related to this problem.

Since the virtual memory has been modified in 6.16, I suspect a nasty bug.

This affects 6.16.5 to 6.16.8.

This appeared "recently", probably with 6.16

Thanks,

Regards,

Pierre

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
</pre>
      </blockquote>
    </blockquote>
  </body>
</html>

--------------Zbj4dXx6pCs05ft0UEs0zgOl--

