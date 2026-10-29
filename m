Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B61606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=erkwwRoG
Received: by kanga.kvack.org (Postfix)
	id 3AE6D6B05B3; Thu, 29 Oct 2026 02:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D8D6B05B4; Thu, 29 Oct 2026 02:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226156B05B5; Thu, 29 Oct 2026 02:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E233E6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:45:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3E9F1C34BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:57 +0000 (UTC)
X-FDA: 85374728754.14.688659C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2CDCC0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=erkwwRoG;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793256356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HZdEtGRBinobOm262LWtghp2oUY3RgVs+/v7S0ZtPM=;
	b=HCLhTSlAjWwUYIepZKamfdig6KdjoETuM6BWL2geufJw3ZCgMmSSFatpVx1BXaVXcL08jQ
	wilkam9TAzdurT9nTYEV+r8YhmA2t22xD0V7rFMVDMKCc8iePwKc4GA6L1XnZnb5Qx4uhb
	1Ux5L88+/nYPaTlSQe2D9dvWyf+f/Xs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=erkwwRoG;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793256356;
	b=3K1u1WnFdCLMSiGwVWu5T7/V+kQ/yBiF9Ks8J28dGAG79td19jsRtItzTwilw3OAWCB6K/
	BB1dFu2tmdDoHKD3BUk50xh01uX67ujQfe9mPwBF1PDiAZfmM5iPkks2xmMkwHBwYap5t8
	JtnX6oQ++smfN2Gd6FMZwRwkX4M39rE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92D5B1682;
	Wed, 28 Oct 2026 23:45:51 -0700 (PDT)
