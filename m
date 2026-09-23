Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BA6C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C676B0093; Wed, 23 Sep 2026 08:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23A06B0095; Wed, 23 Sep 2026 08:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61086B0096; Wed, 23 Sep 2026 08:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93F946B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:22:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21C21807B7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:22:58 +0000 (UTC)
X-FDA: 85244941236.01.690A72F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5DC1840002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:22:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JHClZnLP;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790166175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTAIXVJXCFSZKTwdE8QBtzo/vzIU7ZlldrSNSkWoIJI=;
	b=OhRwJTka39WWrMXaAQKG4x5XlVY9b+gd+IeYl56IzqFVO5izrkim/MPWeNWxGvzxucLZVr
	IDrnZlKTkwMv0qBe7/15syVv57CS7xpD2pS9k6QCZqgIfLT+2aScCS6VkkG5vLVGDW71jY
	b8A8aGJJPAE5G4RFJOpCELuhnHnul3c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JHClZnLP;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790166175;
	b=eCGmOv4FaLdJOUzslBYGvw7mSEUGEt1BTejIrAxwbQrfWRHAn/WquBCUOfCYMrvbv701kR
	hXTP9SPOtpeaplKkf4nAs3T6llR5l9v2oseis4RelA3zfrwDClciq0aDELrC9uaXIDfcKl
	/B3iSIcxStCJ12PgMLiXuIUMWHR1cDc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAC351570;
	Wed, 23 Sep 2026 05:22:50 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98B633F86C;
	Wed, 23 Sep 2026 05:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790166174; bh=fybh03wdLDUBfM1mCw7IcFTO9lMUmLVoP4htnADqzIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JHClZnLPaJqC0rxp3J+GWmS3peEKH96Cr/myTKnRM8Iq2ecs8HOhdHsZqkCIUKqxy
	 LyZhw1Nb3U5O+1LZQ5tYi9fA400pZm7PCr9S9r+DnrQ5w+VAM+JSeL26FdZQhEph9G
	 N11aI3CavViGBw5+rahFfFiiuP/QPmnTPvPJRyt4=
Date: Wed, 23 Sep 2026 17:52:50 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Mark Rtland <mark.rtland@arm.com>, 
	linx-arm-kernel@lists.infradead.org, linx-kernel@vger.kernel.org, kasan-dev@googlegrops.com
