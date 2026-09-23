Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A98DC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8446B6B0098; Wed, 23 Sep 2026 04:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5B96B0099; Wed, 23 Sep 2026 04:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732A66B009B; Wed, 23 Sep 2026 04:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 414616B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:31:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A560BA074D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:31:34 +0000 (UTC)
X-FDA: 85244358108.08.9FCCFEB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8FFFDC000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:31:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ILKJZuuK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790152292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcpGawQ/TblX5RHXCmOdSiCrP4Rv/3YnfhBf7so7XIA=;
	b=vEYAoNPH/UQtTwVsf8D0u1NjfxwZvaEQKZDKAYsAJhev9gY6TrDCRhFvprIkmMMazLPjcZ
	aWKiqGinHqw7AdngUGiYhE+Fx3KVFXmbDcra0qPgYKir1eYeBATV8RkPqg37J+Ixx1q7mu
	ejks1ahgfQ6LcXgDXcWl4PMuTo8ntMc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ILKJZuuK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790152292;
	b=UKipd2Fw3oF78fP4Dg1g5YwmBx91tOfHmoLwAh4cHhRZm6Ekk30EzG27ThtdgvJrWIkXeV
	Pg+KkoMJ9dLAaHu6HpR3Brg62W0Hz50czXIH4Nm2vTwauH3Un0KOHqubXpFO7oyOE4vl3O
	LzW6kNbly15sg2ahDaN9KjIRuWUNACQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09A0C1655;
	Wed, 23 Sep 2026 01:31:28 -0700 (PDT)
Received: from [10.0.138.135] (XHFQ2J9959-5.cambridge.arm.com [10.0.138.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B43753F86C;
	Wed, 23 Sep 2026 01:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790152291; bh=uo/YQJ9Ixi6nxB3CeTrx+DkpZlwIfhyjjyUZRUsJGvs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ILKJZuuKIEuzmuevKqKO4tOS30td5XpGCkCczw00msIJ1M68Pm2su8zMpXlopRKtq
	 uO92e8JU8rn3U2M+muQPsaL6hrrjejHKeBhqQGZnHztXAU4EKE14nCDGLtMFyqT3Sf
	 nAHVmD4U/JKqIVNq3KlgE1+TBT5qqNmtP3stWqns=
Message-ID: <a2365246-53a4-41e6-a655-6813f913cc1f@arm.com>
Date: Wed, 23 Sep 2026 09:31:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 4/4] arm64/mm: Use pgdp_get() for PGD accesses
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
 <20260922061638.3967467-5-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922061638.3967467-5-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: duxcobqirxc5b6hdfq3smdksffk9939d
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8FFFDC000E
X-HE-Tag: 1790152292-756182
X-HE-Meta: U2FsdGVkX198QCKkwpBl3/ceDvSjncZHk6O4GKwmk+fx5E2iqCcnE0meoGX8cYQB6vObThK5ZDSpj1O2PeeqxAkWMjhTMv1oru2+bduTPewj97ZVUTE667giikwbvrI4QZCAn2Gjs4TKgai4lixHEwzJUinqIPt+kIjDQIabS8AdxebiO8GrsCZUYnjgci4HWGR0tJIOtrPioJWYOLaCr3A6RAhKsKqIMexxqJGV2otZAc4HaSQBXnkDIpF0Kgh8/CihpFnJBxV5GAFUJaPv2y1jZvDVPtLnymGYAVdai2BIkRv+GemNlieS8Y/3ZiMFCjqJsqa6J9+1xCM/jrJGzdsrc+cfXw4Nrrrub0PL2zFOPCyYdHBTymQggCDO17A7yPQdZoB8eZxfM88S7oR1hWSDdlDPPUAZCyWWB3CO0MDyCbkcCa8q8k7M32CCCKTDBl/VPK3djTU3ZXyNz1Sbr62BKeuGPcbS90FfVUf8S5mkJKLpLiMsmHVzQKR+P6MVzFTNa7C4LT1D1PVqi0LZwXyGs/tw2Z9MkeN/5GEp7dpeXFxGFYyA/eTnup4tDFqL9bzX0h11ymPchi7VpV20AQXbyRPaGypMBRQKJcQCr/+mnTNXkzWM6dHbUG3IdjJ5fOuK8L34vww2UgA5Vaxk2Wu+trVVq5uBr/+8aQPrezOWGYjxUsCJFyUIc+6hf65GBMPViF95+L0eIpHrEJfjDB6xvj6T9d/FIy5mvvfwFk+vHQCghYLH4WmU1udNknVh4+MfC2AaQ78ufZ2CaB5P/J1Z+5lnYIMCWJSAG2ji3x7W0y98zcXaV42bpy2WrL/B0SJDFv2m5N8uXXHVXg59zKKsSst4B3V8uzNxUatAOXWsWOX9Kv+JBP86ydLfZQ5Sx7Uu/buKNtynDxZUiWbQ5nq6Nq0kZD9W45oR3F7mw7fphMe4SF25+o92jage+9ma8FAy8mZ4q2blFQj7gn/
 GC2wKWGU
 CVfdPyocRnvYVUJcAjHd4NZ2dGD1v1vSVcuHrF3DGW2vzGMVt6gjhcWetSAdV2fBEXGaj2JLPbaIEq77p4xHq/JhSEPXL0V+8M5+zUqiNFZePOKtoJBwMSZh1PI24/Ov4efWnQEpxXVf26f8zIh/S8gHjbEcadFTtYqjIhA58tVNY8H+qkXp/5KsQD6AGQZFdyHhQG9wRlTvvILlcNy8r5BfovGHY3D750sbJjXI8EW2Env/k+XuWEVKk5+sNKq8OTgMndlciQJPAqo0MGwNgRW6kV1HRGxdx44QZTxxKSTBQHx4jSH3UZa7vf6+yRzc7ELg0GuSB7mvbwaxAHz05pRqK60HWtKp8C7eYf0FyjzSqr56K1qClWAuQMRLdpuaa57thBOtq+FpCzMVGkcWxE6pJHloLlFXIm80fwQWvtb9j6aSKx7QTTZrZyE7cYo9/RwTfZAqNmVvus6FnETxAG55qeOX3sHWEowqrZ4G91sHpZ1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/09/2026 07:16, Anshuman Khandual wrote:
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
> atomicity when required. No functional change intended.

I notice you have unconverted READ_ONCE(*pgdp) in:

 - p4d_offset_phys()
 - p4d_offset()

Is that intentional?

Thanks,
Ryan


> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kasan-dev@googlegroups.com
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/mm/fault.c       | 2 +-
>  arch/arm64/mm/hugetlbpage.c | 2 +-
>  arch/arm64/mm/kasan_init.c  | 6 +++---
>  arch/arm64/mm/mmu.c         | 6 +++---
>  arch/arm64/mm/pageattr.c    | 2 +-
>  arch/arm64/mm/trans_pgd.c   | 4 ++--
>  6 files changed, 11 insertions(+), 11 deletions(-)
> 
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


