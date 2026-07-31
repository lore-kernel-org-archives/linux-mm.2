Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE802C55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 22:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0576B0096; Fri, 31 Jul 2026 18:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA15A6B0098; Fri, 31 Jul 2026 18:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA3F6B0099; Fri, 31 Jul 2026 18:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 956BE6B0096
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:10:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05AE51A01BE
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:10:33 +0000 (UTC)
X-FDA: 85050466746.02.0466B8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DBA380006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:10:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SgtmVEXM;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785535831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcMHynopxq0LB8O3aiZw02VpzCo3iMp78znRKkfrp3w=;
	b=3L3LV9XhQFHq5kZtTbEyMsg0pSrCXHE4c5gNrHjJi9TXdydaorCL2z04XA7KwS/1oYE+bp
	k7WIqwib+68AtBMlwf/Uz9RxBvkGH/wNR1rWWKX1ZOm1H1XjS59RxWcP5112VS/cKkTjeD
	bU67JoHs4ecPOwd9Q95+XB6ej6Rhekk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785535831;
	b=vaRsJqFkZtIgV2q8FiNH7uLRkZB1huZqu//4PQQ3xHQtoDCt8o5a+WSkDNt1JvU8tdujUj
	6XCqo9l4PGq1MABQ0zHwxCAq9FmlEprY89giKCnu8bSuGWQ55B2wGf360r1ZekYJ3kptKU
	6iXf8K8WIbspTcwq3i5D2DzyC6r4jI0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SgtmVEXM;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8539E406FB;
	Fri, 31 Jul 2026 22:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701381F00ACF;
	Fri, 31 Jul 2026 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535829;
	bh=KcMHynopxq0LB8O3aiZw02VpzCo3iMp78znRKkfrp3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SgtmVEXMK+BaM0dDhNotsFBU1VNhPZ/5ykE3Gou3coxHECMuyL0PwNTOMkWSJ+eos
	 ttqAFupqL1YevTA8JWZ1LdUYx09hwpFTjKg6odUNrzXnUuGGnfZe/jcT0ftoOrQWWk
	 NC/HHmeoV1H+SU0ZzDGwPDDcico8eKzwfpTFqVSIJSAe7ayrSuUaIwcwHLEc58zifl
	 pLOMRPpUiWTD0FdUwOD7qLD9qkhj+fbbQXaOODFBHzW0Z1sIdeaBy0+s0a5bH6YMve
	 VYvBCt8UN4Bai7CfvxLY3gh0ZFquzAmbwVoWcH8c/weg0aVgYsM3EJIU7ZRImkUpuN
	 H4oJtNNK8ztQA==
