Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE71B606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSnrQyfZ
Received: by kanga.kvack.org (Postfix)
	id D0A5D6B0704; Tue, 24 Nov 2026 08:59:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA5D6B0705; Tue, 24 Nov 2026 08:59:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7C56B0706; Tue, 24 Nov 2026 08:59:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 988926B0704
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B837C0BAF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:59:36 +0000 (UTC)
X-FDA: 85470170352.07.8A7F2B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A06D810000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:59:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSnrQyfZ;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528774;
	b=1KU6npzZaWMOq6oa27Y0+zsivRIuVq4hCYhd9hwnB3XFEE0SjH6QOFQlX5pqRRUlV7t0qj
	IILOndk7Ks/TNmPJLKV64rwF8VjBjR3XevdUW309HqlXvTmV2rlp3Xiv+PpqWpXt6E//RZ
	ngkPFov/GrSp3P+5NEZjeWxdvqOatd8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvsfueMHEyVjE37oaEUJidZMPTJVXlpVOUA/4h72CTE=;
	b=hZBbYnLcY+5ijxkKCzf9DYgQq1IJlU8x6TFK0kdVk50anLpXLbZeYYKmYUkkKjrgRXNs6W
	YvCos/69kxSSBGy69gsj6r59fftCBM8Xv0BlMHsMCMmRV5ZYHLTLvRZUZpIAdjgGnzAC8p
	KQUTsfloYls9TCRxtsncMuJhIUfCEv8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSnrQyfZ;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F61D60F85;
	Tue, 24 Nov 2026 13:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596401F000C4;
	Tue, 24 Nov 2026 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528773;
	bh=kvsfueMHEyVjE37oaEUJidZMPTJVXlpVOUA/4h72CTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VSnrQyfZpr4OAwsGrcz8BHCW4/klS/ONxfDAooEDvS8hEw0h8ATzx6RRag7GaRbUZ
	 PdCzu2czJSsynBun1Xe2QTv6o9kwzFJ2AmPJp1aZPCrtokFkcSv4FeIFv9pmKChNzK
	 5PT2q2qOophF71Z2WpnE5nLRQsMCLxPoDPEJkAuyNfu7NIlSUc9Wgxi3He8tHJc9H4
	 /kokeiWu0iDvJ21O7BPsMsGc+LdOqVpgH3DMJJuJhMaqBpbTKo6iE+qyzLBXOct9b1
	 m909zcbnsZXi6tODHQA5YzLCtB4tz0No6fKbf4ksBR2o/vVOSbqEkq47hKdlg1oY/B
	 cK+Ku5T+1/oyQ==
Date: Tue, 24 Nov 2026 13:59:31 +0000
From: Harry Yoo <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Emil Tsalapatis <emil@etsalapatis.com>, bpf@vger.kernel.org, 
	andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, daniel@iogearbox.net, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
Message-ID: <awWRZ9xCzWLnj_R6@thinkstation>
References: <20261124060357.11700-1-emil@etsalapatis.com>
 <20261124060357.11700-2-emil@etsalapatis.com>
 <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A06D810000A
X-Stat-Signature: wfhdg9satrtdbf3qfeeb8xt15mz6wz8t
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795528774-837520
X-HE-Meta: U2FsdGVkX18I++Wk9jfFsiIqD/Jx5R+WE8A8/ltzeCbNY5PhU+2PJJNuEpQEBSh3Ux+Je87nubwQVR3GM219HSRUDhBovLYygdM+BxzSHDdgAfLfqFszLkrYr5cINx8r8idm8wihyZJxosTd/RP7StJxInqyIuuVN5vP2Vq5UOpw5bGSd1DkFKk18A1IYMhDq3KvR33GC9rkpZ4Fnxk3c7CjGcqJlcbcguCgqEEzYQJr7En3mgtRL0+j+KkSE21SxrVf7CaHLHjzPnS6ZeAUHKoXChldLXxgECJR730pGsez8jb50l5A6pzhnYyXx0l4udKn6Q2wLu3Key4c6hIeqPEkJHrhpRvzJ5CnILQPQewRZmJfDSfWFf8YIaLqMQFuy1qH08ycL1m0PI6OxccGJxliuuh10a/waqWsC4AlzGBR54GdtNbKlYkXbKmaaJfnogWE/8MbEzBe7PXh6a7KDyB0Y/3jEgb3l4ui084P8L/f6H7UjZPY2/Yk/Q4rRBI1dU1QoLM4ujIzWs+sHq/Qy4w9wF916G5JBD85W7sGYSROKHGqc068tRErSvb9RhLPXPtjJj45ZoKvWxlxJ/hGUBVt38Ia8w7y3G7M2N178j/oHBYTxaKPtWNdDCUtPnz0qIWEl18BUoawi9yViGRwj+0AiJDS2YolaazSQDKZzcuBOSlT0w+YDFNtxPvEqVhRtJu3We4VNZ0HAPDPe/jJ7Na+Y+YEBAyDDdF9YZeMx2YQuzq+8KJndWTEvXUvipCSs4wFs5iDbOfFK/skm7DqxNeEkSHFkvsj+5w3YKvTlSm4qVq1mDaKqSFSOL2gms2VnuXOQTyWDNxPr7kU9c/AirRmfm3ouizx0U7OhToBcBUPvolhGDyKXYVpVFruyNrGwJc+6qhAtMecfSzAXEih4s4sMtbhIYslZpMkJvV3YFHt7aWQrsr4VVgIMEVqdegbO7dOAG7eE7Yy0YkPYbs
 9iDr3tTu
 s1GyKDnGmPQVcB6GRENJMXR5kXPG/sk1iRiJHld59YhQbI99e19P2LUAbg92AcFD9Pefpo2krx4ojlBY39DvkXAjFhOTaQj0l43Os/0PiF54alb6uKkOAU9CDVfRI+hi8zYt7OnFm9OKppR+dCyUJe0QE4mfL2BswED69dZQlW/fj8Am8Rz0Kai1BvA8DDi7kjbP81VEC6BQyBOOzdB42fulmbN/6cVG1jLl5HOGNdAjL/WzwCN7ccBYua45NWNsLAwc0zsQBZiHNL72mS/RFYU8t8HYZT3OC+OMAS1sPUMLz1XzFB8Fs7TKqleYIO2XGOM2pCfMz2mkBMYtDW66Q/6p97jePo1BbR7deVjUJTodGwoK73Vx/ByvfBa51/gjRcWp2SKCxdkvn8OuWWtiqp+qxMW1pwwgRb6YRzh9HV4bqE6xWa8bRlPolzFVsC/W10NWb73cQgkjtyKfWxMTr8dMCxhaz8ydrp+QaeqmFZ3GzSlaqEJw4TpBm76g7EX9EwI7EYRCQX6LWvYe5kcXCIVR2t9z4ZZhzoQusADrM+Fhob2G/qlcVkK9kgrgnpBrOAGfvvRAJCQUHFK7RymNOeUCuP4JxZOjPnAQGPhljxw8QlRwbw3QrG1Bb3aBq57WEEZGMH4d0srLqlOtakeKre8qWng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[+Cc Relevant folks]

