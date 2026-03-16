Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FBA9F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAD96B02EA; Mon, 16 Mar 2026 11:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72A56B02EC; Mon, 16 Mar 2026 11:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67C86B02ED; Mon, 16 Mar 2026 11:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A321B6B02EA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:49:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C8A9C1849
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:49:55 +0000 (UTC)
X-FDA: 84552361950.02.56408FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3A47780005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:49:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dnNdS6JP;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773676193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zGpxTk+noseP/pytHVfCySKiUhW10abi1iYZzQ/sPI=;
	b=bh/TIqJfCmZ8UGSqACYB5QH//9WvSmcF99WiNYS8K4+xVCJAlXGV+J3oLfzvjoIj7n1qpv
	rdGdXcKBjXqAx7X1uqxVwvNFvpA+OdEypiZQy3ki2r84H7lpRe5lDmUey2SG6zg368gicG
	PPn9KanSGxLAocSIjz6xNizrKjq6Bvk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773676193; a=rsa-sha256;
	cv=none;
	b=nnuHYC5lFAGsKFoId9iJ4WLb5QJ2xc9ImrlnlCTeMfF0WT47Parf2qj6otedKbvjjCTz2Z
	PJpDYhe99EaW1VjR2ZYdP152Wm/5cyZio7TTEt1LSYb+upOiYUBZ4lVcEvOIbpgtxN+qCU
	Wg38R+szCAy0jvqtK67/nciYjpD+mds=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dnNdS6JP;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06A3C40479;
	Mon, 16 Mar 2026 15:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C85C19421;
	Mon, 16 Mar 2026 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773676191;
	bh=yjd8NtgZHV8vh5dTR2BKFX8AF+cyPjyTRX8mDhKOXNk=;
	h=Date:From:Subject:To:References:In-Reply-To:From;
	b=dnNdS6JPE6qD2jCA3kQJjIdRQTEImwtT4IQd5np/fj4QggzDeGkshtI8ChdkVfnNm
	 qJoSB1cAsevGgmwZHC+UNpQ6/Zqv55lzoc+Vn9HSZ1o3n2pBIUMfgfhu5eTKasUwOv
	 nnOVYNmuGNN4BVuJTYa+xoO20R5sGn2/SyZHXFVgXXoIbBlAv9yC/6G7IrRl1A9Jqq
	 Lm3/6jmPUQQEel7kT+F3tS9PEYNIvb8KbN+EjeRT7BwnzwD3EvL2r+HFdpZ5pLSrKi
	 JFLMV99cXmWqvB2RWYEFMPfEn4S3qZVL1zq6wyoF7YV1ETfMFVTNF5TzyhXSCY2Bu8
	 ajuv4mXvA4vwA==