Subject: Re: [PATCH V2 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Message-ID: <7dn5t2m2fzuwxj2anuycz245hnctqc5mgaj5vdx7ybfql7arwv@6ac363txw3ff>
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
 <20260922061638.3967467-2-anshuman.khandual@arm.com>
 <212067fe-1b16-4b87-87a7-4ce50847eb24@arm.com>
 <m72rpspdg5cv7xptent4tglgd25zehx462nfmcx5uyjwi2ag7p@bc6hvhosgtfb>
 <bce043cc-0f69-4297-8f31-92dcfbc0061d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bce043cc-0f69-4297-8f31-92dcfbc0061d@arm.com>
X-Stat-Signature: bgs1jsrbwoksqwgbtb7oxcihs898cnhx
X-Rspamd-Queue-Id: 5DC1840002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790166175-354168
X-HE-Meta: U2FsdGVkX18XaZYLdafyK+0zF75oSMO5PJEQrdYAJ9bX0z3ywTnno0N/Z03uwUa0iY7wVqYMZYc68Fqisa6eGp1LstOYwJW8qrdQ8fuTNQqazyCtdZ0SSOvooX5A9ITd8BLKdsCS2eY0kvMJcE7jHgl4bTSiZ/BNksA8dExX9BkX4eIB3YhuXW/Ib1O/XpclsSq0v5mHPfR5wKBYVdM45ke0I10AqXZnDT6NN1yxFT8dtZMk90MrCSX7VPbC4HbwG3lVBsvCPQUUVe2zAeDqlnVNw3VTC2lN9QcJ5KQUYKN4hoQwkF2qJTBlzCugcU32R9M07cyXbIO8VSJAr+gl5HRIpKwlcPP0Pdy5K9jJHn0aV8b3PGBcC+iUrZ2teIpywGAy3lQ/19AKg5PR120HZ0to7+/amFgcBJUsoIzZjwxcLuTMl1KWf3sXLF1ejH2DT1bdQdbrwGRuTM1LkuTCY1QzEiZyjISOyN4E8e9UCqST5vA+hNFXTOrTxE39qxF+dSO12J9FUpLsGodnaDAqkqBZ85NXTE7/e+mzdAezj8Q3Pk26JEsi+fX/oevDsnNGPKToKT0bvunJUIFWx5Ci/0F2znoW+IUOab3gPduQ3bpKiGUxubUlRMbE6VIiUt1PKgtotEwgh6OwrZRz2PQbs23qJyYZ014jmG26WM5tVFmFs8wjJ0vdgKT5UZrigurDe/o6La42H9Muq/ZF2Ma2EWF0ORSbf3BeyyUUsp/NXIckgXz9zWn3iKPbQ6VFBtV/hMsNDSV3W0gJAig4//40XpyInnpuukppI/nmHSVqWxOX7ATXbkujH9/Fuq8gjmmcLu14gtWn5lvI4towsllQ8+8ZviuoPZsGbqJkOsGq7JcEk7u/b+/JcaqyDNL+UFvc9JhavVp84cVAwtLaZwbDBg9qIrgKTMPWoPraAxq9jOtR4++Rf6wI3m45CFWYpOrknGV/sr91duV2F+A4T3C
 C846U6lT
 hNRn81ikVj9OPli7dY46q0QyInpSClRWiBBSD9dfwQduOCHko8wtFJxq/m7EAqbZrHNOf1BTwcQgMav2kyp3PL/yR69/pTb03ka3CKxdmNZp4+oUo5Sm+w0T8rcDq0K799hrj0hFTOgiXIx0/O2yj/FXwYoSJ08QZ1JT3iZYtmMHlrWW6yTjctZe/KW22mtVcZYtwb951eE1iK35kxvH3amKY0w9rxSNYnUfwdN/LbAhoWtQ50kF8I5kmZgmELCira3P7hvFbQMJPRmLkqo9pl5eDYBc2xQertdPc6O7x1a14hsa8qqndhB4tSrJZbV4K414kCm5txOujIoJpKyqsk33O52VmrbxB6TR9kOSwEMaCl1q17maL6mDb6M4LPffyK1e7yB9H0CD1I+nKNTQVarl1O7p7eOwDo9cnk+JptaKlahRqlxyLHFQRLMJ8rfQPN41garvFmwJEiRv1YHvWMcfUOSD/4+ezrcdylXeAdylh95NP5Q0jCP3DnHiUrCT9lwCXCBY5g8ez/PBUSJdPuEFL4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 12:31:42PM +0100, Ryan Roberts wrote:
> On 23/09/2026 12:01, Anshuman Khandual wrote:
> > On Wed, Sep 23, 2026 at 09:32:17AM +0100, Ryan Roberts wrote:
> >> On 22/09/2026 07:16, Anshuman Khandual wrote:
> >>> Replace READ_ONCE() with pmdp_get() for PMD accesses in preparation for
> >>> supporting both D64 and D128 translation table formats.
> >>>
> >>> READ_ONCE() cannot currently be used for 128-bit page table entries on
> >>> arm64 because it does not provide the required 128-bit single-copy
> >>> atomicity, causing builds to fail for accesses wider than 64 bits.
> >>>
> >>> Although LDP/STP provide the required atomicity when FEAT_LSE is
> >>> available (as required by FEAT_D128), extending READ_ONCE() to support
> >>> 128-bit accesses is undesirable. READ_ONCE() is a general-purpose API,
> >>> so doing so could encourage other 128-bit users that would either fail
> >>> to build in configurations without D128 support or, if D128 becomes a
> >>> runtime option, silently permit tearing on systems without the required
> >>> hardware support.
> >>>
> >>> Instead, standardize PMD accesses on the existing page-table helpers.
> >>> These can be overridden on arm64 to provide 128-bit single-copy
> >>> atomicity when required. No functional change intended.
> >>
> >> I notice you have an unconverted READ_ONCE(*pmdp) in
> >> pmdp_test_and_clear_young(). Is that intentional?
> > 
> > Converting the above READ_ONCE() instances as pmdp_get() cuases a build
> > failure as pmpd_get() which is defined in generic pgtable header is not
> > visible inside platform specific pgtable header, even with a forward
> > declaration.
> > 
> > In D128 V2 series these conversions were performed later in the series,
> > when platform specific pxdp_get() overrides were added via ptval_get(). 
> > 
> > But to avoid this, we could just move pmdp_test_and_clear_young() inside
> > arch/arm64/mm/mmu.c file instead. Folding in the following change builds.
> 
> I'm not sure if/how this might affect performance? Probably not significant
> since they are for higher levels, so not called as frequently as pte helpers.

Right, should not have much performance impact.

> 
> Another option would be to implement arm64-specific pxdp_get() helpers in
> asm/pgtable.h to override the generic versions?

For now those will still be based on READ_ONCE() just like the default ones.
Although trying to drop similar redundancies from other platforms :)

