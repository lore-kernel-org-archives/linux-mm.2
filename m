Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF92BCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352AB8E0030; Tue,  2 Sep 2025 12:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329228E0002; Tue,  2 Sep 2025 12:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266C68E0030; Tue,  2 Sep 2025 12:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 112118E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:01:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF2D4C029E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:01:41 +0000 (UTC)
X-FDA: 83844775602.25.DA069CF
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf28.hostedemail.com (Postfix) with ESMTP id B156EC0018
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:01:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="U/2B39No";
	spf=pass (imf28.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePrwZDq7iaPQ889D0c8BezIihziwKkN83oj/ujEEnJE=;
	b=C1/SSET5hpzbvepj+6YL36I1LMPPDiAp+cPgmVX3rAwZiMxE28OZOzqoDnmeP54iu4bCWy
	nH372CHNJKJsRyb5DH+t0tvjW5e/4JW8KIYD4uJ5KhblifEG7dxuoBZKM5zK0T0Rbn5OBR
	sw0VKSmz4wbLgeBokoBSAWLTsy4J7gA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828899; a=rsa-sha256;
	cv=none;
	b=3I/AkgCIzEfUpNUpI5bNgyP8fAboHvUggv+mb1ZhCQU8QwDJC/JA7gKR+H5AjW7VhULPun
	eaYopfb/qRox+AEP1CSybcx3gaDd6V2miuPTMdCD5legYi10XkpIAchFlNvG7fmsytUq/f
	Xux9SsSBJClvYUX5rXkSomACvNMdy8A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="U/2B39No";
	spf=pass (imf28.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=ePrwZDq7iaPQ889D0c8BezIihziwKkN83oj/ujEEnJE=;
	b=U/2B39NofmVI66J9TxMYYpzNFsjV4TTuudDhk1PnZ1o9JE3/h0emTwmaNPyjlTiwaPVMePSRD
	c/2FxUyN0rRSTLTFP2M++O8NiydXUOk7w4A1fMmEG5fGXX2GAAOpDcgojy2VmHo+k4vZcNs8wId
	pIELLP+z0qgSDKqo79rBOgw=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cGVpl6f3gzYlSDN;
	Wed,  3 Sep 2025 00:01:19 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 00:01:34 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 00:01:33 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<fengbaopeng@honor.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <surenb@google.com>, <tglx@linutronix.de>,
	<tianxiaobin@honor.com>, <zhongjinji@honor.com>
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the victim is frozen
Date: Wed, 3 Sep 2025 00:01:29 +0800
Message-ID: <20250902160129.13862-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aLWmf6qZHTA0hMpU@tiehlicka>
References: <aLWmf6qZHTA0hMpU@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B156EC0018
X-Stat-Signature: strrd8t14buqaq57yfps96e16uptwi3x
X-Rspam-User: 
X-HE-Tag: 1756828898-831553
X-HE-Meta: U2FsdGVkX18BAhuexy5BS7DAADjK9/jy+5fhHGNPKGqyjMIZ4/hTocLUcrrfBVYPnVklAyDY7tsBvax4nGE/9eauF1On4d0WyPUl107hZulSE1ufKjJHNvmNeItqLKyO639nxSmq23PIc3Ll+muDqpnksQW0Ipb/4eHQUwpdeJkC/zBPqzgU501xjMz2z9npUEgCoxofBfVrTp4o+mXAEZ5XuiZdR4WVxUYIodbXxYMWJzAMdXMC12DQXmSIRKvdLOwkbRVObaQpeS3zoteM6ylEQpcgg0j4siyrj/Wi26bI+VHXpWlJG7h4teRETbBW7rMLfYLn41hHkH4GNVilmROhc0Bus6f9eb4LnCv7iUfK/eQmxuIp6wMdhH4rq6Vn5oeWzOad6AwXwseIdhiGTe3T7RGwe6rXPbq7r3hT3OyZR55MHze04nQ4UTMSvfmY8e1CH5sSxV2u4XooR0s8CbHHfgjSM5IghrSgEKxI8lzXZ6rxlkxFjAv7OxfvQjvE+04dws4elYQpgDWm88Gd3Zb6R4u7PvDhuzR7/tUr9VmxQJP4sIrayavvjFm40groP/jThBHu6T1kiN1HYwelORibnWZNu2AZTe7kPPWGv72CTMvXxLH3g1JzXbqpPsxQ6csdAgnZk7dYZNN6tZRfxc5hTaBUDjuy4ruPOX8LjYNU2FxsDSXKpN8JNlJOfDsMGmQRyo4SmDkXgYqrziCrBBoF9JVSD3Ctnm6Mcpq4BbqpCk2lZR5XPWkKjK2OgyuV3E+yjXn80EQaxSg2e6K7KPt5j6WHcNcO3OfEqoGM2m/LLAoBKhueqIphAAj1PryT2J0DKo2gExhMqEskHeKBT03B0/G1lFmZIxsCQupfRrkMkIUtW6rQhSs3WouR4HcH8rK7XYzPJDluT4XifRaub+kuaW+2A9r3gl1zzIIYVj4hMQDdhaHOZoImiKaIOJIQi958k6JWtqCkF2yT/2l
 88hndmAu
 4vqOSCAyFX2qoihpCDozm5+nigR+mgBg33cdqsxSn1lKzUSVczl1Y73YJ5StOezZc56vRYkBmBvfErr8FeaA9WMy7Ed+7I/BJ4Cu4AK7zwbYYoT6fqs/6L0rMvf+BtQeCNJSAd2WJqZe6zTj3fpI9slAOeu77YazIEQCMubr/8osTZLjBRpPHsNU93PgzzwaiXYHsM1KQL3iqGDbTCkUSfLGAJkpUjAg8f9STl1Tp6OgZCNxa34M/bfC1JJ1vY+B2GM0fUzg0xv9XkscO8tPQR8GPakCyY+9l9z1a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Sorry, I found that it doesn't work now (because I previously tested it by
> > simulating OOM, which made testing easier but also caused the mistake. I will
> > re-run the new test). Calling __thaw_task in mark_oom_victim will change the
> > victim's state to running. However, other threads are still in the frozen state,
> > so the process still can't exit. We should update it again by moving __thaw_task
> > to after frozen (this way, executing __thaw_task and frozen in the same function
> > looks more reasonable). Since mark_oom_victim and queue_oom_reaper always appear
> > in pairs, this won't introduce any risky changes.
> 
> Hmm, I must have completely forgot that we are actually thawing the
> frozen task! That means that the actual argument for not delaying the
> oom reaper doesn't hold.
> Now I do see why the existing implementation doesn't really work as you
> would expect though. Is there any reason why we are not thawing the
> whole process group? I guess I just didn't realize that __thaw_task is
> per thread rather than per process back then when I have introduced it.

Previously, I didn't know why we needed to call __thaw_task() in 
mark_oom_victim(). Now I understand.

> Because thread specific behavior makes very little sense to me TBH.
> So rather than plaing with __thaw_task placement which doesn't really
> make much sense wrt to delaying the reaper we should look into that
> part.
> 
> Sorry, I should have realized earlier when proposing that.

Is this modification acceptable?

This change only thaws the process previously identified as the victim,
and does not thaw the process being killed in for_each_process.

The reason is that the process being killed in for_each_process is usually
a vfork process, which is only temporary and rarely encountered.

@@ -772,12 +773,18 @@ static void mark_oom_victim(struct task_struct *tsk)
                mmgrab(tsk->signal->oom_mm);

        /*
-        * Make sure that the task is woken up from uninterruptible sleep
+        * Make sure that the process is woken up from uninterruptible sleep
         * if it is frozen because OOM killer wouldn't be able to free
         * any memory and livelock. freezing_slow_path will tell the freezer
-        * that TIF_MEMDIE tasks should be ignored.
+        * that TIF_MEMDIE thread should be ignored.
         */
-       __thaw_task(tsk);
+       rcu_read_lock();
+       for_each_thread(tsk, t) {
+               set_tsk_thread_flag(t, TIF_MEMDIE);
+               __thaw_task(t);
+       }
+       rcu_read_unlock();
+
        atomic_inc(&oom_victims);
        cred = get_task_cred(tsk);
        trace_mark_victim(tsk, cred->uid.val);

