Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A5FCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6350D6B00A4; Mon,  8 Jun 2026 06:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5766B00A5; Mon,  8 Jun 2026 06:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADB96B00A6; Mon,  8 Jun 2026 06:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD366B00A4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:05:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E49AEC3346
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:05:24 +0000 (UTC)
X-FDA: 84856312968.24.731D4FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 394A51C0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:05:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GzwngoDz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780913123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zILBs+QcGl99GpFCA+Q3N4MJb7Ci5s+J8iap/Qlkgek=;
	b=iJKw5QNI3MNG0Bi+5C3CapQGtW8vSDclcFvYby+9clOoQSKfttgQka8ZGkU4fpO/VSJBrZ
	iSP1CZQqW7ArxiRK3fDnE44gzAJx5OTeTgdSb67QzADq4N/cCG3JuSrAxpoc0/aQkFfV9m
	hklcEAZkJIjwKtjJnP98gUpX0bSis3s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GzwngoDz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780913123;
	b=QVkSQT8n5fBzREQXqCfFiz4i/APFuuoUD3TV9uMRrRPiazCnlaFpPNNz1xlzV9ye1O0fJB
	XQsSV3M7OyQuQZcyQkUudltWeSMDZsr4s3M8idQ/vlhMB0O/y7lxdYaNXed9mJTDHn9Z72
	8oZeHyLnPScT5oiYDpqKGlp1P9/oWSc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66DB442A67;
	Mon,  8 Jun 2026 10:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714B11F00893;
	Mon,  8 Jun 2026 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780913122;
	bh=zILBs+QcGl99GpFCA+Q3N4MJb7Ci5s+J8iap/Qlkgek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GzwngoDzoOflt5V+bdMt2drTLWGY96sMaxEc6unA4K2N5wWYaSNgJTuePgDbI5xdV
	 P2VT9Kt1Wj2sFRqC9962RaltOjMrkdGYSSrfv9EWRSgP4smTiefhAhC7HMEQmeAXFR
	 aSoXxYmsV3mkxE54BU1oz7Q3iF3AMpZ760IyWiBCdXynZZMvkqkMIU5VARtnzT9gMh
	 XWLh5t6qubKnOoGWGJlGpWSda8T5TqnmhphmBK2/7TT9AXHgJvDYMC4GGawkudru7k
	 8hipsb3T8nQOBVldOpUur4CdLsrkcbjelK1MdeImzuM6LzNJMfdcFmLmIMXhTu9qni
	 rrOcY7EbUk9xQ==
