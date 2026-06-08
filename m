Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8888FCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F636B0005; Mon,  8 Jun 2026 08:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16E66B0088; Mon,  8 Jun 2026 08:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D346B008C; Mon,  8 Jun 2026 08:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D29646B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:47:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63784C35B2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:47:58 +0000 (UTC)
X-FDA: 84856722636.18.119CC65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B103D20007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:47:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QkwD2rZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780922876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkyhxLYoURMoe9UbrqX/GVesARb0CM+eHMrUWeBjhQU=;
	b=8bKodSBtDcxGunMtSdrYi7eaGeZ8jt0kOUa0X8FYwo39QqeotYh66pHFMJEkoXd+s6kUoX
	5jDhd2Zsj26IR2WRmHvp2d4IwqqY1mSalrsmYLhsdmaFJztwjGWG72Vi0CPs2nas+C79rO
	jkrHho27hd5kiatcnUfHtO7ZSRTUeXw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QkwD2rZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780922876;
	b=vmvKt0McYb3yEhGfmlgESMiayzclbrvMC1oRVfd8raXpUaaiEAJ8qeT9zt3bdKri02GAqh
	Fwa1ZdMWNT2JOqDoefWv0jbAyFs+8RuKnM1Jv6vHvv/yKAuMDpwna2JpIrkOWl1h9789ub
	RsF1i3I9f0piNFShEbw/Bcbc+VUaMRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA606401F6;
	Mon,  8 Jun 2026 12:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F611F00893;
	Mon,  8 Jun 2026 12:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780922875;
	bh=KkyhxLYoURMoe9UbrqX/GVesARb0CM+eHMrUWeBjhQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QkwD2rZDIVbJT7LAl10n0AGVWol4JZOZ+k/tgMKKwSGXEH2bCK5fJekgHxLgPRHaO
	 A1CsmEckTrMVXvpS47hlRcNoJgECIGWV0PIiDQEA4sUPZ57HmT0q+w8sa5PmvzxekT
	 xXTZ0TNUVki0ATU5BdSV2+69pKPqfVpxj6RRyxCUDt7pD9FyywSsdzc33Vqv5dX2+W
	 b/sKcAqzYwXJJyneK/phMZEo43bPcnIrMIEb1p8oaWyOr8CRfELGeNpXfxhqrc2B/i
	 TP8cjHorVn/3IZiweX+nPT8ucMIpRvP7644dl/uUswg7gACftpkoT50OyH0TxERM+S
	 A8qrqkirA2GWw==
Date: Mon, 8 Jun 2026 13:47:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 29/37] mm: memfd: skip zeroing for zeroed hugetlb
 pool pages
