Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76401606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsXz2WEI
Received: by kanga.kvack.org (Postfix)
	id 94FBA6B05B2; Wed,  4 Nov 2026 08:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9272B6B05BE; Wed,  4 Nov 2026 08:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864BF6B05BF; Wed,  4 Nov 2026 08:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C67A6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:48:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAB22C06CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:48:57 +0000 (UTC)
X-FDA: 85397567514.02.0BA10D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 667964000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:48:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsXz2WEI;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793800136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyCvdnbxGGbkXes50cr17UZS5hPmW+udSXklBRmG4r0=;
	b=Cmx8T9Nv82GAS63c4zR2x0p7Wn2Z99X0dWGmvyFAZeKGoNK8aWydHLNA28Kg3H2GXYCYgj
	YnNrumT4esOhyav0mgtC1+p1bh0wreURRz7qdOonwo5XGk0fkuik+LVU2w7tXq4LmTAsWX
	GKa89tAk71lOz6Q97Ra9RxPOmFv3A0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793800136;
	b=u5ejSBVJw1D6DkWv/RHk4mGgzkd9Iql1yv//KhKBQnpDVKNy3toVX4ZyV3oSlPvRp6y7M6
	UYDN9jASK/imzgGIqDAeV2I6rtFyr2KisOVNpPkx9bQCYfpUX7lCbiYQJryuHfI95StSb8
	7V4u35majIYptZkbDBNMdiQvBo5CAGs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsXz2WEI;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED3CC60F32;
	Wed,  4 Nov 2026 13:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3AB1F00A18;
	Wed,  4 Nov 2026 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793800135;
	bh=YyCvdnbxGGbkXes50cr17UZS5hPmW+udSXklBRmG4r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gsXz2WEIn8L3GKnLo5nPC0VwY3g/xB+nnswufi/eD2KcrwnffL/1YWXj55zOR6xpf
	 anLepFBx084qLrnNUn4AiMirviJMfC/HxLH8FHYC70iBnKybqHrILKtWEA6kc5GxrN
	 XOQP6QCnJRAsjGBXOv7sjbPQ2+jOlnXWXfmY4kueV10efVZU2Yw8AbicBrNmYtKNb1
	 xF3tDRkoqkC4XH4XBR/g3Pkyv/D0Gz6jR4PC9CidUD4+rUX2RNXjCYReRWdMKqtj2n
	 9RwZbGXl5jfH0JmkJ64mSyVR/0OrmRTt6dgYfrZp+MYOLjvkmkg+BJ3W0fVqgmeXiZ
	 hcRHpdML0hcLQ==
Date: Wed, 4 Nov 2026 13:48:50 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] sparc64: replace move_pte() with a D-cache flush in
 flush_cache_range()
Message-ID: <aus2bLyqhZCNP7rN@gremlin>
References: <20261104105300.16260-1-kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104105300.16260-1-kaloz@kernel.org>
X-Stat-Signature: sgcgzd5dxoddxy3dj3yx5sdh6jnd1naa
X-Rspamd-Queue-Id: 667964000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793800136-182746
X-HE-Meta: U2FsdGVkX19/EDGWlzb7U9NIYXX+H9V+z0K+Em5Lx20io9jA0BU4hc5G8kFYvFDJzH9BTHJG+PEt5sGiKxwsTmvb6sbXDIetZ+ycj6emgSg3J73h9H9tnexhfGl2W0rO+B3KXKmDXoXQvbRm8p0dtbwT9JbLXWEpX5N4Kh73QjVIr14e9cE4Ee8lsJKrv44hKB0vMp2MtovP32nyUz+WrM4LjGickrsBbbyjUU3/1bO3ryVEa8GvDvpFADfO0iVF/yh89qCdrjvb+9Kd8JLJwqvc/VoDASn6WL+a6UZp8tfUnV8C24La2LNPg9pQ44hHNS2sgNGQP3NpWi4aZQaB3XeL1aSYr8YyW49YPfJU3YitK6yLm7K5zMjyq2rdW/87Tr8uCMUiM891QS9q3/EaI8jT7mBAXXOMq71B73pdnuM95Ez4GLZVPrRSZJ1mMfMBwIjUIkDEqp3xiWYssKVD+d8qqSQJY3nahUcT33adlK/gBIU/l2HEIsialD7XvzHb1xhyhBbmS/5C+tgkHfagcU2EQFfdyj9PMk6dWWhV4fZejIdkW89bvhGXFq9WUN3jaMC2FHqSL5cDowCLxu+TUX273F+b2sh/2MA5ScdtycXm3sa4imH8n3jKRhqdeiL4bnwY+7RwDm//ew/ti9YQkIHTyLMo/qRN2h1IICbdOmCBio+tyB9NuAgeJUE3JB7LBL4UPlpdpOsSA/4/A3uRR6khyw/yoKC7au61PwTGOAweBdV44ABD28JhnpMVhIG+3e48M0eXaoD2XCo+8I3vEbm3Xsbe10OfEwh/KOSIYw3DOQ6O2tXE0+vfKK2AI2pX83OPJk8e1QYH1EtL56So4TA1nk6z3uwmYZM6sI7j9HtSxXCSxnXMoYwOj4C289Siz00s9gmgHAGA+xxyI7yHGI41PiE3SgqCIhDYPZEWePwU2jXbqSEha4QSv3N6Asg2hvjZUC6xNHeuGr5upSd
 p2ijMA4f
 yf1VauuUkADTCX2C0xc1uQJqHGtLASRxFCWwPkXV2cmdnhtFtxgVeUmCiVrf+U6E7dtMbspGGe29cQrnkHh5PhPy0ifLmZ8OrNBGV/S+/PxdH4BXnkFNPLhrY//AD8E2QmjvImVC17yOUCsHemjlyUecyFF+AN81jfI/olku5528JvDBcXwu9pagMPDpvLuC0bgrN6TxuNkHETGj4ydN7RjRmL4x/CxWs8N8b+OHJL1FcRxOQEnM+ecJ/bQHAaznMLdn/p+DsGI5Cznx8fn5cuk5o4/HTb1wi3PFXqsY/qF77w//4I2ZO5SEDOKzt9r3FmgrwjP6Mn718o6v9TIs5rIACqZIKlSD5+xIbK8MOXbpMBMPr4OzcHRgquY98ut61e1FF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 11:52:58AM +0100, Imre Kaloz wrote:
> mremap() can move a page to an address of the other D-cache color,
> leaving lines of the old color in the virtually indexed D-cache of
> Spitfire and Cheetah CPUs.  move_pte() flushed the page for each PTE
> moved, which is only correct while move_ptes() handles one PTE at a
> time.
>
> Drop move_pte(), which no other architecture defines, and flush the
> whole D-cache in flush_cache_range(), which mremap() calls on the old
> range before moving the PTEs.  This keeps the fix in sparc64 without
> a page table walk.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Link: https://lore.kernel.org/all/409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org/
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>

Oh lovely thanks :) LGTM!

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Andreas asked for this as a separate patch once the merge window was
> over [1]. It applies on top of sparc for-next.
>
> [1] https://lore.kernel.org/all/4fba060e-c4f4-4d73-8efe-dbed0b5a7bc3@gaisler.com/
>
>  arch/sparc/include/asm/cacheflush_64.h |  4 ++--
>  arch/sparc/include/asm/pgtable_64.h    | 21 ---------------------
>  arch/sparc/mm/init_64.c                | 18 ++++++++++++++++++
>  include/linux/pgtable.h                |  4 ----
>  mm/mremap.c                            |  1 -
>  5 files changed, 20 insertions(+), 28 deletions(-)
>
> diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
> index 54a2d37008e6..1a116b288816 100644
> --- a/arch/sparc/include/asm/cacheflush_64.h
> +++ b/arch/sparc/include/asm/cacheflush_64.h
> @@ -21,8 +21,8 @@ void __flushw_user(void);
>  #define flush_cache_mm(__mm) \
>  	do { if ((__mm) == current->mm) flushw_user(); } while(0)
>  #define flush_cache_dup_mm(mm) flush_cache_mm(mm)
> -#define flush_cache_range(vma, start, end) \
> -	flush_cache_mm((vma)->vm_mm)
> +void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
> +		       unsigned long end);
>  #define flush_cache_page(vma, page, pfn) \
>  	flush_cache_mm((vma)->vm_mm)
>
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> index c26f2888aa18..310b66459521 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -935,27 +935,6 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>  #define pte_clear(mm,addr,ptep)		\
>  	set_pte_at((mm), (addr), (ptep), __pte(0UL))
>
> -#ifdef DCACHE_ALIASING_POSSIBLE
> -/* This flushes only the page the PTE maps, so it relies on move_ptes()
> - * calling it for one PTE at a time, which the default pte_batch_hint()
> - * guarantees.
> - */
> -#define __HAVE_ARCH_MOVE_PTE
> -#define move_pte(pte, old_addr, new_addr)				\
> -({									\
> -	pte_t newpte = (pte);						\
> -	if (tlb_type != hypervisor && pte_present(pte)) {		\
> -		unsigned long this_pfn = pte_pfn(pte);			\
> -									\
> -		if (pfn_valid(this_pfn) &&				\
> -		    (((old_addr) ^ (new_addr)) & (1 << 13)))		\
> -			flush_dcache_page_all(current->mm,		\
> -					      pfn_to_page(this_pfn));	\
> -	}								\
> -	newpte;								\
> -})
> -#endif
> -
>  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>
>  void paging_init(void);
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index 6a0ba9a01a21..a1ab1eacbf33 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -3115,6 +3115,24 @@ void flush_cache_vmap(unsigned long start, unsigned long end)
>  #endif
>  }
>
> +/*
> + * mremap() moves the PTEs of [start, end) to addresses that may have the
> + * other color, and calls this on the old range first.  Flush the whole
> + * D-cache so no line of the old color outlives the move.
> + */
> +void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
> +		       unsigned long end)
> +{
> +	/* flush_cache_mm() spills the user register windows. */
> +	flush_cache_mm(vma->vm_mm);
> +#ifdef DCACHE_ALIASING_POSSIBLE
> +	/* The D-cache is virtually indexed on Spitfire and Cheetah. */
> +	if (tlb_type == spitfire || tlb_type == cheetah ||
> +	    tlb_type == cheetah_plus)
> +		flush_dcache_all();
> +#endif
> +}
> +
>  void flush_tlb_kernel_range(unsigned long start, unsigned long end)
>  {
>  	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b..c729c3cc8bda 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1470,10 +1470,6 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
>  }
>  #endif
>
> -#ifndef __HAVE_ARCH_MOVE_PTE
> -#define move_pte(pte, old_addr, new_addr)	(pte)
> -#endif
> -
>  #ifndef pte_accessible
>  # define pte_accessible(mm, pte)	((void)(pte), 1)
>  #endif
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 0d06d7f37f19..87cb15027bfd 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -289,7 +289,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  			force_flush = true;
>  		}
>  		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
> -		pte = move_pte(pte, old_addr, new_addr);

:))

>  		pte = move_soft_dirty_pte(pte);
>
>  		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
>
> base-commit: c95443b98771a74c6689f5e7bbc56794fe95f550
> --
> 2.47.3
>

--
Cheers, Lorenzo