And a bit of context on the underlying problem.

kmalloc_nolock() could fail when there is a contention on locks
shared across CPUs (e.g., n->list_lock in slab, zone->lock in buddy),
or there is a decent amount of memory pressure. It's more restrictive
than GFP_ATOMIC.

Unconditionally using kmalloc_nolock() in BPF local storage is
unnecessarily restrictive when the program can sleep or spin, and
Emil's patchset teaches the local storage whether the BPF program
accessing the local storage could sleep or spin on a lock.

Answering the question "Does this context allow sleeping, or spinning
on a lock" is extremely tricky in the Linux kernel as BPF programs
could run and call kfuncs almost at any point in the kernel code and
the "context" is usually encoded in the GFP flags or the process flags.

Tracking whether certain locks are taken by current context is not
ideal either as it adds unnecessary overhead for everybody.

On Tue, Nov 24, 2026 at 06:40:11AM +0000, Alexei Starovoitov wrote:
> On Mon, Nov 23, 2026 at 10:03 PM Emil Tsalapatis <emil@etsalapatis.com> wrote:
> > +	/* Only try the spinning allocation when preemption disables are tracked. */
> > +	if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && can_spin_in_alloc() &&
> > +	    size <= KMALLOC_MAX_CACHE_SIZE && !(flags & ~nolock_flags))
> > +		ptr = kmalloc(size, flags | GFP_NOWAIT | __GFP_NOMEMALLOC);
> 
> It works, but I after a bit of brainstorming the following
> might be a better fix, since it will address the root cause:
> Pls run it by Vlastimil, Harry, Sebastian.
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2fef409..4368ab5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2536,6 +2536,24 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
>  	return NULL;
>  }
>  
> +static DEFINE_WAIT_OVERRIDE_MAP(zone_nolock_map, LD_WAIT_CONFIG);
> +
> +/*
> + * zone->lock is always held with IRQs disabled. A caller that runs with IRQs
> + * enabled is not nested inside of it, so it can wait for the owner.
> + */
> +static bool zone_lock_nolock(struct zone *zone, unsigned long *flags)
> +{
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) || irqs_disabled() || in_nmi())
> +		return spin_trylock_irqsave(&zone->lock, *flags);
> +
> +	/* The caller may hold a raw_spinlock_t. */
> +	lock_map_acquire_try(&zone_nolock_map);
> +	spin_lock_irqsave(&zone->lock, *flags);
> +	lock_map_release(&zone_nolock_map);
> +	return true;
> +}

I'm not sure this is a better solution unless this could be generalized
or abstracted further.

>  /*
>   * Obtain a specified number of elements from the buddy allocator, all under
>   * a single hold of the lock, for efficiency.  Add them to the supplied list.
> @@ -2550,7 +2568,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>  	int i;
>  
>  	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
> -		if (!spin_trylock_irqsave(&zone->lock, flags))
> +		if (!zone_lock_nolock(zone, &flags))
>  			return 0;
>  	} else {
>  		spin_lock_irqsave(&zone->lock, flags);
> @@ -3237,7 +3255,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  	do {
>  		page = NULL;
>  		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
> -			if (!spin_trylock_irqsave(&zone->lock, flags))
> +			if (!zone_lock_nolock(zone, &flags))
>  				return NULL;
>  		} else {
>  			spin_lock_irqsave(&zone->lock, flags);
> 
> pw-bot: cr

-- 
Cheers,
Harry / Hyeonggon

