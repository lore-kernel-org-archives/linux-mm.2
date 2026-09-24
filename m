Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0374CC98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2F16B008A; Thu, 24 Sep 2026 08:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B641A6B008C; Thu, 24 Sep 2026 08:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79616B0092; Thu, 24 Sep 2026 08:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E01C6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:10:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C68514010C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:10:03 +0000 (UTC)
X-FDA: 85248537486.26.23C689A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 058CA18000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:10:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nd9Gvt1q;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790251801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJX5S1IwKilV3DfdwUxuBjqWs787yTdnHdN08roC5wI=;
	b=wPQVJMg8Mxv7N1pb8mQrOB30isg4L7rRK/o2luxII+PnFfxCRm5FkX2Ebd8mG/3LtoXf2o
	tTuaOv5LGOCvRaApZwvrHvSqLx05XdvEW3BbohdKYFhvHMZzMgy5Ctztvw1Znash+jKFQ5
	YdzgFCEOdOU2r5dQFvzd2QlNYhR257c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nd9Gvt1q;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790251801;
	b=RxQXe9HI9yB5pWpQU6qXkJFvswh9BUaMD/M7PutK0b1Jhs8LTeX76avisxkfD93CE4GOJM
	yVFn3S2pW/OTnqzvBDuOfIYXIcUs81dURsyZuvKQ4lxx1urUunDfj1Khqu9r1sxBiBHED5
	NofX1UHLKg9/VGx4Cg7Srja9VEpJtCQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6940A152B;
	Thu, 24 Sep 2026 05:09:56 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AB5D3F86C;
	Thu, 24 Sep 2026 05:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790251799; bh=zb3BlFOPcL0srDUMglcVnm0Omt3MH1OzPB+fgFYjBFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nd9Gvt1qKcpnsc06Gjc+2CD1SNy3cD4To54NY8qil+5DrPmWmULRuTBpzh/zGK1yu
	 rVuKH+uU2mLSs/4M1tFh2Y6ZoZ1KA303+qctE0QLw8ommwu02QKio/26ZzRIL0AofH
	 +OO2lduMz1qH9fvguQf92AJQnwUW3OdkFRvLMmc8=
Message-ID: <0944f74c-847a-41a7-bd8f-db9f8dd0fe80@arm.com>
Date: Thu, 24 Sep 2026 13:09:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/4] arm64/mm: Use pmdp_get() for PMD accesses
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
 <20260924062214.1635078-2-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260924062214.1635078-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f4t6bqdbyikzioicxf5w8wjknghx1g7b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 058CA18000B
