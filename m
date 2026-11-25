Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C9D606A339
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BetaRQnY
Received: by kanga.kvack.org (Postfix)
	id 765AC6B0A37; Wed, 25 Nov 2026 09:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7165E6B0A38; Wed, 25 Nov 2026 09:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605F76B0A39; Wed, 25 Nov 2026 09:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F31C6B0A37
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:31:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD49B40F52
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:31:14 +0000 (UTC)
X-FDA: 85473878868.01.79BC3D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA1D940010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:31:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BetaRQnY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795617073;
	b=KdBuoVcLSXwrs1LAIE8qQcZZk9UvlqKJGwyLtzwEkx8/u/eQEnfb3dY4DO0zHISqr4ncyI
	5S0YgYIhmfW4lG+jqYZX7fHLYsb5V7bUwzqa4kH6U/F82mYeFRoISwQlrxDBNm3Gxvu4LA
	+G0sy5uWVtMzqm4j2tQy/GXGIoo8T/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795617073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7NfTeHgie8kk98wdxr3cUN3JAiQZkYebkrK1SD6t6w=;
	b=sAya0VfZEXR4GMe2TmonKmZjkIx/MCAHkAdpIOJgzGxKCBbexNnEYp1gfVqINY+9sIH9Ou
	wEfs2lcCTHtc6fmFZwdDuSTM0OW3w/w42IcdxcXHH5ypWZNA71ln7MmHYcE85eUqcg3OBu
	0isUkWHpma6405k3fgN5mDzlpkIhDyQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BetaRQnY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC817623F4;
	Wed, 25 Nov 2026 14:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ACE1F000D0;
	Wed, 25 Nov 2026 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795617054;
	bh=o7NfTeHgie8kk98wdxr3cUN3JAiQZkYebkrK1SD6t6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BetaRQnYjnzenM/h40NWfe8nEyvUTBR0OueMt/3UKx9DphWz5Jz+xIVdKbjZGzqjr
	 xvkFy4THWdsptklDzOyBa65zOoqT96e81bl+eq2pCE1lHLWudPYCDr9GBzAqQB2pfZ
	 CXhHzUwrtVlcN6cn/5dgEEjfx0eEdeZPYZHoW5BnxzOl8Q1U/Rlp+mGjwKnzyGhX/r
	 o+Uvo+FOCvjFwO6iSz7GU8/Fd8GVgkk8v30gw2LMKQT0x5N4vzBoQUiQtpKloaYUGB
	 uuv/vxu6/v+icbuGJBKEBNpvxlM1T0XNbvqMBtiVZzZIWk2BrDrPpVa5mxuDF5vYan
	 C5p8uR7gn1fZg==
Date: Wed, 25 Nov 2026 14:30:52 +0000
From: Harry Yoo <harry@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, daniel@iogearbox.net, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
Message-ID: <awbvek-HS3OJYJGF@thinkstation>
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com>
 <awWRZ9xCzWLnj_R6@thinkstation>
 <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: CA1D940010
