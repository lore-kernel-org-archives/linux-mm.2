Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA4DC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F0E6B0088; Mon, 31 Aug 2026 16:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0156B008A; Mon, 31 Aug 2026 16:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5FB6B008C; Mon, 31 Aug 2026 16:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 919EB6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:25:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 064881601A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:25:11 +0000 (UTC)
X-FDA: 85162694022.18.F061591
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B9CE4000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:25:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kWqhP6vN;
	spf=pass (imf27.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788207909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYTYWw2k6OBP3VQPyR5BQ5bsjC3+sOp8H3XOBvfMixU=;
	b=OPT8wmPjELJ9PDwwiICcdWlOwDtf41Tnzp+PH5MkVrOwCcEsK5siQPFrL0IW1YJTvasbom
	Z2ZBmJTQuqz4rprIfRQpqOcdOFidcyHA96qFSuGegZ7RJJgD1CgmH1lGt2F4vhZrL9s0Ss
	CzMqXb/3cv7NcIuzp7T5aIZU3axEOCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788207909;
	b=dfZlk1Pe26wzXtXPlDq0Ba65LuatMagWE52zkJm1PIy35F7o7W8XsvApnI7qK6ph+SzSjb
	AFB0VHAj1vs2EE/97smtJ2/bnK5Y8a7PDU16mpfk4Agbz4tYA2HuyR7bvH0PqFGWL9tO4N
	/SPdBvH8E567vRucfIbKNKZNd/kBRJE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kWqhP6vN;
	spf=pass (imf27.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788207908; x=1819743908;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1u5m0X4pQbLUl1Wtl8F8Vk/mWL0JZi4iPgSmQ+Ldy6g=;
  b=kWqhP6vN/bXopADc6BX3xtJl+svga5HUmo26a5AVbI4xqftWxOH5S9FY
   B+h5EZw9iu2d7VyDiP+ZySnoQoHV35L8BkxghEV69JBZZLtH6JNaPbwgj
   4tYWfcoMP+CoJCsdd4603bA2MqeA/h9rgmNYM47lk8cLoQwsKI0mCZ+YJ
   F3XHklcMh5qLVCp9B4VhCpjd5Ia0AO/NHqQmm2C/t0hTkk289e8kHXrtw
   ITjVmwUtr+rXtUtSjaKNMBBJSJckahb2+sqVO71BFDaFMsfY+f2TTXoZv
   F08r4b9qJr3aPj/c0cRP8XhDpMu2njEfPDqs6U673IbpO1ZMe4UFnvX+x
   A==;
X-CSE-ConnectionGUID: fLrC0WwsQfKFwQJqcqJYTQ==
X-CSE-MsgGUID: Qq1N7uXkQ5GO3woTYdXxHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="99286369"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="99286369"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 13:25:06 -0700
X-CSE-ConnectionGUID: 5GrD7GWkTAu7hCsazB5v/w==
X-CSE-MsgGUID: 2lEplv7pSEys9hOBZWssVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="273080572"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 13:25:06 -0700
Message-ID: <a1a0bc24108e68656041dc17824d6b88b4120058.camel@linux.intel.com>
Subject: Re: [PATCH] sched/cache: Fix use-after-free of the mm replaced by
 exec
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Hyunwoo Kim <imv4bel@gmail.com>, "Chen, Yu C" <yu.c.chen@intel.com>
Cc: Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt	 <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman	 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K
 Prateek Nayak	 <kprateek.nayak@amd.com>, Shrikanth Hegde
 <sshegde@linux.ibm.com>, Qais Yousef	 <qyousef@layalina.io>, Aaron Lu
 <ziqianlu@bytedance.com>, Srikar Dronamraju	 <srikar@linux.ibm.com>,
 Vineeth Remanan Pillai <vineethr@linux.ibm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org,  Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, "chen.yu@linux.dev"	 <chen.yu@linux.dev>
Date: Mon, 31 Aug 2026 13:25:06 -0700
In-Reply-To: <apXV6t-7drLDf-lL@v4bel>
References: <apPb-Dr4nPYuHQOK@v4bel>
	 <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com> <apXV6t-7drLDf-lL@v4bel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B9CE4000A
X-Stat-Signature: dwh46n89ig9wqc7g1spnb41ir3s85gad
X-HE-Tag: 1788207908-775046
X-HE-Meta: U2FsdGVkX1+60KHmH9Ww0hAbAzUQOy7CrtlRGjzMdyoOHPtMFZQq3g7pJBTh+tmbFAwMQLfbS3WzyplSbkRB3WNWV455HR5mEY9Ly25OXxVzGeh7e03cOnPPMkDgmqBPUFHjsEKQ+skhfpd5X9dQSrxNJeG/2MWIfPytboNH7fOIKATLfkdiOM49RIpgcSQqwJN7yk684T6hpNPZOlG6UAuFftqv9+RANV1B9XUOeXveSlIk3DHUWuVtTy7KcquhCTpwXAlFymSil+Bk2aJ5uTmRxEAJ8qMpzuH7M4pFTbLfW2FE0AkSunsKfxkMShU33Smln09FvVD+OYSVFmqQ9K7jU74P8CCpmGIOH26etk1zokitLArs0Uk/0pJZ6SGL30cXv7WWFQfzlHYks1LCpz8VjzhsApqG+pxUkJQ7V1hq0Tiz0Z+vrLPbA4TRgy2pFgLFnKL5cBEf0R4W9tecmDFC9vq5rox4Nj1tGROTVjo0T5H2eCPZ7xz6hAuFF6qGQGbe6Y+ba2rvzSnx3wQ+K9fVvd66yuVP7mNzRIb4R1nrdsjBDmsqejTuvW2xIEoZHVHjmTfpFl8ZzAYPpyexy7z4j4AbNG1ZYsRMZLCXZUQL6HcitM/i67FyrJmaffRY8r+1xGqvI48yIs8j5yhnXxO4aoKOGsK/POFL2/SkQRxL6RZcNgqE9aebXIuNY2ebHFhfkVNu2Hi3lLbQoxFcQB2ecetSV7hWX+ww83fi/vO2BjZFMXfodaQUCx8PAdTgQoNPp0zU3VwPg/mLTd52BqDpsekCp+1kXaCsGngcbE1XGMipQF60e1heYJqqz88ujouO1Vxh8WwkyKgPjkxqbH5H2c5by82FSMsbcXu6NKhnHdT3f5kN5waqyOfqx81D3h6/47oKDDf9T+MLQOdOA1yCJQFsnXeLGOGXGKVA/AGIOG59N/ydeeXa5cra3/Tdi9byh9+3NfY0t3D7TW2
 1/rBWW2n
 yBWoIbaC9WS1jquDo8xu5PdxZaNbBOjkCp0Z7qtyv7zPdFYYA39XDsygXstuOQUA0OWf9d9M1CtA1iUCx7CTYK+Czy2HBlERj4ICgMgY5UG5/89/bYawtAH3ZJfJkDjnZuXVrtkCucpK/l3lzvuk5DMyWjKQ/+w5fBN5ZOG67ztAVG/lRArG7EQ7Cbsp4F4m/Nksdt5EXEVQX+Qfe1RUhujLcyokuHwUuTOf05XIUpzxswEfZM+ymJRT3I+W4bbcL7x3CkUvMj/WfnyA+mUbh4nAYqgq25HqXeeEran6fBbAoXSCtoK7WL5+PhGQKNK1TdB/wuQ7MPA/W3/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-09-01 at 04:28 +0900, Hyunwoo Kim wrote:
> On Mon, Aug 31, 2026 at 12:22:45PM +0800, Chen, Yu C wrote:
> > Hi Hyunwoo,
> >=20
> > On 8/30/2026 3:30 PM, Hyunwoo Kim wrote:
> > > When the waker cannot use the wakelist, ttwu_queue() takes the target=
 rq
> > > lock and goes down into update_curr(). If the target rq belongs to an=
other
> > > CPU, the task handed to account_mm_sched() is the one running on that=
 CPU,
> > > not the task being woken.
> > >=20
> > > account_mm_sched() reads p->mm and updates mm->sc_stat. Nothing keeps=
 that
> > > mm alive. The rq lock and rq->cpu_epoch_lock it holds have nothing to=
 do
> > > with the lifetime of the mm.
> > >=20
> > > If that task happens to be in execve(), exec_mmap() points tsk->mm an=
d
> > > tsk->active_mm at the new mm, and exec_mm_put_old() from setup_new_ex=
ec()
> > > drops the old one. free_bprm() does the same when exec fails. On the =
way
> > > from mmput() down to __mmdrop(), mm_destroy_sched() calls free_percpu=
() on
> > > sc_stat.pcpu_sched and free_mm() returns the mm_struct.
> > >=20
> > > Whoever already read the old pointer keeps using it. It adds to runti=
me in
> > > the freed per-cpu area and reads sc_stat in the freed mm_struct. Depe=
nding
> > > on the condition it also writes sc_stat.cpu. That is a use-after-free=
.
> > >=20
> > > Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm pointer acce=
ss")
> > > changed the remaining p->mm dereference to the local variable, and sa=
id the
> > > active_mm reference keeps the structure allocated. That holds for the=
 other
> > > paths that detach an mm, since they take an mmgrab_lazy_tlb() referen=
ce.
> > > exec reassigns active_mm to the new mm as well, so that reference is =
gone.
> > > What is left is the mm_users reference in bprm->old_mm, and dropping =
it is
> > > the free.
> > >=20
> > >               CPU0                                CPU1
> > >=20
> > >                                        write(pipe)
> > >                                        try_to_wake_up()
> > >                                          ttwu_queue()      // takes r=
q0 lock
> > >                                            enqueue_task_fair()
> > >                                              update_curr()
> > >                                                update_se()
> > >                                                  account_mm_sched()
> > >                                                    mm =3D rq0->curr->=
mm
> > >                                                          // old mm
> > >    execve()
> > >      exec_mmap()                       // tsk->mm =3D new mm
> > >      setup_new_exec()
> > >        exec_mm_put_old()
> > >          mmput() -> ... -> __mmdrop()
> > >            mm_destroy_sched()          // free_percpu()
> > >            free_mm()
> > >                                                    read mm->sc_stat.e=
poch
> > >                                                          // use-after=
-free
> > >=20
> >=20
> > Ah, thanks for catching this.
> >=20
> > > ---
> > >   fs/exec.c             |  1 +
> > >   include/linux/sched.h |  4 ++++
> > >   kernel/events/core.c  |  2 ++
> > >   kernel/sched/fair.c   | 16 ++++++++++++++++
> > >   4 files changed, 23 insertions(+)
> > >=20
> > > diff --git a/fs/exec.c b/fs/exec.c
> > > index 745f6eb5279e6..6194c38807980 100644
> > > --- a/fs/exec.c
> > > +++ b/fs/exec.c
> > > @@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_struct *old=
_mm)
> > >   {
> > >   	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
> > >   	mm_update_next_owner(old_mm);
> > > +	sched_cache_exec_done();
> > >   	mmput(old_mm);
> > >   }
> > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > index 8b3d47a325cca..6ae31bffe049e 100644
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -2415,10 +2415,14 @@ struct sched_cache_stat {
> > >   	int cpu;
> > >   } ____cacheline_aligned_in_smp;
> > > +void sched_cache_exec_done(void);
> > > +
> > >   #else
> > >   struct sched_cache_stat { };
> > > +static inline void sched_cache_exec_done(void) { }
> > > +
> > >   #endif
> > >   #ifndef MODULE
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index a6c8e38a31104..2f29cbccf03f1 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct *task, =
struct kmem_cache *ctx_cache,
> > >   	if (!cd)
> > >   		return -ENOMEM;
> > > +	/* @old, loaded by the try_cmpxchg() below, is only stable under RC=
U. */
> > > +	guard(rcu)();
> >=20
> > Is this change related to this UAF issue?
>=20
> Duh.. that one is unrelated. My mistake.
>=20
> >=20
> > > +/* exec() has switched to the new mm and is about to drop the old on=
e. */
> > > +void sched_cache_exec_done(void)
> > > +{
> > > +	struct rq_flags rf;
> > > +	struct rq *rq;
> > > +
> > > +	/*
> > > +	 * account_mm_sched() dereferences rq->curr->mm under this rq's loc=
k,
> > > +	 * so a remote CPU can still be using the old mm. The lock cycle wa=
its
> > > +	 * for it, and the store to tsk->mm cannot be reordered past the
> > > +	 * release, so later acquirers see the new mm.
> > > +	 */
> > > +	rq =3D this_rq_lock_irq(&rf);
> >=20
> > A smart fix, learnt! It behaves like a synchronize_rcu() to protect aga=
inst
> > the read in account_mm_sched(). Small open: since the context of invoki=
ng
> > account_mm_sched() is preemption-disabled, I wonder if we can simply us=
e
> > synchronize_rcu() directly instead of this_rq_lock_irq() - just to avoi=
d
> > contention for rq-lock in heavy system?

Thanks to Kyunwoo to show this potential use-after-free problem.

While synchronize_rcu() avoids rq lock, it could introduce a long delay
of a full grace period that will be undesirable.


I think a better fix is to decouple sc_stat from mm and make it its own str=
ucture.
Then we can do proper refcounting and rcu management on sc_stat itself.
We will let task points to sc_stat with proper ref count and change the acc=
ess
as task->sc_stat directly nstead of via task->mm->sc_stat.

Then we will know sc_stat exists in account_mm_sched() execution
as long as a task points to it and do not have to worry that sc_stat is
released due to the mm life cycle.

In the first 2 patches of the prctl control series for cache aware scheduli=
ng
we posted, we introduced the change I described above and should=C2=A0
fix this issue without additional rq locking or synchronize_rcu() overhead.
 https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.intel.c=
om/

We should probably prioritize to merge the first couple of patches from
that series now in light of this issue.  It will make maintenance and futur=
e
modification of the cache aware scheduling code easier.

Tim

