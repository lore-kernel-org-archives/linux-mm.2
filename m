Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7C7606A33D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g6RtbLrc
Received: by kanga.kvack.org (Postfix)
	id 4C9FD6B00EF; Wed,  4 Nov 2026 08:35:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A19E6B05B1; Wed,  4 Nov 2026 08:35:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390946B05B2; Wed,  4 Nov 2026 08:35:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17E406B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:35:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9788E1206E9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:35:26 +0000 (UTC)
X-FDA: 85397533452.01.C81F5BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF9BB4000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:35:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g6RtbLrc;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799324;
	b=142DFJYcGDx9UEBAZRQsKXQe5WRdQps2LK0t3Ek7cm/U0gHkyJo58+HA/nCvb2HsOf8rBB
	xpHqKGle89MXYnHI7w6FeUh6+Rqho0eNycX/JGHVf5zjYLOpzBE+zhWUi6UMlnwkzXLtz9
	5Y/oeWjkPq1u3ysKQ/GB51iWwToHj0Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g6RtbLrc;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqdPmBaoUJnGfJ3H8rQp/poxysg2bFQew8nX+MtUTMY=;
	b=t6jvxcwtDsv1zW/z2V/blFutWjLcD9AdXZkkt3q99COaOT0D5jFnpbMSEoKQr+IRiLEURv
	3IfON23XuG7w9g/PPZNrn8Tv1j1cBNUJotqcAGY98KpzxxoCLMsIZ1zObAqFTt0i9ewf3S
	tkwb3kxLdSjjdoK+bQ35ykfb3XKzWnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00BD941FE4;
	Wed,  4 Nov 2026 13:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE0B1F000C1;
	Wed,  4 Nov 2026 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793799323;
	bh=MqdPmBaoUJnGfJ3H8rQp/poxysg2bFQew8nX+MtUTMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g6RtbLrc50PuR2+Gt7IkaluB+X+QhOhWLlreFRtgfF7H3qOE+DU+ZS54we4sLvmvJ
	 BLaDA/RxAXfXJUJqxuZqRwTbq7RpoDtSk3NHgAHBkzN4PYzqQEu8WrLL9j+DRtg0ZN
	 zDKI4nrL6g+pc1GgimWqTRBLqENtQeOOsHcsZit01W2bcNpUa5v2I+Ng3cAAud2dCY
	 y+3sfDr9MXFoOIo1/66JJevMH+yvdbI9p/BqlchvjPfMyvU9WPJZVVAFNHO9d4Rg2g
	 79CedPrCI1UxzIruR39nCQVqLv1aTKrt0aRP2nepvwtWTy+oYRVwsob9MDq72kgajq
	 grQlA1vBmEbww==
Message-ID: <fa75220f-fa3a-4198-a2cd-90fb72ee0127@kernel.org>
Date: Wed, 4 Nov 2026 14:35:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sparc64: replace move_pte() with a D-cache flush in
 flush_cache_range()
To: Imre Kaloz <kaloz@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104105300.16260-1-kaloz@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104105300.16260-1-kaloz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF9BB4000A
X-Stat-Signature: gz9i3w5inswiwifkwwsi6ktbxsj8bhba
X-Rspam-User: 
X-HE-Tag: 1793799324-920499
X-HE-Meta: U2FsdGVkX19m6fiG0fyQv/hLBc0KELHgJpAceJe2Kozx70bMIQLPw6Iy8XF8ly7RJ1vfCuSUh1QNoFfMcZGuLQfIsx89qUsJvHs5veZCny2NZJGUmB5rA/zZocBHo4c+99023r4buMoAZ84vapZZQQxL66eKFZk/HmOeAzEBA5N5fGmMNYyLTSoQXEzPbl250C3d5pBRC1MCpB1V7WvAATXlW9H8bv1u8cINVtBTYVmuizOQwnidJQAMMlRBjXMooNTzyGtvvjM5LyLbVumcn+/8ziyhvdHknYt9T2n3xeswVjUY8I+Pn2ba3YRJiAz+cGxQZev4I5mKhn8ARHr6Dg5agnabbT1GcT4n8a11ydrfqpiBp99iNtsneODP3GgzJkIBCljpAQL5OqVtU41z8EoKyN/KI7WWl+vf643x6qPU7T7Tm+pRL9GUtt+C5BRiKUDRDMAvWEalbG+lShCpDjxwvNvEfFv8VSp7mHRzEyf0Vu5loz9O+k+b9ItQMM2QPKBtyHNDsyHnCbXWdX6AuFYoPbJ3dVRgspPZFKXK5pCSjwPtYxe9VWnRDUJNOvEHgkODFnpU7lFkLRmOpbKr3lmt+Lv8Is4ucozQXxlZhpNaPe1DUreeYinySvhmccZduqYSAi2JDSlnZGgTV1rHblnckooHGeAPsPA7VKkPejx1mJPjbmhWR+FUcVBfEEmB54/cHb3k1mH2LO8HUJUid7p0SUK86n95ShpYmm/x5NCgs03fxYBYxq+6cdsVwb6M2f1NFPsBcOBQOvBT+3oo4qJ6lp08Taet4hKR/H+M3htMdH5xdHkD2flyllzDvNQ4X/Q7kXjIfo5y2RAaxtk9n+mDUWR8szJsb/S6ZMMrmpYGXg/TRpZpCuAkkaM4KrIwP7FBwETdUIexR/fs+Y5wF12qiPVsZmMYwL43ueZV9fwKc3EW/5sa2OnU4kVtRgdLg48y0zl8RJgHKakbTPX
 JbOEQzzz
 UrGKTfIzaEH0ySiaMQR9AeGcuCEFvBfi/dh8RvvXA4OZkiPI3Z1veYC3QU64vCsJTZXd0nAdPqH1y086NR4UUvOLgtu/BPIiyxj0gy5YBo6MBDulS0WxSdgXJIt4yWQN3lpMNNU2spKaUDFqitxYLwavwLf2fdzsVMTZP0o6VdV6a5J7KQSK4gSVn/BMh2Y3RHgwQjsg7HIGgy7nuN5Vb5ghB/frXCipvysxB4aQ0miuX/IaJvv0Pjc47KmODFwTZ9tzoEpFqvhRss3+R1FraReY2my1Vqc0fWW2EmGMJo17Zf7g89pOQpLo62rvKUSeEZBBnd9m/2UPPPbEqKzSE9IoRkixE3SL4pqFB18SbAwXj2OANgBSMlh9jL2QhcOEQPGtv7qVFWvyCf6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 11:52, Imre Kaloz wrote:
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
>  		pte = move_soft_dirty_pte(pte);
>  
>  		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
> 
> base-commit: c95443b98771a74c6689f5e7bbc56794fe95f550

Lovely.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

