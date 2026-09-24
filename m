Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F80C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CA86B0095; Thu, 24 Sep 2026 08:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3E06B0096; Thu, 24 Sep 2026 08:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3216B0098; Thu, 24 Sep 2026 08:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5296B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:10:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2A571C23EB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:10:41 +0000 (UTC)
X-FDA: 85248539082.30.333205F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0E1F81C000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:10:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t495K1qy;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790251840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLKAQlkW+/7bBBXcTF/oFR4pmA1rcdanRnCkCGruJdU=;
	b=D22GcQtfJw7qpjYlDY7kbOryjOw524rT8NHfnc4bTsAgmpZWwdf8uRzChbChtCsdh28mrT
	hLec6QxfxhRznZizAoDbFvo1P8Tb/gAiU4clIZ2GFemJyEHoxB+qh/rrShnodZ0QRQksYl
	0p73Kw3Sk4w12Fxj6m9OG/TR6jOchFY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t495K1qy;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790251840;
	b=BevxFuveav/XiPz0sFX7bNGsJwwzlbfxueW8l+xm0jelxg13qBkGYo4lzOu5eYlEvMkK0T
	XaqL0nS0e7BzNqMA0K0pKWOXazPYNMNxSAggt0a5XFeqQkzAC2SeLFqF92K2tOfyti/jWG
	02Dmy3PPP93HqfVAz+oJIKeDpn//iHY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1E22152B;
	Thu, 24 Sep 2026 05:10:35 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01BF23F86C;
	Thu, 24 Sep 2026 05:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790251839; bh=CJqJWrazDBThFqWsTgrpzBOaAxK5nGOBXup4Emqd8AA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t495K1qyq4gbgcnSG0SSkLCtbRbfyt9DTrRQyvaBKXRgWElv+2ae2A1bD2fxdJf0/
	 681XPXlRf6M3F7YyDs3WLLANT8GrMr/gQfEi0VwjuSAghLqAccfqN6AXJrpj312UWZ
	 4T0/KjaUOq23Jc2B3il6L43TsxM6OJYJ08/OJIMk=
Message-ID: <b8265857-4082-4bf3-8f18-84e9495b7f40@arm.com>
Date: Thu, 24 Sep 2026 13:10:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 3/4] arm64/mm: Use p4dp_get() for P4D accesses
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
 <20260924062214.1635078-4-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260924062214.1635078-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E1F81C000C
X-Stat-Signature: 4nfh1oynz3g97cz9xjx6zknn4qj5p14m
X-Rspam-User: 
X-HE-Tag: 1790251839-156647
X-HE-Meta: U2FsdGVkX1/3Im6KNHrxO+pldBZuj/FQ8dNm2mJMFEbcutzsP8DZAVTvwx0u3/Opm7Mdiz2mWz5YmGwSaEAc/+tT/Sl5l1NzXouS3ns1mV0GRLjTOaspbWKMr7Uux3VMJOmsU6A4mRCJLOhxXyXzku4rHWfYPkgB9xRipeBmdUAFzVgH2RoPxMNUzBPSVglpNMrZ0pvt451drCF5yTD+0rwmpdOQ78ZUTLSbQoIqpG8WUDUu6cDqNvSP6LqvYPLSA4H0mdtq5HgDJZqS56ccRLpH8Le7RwikOznPQivYtsG6/GDC0gDaeEa8gGFLWq4FZNPmGCL2tH73YI4hnxZVG6Dzkhzz221ltQweojIIeZr2muQI+3nyIAqLZvf0jUP270ZEMmG+9tbnlcihuTbdd3mb1CjyRgjiUamQAOR8q/Sbi5hW7l5N/8nGzmWqL5TQF5tOK0R0ui7uYmq3RbM+fLdKx6vLLgCa6VCclFY/TwjjU6mT24nGPq5PUmBfynwqtGZW3+m61it8WUCLAflQrvq8Od6d52wDF+pZ9oim8uHDNKZ9UynX01PnS52YKgWutV+bVd0uzeI6ENxbDn5HO4XDJRunMhUJM0GHMHigNZxmGXt8b83GDYs/LZCbHeUyD5ZCRu5MZSWWBT5dThj14wc1Pd9ipGlSckCJIWRu7vOBiShZi5hNFGd/MLFgo/cGQJo+8QJGDo4g/RoOS2G1C+lw66Ok2eFG4IroPTTv7ouxd50LebcjuHYSlJTIQzvZH3FERj03SW2KPsRyWyq3Svaas31QJowTxmODj3hsEDbhmzPZ4SNgxOTjB76ZCZCpN+iQ8kHyz9bgXKhDQVTstrMaL7WbFmtTCH/ijM43vfhetw5GmQ5HLUEAuSMtdeERx5lixPv/HgjaizKFHf5SH7CFyGM+hvbS8n505EhRzCCAT+DQaZQQ98iKQ6pAgf/3EEFzGaGiwX8OjQBC16y
 gXB4TCyf
 q7kRjtAHE7SZBEvp6Ko4MzOQ2DV/cfBSPn9SOHgwtlKdGpvgP9MaI6/p6x077TrjEPs3cscHNCGEqZn/85W+s+1sPLAuu5GcWIT+VDilXv//ygVW6Z8uu1Y3nqPQ9b8gtPOyWQWPdqn3W6REHjT1/29NbKPlAzgEgt3O5271xxNcGnFfIMv9caLTO9k56FlBYXLL6Fg2XYg99gX4u7hMp0t/LbHtmeULkKuyCVDEsu0Ewm02GJquBYFqwh2FjEQe5jxGWnu4/N9RjUb0mX8Ag4Mb/ThKxMFBUHBX4ZN928xfp6QASbFE1hiFOR5NPOPcrcIo1C2OLOwZV2i8HjtpcSpfGQatWtF2QIBRIHgt0WtOzZNCIoHAFXLAxuR0BZh1PPG5SJJJyBIzk7U8RsLW99d21QrwzxIErtpTN44d3cdrCPvjtqvpbya3vq0V4Yp6ovZkESVCDexrkhvIwRgpvoX4L6mTdEtxFGEHtvncEFKIJo3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/09/2026 07:22, Anshuman Khandual wrote:
