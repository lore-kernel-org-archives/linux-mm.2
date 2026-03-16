Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07C5F53D85
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173706B0338; Mon, 16 Mar 2026 14:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13DB26B033A; Mon, 16 Mar 2026 14:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054046B033B; Mon, 16 Mar 2026 14:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E89EA6B0338
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:17:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A3AD1B7728
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:17:40 +0000 (UTC)
X-FDA: 84552734280.18.3A30F74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E40121C000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:17:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H2QlMKdk;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4pl5ietNKH3QZW441p9J2cgx+9XTaSmaVXiigTAPVo=;
	b=H5Y54pp+x1gTyC5t19J+2j5jq2XTa8c68VAbWNobFdgRaCUlBe+vs7ywYLuu9crbRiTZUs
	7XciGsaQgWNFXdYy3egZWW75Z2R+x3j+lfs1E8ZkVl03XTnl9E/5ct/YroMxqnydzZbQuM
	dx63tbelxl60OOT17gZvyktnN60IKAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773685059; a=rsa-sha256;
	cv=none;
	b=rH3DHocZTUnBp7kVLont3AxPap7uJ9O9Eop4wPEJFU1o8wwsom1z4RilO6intI9OeqrTrA
	uToDa2SLbVaView3tFvujXxItrL/Xbz4wEdswUyD4qb7JM3bM7H61WRgrfi7wTdgLljIy0
	dlFcwygiFYo3x4ONETLfIeno842nRbQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H2QlMKdk;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C543C60123;
	Mon, 16 Mar 2026 18:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98E1C19421;
	Mon, 16 Mar 2026 18:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773685057;
	bh=F3be5guAMaL0FVXHJLS8VMk7ogq/XmV4AmYh29KoUxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H2QlMKdkf1ETuHo8DIZKruoMUsNRJHUnA824bR36vDnUdJ8PjAdyHjn7c19TjTbQo
	 UYdmEq5zxvuNVIHykLgQZLesOVTCSzUVXfPW7L+3RgnfEw7pG7h97Q9koOFpwiVBHh
	 v4lc5TVvPs67h8VHp5PcnVV5qnkv5tgHAJzt+DLl4ltgRFIq5h1DIaOVEXBYf2LFOF
	 oTrRR6CbR7qagKZ3/T8AgsIDqwsN186u8YAOfaxS6Hgzp1rYGf0bCq9j1aNVU6N+a3
	 8b3EgtNz7e+hZfZkaRkkOzGJo+39py6EwrEOuTN27v1eUfO6kSMSNDfoRIXa3ovowF
	 toMS7u8V7BKpA==
Date: Mon, 16 Mar 2026 18:17:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v3 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
Message-ID: <5eae219d-62b8-4aea-905d-7a9b59b9892b@lucifer.local>
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-2-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311211315.450947-2-npache@redhat.com>
X-Rspam-User: 
X-Stat-Signature: z8tnc4x39gn9runy59hhbngmkfw9ec44
X-Rspamd-Queue-Id: E40121C000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773685058-761215
X-HE-Meta: U2FsdGVkX18HphXvWnOwqjmOEYE5t1jRgr1pZHB1AgBUqaIHBoB9oBIpt8UkCeUxRYkz046/T7Nd6eNmju8gdB+oYlECOCA0v/BvGUI2103d2X3M2vF3EYWtGz9WNA2pLE4x1Z3oC9POfj9S4+JlOOKeoJYCoEfRCxYRPf3zT5VnhuDEV29NgoZWRM/XJcYTW07eSqvgLvVN0ua9Yh1L7iToX3V/t5WUVIC5zeJLiXvrby3nuVBjnav6G9+tmnx87ILbjRx/tZj1yrOW6Rc5HhzimgryIJqaL+Z7cvZ04esBLf0mLVtnjK8Fjq6qnKgGWAjRmIAkcnvbmUIMsS1yfKfjRndrTkvYifZorOeD3zDFGjupz1HR0Em/8inqVH2hrR+xplq+11R8AKc6SBhauWReyR0d/X+Er9AtmUzBp3mirRwz8Ie7lBWtMO24mQxc/NoN9ztqQlzoksGlw34Z8iQW1ZpJsGxRO0d0odbyc5B6cIPfRqu+cDYQmhA4nkEvY2D2tvH0t7DRYfApDC7OAln0uEKxA0yplIe05yI2QY2LpR+W1zfe54EcXGjI4EvaWshUOlbLlpUP8aQBHVUD3kU5QXFfQFGwNmnp8BA+SXlFKXP4tcyhfe9CocSrQwVoM8dn7u4ZkA65vSTs72pA4vgXAQ4TIHhDtl/2liey5FUuCXC3/vWKwvRgeayMNnzaRTasLlOXckffJoBhmv706LsPo8YHNUmTrF8oMue3617k+GV+90uCjYbwhXBsiUaiXlz3BXM8g/lKcLncdJKRonzKM2JOAFrVdV+0TsMMRIDLGRMnDA46zs3LZLCieC/iu/ZB0laVlvC+Jjk2ctC2Quq0rFAMfEKZCnMmFZdHueDYl9DwYxg3JGsRsXWQYerEyhK4GkzzQxGFgU4xUvGz9pevY2DZo8J6oMxXFRbgbAPY9v0+vBTnEkiAMi7G0N0RPigxuGF0vctJDltd+Pb
 UEeM90Ii
 EOnivLd6E8YO3qSIJd5thmborkCJDHYVIIt15PkyNa5Bqa7YYXb/QmRNUaZJA1v0ltUaItvhCEnMPaBJaHMV7PVnD2UZx+kjhR/JPz7JFTHD41CIK6VCaXS7DsSLuBR8aVXMFM0Xu5OmD1Me/52tV2DMR8jeZDuz1U1RBxeKwD0+9Z7Rh5KeaMSr8n8WWDfrszIYIwnY3cVpIfC5+YkNcGy6oPJiSFlpkp6KgFvM1d34LgkV+ZZmswuVnQ3WBM/0mLpQO0jQLtXAHsIXuR5EoJHKgdbS0hXtFQFxMbDe869KYqW0Iz/erOrpX5Dq8a7DNdnOUxhYh5f6fGOljHODePkimIHXDPkl+fJuFScP7eYOL9ugwiDur0EFzdgZsdKy1qgUV8jCQ8rFVhKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 03:13:11PM -0600, Nico Pache wrote:
