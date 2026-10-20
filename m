Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E1D606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GDAqly89
Received: by kanga.kvack.org (Postfix)
	id EBB786B014B; Tue, 20 Oct 2026 06:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45586B014E; Tue, 20 Oct 2026 06:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE63D6B0150; Tue, 20 Oct 2026 06:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4B26B014B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:02:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19BE680932
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:02:10 +0000 (UTC)
X-FDA: 85342564020.20.9ABB9A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 383AFA0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:02:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GDAqly89;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792490528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34jo2lTPBFEDXI1aSdUvkUPUth9L8yOyLhTCG7rWYZM=;
	b=DNREG/Uv3ZWgiDezMh41vWZKdtOytbW4YHoMLImq/Q1i1OpgtwjfUzFu587p3IR+2LzDzn
	owZt5QJtBbNWhAdp95O4cVgiJAV3pp+1alKL7OxMAam78h6M/m8mzkCAI+uV48Yt4yHJnP
	bfd4cBZdZw5OUJbIEaIW2IQjEaNEf8M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GDAqly89;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792490528;
	b=z+KprK/OhbUPsP99v69ZWXOqNlSj889l+jqaWmSrooAcFXOF2TnLoqRWqZMO0kgfuP7fzf
	O3yROhgr/gBuU3qQ4RCDRuNPViVqpUoUoBxH1SRBP7BbL11MB6ssgWLp3MnI1ilq6iWOOZ
	aEfGjar3G+Kk0dRtbb1cn/POW5Zp6dc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4DA643CBA;
	Tue, 20 Oct 2026 10:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78FD1F000C4;
	Tue, 20 Oct 2026 10:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792490526;
	bh=34jo2lTPBFEDXI1aSdUvkUPUth9L8yOyLhTCG7rWYZM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GDAqly89F/GH8yY5EhL1wwCAlHSQ1x3pwskc+bkhbIsZ8HRGCxNNpO9+Hxc3k2IzQ
	 YcOA5kV75DK7i08tKqUtrnU2C7yvmBBxI72+1b6zLYGfkFbxISwpQOtDQfIKK2+gDC
	 0iSWEYVdJ4tfVAqXHm1g8Wu7rA6WJKqSuFK+ikFVpHiuMEfQnK9/tr8oIpL2t3M2gC
	 Q9lincGUMOWlQBms4PTWH4SUg2PX8+Ow8Tsj3kdfDQCaS3efG70dPs+64nNk/5+QsA
	 NIMa9ANXzjLvRd9GkzFa2y5pIWyR4lllJ18vpYeltIGgelooasDh8vi4zR2zRMZcrF
	 ekgAf1uuGVzmQ==
Message-ID: <f5e7b114-2bda-49e3-974f-170211501203@kernel.org>
Date: Tue, 20 Oct 2026 12:02:01 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: skip shuffling and reporting for no-lock
 frees
Content-Language: en-US
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
 Alexander Duyck <alexanderduyck@fb.com>, David Hildenbrand
 <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261005063515.6312-1-kmehltretter@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261005063515.6312-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 383AFA0007
