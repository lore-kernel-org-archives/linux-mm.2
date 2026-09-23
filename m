Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 688CEC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D8F6B008C; Wed, 23 Sep 2026 04:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDDD6B0092; Wed, 23 Sep 2026 04:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ADDB6B009B; Wed, 23 Sep 2026 04:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 371146B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDBA412072C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:32:25 +0000 (UTC)
X-FDA: 85244360250.10.8B62599
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id CCF7E100004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:32:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t8ia1hWn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790152344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ti51N+CuvD4iSnniqj/uYeUpf/AuXGfZRMFg9bMB8o=;
	b=BDBW7wtcaC6SyPHexJ1XUJ7xgOIRRUMjd09ckXYaPY0KuNCcJRvrfYtv2rutTzRilCCZ9h
	PuA+nxK44JTxQPn3qTrVOSA3pO79sbiUm5QQkuz0MuQyor/IhOV3s21xzCYCXSuC41gKlm
	ChbS6WyDz1Nt0jg7x/ZzVDXY+pMR2dI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t8ia1hWn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790152344;
	b=PPcBIjKeyqABozP3hXaP7HELX15EYswBVbE7LT0FZhR6UrlZD1kxdqVbn5L+LcZb3AkM8j
	He7GCvkYrZskO8mAzaN/6CampFrqX9zO7P4kZSU6xTcrL7TTUubxHlR++YJyydIOCIDT9h
	yUGo78XDZk0FoWsUcMboOnFqinm9epA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44F581570;
	Wed, 23 Sep 2026 01:32:19 -0700 (PDT)
