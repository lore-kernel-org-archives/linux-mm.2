Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA73DC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B396B0088; Tue,  1 Sep 2026 16:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413DA6B008A; Tue,  1 Sep 2026 16:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303256B008C; Tue,  1 Sep 2026 16:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E26D46B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:49:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52A4E40550
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:49:34 +0000 (UTC)
X-FDA: 85166384268.20.A63F796
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf28.hostedemail.com (Postfix) with ESMTP id 324A4C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:49:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iKq90zGZ;
	spf=pass (imf28.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788295772;
	b=jhCCQZhT5AHLvK/98Q7n9XKoyv07AFAHem6eZGlLtEljd9cLgcPH4vhKJek88+hI/aejLS
	SVY4wbhV+Qdf7W7UUqIBK8LwBr+oDlUQPP9BFipRmyiOxhaVg3QPQzsIRTEROCZffggDah
	C2dD7pF9mRkAhB2yFZB3ZEbHIKL+d54=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iKq90zGZ;
	spf=pass (imf28.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788295772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDXCxj7I+sVb7zh1yxEoCiAxGk8ZRa14+CEIOCwmMvA=;
	b=WV2wG4634qmmBTJAsFFhlNbtz2A62OBDdbXbMkG423ahumiE/EV9vLKP/HTj9PvqBOQra6
	NjYfu4wPyrEBSm+zXGYVlUs3O7fTypmICIQWpuUC0Y1VK4GlgjKZer0RTl1HKPke0qg5f2
	ELtelXqntJ/mmuvwvRAgk+pkEbQpws8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788295772; x=1819831772;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=b1lfp27dRUw6lA2IESdgIZCHySDmes3STZlmXmvTcf0=;
  b=iKq90zGZe/ZUfGSsIjVwvmlViewKA/pQVljU6b3018+rU7NjNXwvXzy4
   3dL+fCZREFis2d4ltXaFfycRGVzI/HwnRjqs8NyvGG203K4e5HdmdKN6D
   1OUj/9xgnBJV/yAJi/AdeTvSM8Z1N659IrdVwgZd3RpsgGvCXaxu/wnh1
   tUssoedbFs3wKxOYO147669wD8lPDgBxcs9YM9jVijwvNBkPTAPGHHMQe
   oo+OTsE/cQOYPT9PopQ6GDsrDWKSKZGYxE6oEIIHRwDsRttZFmtQaIGqu
   pj+y1r3OPieO3LUV6QtPMYmBpiKNgQUQuoPRjFxx0FfVV0eKGjjCqTmkD
   Q==;
X-CSE-ConnectionGUID: lNllak2qTwG3VMEqbhHsWQ==
X-CSE-MsgGUID: Ej8tRd8rS1+wFH8CQy+3kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="92612553"
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="92612553"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 13:49:30 -0700
X-CSE-ConnectionGUID: NhaGJ78DRnCyx+pDWKNomQ==
X-CSE-MsgGUID: UiHCEyvRSAyIavxS4UlTLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="267435304"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 13:49:30 -0700
Message-ID: <17afb1540240d267023aba1706bd7659d1a50197.camel@linux.intel.com>
Subject: Re: [PATCH] sched/cache: Fix use-after-free of the mm replaced by
 exec
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: "Chen, Yu C" <yu.c.chen@intel.com>, Kees Cook <kees@kernel.org>, 
 Christian Brauner	 <brauner@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Jan Kara	 <jack@suse.cz>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot	 <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt
 <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Shrikanth Hegde	 <sshegde@linux.ibm.com>,
 Qais Yousef <qyousef@layalina.io>, Aaron Lu	 <ziqianlu@bytedance.com>,
 Srikar Dronamraju <srikar@linux.ibm.com>, Vineeth Remanan Pillai
 <vineethr@linux.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 	linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra	 <peterz@infradead.org>, "chen.yu@linux.dev" <chen.yu@linux.dev>
Date: Tue, 01 Sep 2026 13:49:29 -0700
In-Reply-To: <apasjygjnsg1n6em@v4bel>
References: <apPb-Dr4nPYuHQOK@v4bel>
	 <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com> <apXV6t-7drLDf-lL@v4bel>
	 <a1a0bc24108e68656041dc17824d6b88b4120058.camel@linux.intel.com>
	 <apX1ufR1reYZ9LBc@v4bel>
	 <db2436d91e2e04a8a1063553ce64acc74b533f5c.camel@linux.intel.com>
	 <apasjygjnsg1n6em@v4bel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: eyupgr3r98s48a9bt8pwncx1ewrxoy11
X-Rspamd-Queue-Id: 324A4C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788295771-141
X-HE-Meta: U2FsdGVkX1+FF8gYWYpLblw6Z7HfOo3XEUfElJ8aGudu5SNvBT1V6zt1//9In9m0LyIeDINE92f4cEIRDBhyo9oPGb0y2cpPu/ZQJph976S3lv2cxM07nSbUJatroVrjO7k4GCxlTrnBGEpfec+6aU2ilci8LbZFUdl/vxRBesAUMf9ICFgW1CFugB0FVY4GcM1jCqoSBwgK7HL5zUiaCiI3/wFoYX0ZLdH05HAqE/oIHq9lY9zKndBLRFPvM8RZQ5dW9j9Z4WpxvFMwlIi4mGhQjKsizdKql7I/xuoYI/a8odoFIIIk+yW6nsGzDyMkvRm1YdXoR9ZqkqoNGeaIdAdnM5yt+XKmmX1349V7WQPWlgRemwEtPgwJkrfAm5Bd5YKxQykyveGJFvhXEfRJVkxN6gidtU/NBFy6Szew0y/zvNEcfOnsAmnbQoBktA7SqW7CRzZouIVB+SbHNyWBN8BGkJYAPKs30X+IhTJz5NlaxxhdPsB3VlzCO7jzPALrJ7GmlMd8gplGgmSqZcNVIozmjw57fQovYt3daNz5+ghcN5rWcmQyge7wS/e7lkbry7ufNjKdP/cNvSW2CzPioxSlvnXUbLScY0Gn6+teRpzib+XfsHKhpdmr00Ip2MyHZh3DJBJDFaYn/hPHiW9kyKu9N4zdhDUIDNPgPCDvMGz5VyZdGUqIZbqoYngPYM4vShdCNSdW9yuA/sx2Juh7kifNrl/4QZgLC9/lKeH+fbNIvoTbEiodOn5KhcftQpVr/S0IxzS1ft1evu/vXlyDsvs/boe6Tc9lPRUggGettzkwIfxYU27kFBblWtc/6ER8AfqlQldzRKo7W1Or3aVnNbgEo+8+SOIRPdSYSylISZ0wGG8ZCqQpsmujXwp2doA5O7tXPno0Rt9v9H+wYfjekAvHtuTA5A66QkNI2Fj6EnvspSmJkWATJz6GxXPEzNw9BqVEgNWv2K2g1oyR4tj
 hqJritKw
 Ceyd50bTT+NH72bhwebP/O1el/Hb4WTbKkXbCA9taJWx/ogoXj7YcIk4vgXQy218QQLajrCh6xcZiGgBFKBizajQfLq0R8dF8xNuHBIzBKv+p2oJ1yIZElkydGNanhZ2HvJ6VKZqAVS3p7j8Gfrw+Jg1wYJeOTjMVBwGjW84VqrcOgKgzIK/OR6KhAmYok2oH3QVkrpRbmXFyXNdIdeeQlitBnzE3Aoohf2rKeQRlt2pZt1/WtsYAg6x+irU7rrcp8YZI4Qx+nroOTLvdGgCkp7eOC3HUcjKt4yvFd3KDMwHwqEg1py9oOwVquh/YBylal1k1+wXfBb1FbHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-09-01 at 19:44 +0900, Hyunwoo Kim wrote:
> On Mon, Aug 31, 2026 at 03:10:40PM -0700, Tim Chen wrote:
> > On Tue, 2026-09-01 at 06:44 +0900, Hyunwoo Kim wrote:
> > > On Mon, Aug 31, 2026 at 01:25:06PM -0700, Tim Chen wrote:
> > > > On Tue, 2026-09-01 at 04:28 +0900, Hyunwoo Kim wrote:
> > > > > On Mon, Aug 31, 2026 at 12:22:45PM +0800, Chen, Yu C wrote:
> > > > > > Hi Hyunwoo,
> > > > > >=20
> > > > > > On 8/30/2026 3:30 PM, Hyunwoo Kim wrote:
> > > > > > > When the waker cannot use the wakelist, ttwu_queue() takes th=
e target rq
> > > > > > > lock and goes down into update_curr(). If the target rq belon=
gs to another
> > > > > > > CPU, the task handed to account_mm_sched() is the one running=
 on that CPU,
> > > > > > > not the task being woken.
> > > > > > >=20
> > > > > > > account_mm_sched() reads p->mm and updates mm->sc_stat. Nothi=
ng keeps that
> > > > > > > mm alive. The rq lock and rq->cpu_epoch_lock it holds have no=
thing to do
> > > > > > > with the lifetime of the mm.
> > > > > > >=20
> > > > > > > If that task happens to be in execve(), exec_mmap() points ts=
k->mm and
> > > > > > > tsk->active_mm at the new mm, and exec_mm_put_old() from setu=
p_new_exec()
> > > > > > > drops the old one. free_bprm() does the same when exec fails.=
 On the way
> > > > > > > from mmput() down to __mmdrop(), mm_destroy_sched() calls fre=
e_percpu() on
> > > > > > > sc_stat.pcpu_sched and free_mm() returns the mm_struct.
> > > > > > >=20
> > > > > > > Whoever already read the old pointer keeps using it. It adds =
to runtime in
> > > > > > > the freed per-cpu area and reads sc_stat in the freed mm_stru=
ct. Depending
> > > > > > > on the condition it also writes sc_stat.cpu. That is a use-af=
ter-free.
> > > > > > >=20
> > > > > > > Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm poin=
ter access")
> > > > > > > changed the remaining p->mm dereference to the local variable=
, and said the
> > > > > > > active_mm reference keeps the structure allocated. That holds=
 for the other
> > > > > > > paths that detach an mm, since they take an mmgrab_lazy_tlb()=
 reference.
> > > > > > > exec reassigns active_mm to the new mm as well, so that refer=
ence is gone.
> > > > > > > What is left is the mm_users reference in bprm->old_mm, and d=
ropping it is
> > > > > > > the free.
> > > > > > >=20
> > > > > > >               CPU0                                CPU1
> > > > > > >=20
> > > > > > >                                        write(pipe)
> > > > > > >                                        try_to_wake_up()
> > > > > > >                                          ttwu_queue()      //=
 takes rq0 lock
> > > > > > >                                            enqueue_task_fair(=
)
> > > > > > >                                              update_curr()
> > > > > > >                                                update_se()
> > > > > > >                                                  account_mm_s=
ched()
> > > > > > >                                                    mm =3D rq0=
->curr->mm
> > > > > > >                                                          // o=
ld mm
> > > > > > >    execve()
> > > > > > >      exec_mmap()                       // tsk->mm =3D new mm
> > > > > > >      setup_new_exec()
> > > > > > >        exec_mm_put_old()
> > > > > > >          mmput() -> ... -> __mmdrop()
> > > > > > >            mm_destroy_sched()          // free_percpu()
> > > > > > >            free_mm()
> > > > > > >                                                    read mm->s=
c_stat.epoch
> > > > > > >                                                          // u=
se-after-free
> > > > > > >=20
> > > > > >=20
> > > > > > Ah, thanks for catching this.
> > > > > >=20
> > > > > > > ---
> > > > > > >   fs/exec.c             |  1 +
> > > > > > >   include/linux/sched.h |  4 ++++
> > > > > > >   kernel/events/core.c  |  2 ++
> > > > > > >   kernel/sched/fair.c   | 16 ++++++++++++++++
> > > > > > >   4 files changed, 23 insertions(+)
> > > > > > >=20
> > > > > > > diff --git a/fs/exec.c b/fs/exec.c
> > > > > > > index 745f6eb5279e6..6194c38807980 100644
> > > > > > > --- a/fs/exec.c
> > > > > > > +++ b/fs/exec.c
> > > > > > > @@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_str=
uct *old_mm)
> > > > > > >   {
> > > > > > >   	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
> > > > > > >   	mm_update_next_owner(old_mm);
> > > > > > > +	sched_cache_exec_done();
> > > > > > >   	mmput(old_mm);
> > > > > > >   }
> > > > > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > > > > index 8b3d47a325cca..6ae31bffe049e 100644
> > > > > > > --- a/include/linux/sched.h
> > > > > > > +++ b/include/linux/sched.h
> > > > > > > @@ -2415,10 +2415,14 @@ struct sched_cache_stat {
> > > > > > >   	int cpu;
> > > > > > >   } ____cacheline_aligned_in_smp;
> > > > > > > +void sched_cache_exec_done(void);
> > > > > > > +
> > > > > > >   #else
> > > > > > >   struct sched_cache_stat { };
> > > > > > > +static inline void sched_cache_exec_done(void) { }
> > > > > > > +
> > > > > > >   #endif
> > > > > > >   #ifndef MODULE
> > > > > > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > > > > > index a6c8e38a31104..2f29cbccf03f1 100644
> > > > > > > --- a/kernel/events/core.c
> > > > > > > +++ b/kernel/events/core.c
> > > > > > > @@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct=
 *task, struct kmem_cache *ctx_cache,
> > > > > > >   	if (!cd)
> > > > > > >   		return -ENOMEM;
> > > > > > > +	/* @old, loaded by the try_cmpxchg() below, is only stable =
under RCU. */
> > > > > > > +	guard(rcu)();
> > > > > >=20
> > > > > > Is this change related to this UAF issue?
> > > > >=20
> > > > > Duh.. that one is unrelated. My mistake.
> > > > >=20
> > > > > >=20
> > > > > > > +/* exec() has switched to the new mm and is about to drop th=
e old one. */
> > > > > > > +void sched_cache_exec_done(void)
> > > > > > > +{
> > > > > > > +	struct rq_flags rf;
> > > > > > > +	struct rq *rq;
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * account_mm_sched() dereferences rq->curr->mm under this =
rq's lock,
> > > > > > > +	 * so a remote CPU can still be using the old mm. The lock =
cycle waits
> > > > > > > +	 * for it, and the store to tsk->mm cannot be reordered pas=
t the
> > > > > > > +	 * release, so later acquirers see the new mm.
> > > > > > > +	 */
> > > > > > > +	rq =3D this_rq_lock_irq(&rf);
> > > > > >=20
> > > > > > A smart fix, learnt! It behaves like a synchronize_rcu() to pro=
tect against
> > > > > > the read in account_mm_sched(). Small open: since the context o=
f invoking
> > > > > > account_mm_sched() is preemption-disabled, I wonder if we can s=
imply use
> > > > > > synchronize_rcu() directly instead of this_rq_lock_irq() - just=
 to avoid
> > > > > > contention for rq-lock in heavy system?
> > > >=20
> > > > Thanks to Kyunwoo to show this potential use-after-free problem.
> > >=20
> > > It is a real, triggerable issue.
> > >=20
> >=20
> > Appreciate if you can check whether the first 2 patches in=20
> > https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.inte=
l.com/
> > fixes this issue.
> >=20
> > > >=20
> > > > While synchronize_rcu() avoids rq lock, it could introduce a long d=
elay
> > > > of a full grace period that will be undesirable.
> > > >=20
> > > >=20
> > > > I think a better fix is to decouple sc_stat from mm and make it its=
 own structure.
> > > > Then we can do proper refcounting and rcu management on sc_stat its=
elf.
> > > > We will let task points to sc_stat with proper ref count and change=
 the access
> > > > as task->sc_stat directly nstead of via task->mm->sc_stat.
> > > >=20
> > > > Then we will know sc_stat exists in account_mm_sched() execution
> > > > as long as a task points to it and do not have to worry that sc_sta=
t is
> > > > released due to the mm life cycle.
> > > >=20
> > > > In the first 2 patches of the prctl control series for cache aware =
scheduling
> > > > we posted, we introduced the change I described above and should=C2=
=A0
> > > > fix this issue without additional rq locking or synchronize_rcu() o=
verhead.
> > > >  https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux=
.intel.com/
> > > >=20
> > > > We should probably prioritize to merge the first couple of patches =
from
> > > > that series now in light of this issue.  It will make maintenance a=
nd future
> > > > modification of the cache aware scheduling code easier.
> > >=20
> > > That is a fairly large change.=20
> >=20
> > However adding rcu synchronization will slow down the launch of a new p=
rocess
> > too much.  The rq lock solution has less latency in my opinion.  But I
> > think decoupling sc_stat is the best solution without adding latency in=
 the
> > exec path.
> >=20
> > Wonder what is Peter's opinion?
> >=20
> > >=20
> > > If you add a Reported-by: tag for this UAF to the patch, I am fine wi=
th=20
> > > handling it that way.
> >=20
> > I'll be happy to do that. If you let us know if those two patches from =
prctl series fixes
> > the bug you found in KASAN log, I can also add a Tested-by tag in addit=
ion to Reported-by.
>=20
> I confirmed that patches 1 and 2 of your series prevent this UAF.
>=20

Thanks for confirming that patches 1 and 2 in prctl series fix this use aft=
er free issue.
I will post those two patches separately and update the commit log
with reference to this UAF problem. We will try to expedite getting those t=
wo patches merged.

Tim

>=20
> Best regards,
> Hyunwoo Kim

