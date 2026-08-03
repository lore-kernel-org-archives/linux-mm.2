Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840E7C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1846B0088; Mon,  3 Aug 2026 02:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9096B0092; Mon,  3 Aug 2026 02:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEAC6B0093; Mon,  3 Aug 2026 02:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37ABC6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:54:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCE8A1A05DC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:54:27 +0000 (UTC)
X-FDA: 85059044574.26.2900FBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3E754100006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:54:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nd47rhTt;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785740066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGmx5lhbVnAxzqXa5NcpYNSJJkO7XomAJLKorNkVBLQ=;
	b=1Oyu/sKUQE+zmRwr/vMMTMiZmwbuDSTo2zcbZoR8VLV3KqCdow1KroYGO59oLYnD8iGhNt
	aQPavZf/MKRu/9u+8rOrP2k5sQyNTDSARVrkoXy0K0z3tJk7P39/VGOThZcKJdsYA/LpdF
	TBzv47jSTpgy9LBdSXtzLCbSOrTLeAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785740066;
	b=r8MoTGD3JT0ukgYU2T83buqTTwseu2WT1KiJdRQ4IYq+zpDQthW4kGg5YevlRTCj3UgjyJ
	SmO3yg/fYu5nB4R2W5F7R6NR9dBDTMtzh7Qn0m3+x4ctx/zgewIfelcLPCNU3JWB9NVFZl
	7XKzjw8clUnGphKAPJMZNDW3ha5doI4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nd47rhTt;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F7E7600FF;
	Mon,  3 Aug 2026 06:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAC71F000E9;
	Mon,  3 Aug 2026 06:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785740065;
	bh=bGmx5lhbVnAxzqXa5NcpYNSJJkO7XomAJLKorNkVBLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nd47rhTtI+3syd5qNqlozDRPj+MZsHdtqj4UsUwriigszD5j7vQspVOF6993/8yAk
	 tMmb/AvvSrKNr4wmz1jbEy5Dz8vekFnPcjJM8mlxZiRKFXGGgIPMqLwugUlP58GnwP
	 4DhEc0re1DgvbQBFJfFhlOlE0rf4kdJ887Vo0M/OCKPFcraNGyW/SYnMSxlS0Ro+s9
	 nHj/Ux+5IaWLEUnlHazmHs2v7X0JdxV6La2QuAcgXedBK5VOqsozxsHZLotFBeb29U
	 Bb2++w1FF8FPOxtwbJtnAtj7H6iKp65RtL7ZKFVt4R7RyvXeiSNRzXkVsXWFu9i9at
	 sueamA+91bxZg==
Date: Mon, 3 Aug 2026 09:54:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ionut Nechita <ionut.nechita@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugzilla-daemon@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/isolation: Defer freeing of the bootmem
 housekeeping cpumasks
Message-ID: <anA7GhzjZoi293Yy@kernel.org>
References: <20260728134016.674388f101f141362598240f@linux-foundation.org>
 <20260802115623.110513-1-ionut.nechita@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802115623.110513-1-ionut.nechita@windriver.com>
X-Stat-Signature: 3d5zaapwp59rex7y168yqxtxfqsqihdn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E754100006
X-HE-Tag: 1785740066-524094
X-HE-Meta: U2FsdGVkX1+LS0ABadimGrxCfpdiiGP0u97NcNtddpv0dZqzw/jYs2rBceN0iQCwt67uVbqSKYwF3UaKYeUw/1j6qxD+TiUyJYvRBg+bcvk5W39RJdGoMVHGYxCMlgcWixknLmgTRo+iQhmDJyVeiuG/VbJaRkQW9EjS98R3GpkATed0ROdPy74eyYHVbVntM6Ht0lBaNTigelBydaLoKm7Qx68LU8ijd0aHT5cx0qc9yGnIQS9Jd8d8gkBv3eMnGIbstGF/v7PJsDNhuIaQJdsmwrGHAu0cNCNqCxEJL3oVn0y3xeR2VM+/DsWWUhozJ6Nw/+88/9t5cU3msSmRDOxb46ffthidVJ6Bfu6+dX0TT7mScuM95jp/wpnv5Tgo5kMYGwmihef/xxdrsftsyby1qTxZ+amo2UxXE6kCtqmTR8Zo+RgjiYw51qOE4wCbGKmJDMi9vstU6MnbpDUMZb6abFe5u49Na47TWfWbx3hdQ3+aDERF1MuYCi550LZRhX/bJ8k+YW3J2zP9ORrwhiQ2CD9dIbLBxnzK2Vh3fdbeMx7fFl7A+WfAcrKpWlyrXPHIknyL1YFyapGJm7DHf4Kn2ZtHZbgVrhl+YjvwnfZp9lyIXVtmkfEWN0fLbcJpt8Co0Sa4bIbvGZ06kjQvuALTq7JPrYk9X6g2h3NQZfoiMYq3/MB4PCXC8ajt8NtmORCINJ6WUn4sMlFeTeRqE3rjUAugIsRB3auZONAjfRLM+OuewntQASIR/GxrkQiyfNafyYLtI/BZMHM+SAxzJriEmv4WsK7+6Ec4Q7A6vpWpxRaBFFEjxpa3PgOU9ZlxankV1KHYPbCYoqWVr755M7mten4wzVDUCh+oYkEFhE8voiVaxtmd5Gby6oi2MTRGqPwXUCC9EodIGPD0ze7eUgrzGFLW9fPi0d6xCRciVhfHqsC5wdOOl6SA/cMBYI7xrrhtLt2uhqZefDUjyZL
 /xy7pR6X
 MVVtlth5qr2wLaHe6H0iGRMqggq2GJ2eYlakX3MaXKGyJfJuRwr9cyQBng/MkDdKdi5eWpsXvk3mLhKF4GesklvrAUhI1MLCO6jl1NdnwwQXBjIcdj9WUc8K5UGrrPto1ibRAMKeOXNZ555esKQIUWVLOZSBStOGvMehdL8V3VFdGYBs3s9xDGLWelPyW6P0zglbe0yQFo6GWXkQjrV1mt70zfDGqdILh4+/yg8nA3ujLVTfuTPYV7UoiFUDJO1YvQ1BCO7wv8q4G1CgUH8P8TSgduknTT66cW08zC03y3P+qv4+3n5JjpwRuSw/PzE+zcINHjkFAqGxgZ7dzfx0sVtUtPyaqCJufDubbQVYioLWw41rDkNKAxLX2WWFqSfzSzj1prAr4JLjY7Ks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 02:56:23PM +0300, Ionut Nechita wrote:
> housekeeping_setup() allocates the housekeeping cpumasks from memblock
> while parsing the command line, long before the page allocator exists.
> housekeeping_init() then reallocates them with kmalloc(), so that a later
> runtime update can free the old mask with kfree(), and releases the
> memblock allocations with memblock_free().
> 
> That release is not safe where it currently sits. housekeeping_init() is
> called from start_kernel() after mm_core_init(), so slab_is_available()
> is already true and memblock_phys_free() takes the __free_reserved_area()
> path. But it is still called long before page_alloc_init_late(), so with
> CONFIG_DEFERRED_STRUCT_PAGE_INIT=y the deferred part of the memory map is
> not initialized yet, and __free_reserved_area() refuses to touch it:
> 
> Record the bootmem masks instead and release them from a core_initcall,
> which runs after page_alloc_init_late() has initialized the deferred
> memory map. early_initcall() would still be too early: kernel_init_freeable()
> runs do_pre_smp_initcalls() before page_alloc_init_late().
> 
> Masks that housekeeping_init() did not manage to replace, because
> kmalloc() failed, are never recorded and therefore stay live, preserving
> the existing error behaviour.
> 
> Fixes: 27c3a5967f05 ("sched/isolation: Convert housekeeping cpumasks to rcu pointers")
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221804
> Link: https://lore.kernel.org/linux-mm/20260728134016.674388f101f141362598240f@linux-foundation.org/
> Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Some nits below.

> ---
>  kernel/sched/isolation.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index ef152d401fe2..5c36e33bac50 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -28,6 +28,17 @@ struct housekeeping {
>  
>  static struct housekeeping housekeeping;
>  
> +/*
> + * Bootmem cpumasks that housekeeping_init() has replaced with kmalloc()ed

Nit: s/has replaced/replaces

> + * copies. They can't be released right there: housekeeping_init() runs once
> + * the page allocator and slab are up, but before page_alloc_init_late() has
> + * initialized the deferred part of the memory map, and memblock_free() then
> + * reaches __free_reserved_area(), which refuses to touch a memory map that
> + * isn't fully initialized yet. Record them instead and release them from a
> + * core_initcall, which runs after page_alloc_init_late().

And I'd split it into 3 paragraphs :)

- the first sentence
- description why that memory can't be released in housekeeping_init()
- Record them ...

> + */
> +static struct cpumask *housekeeping_bootmem_masks[HK_TYPE_MAX] __initdata;
> +
>  bool housekeeping_enabled(enum hk_type type)
>  {
>  	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
> @@ -189,10 +200,21 @@ void __init housekeeping_init(void)
>  		WARN_ON_ONCE(cpumask_empty(omask));
>  		cpumask_copy(nmask, omask);
>  		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
> -		memblock_free(omask, cpumask_size());
> +		housekeeping_bootmem_masks[type] = omask;
>  	}
>  }
>  
> +static int __init housekeeping_free_bootmem_masks(void)
> +{
> +	enum hk_type type;
> +
> +	for (type = 0; type < HK_TYPE_MAX; type++)
> +		memblock_free(housekeeping_bootmem_masks[type], cpumask_size());
> +
> +	return 0;
> +}
> +core_initcall(housekeeping_free_bootmem_masks);
> +
>  static void __init housekeeping_setup_type(enum hk_type type,
>  					   cpumask_var_t housekeeping_staging)
>  {
> 
> base-commit: 2d2338c93da79b3bfe4b6099a931d9468d539952
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