Message-ID: <e59ab258-7331-412c-b490-657e32ec1fe0@kernel.org>
Date: Mon, 16 Mar 2026 16:49:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 2/3] vmalloc: Optimize vfree
Content-Language: en-US
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-3-usama.anjum@arm.com>
In-Reply-To: <20260316113209.945853-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qyo9i7bhoezyustwxe3z8cttapdfjiiy
X-Rspamd-Queue-Id: 3A47780005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773676192-835256
X-HE-Meta: U2FsdGVkX1+o7rTipsxW2WownVXmkW4clOjaiM2jVYc30ydsRtHAC6u1dzHvncqjeDA/ygrw1WJM0hYvJ2a2bbowpvnFQJXEM/+VCNPGzeF25bUwPbxNzlvgtGLmkLKqeqK7VUOPq9fV4fSOkAJfPfGXjs4K8K2lXQesfV9GWjPQt7w9JipwpDZBa3fCAfK4KpKWIrxJp62B/vm5ey0y1M3IyaL1n9NrnRh9iVnduJCjStNQrFPUKev3IYxatlSAC6cVi+k+eID7S5YKnq7lmGZycpQncajT5PvO5roRmxzVZNlpy7GPkXgr9A8GBOlpDc+62GNiLNtxuW/qTUze+KArK27BcD68wD/GA9LmiM1eBJdZR7BL9Kg4IYG9OCK3rmJ9xMzYclAvj7LOU+qEhFzWB1wPUKzgO4GiwoJLhi7lmYTIMZ5R4zjFWlSrJkTgZ8o0DWWZ6X9ZvO0YQLMFVeIbN+9L7jbz208GDIDRYgYqo7B1aedkr/BETGpkI9SjHFTVE/urnijFawQra1l5Y7MS62Wr853cIHhwTynm+vFPosddGzohpK6lmjhf//rJVcyUC0Xsl8NNdZV9p+cyxVQ0gQ9Cu3QUSi1HfAyS3Np9TJwg4ucsw6ryvlktbV6bbe8Q+YZtzmsfA5scB5wR18peiZfgwZTLAOcsASeJLTSttprD5hXh2bFpwFhwBPF7wNAMLt9JtfLR/vLVL5ynH9gv42nrpcEjxkmLx/i0W2etpv9YW/m9J1zdqdRXBhH4DllP3MkIR+HAuFAf6gUs251FDjIDa8obhIvceqKgeebOVsU4X/6xHolyNvU9q7W5w4r4ICtQvv/ehRIY+a066pn3Ty8pDHhhN5MjLOcdlE91E14isQO5If/wTAU4V/V5bzQ5FLA7Tft3M9RLkhDCM75dUk8Gnd7/66zvECYhoPt9FgB9EZDcAafd8MA5dbT9B6drRX17F7mZWrtvn3/
 IdeAHFK9
 rfcSIUl+KoOFDhBWPFbuAz4HxOB5XpYzH9WgWlpER0RINj+opjNtI2NDXqU7RvV1bZ9MZ5LGtjwJKYLD4NyWgJphEUyOan1OttJOCWfXT/kI0mfkaePcl6wkbEv6UYf5AoYqV50EcDvG81AXj70fbmXD5Y0ON0sCYAgS/FZFCIjzUGT2i/2zxP8PomWQfMmc75e8y46IypGbXnricRM14uISXAZVNVzvg2iRwLQH4E6ytQ1GdxQoE3esduQPn9LaYG1bIm3hPNv86wXQVK+GGumy/CQ3G+yaImyO0t04ZczMyQKQ+RrE9Au94PLlp+tJxrMYLAjuqihgnF47z1So+UPU3QtWhrso7iM2YkiSZ4JzY5ttCLDAdIQ3qzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 12:31, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
> must immediately split_page() to order-0 so that it remains compatible
> with users that want to access the underlying struct page.
> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
> allocator") recently made it much more likely for vmalloc to allocate
> high order pages which are subsequently split to order-0.
> 
> Unfortunately this had the side effect of causing performance
> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
> benchmarks). See Closes: tag. This happens because the high order pages
> must be gotten from the buddy but then because they are split to
> order-0, when they are freed they are freed to the order-0 pcp.
> Previously allocation was for order-0 pages so they were recycled from
> the pcp.
> 
> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
> that it also frees that order-3 page to the order-3 pcp, then the
> regression could be removed.
> 
> So let's do exactly that; use the new __free_contig_range() API to
> batch-free contiguous ranges of pfns. This not only removes the
> regression, but significantly improves performance of vfree beyond the
> baseline.
> 
> A selection of test_vmalloc benchmarks running on arm64 server class
> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
> large order pages from buddy allocator") was added in v6.19-rc1 where we
> see regressions. Then with this change performance is much better. (>0
> is faster, <0 is slower, (R)/(I) = statistically significant
> Regression/Improvement):
> 
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
> +=================+==========================================================+===================+====================+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> 
> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Rebase on mm-new
> - Rerun benchmarks
> ---
>  mm/vmalloc.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..8b935395fb068 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3459,18 +3459,34 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
> +
> +	if (vm->nr_pages) {
> +		bool account = !(vm->flags & VM_MAP_PUT_PAGES);
> +		unsigned long start_pfn, pfn;
> +		struct page *page = vm->pages[0];
> +		int nr = 1;
>  
>  		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +		start_pfn = page_to_pfn(page);
> +		if (account)
>  			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> +
> +		for (i = 1; i < vm->nr_pages; i++) {
> +			page = vm->pages[i];
> +			BUG_ON(!page);

We shouldn't be adding BUG_ON()'s. Rather demote also the pre-existing one
to VM_WARN_ON_ONCE() and skip gracefully.

> +			if (account)
> +				mod_lruvec_page_state(page, NR_VMALLOC, -1);

I think we should be able to batch this too to use "nr"?

> +			pfn = page_to_pfn(page);
> +			if (start_pfn + nr == pfn) {
> +				nr++;
> +				continue;
> +			}
> +			__free_contig_range(start_pfn, nr);
> +			start_pfn = pfn;
> +			nr = 1;
> +			cond_resched();> +		}
> +		__free_contig_range(start_pfn, nr);
>  	}
>  	kvfree(vm->pages);
>  	kfree(vm);


