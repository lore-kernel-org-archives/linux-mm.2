Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C15CC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5284B6B00D3; Mon, 21 Sep 2026 08:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8386B00D9; Mon, 21 Sep 2026 08:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EED06B00E1; Mon, 21 Sep 2026 08:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14DF96B00D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:44:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC53AC0189
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:44:07 +0000 (UTC)
X-FDA: 85237736934.12.ED52C82
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 19D4F80007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:44:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AJ9nusiE;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789994646;
	b=GlY1kQfxzQByrTaNkff7Ylpq+2N8fnCFgHNY3PVsU1z9ukI7BkOOQA/hfze0vNrisK9yDe
	XM9VFTiynuJSJXw+iqgP+0Y5GHSSC0ygp/468O+4PgL9plGYOJxbfh5zOKGjDbFQzHEdY9
	wtngCSHOICLe8kFCxYknm+3tFgQ6RDY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AJ9nusiE;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789994646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whM2/SEMB+dtryfafZg9Tn+hZ8vcmHOfLtWlTlrqZ4A=;
	b=p8UCzCT7TLedwwi/qI8en95GnVcldggwbJ2LO+HsArk4pNA7q6qCuizVi+t6w1gCxcvV2g
	+QBX1T9i4m1+PB10wHVPZgxMjScjKNHm1AB4z76BR8ClaCZb3+W1QKSQ9uL0Q6omys7Yls
	lGBXh2yxS/G9gSMNUFxN6fQonEg8i8I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6069B1595;
	Mon, 21 Sep 2026 05:44:01 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F4813F86C;
	Mon, 21 Sep 2026 05:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789994644; bh=hSaFlW60GnnapNXxU3t+j2JvEhwluOUUhRrT+x2xCdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AJ9nusiEUfrNPUy+OaKbgRuGMZcBd6pQLGPYNott4hUMC5v3bPARPV48ttz17CRKT
	 D8RUsH8zUiaHV690me4YtnY7dC06DxS6toOalCRKEVM9P5ZoZfbMMlTvju3ASB/Wf2
	 WuycFzGE0BqDwxCE9uKLGiSZJkJIvlH4hvf2PElE=
Date: Mon, 21 Sep 2026 18:14:01 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Mark Rtland <mark.rtland@arm.com>, 
	linx-arm-kernel@lists.infradead.org, linx-kernel@vger.kernel.org, kasan-dev@googlegrops.com
Subject: Re: [PATCH 1/4] arm64/mm: Convert READ_ONCE() as pmdp_get() while
 accessing PMD
Message-ID: <zh3bxbrsd4trhmhofzy3ndjigkwudwtj77ezrqw5zfvmxiglgq@uyfcgtkasu5x>
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
 <20260903060657.2717457-2-anshuman.khandual@arm.com>
 <c1ca2256-2516-4f4d-ba08-a2f584fc812b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1ca2256-2516-4f4d-ba08-a2f584fc812b@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19D4F80007
