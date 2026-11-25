Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EF6606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=HLOmayJZ
Received: by kanga.kvack.org (Postfix)
	id 538526B0A26; Wed, 25 Nov 2026 09:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F996B0A27; Wed, 25 Nov 2026 09:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425056B0A28; Wed, 25 Nov 2026 09:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 195BA6B0A26
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:09:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A78201C475D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:09:11 +0000 (UTC)
X-FDA: 85473823302.24.79112C4
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf24.hostedemail.com (Postfix) with ESMTP id 75496180018
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:09:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HLOmayJZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795615750;
	b=YRaa8pSWgzNBY6BmkiK5S/vqzlMm1ZYviOAGm3BUWqCRLC3+bLHuOcQfxkLdaF6Qgw8E4q
	EwALPcGLSFhPknVPIxLm9mJD5n9RaTbafVlleUYfau84VsX6Ko0zLAnvM+RyVQRdO0Zn0u
	FKbgtHMWh72rPGa6/Io4drSaHsMJHpM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795615750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJfj0NWZLxmiap02Jgv9y6mBQfosM9khI8VQAwhpY5c=;
	b=JQkkSAQqRwidh5FB9mFhtKXfKMnd9KTo7r335vwkHLkbvBCntPVZgxkq19LUo+Gz2K/tD0
	RwKz5A0keSKbT99dGzBiRkSI/3zcCf3qm+GOiurY4uSdOaBNcOgl2BKnjwwFlf/i77RG4V
	xCnRwIyneqEljrjj8f3rubqf/PWGoGk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HLOmayJZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OJfj0NWZLxmiap02Jgv9y6mBQfosM9khI8VQAwhpY5c=; b=HLOmayJZkdjmUcSo04fNYiJZ+F
	iuOcY/vbBOs7dUr1USwUAgETw2iJRkCXAb4zbYLJWrHC3WdrMh0hRKm6cbzkctZ33FtIMF3UbqamV
	lfulBT3qwftheBZI9jUuNiHYSb/CAexRFMIcHIHIePn/PM2FGT2Xzfm8Ex9gbwZ3577im9HaOCuQp
	EO6f8P1MAwM2LMF7+4K7DdbOh3BJG58TXUNqO2FWUdFV8PzNHKMuGvIPM9gAtb4Q+PEVJ3+a+MkRD
	lY9sYRYO7EkLhaHmTL+YpkUgZ7yNNP/ohxd6aFksxkzhoeN2Z63iEYrIVQSfWtTmEswM2oOxhh4an
	Bd/m2EIA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWDgG-00000005O70-0o3R;
	Wed, 25 Nov 2026 14:09:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B818F302186; Wed, 25 Nov 2026 15:09:02 +0100 (CET)
Date: Wed, 25 Nov 2026 15:09:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Harry Yoo <harry@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>, bpf@vger.kernel.org,
	andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
	daniel@iogearbox.net,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
Message-ID: <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com>
 <awWRZ9xCzWLnj_R6@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awWRZ9xCzWLnj_R6@thinkstation>