Message-ID: <aia5QJcMcnwtVZdM@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <0d6c2d31f48ff454223ad4f1d37ef7b73263bf5d.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d6c2d31f48ff454223ad4f1d37ef7b73263bf5d.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B103D20007
X-Stat-Signature: anczn9dawnpwr1h7y7getmtashc9s5q1
X-Rspam-User: 
X-HE-Tag: 1780922876-65345
X-HE-Meta: U2FsdGVkX1/pEmsbDLcMnLB7n8WRBNpPW4qRXz9V6mJ/4yvgJToHx5TBqGIzPNctbu5UIMbprZy0qO/RX0rWA/+qVDTR9nDPgxbmCj4q4nL7wEDa0OFj5YPqfvAGinosnqcOTpuBmaz8L0H78+foiw0g9pftlOpsoE6AugsntctQH8ocLrO7NPTI/3UrLpz1QyuRsqRJ8Mi14fYKEvLpzfhh70iqibCixYWFaO6rad26c9nPXN+3PmLw/EC+CNROU+6YfExx+kwC7GQ5khXsVfhAxCelZENV3OF+NQXjlGmvwJQOvCH4KR4psBCefKLlMKHvUgpvcX/ZRBXE4lOw1V2wIEr6SkhMcfr0P22V+0epsGwKyxpHf2seB6w3VKtVnJb2IqAOS+64H6froTsXfrmD2Ccvj3Cmc3z1AFlU7cYgj2cDEMrX12wpWWR/tul//eH2U6Lf7BVoz51DHzt4Y1FTC8EhJuvT1Rpsx071OSnogcK4aLCJ+NHxk2V4Em0i1OTptxoufLN+4Pcd1cS39VbJgdqMtKSRuAVD7ExBCLnLM4X4uMiGZjrrqeU5dxHi8Psy4GYl9oGHReMWpRpDAx30SfFLvEzStoKzSd8ide7JS2ur962Sh/y5e3Uxvfz28VPY8N4eYsNsraz8cqlvwWL1F90uMwh+hjuLkfL87it61TLsPseVsf/nQqanNFv5L4QDujHYrXErjCiZEk8LnjEHjjFCptlCJBzKKy1pi/t90fu2xxQBtUhNiCz/GgpG6lONwlgpqBUbVwHhLIj5+O0kjfCRPp96cARcYLv87uJAP2atR2f7FZp8ll/bojIjkZefRbiJqWLqsIIvoh/WjhuMtHS4BMbZpFb4VP2kQ474ibFrlpcBYGonLpV30gSwxZGfBo2jUZ0pCAPpx14vM25lgpOQ/R44//Y9mI9HccEUohn6AUTvjv9zshAjZDLsLbuymivEi+ZZEiQnh7w
 udjcBLJ4
 jgA4mPOvwpeV8p/EOFmLkjPlwGe07uRKUYtVjeMekuUGHD4o1ouJTdWEeiB4DSuPtZ66r/jLzW8XR9tIfWuQ1hLXGzTG8lSAR0oI1wlnaf0RDblMFSDaJ5rLc9Ai83qX1D9JGx0BQ3GFN0cySQcPSIO/u3qqVfZUDLMkcgpWmv0c1rBX+lKtNPokc3eN4TXieHfUV6ZsE/tEGKirOG75Rdme1k8vEPBPmmppSj98A3iDJ/iSkpEOHWpbDl5SB3tVIdaBVcuQ/NstquDPHUypO947AeGbL16HpREBEXxS8+xJtPvkLcUithZPeThskKNPaZjwdnPeCRRbIrV6dKwE3iP90SUtrmR1K9jqP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:39:37AM -0400, Michael S. Tsirkin wrote:
> Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
> callers can check whether the pool page is known-zero.  memfd's
> memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
> when the page is already zero.

But why does memfd do that?

This is more AI-ish 'write out in English what the code does' which isn't
really helpful.

>
> This avoids redundant zeroing for memfd hugetlb pages that were
> pre-allocated into the pool and never mapped to userspace.

I think this should lead the commit message given it seems to be the whole
intent no?

>
> Note: HPG_zeroed is currently only set for surplus pages
> allocated with __GFP_ZERO (via alloc_surplus_hugetlb_folio),
> not for pool pages from alloc_pool_huge_folio. So the
> zeroed output from alloc_hugetlb_folio_reserve is typically
> false for pool-only reservations. It becomes true when
> surplus pages fill the reservation. The addr_hint 0 passed
> to folio_zero_user is acceptable for memfd: these pages are
> not mapped yet and will get proper dcache handling at mmap
> time via the page fault path.

This paragraph is really hard to read, and you don't seem to propagate the
same very specific information in the code so people maintaining it don't
know what's going on.

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6

This is committing the sins of the rest and adding more complexity
throughout.

The whole approach needs a rework I think, but hugetlbfs stuff should be
deferred in general.