> The anonymous page fault handler in do_anonymous_page() open-codes the
> sequence to map a newly allocated anonymous folio at the PTE level:
> 	- construct the PTE entry
> 	- add rmap
> 	- add to LRU
> 	- set the PTEs
> 	- update the MMU cache.

Yikes yeah this all needs work. Thanks for looking at this!

>
> Introduce a two helpers to consolidate this duplicated logic, mirroring the

NIT: 'Introduce a two helpers' -> "introduce two helpers'

> existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
>
> 	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
> 	references, adds anon rmap and LRU. This function also handles the
> 	uffd_wp that can occur in the pf variant.
>
> 	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
> 	counter updates, and mTHP fault allocation statistics for the page fault
> 	path.

MEGA nit, not sure why you're not just putting this in a bullet list, just
weird to see not-code indented here :)

>
> The zero-page read path in do_anonymous_page() is also untangled from the
> shared setpte label, since it does not allocate a folio and should not
> share the same mapping sequence as the write path. Make nr_pages = 1
> rather than relying on the variable. This makes it more clear that we
> are operating on the zero page only.
>
> This refactoring will also help reduce code duplication between mm/memory.c
> and mm/khugepaged.c, and provides a clean API for PTE-level anonymous folio
> mapping that can be reused by future callers.

Maybe worth mentioning subseqent patches that will use what you set up
here?

Also you split things out into _nopf() and _pf() variants, it might be
worth saying exactly why you're doing that or what you are preparing to do?

>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>

There's nits above and below, but overall the logic looks good, so with
nits addressed/reasonably responded to:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/mm.h |  4 ++++
>  mm/memory.c        | 60 +++++++++++++++++++++++++++++++---------------
>  2 files changed, 45 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 4c4fd55fc823..9fea354bd17f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4903,4 +4903,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
>
>  void snapshot_page(struct page_snapshot *ps, const struct page *page);
>
> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp);

How I hate how uffd infiltrates all our code like this.

Not your fault :)

> +
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index 6aa0ea4af1fc..5c8bf1eb55f5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5197,6 +5197,37 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
>  }
>
> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp)
> +{
> +	unsigned int nr_pages = folio_nr_pages(folio);

const would be good

> +	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
> +
> +	entry = pte_sw_mkyoung(entry);
> +
> +	if (vma->vm_flags & VM_WRITE)
> +		entry = pte_mkwrite(pte_mkdirty(entry), vma);
> +	if (uffd_wp)
> +		entry = pte_mkuffd_wp(entry);
> +
> +	folio_ref_add(folio, nr_pages - 1);
> +	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> +	folio_add_lru_vma(folio, vma);
> +	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> +	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> +}
> +
> +static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr, bool uffd_wp)
> +{
> +	unsigned int order = folio_order(folio);

const would be good here also!

> +
> +	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
> +	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1 << order);

Is 1 << order strictly right here? This field is a long value, so 1L <<
order maybe? I get nervous about these shifts...

Note that folio_large_nr_pages() uses 1L << order so that does seem
preferable.

