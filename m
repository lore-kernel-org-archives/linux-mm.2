Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E74606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Tit538k9
Received: by kanga.kvack.org (Postfix)
	id E6B296B00EF; Sun,  1 Nov 2026 01:22:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BF16B05B1; Sun,  1 Nov 2026 01:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D315E6B05B2; Sun,  1 Nov 2026 01:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B12FC6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:22:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 351931A09C9
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:22:14 +0000 (UTC)
X-FDA: 85385555388.08.726B92B
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E76E180004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:22:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tit538k9;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793514132;
	b=rRlsSw5w7ysD2/dyEJE48zcrhHkMqfVaUAkLZH1OObso/+VqglAqe5NVqr1k+nfG4E+pi2
	WXpvSJrUCYnOsWzgd/JVoGLiBTRp3NFBVyrkWzc2Q1n9xTpU8D1grcZgHWVTIJyrWz6w8l
	6lO/cdAsfKYPFQqzUnO3SYSvKiFhbgE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tit538k9;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793514132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blO6k0GV9t7jq832MC9mTaWTEhU4J8juq8TCxnkK4WQ=;
	b=0K1POdwUuFk/bgPuoHyMIlJDAr/xXkPwfrOxL7yfwwwVDcxwwzn+FG8xBYIxupdT6Qctlz
	ZZ16EfIWQgTQrTGqKQ/qCeAOv3Du3uZA0VlDr5t237URvvKrrlv7rJFCHTdGBycINdRPaw
	efQrtgeUn8rmgFgV3TmYoEd5D9yvQ3s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gaF9RaTUlWJnz0Kz7eSN92fdFpU4AaHftDt4HKXl/YY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793514127; v=1; x=1794118927;
 b=Tit538k9XfHYAjy4otnRC7vAz5Cj/Lshaoxkkk8Ghq1rfQBmNwtxsywKDb9yCi4afi7pP4H2
 azVrDg4QS5ZtzmVl643fP8STHG/kKplwbnGDLa/Y6/LSRHQbsSx6TbqgXQyIEcr3izcualOTZCZ
 zJw5W9KJF/mRI50gqQiw4csM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ef06936bde13713;
	Sun, 01 Nov 2026 06:22:07 +0000
X-Mizu-Trace-ID: 5ef06936bde13713
X-Migadu-Flow: FLOW_OUT
Message-ID: <86d9a986-58ea-44f5-a8af-514abff12c2a@linux.dev>
Date: Sun, 1 Nov 2026 14:22:00 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5koc6eyb51nbe44yb45kpe88xraareim
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6E76E180004
X-Rspam-User: 
X-HE-Tag: 1793514130-264581
X-HE-Meta: U2FsdGVkX19TXIxAsrwU/Pr4PXKGuxdDaXvr6hYFB+tG3hza1B3OFeWLkn7y8ObKQ8dfkoexp5sX9FxfwMbBBLIII/vLHhbwVs8GWD+yHuL5gyrkKPhg6oNySnMsrwHNgJvuK6w1haf4m23zJOrx8k3TF8Rx2hd7QHS8zNtWEgUZU9onQ3rMeLUtHUlMWlQEhJi586VJU5rfkbDAdNHTSiYZ/xGV8VAufAKXgC6Aty1fYh4x5kwJs/bOLUzkfR9Z02l1XDNjcWz+XIVeveBywqc2UNDIwj1d5tzeE7u/BK6ggpYbM9ItPfG8drhVRQGPiT1tHC5rrydiRJGecu/TUxNQ/rYonXM435SQVpJJyLYoPmJZaGEue3D3EWkLx9ng8JCjnXVxFbwuk23TtVG3SGwuZfhOm/VsfT9xRKMH7Fiy/5Bbji7N+emKL/fSBlCwBz6ai6KXfScrcWP1kkL+ZQLj/Rzdcd+aMHfafXuipge9ZAYfJ75nZxnZFTl8Idikt5YMNo/GNQ0PNjcSyDyXDu2yw8ZSdhw6RjCD63x1XUIQn/kZgSkCH1eB1DZdV3xuTnfkFFfEd9TiGMpVtdaQpQzlSu4cx0y8XEKmTttEOSfJbZeJIn/H5cbI14/Wg+fZQAwX7nTlXHNJipOZwwIRHy4zBKAWiOU7zys9wEK17B9i/5mI1MxpmzQ7WYs80GvrgkF7pQZKzp9xr661zKYwWoYFp/3h9uCIZ7AFK6PKJdrGATxnSa9RZ1mFDqlymdVq7rYkH1QxrhdvzBSFeiO0H2YhzUxJqvvFIF2Dnin6UT9ZPLaBWQz2ij+ogTsSRr1k6alLOtkz0fUnL3FgHRcctqhhOrg+A44I0bpot//WvyMTkoKTugRiBXtz+aDnaE5sI6h+IgDAcvPPak2AZMcMtfMPl+ig0jaMUVerCBEbHf8cheA/bphc5mzy48lqdIqSoZmkWjyJ58Q98Eb9oNF
 6hdMpMzR
 Jl6t6iAIOXdz38+ecCZX2Wac9nlNBuTCL3FRRfkanSZBRfNsEg93vR9Grd/eSd4X7R8IT1HxgBdd2wg0jrIBVvl+JqzQDas+xnOrB+iMKl1NARS02m2Tn1/VAGeSgUeFN61GH6f0e5bpF+Bc34ufo8WO8yYdfuSIVuP04o26Peyzfb1rhkDJmwRTqzofT6RTVy/34v15BfG6zWbc7GVDMHlc+gzLGf1RwWhfZEZWRfB5DJN8evUp2Zgq4di9nfev86luQYk4xL6lu+2V2ZBKHCFvHDN2AM7kabZWDkkUEM1ov16iiq8cz2GWkHms8+mH6vRbPhKQMMIzfdhBVxszzPJN+RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