X-Stat-Signature: szemzq1zxjd98w7qxgc656njqrhxaqek
X-Rspam-User: 
X-HE-Tag: 1789994645-647833
X-HE-Meta: U2FsdGVkX1+2fQBTzW49Auq4baHMn/AVj5dFuc6itSUEGFfkzMOaZJouJidtko0Iy7RjQXycul432aAM4Aobv7a1DlEEy/TaGWt6ql/ubxIPeT9tL9F9BzXydu/ctgHoU39HQ02ErAKhHaxeEChm54+xmrsRueGT7CH+IeHrX5syoLyK27oDQavaHEpVqJ1K/Ej1EPI3/2Qfwi+ACXfCtVKI1NkblMlRZyWqwrmFgQSgF6l1byMQTAwxKELnrwvtDcE7rGC5RSAJlWxRBUDjitsZ0H2oIvLjThCZh41QZiL1BcWqCAB0SS6bXo3bE5zhupKpWaGZVhZZux6EZH248wKGMbsjlkSgF6mMh3RyKm+OmAg04/Xl6Z4D3FbHVIfEW5mlG+LGT3ToY/s+eMKwrWZnQ7HKOgQiGEzjje3nDY1KCggLZveH7xSZiqm0X450yBggUbTptlVdTF5tzK8I4V/7sxF1h2mlk9yptrhvLVhLY7KMOIFrlvouwkpgH2CEZAosVXj/935OoXlbWFhYggQLjlxqhdJYmhEW2jiEFRLb4fldnnPmJ0GVhw1pjaKtZVXa0Gpxr5Aw86fTvPhuUYddfA5j2tOenRoXsd7RBlilNNokboyTXlELLeDS7YCphnwN7xaGLaqlK8LznyDTlPraCJS2AuRX8rPAPB0TZVKiHMFFflH6f2fxTziR+oEiU4r5IPTr00G69ZekIuDerSVWVX9Uks2FATiufIsM1BEGiclg+gckSGiguL9lzZrSQyymqDMifdKk6dGjjILDSogepqlrcnoBR++Ioxg+vD73xYtTuHQW7U6jPIOB+cH8hl0KrXFwJVFDAiMowbgLGPqpDP/hVZhPlh6br2HhATjQh5PdjFsV3+cw087um7ZNnX2Nkda54J1G7RtgBoZkSEVaJknMmZTZncwTJndq1gL/k9WjjfBhVVvQj1LGn/UBS0tgy4qCzM8BY/Yr2gY
 VLH8/XF9
 rJ6meEew3qfPfYWJbU/bs4BR2HxX6MK5IskaXve2ilCpUc/sBTVtt1CQCtEAV9kT5fI5ZX3kGTe61qYCMgV+9r/GWUYPNflqIqHykCsJo7cr1VNY58Z8EzUT2A3m9v+NelXCKX6XH5pi91QDIEg/qYQreRDoUeqtK0nurQNlAZeckPEb19rUUsjF5lu1Z+Tn3T0MLPEgn1WNRhMw7Oj0Vn5L7WMzsKkmxn7IGe07IJgo9HGsKBE4MuAFNgfMr53cED3JO4LE9HwPbZQEnOTehOdYleypGCTQBV7JWM5CEXqo2tZUPAFkWtK0dS6sNMRolMQ+3mTFiq1wYX7SgW3eyklxDXCfxGnBDwf236pgOs0U3Pr2nQ+9mlUAyN/ByDErhL3jzuUyr5pUrxw2PdewAhx+smSv6zCDnFGFnSb8iT0qHi1RLtxi6PN0NCagdNwL19t1yh76wICoH8bvGg4xjbenpqVk8Msj4OYqAwvlo6mK9ITiCD/k/fgD9NJ2OEbjVlRGQsw08BsdWUAeTb9F95Sxfww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 11:49:28AM +0100, Ryan Roberts wrote:
> On 03/09/2026 07:06, Anshuman Khandual wrote:
> > Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
> > support both D64 and D128 translation regime going forward. That is because
> > READ_ONCE() would need 128 bit single copy atomic guarantees, while reading
> > 128 bit page table entries which is currently not supported on arm64. Build
> > fails for READ_ONCE() while accessing beyond 64 bits.
> > 
> > Load Pair/Store Pair (ldp/stp) are only single copy atomic if FEAT_LSE1
> > is supported (which is required when FEAT_D128 is supported). Currently 128
> > bit pgtables is a compile time decision - so we could have chosen to extend
> > READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But then
> > it's a general purpose API and we were concerned that other users might
> > eventually creep in that expect 128 and then fail to compile in the other
> > configs.
> > 
> > But worse, we are considering eventually making D128 a boot time option, at
> > which point we'd have to make READ_ONCE() always allow 128 bit at compile
> > time but then it might silently tear at runtime.
> > 
> > So our preference is to standardize on these existing helpers, which we can
> > override in arm64 to give the 128 bit single copy guarantee when required.
> 
> Perhaps something like this conveys the justification a bit more clearly?:
> 
> ---8<---
> arm64/mm: Use pmdp_get() for PMD accesses
> 
> Replace READ_ONCE() with pmdp_get() for PMD accesses in preparation for
> supporting both D64 and D128 translation table formats.
> 
> READ_ONCE() cannot currently be used for 128-bit page table entries on arm64
> because it does not provide the required 128-bit single-copy atomicity, causing
> builds to fail for accesses wider than 64 bits.
> 
> Although LDP/STP provide the required atomicity when FEAT_LSE is available (as
> required by FEAT_D128), extending READ_ONCE() to support 128-bit accesses is
> undesirable. READ_ONCE() is a general-purpose API, so doing so could encourage
> other 128-bit users that would either fail to build in configurations without
> D128 support or, if D128 becomes a runtime option, silently permit tearing on
> systems without the required hardware support.
> 
> Instead, standardize PMD accesses on the existing page-table helpers. These can
> be overridden on arm64 to provide 128-bit single-copy atomicity when required.
> ---8<---

Sure will update, assume similar format being applicable all patches here.

