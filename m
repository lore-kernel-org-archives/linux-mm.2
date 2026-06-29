Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A76C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796376B0005; Mon, 29 Jun 2026 02:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746AC6B0088; Mon, 29 Jun 2026 02:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E376B008A; Mon, 29 Jun 2026 02:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 379996B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:20:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B30E81C6B45
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:20:29 +0000 (UTC)
X-FDA: 84931950978.26.C80E9B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id E45DEC0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:20:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GkeTzKgD;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782714028;
	b=uqClLMx8B5lOdxP4iVumvR5jOKr7z8mRBKyrunxvP6vbMdfTwtgNkgNSEN66Q8cBa4G0Eu
	zrhWrisTAu/PNpXPUM/cw5qHJJ6bpVqfX9RXhXAVGqFyZHTMHAOvH5CpV8K0ejElnVq4uO
	av12gewyDj6npkq6W9B0u0c6WVabsFw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782714028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ub16g8RqXLcskK6Fsx6rpUpyK9owbsuzrSRMHq/iM7s=;
	b=eqJl5Nw/hgyRDFrzes4UHP+Uwr84t738wbOEbRHYlqejOa82Z1unCLpGdGJJFhfAPUK2ub
	s3dgsFqc1vyzbR1hBknlEDDkLroM+P+NjIkpQiWxhVck6CyvqSi4dGkurLRSYoo88asCM9
	5UuVgUuE2T67abH6naUwKTPuPP5VtH4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GkeTzKgD;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADFDA176B;
	Sun, 28 Jun 2026 23:20:22 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C37F43F85F;
	Sun, 28 Jun 2026 23:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782714027; bh=ymaXtgSzFABz4iScBxNN5MaznB6X3+kdvqfUSvn6QUQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GkeTzKgDjQb/XP4L1JdrSTkO8QNtJM4GujIs+ZmXRxFoLmgki+UvDzQhq4MYvtrPR
	 /mtqkQXmGdUsRGffsknqiUIuKC6ffALraRQvWtk5LVsIqO4UHMGHWhgrDErlWkegW0
	 N24uiOwteB0KKrM124zQnvpNfJUkahCFLOFt9LSM=
Message-ID: <21c5415a-da5d-48c7-92cc-83e8bf1c6dd9@arm.com>
Date: Mon, 29 Jun 2026 11:50:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
 shanghaoqiang@xiaomi.com
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-5-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260618084726.1070022-5-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E45DEC0002
X-Rspam-User: 
X-Stat-Signature: auooh8548uu56haodd67jbj95df1a159
X-HE-Tag: 1782714027-534511
X-HE-Meta: U2FsdGVkX1/znXo9KX67+Rv62+BvDrUkCwndAc7F6b6zh7AYrWAkfxZtTItxlyJj+LQsKneAgkBRLzycqc6qOQ/EjzqqkOwpOCxfX8WPvMxlatYDxTy0xxned2yGBpSv+wrdCnSWMc5Q56Yqs2kvfFkSVcJmbxiL83t/iw8tLyy9BDTpgLiHBPr5DHp6Qmb2RTEYFhQkVmY0AtJKqoUqIhOJtWpvQhl+/ZE+anQyw8XCJWIPjtyuzswgp6FALw5NQbEKGuVWdmNfmuAySdVKORPTb19+sWqVuCmcncFJ3A4BMYxd+sN0HbaInkNuZ/mgMjH8ALermyh1FgPUHDZuEUWnWckJ79b3NNYC0CQOVGZcmrXlie/5GXLjJ9UHt0dGbR3xv1JWIlqmtZNTaPiPvj8gW1ZDSarOl5WEzVdv4bk4Mnh2BAA/xRXQ+caidb0FMVYdwCRnPYID3MIDFsgpcCEXq2QY/D6i8fbNdvktK4PbvbWT7Jdo6CjO+Ds1IKPLlZkTcJ8vEIv4mRJot2mcC8q5jRHpf3/6OPvnZuqPzPjHIcc8HAgt/gtEwj2GA/i9llFUoH/eTaVioTfVxKyLhhUQX+O7dRR4dPg/H+V1EtcOGhPvq3Ek8o2YME6hlh2Ufi7SW7wBZ+cY3YCK55xYGD3pqloKr6rtRth2JTiOK+LNkaVIBOUAVNOpUXY/SuK39nDTGTBWjmJLxiRV+JNFCw/Ly+PoRpSk4jge9tLWcWG+EhER9/Kc1n6LMS38lArAaMFhrZN2d+Ltqouvj9+i+aAzY+cFDLQ5FBTsZU9H50yxOb7Tqal1QIT0b4MEnlUu3VDwXBES+d3d698TnSy+pP+xQvMt/i43Re8Q05EoBD9RabySQIRYjSqAPZitndPz6QkQUxWwZPyd/LbQRh4R0hY86fuBEGyktG8/8c2N2J8VvHW04pcpeIP9bxQBVHOWy7TNfUSxL5fRGTjKldI
 qFFuaooY
 FhjUuJoK7O3ZJ6A8Mjd7iBtnYgLaZJn97IuKMSZOqJe8GI5vfthb+mHabBPht7XSvt4CjDptYKHQHNhXZojjt2iPqVia1tfb8r2nOsqvlNxIvYfncxrlbt4+IxBAr8c2qvyxpx9mMI382k9iZikA5nJZ20kR8fPi7TVSgKiOgQ14/TeV1B+7br0qrmOCZmHDWZubWrVDs4rTBNJQtlaT77SKmvuGNdV5ZgkYZJrW/cyBFpjBTTuBx31ZHArxm+2soruqn39HtlC4EHoJoj+DulHAX92imyvBqdr4bX6ZqOOg87rn97DzSobrpZWLQpkZxLBFX+B3QlRJjigH9CY9lDfe5eGsYLTPyHlBLn3/zs8Opiz5r68ByuX2dIGfkt+e9UIKK91fK9TxIwwtkHTw2JgyRuYY9IDvlYPD90Gm8y1F6EB+GaoF5JwGAalvZtTLzB7dXErz6+PGhVWiK0nrsvYpZFnSyZNA0mvLwdKyvM9SrWBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 2:17 pm, Wen Jiang wrote:
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
> ---
>  mm/vmalloc.c | 81 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 47 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6660f240d27c9..253e017130e09 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -127,7 +127,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte;
>  	u64 pfn;
>  	struct page *page;
> -	unsigned long size = PAGE_SIZE;
> +	unsigned long size;
> +	unsigned int steps;
>  
>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>  		return -EINVAL;
> @@ -149,8 +150,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  		}
>  
>  		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> -		pfn += PFN_DOWN(size);
> -	} while (pte += PFN_DOWN(size), addr += size, addr != end);
> +		steps = PFN_DOWN(size);
> +	} while (pte += steps, pfn += steps, addr += size, addr != end);
>  

This belongs to previous patch.

Apart from that LGTM:

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> @@ -542,8 +543,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
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
> @@ -574,9 +577,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
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
> @@ -586,7 +590,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -596,7 +600,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
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
> @@ -604,7 +628,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  
>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pud_t *pud;
>  	unsigned long next;
> @@ -614,7 +638,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pud_addr_end(addr, end);
> -		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> +		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (pud++, addr = next, addr != end);
>  	return 0;
> @@ -622,7 +646,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  
>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
> @@ -632,14 +656,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
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
> @@ -654,7 +682,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_bad(*pgd))
>  			mask |= PGTBL_PGD_MODIFIED;
> -		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> +		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> @@ -677,27 +705,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
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
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
> +		page_shift = PAGE_SHIFT;
>  
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> -
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


