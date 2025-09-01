Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C07FDCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279AB8E0043; Mon,  1 Sep 2025 09:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251078E0014; Mon,  1 Sep 2025 09:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167C38E0043; Mon,  1 Sep 2025 09:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00C648E0014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:18:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 906DF16085D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:18:03 +0000 (UTC)
X-FDA: 83840734446.25.E9C2C1A
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4A612100010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:18:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf14.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756732682; a=rsa-sha256;
	cv=none;
	b=GTu3drEt2P9D09zoSSF4ph52yJ7uQT/1M/R4XkZrbYj793v7pOygMHNhFCxU8twP4DFnqy
	T7nrUKGasGBCFQ4QZCspGkgMRX47ORJEZ59qFP8dftPakBekHaCXbN3gFd4cT/F86r65Iv
	RwEVZ0VWBh3ZF+vAgo45X0mFAT+CU60=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf14.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756732681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x5or4jlWM2saeyqSCnZaSWLf/T24CFW3RWMj6gk8xhM=;
	b=Pcs0cCKdMsZj8A9SXidUAdrEhE93zz83ToaVv34jKgV+OhRVa8XubNfgcGjjkUjDQaFCqN
	htlHkiR2aBBfmhvUI7urVXrgCTf8ITHK/myuaQHG2xF128zVl64OSJjQ1BTfVt8LvP24Hi
	tRGMo55/Rek8KkomoKI/JrCrLcj6DkA=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cFqDJ3wqFzYl9lf;
	Mon,  1 Sep 2025 21:17:36 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Sep
 2025 21:17:57 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Sep
 2025 21:17:56 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <shakeel.butt@linux.dev>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<fengbaopeng@honor.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rientjes@google.com>,
	<surenb@google.com>, <tglx@linutronix.de>, <tianxiaobin@honor.com>,
	<zhongjinji@honor.com>
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the victim is frozen
Date: Mon, 1 Sep 2025 21:17:52 +0800
Message-ID: <20250901131752.29098-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <krmliemwgxygxkc3rkix5ah6ubzzulpktejdbu5uhpldwtjts2@3sqqkl5i36tv>
References: <krmliemwgxygxkc3rkix5ah6ubzzulpktejdbu5uhpldwtjts2@3sqqkl5i36tv>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A612100010
X-Stat-Signature: tx3ayaaykxwctspesdnoijucmnuwodco
X-HE-Tag: 1756732680-856023
X-HE-Meta: U2FsdGVkX1/F2qcB5a+sEewmoGZhsJRIsDD/XxbsaXTS6Y1Nh0dP9KMZQaW4ldF77GYi37NsbLh8x6F4BgCAd5gPqnKWHVE+IBJJqOA81PE8WoJRPmlZ/HRLmMs7475WfEZdPAMwEH9JZNxzkg4JPcD6SAMEJqLrza6LKxAfoFZtjsOmK+4jaKIW6DnP+llcosPym+NHxDKnciB1/1xu53J7Qycs5Pq/EhoQiSzwvVtK62CBo6ImL5Uor/i8FL+74F74VeTq3mc4082vFl99KPFALK+zsQHjppUAMRqYDA1qJPomn8eBe+Z0f9HYvWVi7fxSQ7dBOVZX4xxubdos/J8wjU5/gyUQQuaTiAAII9NKh+NXHrgCI7ofGRdna0c/A3/4g34Sy0TffsUWeN1+q+aBNwtffbm2LxO78916s6/eVgmZ16zdKlqtbvwsA+NEuy17mUG6Y9VpI4FPL6ulxJMhCU7NKWLMe9zHIq3VPJvv+I4qmAx2suOEz5kEJ+qWKNr9S1myWjXpS+qsJRCPfvp/rYB5cJ5QsXjwtPV4L3VD8fIn4RSk4/rfizQZyVMimtEDgs70a3vooIjEOeD7xB6rY0DypLKf0+h6NBgYXtwhWyB34XrJG4egldukVN4Ezq1ZBOB5G0sX32rnlR1PzwTVQPkJapXVZ2q/cmOzZU55N7mKXEkGcI8yR5fqIuJqNqdrz01z3ObfSCrOuArJXmBYFzrEVvpNXyENedAK4ek/23Gxcl6LMLcg+U8nv7NqCMMlxohtuHRA6y7sjFxTudROT0RUNgUlzclJ5hppuhF6X6hfS2jyKuIVJO5sig61vvn9pAtTjdnE5Y3anY3k8TOAYrZS0KZ/oKNh8SXGrMAwvwAye1tw8RZhc7P2dnwHj+pbupAyd4IEFyufxj50I2Kxg7UQgGH+PYXINZQquFL1/Xb6azQIShrXi0+upgaxs7AjAmfBpj2spd9/qJK
 SxmTSOzQ
 qnPLg1TCNHjs4QNjV5Rv/LbDS+NH4ag8BkwfZcyNDn2RbMdALBBk9NITZhXRjwhpC8p7mUW2+1hO2Begucvl4+OfLQr3IjW3z9FqEvz79qV7o839yoooJylofxZPmOqxGXBcOWVCK/sN5abPfN0hSy4DxemSIc/IMW5wxh0hPsamU7Da/kZBuHoGxoxS1ioMgmbfp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  	get_task_struct(tsk);
> >  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> > -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> > +	tsk->oom_reaper_timer.expires = jiffies;
> > +
> > +	/*
> > +	 * If the task is frozen by the cgroup freezer, the delay is unnecessary
> > +	 * because it cannot exit until thawed. Skip the delay for frozen victims.
> > +	 */
> > +	if (!frozen(tsk))
> 
> Can you please change the above condition with the following to handle
> v2 as well?

Thank you, but I think the cgroupv2 check isn't needed, since a process frozen
by the cgroup v2 freezer won't block exit after being killed. Would it be
better to note in the comment or changelog that this change is for cgroup v1?

> 	if (!frozen(tsk) && !(READ_ONCE(tsk->frozen)))
> 
> > +		tsk->oom_reaper_timer.expires += OOM_REAPER_DELAY;
> >  	add_timer(&tsk->oom_reaper_timer);
> >  }
> >  
> > -- 
> > 2.17.1
> >