> 
> With that:
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> 
> 
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rtland <mark.rtland@arm.com>
> > Cc: linx-arm-kernel@lists.infradead.org
> > Cc: linx-kernel@vger.kernel.org
> > Cc: kasan-dev@googlegrops.com
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/arm64/include/asm/pgtable.h |  3 ++-
> >  arch/arm64/mm/fault.c            |  2 +-
> >  arch/arm64/mm/fixmap.c           |  2 +-
> >  arch/arm64/mm/hugetlbpage.c      |  2 +-
> >  arch/arm64/mm/kasan_init.c       |  4 ++--
> >  arch/arm64/mm/mmu.c              | 22 +++++++++++-----------
> >  arch/arm64/mm/pageattr.c         |  2 +-
> >  arch/arm64/mm/trans_pgd.c        |  2 +-
> >  8 files changed, 20 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 61fbfab3e06e..51f55498d43d 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -805,7 +805,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> >  }
> >  
> >  /* Find an entry in the third-level page table. */
> > -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> > +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> > +					 pte_index(addr) * sizeof(pte_t))
> >  
> >  #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
> >  #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index c75bab3c2f4b..cb25cb130e83 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -188,7 +188,7 @@ static void show_pte(unsigned long addr)
> >  			break;
> >  
> >  		pmdp = pmd_offset(pudp, addr);
> > -		pmd = READ_ONCE(*pmdp);
> > +		pmd = pmdp_get(pmdp);
> >  		ptval_to_str(pmd_str, pmd_val(pmd));
> >  		pr_cont(", pmd=%s", pmd_str);
> >  		if (pmd_none(pmd) || pmd_bad(pmd))
> > diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> > index f66a0016dd02..3cdac8021d4f 100644
> > --- a/arch/arm64/mm/fixmap.c
> > +++ b/arch/arm64/mm/fixmap.c
> > @@ -42,7 +42,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
> >  
> >  static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
> >  {
> > -	pmd_t pmd = READ_ONCE(*pmdp);
> > +	pmd_t pmd = pmdp_get(pmdp);
> >  	pte_t *ptep;
> >  
> >  	if (pmd_none(pmd)) {
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index 8e799c1fe0aa..cdaa4500faf9 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -304,7 +304,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
> >  		addr &= CONT_PMD_MASK;
> >  
> >  	pmdp = pmd_offset(pudp, addr);
> > -	pmd = READ_ONCE(*pmdp);
> > +	pmd = pmdp_get(pmdp);
> >  	if (!(sz == PMD_SIZE || sz == CONT_PMD_SIZE) &&
> >  	    pmd_none(pmd))
> >  		return NULL;
> > diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> > index 45fbdce684c8..7ca833c5de5e 100644
> > --- a/arch/arm64/mm/kasan_init.c
> > +++ b/arch/arm64/mm/kasan_init.c
> > @@ -62,7 +62,7 @@ static phys_addr_t __init kasan_alloc_raw_page(int node)
> >  static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
> >  				      bool early)
> >  {
> > -	if (pmd_none(READ_ONCE(*pmdp))) {
> > +	if (pmd_none(pmdp_get(pmdp))) {
> >  		phys_addr_t pte_phys = early ?
> >  				__pa_symbol(kasan_early_shadow_pte)
> >  					: kasan_alloc_zeroed_page(node);
> > @@ -138,7 +138,7 @@ static void __init kasan_pmd_populate(pud_t *pudp, unsigned long addr,
> >  	do {
> >  		next = pmd_addr_end(addr, end);
> >  		kasan_pte_populate(pmdp, addr, next, node, early);
> > -	} while (pmdp++, addr = next, addr != end && pmd_none(READ_ONCE(*pmdp)));
> > +	} while (pmdp++, addr = next, addr != end && pmd_none(pmdp_get(pmdp)));
> >  }
> >  
> >  static void __init kasan_pud_populate(p4d_t *p4dp, unsigned long addr,
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index b5de4095d650..32daaa547d09 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -200,7 +200,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
> >  			       int flags)
> >  {
> >  	unsigned long next;
> > -	pmd_t pmd = READ_ONCE(*pmdp);
> > +	pmd_t pmd = pmdp_get(pmdp);
> >  	pte_t *ptep;
> >  
> >  	BUG_ON(pmd_leaf(pmd));
> > @@ -257,7 +257,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >  	unsigned long next;
> >  
> >  	do {
> > -		pmd_t old_pmd = READ_ONCE(*pmdp);
> > +		pmd_t old_pmd = pmdp_get(pmdp);
> >  
> >  		next = pmd_addr_end(addr, end);
> >  
> > @@ -272,7 +272,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >  			 * only allow updates to the permission attributes.
> >  			 */
> >  			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
> > -						      READ_ONCE(pmd_val(*pmdp))));
> > +						      pmd_val(pmdp_get(pmdp))));
> >  		} else {
> >  			int ret;
> >  
> > @@ -282,7 +282,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >  				return ret;
> >  
> >  			VM_WARN_ON_ONCE(pmd_val(old_pmd) != 0 &&
> > -					pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
> > +					pmd_val(old_pmd) != pmd_val(pmdp_get(pmdp)));
> >  		}
> >  		phys += next - addr;
> >  	} while (pmdp++, addr = next, addr != end);
> > @@ -293,7 +293,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >  static bool pmd_range_has_valid_noncont(pmd_t *pmdp)
> >  {
> >  	for (int i = 0; i < CONT_PMDS; i++) {
> > -		pte_t pte = pmd_pte(READ_ONCE(pmdp[i]));
> > +		pte_t pte = pmd_pte(pmdp_get(pmdp + i));
> >  
> >  		if (pte_valid(pte) && !pte_cont(pte))
> >  			return true;
> > @@ -1553,7 +1553,7 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
> >  	do {
> >  		next = pmd_addr_end(addr, end);
> >  		pmdp = pmd_offset(pudp, addr);
> > -		pmd = READ_ONCE(*pmdp);
> > +		pmd = pmdp_get(pmdp);
> >  		if (pmd_none(pmd))
> >  			continue;
> >  
> > @@ -1708,7 +1708,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
> >  	do {
> >  		next = pmd_addr_end(addr, end);
> >  		pmdp = pmd_offset(pudp, addr);
> > -		pmd = READ_ONCE(*pmdp);
> > +		pmd = pmdp_get(pmdp);
> >  		if (pmd_none(pmd))
> >  			continue;
> >  
> > @@ -1729,7 +1729,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
> >  	 */
> >  	pmdp = pmd_offset(pudp, 0UL);
> >  	for (i = 0; i < PTRS_PER_PMD; i++) {
> > -		if (!pmd_none(READ_ONCE(pmdp[i])))
> > +		if (!pmd_none(pmdp_get(pmdp + i)))
> >  			return;
> >  	}
> >  
> > @@ -1881,7 +1881,7 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
> >  	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), mk_pmd_sect_prot(prot));
> >  
> >  	/* Only allow permission changes for now */
> > -	if (!pgattr_change_is_safe(READ_ONCE(pmd_val(*pmdp)),
> > +	if (!pgattr_change_is_safe(pmd_val(pmdp_get(pmdp)),
> >  				   pmd_val(new_pmd)))
> >  		return 0;
> >  
> > @@ -1906,7 +1906,7 @@ int pud_clear_huge(pud_t *pudp)
> >  
> >  int pmd_clear_huge(pmd_t *pmdp)
> >  {
> > -	if (!pmd_leaf(READ_ONCE(*pmdp)))
> > +	if (!pmd_leaf(pmdp_get(pmdp)))
> >  		return 0;
> >  	pmd_clear(pmdp);
> >  	return 1;
> > @@ -1917,7 +1917,7 @@ int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
> >  	pte_t *table;
> >  	pmd_t pmd;
> >  
> > -	pmd = READ_ONCE(*pmdp);
> > +	pmd = pmdp_get(pmdp);
> >  
> >  	if (!pmd_table(pmd)) {
> >  		VM_WARN_ON(1);
> > diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> > index bbe98ac9ad8c..0ca07bd5ded9 100644
> > --- a/arch/arm64/mm/pageattr.c
> > +++ b/arch/arm64/mm/pageattr.c
> > @@ -414,7 +414,7 @@ bool kernel_page_present(struct page *page)
> >  		return pud_valid(pud);
> >  
> >  	pmdp = pmd_offset(pudp, addr);
> > -	pmd = READ_ONCE(*pmdp);
> > +	pmd = pmdp_get(pmdp);
> >  	if (pmd_none(pmd))
> >  		return false;
> >  	if (pmd_leaf(pmd))
> > diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
> > index cca9706a875c..b27b2d2c20c3 100644
> > --- a/arch/arm64/mm/trans_pgd.c
> > +++ b/arch/arm64/mm/trans_pgd.c
> > @@ -74,7 +74,7 @@ static int copy_pmd(struct trans_pgd_info *info, pud_t *dst_pudp,
> >  
> >  	src_pmdp = pmd_offset(src_pudp, start);
> >  	do {
> > -		pmd_t pmd = READ_ONCE(*src_pmdp);
> > +		pmd_t pmd = pmdp_get(src_pmdp);
> >  
> >  		next = pmd_addr_end(addr, end);
> >  		if (pmd_none(pmd))
> 