Received: from [10.0.138.135] (XHFQ2J9959-5.cambridge.arm.com [10.0.138.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C80563F86C;
	Wed, 23 Sep 2026 01:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790152342; bh=zzvJxrToN+5AqlqU0CvwWYmRdJMMAE6EqK1QaTzSNoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t8ia1hWnCTKF6BgRjNTh6Q94B8/wFBEFP1mNHioecYtl12XVSfSCern/A1uvo/OZU
	 TiCDYoVmCM3MzNfdFbfDWzlLLfsu5csrVYQMg3i2gkYqyGCYyFxz29vQWHWJDFa8Ha
	 +uBVE/omKsioocOpkO9vW2NLdXR82bDe/iVQmYnM=
Message-ID: <212067fe-1b16-4b87-87a7-4ce50847eb24@arm.com>
Date: Wed, 23 Sep 2026 09:32:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/4] arm64/mm: Use pmdp_get() for PMD accesses
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Mark Rtland <mark.rtland@arm.com>,
 linx-arm-kernel@lists.infradead.org, linx-kernel@vger.kernel.org,
 kasan-dev@googlegrops.com
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
 <20260922061638.3967467-2-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922061638.3967467-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: esobpt8mqa6qqh9xic3bpu4j7rmobqds
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCF7E100004
X-HE-Tag: 1790152343-811457
X-HE-Meta: U2FsdGVkX18ImWcbRrtFCWtShdLUINDywKf60Cr7sWubJhlZbGDIJXy4cvmHbeZhK6EQ6/rPlTMjiV4itqwKQY8jmWZrMFcC3gGY8T2ymLlM/tvbtUEOWN+FGI37yIgszPCWvQVjh0r+3ydE59SJy0bUM1beEWbJNufOXFru3KQTtt7N03lhJSlgQg6jFFXqIrvbqa2EdNh1c+xIC3fE8u7qJg8IaLmIuqEZJZjaUcjGLo2SKODVA/ku1KGthqN9MVTV8edIkGXSXYMKZDtXMpN7ScTgFvz+y/RfiL1Vn9SUcHDBzvY/3h9m/dTKx25ocB8rtGu1Ly1/z5AzavnX6swUgS0rZsMj90YTAJfs9j/YKQPURk9UAQtAYXhV/gPr4h4eYkRUxwh83R2tZcLALbqiQld4zRFFw9NM0wP69Q0NB2ATuWzY7dpsw3BP5q9PzOGAuAlQnucqtUtxlNjW15CQQUFrcpbp9B66tO92+PL9UOhZg57l3M+F3FBHGd4bgSRaC3njJvxQWhBbI0VZFXZKZ2DhEtymhcb6aTB9nuD2dVcRnHT+DxvXfTGiKiQSrTP3k1ch2QFw7f+e0SJLOP4Pl3F+mhCWa2b/hYywMcN1M6BJOjcRlXRUcXldd8knebHNkwqdpyj0Spfey7WB5x201ZT5My+WIGL+EFVp4rZrwKglGwn5axeTTjn+Sofo2FytrZfysdAKEz5+IAST8Km3wXCDEffD3XxWn5NfwdBWtfMV1gRnkqxvn0zxEFJ8aL5iV8Uot8mYLQRIwxoKqJ8TB46ngjElhoAjvazMwDM+CiucH+7R7wXFxH2ylomDMtnzLoqeUHyVYZFAeGKPS/shvwtory+Hu05YHGo95mFp5v+gTxrbDfI+tCGrlOLYIYKObH8d4G2LdvuvRrElCWXg4GZht1beE620ij3+TIEbWBFDJVSRqyx3RNN/49ztq/LfRrmPGJfsr02pM6e
 OwVbfwT6
 yMpaMGWpomdtGDrW+b3el6LrAb8nI33EpSjlZyYAJxXmNzV6igXrqz1az8IwbPlzh1ym3gU2LUUZdU40rFDG4hZixhpEKKvGVUT3KZ4gsoMJPOwoe18aEbnMH6rzwWIW/PM01o/7I7XLZe+AKbs8c96yFoloU5Wa+k0++HANQmvK9Nj0rTItJWxmzGGz9L5/ad+Y20RvYD6pk+wYLA3WgHPXHLVAF4EleNI9sh2/qTYszrO/wb31BYbWh3sUFuHzLbi0vQhAwjAFXL2QAgcfZNIhGNiD0NXWJbVsUUVCIUYWpvd9r4jNeehaILTVErJ/Dbjht/pnuoLq0cR68/D0RdBFjQtZcO3EWTelAmSpm4z8bmoyu47LgwUBRynvNZiEoRZUr/f3opgv92MgrNlcLketH7QnzjvuiOp1RyZSuZGytjvRhn6kqp4FrM7itDLHnqbLZQki1QFlcDwlSBSiU1gMuFAoaIVXm6TcjK/nUSpQMWvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/09/2026 07:16, Anshuman Khandual wrote:
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
> atomicity when required. No functional change intended.

I notice you have an unconverted READ_ONCE(*pmdp) in
pmdp_test_and_clear_young(). Is that intentional?

Thanks,
Ryan


> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rtland <mark.rtland@arm.com>
> Cc: linx-arm-kernel@lists.infradead.org
> Cc: linx-kernel@vger.kernel.org
> Cc: kasan-dev@googlegrops.com
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h |  3 ++-
>  arch/arm64/mm/fault.c            |  2 +-
>  arch/arm64/mm/fixmap.c           |  2 +-
>  arch/arm64/mm/hugetlbpage.c      |  2 +-
>  arch/arm64/mm/kasan_init.c       |  4 ++--
>  arch/arm64/mm/mmu.c              | 22 +++++++++++-----------
>  arch/arm64/mm/pageattr.c         |  2 +-
>  arch/arm64/mm/trans_pgd.c        |  2 +-
>  8 files changed, 20 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 763c5a411d64..b953ea0ba3ed 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -811,7 +811,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
>  }
>  
>  /* Find an entry in the third-level page table. */
> -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> +					 pte_index(addr) * sizeof(pte_t))
>  
>  #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
>  #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
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


