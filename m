Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB58C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376FB6B0098; Thu, 24 Sep 2026 08:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327DD6B0099; Thu, 24 Sep 2026 08:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264DD6B009B; Thu, 24 Sep 2026 08:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE2FF6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:11:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91B27C0321
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:11:00 +0000 (UTC)
X-FDA: 85248539880.04.26D5C10
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 845A280012
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:10:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fVueGZa1;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790251858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgQWdjt1fmXh13aDCNXOnJwaQhvEDo4/f2pi6CIGelo=;
	b=SR/G49Nz8bAdQ/+ZSrt0s9IcAy2e8L9jXOIb+82sI21J2sz/31Y4QiclEG7HrhmfgnU0VM
	u76urlM42VSIaTycfvcLFRtThHD/NU68UxvH9WuSw7OVw9IbYQJP+Y53dfpedgwf6O4ZSp
	LcS7KYHuU8R7oTa1RvJbyprEIxfwdPM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790251858;
	b=ewTrLSEgCeoS9PnHCqn/zWU7bl99Oxc2enJUM2cQEwev5QqdiF6fDUcBclrvKcWKaNBJj8
	THWuWofH1r+yFpRkbX3StdIaXa6UEjjLl0S71c3WJxROqJc3iPh2qbl/F+N4zIknKMC6HD
	TQt3gVoHZvsWBiVmBfK7B8vWqQZ2kKc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fVueGZa1;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B88C152B;
	Thu, 24 Sep 2026 05:10:54 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 592DA3F86C;
	Thu, 24 Sep 2026 05:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790251857; bh=IgtQ7NG3+ltNOk7/3bBV0TizU/mZJ41BEdTzaOl3LaQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fVueGZa1I/lX4r15+916hs6NmRSDKrWZR6N4zsyNwcmBGnEr7G+vVnyiLovJQEz4/
	 Sr3z02kzeKphesgRh4uF3U/WGgbLannb3g6KrCHJUu+dr50lL+cvaZDOlBigyiftFV
	 sAhDDsEP16LQbxhuU1UpU1ewgOxX04Eg/s1QVvCg=
Message-ID: <070d08d9-f778-4780-878a-2c2c4cb4f160@arm.com>
Date: Thu, 24 Sep 2026 13:10:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/4] arm64/mm: Use pgdp_get() for PGD accesses
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
 <20260924062214.1635078-5-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260924062214.1635078-5-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 845A280012
X-Stat-Signature: 5kodmfpd64icfr853r4iznxj7x3nkpmp
X-Rspam-User: 
X-HE-Tag: 1790251858-87217
X-HE-Meta: U2FsdGVkX19Uzce6oMiG1Q8QEkQBTf0y+GPtNU8TDe4UqBX9ZKtNHmQqN6wfAcdEZUTIX2mdwfYHeYCaYGP6Yf4N6zfuGcMOzXQa6TZFoMpTAtJQpZG/2vQUnqzUhK/sodpmk1wqEwU9krY6Pi6DQwnTPe1fuFleE65vVhadxvvuNOb/xm9fWAfDlQhzfgq30w3HlQRmF1gc1k/HnWGHhWuUPQekHM4z3l1gDqZayZu/4kRaFdNkkDCpPZ/jHRNTy/yiFZOoCiVPCJyih5WetrhFLCdB87CEaLv4+/AtEiVE2Vj7M3NU5xrFjCt5KEctWroVXfaysBKL2IVpejRaz6PP+qK8/gGMyQR8RyLtPE9LShB1FteycUO4geOXc5UwM+sHqD/wPBXcC3AVUv21J4JDcCYAFj99h+p9/w5CgxOjebFjecySmFyxm1DxTTetZbl5U1KsZg6OIy1o2ViDIHf1GI0ZuYrDTh8lsR7nKnL24F6xXiZqu6qMAhPdm14qCQvKIgYrR4AuZVVU6Z0tQ3tjc/b7UoA40P01UivofxF4a0YM+GfwC6yj4I9V21i51RtnzgPu+/IJ9Xo4toJ+OpZT733pY2pFgRAs4G7ZGok8bNOX15r+RO+1pnW3E6d+AcTRwEzSv3HRNeSLCbHugjI6iZwRN1Zs5QmpSLzxySiUfmpUYaNF7HTDQTp4H9WTa+piSUH7K6XhgQEZ3P3VREkELaUrIotiZMDmVSbGsJr3pyJk9fN7zPgxTZITBBAKn59LMZgwV2cV6hVBVXv+0ZhHQUCo3ZcduboCRLB0oGw9gB6cTzI4FplAkV3dc+Xf3UBMOljhBjK7+msP6AJS0FgvBWJ9uljdtodV+cMK3TWgYiT2ASAZVWs3agGl/yWET1nbJW8q+U2wQV2ZwAYeX2z8EhFAq6wu0v1O7K0Py+JYOaNTZyVhh28brlrdUaUwhplekfLAgiFfuZXyWcF
 ySlo3VX/
 I9aqtbp4txfzTp037zXgoayb9MFPLyLkC/ZqjrHeZYKz8BiBAGQPyospSDHw2YnMdluimNg4sYH92x2SVrj9L49eS/U83/A3RNIs5aZnUi2Tw9PxTcRe6hmQ3Swrep0X6QK5labGznl9d50L7IBMvTvZyXIc0S/5wdcLedAsjiiLsNP85rPlCn3sQdSp0qH0RZW39ur5eBuZvRW4GCno0ccKphCl5j6WsWAqLWNL4a53GqnMdc9KDEqxqrVgJdiVAVHjSBP+Tjv0WD1Y3Hkcfjw4pdgxz4DfWNaeURN32f3fHq1B+IR9cN/6+q/MJ7RYDMa22xyvq3j9talB6S/zflq5ccUO1Ck6CeOSWEW5E08BHlUg71/bM8fLrh/H991k+YC5t5M8382sZdXGLkBpVZbcTfZ9B1mmhNmZnhHqvg7B4lN8s6erjiRRcYpPMABDbBlbdA7ZrdmXlINTYE+Nu+DxSfd8/up6RHUubiLr7P7JlPyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/09/2026 07:22, Anshuman Khandual wrote:
> Replace READ_ONCE() with pgdp_get() for PGD accesses in preparation for
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
> Instead, standardize PGD accesses on the existing page-table helpers.
> These can be overridden on arm64 to provide 128-bit single-copy
> atomicity when required.
> 
> For now override pgdp_get() which is same as the generic memory default
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
> - Added platform override for pgdp_get()
> - Replaced READ_ONCE() in p4d_offset_phys() and p4d_offset()
> 
>  arch/arm64/include/asm/pgtable.h | 10 ++++++++--
>  arch/arm64/mm/fault.c            |  2 +-
>  arch/arm64/mm/hugetlbpage.c      |  2 +-
>  arch/arm64/mm/kasan_init.c       |  6 +++---
>  arch/arm64/mm/mmu.c              |  6 +++---
>  arch/arm64/mm/pageattr.c         |  2 +-
>  arch/arm64/mm/trans_pgd.c        |  4 ++--
>  7 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index f235f68a7518..05d273f276b8 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -102,6 +102,12 @@ static inline p4d_t p4dp_get(p4d_t *p4dp)
>  	return READ_ONCE(*p4dp);
>  }
>  
> +#define pgdp_get pgdp_get
> +static inline pgd_t pgdp_get(pgd_t *pgdp)
> +{
> +	return READ_ONCE(*pgdp);
> +}
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  
> @@ -1102,7 +1108,7 @@ static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
>  {
>  	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
>  
> -	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
> +	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
>  }
>  
>  static inline
> @@ -1116,7 +1122,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
>  
>  static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
>  {
> -	return p4d_offset_lockless(pgdp, READ_ONCE(*pgdp), addr);
> +	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
>  }
>  
>  static inline p4d_t *p4d_set_fixmap(unsigned long addr)
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index a6afd8929a10..43f25418275a 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -160,7 +160,7 @@ static void show_pte(unsigned long addr)
>  	guard(irqsave)();
>  
>  	pgdp = pgd_offset(mm, addr);
> -	pgd = READ_ONCE(*pgdp);
> +	pgd = pgdp_get(pgdp);
>  	ptval_to_str(pxd_str, pgd_val(pgd));
>  	pr_alert("[%016lx] pgd=%s", addr, pxd_str);
>  
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 5771bf49e1fe..e05e5b41ae50 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -284,7 +284,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
>  	pmd_t *pmdp, pmd;
>  
>  	pgdp = pgd_offset(mm, addr);
> -	if (!pgd_present(READ_ONCE(*pgdp)))
> +	if (!pgd_present(pgdp_get(pgdp)))
>  		return NULL;
>  
>  	p4dp = p4d_offset(pgdp, addr);
> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> index 4dd8c1186471..f61f5bc09467 100644
> --- a/arch/arm64/mm/kasan_init.c
> +++ b/arch/arm64/mm/kasan_init.c
> @@ -102,7 +102,7 @@ static pud_t *__init kasan_pud_offset(p4d_t *p4dp, unsigned long addr, int node,
>  static p4d_t *__init kasan_p4d_offset(pgd_t *pgdp, unsigned long addr, int node,
>  				      bool early)
>  {
> -	if (pgd_none(READ_ONCE(*pgdp))) {
> +	if (pgd_none(pgdp_get(pgdp))) {
>  		phys_addr_t p4d_phys = early ?
>  				__pa_symbol(kasan_early_shadow_p4d)
>  					: kasan_alloc_zeroed_page(node);
> @@ -256,7 +256,7 @@ static int __init root_level_idx(u64 addr)
>  static void __init clone_next_level(u64 addr, pgd_t *tmp_pg_dir, pud_t *pud)
>  {
>  	int idx = root_level_idx(addr);
> -	pgd_t pgd = READ_ONCE(swapper_pg_dir[idx]);
> +	pgd_t pgd = pgdp_get(swapper_pg_dir + idx);
>  	pud_t *pudp = (pud_t *)__phys_to_kimg(__pgd_to_phys(pgd));
>  
>  	memcpy(pud, pudp, PAGE_SIZE);
> @@ -280,7 +280,7 @@ static int __init next_level_idx(u64 addr)
>   */
>  static void __init clear_next_level(int pgd_idx, int start, int end)
>  {
> -	pgd_t pgd = READ_ONCE(swapper_pg_dir[pgd_idx]);
> +	pgd_t pgd = pgdp_get(swapper_pg_dir + pgd_idx);
>  	pud_t *pudp = (pud_t *)__phys_to_kimg(__pgd_to_phys(pgd));
>  
>  	memset(&pudp[start], 0, (end - start) * sizeof(pud_t));
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 83709d987e7c..76d8d320aeed 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -434,7 +434,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
>  {
>  	int ret;
>  	unsigned long next;
> -	pgd_t pgd = READ_ONCE(*pgdp);
> +	pgd_t pgd = pgdp_get(pgdp);
>  	p4d_t *p4dp;
>  
>  	if (pgd_none(pgd)) {
> @@ -1649,7 +1649,7 @@ static void unmap_hotplug_range(unsigned long addr, unsigned long end,
>  	do {
>  		next = pgd_addr_end(addr, end);
>  		pgdp = pgd_offset_k(addr);
> -		pgd = READ_ONCE(*pgdp);
> +		pgd = pgdp_get(pgdp);
>  		if (pgd_none(pgd))
>  			continue;
>  
> @@ -1827,7 +1827,7 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
>  	do {
>  		next = pgd_addr_end(addr, end);
>  		pgdp = pgd_offset_k(addr);
> -		pgd = READ_ONCE(*pgdp);
> +		pgd = pgdp_get(pgdp);
>  		if (pgd_none(pgd))
>  			continue;
>  
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 826856ef64a8..dfa1356daac2 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -399,7 +399,7 @@ bool kernel_page_present(struct page *page)
>  	unsigned long addr = (unsigned long)page_address(page);
>  
>  	pgdp = pgd_offset_k(addr);
> -	if (pgd_none(READ_ONCE(*pgdp)))
> +	if (pgd_none(pgdp_get(pgdp)))
>  		return false;
>  
>  	p4dp = p4d_offset(pgdp, addr);
> diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
> index 7afe2beca4ba..06470d690f9f 100644
> --- a/arch/arm64/mm/trans_pgd.c
> +++ b/arch/arm64/mm/trans_pgd.c
> @@ -134,7 +134,7 @@ static int copy_p4d(struct trans_pgd_info *info, pgd_t *dst_pgdp,
>  	unsigned long next;
>  	unsigned long addr = start;
>  
> -	if (pgd_none(READ_ONCE(*dst_pgdp))) {
> +	if (pgd_none(pgdp_get(dst_pgdp))) {
>  		dst_p4dp = trans_alloc(info);
>  		if (!dst_p4dp)
>  			return -ENOMEM;
> @@ -164,7 +164,7 @@ static int copy_page_tables(struct trans_pgd_info *info, pgd_t *dst_pgdp,
>  	dst_pgdp = pgd_offset_pgd(dst_pgdp, start);
>  	do {
>  		next = pgd_addr_end(addr, end);
> -		if (pgd_none(READ_ONCE(*src_pgdp)))
> +		if (pgd_none(pgdp_get(src_pgdp)))
>  			continue;
>  		if (copy_p4d(info, dst_pgdp, src_pgdp, addr, next))
>  			return -ENOMEM;


