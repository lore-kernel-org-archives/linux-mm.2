Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0C8C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33946B0093; Sun,  2 Aug 2026 12:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A926B0095; Sun,  2 Aug 2026 12:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF96E6B0096; Sun,  2 Aug 2026 12:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE7B6B0093
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:14:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EAB01204BB
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:14:07 +0000 (UTC)
X-FDA: 85056826134.18.2E8B5B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D7268000C
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:14:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhufBt+1;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785687245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOgh6AwBFUfLjYfZK93RPZ07a6OmymGwQZcUl0F0LPo=;
	b=VxTPJlqXqlCHzNr42S7eIh1phlxfIFl3OcVtS/FXIV2lfdL81uGc/EkMiJjpGW6sxIJXjp
	3te5nxea8w+3x6YwUHj0WRYHzi6/lnDl4WRplK9YfYskc0m5Vlh9CJsCnlCPbF37KNSd3y
	N9RRzdFKwCd1pC+WG1webPbgyExjO+w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhufBt+1;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785687245;
	b=LDsHN6Pxa9zFAXafKA8Z/xcRTvGxq/w8pcWWw0zGhkbgYfnULpznz9gbKAxibR0AtBIGiU
	4fHPiDS379MvHQlifwARsfMVmKUL9ZynDBZbTJUdL3akmib8kDCZPOhWha2E2mk337Tk78
	4+3TNSQSlp4ZfeeOh8uLzuB2+SKgPWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73E5843F86;
	Sun,  2 Aug 2026 16:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386C91F000E9;
	Sun,  2 Aug 2026 16:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785687244;
	bh=iOgh6AwBFUfLjYfZK93RPZ07a6OmymGwQZcUl0F0LPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lhufBt+1XNJzEcjIqIcJ+1N2abIk1ly1qIIe43EMZFBn1onbJT+yEvwkapRDQeGPm
	 YDtFviqqr0u03loYYqQ3lFbBsJyCTb2JQl71Jilnftn1xwZPAR1L+7DMrncNuSBIAa
	 ZLDvpvErdwINXBNW/GavrD9Qv/Eos7oU5SbO7JOsUlZc0r+6ETUIiCznKXqO6yRCd5
	 S+haPKqdJjpl7ptpbg6xhxN55C7XCZDcyvm6cD47/Z++SOmxVqAbYMQSbNl+FB33w7
	 wBWAdhVf4W1r9YWJ66jqbZlv1u7v55M6neWNkaIALfw23TgZyp4zEcDkPcyjPWo3wl
	 c6zW3LnrZvwOA==
Date: Sun, 2 Aug 2026 19:13:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>, rientjes@google.com,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Patrick Bellasi <derkling@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 04/26] x86/mm: split out preallocate_sub_pgd()
Message-ID: <am9sw9dnbYLegAfY@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D7268000C
X-Rspamd-Server: rspam01
X-Stat-Signature: 5itowef37u4t3wbky5ugo8o864rf1jns
X-HE-Tag: 1785687245-700088
X-HE-Meta: U2FsdGVkX18c81wUakuC+QV+4Mj4j+/0g3AjUTfD/8NttH/pTsQ78NMcIp7v0YuHfU+YMBd9kngwXE10j22qpLgWVwCtKCkWcPGcazZnBbgln+kuRn+Pab+70ZGGbKKxMtxyMaY4TSz/EGLHDNHJ9SGK5yWw+GsgfX4/egsYh+RJOfSXr3VTm1N9DCMfENWTiAF3BreU2LNGkMwnrskpZ8xMIIk24FSA6nfQbZ1twyz2btI54K5mHxazJo7NgQEULbd1AwZzFsXFL919pOVB55qb99wLRVnITRorGiB4gbPSCKaGpkia5XOABg0klKdILvkx2vHC1+psMD+tU0pZfmEUmL75BPjfzG1zlaXbBcW9u/sEKdxo9UZ/IPPUwp9sxM5iZUhFio0MDbhSxUQypdprI5OWbw3rwyNzgRC3cKtzElrw712uSkYSupSVlFBYByFBFlXo8D3sZ1gP9p3/tUk3P1wrmEmG2bPAuOVBR/t2OOZEj3DRvQUV2tDwaYj3ALgPrEXaCMtavmX/o7ELojRS5FMW+P6xg+US1SpYhT6fMLPzxh+G8huOHNtG8AOGmr8TWW1y9uXhiLa04fkfn4i+tkLzqKXlB9fEUVemFlSiFYwxRZnNCOMQc7DYwnuBZL7aw805K4VryM4J6iOZQnaDgr5CfhOJI/or2eN2xjy/gxJjx4PrsJLmT17yOOO1Y2O4RBbZUHoTx0w8a0Va0bgKmVYJ8XABDn/PuxRY+AOyh78jCehlat2PYx2/Wsz7YbwO9l37nTEgviC58jdJqOR9xEvApWEwLyFkTrpexfxtjEV7DPO49qJYJ+ZPrh+nZBFLzDvn0hbNEAWCMiZ2SruPwL1/cPBtLUsw+6um3fp/Euk559xh9Apxh7SOnBOnDmIT4A/R+4Dyw+XovKPMOTr9xgRUqR2f4ZOVT2VWbUJyKE2q27wOLl84kcjaK63riBTYrU8cxcJYgjZZlx2
 8Gw+TW8f
 XEj+z93OI3C9WbMmoCMxlqmnP6OOQqRjJWHXqV9kv3w5utothA2v6wYekMcu/SICZkZ0JXn93pVQvmXh3UWlCpAJVp1dO9fLIJ5XPFOPLz+vfr5zg9BoOWX2ObALibsmsf9IFeC2qKiuEnrZwW01V9o17ToIeFVv//6oDpexzdO3Cs+HeRWSBJb/pGGZOao/nGELRHcul3LcH6u9VFeP9CbJ8Z+CalX7IG4KIRB/lk93SLnD06rbcQEacXSEIYu6hxFhfrDXKCpc3XufcVpyRo6sgiP17YHSTe4ItvuyiR6La0IamV9kN7vXU4m6l0DVO6BO985Nhqo+oZfOyIpiS8wWjIYmMyYbGfh3tA6os3DaVwpk=
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

I think this should go to arch/x86/mm/pgtable.c. pgalloc.h does not need
printk symbols.

>  #include <linux/threads.h>
>  #include <linux/mm.h>		/* for struct page */
>  #include <linux/pagemap.h>
> @@ -128,6 +129,8 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
>  	___pud_free_tlb(tlb, pud);
>  }
>  
> +extern int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr);
> +
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
> diff --git a/arch/x86/mm/pgtable.c b/
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
> + * top hardware level. In other words, allocate a p4d on 5-level or a
> + * pud on 4-level.
> + */
> +int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr)
> +{
> +	const char *lvl;
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
> +	return -ENOMEM;
> +}
> +#endif
> 
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

