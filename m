Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA49C982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 04:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253236B0088; Thu, 24 Sep 2026 00:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B066B008A; Thu, 24 Sep 2026 00:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1675E6B008C; Thu, 24 Sep 2026 00:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD0696B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:22:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3789120209
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:22:23 +0000 (UTC)
X-FDA: 85247358966.17.0D7F63F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 89B0040005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:22:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vcaCmMp8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790223742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+l2baNjads9ypsuvHYYts3WZDcQaL+ObhhWN33GAkg=;
	b=a2kh/+Ys63iTk+zVX0C4+Ue+HREsL4P2Cwev8c9/97s0G4ai4fnTZZlSU0byck6Dgk2KkP
	H/0afvCHAoiQuc5VVKk+o76SgxbRpN4U1GoK1eUSdXNL0cnl8+PatWO/BiS9IoQ0JK4a6v
	PoTYDxv8ktWfqi4IJl1P6GC573f2xJI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vcaCmMp8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790223742;
	b=7y0amaw8abd5TeViva2ZnfUfWD1Hzf5TJBFwVUMjlCaDlaumPGuHHq3CkCWxYfFXJW5Lf1
	huigZ5NSqK59Tvz2kufTWC3mMB6oIZrgLir6nb/11ljDV3jDutBS0Gx531DVPf0j3qw2t2
	g3noBMIAhjhO39YoZ5+abo/EWsHPgyo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 728BB152B;
	Wed, 23 Sep 2026 21:22:16 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17AE03F632;
	Wed, 23 Sep 2026 21:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790223739; bh=fUdSVAPf6JXOiBt1WWMuSzllWnjreq6oNfBQJVovxRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vcaCmMp8KMgI7rlLS5ZdKK8H9cM1yzjrrGOEQJN1omkufGYnpJu1rXNXvkRmte5If
	 JM82hP0WEX+At0U6W5yRcvzxzqF2hKPJV4EX7zarCcdCE2nIZPwkJ9WahHNcaiNPSB
	 w0ABcm0ZfrX3w23T+UrHGy8IFaoNbLi2EBRYeZ8c=
Date: Thu, 24 Sep 2026 09:52:15 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH V2 4/4] arm64/mm: Use pgdp_get() for PGD accesses
Message-ID: <6g6jx5mcpv3zkxqyysfyldn6zgc2m6vydjwnoz3balrdjre2pe@wdso3tebrjn3>
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
 <20260922061638.3967467-5-anshuman.khandual@arm.com>
 <a2365246-53a4-41e6-a655-6813f913cc1f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2365246-53a4-41e6-a655-6813f913cc1f@arm.com>
X-Stat-Signature: 3uoyocx6jffa4xfh63jw767y56usjmht
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89B0040005
X-HE-Tag: 1790223741-963743
X-HE-Meta: U2FsdGVkX19HlrUSyp9yHWaxwiBdJFkXPU42rcgjrEo86qCsUgdK1QODaBbvzgXXhdbKEfEDbhEgeM9pwIV7ljDr3Z8jfHNZV90YKkHnJzEsTTUKsZRoF1icmwaTMHLKldmv24hElSn3syXP5+G+O/tkqwNSKnPCnVLcPc8B7es8kdA8npKxKCpkB6ETnb+huYI3umwpe5DxayH0+YV5YJAFYBtmLNM03kqqbYpnZpcAiMy0q78+/cb8y66f0wyLYdRGB7/FfQi6BMMFoUofcr6HdWOX9q85uSFBZbFsbif+YnxuZPSkr0tPviK9bjGp/IyZzvrfFCRz+SVX5bNaPpU87TPF3rHjimiUgRWs208A0KNVUECjF5u8mpvqEfQVmvznrsfBkgVS2hvmLKWvInifmvC4pPWGWFfkPFecsxnOLZ66AmqPjn/Oekj674ngJyNVTT9jHNhQ00In6U9k3OxxmdXmdE08O3KvNIz0ox/P4Gr3mN6iGgjVqxkIQ3raljqwCIB+PniM06A1QcYKPE8wfhCbc4dOh7jN7oai/EUzClaNwBhF7tsvvFebxiM+2BDbYt5szDYsz7oXPnSNkv9u9CSGFbsARgX3P6tKJW8kWix9hvR5OGuL0ooU8a4gQ3XaveYdxbNvw+LUgUiDYtCd4p48TmKSOlPUlnZhVH+ftwrMVC4p8WoasixnanRV++A21bTVwUBVw+iqEkZJWpiBeubnWwaoxCXiDhXR5+tiVlLhJRwuUY4VxaQN7Nc8R262rG1uS4xQFlIlFEcHsv8vA7vpZ70VDKlyvUaNr0DOe7FIFB/swIe4/VOFsvyzSmGMMJDa/6OffLT3twAZugyp2izqDzPWhLIBSQd5c9PBTVTjcj5/j1Y8A6CuG6RLICNpZkAAyzk4f7wwK80neuCuGUUWLraIvo9AF+T3rA6JTVMZoz4jfWF1TbBPj+NUgkAaM3N5LoU47izRLiD
 OiXFnZG7
 A6qlolkcToE0G//hiRi4qUhBpQyygwsh24+f4yf82wIjlFIu8gqUgcbmPrBR1SW3xzDYagd9BQcJIcEE8elNOW2y7CFZjdhhOt5o1+Q8MMOeOva4Pmwek1QXDe3uZBmdUx8jsfwzjie+I0IiCbZHyY2qmdZFD86oGeChXyA0ut5BikzPioc6OzpD7RCvmHt8BkVSLdT2B4CV7cLtrPZlVw3GVT1cRsebEYlPEV5xWbOz3s9WMzZe/8GmJgsq/3wEUmKpZxK0dspN7vdws5H5xsc7Dp5Sf9JkaGHFE8OPaFqCVoLyCZxBgY4qk62rrujPhFGwn/d1tZmjoOST+BqnWN1Bd2Bl/dx9EpMFvTItV5OKdnTGx8+3OQ/B0GpNwzuRfDdK+U28G5SVE2/iHxlcaQUDsRZ4nLuV5eYACXDiFjcge0aMt4z/MCqgF4OftZvSICIIkAe9VDllhSPp0FltiRfIi+v6OJH3///PMvg/n3f+IVEfUQ4tC9BLBfoSFPmv5tBa0U5P5jHjS1ZqvZ+632HeHqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 09:31:28AM +0100, Ryan Roberts wrote:
> On 22/09/2026 07:16, Anshuman Khandual wrote:
> > Replace READ_ONCE() with pgdp_get() for PGD accesses in preparation for
> > supporting both D64 and D128 translation table formats.
> > 
> > READ_ONCE() cannot currently be used for 128-bit page table entries on
> > arm64 because it does not provide the required 128-bit single-copy
> > atomicity, causing builds to fail for accesses wider than 64 bits.
> > 
> > Although LDP/STP provide the required atomicity when FEAT_LSE is
> > available (as required by FEAT_D128), extending READ_ONCE() to support
> > 128-bit accesses is undesirable. READ_ONCE() is a general-purpose API,
> > so doing so could encourage other 128-bit users that would either fail
> > to build in configurations without D128 support or, if D128 becomes a
> > runtime option, silently permit tearing on systems without the required
> > hardware support.
> > 
> > Instead, standardize PGD accesses on the existing page-table helpers.
> > These can be overridden on arm64 to provide 128-bit single-copy
> > atomicity when required. No functional change intended.
> 
> I notice you have unconverted READ_ONCE(*pgdp) in:
> 
>  - p4d_offset_phys()
>  - p4d_offset()
> 
> Is that intentional?

Platform overrride for p4dp_get() should solve the problem as well.

> 
> Thanks,
> Ryan
> 
> 
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: kasan-dev@googlegroups.com
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/arm64/mm/fault.c       | 2 +-
> >  arch/arm64/mm/hugetlbpage.c | 2 +-
> >  arch/arm64/mm/kasan_init.c  | 6 +++---
> >  arch/arm64/mm/mmu.c         | 6 +++---
> >  arch/arm64/mm/pageattr.c    | 2 +-
> >  arch/arm64/mm/trans_pgd.c   | 4 ++--
> >  6 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index a6afd8929a10..43f25418275a 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -160,7 +160,7 @@ static void show_pte(unsigned long addr)
> >  	guard(irqsave)();
> >  
> >  	pgdp = pgd_offset(mm, addr);
> > -	pgd = READ_ONCE(*pgdp);
> > +	pgd = pgdp_get(pgdp);
> >  	ptval_to_str(pxd_str, pgd_val(pgd));
> >  	pr_alert("[%016lx] pgd=%s", addr, pxd_str);
> >  
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index 5771bf49e1fe..e05e5b41ae50 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -284,7 +284,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
> >  	pmd_t *pmdp, pmd;
> >  
> >  	pgdp = pgd_offset(mm, addr);
> > -	if (!pgd_present(READ_ONCE(*pgdp)))
> > +	if (!pgd_present(pgdp_get(pgdp)))
> >  		return NULL;
> >  
> >  	p4dp = p4d_offset(pgdp, addr);
> > diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> > index 4dd8c1186471..f61f5bc09467 100644
> > --- a/arch/arm64/mm/kasan_init.c
> > +++ b/arch/arm64/mm/kasan_init.c
> > @@ -102,7 +102,7 @@ static pud_t *__init kasan_pud_offset(p4d_t *p4dp, unsigned long addr, int node,
> >  static p4d_t *__init kasan_p4d_offset(pgd_t *pgdp, unsigned long addr, int node,
> >  				      bool early)
> >  {
> > -	if (pgd_none(READ_ONCE(*pgdp))) {
> > +	if (pgd_none(pgdp_get(pgdp))) {
> >  		phys_addr_t p4d_phys = early ?
> >  				__pa_symbol(kasan_early_shadow_p4d)
> >  					: kasan_alloc_zeroed_page(node);
> > @@ -256,7 +256,7 @@ static int __init root_level_idx(u64 addr)
> >  static void __init clone_next_level(u64 addr, pgd_t *tmp_pg_dir, pud_t *pud)
> >  {
> >  	int idx = root_level_idx(addr);
> > -	pgd_t pgd = READ_ONCE(swapper_pg_dir[idx]);
> > +	pgd_t pgd = pgdp_get(swapper_pg_dir + idx);
> >  	pud_t *pudp = (pud_t *)__phys_to_kimg(__pgd_to_phys(pgd));
> >  
> >  	memcpy(pud, pudp, PAGE_SIZE);
> > @@ -280,7 +280,7 @@ static int __init next_level_idx(u64 addr)
> >   */
> >  static void __init clear_next_level(int pgd_idx, int start, int end)
> >  {
> > -	pgd_t pgd = READ_ONCE(swapper_pg_dir[pgd_idx]);
> > +	pgd_t pgd = pgdp_get(swapper_pg_dir + pgd_idx);
> >  	pud_t *pudp = (pud_t *)__phys_to_kimg(__pgd_to_phys(pgd));
> >  
> >  	memset(&pudp[start], 0, (end - start) * sizeof(pud_t));
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 83709d987e7c..76d8d320aeed 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -434,7 +434,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
> >  {
> >  	int ret;
> >  	unsigned long next;
> > -	pgd_t pgd = READ_ONCE(*pgdp);
> > +	pgd_t pgd = pgdp_get(pgdp);
> >  	p4d_t *p4dp;
> >  
> >  	if (pgd_none(pgd)) {
> > @@ -1649,7 +1649,7 @@ static void unmap_hotplug_range(unsigned long addr, unsigned long end,
> >  	do {
> >  		next = pgd_addr_end(addr, end);
> >  		pgdp = pgd_offset_k(addr);
> > -		pgd = READ_ONCE(*pgdp);
> > +		pgd = pgdp_get(pgdp);
> >  		if (pgd_none(pgd))
> >  			continue;
> >  
> > @@ -1827,7 +1827,7 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
> >  	do {
> >  		next = pgd_addr_end(addr, end);
> >  		pgdp = pgd_offset_k(addr);
> > -		pgd = READ_ONCE(*pgdp);
> > +		pgd = pgdp_get(pgdp);
> >  		if (pgd_none(pgd))
> >  			continue;
> >  
> > diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> > index 826856ef64a8..dfa1356daac2 100644
> > --- a/arch/arm64/mm/pageattr.c
> > +++ b/arch/arm64/mm/pageattr.c
> > @@ -399,7 +399,7 @@ bool kernel_page_present(struct page *page)
> >  	unsigned long addr = (unsigned long)page_address(page);
> >  
> >  	pgdp = pgd_offset_k(addr);
> > -	if (pgd_none(READ_ONCE(*pgdp)))
> > +	if (pgd_none(pgdp_get(pgdp)))
> >  		return false;
> >  
> >  	p4dp = p4d_offset(pgdp, addr);
> > diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
> > index 7afe2beca4ba..06470d690f9f 100644
> > --- a/arch/arm64/mm/trans_pgd.c
> > +++ b/arch/arm64/mm/trans_pgd.c
> > @@ -134,7 +134,7 @@ static int copy_p4d(struct trans_pgd_info *info, pgd_t *dst_pgdp,
> >  	unsigned long next;
> >  	unsigned long addr = start;
> >  
> > -	if (pgd_none(READ_ONCE(*dst_pgdp))) {
> > +	if (pgd_none(pgdp_get(dst_pgdp))) {
> >  		dst_p4dp = trans_alloc(info);
> >  		if (!dst_p4dp)
> >  			return -ENOMEM;
> > @@ -164,7 +164,7 @@ static int copy_page_tables(struct trans_pgd_info *info, pgd_t *dst_pgdp,
> >  	dst_pgdp = pgd_offset_pgd(dst_pgdp, start);
> >  	do {
> >  		next = pgd_addr_end(addr, end);
> > -		if (pgd_none(READ_ONCE(*src_pgdp)))
> > +		if (pgd_none(pgdp_get(src_pgdp)))
> >  			continue;
> >  		if (copy_p4d(info, dst_pgdp, src_pgdp, addr, next))
> >  			return -ENOMEM;
> 

