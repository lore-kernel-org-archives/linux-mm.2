Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36CAFFEE4E3
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 09:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029086B0005; Sat, 28 Feb 2026 04:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19026B0088; Sat, 28 Feb 2026 04:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E180E6B0089; Sat, 28 Feb 2026 04:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCBCF6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:30:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56BC9C34CB
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:30:27 +0000 (UTC)
X-FDA: 84493344894.25.D9577BB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 256DB8000D
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:30:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772271025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36+ox8ifDSsvjtPDq6jzvkqpc+zPvPY840Mq3tVVFvA=;
	b=kZJR3O1xF9OX+qVgCk1XevFyglkx3aR0ARig0Idm9TzTxg0mEOonmnaWmtQ3LQZAvGLluA
	RzP3ZsnF5iPRp7xTB23E9CNKWrxx/yp+jwwcLErh7RK3zAe+ss3WwU8YRiXU7lBHpKJ/0k
	zbG1M/tqzgU4CaYRtqj5Di9WUUmPpeU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772271025; a=rsa-sha256;
	cv=none;
	b=VpllsQQLj79XUlB117w2zR9fvKeBZnu+9EEm4ygrQxH0DMhtwYXCZV9HDBITH5J+UYkdnd
	I8c/u2ElXiMk733THMdj0x9cPmB+Ke3SxoHEwXx/YH3T5P7V0H6dN59lfdDeaCMXVQJifD
	TXmvkmy+eF8VSg3PTOBKBpdfQIx4wco=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AD991516;
	Sat, 28 Feb 2026 01:30:17 -0800 (PST)
Received: from [10.163.135.253] (unknown [10.163.135.253])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29DAA3F73B;
	Sat, 28 Feb 2026 01:30:06 -0800 (PST)
Message-ID: <94fcaf80-c812-43d9-8010-46eb9f913746@arm.com>
Date: Sat, 28 Feb 2026 15:00:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-2-npache@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260226012929.169479-2-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 256DB8000D
X-Stat-Signature: aon8a6aadxtdu7opzupkbwa4o14kq1d8
X-Rspam-User: 
X-HE-Tag: 1772271024-241067
X-HE-Meta: U2FsdGVkX18Bo9ah6p6C21ViH3sX4mOjBsHQYAZQBWakzLTYzx39jJdd1/EY6pCmg92Naud7npvMt/gsOXpMxqRuTocRumwm9vbMiB9tYSe5p82j+gP6SmUTV9bXTuPpbWQFs0AcIOFKNl1T1DUvvT1T0FrN6X2hm645VA80n7CmOxv/il8HokpE7g29oC1hw6cB7zoxWQoLF76tIQVQTRVO5TDBcjlAKY3Flgpt5w8mPqdi3LBZhuseLx5dnAc3gwLNmOC++0LQu6YplW5kkZpasuj/diZV3LmlfGnsgxVx/r43hcAk4qCmNAGLrJNZ3zxGWUhaqewlE2GaRgGA01ijLJT3TyF8CkG0uWu75IByXjDa4ZJ5k7Clf4wvL8gjFR3HIMZimIAC8aS060ebelNlma5+BPug27d3MIZ/0O2tfYOPxdaJ5qKV/EfZK1s+Ajf0Dw3leG024dCCltxh3LQ48GliY88j/almMiRP523laJow3UAVT20QIV16dCY73dX670KL9FLcdE7jByR6BJoTQU+Ju4/OhMp2SeBHlmJ5PruEcQsvowCM8HXtBuykBcjzuSkEEuO/C1/7/ptE+ePLyDrfznIMMPYD3MJEdCBpETqXSBrxNgF46UrfICerqXikJpspn7ZErIjnWPAOgoVYbJBDWxTIlAkBTzeSKXKM1tPuaRsvYJveVLHla5hkKC74znhiTUmVvi6AXzfSJoS8krwLi8vJ/aGyqw+p2JsfDr9kRysI1xoewQCrUve59zgcmyJQFyQ51u35wbalhS0lX3BxNIeynM+OqsgAsULBSy8zImy48P/2k9Qwc3613vHD4bTU1L3XyKd67zpknQY/UPcjDV+9A7/zct+3O+9K49JhG9LXGiHe4g/ZbrurkPFtV/A8YMAcP+qHJLvUb6/lyv/R8jJvboF5YhBwzCty1TjM63d5RYiKI3AIbnb3BiHVY1IYLAh0qeFJMmP
 k3H1c32d
 0MZ3Ti/VAo+tY9SHCuEnzwRtgeAPjOWKR1fhhpnc3zp3Uybln+otcGdYF6eQ+3qV1U7HXrMdTuS1g2gw35izE/W4HJacH5GqPvE41+a46YUCc4lL13mQRrHl3UaU11gbgPPOAT5S1fU+LGiUY0YePDr3R4nnXhL924GpCUX6esvoSupuwZ9Mg+MaHax0bxC6RcVxStGVBPNhBk6CDEHEMt/WB9oq44d3qg9oPdJpxD8IFMWR1njiEy6QjvtOqw1+n5GN3GmYKm3DynAJMLgOlhh18G3I7Lv4cQdG5QPNsq+dgsRpVl00P9TZd6oZO5ZZkrkDk/Fial3Uu/iY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/26 6:59 am, Nico Pache wrote:
> The anonymous page fault handler in do_anonymous_page() open-codes the
> sequence to map a newly allocated anonymous folio at the PTE level:
> 	- construct the PTE entry
> 	- add rmap
> 	- add to LRU
> 	- set the PTEs
> 	- update the MMU cache.
> 
> Introduce a two helpers to consolidate this duplicated logic, mirroring the
> existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
> 
> 	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
> 	references, adds anon rmap and LRU. This function also handles the
> 	uffd_wp that can occur in the pf variant.
> 
> 	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
> 	counter updates, and mTHP fault allocation statistics for the page fault
> 	path.
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
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

Should we make map_anon_folio_pte_pf() inline, since it has only one caller.

>  include/linux/mm.h |  4 ++++
>  mm/memory.c        | 59 +++++++++++++++++++++++++++++++---------------
>  2 files changed, 44 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 13336340612e..3ebf143c7502 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4901,4 +4901,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
>  
>  void snapshot_page(struct page_snapshot *ps, const struct page *page);
>  
> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp);
> +
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index 9385842c3503..a1a364e1fdcd 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5189,6 +5189,36 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
>  }
>  
> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp)
> +{
> +	unsigned int nr_pages = folio_nr_pages(folio);
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
> +		struct vm_area_struct *vma, unsigned long addr,
> +		unsigned int nr_pages, bool uffd_wp)
> +{
> +	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
> +	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> +	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
> +}
> +
>  /*
>   * We enter with non-exclusive mmap_lock (to exclude vma changes,
>   * but allow concurrent faults), and pte mapped but not yet locked.
> @@ -5235,7 +5265,14 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  			pte_unmap_unlock(vmf->pte, vmf->ptl);
>  			return handle_userfault(vmf, VM_UFFD_MISSING);
>  		}
> -		goto setpte;
> +		if (vmf_orig_pte_uffd_wp(vmf))
> +			entry = pte_mkuffd_wp(entry);
> +		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
> +
> +		/* No need to invalidate - it was non-present before */
> +		update_mmu_cache_range(vmf, vma, addr, vmf->pte,
> +				       /*nr_pages=*/ 1);
> +		goto unlock;
>  	}
>  
>  	/* Allocate our own private page. */
> @@ -5259,11 +5296,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
> @@ -5285,19 +5317,8 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
> +	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr, nr_pages,
> +			      vmf_orig_pte_uffd_wp(vmf));
>  unlock:
>  	if (vmf->pte)
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);


