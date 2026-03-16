Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63047F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08BA6B02E0; Mon, 16 Mar 2026 11:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5AC6B02E2; Mon, 16 Mar 2026 11:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96E56B02E3; Mon, 16 Mar 2026 11:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB306B02E0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:21:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B8501602E3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:21:57 +0000 (UTC)
X-FDA: 84552291474.03.CD6C21F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D0C910000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:21:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pIH9+2Ar;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojuQcjj3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pIH9+2Ar;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojuQcjj3;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773674514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69w6Pf4LvsBQHR3bSr5yOfdqGpd6SqeyH4ovMjNicm0=;
	b=OysTAglMMDUcj+pE2s6RFjKm8LOEdHTKOR0+x8PzQNx0VVOzCafTZvCr4EoSu4ezmP3m5X
	fMUjeDw6X4i2gqzKwoG7RXF1GCBs1B1s/YRkxQH34d7lU4+mPgzTRe1Wz0VRArVFZQ8Mqe
	9mh79ENNUBLjdjBDZzDIyfymEjRuQvo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773674514; a=rsa-sha256;
	cv=none;
	b=LJsXx0kOQ7p206aZdLwlLDroGJqqFGLfy0e9JDIbsqtTqZZHmXLEFkLJXxSyr6czDe5t4c
	y5DbllcjRfG6oRTRjUK4CrRwql6t8ePQf+y7GHU3U8EUOC7o/QRAcofTlvhEMFQ6EgGR2s
	8b7pLjzZ6FZyEj2BDd59tlHTNIqWX6w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pIH9+2Ar;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojuQcjj3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pIH9+2Ar;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojuQcjj3;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 517295BD6A;
	Mon, 16 Mar 2026 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773674512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=69w6Pf4LvsBQHR3bSr5yOfdqGpd6SqeyH4ovMjNicm0=;
	b=pIH9+2ArvYiAjQ9BoSmYh68CN6wcN3UG4yHdH7fJ7swPDgvAvMS+1yAVsyBo111goT28MK
	ScSsjKaiAQiLHOw4EdfVEBysOOZXfcykdcFBgM9t8N1+JD9dEij+y5uoc6R01mgiSs5/GI
	E4vUaMsW3MjnMTZv3sR6ePk3tS/61Wc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773674512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=69w6Pf4LvsBQHR3bSr5yOfdqGpd6SqeyH4ovMjNicm0=;
	b=ojuQcjj3A2xffZpFIF5WsVVAEUvS1YjhxVW8hWq5TPdO8ytBoFfP6oXusJR7zsL9kXz5jC
	J20HyI5ljT6F/aAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773674512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=69w6Pf4LvsBQHR3bSr5yOfdqGpd6SqeyH4ovMjNicm0=;
	b=pIH9+2ArvYiAjQ9BoSmYh68CN6wcN3UG4yHdH7fJ7swPDgvAvMS+1yAVsyBo111goT28MK
	ScSsjKaiAQiLHOw4EdfVEBysOOZXfcykdcFBgM9t8N1+JD9dEij+y5uoc6R01mgiSs5/GI
	E4vUaMsW3MjnMTZv3sR6ePk3tS/61Wc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773674512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=69w6Pf4LvsBQHR3bSr5yOfdqGpd6SqeyH4ovMjNicm0=;
	b=ojuQcjj3A2xffZpFIF5WsVVAEUvS1YjhxVW8hWq5TPdO8ytBoFfP6oXusJR7zsL9kXz5jC
	J20HyI5ljT6F/aAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1513F4273B;
	Mon, 16 Mar 2026 15:21:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p1vYBBAguGkWVQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 16 Mar 2026 15:21:52 +0000
Message-ID: <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
Date: Mon, 16 Mar 2026 16:21:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
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
 <20260316113209.945853-2-usama.anjum@arm.com>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260316113209.945853-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D0C910000E