> ---
>  include/linux/cma.h     |  3 ++-
>  include/linux/hugetlb.h |  6 ++++--
>  mm/cma.c                |  6 ++++--
>  mm/hugetlb.c            | 11 +++++++++--
>  mm/hugetlb_cma.c        |  4 ++--
>  mm/memfd.c              | 14 ++++++++------
>  6 files changed, 29 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 8555d38a97b1..dee88909cf5d 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -53,7 +53,8 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
>
>  struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>  		unsigned int align, bool no_warn);
> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
> +				       gfp_t caller_gfp);
>  bool cma_release_frozen(struct cma *cma, const struct page *pages,
>  		unsigned long count);
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 06d033a57a61..7eb529eabe99 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -708,7 +708,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
>  				nodemask_t *nmask, gfp_t gfp_mask,
>  				bool allow_alloc_fallback);
>  struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
> -					  nodemask_t *nmask, gfp_t gfp_mask);
> +					  nodemask_t *nmask, gfp_t gfp_mask,
> +					  bool *zeroed);
>
>  int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
>  			pgoff_t idx);
> @@ -1128,7 +1129,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
>
>  static inline struct folio *
>  alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
> -			    nodemask_t *nmask, gfp_t gfp_mask)
> +			    nodemask_t *nmask, gfp_t gfp_mask,
> +			    bool *zeroed)
>  {
>  	return NULL;
>  }
> diff --git a/mm/cma.c b/mm/cma.c
> index c7ca567f4c5c..27971f6264ab 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -924,9 +924,11 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>  	return __cma_alloc_frozen(cma, count, align, gfp);
>  }
>
> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
> +				       gfp_t caller_gfp)
>  {
> -	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
> +	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN |
> +		    (caller_gfp & __GFP_ZERO);
>
>  	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
>  }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ed00db703911..a087e915783f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2196,7 +2196,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
>  }
>
>  struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
> -		nodemask_t *nmask, gfp_t gfp_mask)
> +		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
>  {
>  	struct folio *folio;
>
> @@ -2212,6 +2212,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>  		h->resv_huge_pages--;
>
>  	spin_unlock_irq(&hugetlb_lock);
> +
> +	if (zeroed && folio) {
> +		*zeroed = folio_test_hugetlb_zeroed(folio);
> +		folio_clear_hugetlb_zeroed(folio);
> +	}
> +
>  	return folio;
>  }
>
> @@ -2296,7 +2302,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
>  		 * down the road to pick the current node if that is the case.
>  		 */
> -		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
> +		folio = alloc_surplus_hugetlb_folio(h,
> +						    htlb_alloc_mask(h),
>  						    NUMA_NO_NODE, &alloc_nodemask,
>  						    USER_ADDR_NONE);
>  		if (!folio) {
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 7693ccefd0c6..c9266b25be3d 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -35,14 +35,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>  		return NULL;
>
>  	if (hugetlb_cma[nid])
> -		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> +		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
>
>  	if (!page && !(gfp_mask & __GFP_THISNODE)) {
>  		for_each_node_mask(node, *nodemask) {
>  			if (node == nid || !hugetlb_cma[node])
>  				continue;
>
> -			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
> +			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
>  			if (page)
>  				break;
>  		}
> diff --git a/mm/memfd.c b/mm/memfd.c
> index abe13b291ddc..a99617a62e33 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -69,6 +69,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>  #ifdef CONFIG_HUGETLB_PAGE
>  	struct folio *folio;
>  	gfp_t gfp_mask;
> +	bool zeroed;
>
>  	if (is_file_hugepages(memfd)) {
>  		/*
> @@ -93,17 +94,18 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>  		folio = alloc_hugetlb_folio_reserve(h,
>  						    numa_node_id(),
>  						    NULL,
> -						    gfp_mask);
> +						    gfp_mask,
> +						    &zeroed);
>  		if (folio) {
>  			u32 hash;
>
>  			/*
> -			 * Zero the folio to prevent information leaks to userspace.
> -			 * Use folio_zero_user() which is optimized for huge/gigantic
> -			 * pages. Pass 0 as addr_hint since this is not a faulting path
> -			 *  and we don't have a user virtual address yet.
> +			 * Zero the folio to prevent information leaks to
> +			 * userspace.  Skip if the pool page is known-zero
> +			 * (HPG_zeroed set during pool pre-allocation).
>  			 */
> -			folio_zero_user(folio, 0);
> +			if (!zeroed)
> +				folio_zero_user(folio, 0);
>
>  			/*
>  			 * Mark the folio uptodate before adding to page cache,
> --
> MST
>

Thanks, Lorenzo

