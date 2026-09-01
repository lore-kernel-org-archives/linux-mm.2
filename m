Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 222EEC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F0B6B0121; Tue,  1 Sep 2026 06:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025936B0122; Tue,  1 Sep 2026 06:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F816B0123; Tue,  1 Sep 2026 06:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C887B6B0121
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:44:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51E67160359
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:44:41 +0000 (UTC)
X-FDA: 85164859962.03.DCE9B17
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7F0AE20003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:44:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jdE7AWvi;
	spf=pass (imf31.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788259479;
	b=sNI9m6VW4PR+IBHLkuWYFmFNOU+m46ESKR0jd/VHxlembn/j4JM+sPhSX730xP5TFTLTN6
	w8tR+1XAYJUpNvk7GreeJdv9RVEh/rJUaVPwM0Q7RotyRVrWIKksT81n30VFf86oWzIL4W
	dUKvQSnAfZXidIPALUxh3puwUD8OEVk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jdE7AWvi;
	spf=pass (imf31.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788259479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZloK1QMVfYTr7lw3fYmKao90elb4bik95MvHlyNxNk=;
	b=FYJ5zsCuFg/Nl2ZGbNsQS7imY7leFJKsimVkPUNNCq+b6aGN/McS9nrxCCX2uIkmiaregN
	VJd6wZ/SsjlDuLqpafUMmrssg13Chvw1K9JKy6RzgUFBdZ+UWpfk2JpMmcSX2O/YGWhIur
	0xcUglerJ1UfSQwx37wz6541xVnr1gY=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-39266382df6so3909406a91.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 03:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788259478; x=1788864278; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jZloK1QMVfYTr7lw3fYmKao90elb4bik95MvHlyNxNk=;
        b=jdE7AWviwogowk+ATs2rF2CrsiuTEKHhEui9NCWceGliC0x/BwSHBYAKNejDFDUb7A
         BxmvAKHFjNR3ZJkhALujwzfbhpFLIp59vM3lWOesf3tt0LuEv886jmcNezmRnMfKMja2
         ZBGOuXAcMHT1yvX2z96W/3wy92Px/L3avP2lLY396TwxtJLpMfMBV31ExxAXiFwM/MNz
         vuRZTjCEl9Fp417caaxVl9pis3AbhVeX12bYYkHtHJuE3QgS+wAzvdJWCNDIERkGmbXq
         7Ouz5Jp9gp8ldPQpnAWk9SztovMoazH+d4cFN8MNMgOrUmf91WOiRuAbMHFfUC1ZfR/7
         fUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788259478; x=1788864278;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jZloK1QMVfYTr7lw3fYmKao90elb4bik95MvHlyNxNk=;
        b=jOPS9DgCGC5mZf6n/QSX4tOTLfUXvAfGmqYrjuSi092IIdqAqPMBLSuIzasdnEp6U6
         I62TNlwohYPuP01IODHwtoenv9lPSJuouDzZUmdj0/4sBQfGP7CJNVZUvDNjbepLgpvg
         NJ6lDd19EwTr5DHfSz41lpaycfRKdj/5tFF0J9w+67lwzIW+29JMZxIQIjll2RcywYXo
         /eY4jZsJUcdk9TqVxQ28rbI9cfGVPxxWcclLzinasp7NmwNdSfjnOdtwOEph8kelaWXy
         6fjJZ5cyeAzTxIFEWGZ59fNw0pa2Pavv/OQIqrRGJULm0GLnOywfOW4TIXQEodeQDFju
         ++ag==
X-Forwarded-Encrypted: i=1; AKwUvBxPj77FvxIUIfIpmJpk9rlABzgNESnf6E7mI4HaY203LveI9Jrl8VLHiebbQ+xYnx9gTa/3Cu6qzw==@kvack.org
X-Gm-Message-State: AFuF++lDoPbuho/2ehV4Fx5pD8UV8xPYpAFOpS79mbpZfdrsoYjfk5Rh
	TV404389WQyojTPzHcvWx5WKnWfBDl5HjB7QZyhZBQ3ZJIT7TlasJ7Nf
X-Gm-Gg: AYBFou0wliR7XkvL+rYRVWS0qDSUtcxWtj4/9S/chjCEOvFmljzXqg3aDWtX3HJhEUe
	NOgpSNZyljuqV0MUqIhSjpfpMSfKD83/VEsWlDyz29lEIDJ6wZe3tc/q2ZE10pWqmBtXV4nTAIq
	KqICQY8BKDmgviJPBMkn/68qNK6DukYGhtqd0Q9cZutvxvbhunCx635oHt9g4bgS04xNuYy283L
	OyodP7c91X6TmuDVdemjpPrpSTLB2baExYT3211HT98lsQluxbbt6VZSr72WKqBZ0ZppdrpQp7v
	Dqw7ID+nMU9ulGGRatG+vpD8DWOLnEYscgn/LJXs09c7HC0M14N8ic+BoD5B2RXFOlEPeEFw6vw
	0GgKoCUxb0JMLbeeJu5WsI2nKCG8soUEGNmO2BZaKIpgB6hcM7NMxRF2GZGqcJUWkcSP8td8raK
	fd2XHiCPBohsqIj6r5mRnJsV+KEySmLgIbYzXACx6j5jBIaN8CcS3Ad7zxqIqWcmARM3/auscHL
	5C7Owxp912MUIfpXBo=
X-Received: by 2002:a17:90b:3ec5:b0:398:e6b6:acc1 with SMTP id 98e67ed59e1d1-39907d6563cmr10056321a91.15.1788259478120;
        Tue, 01 Sep 2026 03:44:38 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d471e75sm5591120a91.8.2026.09.01.03.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 03:44:37 -0700 (PDT)
Date: Tue, 1 Sep 2026 19:44:31 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Chen, Yu C" <yu.c.chen@intel.com>, Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"chen.yu@linux.dev" <chen.yu@linux.dev>, imv4bel@gmail.com
Subject: Re: [PATCH] sched/cache: Fix use-after-free of the mm replaced by
 exec
Message-ID: <apasjygjnsg1n6em@v4bel>
References: <apPb-Dr4nPYuHQOK@v4bel>
 <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com>
 <apXV6t-7drLDf-lL@v4bel>
 <a1a0bc24108e68656041dc17824d6b88b4120058.camel@linux.intel.com>
 <apX1ufR1reYZ9LBc@v4bel>
 <db2436d91e2e04a8a1063553ce64acc74b533f5c.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db2436d91e2e04a8a1063553ce64acc74b533f5c.camel@linux.intel.com>
X-Rspam-User: 
X-Stat-Signature: n4kf8945dd6qf7b7ipje1prc6w6im3p1
X-Rspamd-Queue-Id: 7F0AE20003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788259479-381488
X-HE-Meta: U2FsdGVkX1/V3tzXNJJdjJG7tGW4sYcWeOe3ZTP8qu6TZH3MWApOf6czsAY76ILfVgzT2KjMTSlTdqXbjgjM/ObL8G4VLJ9zkuVvhXeUxO2ei+S0vp2K5PqiB3o1xCoJeboRVK8gNSN9aEW+JfNJr/BSyu9HbW12Gg0QrxbR5Lr8brYfQFjhkWz3aQ5DZYN892QSdULzx1RVS/tAWEEEpa6Y7ffuhiQxj/6QmX5zbtrkEyh8T4RPF3w+NwuQPKWR6l1LFVhHskc6ayLn4X+RR38Eq2vfzjSQ0Ehue7JEe+3w6CfkBtXoDa5naioiel0M4jt3cChKJ/XLoAUKTcErtRAcM9CoaSq+T71quYz7bvm/SypKZz4h9x0qcLU1d1u1vRULtgUHoEzimosbf5lIB/Q1PJfmeG3HJVX8gGrp99AK/IUOvI1j22O9REiDt19EvFb4Kowr9jy+SEc1btPdMaIZl2SC+DDY6NLywIA0Z9cDprYipmmgzEqVTAgS1dIAUFneJU5ImBQAGf5fAZR93T9pQLMu+vtnAdLyVvqYhhWpMGdyVyEarJuQIy+f+KlApJpd0XCIrdypHBdN/BrcWmuLy85uQhBcCr92G80pUl/DKLVArEDjT/6JAfhMdzn+/gZu2f1nr08n1oRMWy5B4G3Eatdvaktl6Sn6iHDYsTVmJeElwrgISS8utV+2fN5Li6dvt6Mm0f+xjU6b1sv9cmDDnCeUp4x4D/iB9GEZKUCef2WVH/KEAZJBVr54m6y3M7OuAdP6K/QGeys9yDOR+7bSWVoJtSXWHTPkfOrSXcAbVQKqEk8qcHmHuLZZEKJKyz17AIzEqKKB8oCQrtyStd2ixt8WQZko/oB/Npy6Z2lt2IRTGjbIFUFCiqJc3xZ8QNIUVZ7kzNxGgCk86txGBlUbGsqz9xE9Uzs69fPgGbdHQRxjuwJPmSwIzyC84009tcROkwufGQDyA8u1w+o
 BWsPmS6x
 WAlP0RG2SAyb7tkSkNAbWgCrq+cRnlJpWorMM7CgSf1O03rhqCzHPOLg6/hFDsMLQTcMFfKBNGlR2/fxEWckCZj+p/aH/cNpenZK1tSB4+ND0J7t4JnxcgywF1IUtIIyr1D78V6KBWzByqABHhndFO3u8O4QBIp+GqUwA5Tnpb/MYykfuVrbwVDUim6/gg3jsfKVAvUC3qxOpx8H7cUbfaeS0KS9EVfFOJ2e77aeyXV6bywPAPtYjERgVmqIeZ0EdDjaccQj85cOG2783JdOJ5Hq/k6dO/XhlDlmRo4CAC7ZCEZ3IoqIAVhRMydU3uzhcZIkIRYtvTzOgZjMu5+wgGZidjdJ5LUz7lGlN5HfFAzizfaz2iZx2QPbT1XgEqHIVZ0Ik7MopfRV+U5VNQhIvmhVwoWXkflN9oq2oX/Zv2UrBFVaATOQ073CJgkQPSHgodsFMoXuySknltV+03TGE1iAITK0dT29Ks6B+rLHrYc7NpSS4bgWjPr/JJQOI7qz9D6svjc6ctv0MV5i2LARJdZQTu1Y120RcH/kxESUtMc7hUZjHpgYxvidAV7/CP9h3XePy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:10:40PM -0700, Tim Chen wrote:
> On Tue, 2026-09-01 at 06:44 +0900, Hyunwoo Kim wrote:
> > On Mon, Aug 31, 2026 at 01:25:06PM -0700, Tim Chen wrote:
> > > On Tue, 2026-09-01 at 04:28 +0900, Hyunwoo Kim wrote:
> > > > On Mon, Aug 31, 2026 at 12:22:45PM +0800, Chen, Yu C wrote:
> > > > > Hi Hyunwoo,
> > > > > 
> > > > > On 8/30/2026 3:30 PM, Hyunwoo Kim wrote:
> > > > > > When the waker cannot use the wakelist, ttwu_queue() takes the target rq
> > > > > > lock and goes down into update_curr(). If the target rq belongs to another
> > > > > > CPU, the task handed to account_mm_sched() is the one running on that CPU,
> > > > > > not the task being woken.
> > > > > > 
> > > > > > account_mm_sched() reads p->mm and updates mm->sc_stat. Nothing keeps that
> > > > > > mm alive. The rq lock and rq->cpu_epoch_lock it holds have nothing to do
> > > > > > with the lifetime of the mm.
> > > > > > 
> > > > > > If that task happens to be in execve(), exec_mmap() points tsk->mm and
> > > > > > tsk->active_mm at the new mm, and exec_mm_put_old() from setup_new_exec()
> > > > > > drops the old one. free_bprm() does the same when exec fails. On the way
> > > > > > from mmput() down to __mmdrop(), mm_destroy_sched() calls free_percpu() on
> > > > > > sc_stat.pcpu_sched and free_mm() returns the mm_struct.
> > > > > > 
> > > > > > Whoever already read the old pointer keeps using it. It adds to runtime in
> > > > > > the freed per-cpu area and reads sc_stat in the freed mm_struct. Depending
> > > > > > on the condition it also writes sc_stat.cpu. That is a use-after-free.
> > > > > > 
> > > > > > Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm pointer access")
> > > > > > changed the remaining p->mm dereference to the local variable, and said the
> > > > > > active_mm reference keeps the structure allocated. That holds for the other
> > > > > > paths that detach an mm, since they take an mmgrab_lazy_tlb() reference.
> > > > > > exec reassigns active_mm to the new mm as well, so that reference is gone.
> > > > > > What is left is the mm_users reference in bprm->old_mm, and dropping it is
> > > > > > the free.
> > > > > > 
> > > > > >               CPU0                                CPU1
> > > > > > 
> > > > > >                                        write(pipe)
> > > > > >                                        try_to_wake_up()
> > > > > >                                          ttwu_queue()      // takes rq0 lock
> > > > > >                                            enqueue_task_fair()
> > > > > >                                              update_curr()
> > > > > >                                                update_se()
> > > > > >                                                  account_mm_sched()
> > > > > >                                                    mm = rq0->curr->mm
> > > > > >                                                          // old mm
> > > > > >    execve()
> > > > > >      exec_mmap()                       // tsk->mm = new mm
> > > > > >      setup_new_exec()
> > > > > >        exec_mm_put_old()
> > > > > >          mmput() -> ... -> __mmdrop()
> > > > > >            mm_destroy_sched()          // free_percpu()
> > > > > >            free_mm()
> > > > > >                                                    read mm->sc_stat.epoch
> > > > > >                                                          // use-after-free
> > > > > > 
> > > > > 
> > > > > Ah, thanks for catching this.
> > > > > 
> > > > > > ---
> > > > > >   fs/exec.c             |  1 +
> > > > > >   include/linux/sched.h |  4 ++++
> > > > > >   kernel/events/core.c  |  2 ++
> > > > > >   kernel/sched/fair.c   | 16 ++++++++++++++++
> > > > > >   4 files changed, 23 insertions(+)
> > > > > > 
> > > > > > diff --git a/fs/exec.c b/fs/exec.c
> > > > > > index 745f6eb5279e6..6194c38807980 100644
> > > > > > --- a/fs/exec.c
> > > > > > +++ b/fs/exec.c
> > > > > > @@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_struct *old_mm)
> > > > > >   {
> > > > > >   	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
> > > > > >   	mm_update_next_owner(old_mm);
> > > > > > +	sched_cache_exec_done();
> > > > > >   	mmput(old_mm);
> > > > > >   }
> > > > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > > > index 8b3d47a325cca..6ae31bffe049e 100644
> > > > > > --- a/include/linux/sched.h
> > > > > > +++ b/include/linux/sched.h
> > > > > > @@ -2415,10 +2415,14 @@ struct sched_cache_stat {
> > > > > >   	int cpu;
> > > > > >   } ____cacheline_aligned_in_smp;
> > > > > > +void sched_cache_exec_done(void);
> > > > > > +
> > > > > >   #else
> > > > > >   struct sched_cache_stat { };
> > > > > > +static inline void sched_cache_exec_done(void) { }
> > > > > > +
> > > > > >   #endif
> > > > > >   #ifndef MODULE
> > > > > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > > > > index a6c8e38a31104..2f29cbccf03f1 100644
> > > > > > --- a/kernel/events/core.c
> > > > > > +++ b/kernel/events/core.c
> > > > > > @@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
> > > > > >   	if (!cd)
> > > > > >   		return -ENOMEM;
> > > > > > +	/* @old, loaded by the try_cmpxchg() below, is only stable under RCU. */
> > > > > > +	guard(rcu)();
> > > > > 
> > > > > Is this change related to this UAF issue?
> > > > 
> > > > Duh.. that one is unrelated. My mistake.
> > > > 
> > > > > 
> > > > > > +/* exec() has switched to the new mm and is about to drop the old one. */
> > > > > > +void sched_cache_exec_done(void)
> > > > > > +{
> > > > > > +	struct rq_flags rf;
> > > > > > +	struct rq *rq;
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * account_mm_sched() dereferences rq->curr->mm under this rq's lock,
> > > > > > +	 * so a remote CPU can still be using the old mm. The lock cycle waits
> > > > > > +	 * for it, and the store to tsk->mm cannot be reordered past the
> > > > > > +	 * release, so later acquirers see the new mm.
> > > > > > +	 */
> > > > > > +	rq = this_rq_lock_irq(&rf);
> > > > > 
> > > > > A smart fix, learnt! It behaves like a synchronize_rcu() to protect against
> > > > > the read in account_mm_sched(). Small open: since the context of invoking
> > > > > account_mm_sched() is preemption-disabled, I wonder if we can simply use
> > > > > synchronize_rcu() directly instead of this_rq_lock_irq() - just to avoid
> > > > > contention for rq-lock in heavy system?
> > > 
> > > Thanks to Kyunwoo to show this potential use-after-free problem.
> > 
> > It is a real, triggerable issue.
> > 
> 
> Appreciate if you can check whether the first 2 patches in 
> https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.intel.com/
> fixes this issue.
> 
> > > 
> > > While synchronize_rcu() avoids rq lock, it could introduce a long delay
> > > of a full grace period that will be undesirable.
> > > 
> > > 
> > > I think a better fix is to decouple sc_stat from mm and make it its own structure.
> > > Then we can do proper refcounting and rcu management on sc_stat itself.
> > > We will let task points to sc_stat with proper ref count and change the access
> > > as task->sc_stat directly nstead of via task->mm->sc_stat.
> > > 
> > > Then we will know sc_stat exists in account_mm_sched() execution
> > > as long as a task points to it and do not have to worry that sc_stat is
> > > released due to the mm life cycle.
> > > 
> > > In the first 2 patches of the prctl control series for cache aware scheduling
> > > we posted, we introduced the change I described above and should 
> > > fix this issue without additional rq locking or synchronize_rcu() overhead.
> > >  https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.intel.com/
> > > 
> > > We should probably prioritize to merge the first couple of patches from
> > > that series now in light of this issue.  It will make maintenance and future
> > > modification of the cache aware scheduling code easier.
> > 
> > That is a fairly large change. 
> 
> However adding rcu synchronization will slow down the launch of a new process
> too much.  The rq lock solution has less latency in my opinion.  But I
> think decoupling sc_stat is the best solution without adding latency in the
> exec path.
> 
> Wonder what is Peter's opinion?
> 
> > 
> > If you add a Reported-by: tag for this UAF to the patch, I am fine with 
> > handling it that way.
> 
> I'll be happy to do that. If you let us know if those two patches from prctl series fixes
> the bug you found in KASAN log, I can also add a Tested-by tag in addition to Reported-by.

I confirmed that patches 1 and 2 of your series prevent this UAF.


Best regards,
Hyunwoo Kim

