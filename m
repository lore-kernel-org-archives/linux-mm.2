Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC1FC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF6E6B0093; Wed, 16 Sep 2026 08:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A12C6B0095; Wed, 16 Sep 2026 08:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B63A6B0096; Wed, 16 Sep 2026 08:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8C86B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:54:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAA961206EC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:54:57 +0000 (UTC)
X-FDA: 85219620234.30.D5C902E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 75CC7A0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:54:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kL2FeXHk;
	spf=pass (imf15.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+6Kr80JG4BpC+G12cdr/A75Y8Inn6C+PumT0UpV3iA=;
	b=fT89M5sx+AkAiI4ldAL+QWir894lNbMIW+zxKowF7/Ncw+QjRmkEc9SU6D2th9PeOFgIer
	vihGaBTStk166iC65i7X5MzspZ/x0OgrPLSuGjB7GwOWPaDEhgTEkwBCLGglL0gswCeNWN
	PVLdi6TSn1o1huJLkFSEWRDN3QCcaeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563296;
	b=7xvrmP7dcAgIrhXpFxIUk8xaRKGPP/bHsQKKXejjZpHpHbmswzM718TywfOCmOXZ5fjICt
	7DAbVpW9tRDfnVWuCxs7u2LGsso1nMcUFnvrlV32zWtdyAbmcm6/gVercHpz+OWUrV3skU
	kiPPj/DiHc8TXN2jK1idZ5AmeZXJBkY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kL2FeXHk;
	spf=pass (imf15.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3+6Kr80JG4BpC+G12cdr/A75Y8Inn6C+PumT0UpV3iA=; b=kL2FeXHkacHaFxdFGZoyyMtDG7
	qVtQ95V5o5JnWtfqovZodaKZTyDq7rRGm4juqrkFIfvNv7/FRNCmx/rgv9+9cBzJmxNDsORbe5YO4
	EBjLOt9S7vviqc9E+5Rj3TsFZvqTNdkmiZmfP+bgfg2iqI9I3FJ2YxWo5tVYQClwBxaAJSafk/QBp
	7UD9D0JS7VJoOky5XYBLvsIObwPtcOsNPXtuoJV/FJewNWmwuQtWz8kjSATnhWXXjFwoQbRr/Thc0
	Fw2sAxshJ56i6FiSwe5n2WDyQvK376fO1967y4rHuxtN5tz/Ii5es595YxihBgb+CjRx1na6Z7xab
	Xd/UpRJg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6p9t-00000004Tte-28nx;
	Wed, 16 Sep 2026 12:54:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 80F96300328; Wed, 16 Sep 2026 14:54:40 +0200 (CEST)
Date: Wed, 16 Sep 2026 14:54:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>, Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] sched/cache: Decouple sched_cache_group from mm
Message-ID: <20260916125440.GF776954@noisy.programming.kicks-ass.net>
References: <cover.1789061845.git.tim.c.chen@linux.intel.com>
 <cb678eddae708e2865ec69a04edf999119c2168a.1789061845.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb678eddae708e2865ec69a04edf999119c2168a.1789061845.git.tim.c.chen@linux.intel.com>
X-Stat-Signature: z1tn6ew9ga7bh3mdjr3q3rm3b5auttsp
X-Rspam-User: 
X-Rspamd-Queue-Id: 75CC7A0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789563295-255303
X-HE-Meta: U2FsdGVkX18Hl2RmAOyj4MhjXYtYhar7d+/+cBZyPMV8onCPL5bnlDzTZVKv8Uskx0vtryNOK9aKJZ38Y1SZwdvL8RsufCbY+a3qSMBMH+5qMA3p8Ga/upzT3c6Gy8GUTdRbyy/j+lWytdn9i1SKDpzOrbdiWlMPi3FgR5OPJ9/96lOciDY2jmWaTFuUjvIvYAHySmFTkqmMIEjEjN6k4oRPPbINTGcVtINyOPBoYSAnXwYhzJhzJwSkgFgqWYhI680asJ+BFgjiDKI0sugsoXy+8HMp8OSqamkePXkNYfyOuwutYo2YitjANQHKERfMjW7TQufsqlK/OfOegLSINTt3j1M2r0gMAA/cxvbuDL7z0uw8BiE643maQiQqWx4qOceXXvz4wir18cy0k3SXjwkZfiajfSs2UVNoWAHARcLUfRqwlAxNAuSM14VNkckKDf3Vo4E9lznce0r0FraH+10A+dOqG/WW0GEBwLiEYdEVxg1zGV9IZ1/h5K1AAMD7jYnrK0a6NtWBxaUDXhYcl97hqPwy5dhi9TmkWxvSa33qgdlDnA7Ti13EixovAIbmsWjWRprt6t8CiFz8LSx95q6WrmP4OQOwh4eIeliHYc0cRG6nW6+5xaaxAgQRu9NJs6bH1E/ueLhAAvxI1xi/j6JYXQdJntysLyTDECSZ6PERsq59PTngpjYO1f3PZ9mmC3bYTmwCqJCYNXgWBHc5XbS4P90yZiBGrMrlr7qUbWBSVDVrdFat3rIsFhoBokZVtCo+dy5kk9H6rHxi2kYA06lNSJBzhRZbupMsdxAvvIyArMOzv11XQENJgofXPB5R5g0xZpxXQ6o6+MjQpMuETChqBMg8YEKQneRw/DbxBdEVV4ZsR69l7Aa9vud3wDOAdVdNgu/rzsoxL8BgA/56kV7Mqh56jD7UUvPxA9tJo+lRtNYF8wSI/CLLKvHDM++iT6uP71ChWOaVZCXhehL
 bjkwjZg8
 rfciF+tQI0B2kt5mMPCpxflAolWlR6fYoNXhmSi8R9iNUkwyw1FLdlZ6i1LYXWJMR+BiZEPzxMagzkRfP5Psh6KznVDJww2n2lJ/DQUggvbZ3IY5wytZ3g5VA2H6dl9ZGHiRtgf9iNjwcAscS16GvoNhxDusEgfFkaw5XvgsSwjL2NIz8s0mDF2sy7xW4z3E/g2m3pmurCuQQub6ChNk9znckx8enbNdaTsXJUvCQ0AQJRSvT20P1dvw2Z9rTfw7Z1MYCnWCwblzMkiJ6Zvfe4q9ccqHq75pJ3FNF2bJAo0bmGXvTUuZtu+qcVFzxEY85Zyoevvyct7yYxBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 10:46:11AM -0700, Tim Chen wrote:

> +static void sched_cache_group_free_rcu(struct rcu_head *rcu)
> +{
> +	struct sched_cache_group *grp =
> +		container_of(rcu, struct sched_cache_group, rcu);
> +
> +	/* free_percpu() may be called from atomic context. */

That comment is misleading at best. This is rcu-free context. And
free_percpu() is not allowed from actual atomic context on RT.

> +	free_percpu(grp->pcpu_sched);
> +	kfree(grp);
> +}
> +
> +void sched_cache_group_put(struct sched_cache_group *grp)
> +{
> +	if (!grp || !refcount_dec_and_test(&grp->refcnt))
> +		return;
> +
> +	call_rcu(&grp->rcu, sched_cache_group_free_rcu);
> +}
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 32213801ea39..b5a823f0a622 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

> @@ -1669,18 +1677,35 @@ void mm_init_sched(struct mm_struct *mm,
>  		epoch = rq->cpu_epoch;
>  	}
>  
> -	raw_spin_lock_init(&mm->sc_stat.lock);
> -	mm->sc_stat.epoch = epoch;
> -	mm->sc_stat.cpu = -1;
> -	mm->sc_stat.next_scan = jiffies;
> -	mm->sc_stat.nr_running_avg = 0;
> -	mm->sc_stat.footprint = 0;
> +	raw_spin_lock_init(&grp->lock);
> +	grp->epoch = epoch;
> +	grp->cpu = -1;
> +	grp->next_scan = jiffies;
> +	grp->nr_running_avg = 0;
> +	grp->footprint = 0;
> +	refcount_set(&grp->refcnt, 1);
>  	/*
> -	 * The update to mm->sc_stat should not be reordered
> -	 * before initialization to mm's other fields, in case
> +	 * The update to grp->pcpu_sched should not be reordered
> +	 * before initialization to grp's other fields, in case
>  	 * the readers may get invalid mm_sched_epoch, etc.
>  	 */
> -	smp_store_release(&mm->sc_stat.pcpu_sched, _pcpu_sched);
> +	smp_store_release(&grp->pcpu_sched, _pcpu_sched);
> +	/*
> +	 * Publish the group last.  Not every reader qualifies it by
> +	 * grp->pcpu_sched - can_migrate_llc_task() only checks that the
> +	 * pointer is non-NULL before reading grp->footprint and
> +	 * grp->nr_running_avg - so a reachable group must already be
> +	 * fully initialized.
> +	 */
> +	mm->sched_cache_grp = grp;

If it is a publish it needs to be store-release.

> +	return 0;
> +}
> +
> +void mm_destroy_sched(struct mm_struct *mm)
> +{
> +	if (mm->sched_cache_grp)
> +		sched_cache_group_put(mm->sched_cache_grp);
> +	mm->sched_cache_grp = NULL;
>  }
>  
>  /* because why would C be fully specified */
> @@ -1738,7 +1763,7 @@ static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
>  	if (!mm)
>  		return -1;
>  
> -	mm_sched_cpu = READ_ONCE(mm->sc_stat.cpu);
> +	mm_sched_cpu = READ_ONCE(mm->sched_cache_grp->cpu);
>  	if (mm_sched_cpu != -1) {
>  		mm_sched_llc = llc_id(mm_sched_cpu);
>  
> @@ -1781,11 +1806,15 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
>  	/*
>  	 * init_task, kthreads and user thread created
>  	 * by user_mode_thread() don't have mm.
> +	 *
> +	 * A kthread can temporarily adopt an mm via kthread_use_mm(),
> +	 * so p->mm alone does not imply a user task.

This seems like a related but distinct fix, no?

>  	 */
> -	if (!mm || !mm->sc_stat.pcpu_sched)
> +	if (!mm || p->flags & PF_KTHREAD || !mm->sched_cache_grp ||
> +	    !mm->sched_cache_grp->pcpu_sched)
>  		return;

Is this susceptible to TOCTOU ?

>  
> -	pcpu_sched = per_cpu_ptr(mm->sc_stat.pcpu_sched, cpu_of(rq));
> +	pcpu_sched = per_cpu_ptr(mm->sched_cache_grp->pcpu_sched, cpu_of(rq));
>  
>  	scoped_guard (raw_spinlock, &rq->cpu_epoch_lock) {
>  		__update_mm_sched(rq, pcpu_sched);
> @@ -1798,11 +1827,11 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
>  	 * If this process hasn't hit task_cache_work() for a while invalidate
>  	 * its preferred state.
>  	 */
> -	if ((long)(epoch - READ_ONCE(mm->sc_stat.epoch)) > llc_epoch_affinity_timeout ||
> +	if ((long)(epoch - READ_ONCE(mm->sched_cache_grp->epoch)) > llc_epoch_affinity_timeout ||
>  	    invalid_llc_nr(mm, p, cpu_of(rq)) ||
>  	    exceed_llc_capacity(mm, cpu_of(rq))) {
> -		if (READ_ONCE(mm->sc_stat.cpu) != -1)
> -			WRITE_ONCE(mm->sc_stat.cpu, -1);
> +		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
> +			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
>  	}
>  
>  	mm_sched_llc = get_pref_llc(p, mm);

Perhaps it makes sense to have a local:

	struct sched_cache_group *scg = READ_ONCE(mm->sched_cache_grp);

because as is, the compiler is free to keep re-loading that. I mean,
dumb, but allowed. Also the local variable will shorten some of those
long expressions.


Somewhat applicable to the rest of the patch too, where it makes sense
and all that.