Date: Fri, 31 Jul 2026 22:10:27 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 04/26] x86/mm: split out preallocate_sub_pgd()
Message-ID: <am0aplxsh1b16Rch@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DBA380006
X-Stat-Signature: niowz9srqg9k66dch55aqwn8nimcdj8s
X-HE-Tag: 1785535831-738188
X-HE-Meta: U2FsdGVkX1/AXZEVLGexa5NZn0JLCjpjM9jM+K3M72SnoVRufpxOaWCtZfl/vhihMbzGTiFJIyWb1MJFcsaMsscaPXxB2wZ2VIdsEJZgf9SHk9aP2h8UoG694GXPU94Srod6FKaLhLHEPpFysWEcObFiC6pJ8lwAOV9BTb2bXE2EYVJ/5xY0cDiU4cMTKS0qJIby0WnbK6ln3N/MVKaUfD4n5hZM4SgLzJSnS1h1V93gevgb9g/Lpue8SFhBxXBIrfZUsL5I8OnL5saNcDeRifaW9nTvvEP+Xo82fzzp5XtlHjPnb7E3kEvTSH2fPEe31NfjXe4pQftrDShFNL9XT+NrpIkFfZoVPtva21FN7TNuCUPCueC9LaXJv2UkZaZdNCzf2wqG4SKHzJShxa04zs4HEDR79po4CyBxVbhuLO4VgeMq9EQg6rIc0Wf+S1WjldanncY2vGFKJTEl4Gh4PYl9M78g2y2mFzmJ25pyISqFEeWdruusck0oId9p4TDozw4NkYePl8jkpz0Zkc3q43ooUPxG6UUT5mlzh2InG8XjOaXdddTySda1zwaB3vYDnQ3syhSaOrao9XG3lJyPnmN9GRy6omgSmzHVh3qnmvsFIJj6cXTHlCzzZ9M3c14ajO3gbeo6sobXIcC5zxYW3X7jF2VOx7PR29x4VjQeXxYyiKJrdRufVdkpkrGPamLtK5LtqmMmTgD060RZqNqtQWgrYXqMdr1STLq0W9JG0mB6SVvRoqiD9bOYJBK3MD1Jmx0hwypZStuB8gZAcr1JgEdqKsjqDikGeBaG03OooOMZngeEhLgtF686XRih2bPt2t+GIt0u8NqlbSiezMPCgxeD61FXSQ1F4jqmOPURJjVpEDy8Dko5hBcFPpNd9mzlnVk2iXubmJxSJo+AkowjWg5ncykoXXvPqPNilKKHmSEBl3V6Jn0HrXKAGRd6SZv0jc6bF8etoJExiM7v4/p
 lN6KAr//
 JhXOmpYQ2bvrjSMjeX5HrsdtNHPfWQmNtNyfFxmuJpq+urFWu5Np0Yd80YiW7kXEwtXKNt+FbMxDAkO1WizKNTXvhjGW23z6yczdhskRewxNbt4MgFXeQbADGNbWFpOAZJTYGB8nYiDTPJWRLHHH4OyO3PFRB8iJUYXsxPj42i6kvfxOJk1OtiNWpWBC2/vmRECqIZewKjM1M9yxOZ28ouwgPe5315qepaI1XMVMDrPO09c6scS1q54qw24cLv2eFAN7s1taR2uh1HZhCvOdYr3a5OIwb7dfdPW7Sw+UdDMGQiCi+a0ik42K1+eSofmPJWWfVNRdyo/pKUvfobPdkvIf1Pw4yAOWpmOauZP8tydiWDJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:37PM +0000, Brendan Jackman wrote:
> This code will be needed elsewhere in a following patch. Split out the
> trivial code move for easy review.
> 
> As a side effect, change the logging slightly: instead of directly
> reporting the level of the failure in panic(), show a generic panic
> message, will be preceded by a separate warn that reports the level of
> the failure. This is a simple way to have this helper suit the needs of
> its new user as well as the existing one.
> 
> Other than logging, no functional change intended.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  arch/x86/include/asm/pgalloc.h |  3 +++
>  arch/x86/mm/init_64.c          | 44 +++++++-----------------------------------
>  arch/x86/mm/pgtable.c          | 38 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
> index c88691b15f3c6..2aba6cfabf495 100644
> --- a/arch/x86/include/asm/pgalloc.h
> +++ b/arch/x86/include/asm/pgalloc.h
> @@ -2,6 +2,7 @@
>  #ifndef _ASM_X86_PGALLOC_H
>  #define _ASM_X86_PGALLOC_H
>  
> +#include <linux/printk.h>
>  #include <linux/threads.h>
>  #include <linux/mm.h>		/* for struct page */
>  #include <linux/pagemap.h>
> @@ -128,6 +129,8 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
>  	___pud_free_tlb(tlb, pud);
>  }
>  
> +extern int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr);
> +

Do we need extern here?

