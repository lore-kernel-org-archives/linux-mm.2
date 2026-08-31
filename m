Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123A3C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 22:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F348F6B0088; Mon, 31 Aug 2026 18:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE65C6B008A; Mon, 31 Aug 2026 18:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB626B008C; Mon, 31 Aug 2026 18:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B29366B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:11:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2EEAA2F34
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:11:19 +0000 (UTC)
X-FDA: 85162961478.05.D359812
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78C4A18000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:11:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oKywa0dN;
	spf=temperror (imf06.hostedemail.com: error in processing during lookup of tim.c.chen@linux.intel.com: DNS error) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788214276;
	b=xEfFakz9eW21TnI34vgdTWXhYS20P1Qp+2/2Nu9fKJxYJogZ/ZtHu2fEU+TncUFznU4/oF
	OQ6e47F4cagozuxERXJWFjDewVRWirmiOX4LOB9Bg1Lw+z6QhwUT2Py/3qS3KJ9GporTSw
	7SZo3mx2PVUclYCw9XIwQ+IUU+RtHw8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oKywa0dN;
	spf=temperror (imf06.hostedemail.com: error in processing during lookup of tim.c.chen@linux.intel.com: DNS error) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788214276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZaIWoevM8VgyskgolHIvpnZdqXrXZCIdl1zseBr+6M=;
	b=jxzKjVVque2r/zUVf5+j3v6No2yy1R3Qrlu7WaV3kPEiiR9beDc9EtE6xEqyiCJAnbj30V
	X2e+LNxaOQwb9Inkhl1ZxXJiimhBJk8VkWWPtGo/xr9KWrpSpV0AZeiOCYKry/mF9BT/K3
	+k4BrEqHEAGo8jBxB5ys325u8nxOHAM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788214270; x=1819750270;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=74uWWSroKtUahBYD0O1rtruEN1eXOPLWBDX0MXkOELo=;
  b=oKywa0dNirkfimfJ6gS+ov/E0UEya395wR8ToIOOMuRxsZ+lm1NFSFlr
   mM1thlQrrU6otKbbfhj/E40J0tcUv4ey+5WKlc3mbxy/mIdbLtxDf8FU3
   Gp+7imhY/7h/aVsp209vZk+S4n8/f33kUeAL9G8j43lCaVsTmcTOmvHqj
   HAPjImG1wGBHOKpaukVjg0VAdYgQZkj/jK9jG78aFFze0pAepZToZgX6E
   dAqm78zKj9fH++RmEPzeWe2WT0K0uVe2T3rj6AXV7jaSPHBm9+hkIBHRh
   j3ZoRxD/Hz5iqCVeaL8g1IiMu8WBOUEyyhmFfcVAFiZrCpa5KfUbRNmi8
   Q==;
X-CSE-ConnectionGUID: IxaD9AeDQFCYWGFxMcKGSA==
X-CSE-MsgGUID: 12acVev1QpOeEUhNSk3/Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="88655877"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="88655877"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 15:10:42 -0700
X-CSE-ConnectionGUID: oOmRa3boQGqtiDT+CE1A1Q==
X-CSE-MsgGUID: o0d0SNirTICSHrrEFg7Vog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="264622730"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 15:10:40 -0700
Message-ID: <db2436d91e2e04a8a1063553ce64acc74b533f5c.camel@linux.intel.com>
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
Date: Mon, 31 Aug 2026 15:10:40 -0700
In-Reply-To: <apX1ufR1reYZ9LBc@v4bel>
References: <apPb-Dr4nPYuHQOK@v4bel>
	 <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com> <apXV6t-7drLDf-lL@v4bel>
	 <a1a0bc24108e68656041dc17824d6b88b4120058.camel@linux.intel.com>
	 <apX1ufR1reYZ9LBc@v4bel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: qfg14n9x13m9um3j7m4gmpepkcd6wfhi
