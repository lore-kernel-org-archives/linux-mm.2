Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34EEECA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 15:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3206B0096; Wed,  7 Oct 2026 11:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463F56B0098; Wed,  7 Oct 2026 11:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355656B009B; Wed,  7 Oct 2026 11:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14BED6B0096
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:53:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 852FEC02AA
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:53:36 +0000 (UTC)
X-FDA: 85296275232.02.B1D3F44
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5BB2420004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:53:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wxvJRYUm;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791388414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0IQrERTmaG0I9V8RlATq0HvuoFbiBOU9j5JF9KDiPOM=;
	b=33iOEn7zR3AE2YsFCkZCBwZuV9bj2V5rN0/K+l4W/AutJhS5iEHSB2fP6iVx22DosZW5i3
	ZL0ZeiUmb3pVtSXh7jjLW+0lL5Pw3TpeRHeg5sc1Yfh4koQtWBA9lJKH5lNiiGjv2Tp6C3
	xLY6LMBXaAme87r2ddxnYWv7TgWoCEA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wxvJRYUm;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791388414;
	b=qLxt3nM86zPfo715tfCqv6G8FHXkRbVlCfl8kBwbeTRwsVhiyQz17Vo4xT/+F4AJAAlyVH
	GFN7uYHC4wBpFW8zi4Un/Ba9kK+v15VCZFu3Q+fI+Lku3/9yLb+XP50hyxI7w0m/anIrC5
	GeIa6HZe3LqNwfrHMUszLZEWGQl9hHQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NN1LFKmcwSNUSABIR1+OWEbwCszOVMREwMQ7NIyyAac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791388409; v=1; x=1791993209;
 b=wxvJRYUmC86AieqJtGF6G1/7QXvgIOrb3OYZD7dVSOp4wfaUJP/DmL4skpZFZUN6yKBI7X8u
 99/JEKAy7c0xDklovs2fx3zR2Fe0Wtb3q8DLOlvv9fqLRftOyko4NSovHk3hqqks77++6paVRac
 Y60FnkVo5LY0/GURIaihMrb0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 096a6bbfb1de998f;
	Wed, 07 Oct 2026 15:53:19 +0000
X-Mizu-Trace-ID: 096a6bbfb1de998f
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Wed,  7 Oct 2026 08:53:14 -0700
Message-ID: <20261007155316.2010164-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261006091815.897133-1-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5BB2420004
X-Stat-Signature: 17b4ywujybqpg7f1pqg5pwjecjoxjfqb
X-HE-Tag: 1791388414-144863
X-HE-Meta: U2FsdGVkX1+tAY26YZOsHKfbSCA+LGl3/fgOfo07GYyrK2hgPxerMYKcPmSTJJklnuGvJoBXpIgfxq9XcuP6cPUour+jLxfo8HRWof1653xlwifd9x0IxTcdV8BMw5adULZJ/B52Nl0QxP4nlwnyP5d7Hlp5ev347J2u5ELe3wFai070t9/hQwwdktk00gbSsj0qUZuGYDzf/b3ZeVucpyy6MQPuk8aKEpJMil2yMF/zQ3NMBVCWTXw9nd5zkEsUo4QjIqjsgee0Zduz/CUxdws8b4cqppP7rntCw/II3Gq//rWPChJYlsBdjeYkzQVRAN2hITKrg4v3bBpc/2osAMB3FE2lLqN36OxoqsVRKkKiStZ52mwFYWJJbJugD4lxdqqMQEgyGIYtWyHJpWHncO7twtWZCyZUFU7aq83htSa4AAdFoy5BWq1+jOnLUZDG+UeXioUH0N1tdeGa5UdwzM8hIoj1X0vxL71ewNe9s2fAlLUrAD+1yjFgAa3I0oqX/7miWTTWw3hLmiLRA3SlxMm8+X5r4rCTdtfTEN35lhdLhW8t950mRWKCuwZtuU7Jwma56wznSj4ahUO033hLiy+wWmq4t2aFEEzHmYDaVex7/iae80t0ffw2r7clwPmXqlOo6yR+3QFD/CYwAGK0TBlCgCcmAqaP7/7A/CCzwKEm5nmVQaRCU8cKr0ntPfDOA83G1+2NwLfBUp6yTQm5LMqtHggoKqMcNgHvtxpzqwiAnbnTX7iY1yaKLkkG7ZzJ+T7MLAxDcrMChBVVCW/HKZMu5h3fFPsLOGgYXGtD0DcS04gy5T1DBOeEThq0x2fr+5J88WlNxnvTF0M+us3Sj3jGedUjrGvDO+eZ+YBy+KRjKGFfzMxomyEBjHKTv9c+CEXBDswN0Uo0CmB3SBjr2ozsGcveRKBobfxA3TpEOpC2BPO1Js6i0e12Ul08fwEXAjZY82cNMyX0GYE9vJ1
 21JKzSNo
 pITKU1LkezSVyNK6AZvNj8Ki4Fft0AL4KxBrZVchckH+7prriKxRvov8QGAB0qGZS2EVXrss4+ePYUw2AMWUHnDsy6O+lF3XtJ8B50IFHmEga1skVC7/6Gw5WPsDNrMklSkBr563qW/HjTcXHvuu8MSMnl5hboXjCMeCinutX48cfVcUrphnOzXR+MjD1Pnoohwtx6I4K4KkuT8vMrsLi4plihooJI1BRk6Y6sDSb2QBj0fug31PyfB9wPVjhBFiqnX0tioBI/ZPBE8dCltp6iPfi1uCszhwvSisqqjw3wS7T3xI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Oct 2026 10:18:13 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> storm in defrag_mode"), direct reclaim and compaction for non-movable
