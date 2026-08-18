Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464CFC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424206B018D; Tue, 18 Aug 2026 11:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC1F6B02A1; Tue, 18 Aug 2026 11:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312706B046B; Tue, 18 Aug 2026 11:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 079966B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:53:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 609DA1401F6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:53:17 +0000 (UTC)
X-FDA: 85114834434.22.866A0D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3FAD8100003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:53:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KiMNDdqo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787068395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geXWrV0/2z0kpozDGOhKEC+5F4VQGLvn66X7G1ETdLM=;
	b=he4S6iHbpqskUL34c9XNx8ykU9hUHRZXQrasT2HoKKOJedOnuC6qLIL7Z6gHOig4PnKdTo
	N1SXRjyxT+2tXE8Decq9Sw2xwyrP75T7ocvMQweWHYXlJX6boAqXZY47dm9WSI2XlnF7sC
	0d+tl2/T42ugvYW/jE4d8ounZWkk3S8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KiMNDdqo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787068395;
	b=LRcSUBPjFt4R2pMEekaAs8bQeCJcXW7mp8Uc5YpfIUEoG2z4EyjBfLVM5gQlK88s/qqS+n
	i0s9S7N5IPENSKUES/LKwm7kB2E179knxlTKVsJh2Af56/b8fT1ZVUY8lbC64/V+wUd64N
	VVDZC7XGTzMsOjX0J6BKHfkGADOLCVw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3316B1A00;
	Tue, 18 Aug 2026 08:53:10 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AEF53F763;
	Tue, 18 Aug 2026 08:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787068394; bh=n5Pn/EgrqrIEFc5DK4mgxFWT/9EScWqa5GcuyDfAyeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KiMNDdqo79AFXbKqbuzUTJzNZjfCcxsyG80l6DMNVWk3SK8nXkyidq4VEkkObM4lg
	 2k296O5lKEZVD5XqetWIn+E/GvtX7ic8xbAsx7MBDnbniwPndVR5pUbaKDi8vAr2ak
	 /6nbyhSweQ+975pWMIkNhvlMelJpufEsIPDC/zOk=
Date: Tue, 18 Aug 2026 16:53:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>,
	Frank van der Linden <fvdl@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 11/18] hugetlb_vmemmap: Use try_populate_vmemmap_pmd for
 replacing in-use PMDs
Message-ID: <aoR_5LHPsVXUnxt6@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-12-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-12-jthoughton@google.com>
X-Rspam-User: 
X-Stat-Signature: z8iawb9jqkx6hnjesg6mf9yksb1docut
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3FAD8100003
X-HE-Tag: 1787068395-828603
X-HE-Meta: U2FsdGVkX19AYDJ10kZa3ys+EtRRhHI3y23hM+dvq+dTKZxJ6y/US+qpWJ43Qghhy9fgnTQ/43KXpzpm1tYiRuMN45uiV5HafCqIB7Fo4M/aURuRlbGMMQkLckqhfh1wr7qy/q3jUW1eNUXRynyC5UfAkM0fIO2G5C0aoO5zrengrzJcNO1mcopXI9vZhQfxYDl1CIwjb0t5YIC2MQFMzoVVHyRSi9uHzBZAHhz8hQODJ4csDVTONtupJA7XHCzyY5xurx94gfm+wSc0WYTSX/ptrCqhHibZKkFVeMt9XNuiL/O4pXYKrQnPgIMVQFYr+pL0Fj00NeYWSPGwA7MZyU9am3z5cwX079bY0R6e+SnU7jiC4zxEeSbgmpd3I+ja6WBOVNBR264dwr6g7om1KlC3Na8Ca5qf4707zsLNXa4YMXij0gEkqkDaxV1YApH2OwSj+ADjsofti7Tsp0LAbTQ7YNml0ALpIxeNTn7azVPZLfYrWh2usKUMIWlsKjD+oseHU1NF1bUbQpCnRza1cofJJYDD7xwuPVSnAjv5g6sTPqJA+1AX8dP5sqDCZWM/5H2bXihKhqvvt3sOmaRraKdSnVC72yUZd7fZwk9U1kM3/cq/epRd4z0kZz5gYhC+C1CSMeof/qLTsFdbIsVdA8bd0bKSGnRTiCeQ+8AgFoToRU2ciAm6gfCYu0ltrfQ2+ieMKyTZgGD5yn+/XX+Y6aYzJkNhpcoY+ScqToQD9WcCtd89wvYZ8nocdZZOizFRgfdBdbKie6jSaWNw246dLHCZWz0TMfwY8RUCvYlJJHlszg+QJj122DR+TM7JYH3Ph5dOzyJ1SoDE0VvNMT3eB3C17Ca35ezXLinJz1Cum/Qk5NiZ10+Z+BQ6ipACcqFi4qElGyVVvRHrdsfOBFa4Fjifl/jj8e2I3EuUBQ/SqAmpImeo4y4lU0zHnZnsVDscDK8rsW3rawvmOJt0k+0
 TIIIkIsn
 nh7SrK5pFDuwVXkr3bKYe8pxpyN+f6eiD0NQ8TsSClyNcUGZYy1aLnKdTSzPleXdgmSJL43eaTCu/KU2gVBjrEnTKv2WhAKBM2ai1j9+YmheRsQKxr2scpc9sXjuN7a1QwGwNMx/Dxd8PqBsY5oP6EYxCEsj71rBGyNLAo5yj0ly63/XpU0JDpZxVO10Sxgq7hhXOPLPBGdhDIlBrV1Sx7Qt6RKxMxX9s2ITJPcr4XOgAO/+Rduvk1tp9nQ8CWrX57Wjb/NmKIihh1iojeCSBGcDixg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:11:21AM +0000, James Houghton wrote:
> diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
> index 1b4509d3382c..c8946250d431 100644
> --- a/arch/arm64/include/asm/pgalloc.h
> +++ b/arch/arm64/include/asm/pgalloc.h
> @@ -121,4 +121,13 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
>  		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_PXN);
>  }
>  
> +#define __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
> +static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
> +					   unsigned long addr)
> +{
> +	/* BBML2_NOABORT is required. Its presence has been checked. */
> +	pmd_populate_kernel(&init_mm, pmdp, pgtable);
> +	return 0;
> +}

This patch adds the same function in 4 different arch files. Can we not
have a single generic implementation in linux/pgalloc.h, bracketed by
some ARCH_WANTS_* (macro or config)?

I think the same goes for patch 4 with try_update_vmemmap_pte(), we can
reduce the code duplication.

> diff --git a/include/linux/pgalloc.h b/include/linux/pgalloc.h
> index 9174fa59bbc5..ed446d95ca37 100644
> --- a/include/linux/pgalloc.h
> +++ b/include/linux/pgalloc.h
> @@ -26,4 +26,24 @@
>  			arch_sync_kernel_mappings(addr, addr);		\
>  	} while (0)
>  
> +#ifndef __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
> +/*
> + * try_populate_vmemmap_pmd - Populate a PMD that is in use by the vmemmap.
> + * @addr: Base address of the remapped PMD.
> + * @pmdp: Page table pointer to be overwritten.
> + * @pgtable: Pointer to the page table that the new PMD will point to.
> + *
> + * This function is only to be used to update PMDs that map the vmemmap to
> + * point to a page of already-populated PTEs that map the same pages.
> + *
> + * Implementations of this function must ensure that, while the update is taking
> + * place, CPUs will not fault on the remapped virtual address range.
> + */
> +static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
> +					   unsigned long addr)

Nit: if we follow try_update_vmemmap_pte(), we could place 'addr' first.
It matches pgd_populate_kernel() as well in this file.

> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
>  #endif /* _LINUX_PGALLOC_H */
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 977249e22ed0..b445febac0d2 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -55,6 +55,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
>  			     struct vmemmap_remap_walk *walk)
>  {
>  	pmd_t __pmd;
> +	int ret;
>  	int i;
>  	unsigned long addr = start;
>  	pte_t *pgtable;
> @@ -74,8 +75,15 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
>  		set_pte_at(&init_mm, addr, pte, entry);
>  	}
>  
> +	ret = 0;
>  	spin_lock(&init_mm.page_table_lock);
>  	if (likely(pmd_leaf(*pmd))) {
> +		/* Make pte visible before pmd. See comment in pmd_install(). */
> +		smp_wmb();
> +		ret = try_populate_vmemmap_pmd(pmd, pgtable, start);
> +		if (ret)
> +			goto free;
> +
>  		/*
>  		 * Higher order allocations from buddy allocator must be able to
>  		 * be treated as independent small pages (as they can be freed
> @@ -84,21 +92,17 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
>  		if (!PageReserved(head))
>  			split_page(head, get_order(PMD_SIZE));
>  
> -		/* Make pte visible before pmd. See comment in pmd_install(). */
> -		smp_wmb();
> -		/*
> -		 * On arm64, this requires BBML2_NOABORT. Its support has
> -		 * already been checked.
> -		 */
> -		pmd_populate_kernel(&init_mm, pmd, pgtable);
>  		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
>  			flush_tlb_kernel_range(start, start + PMD_SIZE);
> -	} else {
> -		pte_free_kernel(&init_mm, pgtable);
> -	}
> -	spin_unlock(&init_mm.page_table_lock);
> +	} else
> +		goto free;
>  
> -	return 0;
> +out:
> +	spin_unlock(&init_mm.page_table_lock);
> +	return ret;
> +free:
> +	pte_free_kernel(&init_mm, pgtable);
> +	goto out;
>  }

Would 'free' first with fall through 'out' read better?

-- 
Catalin