Date: Mon, 8 Jun 2026 11:05:09 +0100
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
Subject: Re: [PATCH v10 06/37] mm: move vma_alloc_folio_noprof to page_alloc.c
Message-ID: <aiaSI4SlVDIa4Y73@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <5a3034dc7b3d5ea1edcc8b9baff63c980b7ae434.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a3034dc7b3d5ea1edcc8b9baff63c980b7ae434.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: k66y1gwzktcrqb539zr7q3gcaaesdwji
X-Rspamd-Queue-Id: 394A51C0006
X-HE-Tag: 1780913123-338966
X-HE-Meta: U2FsdGVkX18oG+RS9wAPXKNN+g2Trnm3+DVL7ubZSvMYc2cNnhBUtsxR9ywJv4K48j5QUrlwWIsHdfOyfp5Rsq0Insx6l11A6hdABDt0qbWRFS64xlgPXPKNasrFk9W0LSXvrVCpiJDRQjSz831om+d3FfeaacXB5SvIHZ/DjUcVeG/3Abf19VvohScBbhlw2Dm6ust9UO7NFOk0y8wXTjqw6W8QF47kqxg2mxn/mwlMx5V6UyuJzOP/FMi6vvyLqZlESiVna9Ch5eI103F3Y6jwDxfY5HyWZZCVF2uNXudavnECNzWYS5tsurhsev+CqC5ZK/fanu7mAOwO02PMXKTjewBqS5AiQwrqjZFiC8ahL21fDui3OqJG+tnlV4Eh0HrewaT24HL8nXgpv8ZU7o+e6V7XpSvgw1tL/EDDzoiU9OlCVK4b6PUsI3w0LZCDdCdmvL45/RkHvi53f1fOwP+dN6spHn46c7re8M2dqMCP+eADNToeYC+l/dUtO1p41d5o0qNWbRwclDjDW5O5DpFGS2ZXnIO2F1dL76HH4VYY2rEwVH30OEX8MX4/XQr94podlo14SCKsLim8CkPFYlFCTLmxjqnapeKOLKgU0DCKqVeT6A7UK4smRJQ3xFfJvY+5Vz/I2nn3I338CWJ8davKfl77ExhV8K3+1OSxU8MgIQeVO7+oIomldR9f1L9gxZjMzEoJVO6OHlxPZ1e0HPA7htsTWwU4nb+IClw0LM3DF7QPLG9thGMn8Dp0dDX3O8U7+rWPm0GXrDvfBi0QAAHT+9YnUIbatXk0yaNqQQeF2bp7wxKFuF61NMw0gunqRCdUQ8eU5tyrUF9BQX41UUfzvBSH65y2k8tRUqxlh3JRYOot4WqxKxVGcS843PEggUw3TTOjoQ07eoAJDd+nVRgoWrbRR7X62pzbu9CZXLwPOWaOJBkhWfkWJF9D6fEF5FVRUDAOuJt/TkWNR1B
 3NF76Gg2
 Bp3905v7ODHiI0Qt6mH5baXZE9SDdqgPhEuwByabwb9yUK8/dV6t6/RtapoDLHMFWqnWBCZnFZUYsZ/8UvEUk0IQ7L8ycHVE/bawSa68k53plEg3AhfiZwEkGPgUjyYeQ9DpbblLXI+s6iqv7kot2W3CCVmf0EB4kdnCTp3eaj88vgsyf8Kxhaib8dxpaAzpg5YAMGsYftz6c9l6plAFd25JcKmw7AjaSX4raBicd07npjDKjW2YDODCsEIRElccYc3uSuOp0EUFo8Hdim57dqWCK8hBMmlvh+AIJdMLykFiBtoMEpyX4ydT8kJLJSIftSTe09PriIA6WIl2pDGfiusjfzV3WagbZcOgpA6iv35BK9PAf34fgO9HAF1gZVVJJLEzZtdjH1ZEaG4RUewJD9qiUjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:35:05AM -0400, Michael S. Tsirkin wrote:
> Move vma_alloc_folio_noprof() from an inline in gfp.h (for !NUMA)
> and mempolicy.c (for NUMA) to page_alloc.c.

This is an incorrectly described patch. You're not moving the function,
you're also altering its behaviour.

Do the two changes separately, and justify why you are changing this
behaviour.

>
> This prepares for a subsequent patch that will thread user_addr
> through the allocator: having vma_alloc_folio_noprof in page_alloc.c
> means user_addr can be passed to the internal allocation path
> without changing public API signatures or duplicating plumbing
> in both gfp.h and mempolicy.c.

We seem to have a fun mess with some NUMA stuff living in mempolicy.c and
some living in page_alloc.c with #ifdef CONFIG_NUMA's around it.

But I guess that was a pre-existing problem...

>
> The !NUMA path gains the VM_DROPPABLE -> __GFP_NOWARN check
> that the NUMA path already had.

What is your justification for doing this? Commit messages that put the
code changes in English are not helpful, tell me _why_ you are doing this.

It seems that you're suggesting not doing this was a pre-existing bug?
Therefore it would need a fixes/cc: stable no? Unless you feel this isn't
significant enough to require that?

