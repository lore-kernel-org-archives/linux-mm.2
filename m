Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC15CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8458E0023; Tue,  9 Sep 2025 10:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFF98E0003; Tue,  9 Sep 2025 10:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC9A8E0023; Tue,  9 Sep 2025 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D02A8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:47:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1763CC0553
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:47:49 +0000 (UTC)
X-FDA: 83869991058.20.4AECC80
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf23.hostedemail.com (Postfix) with ESMTP id 886A114000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:47:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf23.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429267; a=rsa-sha256;
	cv=none;
	b=aGT+HkDswTOkKA5SVqS/LclaFX0gMK+j4z0zGwI5si7ByWbI2GoFBwgrfmBictAcgi5R2v
	zBneRyNkp3CRRVMN+lCYzYGB4Cwiyd+49zexSi2aP4bERIaGcd/39zger62YnMTIxgdxVd
	4MkRAK/g12aZBaJg44qQA1mjCeLMBFY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf23.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IEnZumGefFe66NTscmVg+xDyuARc7BgG9nbIZa/oZLw=;
	b=iCj2s76DyoOuNtjakIZyogSidQof/aP1Q5DL/BqNzzwboQKf2IAeBJnkYmIciK8+/UVx5h
	t1lOrYJlnFx0CucJtruov6SYXZXa8mmrZ3c+7DZMC8Xp1vOf4Uh15+rpExxBHy5hrSJBOM
	5c2VRMFRrwkhH34JaPxF92NAqrjDq90=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cLmr15WXTzYl9B5;
	Tue,  9 Sep 2025 22:47:13 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 22:47:40 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 22:47:39 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>, <lenb@kernel.org>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-pm@vger.kernel.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <pavel@kernel.org>, <rafael@kernel.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for thawing OOM victims
Date: Tue, 9 Sep 2025 22:47:35 +0800
Message-ID: <20250909144735.6166-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aMAzkQQ4XAFh9xlm@tiehlicka>
References: <aMAzkQQ4XAFh9xlm@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w001.hihonor.com (10.68.25.235) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 886A114000E
X-Stat-Signature: tiu6etjt5rd95yybthj9jk3k9zjuwyxq
X-Rspam-User: 
X-HE-Tag: 1757429266-461031
X-HE-Meta: U2FsdGVkX19VgYULr3j2Gstj9ywdZuHNKS4DCIPd9+ramcsUaemi+zDdQL4mqDviON0m6meqm+T+CfW4By3VZRQ8njM4gSxl2Au/PNJeKhyvWpQmkgwLFixSz4XYc/fe0jHKXO1fYY4kq4KIY0bnWYxFvxH60F2rcO2NFKwYJdFZoXSowe8e92mueaydRGsbsjKKq1hBJ/iBVoKwPjXQ4kQBeYJfGzzcyNsyCwyi77dRFqdOHLBcaByEPfMJQgyyE/X5fTrrqSwJkeidD/BgiKN6VQNWKeycmc4nSM07vlDaIp5BIf5+b6ajixsqPLUuTrQ3g6WD28lYa7nWUW3UGYKd97s4e7pV4djIcPOkXtzXyKPBgbi38ZqHrFj1TFZE+bzVV44kul5p6rlSHMJKcuB3enseq75ej9giXbLUxHR9SJbPHfx8dLYL5Sjr1gxN0c/03xieAcNihYyYZ8OMaNaCP7SxrY4iwmWha2eSTZjk6bSykg4JvzLuCfi9R+1L550cq0mZtNvEyHCgVxszLIDkECAbImywfyosKAYJh+BRqLbQLKKKkoOSiCBFDfaD6csby7NvIshObUEeBzEOIEL0gy+htdKKW2VGwQjwjUD/Dp2H3ULkbmS8mZ6lBZ9edm9TA45EVKZZnLAAJHbZEgo/T0vjy0Mu3ZzcNF2DUOi1C1OjiDF1WXGgP0CKnKl5pMsg5ee40dHJooGV2mVjh6MAhXSFf3GAUnK4F7rNxThGhMaF6PVmRq9IDpBKMg6EE6vUcvU3DDTcdZnz7aO0k2yQDqvLFn/feKCYmtmLKnGDojVIiAVVFWOrhHYk2QeeyQ1nSvuCIi8dnzRWP6QI0LY48o2CH8+jWiulG/p8L+SWCDXOsqf5sYwHJYqes8rQV5Ot38pQ0C0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > On Tue 09-09-25 19:41:31, zhongjinji wrote:
> > > > > On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > > > > > OOM killer is a mechanism that selects and kills processes when the system
> > > > > > runs out of memory to reclaim resources and keep the system stable.
> > > > > > However, the oom victim cannot terminate on its own when it is frozen,
> > > > > > because __thaw_task() only thaws one thread of the victim, while
> > > > > > the other threads remain in the frozen state.
> > > > > > 
> > > > > > Since __thaw_task did not fully thaw the OOM victim for self-termination,
> > > > > > introduce thaw_oom_process() to properly thaw OOM victims.
> > > > > 
> > > > > You will need s@thaw_oom_process@thaw_processes@
> > > > 
> > > > The reason for using thaw_oom_process is that the TIF_MEMDIE flag of the
> > > > thawed thread will be set, which means this function can only be used to
> > > > thaw processes terminated by the OOM killer.
> > > 
> > > Just do not set the flag inside the function. I would even say do not
> > > set TIF_MEMDIE to the rest of the thread group at all. More on that
> > > below
> > > 
> > > > thaw_processes has already been defined in kernel/power/process.c.
> > > > Would it be better to use thaw_process instead?
> > > 
> > > Sorry I meant thaw_process as thaw_processes is handling all the
> > > processes.
> > > 
> > > > I am concerned that others might misunderstand the thaw_process function.
> > > > thaw_process sets all threads to the TIF_MEMDIE state, so it can only be
> > > > used to thaw processes killed by the OOM killer.
> > > 
> > > And that is the reason why it shouldn't be doing that. It should thaw
> > > the whole thread group. That's it.
> > >  
> > > > If the TIF_MEMDIE flag of a thread is not set, the thread cannot be thawed
> > > > regardless of the cgroup state.
> > > 
> > > Why would that be the case. TIF_MEMDIE should only denote the victim
> > > should be able to access memory reserves. Why the whole thread group
> > > needs that? While more threads could be caught in the allocation path
> > > this is a sort of boost at best. It cannot guarantee any forward
> > > progress and we have kept marking only the first thread that way without
> > > any issues.
> > 
> > When a process is frozen, all its threads enter __refrigerator() (in kernel/freezer.c). 
> > When __thaw_task is called, the threads are woken up and check the freezing(current) 
> > state (in __refrigerator). The freezing check is implemented via freezing_slow_path. 
> > When TIF_MEMDIE is set for a thread, freezing_slow_path will return false, allowing 
> > the thread to exit the infinite loop in __refrigerator(), and thus the thread will 
> > be thawed.
> > 
> > The following code can explain how TIF_MEMDIE works in thread thawing.
> > __refrigerator
> >   for (;;) {
> >     freezing = freezing(current)
> >       freezing_slow_path
> >         if (test_tsk_thread_flag(p, TIF_MEMDIE))
> >           return false;
> >     if (!freezing)
> >       break;
> >     schedule();
> >   }
> 
> OK, I see. We could deal with that by checking tsk_is_oom_victim()
> instead of TIF_MEMDIE

Thank you, this looks great. It seems that oom_reserves_allowed implies
that tsk_is_oom_victim is not always effective (in page_alloc.c).
I will check it.