X-Rspamd-Queue-Id: 78C4A18000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1788214269-630524
X-HE-Meta: U2FsdGVkX1/WZwpOupOaOv/Hq1e94QeSFQCOgM71PmZ79kAGsXDKAZLtBGKJm5L3elBFj8qL4kKqqHOv9h0CXZyr1H3BEjqDN+QjzN7L/xAbO0N92GiI05lq7WvMBxfO/Dv0O7PcaA039nwEfngKBIX6sfGY2EEn71afOFNvOIkiEfJAXuljSw/z0oKZanKmIJq05Sv71wTW6R0BBca6oqHbPL3d45Dm7HQKPg+fzuOk95GKXK6P/4ao6XCZudN0ZNNkNNXJu79UPPWL37uZKtT19YNnsUUtHJuhmkSHQXnGw789zIkEFtTj8FIoV3Ez9ABjA2sUSvjilqyMdLO5nUntW6kk0AdfGjg6TZxWPfvfBxWL0+4VAh0P9Ml314JA0z+m5iwRHaAkAAalWOrnM29gV73HyIZpMsajsWaYbAmKSOiPp897EQxFGwNgzTNsyz5BJQkw06x8YdQNabJ1g4Miop7FshewLH2HmYScZpPXnoNRgo5c3XMdSXBGA+oF9dZ+8gRSvijli2PeyNqwRJdu+EO6qWJ/zq03IcXp5jZqzeOlcWJK2+d4prz8RqdmHjvuacxeb1CrWhcOtZCGk9HUfviQbnPT4yksyuuZ2XXH/uMIW0ERN/H6BQjobXaT9t1omSEcNj5XIbgfwQfvyhl+zZgdRvlqk3S3zRLcH8lufvVM/ZOp0FRsWRpbnMEoOsn8flTuxHYj+Tg9Hmj2PMfH9H7dSTGYc29xwwOUrTgKK9m9gfMRGhsMP7qQvsoFEKzIWm8WOVmHP910g/WnfVhviHqP+/Zpu049O93Ps+F8/tdIXRnDWQiZZBqgJ1fXxDDmWBQgthAjrkQWyge28oyH16WUo50SnwctESzUTCl3m0ZlaoOxBziJMN9EBtV4Yf4Wuo64UtNfZAgO4yeYDk2s+YzeCenezbyl7JdwwiuHuoMsKDi0LgwB+7rsiCpjqc6Ngdv2cHmwB0yjU+C
 z499kNgA
 zRtptmYLDf8ULz8azbzwszGytIvtM7czBpqeljd29+scpVY1Pz7tfqMQmItL4jj0jFqIYy2se4nAOKufAcQjwpbjhYFhKsLR2Jb/pFRwecS+s48Z5lv9zeZLZHVtMxFiT5NhvogfV7OXUyPVqmlvsvq4J+SssuVeJ8ex7QoJr97TPoDEx6woP88FiCEo6rXccWJchPjYGfyImkTZqpNohrxQP2whGs0m6PHczYjXuILJrLVQJqd8M0fVipmeBz1kzuH2AZ7PfR6p+cg1y0XLu1zEtyHJ/dhicopSxXRCc8+mOMPsH7YqE6jBuMdvWy0nIdDHywhz5UvJmO1YIpoBEFlELNLCdN7Sd8bdQbVBpxVBDQWaZ1ZrFTAMKf4EBaWK8P79dw54Y4uAHzPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-09-01 at 06:44 +0900, Hyunwoo Kim wrote:
> On Mon, Aug 31, 2026 at 01:25:06PM -0700, Tim Chen wrote:
> > On Tue, 2026-09-01 at 04:28 +0900, Hyunwoo Kim wrote:
> > > On Mon, Aug 31, 2026 at 12:22:45PM +0800, Chen, Yu C wrote:
> > > > Hi Hyunwoo,
> > > >=20
> > > > On 8/30/2026 3:30 PM, Hyunwoo Kim wrote:
> > > > > When the waker cannot use the wakelist, ttwu_queue() takes the ta=
rget rq
> > > > > lock and goes down into update_curr(). If the target rq belongs t=
o another
> > > > > CPU, the task handed to account_mm_sched() is the one running on =
that CPU,
> > > > > not the task being woken.
> > > > >=20
> > > > > account_mm_sched() reads p->mm and updates mm->sc_stat. Nothing k=
eeps that
> > > > > mm alive. The rq lock and rq->cpu_epoch_lock it holds have nothin=
g to do
> > > > > with the lifetime of the mm.
> > > > >=20
> > > > > If that task happens to be in execve(), exec_mmap() points tsk->m=
m and
> > > > > tsk->active_mm at the new mm, and exec_mm_put_old() from setup_ne=
w_exec()
> > > > > drops the old one. free_bprm() does the same when exec fails. On =
the way
> > > > > from mmput() down to __mmdrop(), mm_destroy_sched() calls free_pe=
rcpu() on
> > > > > sc_stat.pcpu_sched and free_mm() returns the mm_struct.
> > > > >=20
> > > > > Whoever already read the old pointer keeps using it. It adds to r=
untime in
> > > > > the freed per-cpu area and reads sc_stat in the freed mm_struct. =
Depending
> > > > > on the condition it also writes sc_stat.cpu. That is a use-after-=
free.
> > > > >=20
> > > > > Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm pointer =
access")
> > > > > changed the remaining p->mm dereference to the local variable, an=
d said the
> > > > > active_mm reference keeps the structure allocated. That holds for=
 the other
> > > > > paths that detach an mm, since they take an mmgrab_lazy_tlb() ref=
erence.
> > > > > exec reassigns active_mm to the new mm as well, so that reference=
 is gone.