X-Stat-Signature: pebpac81zzcf1rrxt63p4unhnpmubhup
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795617072-813630
X-HE-Meta: U2FsdGVkX1+nDSrD6cZVizgEnqL6+NYpnDL7uXK7gj3liT9cDwn8Y9g2XWN7BHzxE2gVU5DUUDFID6zG6gwOvv7mKv4vRQsZ1yktNRIGcmLnoh7P1dVdIvXTeVv9QaLJm0q1trF9HI3tUPiEmzC40jV3VAyqsXgRI9ScwDIpt1Nm40zs9GzJCCz71wp5ctafpbQRlDYquCc66pyK4sshvltU6VuL3nUpLz4oqc0rJz7aDCNl+MKoFjdNQHUw7BMTMMMb0yKp5P04484F2gBJVIduaBJu4uTqpSgyphUho/c+I0tW5TOBQXOWof5xH5WKSRn3c3tPNdaocJnepZgmxaH6aSeKvV/aCJEx3Kjkxia0vTnKjGeTXDQsKHm4ST1/J7mZXGwE1q06MkbJQHuvl/00Y2iBOrZUjhKdTaLGF1ML880vCBA2VjcTZGnf/tvwHxB+D3HtU7sNnUpxHzdCqjvRFMgY1+Rtvt8WD5Z9ALcqNr5pPx9wdr6ZwPIHw9Fp//XQCxTvZuPMa2i/mInh2zg4Urs1ezIKiB1vewt0mWpEh5BUqe35McGf5y3ZCQZ0jzrAcCvpVla4g/q6L49h/VvnVGUQ5FjIGC2194A+h7mXcvKpYds03s3qEdaHYe70jWj/uoK7GKPKaRpPLsz4/pKYVdYp2NCP2bt3jxm9liowJyjglvIwr0V6UE2vW9HUgs0Ur9sRy5GjePNDS3nMXhxqcnLMUUPeL2AU929wle0WJ41thDBxSvX4siuYYtnp1KJ+UxeVhA6wDi6vbiOpnl5BR/sD/8lYuyCY5jNDZbiTXj0rf0Tf3/pVD2P+mZYnWKsLidNUJRq3vpM79qODHjxoW3OxlHIKeBdeork7wimLhvUg1nfOCrogihUT18KpR6PY1BbEXrAwzORNMwUbTL0mKB5Ulgq60QuZ1KYjb0tWazXgy68NGTEMwA5jFGeK3pi/DiTx/LMANIAQH74
 n8FlLdPR
 GIFyRcHWG0t42qOMMrWmVgKAKTL0HkrKuCciP8c+UmVxJeAGbPFAYCTeWj/jVkBUWyh34Mx1Vg/2qYzk+eJmIKztwOradGS6TjWDqBo7ZnY2+zhRwkvzrJho1ju2ImdYktXi0oWJzSa7WCDoFL/K8kbPVqwssSg2htmZxwKOYZwSClJseaCV7Qo5hE4V7gFiSDcYeGwS6BVT28P46T8voImTqtd1kP4hPTMctYdIRq95suDIzigJKMsiNTycJWDt9sFtCswBug2WOcjRWvO3jl4Ooo78dDzaYrumxbj4u9avZTV7SVAxIJRusOFDNZFGI/e9LkkpzR5IOiJCiBfPDLisPq/r7aqP5ssIc7fUK5DQ4ykHaaLzkmaS0ysKG06N8Tu3fFTbfW+SsAKbWcCnR6NkpmUzLtHB6Wx36dgVKufYkNAN9JOqA02R02NgvB30/Xb+5UrzljWcgh8QuZFyaigPoFQPSfx4JrLJ0JbrmpjY88H8PVfWLkg0CE2i32dWqg1eePCagHNBvKwg/XQkouf/STSyniYWUV5TGN6afqFDhxxHTa2yg/B1Z/7/lBJwMtdH4ITchDIzNBFSedTMcK/4JDm2PndK3tBhNvPgQ4eaS/cAn1zYAobr0hFY5TmATaS+9i+a0tVzbYViagi6nYF2Kbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 03:09:02PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 24, 2026 at 01:59:31PM +0000, Harry Yoo wrote:
> > [+Cc Relevant folks]
> > On Tue, Nov 24, 2026 at 06:40:11AM +0000, Alexei Starovoitov wrote:
> > > On Mon, Nov 23, 2026 at 10:03 PM Emil Tsalapatis <emil@etsalapatis.com> wrote:
> > > > +	/* Only try the spinning allocation when preemption disables are tracked. */
> > > > +	if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && can_spin_in_alloc() &&
> > > > +	    size <= KMALLOC_MAX_CACHE_SIZE && !(flags & ~nolock_flags))
> > > > +		ptr = kmalloc(size, flags | GFP_NOWAIT | __GFP_NOMEMALLOC);
> > > 
> > > It works, but I after a bit of brainstorming the following
> > > might be a better fix, since it will address the root cause:
> > > Pls run it by Vlastimil, Harry, Sebastian.
> > >
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 2fef409..4368ab5 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -2536,6 +2536,24 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
> > >  	return NULL;
> > >  }
> > >  
> > > +static DEFINE_WAIT_OVERRIDE_MAP(zone_nolock_map, LD_WAIT_CONFIG);
> > > +
> > > +/*
> > > + * zone->lock is always held with IRQs disabled. A caller that runs with IRQs
> > > + * enabled is not nested inside of it, so it can wait for the owner.
> > > + */
> > > +static bool zone_lock_nolock(struct zone *zone, unsigned long *flags)
> > > +{
> > > +	if (IS_ENABLED(CONFIG_PREEMPT_RT) || irqs_disabled() || in_nmi())
> > > +		return spin_trylock_irqsave(&zone->lock, *flags);
> > > +
> > > +	/* The caller may hold a raw_spinlock_t. */
> > > +	lock_map_acquire_try(&zone_nolock_map);
> > > +	spin_lock_irqsave(&zone->lock, *flags);
> > > +	lock_map_release(&zone_nolock_map);
> > > +	return true;
> > > +}
> > 
> > I'm not sure this is a better solution unless this could be generalized
> > or abstracted further.
> 
> This is absolute atrocious shite. You cannot attempt a spin_trylock from
> NMI context. That thing might be a mutex.

Uh, right. We went through this when kmalloc_nolock() was introduced.

> This should not work; if it does, that is an accident we need to fix.

Current implementation handles this by can_spin_trylock() in
mm/internal.h.

One remaining accident we're aware is that we cannot attempt a
spin_trylock or local_trylock under pi_lock (even on !RT).

Currently I don't have a good idea to fix this :/

-- 
Cheers,
Harry / Hyeonggon