> Replace READ_ONCE() with p4dp_get() for P4D accesses in preparation for
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
> Instead, standardize P4D accesses on the existing page-table helpers.
> These can be overridden on arm64 to provide 128-bit single-copy
> atomicity when required.
> 
> For now override p4dp_get() which is same as the generic memory default
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
> - Added platform override for p4dp_get()
> - Replaced READ_ONCE() in pud_offset_phys() and pud_offset()
> 
>  arch/arm64/include/asm/pgtable.h | 10 ++++++++--
>  arch/arm64/mm/fault.c            |  2 +-
>  arch/arm64/mm/fixmap.c           |  2 +-
>  arch/arm64/mm/hugetlbpage.c      |  2 +-
>  arch/arm64/mm/kasan_init.c       |  4 ++--
>  arch/arm64/mm/mmu.c              | 12 ++++++------
>  arch/arm64/mm/pageattr.c         |  2 +-
>  arch/arm64/mm/trans_pgd.c        |  4 ++--
>  8 files changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index b46930f844a2..f235f68a7518 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -96,6 +96,12 @@ static inline pud_t pudp_get(pud_t *pudp)
>  	return READ_ONCE(*pudp);
>  }
>  
> +#define p4dp_get p4dp_get
> +static inline p4d_t p4dp_get(p4d_t *p4dp)
> +{
> +	return READ_ONCE(*p4dp);
> +}
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  
> @@ -976,7 +982,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
>  {
>  	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
>  
> -	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
> +	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
>  }
>  
>  static inline
> @@ -990,7 +996,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
>  
>  static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
>  {
> -	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
> +	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
>  }
>  #define pud_offset	pud_offset
>  
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 435e2e14c070..a6afd8929a10 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -174,7 +174,7 @@ static void show_pte(unsigned long addr)
>  			break;
>  
>  		p4dp = p4d_offset_lockless(pgdp, pgd, addr);
> -		p4d = READ_ONCE(*p4dp);
> +		p4d = p4dp_get(p4dp);
>  		ptval_to_str(pxd_str, p4d_val(p4d));
>  		pr_cont(", p4d=%s", pxd_str);
>  		if (p4d_none(p4d) || p4d_bad(p4d))
> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index d9a870836faf..2a0fe0b0f771 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -74,7 +74,7 @@ static void __init early_fixmap_init_pmd(pud_t *pudp, unsigned long addr,
>  static void __init early_fixmap_init_pud(p4d_t *p4dp, unsigned long addr,
>  					 unsigned long end)
>  {
> -	p4d_t p4d = READ_ONCE(*p4dp);
> +	p4d_t p4d = p4dp_get(p4dp);
>  	pud_t *pudp;
>  
>  	if (CONFIG_PGTABLE_LEVELS > 3 && !p4d_none(p4d) &&
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index c9ad5e75b073..5771bf49e1fe 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -288,7 +288,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
>  		return NULL;
>  
>  	p4dp = p4d_offset(pgdp, addr);
> -	if (!p4d_present(READ_ONCE(*p4dp)))
> +	if (!p4d_present(p4dp_get(p4dp)))
>  		return NULL;
>  
>  	pudp = pud_offset(p4dp, addr);
> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> index aad29bcc7622..4dd8c1186471 100644
> --- a/arch/arm64/mm/kasan_init.c
> +++ b/arch/arm64/mm/kasan_init.c
> @@ -89,7 +89,7 @@ static pmd_t *__init kasan_pmd_offset(pud_t *pudp, unsigned long addr, int node,
>  static pud_t *__init kasan_pud_offset(p4d_t *p4dp, unsigned long addr, int node,
>  				      bool early)
>  {
> -	if (p4d_none(READ_ONCE(*p4dp))) {
> +	if (p4d_none(p4dp_get(p4dp))) {
>  		phys_addr_t pud_phys = early ?
>  				__pa_symbol(kasan_early_shadow_pud)
>  					: kasan_alloc_zeroed_page(node);
> @@ -162,7 +162,7 @@ static void __init kasan_p4d_populate(pgd_t *pgdp, unsigned long addr,
>  	do {
>  		next = p4d_addr_end(addr, end);
>  		kasan_pud_populate(p4dp, addr, next, node, early);
> -	} while (p4dp++, addr = next, addr != end && p4d_none(READ_ONCE(*p4dp)));
> +	} while (p4dp++, addr = next, addr != end && p4d_none(p4dp_get(p4dp)));
>  }
>  
>  static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 22efaee79293..83709d987e7c 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -367,7 +367,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
>  {
>  	int ret = 0;
>  	unsigned long next;
> -	p4d_t p4d = READ_ONCE(*p4dp);
> +	p4d_t p4d = p4dp_get(p4dp);
>  	pud_t *pudp;
>  
>  	if (p4d_none(p4d)) {
> @@ -457,7 +457,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
>  	}
>  
>  	do {
> -		p4d_t old_p4d = READ_ONCE(*p4dp);
> +		p4d_t old_p4d = p4dp_get(p4dp);
>  
>  		next = p4d_addr_end(addr, end);
>  
> @@ -467,7 +467,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
>  			goto out;
>  
>  		VM_WARN_ON_ONCE(p4d_val(old_p4d) != 0 &&
> -				p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
> +				p4d_val(old_p4d) != (p4d_val(p4dp_get(p4dp))));
>  
>  		phys += next - addr;
>  	} while (p4dp++, addr = next, addr != end);
> @@ -1622,7 +1622,7 @@ static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
>  	do {
>  		next = p4d_addr_end(addr, end);
>  		p4dp = p4d_offset(pgdp, addr);
> -		p4d = READ_ONCE(*p4dp);
> +		p4d = p4dp_get(p4dp);
>  		if (p4d_none(p4d))
>  			continue;
>  
> @@ -1788,7 +1788,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
>  	do {
>  		next = p4d_addr_end(addr, end);
>  		p4dp = p4d_offset(pgdp, addr);
> -		p4d = READ_ONCE(*p4dp);
> +		p4d = p4dp_get(p4dp);
>  		if (p4d_none(p4d))
>  			continue;
>  
> @@ -1809,7 +1809,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
>  	 */
>  	p4dp = p4d_offset(pgdp, 0UL);
>  	for (i = 0; i < PTRS_PER_P4D; i++) {
> -		if (!p4d_none(READ_ONCE(p4dp[i])))
> +		if (!p4d_none(p4dp_get(p4dp + i)))
>  			return;
>  	}
>  
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 07b2fa4de57f..826856ef64a8 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -403,7 +403,7 @@ bool kernel_page_present(struct page *page)
>  		return false;
>  
>  	p4dp = p4d_offset(pgdp, addr);
> -	if (p4d_none(READ_ONCE(*p4dp)))
> +	if (p4d_none(p4dp_get(p4dp)))
>  		return false;
>  
>  	pudp = pud_offset(p4dp, addr);
> diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
> index d119119455f1..7afe2beca4ba 100644
> --- a/arch/arm64/mm/trans_pgd.c
> +++ b/arch/arm64/mm/trans_pgd.c
> @@ -99,7 +99,7 @@ static int copy_pud(struct trans_pgd_info *info, p4d_t *dst_p4dp,
>  	unsigned long next;
>  	unsigned long addr = start;
>  
> -	if (p4d_none(READ_ONCE(*dst_p4dp))) {
> +	if (p4d_none(p4dp_get(dst_p4dp))) {
>  		dst_pudp = trans_alloc(info);
>  		if (!dst_pudp)
>  			return -ENOMEM;
> @@ -145,7 +145,7 @@ static int copy_p4d(struct trans_pgd_info *info, pgd_t *dst_pgdp,
>  	src_p4dp = p4d_offset(src_pgdp, start);
>  	do {
>  		next = p4d_addr_end(addr, end);
> -		if (p4d_none(READ_ONCE(*src_p4dp)))
> +		if (p4d_none(p4dp_get(src_p4dp)))
>  			continue;
>  		if (copy_pud(info, dst_p4dp, src_p4dp, addr, next))
>  			return -ENOMEM;