X-Stat-Signature: qxwj91cfhsnds9eoxromaxyji8ha83qi
X-Rspam-User: 
X-HE-Tag: 1773674513-634802
X-HE-Meta: U2FsdGVkX19d0uodywRzrut4VHCvloRyn9rAUSSs0qdfdSxPMI65Mf7MJ87GhwPN0P2GTtSAyaJZf0ZOfj7ZHMdnag/0ULm+tEYphfXQFEk4e3M8UBRogbg0f7v+b6R3fZ+ibyx2rVKnCjFIxTFINJ7Q9MCJ3GAxliVOaNOcUk5lAMGSx32DPU6O2mYxxtCZB2jTbC1bpWEyq2ZWyd+GDPzne7GpC6rJbcfoBIntfnJGFW1ocDnGypdtKQU2izUyR0tt9WSsK2j5+nag6z4oY+bk5a+UUIPg5xWIn29btIATJyd0oYRKPIJ0ALBkycI6KbZ2cPCjLBV7L3GoCG4nbiWxGNOPjd69URe6BOyWnj2BXRqILGNP6LVdLqQe0Sh6KQOMJ2aMgHNo4X3NdNSJw8DOgLJa/61PR+V2qZNaiWgMGBDd/2zdy6EDwjQKXNO2na9Iu57C9RudfxKje88jt05RFJfg+gP8zlwqRQgRtT3RZhb631DQnrhqCMwZGZiC4fVclUq9OZVp91fPexfdBg5i2qdLhL3xu0hEn0t18uK3B4r8HOxBm3i3lX8TXLyRn7QBEZ8UTM7Ow5hpRwuj0mjpG90T3Y8Hr435+V9Ms8EsbhcnvZmfXZVWL7Gl/wfEbUNxpqHFNHbOAP/YAR3vyi4Q6wXFtHUfkAFR9hvGIusj/tSweQHe3FwogKBF/UUzeHCUDkw2Chr6fEpaoKwOHvfGRKio0UjlSUxjeVau4sBJVxfQF87PFZfTfe8HuhTyiSmXQpUZkoaTtuvfWopsbxc89BSnjEErV+7Lomer5+BJlX13TWPuDySaI4Iay/hn8a2Gxa5of+msGN7Grmgb9/Ri3Uy06H3q4MIF5f4Ea9ApAib38G5ycZM7Fvp3PFErvRjQu5llmS9NcsNC5eH0uMnK/t3B2bMxpfWQtcDb3nXqvw1ndTm5ak0DilV77toj4HPByFJkjrnaYWOuI3a
 OHw03kcQ
 hxj26X1cloohpgpnSN8o1etoE/i8YkHG9UyJ2oc1F3ThJW1JFp6ZoiECdDdxpLAtURMqdHB36vPUxlIal76qd9QRTBOFUfyIkocuqXAmiKioo9MhgujgB+wHrJzgesQcebf+w8osEcK6cUq2+7rkMKyG7YiDYLi+xedSFxsC7TNrZ7QH/A/hmLPyCIzLTxEVh5G8IkcNiqgkeZPcUHkbmXM36120crTGnf46eAgEW+JVnEXoDYfRAfjx/28Rg7eGSexF3c01Q3bBPcutJHWE5AxiIVGOTR+tP+iDLjXXJLEuYEy4mSfKfopelWnKsfer+31mXaPy77uUYAKkERoA+vlqwYic6wn9f5r7B4ahYJHRt2l9pErCX46JZMj7fRdWgfkNgtqHj0V6pJW84LOm+yFuM8Nhv2MkCtjAIylhhfgT274LjqP62y0i5O2h2MowtFHqUN486nq4FdM/SI67rUe1fdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 12:31, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Decompose the range of order-0 pages to be freed into the set of largest