> requests under defrag_mode run at pageblock_order, to produce the whole
> blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> still use the request order. An order-0 request can therefore retry
> indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> 
> - Reclaim at pageblock_order gives up after one pass as soon as a zone
>   looks compaction_ready(), and do_try_to_free_pages() then returns 1
>   even though nothing was reclaimed. It returns before the retry that
>   would reclaim memory.low-protected cgroups, so when most memory is
>   protected, the pass that did run finds next to nothing.
> 
> - Compaction at pageblock_order fails or is deferred.
> 
> - should_reclaim_retry() takes the reported progress as progress for
>   the order-0 request and resets no_progress_loops. The request
>   retries.
> 
> Order 1-3 requests loop the same way, and should_compact_retry() also
> checks their pageblock_order compaction result against the request
> order.
> 
> On a production host (64G, defrag_mode, memory.low covering most of the
> workload), 95% of direct reclaim runs were order-9 runs that returned 1
> with nothing reclaimed, at up to 60k runs per second. Across ~200M
> should_reclaim_retry() calls in a day, no_progress_loops never left 0.
> The spinning allocations were SLUB slab refills for inode and dentry
> caches. The time spent registers as memory pressure, and pressure-based
> OOM killing takes down both workloads and system services.
> 
> For promoted requests:
> 
> - Reclaim progress does not reset no_progress_loops, as for costly
>   orders.
> 
> - should_compact_retry() checks the compaction result at the promoted
>   order and does not retry COMPACT_SKIPPED, since the request can fall
>   back. The compaction priority floor and the COMPACT_SUCCESS retry
>   limit stay those of the request order, so a non-costly request still
>   gets its COMPACT_PRIO_SYNC_FULL pass before it falls back.
> 
> When the fallback is taken, reset the retry counters, so that the
> fallback attempt gets a full retry budget before the OOM killer is
> considered.
> 
> __alloc_pages_slowpath() computes the promoted order once per iteration
> and passes it to direct reclaim, direct compaction and the two retry
> helpers next to the request order, so no callee has to recompute it.
> Harry Yoo asked for the two orders to be explicit rather than derived
> in each callee.
> 
> In a VM reproducer (32G, defrag_mode, inode churn under memory.low):
> 
>                                         before    after
>     should_reclaim_retry() calls           63M     293k
>     peak memory pressure (PSI some avg10)  99%      12%
> 
> File creation runs 5.7x faster.
> 
> Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

[..]

>  @@ -5007,14 +5034,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	 * of free memory (see __compaction_suitable)
>  	 */
>  	if (did_some_progress > 0 && can_compact &&
> -	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
> -				 compact_result, &compact_priority,
> +	    should_compact_retry(gfp_mask, ac, order, reclaim_order,
> +				 alloc_flags, compact_result, &compact_priority,
>  				 &compaction_retries))
>  		goto retry;
>  
> -	/* Reclaim/compaction failed to prevent the fallback */
> +	/*
> +	 * Reclaim/compaction failed to prevent the fallback. The retry
> +	 * budget was spent on making blocks, not on the request itself;
> +	 * give the fallback a fresh one before considering OOM.
> +	 */
>  	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
>  		alloc_flags &= ~ALLOC_NOFRAGMENT;
> +		no_progress_loops = 0;
> +		compaction_retries = 0;

Should these counters be reset only when the work order was actually
promoted?

For movable requests, and requests already at or above pageblock
order, `reclaim_order == order`. Their retry budget was therefore
spent on the request itself rather than on promoted pageblock
production. Resetting the counters here can give those requests
another 17 no-progress reclaim attempts, plus additional
compaction-success retries, before OOM or allocation failure.

How about:
	if (reclaim_order != order) {
		no_progress_loops = 0;
		compaction_retries = 0;
	}

instead?

>  		goto retry;
>  	}
>  
> -- 
> 2.54.0
> 
> 

