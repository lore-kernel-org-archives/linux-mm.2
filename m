Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35244CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7411C8E0015; Tue,  9 Sep 2025 09:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719B68E0003; Tue,  9 Sep 2025 09:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656528E0015; Tue,  9 Sep 2025 09:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52FBC8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:52:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 243B213B2C1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:52:07 +0000 (UTC)
X-FDA: 83869850694.10.FE5EB82
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf17.hostedemail.com (Postfix) with ESMTP id A22244000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:52:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757425925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tYZddnlw5ExVfE3qHZj1qUI13xaQA3F75v5hghq9Bhs=;
	b=Kx2Pu1p+PgDYmrsqBWtMwE7JzT1rkf1D2hw1klddd2gnAh9kBhrYfPzuc4BWEmF6DdcnkZ
	b+yMd/g4WFVMxoFBvmvSQDWtHNbR9TWhX5zey3Z3vwf0TAh1s737dAy4VkZbk2BUZsoMdV
	SahqqGoXFshOJhoIPUNGdGEEDRu+k7s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757425925; a=rsa-sha256;
	cv=none;
	b=5lhrM6eIn/bRpjArodvNEb8hOFtUQ1G7b6sU1VXi3eIcvuAsaFGFYUrs3JL4JT6iTpwJ+0
	BxNkq0GESDAp6vIAV2E8RM9MBc+MijEKNgJK+uwnTVyyZCR2OP/w8mCvLJ6x4l8s7lZkSI
	N6vRfb6f/NDDs9aoXaZ6Li+xviVQqnY=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cLlbk28D9zYl56j;
	Tue,  9 Sep 2025 21:51:30 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 21:51:56 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 21:51:56 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>, <lenb@kernel.org>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-pm@vger.kernel.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <pavel@kernel.org>, <rafael@kernel.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for thawing OOM victims
Date: Tue, 9 Sep 2025 21:51:52 +0800
Message-ID: <20250909135152.20477-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aMAWvwQ3eJZH55mp@tiehlicka>
References: <aMAWvwQ3eJZH55mp@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w011.hihonor.com (10.68.20.122) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A22244000A
X-Stat-Signature: z3ba5z1mwps7tmd6odze95kn1dq5nxd7
X-HE-Tag: 1757425924-195415
X-HE-Meta: U2FsdGVkX19xN1+wZ2T2OOAYRNlfecTHd3KQPXuk67zgayCEozTV1r+SCjzBzkHVVKlGog4lreUWAlyTjdl2f1m3ATVTFPANX3U6Ysw6YKtFCGa88cE2ERssSW0/JeaIUts5o2NJSCOj54ytE4S+Aw/2FrJuMclpkeSXsH+66ZYfyMo6ReI74bfXhlhW60/UbuctZflxnHByM2iiZl0Ewch65hgXVzMZNXbavvV/MXyq58LYeqfCubO6PIxj3IzFA5SL+vuuAJijU2muGKUR+69AZJ1VPXDwyrdDB6WLCtscJIKH2023FG4iL4RjjoaaWIbwDR8RjoRwxt76iTMB7zFfm8Pm/7ekFOFlGToHx/slWEF9NopNHdX7yaLbZUc0/juYH8oTQd5XafRKjapnjTKYKIfbsTJGTWXCh/bQCwgm/h2JWpH3ebULxXst8QhrklDUUTwkcGtGmpfAoeRJbQIou2NxODfDQGyagIcjBDZiSHWEjJhepi5vGuMIqKcnm4A7oy3dZCBDqnd0gyFWveqXauAdVENZKRwQAmjEPstY0VtasKIFUvdJEmFek64c/JRbElzIOlrSusFjKLcdIO2mz7tQTc49+Ub7m9FDsVa0f+7i4Y9p9TFWtfrpk7m2r0VlQ61a46nGM8Ku7QcZaPq6/o+NSWOJiDc74ZMxOeySdsORanzX8tHwbIs8EvY2GZDOKPPajhV6ZDml/U5l/eeZ3ai3oOQr9so2F+Fkal+ONElXnzCVPzFbjvDXeusOm1ZbfJ8l92cfHZxLAz2JhSAQMBlzl14REqgh2eDZyBTUKT23b+rMtaj8uubIblXcthU9HEPglC2fA3RwYceZbbK12FH3ZNusLV8ARefOnuHxsrzReLW6b5567TYSdO2SFH+/ZnFuAiT4kpr/GYJY8Wn+C8ZwevuMEvEiD9O30IPDC+gjbVviYGV0Ga2AKVV6Cmb/hyCm0eyCSRBKaAH
 bw91R3pb
 BUkxkwD6vNEhDkrX++YXf2rignDIRwzp0laDcBWPJpyonn55QSTEMVtFwwGtqu+0+JwkAhXsWcmOQAPAaiIG8nmrlbw8W2dhst0tj+rsPO7Ddvj/NXoK4IfmS6ULGLza61jsoG1MFfZmTZMBhtEIpyr/ILFeM5zr8EjrZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue 09-09-25 19:41:31, zhongjinji wrote:
> > > On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > > > OOM killer is a mechanism that selects and kills processes when the system
> > > > runs out of memory to reclaim resources and keep the system stable.
> > > > However, the oom victim cannot terminate on its own when it is frozen,
> > > > because __thaw_task() only thaws one thread of the victim, while
> > > > the other threads remain in the frozen state.
> > > > 
> > > > Since __thaw_task did not fully thaw the OOM victim for self-termination,
> > > > introduce thaw_oom_process() to properly thaw OOM victims.
> > > 
> > > You will need s@thaw_oom_process@thaw_processes@
> > 
> > The reason for using thaw_oom_process is that the TIF_MEMDIE flag of the
> > thawed thread will be set, which means this function can only be used to
> > thaw processes terminated by the OOM killer.
> 
> Just do not set the flag inside the function. I would even say do not
> set TIF_MEMDIE to the rest of the thread group at all. More on that
> below
> 
> > thaw_processes has already been defined in kernel/power/process.c.
> > Would it be better to use thaw_process instead?
> 
> Sorry I meant thaw_process as thaw_processes is handling all the
> processes.
> 
> > I am concerned that others might misunderstand the thaw_process function.
> > thaw_process sets all threads to the TIF_MEMDIE state, so it can only be
> > used to thaw processes killed by the OOM killer.
> 
> And that is the reason why it shouldn't be doing that. It should thaw
> the whole thread group. That's it.
>  
> > If the TIF_MEMDIE flag of a thread is not set, the thread cannot be thawed
> > regardless of the cgroup state.
> 
> Why would that be the case. TIF_MEMDIE should only denote the victim
> should be able to access memory reserves. Why the whole thread group
> needs that? While more threads could be caught in the allocation path
> this is a sort of boost at best. It cannot guarantee any forward
> progress and we have kept marking only the first thread that way without
> any issues.

When a process is frozen, all its threads enter __refrigerator() (in kernel/freezer.c). 
When __thaw_task is called, the threads are woken up and check the freezing(current) 
state (in __refrigerator). The freezing check is implemented via freezing_slow_path. 
When TIF_MEMDIE is set for a thread, freezing_slow_path will return false, allowing 
the thread to exit the infinite loop in __refrigerator(), and thus the thread will 
be thawed.

The following code can explain how TIF_MEMDIE works in thread thawing.
__refrigerator
  for (;;) {
    freezing = freezing(current)
      freezing_slow_path
        if (test_tsk_thread_flag(p, TIF_MEMDIE))
          return false;
    if (!freezing)
      break;
    schedule();
  }

Since thread_info is not shared within a thread group, TIF_MEMDIE for each thread  
must be set so that all threads can be thawed.