> > > > > What is left is the mm_users reference in bprm->old_mm, and dropp=
ing it is
> > > > > the free.
> > > > >=20
> > > > >               CPU0                                CPU1
> > > > >=20
> > > > >                                        write(pipe)
> > > > >                                        try_to_wake_up()
> > > > >                                          ttwu_queue()      // tak=
es rq0 lock
> > > > >                                            enqueue_task_fair()
> > > > >                                              update_curr()
> > > > >                                                update_se()
> > > > >                                                  account_mm_sched=
()
> > > > >                                                    mm =3D rq0->cu=
rr->mm
> > > > >                                                          // old m=
m
> > > > >    execve()
> > > > >      exec_mmap()                       // tsk->mm =3D new mm
> > > > >      setup_new_exec()
> > > > >        exec_mm_put_old()
> > > > >          mmput() -> ... -> __mmdrop()
> > > > >            mm_destroy_sched()          // free_percpu()
> > > > >            free_mm()
> > > > >                                                    read mm->sc_st=
at.epoch
> > > > >                                                          // use-a=
fter-free
> > > > >=20
> > > >=20
> > > > Ah, thanks for catching this.
> > > >=20
> > > > > ---
> > > > >   fs/exec.c             |  1 +
> > > > >   include/linux/sched.h |  4 ++++
> > > > >   kernel/events/core.c  |  2 ++
> > > > >   kernel/sched/fair.c   | 16 ++++++++++++++++
> > > > >   4 files changed, 23 insertions(+)
> > > > >=20
> > > > > diff --git a/fs/exec.c b/fs/exec.c
> > > > > index 745f6eb5279e6..6194c38807980 100644
> > > > > --- a/fs/exec.c
> > > > > +++ b/fs/exec.c
> > > > > @@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_struct =
*old_mm)
> > > > >   {
> > > > >   	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
> > > > >   	mm_update_next_owner(old_mm);
> > > > > +	sched_cache_exec_done();
> > > > >   	mmput(old_mm);
> > > > >   }
> > > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > > index 8b3d47a325cca..6ae31bffe049e 100644
> > > > > --- a/include/linux/sched.h
> > > > > +++ b/include/linux/sched.h
> > > > > @@ -2415,10 +2415,14 @@ struct sched_cache_stat {
> > > > >   	int cpu;
> > > > >   } ____cacheline_aligned_in_smp;
> > > > > +void sched_cache_exec_done(void);
> > > > > +
> > > > >   #else
> > > > >   struct sched_cache_stat { };
> > > > > +static inline void sched_cache_exec_done(void) { }
> > > > > +
> > > > >   #endif
> > > > >   #ifndef MODULE
> > > > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > > > index a6c8e38a31104..2f29cbccf03f1 100644
> > > > > --- a/kernel/events/core.c
> > > > > +++ b/kernel/events/core.c
> > > > > @@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct *ta=
sk, struct kmem_cache *ctx_cache,
> > > > >   	if (!cd)
> > > > >   		return -ENOMEM;
> > > > > +	/* @old, loaded by the try_cmpxchg() below, is only stable unde=
r RCU. */
> > > > > +	guard(rcu)();
> > > >=20
> > > > Is this change related to this UAF issue?
> > >=20
> > > Duh.. that one is unrelated. My mistake.
> > >=20
> > > >=20
> > > > > +/* exec() has switched to the new mm and is about to drop the ol=
d one. */
> > > > > +void sched_cache_exec_done(void)
> > > > > +{
> > > > > +	struct rq_flags rf;
> > > > > +	struct rq *rq;
> > > > > +
> > > > > +	/*
> > > > > +	 * account_mm_sched() dereferences rq->curr->mm under this rq's=
 lock,
> > > > > +	 * so a remote CPU can still be using the old mm. The lock cycl=
e waits
> > > > > +	 * for it, and the store to tsk->mm cannot be reordered past th=
e
> > > > > +	 * release, so later acquirers see the new mm.
> > > > > +	 */
> > > > > +	rq =3D this_rq_lock_irq(&rf);
> > > >=20
> > > > A smart fix, learnt! It behaves like a synchronize_rcu() to protect=
 against
> > > > the read in account_mm_sched(). Small open: since the context of in=
voking
> > > > account_mm_sched() is preemption-disabled, I wonder if we can simpl=
y use
> > > > synchronize_rcu() directly instead of this_rq_lock_irq() - just to =
avoid
> > > > contention for rq-lock in heavy system?
> >=20
> > Thanks to Kyunwoo to show this potential use-after-free problem.
>=20
> It is a real, triggerable issue.
>=20

Appreciate if you can check whether the first 2 patches in=20
https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.intel.co=
m/
fixes this issue.

> >=20
> > While synchronize_rcu() avoids rq lock, it could introduce a long delay
> > of a full grace period that will be undesirable.
> >=20
> >=20
> > I think a better fix is to decouple sc_stat from mm and make it its own=
 structure.
> > Then we can do proper refcounting and rcu management on sc_stat itself.
> > We will let task points to sc_stat with proper ref count and change the=
 access
> > as task->sc_stat directly nstead of via task->mm->sc_stat.
> >=20
> > Then we will know sc_stat exists in account_mm_sched() execution
> > as long as a task points to it and do not have to worry that sc_stat is
> > released due to the mm life cycle.
> >=20
> > In the first 2 patches of the prctl control series for cache aware sche=
duling
> > we posted, we introduced the change I described above and should=C2=A0
> > fix this issue without additional rq locking or synchronize_rcu() overh=
ead.
> >  https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.int=
el.com/
> >=20
> > We should probably prioritize to merge the first couple of patches from
> > that series now in light of this issue.  It will make maintenance and f=
uture
> > modification of the cache aware scheduling code easier.
>=20
> That is a fairly large change.=20

However adding rcu synchronization will slow down the launch of a new proce=
ss
too much.  The rq lock solution has less latency in my opinion.  But I
think decoupling sc_stat is the best solution without adding latency in the
exec path.

Wonder what is Peter's opinion?

>=20
> If you add a Reported-by: tag for this UAF to the patch, I am fine with=
=20
> handling it that way.

I'll be happy to do that. If you let us know if those two patches from prct=
l series fixes
the bug you found in KASAN log, I can also add a Tested-by tag in addition =
to Reported-by.

Thanks.

Tim

>=20
>=20
> Best regards,
> Hyunwoo Kim

