Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3397BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7AB6B00C0; Mon, 13 Jul 2026 12:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F346B00C1; Mon, 13 Jul 2026 12:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCF56B00C2; Mon, 13 Jul 2026 12:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD27F6B00C0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:18:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2CDF4C0A24
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:49:23 +0000 (UTC)
X-FDA: 84983885406.18.1F169E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id F131FA0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:49:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fEhipLwP;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783950561;
	b=JFIln3QcyF2ArS62jA9zIXfgfeZ5I7cq8ktVRB0f40x0ocwRTlcEDT3btwpBv/5R1Fd9yV
	ZlW+k27YfKwS1ffMIzY/CqebG+aDh5Vkq4+xPrJkOEjXV9NlR6DJ25C4QvYLeNUJ4p5C4m
	tEyWXrk1zYQLucXUmMS0wT6BthsflBA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fEhipLwP;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783950561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dL2VKym1UnhltwnaYtOpqLzEe9LSm4JI0ZNKENT3yQo=;
	b=W/TumgkborufYlpaVT/rbvfm4DPvOGngs2sw7IKaoe3zRBqy74guAmtoKfNJodz2bBL0IF
	t3MWI/wh+u7poChpBXD4a0qCGzTH8kGK64W04XS+dGmGu30svh0ASc3DjzHxkr+busYQgf
	+alnG3eJZ+qv1u0mC9ennZX7KNCaX/U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87D6D1576;
	Mon, 13 Jul 2026 06:49:15 -0700 (PDT)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74E3E3F7B4;
	Mon, 13 Jul 2026 06:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783950559; bh=hpF+B5I89ietP3twgkdOdoYxWCsb5V0kGzBiAvX1wgs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fEhipLwPpaOlZwwA7uusgOWXnDcZ6crqM6UwSs112vVuANbuv+f94pDG8HL8QZrDM
	 WpoBaqlEh4OT/1Fge7tlsYYRY6DGGBDSouZT32UoHBd6nOSc8LQjA2nlUn7dLwmH2q
	 TTbelgOntgP3R1jjsxOoO4tNvFKkvqY6SsVCHvVE=
Message-ID: <85a3a79a-2a78-47ed-bd93-48e8f1967551@arm.com>
Date: Mon, 13 Jul 2026 19:19:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-5-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260709073823.6643-5-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F131FA0009
X-Stat-Signature: mxo65c3cguoukhxnyd5jrypsi5nrjbjd
X-HE-Tag: 1783950560-607334
X-HE-Meta: U2FsdGVkX1/Pykaufj8/eyfkb2VjYFCQ0aME3rX3373WMt+/w4oblexAAqFtm3aH5H1WovtNF7CqEXfxVRiNbxH+k9dLiJHT9e+tJqirIKx+tpDaMA3pIIGwpIesnNZdTY1u0FDZ1ilsZpVEczsgFDVhm02fOK6xwnsPZLk9C6bGzLXXpm0qod0/uYQw9fIFLyu2oTvGlGelE00CX43/6U1zSbfh4y1h32++sW9THc2hAbGCHmTfKt8I7TnMyb0KXBl8dF+ak5Z0Gihx2V78JQYm8mhpSCaqwFbGe1Wu4yZKx2tK2TthU7Z5ljs+hFq9ihDCugmurBUD/4l43gUjkV+Q7/eXKnuzrMyCt5NANQod5v7wN1DG0mpAxoNLpmnYBAW3TPA8ePI42gHcSgLZ+mcH8lIBAVnGQz5vP5Wqgd4GdR55kQnTU7ZL4aCdWw4sOmorOxmqjhWGBGbLLP6rbqVPAbfkGkesEpF+lKonXPwQnQa8i970oEbpl8qUDdqZ75ykv2iFYLQtfk9iBzXH+BMmupVlkMyrC3vCPsAzf05EYQA7ThlmivMml+RA1P0V8VI1nliHK3HK/w9hjsi9ULjJ8yQidqup7s3FMLaw+K7Zd8TK0+OFiaQJqxFE+ifkggPliBd4cFKplfJUotTF+je6FpdYVmEZz+f8zB98eIyLeTaIvnKiEo2hbEqd7imUPS1OqSFYB0j0tvrrgZP2/lhOybnem0qDomkNDqq76ty+ai/Jh77p+7V+6l7A5LhIRgMowZgyaGFnze7KOHq5LqjfORijY+9wGIrbJyMxx14r7+tIZCmUAAKUDsLAc2FIoCbj+W0Mvs6VXYfYj0aFYkCqeOT48KFROhPFRbuaoDYQV/kaQpgSKz5n8w6FhCqwyvPYNymCQkrwRdlybWzvuS+xYrnaUCqgBXKsoV4CFLrAjOWUxIOrzRD5Bap0Wl9RBIjJaaThvxurqyyStSr
 PppVSJkC
 SJrimt2YvWho8jHC7cfsxnzyh6F3CBAlkOPugkHAjjV/s+g4jcUIVjMW00nD6QkGG3LVYicVldJv+uZfqoPuysCiJQlbePFBkj6gMTo3wm2ZNOZT8yXzJmjbENHGKEDUF8KnXmB+GhtPOgLzPVsyNLlv3BUXIffj1wWC8ftEK2qAZz1CLHzLpZ8pCCMiYuSj/jdyyyXl9RIZTPP14D3WAlTkaoC74/U4dmm4S2bwVE8BEcGJOYOr3tonO8Ccre8IJhPN3an3m7s9qz0JAX/zTaVYERKs/hS2/5TalKHPhRvJcoZeDWRNgeXPk32W4LGFOwPqWjJ37FIuKqlekcr9HbJgPrIHKqCyIYQabElSeawZA+Ts7gV6lvlCjGgaD52V0YkKgEt8NdCW1ccIEtz7eOZO1i470efeFVjx1lYJGVxk6KCmWIhTaMoNWryuRYKvpxnxJOCEljU0DVsY3MF25oRFJhOTa0e1fsWe8dbz92+wSjZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 1:08 pm, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> provides a clean interface by taking struct page **pages and mapping them