X-Stat-Signature: xgfo68hq8pz7k31qfafws1qz39nbhza3
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792490528-649066
X-HE-Meta: U2FsdGVkX1808sOOSOJ3hp53BG51UIW5j+Ceijm+KMStiHj0b8fIQ4+Tq+FmOoU24qyGkSCKMWoykSMiQE/gAFwp2aywqzHzKFtBQaS6AWcOV4tWhjKG4lPLRQC8FB7N1zOvu0nic17LHFGHxVw0ielbsg/AdP20zFAb/04LrLh9BdE1Q9JOHdJr8anGIqEKc9ODDcXVjrFzTpk+YIwV8LeUajoODgY6qvauCdSjiyuUMTp3E3XqV+WIxDCbkg+DbaHQq4ZYHrQN4wPezTOPwvwif8g/qCP2PKK7acfRoDbj62skfWwwrRZWe3Cb+oxdWa8dP1DgTD7kM/1YP+LxQ7SCRHN2WXp4/XbBZcKdDOkHg/ZfFH3MCKQv4oFGmPMoZw89dFLwoJrfRXGC2D1eORNkIyVw3aQMs5H1FZOTnMz6wd6QzUOl7H8vHUvyrGfJQpmwOxNmrcqMiNPHI/AFrzPYi6z5irNgy7sU4F6xlfPqDzscdwbX8pvCdJTkA/SFfnyHnqmVAeUIyXr8wGGagEwRsYCk/s9nBgN0yBm3M9Vj4krLJnmKVNnqDn03GMJ55jNTtx0RkpxnTBfVjKHlVcV9sdM7OUwsnHyGTikJBcnNRFLyHPDOBVEte0kWb0vxoIJP+yUxrihVaVP/xLa84UtmBkqaeYr0kX7j9WFkMecxgAcB7mIH+1xwxLQnzv/Ag0SXe56z72Nybu1/+28dIFBQ+7TPT8R0h8GzY1WYO5R1R2OwrcpCcdivG1Pa+66CMPuMymkrTVykN1eeh3vRH3Osl02zy6SatM42gWhdAMM6EEhzBKmifO83yJTmPv0zsaV/zU2d1GrnXHNl+yB0pTatk6fbxzEjoT1DOca5YBhQgx8aJgiln7IRFEp85Dm7ThvgWu4sXje/euX11VX2n64BMVqISS44Il80TuGPFhyCzdsKwyTvy1hEgPRnPIsObhpRFNitHWM49AsEpds
 wF0Wgi62
 /9yYOkdYkVUGKd+Q6RW7kdUVnmM0lpe7d7FfOoVcTEv5oGdIDATnlGdaiknmA57tkZ2xFxdPRED1SO5MdyG3UFbm7zVM6MiXAWnRRwA5wC6nH4OVvH3O5MSjlvOxsMEGcBew1R1z7KGXFiO156QdesF5UWEzG5RcZMM9oR4ilvLrJb+dpc3dpyibVcvupecPRWIyiQadmddINrXQ7FzaSkMslVcS9ZZ+wOc7XwDVVgf2Qg8hKk4KFgDKT9AOJfdzhSBVWGdf7UwZ56y7BNnG5gzRhzX0fImEw/0a1J0MEoofKS50v8GQf/JmKSMndL1JEn0RqAjO8zEgGwp7a5h4YFwPn3RtxREiKoz6g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/5/26 08:35, Karl Mehltretter wrote:
> free_pages_nolock() may run in NMI context or while a raw spinlock is
> held. When its zone trylock succeeds, __free_one_page() still reaches
> optional work written for ordinary frees.
> 
> shuffle_pick_tail() can refill its random-bit cache through
> get_random_u64(), which takes a per-CPU local lock.
> page_reporting_notify_free() can queue delayed work. Both operations can
> enter locking outside the trylock-or-defer mechanism used by no-lock
> frees.

For page_reporting_notify_free() are any raw spinlocks bad or is it the
scheduler locks?

> An instrumented PREEMPT_RT lockdep run forced a random-bit cache refill
> while calling free_pages_nolock() under a raw spinlock. The unpatched
> allocator reported:
> 
>     BUG: Invalid wait context
> 
> The attempted lock was batched_entropy_u64.lock in get_random_u64().
> Lockdep showed the raw test lock and zone->lock both held.

