Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E762E78D44
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750376B0088; Mon,  9 Feb 2026 03:49:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE0C6B0089; Mon,  9 Feb 2026 03:49:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2266B008C; Mon,  9 Feb 2026 03:49:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA936B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:49:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDA41140756
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:49:47 +0000 (UTC)
X-FDA: 84424295214.01.A4716F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1318840006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:49:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TPEOF6/3";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770626986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGbTfLLZD/gDNQDsOqhyyqWwiZVtJ78GG3mOzthMJgA=;
	b=cxUp/eq5YgE6f0QisJh7fZwclqCGpA7hzN9PnVxB5F77Nq019oiAbMD4kY3Mn9N+kpT3An
	3jzIuOgt2OO9bwqPAJwcM2j16Xu041NAqA9/QLUcnsT2KxIx9jdcnZBMRGMpXODG9xVWdn
	n/++oAE2xILpW+4heE250/bk4ChNQl8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TPEOF6/3";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770626986; a=rsa-sha256;
	cv=none;
	b=OVOsxr+td7PpZjkSauiUVECdduw3dO4dI2IakyoRmoydYsP1RBm9yu6akGmYnkquPzF4fE
	JpgBxC+NwR2t4QuyC9yBrFOwy3GiTqoD8k2LzUAbHCaWjndvBXiYLGBQRHDN1THITdrA44
	+Vow7qOT4kg/ljhHSbtwWHjDNdjQ8hU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B7C34417D;
	Mon,  9 Feb 2026 08:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BD6C116C6;
	Mon,  9 Feb 2026 08:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770626984;
	bh=hrBXFznTwdWmXs1zvNu9iVueNufa6xnW3w+yF3Djn+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TPEOF6/3AguXyv7ybUXpRZLxt7s0hAp01KEaZscFtoVxo/QpUBu5lI2i5wOWi1+MD
	 y3U6cc2RGmkB9FSiI4B7hmHsp1IL8xT63Pn3YuyW2x/hpjWR6c8Qbq046qN3rjaO+s
	 1uyIAt1Y0cpjQIuZgNY8fK4XAb/2YVpFL8twI+jBtCyAjRVisoPkqfWFU1QYPTEsBd
	 xKRXkoZZ046rUR0KjiGG4xOhZjl7TGeSSUY4Hh7Fkfr9ZlzH8MFG7IVAclUG4qTJlT
	 QXbh0YG6qbH3Ohoxj4lT4SWHiIz0z9GBovH4Rc9J8C24vdVv4Vm4zfcyG8WJyWyjSG
	 4MX0jadpTq1tQ==
Message-ID: <3d5cb9a4-6604-4302-a110-3d8ff91baa56@kernel.org>
Date: Mon, 9 Feb 2026 09:49:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1318840006
X-Stat-Signature: 66yxh9u3oowxhm3zsdqcfgym3xw5feir
X-Rspam-User: 
X-HE-Tag: 1770626985-811769
X-HE-Meta: U2FsdGVkX19IUcUIbGeW6QaU1HHkOMv4yzsI3y0a4//65AL3oNXYi/Pgdhms+Ph3QMk5raFMhXP8tsoBTk6hxgdQrxj4797ju2F85aXArOMw5eeJum/ciOT66M8+UrDY1HXeP7Mr1ESrM5RyKJyskt1A/QVR4Tixk42yr5zNDWN1QR92JuPHTZA8ba8K3nW2ussKNIMsh4IsKpt/F98hwkXL4p+JIs9k77iPY1q2kKxYqk/tC61w09UIXmScEbEXknFfivl/PK6VyzwEXk/UeBkkWgXfkV/DnGBDxUlHG0XJ33OOCGcHXqymuXfpdWwfvAVNW8jVdPOeO8RaUADsEY4V9VTzYJIZXZ+JCWtQDxeRTQenBJrXMVF3NSgSxD4Q554A4tXT9DXIzbqcH6e9g+xL8MSY/s2HTtno7kQH/UqBDqbaoSMbUSmV4nvmGMuU8DXQmjByOA4LhYb3txo9qhvLwnAzXgOeizQrjXs2rJ+vVQk/NkXdsbwwkjDvCQTuJ3dZRI2w/aO34PLXpPXuwiB1XI84zQc7JzDoEleGg2+fRAFMGtV7emXhGr09RjQXpFA+POJTdk/fJFqxzDfJC6wU26DRodaX2TlU8JXjxYO/RHyHHXlzccdXmsSC+vjDWuXbYnyh76hYLifzDBKmiO4eha9NxPZ6t87I9qsgTKueLC7n5pYRdDIWs2KhRqSyIU/aNTTWsnNatazQq7S7yt4gRlboyFcZfFLDPns/jPTdZOigAB99s8Hh6sHLvW+by/hpZ/K6YkYdsKlpKWVPQYIWU28lmed3RLqa4eZgUhcMH2eNnKfm/7FPRwUkDuDxLd4pjogba0irBNBz7joDTolUVE0DdRQu+PGo9Iz4aYE39ZopvtpUYVs8CRxQTOdzjYLpD/W6HsuVbewDNwT63Flq0rUapQQKzMbI9a3yeEl9jeSaC1trF9BdwGgfyBHpTDi7OSRioEmATfFsw5u
 Ox6pfgBm
 /nBTo6ORpC0fL/jStoZlDeQoR1Mv2Dfft4fUtHPHyZi8fJdnIL+bhOJ4aFOBDQDLVbStGImjnCJwPRcChJdVfnlxDxJMytos/LtcdhZWbaorTvA2EgvkkYOXpIU5ZQnp6IgqZ77hvcXZUEoQrWj/D53NevidTlSKuFcQQ3HoOlfDH43X9q8Al4uXlUd3CPCA1xckpEIvywex4rsEsGjj+nk4/CQUehqVxvkoqdhg9Y8Bobh0ka7SXsM1zdpvgG3Dk9vPvh8VtJHq8psklYB65zZINNjHeG67kXjOcdlCPRx6KuDNvGyyBSHSeGNn3tq9BmFnW5WjFWxlPr+ayd5UoHrQ2XkvWaK+6si4Sy2qAbgDqrtIgy3rX/oMGtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/26/25 07:07, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