> +	count_mthp_stat(order, MTHP_STAT_ANON_FAULT_ALLOC);
> +}
> +
>  /*
>   * We enter with non-exclusive mmap_lock (to exclude vma changes,
>   * but allow concurrent faults), and pte mapped but not yet locked.
> @@ -5243,7 +5274,14 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  			pte_unmap_unlock(vmf->pte, vmf->ptl);
>  			return handle_userfault(vmf, VM_UFFD_MISSING);
>  		}
> -		goto setpte;
> +		if (vmf_orig_pte_uffd_wp(vmf))
> +			entry = pte_mkuffd_wp(entry);
> +		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);

How I _despise_ how uffd is implemented in mm. Feels like open coded
nonsense spills out everywhere.

Not your fault obviously :)

> +
> +		/* No need to invalidate - it was non-present before */
> +		update_mmu_cache_range(vmf, vma, addr, vmf->pte,
> +				       /*nr_pages=*/ 1);

Is there any point in passing vmf here given you pass NULL above, and it
appears that nobody actually uses this? I guess it doesn't matter but
seeing this immediately made we question why you set it in one, and not the
other?

Maybe I'm mistaken and some arch uses it? Don't think so though.

Also can't we then just use update_mmu_cache() which is the single-page
wrapper of this AFAICT? That'd make it even simpler.

Having done this, is there any reason to keep the annoying and confusing
initial assignment of nr_pages = 1 at declaration time?

It seems that nr_pages is unconditionally assigned before it's used
anywhere now at line 5298:

	nr_pages = folio_nr_pages(folio);
	addr = ALIGN_DOWN(vmf->address, nr_pages * PAGE_SIZE);
	...

It's kinda weird to use nr_pages again after you go out of your way to
avoid it using folio_nr_pages() in map_anon_folio_pte_nopf() and
folio_order() in map_anon_folio_pte_pf().

But yeah, ok we align the address and it's yucky maybe leave for now (but
we can definitely stop defaulting nr_pages to 1 :)

> +		goto unlock;
>  	}
>
>  	/* Allocate our own private page. */
> @@ -5267,11 +5305,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	 */
>  	__folio_mark_uptodate(folio);
>
> -	entry = folio_mk_pte(folio, vma->vm_page_prot);
> -	entry = pte_sw_mkyoung(entry);
> -	if (vma->vm_flags & VM_WRITE)
> -		entry = pte_mkwrite(pte_mkdirty(entry), vma);
> -
>  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
>  	if (!vmf->pte)
>  		goto release;
> @@ -5293,19 +5326,8 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  		folio_put(folio);
>  		return handle_userfault(vmf, VM_UFFD_MISSING);
>  	}
> -
> -	folio_ref_add(folio, nr_pages - 1);
> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> -	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
> -	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> -	folio_add_lru_vma(folio, vma);
> -setpte:
> -	if (vmf_orig_pte_uffd_wp(vmf))
> -		entry = pte_mkuffd_wp(entry);
> -	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
> -
> -	/* No need to invalidate - it was non-present before */
> -	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
> +	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
> +			      vmf_orig_pte_uffd_wp(vmf));

So we're going from:

entry = folio_mk_pte(...)
entry = pte_sw_mkyoung(...)
if (write)
	entry = pte_mkwrite(also dirty...)
folio_ref_add(nr_pages - 1)
add_mm_counter(... MM_ANON_PAGES, nr_pages)
count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC)
folio_add_new_anon_rmap(.., RMAP_EXCLUSIVE)
folio_add_lru_vma(folio, vma)
if (vmf_orig_pte_uffd_wp(vmf))
	entry = pte_mkuffd_wp(entry)
set_ptes(mm, addr, vmf->pte, entry, nr_pages)
update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages)

To:

<map_anon_folio_pte_nopf>
entry = folio_mk_pte(...)
entry = pte_sw_mkyoung(...)
if (write)
	entry = pte_mkwrite(also dirty...)
if (vmf_orig_pte_uffd_wp(vmf) <passed in via uffd_wp>) <-- reordered
	entry = pte_mkuffd_wp(entry)
folio_ref_add(nr_pages - 1)
folio_add_new_anon_rmap(.., RMAP_EXCLUSIVE)
folio_add_lru_vma(folio, vma)
set_ptes(mm, addr, pte, entry, nr_pages)
update_mmu_cache_range(NULL, vma, addr, pte, nr_pages)

<map_anon_folio_pte_pf>
add_mm_counter(... MM_ANON_PAGES, nr_pages) <-- reordered
count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC) <-- reodrdered

But the reorderings seem fine, and it is achieving the same thing.

All the parameters being passed seem correct too.

>  unlock:
>  	if (vmf->pte)
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
> --
> 2.53.0
>

Cheers, Lorenzo