https://lore.kernel.org/linux-mm/20260923043226.331880-1-anshuman.khandual@arm.com/

But given D128 is going to define pxdp_get() anyway it might make sense to
define them now and withdraw the above series :) Seems like s390 platform
also has similar situation.

>
> Thanks,
> Ryan
> 
> > 
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index ae41946c54f26..13ca85ec89f6a 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -1289,14 +1289,8 @@ static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
> > 
> >  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
> >  #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> > -static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> > -               unsigned long address, pmd_t *pmdp)
> > -{
> > -       /* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
> > -       VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
> > -       return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
> > -}
> > -#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
> > +bool pmdp_test_and_clear_young(struct vm_area_struct *vma, unsigned long address, pmd_t *pmdp);
> > +#endif
> > 
> >  static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
> >                                                unsigned long address,
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 76d8d320aeedf..b3fd06a623db5 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -2440,4 +2440,15 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
> >                      __func__, pte_str_old, pte_str);
> >  }
> >  #endif /* CONFIG_DEBUG_VM */
> > +
> > +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
> > +#define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> > +bool pmdp_test_and_clear_young(struct vm_area_struct *vma, unsigned long address, pmd_t *pmdp)
> > +{
> > +       /* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
> > +       VM_WARN_ON(pmd_table(pmdp_get(pmdp)) && !system_supports_haft());
> > +       return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
> > +}
> > +#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
> > +
> >  #endif
> > 
> >>
> >> Thanks,
> >> Ryan
> >>
> >>
> >>>
> >>> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >>> Cc: Will Deacon <will@kernel.org>
> >>> Cc: Ryan Roberts <ryan.roberts@arm.com>
> >>> Cc: Mark Rtland <mark.rtland@arm.com>
> >>> Cc: linx-arm-kernel@lists.infradead.org
> >>> Cc: linx-kernel@vger.kernel.org
> >>> Cc: kasan-dev@googlegrops.com
> >>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> >>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >>> ---
> >>>  arch/arm64/include/asm/pgtable.h |  3 ++-
> >>>  arch/arm64/mm/fault.c            |  2 +-
> >>>  arch/arm64/mm/fixmap.c           |  2 +-
> >>>  arch/arm64/mm/hugetlbpage.c      |  2 +-
> >>>  arch/arm64/mm/kasan_init.c       |  4 ++--
> >>>  arch/arm64/mm/mmu.c              | 22 +++++++++++-----------
> >>>  arch/arm64/mm/pageattr.c         |  2 +-
> >>>  arch/arm64/mm/trans_pgd.c        |  2 +-
> >>>  8 files changed, 20 insertions(+), 19 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> >>> index 763c5a411d64..b953ea0ba3ed 100644
> >>> --- a/arch/arm64/include/asm/pgtable.h
> >>> +++ b/arch/arm64/include/asm/pgtable.h
> >>> @@ -811,7 +811,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> >>>  }
> >>>  
> >>>  /* Find an entry in the third-level page table. */
> >>> -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> >>> +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> >>> +					 pte_index(addr) * sizeof(pte_t))
> >>>  
> >>>  #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
> >>>  #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
> >>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> >>> index 2cecf6ba6df7..2757ee0c4300 100644
> >>> --- a/arch/arm64/mm/fault.c
> >>> +++ b/arch/arm64/mm/fault.c
> >>> @@ -188,7 +188,7 @@ static void show_pte(unsigned long addr)
> >>>  			break;
> >>>  
> >>>  		pmdp = pmd_offset_lockless(pudp, pud, addr);
> >>> -		pmd = READ_ONCE(*pmdp);
> >>> +		pmd = pmdp_get(pmdp);
> >>>  		ptval_to_str(pxd_str, pmd_val(pmd));
> >>>  		pr_cont(", pmd=%s", pxd_str);
> >>>  		if (pmd_none(pmd) || pmd_bad(pmd))
> >>> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> >>> index f66a0016dd02..3cdac8021d4f 100644
> >>> --- a/arch/arm64/mm/fixmap.c
> >>> +++ b/arch/arm64/mm/fixmap.c
> >>> @@ -42,7 +42,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
> >>>  
> >>>  static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
> >>>  {
> >>> -	pmd_t pmd = READ_ONCE(*pmdp);
> >>> +	pmd_t pmd = pmdp_get(pmdp);
> >>>  	pte_t *ptep;
> >>>  
> >>>  	if (pmd_none(pmd)) {
> >>> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> >>> index 8e799c1fe0aa..cdaa4500faf9 100644
> >>> --- a/arch/arm64/mm/hugetlbpage.c
> >>> +++ b/arch/arm64/mm/hugetlbpage.c
> >>> @@ -304,7 +304,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
> >>>  		addr &= CONT_PMD_MASK;
> >>>  
> >>>  	pmdp = pmd_offset(pudp, addr);
> >>> -	pmd = READ_ONCE(*pmdp);
> >>> +	pmd = pmdp_get(pmdp);
> >>>  	if (!(sz == PMD_SIZE || sz == CONT_PMD_SIZE) &&
> >>>  	    pmd_none(pmd))
> >>>  		return NULL;
> >>> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> >>> index 45fbdce684c8..7ca833c5de5e 100644
> >>> --- a/arch/arm64/mm/kasan_init.c
> >>> +++ b/arch/arm64/mm/kasan_init.c
> >>> @@ -62,7 +62,7 @@ static phys_addr_t __init kasan_alloc_raw_page(int node)
> >>>  static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
> >>>  				      bool early)
> >>>  {
> >>> -	if (pmd_none(READ_ONCE(*pmdp))) {
> >>> +	if (pmd_none(pmdp_get(pmdp))) {
> >>>  		phys_addr_t pte_phys = early ?
> >>>  				__pa_symbol(kasan_early_shadow_pte)
> >>>  					: kasan_alloc_zeroed_page(node);
> >>> @@ -138,7 +138,7 @@ static void __init kasan_pmd_populate(pud_t *pudp, unsigned long addr,
> >>>  	do {
> >>>  		next = pmd_addr_end(addr, end);
> >>>  		kasan_pte_populate(pmdp, addr, next, node, early);
> >>> -	} while (pmdp++, addr = next, addr != end && pmd_none(READ_ONCE(*pmdp)));
> >>> +	} while (pmdp++, addr = next, addr != end && pmd_none(pmdp_get(pmdp)));
> >>>  }
> >>>  
> >>>  static void __init kasan_pud_populate(p4d_t *p4dp, unsigned long addr,
> >>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> >>> index e589fb00d1e3..95621913679e 100644
> >>> --- a/arch/arm64/mm/mmu.c
> >>> +++ b/arch/arm64/mm/mmu.c
> >>> @@ -200,7 +200,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
> >>>  			       int flags)
> >>>  {
> >>>  	unsigned long next;
> >>> -	pmd_t pmd = READ_ONCE(*pmdp);
> >>> +	pmd_t pmd = pmdp_get(pmdp);
> >>>  	pte_t *ptep;
> >>>  
> >>>  	BUG_ON(pmd_leaf(pmd));
> >>> @@ -257,7 +257,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >>>  	unsigned long next;
> >>>  
> >>>  	do {
> >>> -		pmd_t old_pmd = READ_ONCE(*pmdp);
> >>> +		pmd_t old_pmd = pmdp_get(pmdp);
> >>>  
> >>>  		next = pmd_addr_end(addr, end);
> >>>  
> >>> @@ -272,7 +272,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >>>  			 * only allow updates to the permission attributes.
> >>>  			 */
> >>>  			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
> >>> -						      READ_ONCE(pmd_val(*pmdp))));
> >>> +						      pmd_val(pmdp_get(pmdp))));
> >>>  		} else {
> >>>  			int ret;
> >>>  
> >>> @@ -282,7 +282,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >>>  				return ret;
> >>>  
> >>>  			VM_WARN_ON_ONCE(pmd_val(old_pmd) != 0 &&
> >>> -					pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
> >>> +					pmd_val(old_pmd) != pmd_val(pmdp_get(pmdp)));
> >>>  		}
> >>>  		phys += next - addr;
> >>>  	} while (pmdp++, addr = next, addr != end);
> >>> @@ -293,7 +293,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >>>  static bool pmd_range_has_valid_noncont(pmd_t *pmdp)
> >>>  {
> >>>  	for (int i = 0; i < CONT_PMDS; i++) {
> >>> -		pte_t pte = pmd_pte(READ_ONCE(pmdp[i]));
> >>> +		pte_t pte = pmd_pte(pmdp_get(pmdp + i));
> >>>  
> >>>  		if (pte_valid(pte) && !pte_cont(pte))
> >>>  			return true;
> >>> @@ -1553,7 +1553,7 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
> >>>  	do {
> >>>  		next = pmd_addr_end(addr, end);
> >>>  		pmdp = pmd_offset(pudp, addr);
> >>> -		pmd = READ_ONCE(*pmdp);
> >>> +		pmd = pmdp_get(pmdp);
> >>>  		if (pmd_none(pmd))
> >>>  			continue;
> >>>  
> >>> @@ -1708,7 +1708,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
> >>>  	do {
> >>>  		next = pmd_addr_end(addr, end);
> >>>  		pmdp = pmd_offset(pudp, addr);
> >>> -		pmd = READ_ONCE(*pmdp);
> >>> +		pmd = pmdp_get(pmdp);
> >>>  		if (pmd_none(pmd))
> >>>  			continue;
> >>>  
> >>> @@ -1729,7 +1729,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
> >>>  	 */
> >>>  	pmdp = pmd_offset(pudp, 0UL);
> >>>  	for (i = 0; i < PTRS_PER_PMD; i++) {
> >>> -		if (!pmd_none(READ_ONCE(pmdp[i])))
> >>> +		if (!pmd_none(pmdp_get(pmdp + i)))
> >>>  			return;
> >>>  	}
> >>>  
> >>> @@ -1881,7 +1881,7 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
> >>>  	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), mk_pmd_sect_prot(prot));
> >>>  
> >>>  	/* Only allow permission changes for now */
> >>> -	if (!pgattr_change_is_safe(READ_ONCE(pmd_val(*pmdp)),
> >>> +	if (!pgattr_change_is_safe(pmd_val(pmdp_get(pmdp)),
> >>>  				   pmd_val(new_pmd)))
> >>>  		return 0;
> >>>  
> >>> @@ -1906,7 +1906,7 @@ int pud_clear_huge(pud_t *pudp)
> >>>  
> >>>  int pmd_clear_huge(pmd_t *pmdp)
> >>>  {
> >>> -	if (!pmd_leaf(READ_ONCE(*pmdp)))
> >>> +	if (!pmd_leaf(pmdp_get(pmdp)))
> >>>  		return 0;
> >>>  	pmd_clear(pmdp);
> >>>  	return 1;
> >>> @@ -1917,7 +1917,7 @@ int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
> >>>  	pte_t *table;
> >>>  	pmd_t pmd;
> >>>  
> >>> -	pmd = READ_ONCE(*pmdp);
> >>> +	pmd = pmdp_get(pmdp);
> >>>  
> >>>  	if (!pmd_table(pmd)) {
> >>>  		VM_WARN_ON(1);
> >>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> >>> index bbe98ac9ad8c..0ca07bd5ded9 100644
> >>> --- a/arch/arm64/mm/pageattr.c
> >>> +++ b/arch/arm64/mm/pageattr.c
> >>> @@ -414,7 +414,7 @@ bool kernel_page_present(struct page *page)
> >>>  		return pud_valid(pud);
> >>>  
> >>>  	pmdp = pmd_offset(pudp, addr);
> >>> -	pmd = READ_ONCE(*pmdp);
> >>> +	pmd = pmdp_get(pmdp);
> >>>  	if (pmd_none(pmd))
> >>>  		return false;
> >>>  	if (pmd_leaf(pmd))
> >>> diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
> >>> index cca9706a875c..b27b2d2c20c3 100644
> >>> --- a/arch/arm64/mm/trans_pgd.c
> >>> +++ b/arch/arm64/mm/trans_pgd.c
> >>> @@ -74,7 +74,7 @@ static int copy_pmd(struct trans_pgd_info *info, pud_t *dst_pudp,
> >>>  
> >>>  	src_pmdp = pmd_offset(src_pudp, start);
> >>>  	do {
> >>> -		pmd_t pmd = READ_ONCE(*src_pmdp);
> >>> +		pmd_t pmd = pmdp_get(src_pmdp);
> >>>  
> >>>  		next = pmd_addr_end(addr, end);
> >>>  		if (pmd_none(pmd))
> >>
> 