If not, then why are you changing this behaviour?

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  include/linux/gfp.h |  9 ++-------
>  mm/mempolicy.c      | 32 --------------------------------
>  mm/page_alloc.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+), 39 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 51ef13ed756e..7ccbda35b9ad 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -318,13 +318,13 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
>
>  #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
>
> +struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> +		struct vm_area_struct *vma, unsigned long addr);
>  #ifdef CONFIG_NUMA
>  struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
>  struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
>  struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
>  		struct mempolicy *mpol, pgoff_t ilx, int nid);
> -struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
> -		unsigned long addr);
>  #else
>  static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order)
>  {
> @@ -339,11 +339,6 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
>  {
>  	return folio_alloc_noprof(gfp, order);
>  }
> -static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> -		struct vm_area_struct *vma, unsigned long addr)
> -{
> -	return folio_alloc_noprof(gfp, order);
> -}
>  #endif
>
>  #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index d139b074a599..a1707ad498a8 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2516,38 +2516,6 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
>  	return page_rmappable_folio(page);
>  }
>
> -/**
> - * vma_alloc_folio - Allocate a folio for a VMA.
> - * @gfp: GFP flags.
> - * @order: Order of the folio.
> - * @vma: Pointer to VMA.
> - * @addr: Virtual address of the allocation.  Must be inside @vma.
> - *
> - * Allocate a folio for a specific address in @vma, using the appropriate
> - * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
> - * VMA to prevent it from going away.  Should be used for all allocations
> - * for folios that will be mapped into user space, excepting hugetlbfs, and
> - * excepting where direct use of folio_alloc_mpol() is more appropriate.
> - *
> - * Return: The folio on success or NULL if allocation fails.
> - */
> -struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
> -		unsigned long addr)
> -{
> -	struct mempolicy *pol;
> -	pgoff_t ilx;
> -	struct folio *folio;
> -
> -	if (vma->vm_flags & VM_DROPPABLE)
> -		gfp |= __GFP_NOWARN;
> -
> -	pol = get_vma_policy(vma, addr, order, &ilx);
> -	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
> -	mpol_cond_put(pol);
> -	return folio;
> -}
> -EXPORT_SYMBOL(vma_alloc_folio_noprof);
> -
>  struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
>  {
>  	struct mempolicy *pol = &default_policy;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8dae5b3f5876..6a605d05e8cd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5286,6 +5286,49 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>  }
>  EXPORT_SYMBOL(__folio_alloc_noprof);
>
> +#ifdef CONFIG_NUMA
> +/**
> + * vma_alloc_folio - Allocate a folio for a VMA.
> + * @gfp: GFP flags.
> + * @order: Order of the folio.
> + * @vma: Pointer to VMA.
> + * @addr: Virtual address of the allocation.  Must be inside @vma.
> + *
> + * Allocate a folio for a specific address in @vma, using the appropriate
> + * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
> + * VMA to prevent it from going away.  Should be used for all allocations
> + * for folios that will be mapped into user space, excepting hugetlbfs, and
> + * excepting where direct use of folio_alloc_mpol() is more appropriate.
> + *
> + * Return: The folio on success or NULL if allocation fails.
> + */
> +struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +	struct mempolicy *pol;
> +	pgoff_t ilx;
> +	struct folio *folio;
> +
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		gfp |= __GFP_NOWARN;
> +
> +	pol = get_vma_policy(vma, addr, order, &ilx);
> +	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
> +	mpol_cond_put(pol);
> +	return folio;
> +}
> +#else
> +struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		gfp |= __GFP_NOWARN;
> +
> +	return folio_alloc_noprof(gfp, order);
> +}
> +#endif
> +EXPORT_SYMBOL(vma_alloc_folio_noprof);
> +
>  /*
>   * Common helper functions. Never use with __GFP_HIGHMEM because the returned
>   * address cannot represent highmem pages. Use alloc_pages and then kmap if
> --
> MST
>

Thanks, Lorenzo