X-Rspamd-Queue-Id: 75496180018
X-Stat-Signature: armi9z587eua7rzcsfdof84yj3x11oye
X-Rspam-User:
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795615749-697514
X-HE-Meta: U2FsdGVkX1/WKxK/10VSCBE72S8HAyR0d03/le9j2rRpHOlamV0LvmChdzSd2huBNyciX8N0br9bhqgq+zufU6SRrmQqxPJhuy4fy151+rufmNDySsqdPRzO8OwxhLzMMhCd5x4l83KS7NnxGhUecJAKY9JRgP5omkj9cazaomnqHtxoUPnKjYbyAVQcNk4WWYOd26fGlpn6XiOoWlH4+/0em6rddgLC4IP+1c7iwznchWbDXJGr1Ex/GrVkZNTXT/sTNsgvRKUpa9tGFHwp4VkHpk88hd3UXpROI8mTTz+654SDolW2DECFE7HauCeMXjXeDIy6WpAWV4aEtNo2XmSuGi9s19BGGRJA9Xr6IAXOLY97S4ymrCD0cDDbNoZhElsM9tDD+DrQ16xdWx93sDRxHl1aKAzF6N0srAi50ndFY/8o77y9CtefGaG4AZK2PvVAXgmzt8NjGm2WOTmPASUuw5xz4A+0xxQKkM0Em/Pf187vUA5scqRsurEUcf79mlycbrIzlEEnwEckxZmp8A8IIiAXrHM3Vsc6mCbhzcjLwXfVeW51bL0xakJxYP8oRCO0CzjkaMuZOLL9e/4rwC+EYpgBjABGpmxQVa/PlIxNOebZbN35LCNxOTUZT6jJi8Uj+CzoQ0GhXRhgu/aOrSgV4wsqS6z3KAx7/rEq6qbbJ9yhiMvNarF9faWypLgp5zwU7OIM5R5/upgNR8Go6H6waHBvInytC19Vg6wm3ipL+O2lqsqCa4iLqCN2XWoW9WnrGYy4//3iPYdvQsggPs6oyzswp1N9f0D5NHfKrfJasRV+NLZf1HdXLalBlKHwjmV2ByGFNGUkGSvNTruqY8+hk1PwUo2c65rl21F9CSj1+P8dSLImg3+5gAElSAKyyDyZEe0H501KvmcJqSwf9NeIMeA9xQmYkAxdmPSQkaZBt97n7Ty2ZvcAaxIs+UHXtpd/EEZ50NQWpdsVgHB
 VE+MOkAJ
 ZakGt8bWDpZ1u/fKoTiJRyfk9not4ZgeM4eEdJjzDnFD/e/51PB+2aYGWLO4lsVfqp8lbDxqj5WiOTDUpX+2xCRr+4xyDbEL3GQ4Wl5npFQhX5AB8cjfwD0TxgJLAfLecYVpdC+lUR+rcdEqeOUB6QV4PBP9af8+OomjWKHTjTisSt0TC2/HeP2CU8N0gV0Kwn+Li3dh+MgyKjgeaP4zXM+5jBWVPYbZDL45WChneYxRYBVNKQMPJbKHat2q6n2T7byHmSFBu5u0T/sL87RMUAg7spRC5Lh8lMOJpAzbQl7OGlGaKMJ5JQAdeLVfr/YlM2UstmOHwE09v/12frXCaIW+jSgoeChYywQH5wID/JFm4rQ/Me+4SYVfFYDWLHua+2JItGkTv7ucMk2KExgzOBuo8Z4+lRIpgqIBgakutNcGspeBUg6o3qPY7F1slqHVZ8KVvCg4v7OjtPMct44mMxztx1LUy2r1l37inWuARjL3PlVvb9egvkUiDiCozO1WqtGAagpScMz33ZvM+LDKgKhSDN5idVl5gyPvi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 01:59:31PM +0000, Harry Yoo wrote:
> [+Cc Relevant folks]
> 
> And a bit of context on the underlying problem.
> 
> kmalloc_nolock() could fail when there is a contention on locks
> shared across CPUs (e.g., n->list_lock in slab, zone->lock in buddy),
> or there is a decent amount of memory pressure. It's more restrictive
> than GFP_ATOMIC.
> 
> Unconditionally using kmalloc_nolock() in BPF local storage is
> unnecessarily restrictive when the program can sleep or spin, and
> Emil's patchset teaches the local storage whether the BPF program
> accessing the local storage could sleep or spin on a lock.
> 
> Answering the question "Does this context allow sleeping, or spinning
> on a lock" is extremely tricky in the Linux kernel as BPF programs
> could run and call kfuncs almost at any point in the kernel code and
> the "context" is usually encoded in the GFP flags or the process flags.
> 
> Tracking whether certain locks are taken by current context is not
> ideal either as it adds unnecessary overhead for everybody.
> 
> On Tue, Nov 24, 2026 at 06:40:11AM +0000, Alexei Starovoitov wrote:
> > On Mon, Nov 23, 2026 at 10:03 PM Emil Tsalapatis <emil@etsalapatis.com> wrote:
> > > +	/* Only try the spinning allocation when preemption disables are tracked. */
> > > +	if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && can_spin_in_alloc() &&
> > > +	    size <= KMALLOC_MAX_CACHE_SIZE && !(flags & ~nolock_flags))
> > > +		ptr = kmalloc(size, flags | GFP_NOWAIT | __GFP_NOMEMALLOC);
> > 
> > It works, but I after a bit of brainstorming the following
> > might be a better fix, since it will address the root cause:
> > Pls run it by Vlastimil, Harry, Sebastian.
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 2fef409..4368ab5 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2536,6 +2536,24 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
> >  	return NULL;
> >  }
> >  
> > +static DEFINE_WAIT_OVERRIDE_MAP(zone_nolock_map, LD_WAIT_CONFIG);
> > +
> > +/*
> > + * zone->lock is always held with IRQs disabled. A caller that runs with IRQs
> > + * enabled is not nested inside of it, so it can wait for the owner.
> > + */
> > +static bool zone_lock_nolock(struct zone *zone, unsigned long *flags)
> > +{
> > +	if (IS_ENABLED(CONFIG_PREEMPT_RT) || irqs_disabled() || in_nmi())
> > +		return spin_trylock_irqsave(&zone->lock, *flags);
> > +
> > +	/* The caller may hold a raw_spinlock_t. */
> > +	lock_map_acquire_try(&zone_nolock_map);
> > +	spin_lock_irqsave(&zone->lock, *flags);
> > +	lock_map_release(&zone_nolock_map);
> > +	return true;
> > +}
> 
> I'm not sure this is a better solution unless this could be generalized
> or abstracted further.

This is absolute atrocious shite. You cannot attempt a spin_trylock from
NMI context. That thing might be a mutex.

This should not work; if it does, that is an accident we need to fix.