> describe fully independent choices. A split-only walk can defer the
> PMD-split flush to a later global flush, and a remap-only walk can
> defer the final remap flush. However, when a PMD split is followed
> by PTE remapping, the split flush must happen before the PTEs are
> changed, because stale large-page translations must not overlap with
> new small-page translations that map different physical pages.
> 
> Replace the two flags with a single VMEMMAP_REMAP_NO_TLB_FLUSH flag.
> Keep split-only walks able to defer the flush, but force the split
> flush whenever a remap_pte callback is present. Callers that batch
> HVO work can still defer the final remap flush and issue their own
> global flush.
> 
> Current callers keep the same flushing behavior.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 1105aa925acc..8b3abb562599 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
>   	struct list_head	*vmemmap_pages;
>   
>   
> -/* Skip the TLB flush when we split the PMD */
> -#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
> -/* Skip the TLB flush when we remap the PTE */
> -#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
> +/* Skip the TLB flush while updating the vmemmap page tables. */
> +#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(0)

Since this flag is now also used by the split-only path, the
VMEMMAP_REMAP_NO_TLB_FLUSH name is somewhat misleading. Moreover, the
flag does not suppress every TLB flush, as the PMD-split flush is still
mandatory when remapping follows.

Would VMEMMAP_DEFER_TLB_FLUSH better describe its semantics? It
indicates that flushes which can be safely batched are deferred, without
implying that all TLB flushes are skipped.

Thanks,
Qi

>   	unsigned long		flags;
>   };
>   
> @@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
>   		/* Make pte visible before pmd. See comment in pmd_install(). */
>   		smp_wmb();
>   		pmd_populate_kernel(&init_mm, pmd, pgtable);
> -		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
> +		/*
> +		 * Modern MMUs allow overlapping TLB entries with different mapping
> +		 * granularities only if they map the same physical address. So
> +		 * remapping must not proceed without first flushing the TLB.
> +		 */
> +		if (walk->remap_pte || !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
>   			flush_tlb_kernel_range(start, start + PMD_SIZE);
>   	} else {
>   		pte_free_kernel(&init_mm, pgtable);
> @@ -272,7 +275,7 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
>   {
>   	struct vmemmap_remap_walk walk = {
>   		.remap_pte	= NULL,
> -		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
> +		.flags		= VMEMMAP_REMAP_NO_TLB_FLUSH,
>   	};
>   
>   	return vmemmap_remap_range(start, end, &walk);