> of the young flags and flushing TLB entries, thereby improving performance
> during large folio reclamation. And it will be overridden by the architecture
> that implements a more efficient batch operation in the following patches.
> 
> While we are at it, rename ptep_clear_flush_young_notify() to
> clear_flush_young_ptes_notify() to indicate that this is a batch operation.
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   include/linux/mmu_notifier.h |  9 +++++----
>   include/linux/pgtable.h      | 31 +++++++++++++++++++++++++++++++
>   mm/rmap.c                    | 31 ++++++++++++++++++++++++++++---
>   3 files changed, 64 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d1094c2d5fb6..07a2bbaf86e9 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>   	range->owner = owner;
>   }
>   
> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)	\
>   ({									\
>   	int __young;							\
>   	struct vm_area_struct *___vma = __vma;				\
>   	unsigned long ___address = __address;				\
> -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
> +	unsigned int ___nr = __nr;					\
> +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>   	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>   						  ___address,		\
>   						  ___address +		\
> -							PAGE_SIZE);	\
> +						  ___nr * PAGE_SIZE);	\
>   	__young;							\
>   })
>   

Man that's ugly, Not your fault, but can this possibly be turned into an 
inline function in a follow-up patch.

[...]

>   
> +#ifndef clear_flush_young_ptes
> +/**
> + * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
> + *			    that map consecutive pages of the same folio.

With clear_young_dirty_ptes() description in mind, this should probably 
be "Mark PTEs that map consecutive pages of the same folio as clean and 
flush the TLB" ?

> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @nr: Number of entries to clear access bit.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a simple
> + * loop over ptep_clear_flush_young().
> + *
> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
> + * some PTEs might be write-protected.
> + *
> + * Context: The caller holds the page table lock.  The PTEs map consecutive
> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
> + */
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)

Two-tab alignment on second+ line like all similar functions here.

> +{
> +	int i, young = 0;
> +
> +	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
> +		young |= ptep_clear_flush_young(vma, addr, ptep);
> +

Why don't we use a similar loop we use in clear_young_dirty_ptes() or 
clear_full_ptes() etc? It's not only consistent but also optimizes out 
the first check for nr.


for (;;) {
	young |= ptep_clear_flush_young(vma, addr, ptep);
	if (--nr == 0)
		break;
	ptep++;
	addr += PAGE_SIZE;
}

> +	return young;
> +}
> +#endif
> +
>   /*
>    * On some architectures hardware does not set page access bit when accessing
>    * memory page, it is responsibility of software setting this bit. It brings
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e805ddc5a27b..985ab0b085ba 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -828,9 +828,11 @@ static bool folio_referenced_one(struct folio *folio,
>   	struct folio_referenced_arg *pra = arg;
>   	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>   	int ptes = 0, referenced = 0;
> +	unsigned int nr;
>   
>   	while (page_vma_mapped_walk(&pvmw)) {
>   		address = pvmw.address;
> +		nr = 1;
>   
>   		if (vma->vm_flags & VM_LOCKED) {
>   			ptes++;
> @@ -875,9 +877,24 @@ static bool folio_referenced_one(struct folio *folio,
>   			if (lru_gen_look_around(&pvmw))
>   				referenced++;
>   		} else if (pvmw.pte) {
> -			if (ptep_clear_flush_young_notify(vma, address,
> -						pvmw.pte))
> +			if (folio_test_large(folio)) {
> +				unsigned long end_addr =
> +					pmd_addr_end(address, vma->vm_end);
> +				unsigned int max_nr =
> +					(end_addr - address) >> PAGE_SHIFT;

Good news: you can both fit into a single line as we are allowed to 
exceed 80c if it aids readability.

> +				pte_t pteval = ptep_get(pvmw.pte);
> +
> +				nr = folio_pte_batch(folio, pvmw.pte,
> +						     pteval, max_nr);
> +			}
> +
> +			ptes += nr;

I'm not sure about whether we should mess with the "ptes" variable that 
is so far only used for VM_LOCKED vmas. See below, maybe we can just 
avoid that.

> +			if (clear_flush_young_ptes_notify(vma, address,
> +						pvmw.pte, nr))

Could maybe fit that into a single line as well, whatever you prefer.

>   				referenced++;
> +			/* Skip the batched PTEs */
> +			pvmw.pte += nr - 1;
> +			pvmw.address += (nr - 1) * PAGE_SIZE;
>   		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>   			if (pmdp_clear_flush_young_notify(vma, address,
>   						pvmw.pmd))
> @@ -887,7 +904,15 @@ static bool folio_referenced_one(struct folio *folio,
>   			WARN_ON_ONCE(1);
>   		}
>   
> -		pra->mapcount--;
> +		pra->mapcount -= nr;
> +		/*
> +		 * If we are sure that we batched the entire folio,
> +		 * we can just optimize and stop right here.
> +		 */
> +		if (ptes == pvmw.nr_pages) {
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;
> +		}
Why not check for !pra->mapcount? Then you can also drop the comment, 
because it's exactly the same thing we check after the loop to indicate 
what to return to the caller.

And you will not have to mess with the "ptes" variable?



Only minor stuff.

-- 
Cheers,

David