> possible power-of-2 size and aligned chunks and free them to the pcp or
> buddy. This improves on the previous approach which freed each order-0
> page individually in a loop. Testing shows performance to be improved by
> more than 10x in some cases.
> 
> Since each page is order-0, we must decrement each page's reference
> count individually and only consider the page for freeing as part of a
> high order chunk if the reference count goes to zero. Additionally
> free_pages_prepare() must be called for each individual order-0 page
> too, so that the struct page state and global accounting state can be
> appropriately managed. But once this is done, the resulting high order
> chunks can be freed as a unit to the pcp or buddy.
> 
> This significantly speeds up the free operation but also has the side
> benefit that high order blocks are added to the pcp instead of each page
> ending up on the pcp order-0 list; memory remains more readily available
> in high orders.
> 
> vmalloc will shortly become a user of this new optimized
> free_contig_range() since it aggressively allocates high order
> non-compound pages, but then calls split_page() to end up with
> contiguous order-0 pages. These can now be freed much more efficiently.
> 
> The execution time of the following function was measured in a server
> class arm64 machine:
> 
> static int page_alloc_high_order_test(void)
> {
> 	unsigned int order = HPAGE_PMD_ORDER;
> 	struct page *page;
> 	int i;
> 
> 	for (i = 0; i < 100000; i++) {
> 		page = alloc_pages(GFP_KERNEL, order);
> 		if (!page)
> 			return -1;
> 		split_page(page, order);
> 		free_contig_range(page_to_pfn(page), 1UL << order);
> 	}
> 
> 	return 0;
> }
> 
> Execution time before: 4097358 usec
> Execution time after:   729831 usec
> 
> Perf trace before:
> 
>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>             |
>             ---kthread
>                0xffffb33c12a26af8
>                |
>                |--98.13%--0xffffb33c12a26060
>                |          |
>                |          |--97.37%--free_contig_range
>                |          |          |
>                |          |          |--94.93%--___free_pages
>                |          |          |          |
>                |          |          |          |--55.42%--__free_frozen_pages
>                |          |          |          |          |
>                |          |          |          |           --43.20%--free_frozen_page_commit
>                |          |          |          |                     |
>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>                |          |          |          |
>                |          |          |          |--11.53%--_raw_spin_trylock
>                |          |          |          |
>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>                |          |          |          |
>                |          |          |          |--5.64%--_raw_spin_unlock
>                |          |          |          |
>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>                |          |          |          |
>                |          |          |           --1.07%--free_frozen_page_commit
>                |          |          |
>                |          |           --1.54%--__free_frozen_pages
>                |          |
>                |           --0.77%--___free_pages
>                |
>                 --0.98%--0xffffb33c12a26078
>                           alloc_pages_noprof
> 
> Perf trace after:
> 
>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>             |
>             |--5.52%--__free_contig_range
>             |          |
>             |          |--5.00%--free_prepared_contig_range
>             |          |          |
>             |          |          |--1.43%--__free_frozen_pages
>             |          |          |          |
>             |          |          |           --0.51%--free_frozen_page_commit
>             |          |          |
>             |          |          |--1.08%--_raw_spin_trylock
>             |          |          |
>             |          |           --0.89%--_raw_spin_unlock
>             |          |
>             |           --0.52%--free_pages_prepare
>             |
>              --2.90%--ret_from_fork
>                        kthread
>                        0xffffae1c12abeaf8
>                        0xffffae1c12abe7a0
>                        |
>                         --2.69%--vfree
>                                   __free_contig_range
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Rebase on mm-new
> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>   fpi_flags are already being passed.
> - Add todo (Zi Yan)
> - Rerun benchmarks
> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
> - Rework order calculation in free_prepared_contig_range() and use
>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>   be up to internal __free_frozen_pages() how it frees them
> ---
>  include/linux/gfp.h |   2 +
>  mm/page_alloc.c     | 110 ++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 108 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index f82d74a77cad8..96ac7aae370c4 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>  #endif
>  
> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages);
> +
>  DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>  
>  #endif /* __LINUX_GFP_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 75ee81445640b..6a9430f720579 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -91,6 +91,13 @@ typedef int __bitwise fpi_t;
>  /* Free the page without taking locks. Rely on trylock only. */
>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>  
> +/*
> + * free_pages_prepare() has already been called for page(s) being freed.
> + * TODO: Perform per-subpage free_pages_prepare() checks for order > 0 pages
> + * (HWPoison, PageNetpp, bad free page).
> + */

I'm confused, and reading the v1 thread didn't help either. Where would the
subpages to check come from? AFAICS we start from order-0 pages always.
__free_contig_range calls free_pages_prepare on every page with order 0
unconditionally, so we check every page as an order-0 page. If we then free
the bunch of individually checked pages as a high-order page, there's no
reason to check those subpages again, no? Am I missing something?

> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
> +
>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>  static DEFINE_MUTEX(pcp_batch_high_lock);
>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
> @@ -1310,6 +1317,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  	bool compound = PageCompound(page);
>  	struct folio *folio = page_folio(page);
>  
> +	if (fpi_flags & FPI_PREPARED)
> +		return true;
> +
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>  
>  	trace_mm_page_free(page, order);
> @@ -1579,8 +1589,10 @@ static void __free_pages_ok(struct page *page, unsigned int order,
>  	unsigned long pfn = page_to_pfn(page);
>  	struct zone *zone = page_zone(page);
>  
> -	if (__free_pages_prepare(page, order, fpi_flags))
> -		free_one_page(zone, page, pfn, order, fpi_flags);
> +	if (!__free_pages_prepare(page, order, fpi_flags))
> +		return;
> +
> +	free_one_page(zone, page, pfn, order, fpi_flags);

This is not a functional change, can we drop it?

>  }
>  
>  void __meminit __free_pages_core(struct page *page, unsigned int order,
> @@ -6784,6 +6796,93 @@ void __init page_alloc_sysctl_init(void)
>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>  }
>  
> +static void free_prepared_contig_range(struct page *page,
> +				       unsigned long nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned int order;
> +		unsigned long pfn;
> +
> +		pfn = page_to_pfn(page);
> +		/* We are limited by the largest buddy order. */
> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
> +		/* Don't exceed the number of pages to free. */
> +		order = min(order, ilog2(nr_pages));
> +		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
> +
> +		/*
> +		 * Free the chunk as a single block. Our caller has already
> +		 * called free_pages_prepare() for each order-0 page.
> +		 */
> +		__free_frozen_pages(page, order, FPI_PREPARED);
> +
> +		page += 1UL << order;
> +		nr_pages -= 1UL << order;
> +	}
> +}
> +
> +/**
> + * __free_contig_range - Free contiguous range of order-0 pages.
> + * @pfn: Page frame number of the first page in the range.
> + * @nr_pages: Number of pages to free.
> + *
> + * For each order-0 struct page in the physically contiguous range, put a
> + * reference. Free any page who's reference count falls to zero. The
> + * implementation is functionally equivalent to, but significantly faster than
> + * calling __free_page() for each struct page in a loop.
> + *
> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
> + * order-0 with split_page() is an example of appropriate contiguous pages that
> + * can be freed with this API.
> + *
> + * Returns the number of pages which were not freed, because their reference
> + * count did not fall to zero.

We probably don't need this part.

> + *
> + * Context: May be called in interrupt context or while holding a normal
> + * spinlock, but not in NMI context or while holding a raw spinlock.
> + */
> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	unsigned long not_freed = 0;
> +	struct page *start = NULL;
> +	unsigned long i;
> +	bool can_free;
> +
> +	/*
> +	 * Chunk the range into contiguous runs of pages for which the refcount
> +	 * went to zero and for which free_pages_prepare() succeeded. If
> +	 * free_pages_prepare() fails we consider the page to have been freed;
> +	 * deliberately leak it.
> +	 *
> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
> +	 * vice versa.
> +	 */
> +	for (i = 0; i < nr_pages; i++, page++) {
> +		VM_WARN_ON_ONCE(PageHead(page));
> +		VM_WARN_ON_ONCE(PageTail(page));
> +
> +		can_free = put_page_testzero(page);
> +		if (!can_free)
> +			not_freed++;
> +		else if (!free_pages_prepare(page, 0))
> +			can_free = false;
> +
> +		if (!can_free && start) {
> +			free_prepared_contig_range(start, page - start);
> +			start = NULL;
> +		} else if (can_free && !start) {
> +			start = page;
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, page - start);
> +
> +	return not_freed;
> +}
> +EXPORT_SYMBOL(__free_contig_range);
> +
>  #ifdef CONFIG_CONTIG_ALLOC
>  /* Usage: See admin-guide/dynamic-debug-howto.rst */
>  static void alloc_contig_dump_pages(struct list_head *page_list)
> @@ -7327,11 +7426,14 @@ EXPORT_SYMBOL(free_contig_frozen_range);
>   */
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  {
> +	unsigned long count;
> +
>  	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
>  		return;
>  
> -	for (; nr_pages--; pfn++)
> -		__free_page(pfn_to_page(pfn));
> +	count = __free_contig_range(pfn, nr_pages);
> +	WARN(count != 0, "%lu pages are still in use!\n", count);

And we almost certainly don't want this warning. Spurious temporary page
refcount increases (get_page_unless_zero()) can happen e.g. due to memory
compaction pfn scanners. It just might mean that side will be then the last
one to drop the refcount and freeing the order-0 page. For us it means only
that we abort and restart the batching, so we get worse performance, but
functionally it's ok, and should be very rare anyway.

> +
>  }
>  EXPORT_SYMBOL(free_contig_range);
>  #endif /* CONFIG_CONTIG_ALLOC */


