Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38EECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DEC56B0088; Fri, 12 Jun 2026 10:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F476B0092; Fri, 12 Jun 2026 10:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DFC6B0093; Fri, 12 Jun 2026 10:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 043066B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:22:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91A2A161BCA
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:22:52 +0000 (UTC)
X-FDA: 84871476984.07.3A77219
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0FB33160007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:22:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IIWvvZja;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781274170;
	b=E+k14FOYbLcrBwOhb5D+OP5SYLfEueuXSYwNoBDmZ/5bQtKPbuoKk2NkzwJDnKtrHITOGk
	1kPQvWYiztVCBJ2YR4PYF5MF+u96XpFSKX9gI+bSCZpfeBPFKEAhsPShIraDzqUuvkY7L8
	8dAQ1biXp0e8Ft1/6jVIsGE4jJQwJ5M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IIWvvZja;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781274170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDM/naiUy7IWjIuXVH8zM74N1Dr0cGZHLlVFqqGy5sk=;
	b=hxG8kx8/zY9UIYKhdsorn6fbJ5y7ENqJrrIuY2QUuTlvoryqslgjclHiOUybtIIdYajNJi
	yMf9yhPzO9hYUGg9+4RB4JeAINjyPCpBXfWqOpJE+czztbVwqhHUlNK7APNQDX+FyVp6N6
	DhOvATZy90yjbeCE7IamoRCIrULXkxc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781274164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RDM/naiUy7IWjIuXVH8zM74N1Dr0cGZHLlVFqqGy5sk=;
	b=IIWvvZjaJJoV7NR4JCOHDkSbKcFvz71ysWroR2jnxaP4Fcw3M3/K8n6kwMEXobgHZpxyyw
	xq/V0R5OZiDgXoBEfOOFIxpJzHoD89XH2c6OxcNd/H6/oeSZQ5R8igiVms6eZsvVbSzgML
	bmhipw0lTaVwEeVvgPna0gH4j6V8WB0=
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	linux-mm@kvack.org
Subject: Re: [v2 15/16] mm: install PMD swap entries on swap-out
Date: Fri, 12 Jun 2026 22:21:24 +0800
Message-Id: <20260612142124.73367-1-lance.yang@linux.dev>
In-Reply-To: <20260602142537.198755-16-usama.arif@linux.dev>
References: <20260602142537.198755-16-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0FB33160007
X-Stat-Signature: khocc6a8qj7duw15siwbbihwkak6c18m
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781274167-111526
X-HE-Meta: U2FsdGVkX1/wzyIIGtNRHxfjC1G2jUbvkILH36yCdQ/PJvDjkrfJtd2MVEWwPjrsMG1M0W+S6KvcmYLuMmjTU1wrIUyFsQpsaYeZB+cfKL0biOs1Y44kzCMk0xgVHk4PTRY3qBI13E2yyx+8676jaCZVU8D+JB09Qx6FfSPTVvfqUSbanyxPt10vCADIpVM4NVx28eKPJHDSmrhAMj3wmhLLuO3azWol5rtULkiE3h+1+7KJsjg+oV1Jh+lC61AjE1mvSidYNsiETWNjqTpqVFsSaj9CaI+nlwJib9oP0l1BH61kpWCrT0Kh6IJscA/xVwAxW8k/Xesx7IvTCjoCROg9aTkInMeoeRBWsi4N1gE4qgynw0XD787GJ23Pdl6QT68tKa6gCzhadjjFXzISLhWiSN1B5EntTMA7oLy0XspIvT7WCeWen7Bjn9TSgOk7Wi06FZwK2hqCraPlXXO6EyrcCUH4EyPoKcKmir6DiW1v61UVCKeoVvKKUUJe+9ky1JX6ZPePur9RHuEAFBVCgsLgIHCKBxzYEmOH/EiJhuH+e68P2VmMzzd/4RxEDFeuXlXviVGmad+XgfXWtUK5XBqRAQxf3CwPQ2ewiDfdKILxME23VmDz2DPFB9mCwp+q0zyOuU8rAwGxareoPZ5sisz60BALoRxVRqizjiA4ra/5F9xPae/5hhId8kBaMyVlsCyNyXIXImMVuuaBRBn7jZ8ytxdTWYIeI9rtiExsr+44behxcQuWNmEjScv9TG6jmzhQ66/ZgraqdQTlxaCETRKsL7ENpuUtvfe64vXew28lLIk8+8Jy+Xia/JQMh1HiD99SBr5WED9bAzjt3HLqtchnWs5rCQcF8ZM6JSh9NGDQCZRKReQqhcGAxjK2TFmvEu7QmIVlWwPRqhYCoQHhxZvhJ4z7pUGk/UOWLLdJOotbP3oC+BGrTSRC50+edbRH6+W7qwb1DH+SIuq2YKI
 j5E+CV14
 YN/6JhORoD/o0BgqqSy22dYra5Um0uAkbXS5Cd078oM5gCrUzDH9TxXEV6zyqtUx4mwUQJpzEHuQJC7/EVVVqHfP+BhGB0ZndUqyDLVMq47XxHKH0g2PM0++9fGf3u8DmIc6F9qF0ZKAMgtmHhlC6NucNg5C6zYSvvzpad+OhI5k2nkRLaMyusziUOGWdCs1bR40BNJENWwnGAWIygeOfaiJulQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc linux-mm