Received: from [10.163.153.30] (unknown [10.163.153.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D8E93F673;
	Wed, 28 Oct 2026 23:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793256354; bh=wEceBPDAoI7jkb3PQGl1/s7MQmUjV8j5qCga2ORy3jo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=erkwwRoG6+fk1Y3jDeJ13nGzcRLsYy0R9OCVLIYLTULcKkEtbklrmnBpAtpbme0Mp
	 yc1Ho19txmvw15SBggNRsxjjRXm0L55bGaaQLANavxQ2otIesqDLYAA7aE0p+al4JJ
	 L0F9uugIDa/NKe4ON8P8/Xt9RLydxLcoTZ9T4d4Q=
Message-ID: <dd2ee501-fdba-4853-8f8a-e0e78d068148@arm.com>
Date: Thu, 29 Oct 2026 12:15:47 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: annotate data race for
 zone->free_area[order].nr_free
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: teawater <zhuhui@kylinos.cn>
References: <20261028090747.68086-1-hui.zhu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261028090747.68086-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C2CDCC0002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ypg4c1tzbay5rhsbxqmz68z88g6ncegi
X-HE-Tag: 1793256355-820753
X-HE-Meta: U2FsdGVkX1+zGVH7KzGziu/GYHasX+I3wthybClkFvR37fh4ERQFUmuuRt3SIpR2W1EUCOXDTOdWJO/yoCF2reYRYNKoOvfGbzTVthyftuiyDECSuiIJ3CsN/rK+yHwp1CRGMvgEzSryxvfrJDlYcXSfbH5pdu4n1ktBnWTn1fMBlYUCc4CYGDo1dPJdZty7KqFo4h8zOtq1TmJ54XGW3ASJ7F1cUR0zrsr299oc4eYsFJUYellla7TCNLB9qtRyk3cywRoUpGfq6YYDuq/sQ4UHyxizZ0ypy7msp1O4ZTx8VlwxFbtHedK812YNvzj4iYwL+Qo09H2W2bGL16KKS3VFAYqKckiQRpKaXo+WrDTrOy19GhgIzsPpMD/KmWHmiqDSXBvi0wuLc/E4i+lW/6vfhcZEeDKyhRVnN59vd+Tf4z2GMf+bth86Wsw5o9rd30mofG7c2iaQGpBHPtygEBEwDaVUP/dfskw59ahtSnbftHVa95vrvbTgDUp7a0EQvZ0nfn0oFwf/Wlr7J+uf1Aok5mnhcUJAOuEmuO2oFkeeO5w89zjQ16/57n1uVL8tTl/bnbW+WA39bKgeChxx+FI7hxVLOexSrtJsuDk8D3z7ZUIxYQv9ZoQ47TmMrTAKmtYHWNjKoIWfUGjlf+VIBcJq0lsUiD/LQXYHC2ChBi+KMtWC/lBozvVHpiV7uQp9N/JupfuWhM30hN7PBiCbuFX1huSKX3pVk/7/tcEA+9Buq94HsareVQ3cIN7944itZnPxkv3KS3GTHu7Ixm2hcp+cwTri6jVVU2oCGzzHeu4VO/UPB8vzCeGehjHjj6gRXuJMPRBH4BKANIKNIYpyR8hRfluc6CHku9hHmnLZR1ViNdk55VAenwfJ5BFEj+ZSUpHo+UBFGxo2Zt+qBWbBfN1BA7Xs2t8705Kb0ET+iuP5/G7iMRr2nof1XQW446D1DAZNOxp35dDTabIoLza
 CG54V98U
 ARiwpdlrRMwfMRH4G4c5Sr3wljrLVQeU7EofX3xZoV00jgI/fpKUIOv6pTYImfq8aWoyHmy90fZ63LZ76buoJYGE+6w2wjDjQlzjsi2HCb8E9C5HIvLD0cte0AMp8XDej23WYrPO54zCxzGX7Vz6b+ToSAwKdJEDC8lfHNTM/sNv4cFoEUO+ZtZKEqR9btwL4DaeoGfJcyr9nMCf+Wj9w/NqOTgjvKQG+nIjcdkiwbi65mwycERwkmnQYoCUjOgQEPraemrhTbsPu5JVqItm1F5+RWQOYd4UaGgAVPmTAklniQ/RAToHHGZeO6wAenMzQTr0BqXOSMU9xcZkKuqaKB3jImQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 28/10/26 2:37 pm, Hui Zhu wrote:
> From: teawater <zhuhui@kylinos.cn>
> 
> KCSAN reports a data-race on nr_free which also exists on mainline:
> 
>   BUG: KCSAN: data-race in fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
> 
>   race at unknown origin, with read to 0xffff9894ff3dcb60 of 8 bytes by task 179078 on cpu 12:
>    fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
>    isolate_freepages+0x52/0x650 mm/compaction.c:1722
>    compaction_alloc_noprof+0x36e/0x3e0 mm/compaction.c:1850
>    compaction_alloc+0x21/0x30 mm/compaction.c:1880
>    migrate_folio_unmap+0x7f/0x820 mm/migrate.c:1177
>    migrate_pages_batch+0x37e/0x1200 mm/migrate.c:1762
>    migrate_pages_sync+0xce/0x560 mm/migrate.c:1928
>    migrate_pages+0x8c6/0xc20 mm/migrate.c:2037
>    compact_zone+0x539/0x10b0 mm/compaction.c:2660
>    compact_zone_order+0x1b8/0x230 mm/compaction.c:2795
>    try_to_compact_pages+0x20b/0x630 mm/compaction.c:2851
>    __alloc_pages_direct_compact+0x98/0x2b0 mm/page_alloc.c:3722
>    __alloc_pages_slowpath.constprop.0+0x452/0xdf0 mm/page_alloc.c:4401
>    __alloc_pages_noprof+0x28a/0x2d0 mm/page_alloc.c:4794
>    alloc_pages_mpol_noprof+0x1b1/0x470 mm/mempolicy.c:2270
>    alloc_pages_noprof+0x7a/0xe0 mm/mempolicy.c:2347
>    io_mem_alloc_compound io_uring/io_uring.c:2848 [inline]
>    io_pages_map+0xb9/0x330 io_uring/io_uring.c:2892
>    io_allocate_scq_urings+0x231/0x300 io_uring/io_uring.c:3933
>    io_uring_create+0x29c/0x9c0 io_uring/io_uring.c:4091
>    io_uring_setup+0xb6/0x100 io_uring/io_uring.c:4203
>    __do_sys_io_uring_setup io_uring/io_uring.c:4230 [inline]
>    __se_sys_io_uring_setup io_uring/io_uring.c:4224 [inline]
>    __x64_sys_io_uring_setup+0x66/0xe0 io_uring/io_uring.c:4224
>    x64_sys_call+0x1816/0x1d90 arch/x86/include/generated/asm/syscalls_64.h:426
>    do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>    do_syscall_64+0x70/0x2a0 arch/x86/entry/common.c:81
>    entry_SYSCALL_64_after_hwframe+0x76/0xe0
> 
>   value changed: 0x00000000000002f4 -> 0x00000000000002f5
> 
> nr_free is only updated with zone->lock held, but fast_isolate_freepages()
> and fast_find_migrateblock() read it locklessly to skip an order that has
> no free pages.  page_alloc.o is excluded from KCSAN, so the writer is not
> instrumented and the report is of unknown origin.
> 
> The race is benign: a stale zero only skips the order for this round, and
> a stale non-zero just finds an empty MIGRATE_MOVABLE freelist under the
> lock.  Annotate both reads with data_race(), following commit
> af1c31acc853 ("mm/vmstat: annotate data race for zone->free_area[order].nr_free").
> 
> No functional change intended.
> 
> Signed-off-by: teawater <zhuhui@kylinos.cn>
> ---

Thanks. With the SOB fixed:

Reviewed-by: Dev Jain <dev.jain@arm.com>

Is a Fixes: tag required? I think stable backport would be overkill but
Fixes makes sense as this leads to a reproducible stack trace?


>  mm/compaction.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb2016..499ec7ceaa3ed 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1601,7 +1601,11 @@ static void fast_isolate_freepages(struct compact_control *cc)
>  		unsigned int order_scanned = 0;
>  		unsigned long high_pfn = 0;
>  
> -		if (!area->nr_free)
> +		/*
> +		 * Access to nr_free is lockless as it is only a hint; a stale
> +		 * value is harmless. Use data_race to avoid KCSAN warning.
> +		 */
> +		if (!data_race(area->nr_free))
>  			continue;
>  
>  		spin_lock_irqsave(&cc->zone->lock, flags);
> @@ -2031,7 +2035,11 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
>  		unsigned long flags;
>  		struct page *freepage;
>  
> -		if (!area->nr_free)
> +		/*
> +		 * Access to nr_free is lockless as it is only a hint; a stale
> +		 * value is harmless. Use data_race to avoid KCSAN warning.
> +		 */
> +		if (!data_race(area->nr_free))
>  			continue;
>  
>  		spin_lock_irqsave(&cc->zone->lock, flags);