X-HE-Tag: 1790251800-20795
X-HE-Meta: U2FsdGVkX1+MZ8+Y3E9uRNMErdSZ/CXk8SeOjWYPWrWWUH4mLi2vzI4N0x32nU6Pn4ocPdIgipbXRGOczJOGI6phdlbBtdf9UU3Thli8Ds3l9IxvGE3rahGqQpa4Yq6OY3KXbgivFnEYd1rL/h2Z7tB7iptntzWaZxIFN8xsGEqCdPyiB7xYetUhEC+KGs2Qn4Ezgz+fIk7mR+amklP7hVWAPMhSD7FvUKzABEfGl5tkuuNhGdoUNjzXyYHQS492JrIiY8nCxU28Xx0HNDjy+pOcxiAkXL+cRUU5K55qaTTrCj+GCLPp13VHiRBpNdNewJVdkEo5TSLjWGis+0MSY2EKizEPYocOGyarKAXew3o3Kn40kutzfu6URL3gsv01VzqwLPTeni1tFQP8X9YjiWGAPAkk7bGLWH1VqaW3RQLkRGlHeRxYoCVc6FI7vdSJm9R6sTLoldcS0/BcvkaCUpda2h//2l2Re+QycY5MyOc/yHXxgHwsPQJ2M9c3q9fDGi1SEnN2Fj7hYiwRq66UlRk8wEY5UiBf5ezHkwSqhvRCwl5gP4Aac0Yc1tgTZ/yIEqN2b7pPkH/ShL50U/mQtyXiM3DxHPN/YP/js80utOAyiwKVjS60VXaq9dfZUTMUaMUDe3naffl842G9KCxsXRghB5wNiFWAC9glXIKVG5xeH6JiZVKbgLh6lK+0mEjL1yQstRrBCjrBAYj+UyMOIHg1OIDcnnNaBT7voCCTF1QmseMrPo8HIKntWAiryJR7gwUCKyxgWrSZP8OVPJamEFoJ6BuSLKUKEnSrS9bivLOK/bm7g+zQouyU8tLsX2YrHbOrcXScGOTx43YFgL6Z3QDVbmmVqt6Il7oC9ZFj3SfWQI6sJasz8tWSE4MuIYcWj4w59+EoJiI5aWKEhP8EmqkZwvAkv4EDeNdMcchiNNH1gGuhfG/6EGjU5kP9PYwbOsCmg0vgo3crXGiCS3m
 FjH7Xg/s
 6geYbRTggq+UxZbAB1ScAkkwWqceqdI3GdNkHjF4YIOjxGpnig+52mLjOeYetN/f8T93vS9NY02O8LVnSKfOgv7B1lY3BWfpaSRxCWxu7vPh3SgUQI40euNlTi3SdzY/l33Eu3P8vx3TQRmyqoqjPgGDBZRt7rszK+b+436Ao8w5MEn6/N7m/y272JfXZvZP8RRyrWbFX94DDNwQN1B+aNOZPuc2JSeaHzIgGFQVMTaMD88OlI4m24/1to98xtOLMRCQSpB7ro7MTdqxpk+IXHrJYERrlHJ3JDyEK+dweTjZO3TVynBRyfmXzL5COAuZ70bRkJkTevmBtOvZDVA+OLkOmuTg+XKwfaCST3VdHJIjlwk6LBNrtH6RV3Wbv9L0UIOQTVCRZ5FsaZSJN4RYxQzRzii6PKAKKCPGF3TxaEP95nHNbofmr4E79/AnKN97UpVFo4X/raxwY7bt4MgaUeP8i02ObEwKcx0+P6NZ92cG40TM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/09/2026 07:22, Anshuman Khandual wrote:
