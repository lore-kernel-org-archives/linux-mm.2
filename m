Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0174BFCE069
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B356B0095; Thu, 26 Feb 2026 07:37:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2280E6B0098; Thu, 26 Feb 2026 07:37:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154F26B009E; Thu, 26 Feb 2026 07:37:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04DAE6B0095
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:37:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C389DC3AAE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:37:56 +0000 (UTC)
X-FDA: 84486559752.16.344495A
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id E50844000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:37:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGpr3FmI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772109475; a=rsa-sha256;
	cv=none;
	b=OUes7e4tMrhX80bOHvjcOpW0K2nNgHoYe3vRReu0ozbsi0USdQM1RGF34qHjz61zUVosGl
	+p8w56g7VYsyqPBXY/j3todomZDg1+SUt4Ityye1SCo61+ySrH8FYBL7gkjTD+/lGDpfmZ
	tlRmdnYuwHWnWXdSvhW6POWbFGP6fig=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGpr3FmI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772109475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPNsJJopwXeIQajTPzQOqmwoq99q8dZhkvlRtgNDvjs=;
	b=1etzxRnV3gQL2qJU8odmmUADX9PnsA7h1JLlTv4btAb44VQy1Uf69MM3Q9AOqTqibyGdis
	HptE6ReIJQmMxWWK169Krwr08ijtNz5lnLXjfAZwedCrWTUfGtTilDhXz34S6ztZcbTqpS
	huLmJ4OkdZ3ux8rW2DMz26FaaXlUxiw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772109473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPNsJJopwXeIQajTPzQOqmwoq99q8dZhkvlRtgNDvjs=;
	b=DGpr3FmInTfsEa7ak4gaWrS03UTVFfbW9HJv0UQy+RlyTfuJR6/UpOsr9dyf+aH2kO7T66
	+YmOMY44vxffMh/T02Q+dbb3ocIUW7Avb2n+bBA1V0DkTzFeB5kQot0jlV8roM9f/AtXFx
	b2MxQG9FNaKVyeDXagSTpEApubu7kf4=
From: Usama Arif <usama.arif@linux.dev>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC V1 10/16] arm64/mm: Route all pgtable writes via ptdesc_set()
Date: Thu, 26 Feb 2026 04:37:45 -0800
Message-ID: <20260226123747.801496-1-usama.arif@linux.dev>
In-Reply-To: <20260224051153.3150613-11-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6p86ekwbm961nf95tk9h4fxiw4yo1nqm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E50844000A
X-HE-Tag: 1772109474-408928
X-HE-Meta: U2FsdGVkX1+4XAVa9P5eiAYM0wBQzOx0N/LCPZW5ledeM9FIiENpwv47HFIv1UcJv8KD2I7fRQJC8JooDX2RB7wdfmShJZSy/xbhJw3C9yvNpWbV9NyGmFEyt6SR4yhK39LSbmE/O5tXmBPTNcbeeXhGKGhfXdDK3ZEHDDA3nQxoLe3vg0GmwfpvD+J818Ifu55bz5bL3XjvLvUT74RNpWHGExCPc8q9YTc+QpMAmjyBBuHqOXjPD84oUz3Gx3cNRqZz5RBiU5Y/L7H/NlRifjEl6M996b7xbMDm+okcAJHUhZC0kH984Yk8LdI6ZOFubXvDRXep6Mw0tfti3vWyDAW5VX9ptGT1RMYO2VSzsrTkO9SxJzT5fFs2qYOeLtB/2R80pQNEorCTwmt7m6L5fMrJ5P8DCE2etHFMYezmeaIrthq4GD1rFAx2qboQCXc0GvI3X4yPp9f6e+JV6uorx1Sd6Uy/TyFiIcDMOgyApvv9DE140Z3e3zL6n813WkMjlRWY9K7HthSEYqCss5d3mypxQ4sC9aYdWptlo1Hu/mEcun3UdPztjpjz1v9jg0tjY79t4U7Igu3mPPOadPqjCq2ll2GHabZ4gLxi9F5AR+n3rgtaiocnsN4HM2f7F4ppnEZT45VipMiDg0X8rQ8A7SkZGOumlIqMoWQKYIHQXSBzNiYQBXppkQfTMGSAfgByDC14vj5DSvxMmPT5cY//jBqDpjlDcM/L6pUJNzdGfHo686/oFQ3qGaMWrlAw2mI9dIGUagqY1pillbsDmFMx1F7a41+/vAC2xOPyeJAjOegFLCrtYtxjvelA6XwsasToCYAls2vIdCMM3cd4pIgsIxcRMiON4W/GNZTg7lE+4qrMkMM0s3aPmqs3glQNsKLxb1hTm6H8jlX7HZJ5HP76G+Gf+ipFUubeE9uJzt0n5b8z88rCggWn5Dfy2DfkPzIE/jHKfH6ORIZpAaFGd4J
 ++8dAFrq
 MXY9i3mewEFuSwcYXWz8/FiQ5s2zxkxoJgnzvRAjmvIsuONBTh7Lvn6TVtFDVOAXmFnPyHSfEpSgre8xQzrcjm9oCZWC69F7KutFpvDWDQsexfO49usywZIWELwJDWngjNpLeXkowOs1bHZYZDrTg5gBh7+RZE6zh52h31JJTVmngYG7nMJ6rM9eAm2WQX7aascGJGhlnJXSAKEPp7X+ff9WBL2XK3oZDVKlB3Eq2bADfPjJPdEJzejfBH/L04lv4+9bCXmea1V+03XvGuYkSSeMXCcygKg3out0zQLK2ivy8CQfu3PoGfl0O4Ub0DSA0KYvMXyLOcoB0/XyEMrP2OLd43NqUh6D1GlYUErwXGJERTVMNDIb0Ur/VRqFRDMJPm3mG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 10:41:47 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Currently ptdesc_set() is defined as WRITE_ONCE() but this will change for
