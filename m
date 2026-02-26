Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2087CFC5913
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A646B008A; Thu, 26 Feb 2026 04:28:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837666B008C; Thu, 26 Feb 2026 04:28:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A656B0092; Thu, 26 Feb 2026 04:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 605146B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:28:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F14CD1CE9A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:28:11 +0000 (UTC)
X-FDA: 84486081582.19.CF89CA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1E12E180008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:28:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxMLcIyF;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772098090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2wjehqufVBx9mw5zUJ2jma6kpPbGyF2fhfdbBKTXzw=;
	b=nW/FTn7SVDc/YqsFJIvRy1idEsSRd1ToGbipsujfhOEpO/I65iEyf8dwXn7pEK6kVesA8A
	2ChFBNWQqu0TtK5gOJMyctMWEZVw2xHhGi4XH6GWtYLwMNPfvtQ8fVIOna06Ajl2lcoiwQ
	gZRR8abOqJZWXoLQ/RwHL5IEKKKKXZU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxMLcIyF;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772098090; a=rsa-sha256;
	cv=none;
	b=cKC1GpwvBNvWkCl/60zhaNQAg5JTmo14pvxLBvB9wC8eO0Bi297NYzW6li5msPPZc0yXc6
	maVpTEdAGOt94KZYvdVRN2otPrmrSTmJUbxGQxC6TsiH3nCiCc/w6xJa0B4p0dTWuCYyRX
	8ITgRaMx/rXelW2Rki6cdMg90sSnjM4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13AE742B0F;
	Thu, 26 Feb 2026 09:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B4CC19425;
	Thu, 26 Feb 2026 09:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772098088;
	bh=rgQOASaEYaTnnA/hyNxk7Xs4bJb1VJjlN0QqngKbpqc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bxMLcIyFw+HsCDeyhLytU64ia68W3qqqTiRWYJZwH3Mw5P62fDVb+xqcp7JewiW/Z
	 Uor+8JtA2/ngkAi57ddJwXAhNRwK4FnRiag2qcFeLFHohKGzNFOncPccbl3B4UwJzK
	 2I+Z/R8tCwdDRMeLr970Z5dyn0pBN2sjVG44pk7uATFzbMZ2CReu7KJsQ6Jjn17aNH
	 2c+tIrAOa7h+FuxfQy/lvM7FgaFebx94+9/DKQ4fuUNsN54v6YRz00a1PEOZKlSLwo
	 GhsgBSGsCRZCFNM7CQbuXcy3fNKZ9R7pkSENQS+SprmUecuAx3GKiFh7oPrk338gT2
	 7YPPx/HVe0jqg==
Message-ID: <7334b702-f6a0-4ccf-8ac6-8426a90d1846@kernel.org>
Date: Thu, 26 Feb 2026 10:27:54 +0100
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
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226012929.169479-2-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jnbzzfee6qe3gxphxmeoxydxei6om9at
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E12E180008
X-HE-Tag: 1772098089-254820
X-HE-Meta: U2FsdGVkX19t9q0IKv53h1yKKKVYT1DCdRRvFD63cHm/8IyFflhoNrgeAKIySs1lpyTpRls1CautymxNxVrKyokX2vGXz+XBH9c1TOxifFTLkFm1Fh1xxstie/CUFbudu6z3xpZbCNqCaaUK34avo1QkRbWAe7DjpXYoPROhvW6DPvoxK6Ayjo14Iv6Mhlhf7D319w87mo2mVfSYdIJ9zLifJ0pz6nuoHEPHSDyLtJib8+i52+9O6i9prgiQ7qLaWH9P8H00YBJy2zI0Vn0S+BA0qdAEpqXaOGv8q8a5EVOwu++J9E3MnA0HrfEIWuEZ9XGVIN6/jA8rKIjHaw1GoYUsV0QKrcMhJZVwbL3m9qNEpNQKWkP3FrfHcOwmeIb/b2LzZM78U9IarZpRr++CAo8GJsCuj1YAN/NRu+YTA6D/PVf94GgvfYkIxG91TAEDd9vmuat7x094iiQaHChNieOI3DaLi1D2sv8Bw0NLgM5PYNXwi5ekpsI3hwwiESRgyq/x9Jdm/DaQx0omABmX6n30A9WuE1n0PpJ9OgK4TUy9S7IfKWLilL1KOHG7twh/81vLdDyuQexY8GwzVE7ufYEplWbM7vYibBi8LFAD3PEU6siiUGwxXlj3GQ5v2kKEX4L0/9lGMGVnIAjB1rzau5mUciV0e5aM6U7MK5xq2Y+4DCbtlOFNUkMCKYH3wsdAZKEnT+5iNFFZtn6g2+bK+867ffOqCzTocQofofsKxielfz7V90a+6/mFAIjyOZAmK+eeXvI4Mgv8XZtaiYasLCiu4BIy+ng1W3K939i2Yha42ErpFfI41L/Ss+AvMhp5EkikK8bIhrPeM3X+NrbUCxpbzmxflMNKJexUZPq+fUdLhekQkVM0Wpp/N1/ESa52JTYT9RfVnRm+eThFbpzV579m95T1/xoipN+u41cB0afohV56lCoXpBlrmJAtIkMYu+iHWpxeMn+rvmyBt5H
 Vh9WtpK6
 0HltbIYw9Nd2dYmOqE8JDf6YDlNwipvM3Ef64bzF7a3OqfkX40y9za1J/OZ1zOjX5Ed47bEaLH5kukAKye3Jd6LWFDNU5rQHWSHPq5OJTjO9sGcT1qHfMPtESuf/hOtSs60Ba4McrCEEOfoAu0nb1eBQYUi/Tdvjcnl+syokL9Mj3COTwjulz9L4LM1xwIJzi4pRE9IJ7dl9tmuD61xlwzFSQpPYEXSlhwhuwQZvIc0TrBiiB/LFpCIYbDViNjha2rTGM3AWnEsI9JEfh4hyEBUBDtcPFaN6DhMTAqwaj89nx1kCNJhz3nR843V2pcr5z30t3qj84xMFHiRsKuhdKyU6zXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 02:29, Nico Pache wrote:
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

One thing:

You can also void passing in "nr_pages" here, especially when you query
the order below, and simply do

unsigned int order = folio_order(folio);

map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1U << order);
count_mthp_stat(order, MTHP_STAT_ANON_FAULT_ALLOC);


Apart from that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