>  #if CONFIG_PGTABLE_LEVELS > 4
>  static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, p4d_t *p4d)
>  {
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index ab4c5a02326f7..ac6688c70872e 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1293,46 +1293,16 @@ static struct kcore_list kcore_vsyscall;
>  static void __init preallocate_vmalloc_pages(void)
>  {
>  	unsigned long addr;
> -	const char *lvl;
>  
>  	for (addr = VMALLOC_START; addr <= VMEMORY_END; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
> -		pgd_t *pgd = pgd_offset_k(addr);
> -		p4d_t *p4d;
> -		pud_t *pud;
> -
> -		lvl = "p4d";
> -		p4d = p4d_alloc(&init_mm, pgd, addr);
> -		if (!p4d)
> -			goto failed;
> -
> -		if (pgtable_l5_enabled())
> -			continue;
> -
> -		/*
> -		 * The goal here is to allocate all possibly required
> -		 * hardware page tables pointed to by the top hardware
> -		 * level.
> -		 *
> -		 * On 4-level systems, the P4D layer is folded away and
> -		 * the above code does no preallocation.  Below, go down
> -		 * to the pud _software_ level to ensure the second
> -		 * hardware level is allocated on 4-level systems too.
> -		 */
> -		lvl = "pud";
> -		pud = pud_alloc(&init_mm, p4d, addr);
> -		if (!pud)
> -			goto failed;
> +		if (preallocate_sub_pgd(&init_mm, addr)) {
> +			/*
> +			 * The pages have to be there now or they will be
> +			 * missing in process page-tables later.
> +			 */
> +			panic("Failed to pre-allocate pagetables for vmalloc area\n");
> +		}

Nit: We can probably move this comment above the if block, and drop the
curly braces:

		/*
		 * The pages have to be there now or they will be missing in
		 * process page-tables later.
		 */
		 if (preallocate_sub_pgd(&init_mm, addr))
		 	panic("Failed to pre-allocate pagetables for vmalloc area\n");

>  	}
> -
> -	return;
> -
> -failed:
> -
> -	/*
> -	 * The pages have to be there now or they will be missing in
> -	 * process page-tables later.
> -	 */
> -	panic("Failed to pre-allocate %s pages for vmalloc area\n", lvl);
>  }
>  
>  void __init arch_mm_preinit(void)
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index f32facdb30354..fdd3709509946 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -833,3 +833,41 @@ void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
>  	/* See note in arch_check_zapped_pte() */
>  	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
>  }
> +
> +#if CONFIG_PGTABLE_LEVELS > 3
> +/*
> + * Allocate all possibly required hardware page tables pointed to ths

								     ^the

> + * top hardware level. In other words, allocate a p4d on 5-level or a

   					  allocate p4ds?
> + * pud on 4-level.

      puds?

> + */
> +int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr)
> +{
> +	const char *lvl;

Nit:

	const char *lvl = "p4d";

or:

	const char *lvl = pgtable_l5_enabled() ? "p4d" : "pud";

But I am wondering how important this information is here?

We should be able to tell whether 5-level paging is enabled based on
kernel config and command line. If the information is generally not easy
to get, maybe logging it during boot would generally be useful?

Anyway, if we drop lvl here we can drop the gotos, which would be nice.

> +	p4d_t *p4d;
> +	pud_t *pud;
> +
> +	lvl = "p4d";
> +	p4d = p4d_alloc(mm, pgd_offset_pgd(mm->pgd, addr), addr);
> +	if (!p4d)
> +		goto failed;
> +
> +	if (pgtable_l5_enabled())
> +		return 0;
> +
> +	/*
> +	 * On 4-level systems, the P4D layer is folded away and
> +	 * the above code does no preallocation.  Below, go down
> +	 * to the pud _software_ level to ensure the second
> +	 * hardware level is allocated on 4-level systems too.
> +	 */
> +	lvl = "pud";
> +	pud = pud_alloc(mm, p4d, addr);
> +	if (!pud)
> +		goto failed;
> +	return 0;
> +
> +failed:
> +	pr_warn_ratelimited("Failed to preallocate %s\n", lvl);

Can this possibly fire more than once? IIUC we will panic right after
returning.

> +	return -ENOMEM;
> +}
> +#endif
> 
> -- 
> 2.54.0
> 