On Tue, Jun 02, 2026 at 07:24:23AM -0700, Usama Arif wrote:
[...]
>diff --git a/mm/vmscan.c b/mm/vmscan.c
>index e8a90911bf88..0f376fbf9bb3 100644
>--- a/mm/vmscan.c
>+++ b/mm/vmscan.c
>@@ -64,6 +64,7 @@
> 
> #include <linux/swapops.h>
> #include <linux/sched/sysctl.h>
>+#include <linux/zswap.h>
> 
> #include "internal.h"
> #include "swap.h"
>@@ -1332,7 +1333,18 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
> 			enum ttu_flags flags = TTU_BATCH_FLUSH;
> 			bool was_swapbacked = folio_test_swapbacked(folio);
> 
>-			if (folio_test_pmd_mappable(folio))
>+			/*
>+			 * With THP_SWAP, PMD-mappable folios already in the
>+			 * swap cache can be unmapped with a PMD-level swap
>+			 * entry, avoiding the cost of splitting the PMD.
>+			 * Skip this when zswap has been enabled because
>+			 * zswap stores pages individually and cannot
>+			 * reconstruct a large folio on swap-in.
>+			 */
>+			if (folio_test_pmd_mappable(folio) &&
>+			    !(IS_ENABLED(CONFIG_THP_SWAP) &&
>+			      folio_test_swapcache(folio) &&
>+			      zswap_never_enabled()))

There may be a race here ...

1) zswap_never_enabled() passes, 2) try_to_unmap() installs the PMD swap
entry, and 3) zswap can still be enabled before the later pageout() ->
swap_writeout() -> zswap_store().

zswap_store() loops over each page of the folio:

	for (index = 0; index < nr_pages; ++index) {
		struct page *page = folio_page(folio, index);

		if (!zswap_store_page(page, objcg, pool))
			goto put_pool;
	}

So still one PMD swap entry, while zswap has 512 entries, one for each
page of the folio ...

If the swapcache is reclaimed later, a PMD fault will try PMD-order
swapin again:

do_huge_pmd_swap_page()
	swap_cache_get_folio()
	swapin_sync(..., BIT(HPAGE_PMD_ORDER))
		swap_read_folio()
			zswap_load()

zswap_load() rejects large folios with -EINVAL and leaves the folio not
uptodate:

	/*
	 * Large folios should not be swapped in while zswap is being used, as
	 * they are not properly handled. Zswap does not properly load large
	 * folios, and a large folio may only be partially in zswap.
	 */
	if (WARN_ON_ONCE(folio_test_large(folio))) {
		folio_unlock(folio);
		return -EINVAL;
	}

swap_read_folio() jumps to finish and does not try a normal swap read:

	if (zswap_load(folio) != -ENOENT)
		goto finish;

And the awkward part is that no error really gets propagated ...
swap_read_folio() is void, and swapin_sync() just hands the same folio
back to do_huge_pmd_swap_page().

At that point the folio is still !uptodate, so the fault would just end
up:

	if (unlikely(!folio_test_uptodate(folio))) {
		ret = VM_FAULT_SIGBUS;
		goto out_page;
	}

Looks race, but possible?

Cheers, Lance

> 				flags |= TTU_SPLIT_HUGE_PMD;
> 			/*
> 			 * Without TTU_SYNC, try_to_unmap will only begin to
>diff --git a/mm/vmstat.c b/mm/vmstat.c
>index f534972f517d..9b4963a7eb04 100644
>--- a/mm/vmstat.c
>+++ b/mm/vmstat.c
>@@ -1421,6 +1421,7 @@ const char * const vmstat_text[] = {
> 	[I(THP_ZERO_PAGE_ALLOC_FAILED)]		= "thp_zero_page_alloc_failed",
> 	[I(THP_SWPOUT)]				= "thp_swpout",
> 	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
>+	[I(THP_SWPOUT_PMD)]			= "thp_swpout_pmd",
> #endif
> #ifdef CONFIG_BALLOON
> 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
>-- 
>2.52.0
>
>

