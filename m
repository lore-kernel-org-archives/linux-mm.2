Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6409FCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 19:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73ACB6B008A; Tue, 29 Sep 2026 15:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7127B6B008C; Tue, 29 Sep 2026 15:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628AD6B0092; Tue, 29 Sep 2026 15:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42C166B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:58:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB9511C3004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:58:20 +0000 (UTC)
X-FDA: 85267861560.15.257D6E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E692F40003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:58:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LL9i6kj1;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790711899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCN5Kn+gBtWe4kYHCGE6/4to6ZNiWj6FurMdUFPZ6Dw=;
	b=HSXC+UoaZlZy3cAFavII6+zgj635xYyj1WHStByXbo9V1t9T9lvyrQA4MPgX9/UW5x/Abq
	MlHw3kd/+WdjJON/Gxm62EcwQN5YhSu/3mZcm45CiqJ/QiRRb2QPPp1iS6JR9aC2Dwd4Yy
	+4c+cCrhjwErUzYE1SwJpUjY9k9YGHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LL9i6kj1;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790711899;
	b=Ex/ZekIhQwO4eNqOO4nBzPj9jM8D59dDTbmck6oayHaXOgus44sz0aAArZsevpNriqrc8y
	jbu//0VedH67NGJJPnsqwg/UQexDB1KkAr9m+08mZlJlxpGR1P360ARD5oMj03gAXKvxCR
	XFbRC48uhyHmwICc46y6BMr4d5FOKeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7B8C4006A;
	Tue, 29 Sep 2026 19:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A1A1F000FF;
	Tue, 29 Sep 2026 19:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790711897;
	bh=JCN5Kn+gBtWe4kYHCGE6/4to6ZNiWj6FurMdUFPZ6Dw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LL9i6kj1EDtQTAbtFK5w8bLhV3X6WVWZcpFEx6FTRyFwhjmZrEOYzlR1SZ5E5N7uw
	 xuOdC6ot0DZsgX5uqUQiEoowghkz/ZA1Dt4psUggVcg8N2skpt9D1CbwOIAfcQ6FN2
	 3H7NU3LgvUawqwIxToLR4V3o9sUTYMEoXq6dJhGA=
Date: Tue, 29 Sep 2026 12:58:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>, Harry Yoo
 <harry@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-Id: <20260929125816.5a846a62943eeaf63725b525@linux-foundation.org>
In-Reply-To: <20260929174553.175333-1-kirill@shutemov.name>
References: <20260929174553.175333-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rpu5uwrf8wq1fx5xetdhw1nhgpj15a4h
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E692F40003
X-HE-Tag: 1790711898-536413
X-HE-Meta: U2FsdGVkX1+uhfXXBiWvaLOB09mfakwwDeMLLzZ7xy5MJCzozHvXsUzZcY1bTRN872cIXUry1TPbFGtCj9RAsOlQyS9Yewyyf3iXz1ceSoAj4rMRrABKloKZS605nWZkIvR8TBX3PYkXM1L6j0iSKfRYwBqoQkGh3jdf5FPCo75MywQi8rtwMi5VdD4Fuj+OowgIg1znpGWT5JU6exRGTFWNw2RjScPJ2mLNv3Ltxk1Yctq28QbhqLm2IRYwpzHtIh4S1LFalhPsDxGQv5xyevfPseOSvzEmJln9RJfkLJWeJ142jOBp96i1V3j4afbqQjpahfmJgHxxiZbBkNEZN3yfvV2dDupBNea6JPfzJf8O+Q3R+1faD8JxM+e6kQrumD1XfDgesThvir92keDqQTj/wCjF8SB9GsyJWY14qMSn/4SdjdLQ2d1wblO546mY0QEr+Yb70Zt6DHxpQfowWnpm8CGARU701VJDiXzvPGrdQKwcWQmjK0X9TSkbsAGny+hCok+39OgGyLtwoHnP5IKR79jH+dwBY6NL32B6VP4JOfN/ZWYx/4yiq/1D0dNkq4wRfktJmQMPnPOk5wtIr62Wu0H2NN4cEhx2t/8w5UGwZA6gPPpjwKHgY+7EMd5YDfR3cjMvQRvX9kIPeBKy0bgvk3pJ77ZCp+5kRy5zBTMakmPG1i3MRsAH6IvnbLO283awqNJbXXTwTjT/UqWfdTXmHZAFUwLoCuALScGnoE3vJOTD7APmWqYw/irY5ZZ3IJ8JtnHWQyKfwf+dPRYKkyEWWiH9mYFBKQ7yHoHGCP2yNtT6+C2Gq4FLXeUiNSZRyl1CauQqtIpHUitS38J2HA8ytENr8uDnFTIoJZDUwQJ7Tk/MW3rmPMVjUTNKyUWoeFqs098cbHnPf9dRHYz7AjWpohZOBKFCSsxj/t8/77GsQCvgHixUBZt74mjgwHzjs/O1sBNDz+JxLB11ixp
 yumq+xpT
 d4leSXsmJWMvO3O+sqXha9oWfPBkqexkentv/wYMxu4W87N6T94p7SQxb3v/acFqgyOZsS+akXyBFmWLVET9iTtk+m9hqxSPztjRlh16BRkJFkvNcOoPRFyN8nBE9Afz+kTaqUYqw1Q/JhmnYbVLnM6f9+02/rSw0uJG9fsElFLYkJPS0ocSiBMqfI9RcLyKSC3me0hU3qzBizOD/DfrPxeAEqorKqCp2f9cGn5eLeKvgwV/6CJJPBBrVg23s6Xm5A+ZeAxelu2urNZ+875yyjAjDxCRAk3GUD8VIafwmaf4mrwk8RGMy6GibsusfRx7ODi4m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 18:45:51 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> storm in defrag_mode"), direct reclaim and compaction for non-movable
> requests under defrag_mode run at pageblock_order, to produce the whole
> blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> still use the request order. An order-0 request can therefore retry
> indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:

7e8756d7ad22 is new in 7.3-rcX, so no cc:stable needed.

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

A production host running latest -rc?

> Treat promoted requests like costly orders:
> 
> - Reclaim progress does not reset no_progress_loops for them.
> 
> - should_compact_retry() checks the compaction result at the promoted
>   order. It does not retry COMPACT_SKIPPED, since the request can fall
>   back, and it does not escalate compaction to COMPACT_PRIO_SYNC_FULL.
> 
> When the fallback is taken, reset the retry counters, so that the
> fallback attempt gets a full retry budget before the OOM killer is
> considered.
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
> Cc: <stable@vger.kernel.org>

Please double-check?