In slab we solved this by using prandom - commit a1e244a9f177 ("mm/slab: use
prandom if !allow_spin")
Could be better?

> Skip allocator shuffling and page-reporting notification for FPI_NOLOCK.
> The freed page remains on the buddy list and can be collected by a later
> reporting pass.
> 
> Trees from v6.15 through v7.2 call this flag FPI_TRYLOCK. Use
> FPI_TRYLOCK in place of FPI_NOLOCK when backporting this change.
> 
> Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
> Cc: <stable@vger.kernel.org> # see patch description, needs adjustments for <= 7.2
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> This was found while auditing the no-lock paths discussed at:
> https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com
> 
> Tested on base e767a4ea70a3 in four-vCPU x86-64 QEMU TCG with
> PREEMPT_RT, PROVE_LOCKING, PROVE_RAW_LOCK_NESTING,
> SHUFFLE_PAGE_ALLOCATOR, PAGE_REPORTING and page_alloc.shuffle=1.
> 
> A temporary initcall registered page reporting and freed 65 maximum-order
> allocations with free_pages_nolock() under a raw spinlock. This exhausts
> shuffle_pick_tail()'s cache and forces a refill.
> 
>                                              unpatched  patched
>   free_pages_nolock() calls                          65       65
>   __free_one_page() calls                           130      130
>   shuffle_pick_tail() calls                          65        0
>   page_reporting_notify_free() calls                130        0
>   reporting work pending                              1        0
>   invalid-wait-context reports                        1        0
> 
> Maximum-order splitting accounts for the 130 __free_one_page() calls.
> Both guests powered off. The patched guest emitted no diagnostics. This
> forced test does not measure normal frequency.
> 
> A second A/B used no test-only MM caller. A BPF arena program attached to
> mm_page_free_batched requested 2,048 pages from a memcg-limited map. Partial
> failures rolled allocated pages back through free_pages_nolock() while the
> tracepoint held the per-CPU page-list lock. A virtio-balloon device provided
> page reporting.
> 
>                                       unpatched  patched
>   arena allocation attempts                  70       70
>   arena allocation failures                  70       70
>   shuffle calls from rollback                 9        0
>   get_random_u64() calls from shuffle         1        0
>   reporting notifications                    12        0
>   delayed-work queues                         5        0
> 
> Both guests powered off without a diagnostic. This confirms that an in-tree
> caller reaches the optional operations. It did not reproduce a deadlock or
> lockdep warning.
> 
> The upstream form applies to v7.3-rc1, mainline and next-20261002. The
> FPI_TRYLOCK backport applies to v6.15 through v7.2. mm/page_alloc.o builds
> on v6.18 and v7.2.7. Stable backports were not runtime tested.
> 
>  mm/page_alloc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..3e21dc90b858 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -89,7 +89,10 @@ typedef int __bitwise fpi_t;
>   */
>  #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
>  
> -/* Free the page without taking locks. Rely on trylock only. */
> +/*
> + * Request the no-lock free path. Use trylocks and skip optional operations
> + * which can take other locks or queue work.
> + */
>  #define FPI_NOLOCK		((__force fpi_t)BIT(2))
>  
>  /* free_pages_prepare() has already been called for page(s) being freed. */
> @@ -1013,7 +1016,7 @@ static inline void __free_one_page(struct page *page,
>  
>  	if (fpi_flags & FPI_TO_TAIL)
>  		to_tail = true;
> -	else if (is_shuffle_order(order))
> +	else if (!(fpi_flags & FPI_NOLOCK) && is_shuffle_order(order))

is_shuffle_order() should be checked first as it has
CONFIG_SHUFFLE_PAGE_ALLOCATOR=n compole-time false variant, and static key.

>  		to_tail = shuffle_pick_tail();
>  	else
>  		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
> @@ -1021,7 +1024,7 @@ static inline void __free_one_page(struct page *page,
>  	__add_to_free_list(page, zone, order, migratetype, to_tail);
>  
>  	/* Notify page reporting subsystem of freed page */
> -	if (!(fpi_flags & FPI_SKIP_REPORT_NOTIFY))
> +	if (!(fpi_flags & (FPI_SKIP_REPORT_NOTIFY | FPI_NOLOCK)))

Maybe add a comment why we check FPI_NOLOCK too?

>  		page_reporting_notify_free(order);
>  }
>  