> D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
> copy atomicity.
> 
> In future this infrastructure can be used for D128 to maintain single copy
> atomicity semantics with inline asm blocks.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 11 ++++++-----
>  arch/arm64/mm/mmu.c              |  4 ++--
>  mm/debug_vm_pgtable.c            |  4 ++--
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 804ef49aea88..42124d2f323d 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  }
>  
>  #define ptdesc_get(x)		READ_ONCE(x)
> +#define ptdesc_set(x, val)	WRITE_ONCE(x, val)
>  
>  #define pmdp_get pmdp_get
>  static inline pmd_t pmdp_get(pmd_t *pmdp)
> @@ -389,7 +390,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
>  
>  static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	ptdesc_set(*ptep, pte);
>  }
>  
>  static inline void __set_pte_complete(pte_t pte)
> @@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
>  	}
>  #endif /* __PAGETABLE_PMD_FOLDED */
>  
> -	WRITE_ONCE(*pmdp, pmd);
> +	ptdesc_set(*pmdp, pmd);
>  
>  	if (pmd_valid(pmd))
>  		queue_pte_barriers();
> @@ -917,7 +918,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
>  		return;
>  	}
>  
> -	WRITE_ONCE(*pudp, pud);
> +	ptdesc_set(*pudp, pud);
>  
>  	if (pud_valid(pud))
>  		queue_pte_barriers();
> @@ -999,7 +1000,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
>  		return;
>  	}
>  
> -	WRITE_ONCE(*p4dp, p4d);
> +	ptdesc_set(*p4dp, p4d);
>  	queue_pte_barriers();
>  }
>  
> @@ -1120,7 +1121,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
>  		return;
>  	}
>  
> -	WRITE_ONCE(*pgdp, pgd);
> +	ptdesc_set(*pgdp, pgd);
>  	queue_pte_barriers();
>  }
>  
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index bcf32d1a92de..ffd307c546f5 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -83,7 +83,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>  	 * writable in the kernel mapping.
>  	 */
>  	if (rodata_is_rw) {
> -		WRITE_ONCE(*pgdp, pgd);
> +		ptdesc_set(*pgdp, pgd);
>  		dsb(ishst);
>  		isb();
>  		return;
> @@ -91,7 +91,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>  
>  	spin_lock(&swapper_pgdir_lock);
>  	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
> -	WRITE_ONCE(*fixmap_pgdp, pgd);
> +	ptdesc_set(*fixmap_pgdp, pgd);
>  	/*
>  	 * We need dsb(ishst) here to ensure the page-table-walker sees
>  	 * our new entry before set_p?d() returns. The fixmap's
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 83cf07269f13..faf6a19a89a1 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
>  	 * X86 defined pmd_set_huge() verifies that the given
>  	 * PMD is not a populated non-leaf entry.
>  	 */
> -	WRITE_ONCE(*args->pmdp, __pmd(0));
> +	ptdesc_set(*args->pmdp, __pmd(0));

The ptdesc_set() and ptdesc_get() macros are defined in
arch/arm64/include/asm/pgtable.h and are arm64-specific. This change is
in mm/debug_vm_pgtable.c which is generic code compiled for all
architectures. Other architectures do not define ptdesc_set(), so this
will would cause a build failure on other architectures..

>  	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
>  	WARN_ON(!pmd_clear_huge(args->pmdp));
>  	pmd = pmdp_get(args->pmdp);
> @@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
>  	 * X86 defined pud_set_huge() verifies that the given
>  	 * PUD is not a populated non-leaf entry.
>  	 */
> -	WRITE_ONCE(*args->pudp, __pud(0));
> +	ptdesc_set(*args->pudp, __pud(0));
>  	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
>  	WARN_ON(!pud_clear_huge(args->pudp));
>  	pud = pudp_get(args->pudp);
> -- 
> 2.43.0
> 
> 