> Replace READ_ONCE() with pmdp_get() for PMD accesses in preparation for
> supporting both D64 and D128 translation table formats.
> 
> READ_ONCE() cannot currently be used for 128-bit page table entries on
> arm64 because it does not provide the required 128-bit single-copy
> atomicity, causing builds to fail for accesses wider than 64 bits.
> 
> Although LDP/STP provide the required atomicity when FEAT_LSE is
> available (as required by FEAT_D128), extending READ_ONCE() to support
> 128-bit accesses is undesirable. READ_ONCE() is a general-purpose API,
> so doing so could encourage other 128-bit users that would either fail
> to build in configurations without D128 support or, if D128 becomes a
> runtime option, silently permit tearing on systems without the required
> hardware support.
> 
> Instead, standardize PMD accesses on the existing page-table helpers.
> These can be overridden on arm64 to provide 128-bit single-copy
> atomicity when required.
> 
> For now override pmdp_get() which is same as the generic memory default
> to avoid build dependency problem for callers in header <asm/pgtable.h>.
> 
> No functional change intended.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kasan-dev@googlegroups.com
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
> Changes in V3
> 
> - Added platform override for pmdp_get()
> - Replaced READ_ONCE() in pmdp_test_and_clear_young()
> 
>  arch/arm64/include/asm/pgtable.h | 11 +++++++++--
>  arch/arm64/mm/fault.c            |  2 +-
>  arch/arm64/mm/fixmap.c           |  2 +-
>  arch/arm64/mm/hugetlbpage.c      |  2 +-
>  arch/arm64/mm/kasan_init.c       |  4 ++--
>  arch/arm64/mm/mmu.c              | 22 +++++++++++-----------
>  arch/arm64/mm/pageattr.c         |  2 +-
>  arch/arm64/mm/trans_pgd.c        |  2 +-
>  8 files changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 763c5a411d64..9ad2d03e86ad 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -84,6 +84,12 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  	arch_flush_lazy_mmu_mode();
>  }
>  
> +#define pmdp_get pmdp_get
> +static inline pmd_t pmdp_get(pmd_t *pmdp)
> +{
> +	return READ_ONCE(*pmdp);
> +}
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  
> @@ -811,7 +817,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
>  }
>  
>  /* Find an entry in the third-level page table. */
> -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> +					 pte_index(addr) * sizeof(pte_t))
>  
>  #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
>  #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
> @@ -1291,7 +1298,7 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  		unsigned long address, pmd_t *pmdp)
>  {
>  	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
> -	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
> +	VM_WARN_ON(pmd_table(pmdp_get(pmdp)) && !system_supports_haft());
>  	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 2cecf6ba6df7..2757ee0c4300 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -188,7 +188,7 @@ static void show_pte(unsigned long addr)
>  			break;
>  
>  		pmdp = pmd_offset_lockless(pudp, pud, addr);
> -		pmd = READ_ONCE(*pmdp);
> +		pmd = pmdp_get(pmdp);
>  		ptval_to_str(pxd_str, pmd_val(pmd));
>  		pr_cont(", pmd=%s", pxd_str);
>  		if (pmd_none(pmd) || pmd_bad(pmd))
> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index f66a0016dd02..3cdac8021d4f 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -42,7 +42,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
>  
>  static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
>  {
> -	pmd_t pmd = READ_ONCE(*pmdp);
> +	pmd_t pmd = pmdp_get(pmdp);
>  	pte_t *ptep;
>  
>  	if (pmd_none(pmd)) {
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa..cdaa4500faf9 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -304,7 +304,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
>  		addr &= CONT_PMD_MASK;
>  
>  	pmdp = pmd_offset(pudp, addr);
> -	pmd = READ_ONCE(*pmdp);
> +	pmd = pmdp_get(pmdp);
>  	if (!(sz == PMD_SIZE || sz == CONT_PMD_SIZE) &&
>  	    pmd_none(pmd))
>  		return NULL;
> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> index 45fbdce684c8..7ca833c5de5e 100644
> --- a/arch/arm64/mm/kasan_init.c
> +++ b/arch/arm64/mm/kasan_init.c
> @@ -62,7 +62,7 @@ static phys_addr_t __init kasan_alloc_raw_page(int node)
>  static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
>  				      bool early)
>  {
> -	if (pmd_none(READ_ONCE(*pmdp))) {
> +	if (pmd_none(pmdp_get(pmdp))) {
>  		phys_addr_t pte_phys = early ?
>  				__pa_symbol(kasan_early_shadow_pte)
>  					: kasan_alloc_zeroed_page(node);
> @@ -138,7 +138,7 @@ static void __init kasan_pmd_populate(pud_t *pudp, unsigned long addr,
>  	do {
>  		next = pmd_addr_end(addr, end);
>  		kasan_pte_populate(pmdp, addr, next, node, early);
> -	} while (pmdp++, addr = next, addr != end && pmd_none(READ_ONCE(*pmdp)));
> +	} while (pmdp++, addr = next, addr != end && pmd_none(pmdp_get(pmdp)));
>  }
>  
>  static void __init kasan_pud_populate(p4d_t *p4dp, unsigned long addr,
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index e589fb00d1e3..95621913679e 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -200,7 +200,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
>  			       int flags)
>  {
>  	unsigned long next;
> -	pmd_t pmd = READ_ONCE(*pmdp);
> +	pmd_t pmd = pmdp_get(pmdp);
>  	pte_t *ptep;
>  
>  	BUG_ON(pmd_leaf(pmd));
> @@ -257,7 +257,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
>  	unsigned long next;
>  
>  	do {
> -		pmd_t old_pmd = READ_ONCE(*pmdp);
> +		pmd_t old_pmd = pmdp_get(pmdp);
>  
>  		next = pmd_addr_end(addr, end);
>  
> @@ -272,7 +272,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
>  			 * only allow updates to the permission attributes.
>  			 */
>  			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
> -						      READ_ONCE(pmd_val(*pmdp))));
> +						      pmd_val(pmdp_get(pmdp))));
>  		} else {
>  			int ret;
>  
> @@ -282,7 +282,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
>  				return ret;
>  
>  			VM_WARN_ON_ONCE(pmd_val(old_pmd) != 0 &&
> -					pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
> +					pmd_val(old_pmd) != pmd_val(pmdp_get(pmdp)));
>  		}
>  		phys += next - addr;
>  	} while (pmdp++, addr = next, addr != end);
> @@ -293,7 +293,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
>  static bool pmd_range_has_valid_noncont(pmd_t *pmdp)
>  {
>  	for (int i = 0; i < CONT_PMDS; i++) {
> -		pte_t pte = pmd_pte(READ_ONCE(pmdp[i]));
> +		pte_t pte = pmd_pte(pmdp_get(pmdp + i));
>  
>  		if (pte_valid(pte) && !pte_cont(pte))
>  			return true;
> @@ -1553,7 +1553,7 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
>  	do {
>  		next = pmd_addr_end(addr, end);
>  		pmdp = pmd_offset(pudp, addr);
> -		pmd = READ_ONCE(*pmdp);
> +		pmd = pmdp_get(pmdp);
>  		if (pmd_none(pmd))
>  			continue;
>  
> @@ -1708,7 +1708,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
>  	do {
>  		next = pmd_addr_end(addr, end);
>  		pmdp = pmd_offset(pudp, addr);
> -		pmd = READ_ONCE(*pmdp);
> +		pmd = pmdp_get(pmdp);
>  		if (pmd_none(pmd))
>  			continue;
>  
> @@ -1729,7 +1729,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
>  	 */
>  	pmdp = pmd_offset(pudp, 0UL);
>  	for (i = 0; i < PTRS_PER_PMD; i++) {
> -		if (!pmd_none(READ_ONCE(pmdp[i])))
> +		if (!pmd_none(pmdp_get(pmdp + i)))
>  			return;
>  	}
>  
> @@ -1881,7 +1881,7 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
>  	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), mk_pmd_sect_prot(prot));
>  
>  	/* Only allow permission changes for now */
> -	if (!pgattr_change_is_safe(READ_ONCE(pmd_val(*pmdp)),
> +	if (!pgattr_change_is_safe(pmd_val(pmdp_get(pmdp)),
>  				   pmd_val(new_pmd)))
>  		return 0;
>  
> @@ -1906,7 +1906,7 @@ int pud_clear_huge(pud_t *pudp)
>  
>  int pmd_clear_huge(pmd_t *pmdp)
>  {
> -	if (!pmd_leaf(READ_ONCE(*pmdp)))
> +	if (!pmd_leaf(pmdp_get(pmdp)))
>  		return 0;
>  	pmd_clear(pmdp);
>  	return 1;
> @@ -1917,7 +1917,7 @@ int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
>  	pte_t *table;
>  	pmd_t pmd;
>  
> -	pmd = READ_ONCE(*pmdp);
> +	pmd = pmdp_get(pmdp);
>  
>  	if (!pmd_table(pmd)) {
>  		VM_WARN_ON(1);
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index bbe98ac9ad8c..0ca07bd5ded9 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -414,7 +414,7 @@ bool kernel_page_present(struct page *page)
>  		return pud_valid(pud);
>  
>  	pmdp = pmd_offset(pudp, addr);
> -	pmd = READ_ONCE(*pmdp);
> +	pmd = pmdp_get(pmdp);
>  	if (pmd_none(pmd))
>  		return false;
>  	if (pmd_leaf(pmd))
> diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
> index cca9706a875c..b27b2d2c20c3 100644
> --- a/arch/arm64/mm/trans_pgd.c
> +++ b/arch/arm64/mm/trans_pgd.c
> @@ -74,7 +74,7 @@ static int copy_pmd(struct trans_pgd_info *info, pud_t *dst_pudp,
>  
>  	src_pmdp = pmd_offset(src_pudp, start);
>  	do {
> -		pmd_t pmd = READ_ONCE(*src_pmdp);
> +		pmd_t pmd = pmdp_get(src_pmdp);
>  
>  		next = pmd_addr_end(addr, end);
>  		if (pmd_none(pmd))


