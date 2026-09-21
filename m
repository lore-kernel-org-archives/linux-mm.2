Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB89C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5D26B00AD; Mon, 21 Sep 2026 06:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C466B00AF; Mon, 21 Sep 2026 06:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B7A6B00E1; Mon, 21 Sep 2026 06:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 158956B00AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:49:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B29BC013E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:49:36 +0000 (UTC)
X-FDA: 85237448352.24.52F8D83
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 603CA180002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:49:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=erV4TueH;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEWrTZ6OQNeCRFetVug7UdrK+ghkO/zagFf8q9Ojo2U=;
	b=fK6VgHoM3fg3i9+v2uZN6g6JWgMs3Uw1Cp3xHHJCZoXWFlHsr9Nj/IkAXYTer91JiTnSUK
	Mu2qxTMdVcuf53AagUh+DFwXJMGh6EsMPnOYM/Q0WfZAoxdmMvbDLE+PoP10+RMQIwfQAx
	udydRwvsWh2s+BDjkQC3sMfwJ8AfILo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=erV4TueH;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987774;
	b=JjMhQlncXJ0MeZ8xFeWWlCdG1FFiwlNYEM42VDHtxDWVAV8RSPThzBuWvaLBok1vgzYgUI
	7T7dy/RSNnM8h4rtYfgGr5LSEneiMvxhBLnWbE6F1NiC7gG0bqPASYoCwQBX4tmJmrGEbY
	/5TgLEQ1HXPdlhdXduuZ3lRVbiMmbJo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F32FD1570;
	Mon, 21 Sep 2026 03:49:29 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B56643F86C;
	Mon, 21 Sep 2026 03:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987773; bh=Sh52A48MJo14bixZqGSha3srEquqn/DYNl7bZAm7A1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=erV4TueHzMTKU7EV61dmBcEuKYzA1op4hwcZB7VEFgaJWmKI5FE7ugnqJLu5ERObj
	 Q50JhfvJ6lkvid/bPPod28UwjH6vdEo+d+vjjz43+VycruIntOw4hXFlZ850Oh67Co
	 N6iKAnN/H18buKKpap1r1rQzAeicQUyvZ1ACH5b4=
Message-ID: <c1ca2256-2516-4f4d-ba08-a2f584fc812b@arm.com>
Date: Mon, 21 Sep 2026 11:49:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arm64/mm: Convert READ_ONCE() as pmdp_get() while
 accessing PMD
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
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
 <20260903060657.2717457-2-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260903060657.2717457-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 603CA180002
X-Stat-Signature: qs3tny7d9mfamhuescg8rtyia597jr34
X-Rspam-User: 
X-HE-Tag: 1789987774-32910
X-HE-Meta: U2FsdGVkX19LPhKqr1+2NWPlJI7ef+Gc1LllLlQ67VT/YAXgXGVH1e+ThnX33TNfiMvbsqJi2CL4eJa3SJpnaVDmyKUZIf+CTagBCEY3ZZ80mpDro94INwTF0UnXNmLf4OnaY5Q7ruSCBRVs1KfhP4x36xZBCMH73ZTxYc7yY8WQeY8S+vEjNRZOvOoUuQSh1tFOUMqYf2WaZQOlt0ftG/dNOURJF5Dp66/xZuVYIeCH0NUB5GDMv2LFoQ1zOFG6ORTb8QZ3Cr/AOFLPywKFr0D30opW9gR5k4H5sEU3uJlu1BQFaxd+khz3M03P46kpxMPOb3nYl24W8ze+0LPchAWHkB1tPKHyDFKmcM1H27zYeGRiu/ka0UVWRW6hLl1AkdSsAWhgfNockLEBvNujVUyPxqWU4wSdHOTYMJMbFvQ33fwgdXjAOLjOA008cpgdWdinqZO3BLGGTiQetwufLvrTTxuFGLYUxDtOfKHMyLRaIJGDnbgHRskXlOsJnw0x4432xIH7UR/D6wPeX6Ivd5VhItA2Lo4BT7fgOI3TclmIxM4uJU2emn01erutZYzpfLvP2BR647QUqc5C3Y75ih/HXpIO2fbq99s8OeiB8ykho63x2gRe/m1xJEbEadQ6bwtWy26d9o3JnqJIftCYvZ02UiA15Hk4nSRsO089josPUVByEcfw45Xxlz9MUzk0z1YjZ8800z4LewcnlX8b+zzuf7BYZ6A9hwoDwAjEsAj3CfKyeN3kWUaafnjfs3NIDl7tnkVH8kf6StAiT9q3RM17WIIMehVGCmYECY2yUeaAbkBJik/vWylP+LpPW6kqaINBgnYaUr/y36uHbVSi9sEUmBYyU0RGptMEkAnYTbpC7OFErBeo/9lAfxVtVBn+UUIuKy+yrJ7pBu7BRTicZjkAPRx9P+img0pG88dvFWzuKQvOUdfWvp130dn8+NPNfLW5di5ir/qOUTVz4cs
 HyxxgkKk
 l3mlVFcemQfUKuYiku+U/RgS/v8UKpoySGVw5DarGFPAgUCZRsUZOwYwtXyMM3OJiy9J56UPoGiJgIgyVXVK6Cc80fqwBkc+rE/epI4cBQJY8w2zKvo+HHuERLOVvNv9XlFuX8rPthcOZUZ0vHcJeGjv4DdT7UbQ5syVTYZsdR4huBOC9xTT/q20/ne58BoaQL6JNvvI6GJNMssqV/DAbcGRrCthoqk9Xjr5NnsnTkuGOQl1CXCnSlLlpEWlr+yEPdBUHujDa/ud1oY7Bn30/g1coXRldYQxn9FHvrTjXc9DCR9LAuuWCCUMoyNgRXiHazmC+vQsuHvCMXXyKQPKdd3wUX+ws7oeEvNfu24xX8X42VOApC/DZ+4bqq8GTJRiGvwXkLyvOsm7VJtaPip+g1veHyX1495GMq25Yvja5TSl5b70a8eRPbRuU1htn54UasNXNsBb6mm0MVvcxFemfxi72hRb04agiqf88cqdI6y6P6y4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 07:06, Anshuman Khandual wrote:
> Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
> support both D64 and D128 translation regime going forward. That is because
> READ_ONCE() would need 128 bit single copy atomic guarantees, while reading
> 128 bit page table entries which is currently not supported on arm64. Build
> fails for READ_ONCE() while accessing beyond 64 bits.
> 
> Load Pair/Store Pair (ldp/stp) are only single copy atomic if FEAT_LSE1
> is supported (which is required when FEAT_D128 is supported). Currently 128
> bit pgtables is a compile time decision - so we could have chosen to extend
> READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But then
> it's a general purpose API and we were concerned that other users might
> eventually creep in that expect 128 and then fail to compile in the other
> configs.
> 
> But worse, we are considering eventually making D128 a boot time option, at
> which point we'd have to make READ_ONCE() always allow 128 bit at compile
> time but then it might silently tear at runtime.
> 
> So our preference is to standardize on these existing helpers, which we can
> override in arm64 to give the 128 bit single copy guarantee when required.

Perhaps something like this conveys the justification a bit more clearly?:

---8<---
arm64/mm: Use pmdp_get() for PMD accesses

Replace READ_ONCE() with pmdp_get() for PMD accesses in preparation for
supporting both D64 and D128 translation table formats.

READ_ONCE() cannot currently be used for 128-bit page table entries on arm64
because it does not provide the required 128-bit single-copy atomicity, causing
builds to fail for accesses wider than 64 bits.

Although LDP/STP provide the required atomicity when FEAT_LSE is available (as
required by FEAT_D128), extending READ_ONCE() to support 128-bit accesses is
undesirable. READ_ONCE() is a general-purpose API, so doing so could encourage
other 128-bit users that would either fail to build in configurations without
D128 support or, if D128 becomes a runtime option, silently permit tearing on
systems without the required hardware support.

Instead, standardize PMD accesses on the existing page-table helpers. These can
be overridden on arm64 to provide 128-bit single-copy atomicity when required.
---8<---

With that:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>


> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rtland <mark.rtland@arm.com>
> Cc: linx-arm-kernel@lists.infradead.org
> Cc: linx-kernel@vger.kernel.org
> Cc: kasan-dev@googlegrops.com
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
> index 61fbfab3e06e..51f55498d43d 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -805,7 +805,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
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
> index c75bab3c2f4b..cb25cb130e83 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -188,7 +188,7 @@ static void show_pte(unsigned long addr)
>  			break;
>  
>  		pmdp = pmd_offset(pudp, addr);
> -		pmd = READ_ONCE(*pmdp);
> +		pmd = pmdp_get(pmdp);
>  		ptval_to_str(pmd_str, pmd_val(pmd));
>  		pr_cont(", pmd=%s", pmd_str);
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
> index b5de4095d650..32daaa547d09 100644
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