> via direct PTE iteration. This avoids the page table rewalk seen when
> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> 
> Extend it to support larger page_shift values, and add PMD- and
> contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
> since it now handles more than just small pages.
> 
> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> iterate over pages one by one via vmap_range_noflush(), which would
> otherwise lead to page table rewalk. The code is now unified with the
> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/vmalloc.c | 81 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 47 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d7fef85b241c4..d2a4d649af549 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -125,7 +125,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte;
>  	u64 pfn;
>  	struct page *page;
> -	unsigned long size = PAGE_SIZE;
> +	unsigned long size;
> +	unsigned int steps;
>  
>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>  		return -EINVAL;
> @@ -147,8 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  		}
>  
>  		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> -		pfn += PFN_DOWN(size);
> -	} while (pte += PFN_DOWN(size), addr += size, addr != end);
> +		steps = PFN_DOWN(size);
> +	} while (pte += steps, pfn += steps, addr += size, addr != end);

I think I had also recommended to put these vmap_pte_range() changes
into the previous patch.

>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> @@ -540,8 +541,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
>  
>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
> +	unsigned long pfn, size;
> +	unsigned int steps;
>  	int err = 0;
>  	pte_t *pte;
>  
> @@ -572,9 +575,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  			break;
>  		}
>  
> -		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> -		(*nr)++;
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +		pfn = page_to_pfn(page);
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> +		steps = PFN_DOWN(size);
> +	} while (pte += steps, *nr += steps, addr += size, addr != end);
>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> @@ -584,7 +588,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -594,7 +598,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pmd_addr_end(addr, end);
> -		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> +
> +		if (shift >= PMD_SHIFT) {
> +			struct page *page = pages[*nr];
> +			phys_addr_t phys_addr;
> +
> +			if (WARN_ON(!page))
> +				return -ENOMEM;
> +			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> +				return -EINVAL;
> +
> +			phys_addr = page_to_phys(page);
> +
> +			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
> +						shift)) {
> +				*mask |= PGTBL_PMD_MODIFIED;
> +				*nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
> +				continue;
> +			}
> +		}
> +
> +		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (pmd++, addr = next, addr != end);
>  	return 0;
> @@ -602,7 +626,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  
>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pud_t *pud;
>  	unsigned long next;
> @@ -612,7 +636,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pud_addr_end(addr, end);
> -		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> +		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (pud++, addr = next, addr != end);
>  	return 0;
> @@ -620,7 +644,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  
>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
> @@ -630,14 +654,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = p4d_addr_end(addr, end);
> -		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
> +		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (p4d++, addr = next, addr != end);
>  	return 0;
>  }
>  
> -static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> -		pgprot_t prot, struct page **pages)
> +/*
> + * It can take an array of pages which are not all contiguous, but it
> + * may have contiguous chunks, as hinted by @shift.
> + */
> +static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages, unsigned int shift)
>  {
>  	unsigned long start = addr;
>  	pgd_t *pgd;
> @@ -652,7 +680,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_bad(*pgd))
>  			mask |= PGTBL_PGD_MODIFIED;
> -		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> +		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> @@ -675,27 +703,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
> -	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> -
>  	WARN_ON(page_shift < PAGE_SHIFT);
>  
> -	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift == PAGE_SHIFT)
> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> -
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
> +		page_shift = PAGE_SHIFT;
>  
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> -					page_to_phys(pages[i]), prot,
> -					page_shift);
> -		if (err)
> -			return err;
> -
> -		addr += 1UL << page_shift;
> -	}
> -
> -	return 0;
> +	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
>  }
>  
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,


