Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11F0FA3742
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 12:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226606B0088; Fri,  2 Jan 2026 07:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4A76B0089; Fri,  2 Jan 2026 07:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1286B008A; Fri,  2 Jan 2026 07:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED8ED6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:21:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D777140C9A
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:21:22 +0000 (UTC)
X-FDA: 84286934004.12.35238CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9E783100006
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:21:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767356480; a=rsa-sha256;
	cv=none;
	b=ngANm/Voo5Z7gCyib7XNGQ97pwo8cYNikeARYM7qr16uGRI959JGYAcOftzR015H/WyKb+
	8jzBjYdJmsw9UJXMO/RA6CGFKEbZo9WcSzoqQfg0KtxXRk1CtU6iAXDL2jDDTl4AanpWNy
	4kdFOc07NPp56opFnwL4WK0xi5MenHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767356480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QXM8LJ6n5DBtUq8ca9svyjVLB1Hucrj6X6R3AG8yJB0=;
	b=iCepIXOXT76mFl+xpYwLCfBvQTX1TMHl8f7P7GQ5VTBF1NCLSKfgewYaNY2QpoMx5Umoai
	MzOXzLMeuVJL53dEX+N6E1gKHwZqvTCA2hnBxRMlrl20M/uaCYNIc6ju8ZwWKGbbuRJAxc
	BidJ0wqjnv+jF9p4tU+0OeAsFesz5VI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B0B4497;
	Fri,  2 Jan 2026 04:21:12 -0800 (PST)
Received: from [10.57.94.221] (unknown [10.57.94.221])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77F283F63F;
	Fri,  2 Jan 2026 04:21:16 -0800 (PST)
Message-ID: <fdf816d2-716a-466a-97be-9d8e8b442be5@arm.com>
Date: Fri, 2 Jan 2026 12:21:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] arm64: mm: support batch clearing of the young
 flag for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <a5138065a70a7588904d0bcfc569a5d856dcc65e.1766631066.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <a5138065a70a7588904d0bcfc569a5d856dcc65e.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E783100006
X-Rspamd-Server: rspam03
X-Stat-Signature: b7pksgs3rghfcc3cps1fstyh6q1edauk
X-Rspam-User: 
X-HE-Tag: 1767356480-121722
X-HE-Meta: U2FsdGVkX191pOIxdVfNjiUZ15eQLAXjVngIYVP2Kg/pVARapTJHBmSCUgfpKgLA76LmvkoH8jfFck+eEoSB4qX3yvKKjoixjDsu4O4rjC5aU2yBKzBF1gWAG75xi42F2M/g7747PEOPNmByXVPbsH6Zn/jYbMHwxlLF+rckAWGY1a2WS3KJmd/Y8hP0rRL3wkFR+kLGKxHnCywIjsWiktnXuNIY50RYxEu+e1fKswBdieXMDuq1o/bYIL+MG9bJ6/DWt176ab/ZMur7+APInfD/pXqYyc5hX7A6q+PJMK/6eNkbLy2vNPGWnDRYbqsqY6OALVSTMczRTVF9zLzoG0sW8h6L+ZemL6DBt/x/+6CvGH3MIcoWWGYU+hl7yRCNoiREVV4PB3qSAfAGvgZZhVYOZ1O8ARbvMZLK+MH9VkGaRO5fYU6lWvhY6fl5Blx7/vvtWVfZV2n5ySMpuhwecsXmZ95iRzbyrUNJH4vOEqtm2ftkUKUgBfACJBklgmzXS7+3uyA432QsNN/JyMxVv20aLgdRQ/AiWYBJXFCILA8m8M8lFw2cGPWQvXqyAEAIkVF7fZzx+02z1bEyb7Pyj6Ko1WJBMXvKjdHkCFvnGx9qSxrxyfCbPOGv1tAM9XKEZOMYGdT+9XNEiWO0AhCKZ3A/LplL9cpXm5kYfCIjJN06NWwO1SfwQi8l2eC+a1p35JSzYyw9tjNWoPJrNO5AAS0NcI2IPtaNI9Yp2byH+m4lRy7IjvjBz261T2YT3Zl0XkSQ63NOBtVvKJMRY5yEcpVtsfplPAmZaQTwF2MqLKkbt52Y9q3Vx8Ije+zQLz7gm/5MvvEsbX6akcHk00nKoXyYKSGACvo4+AFiY6SLWBlECGhphp6GVSw7FIqcC2/R1yr03Ol7G+ud+6WZGn0sL4hz2bNio8WhEB3DGRnf7kyzX/vAGSKn0tTCLT2KqixQC/8/RyjVDctssnOrjNC
 +p5z+C9d
 l9mbL+5Irrp2IH47nlG9/wZCFRACrS1lJfqi+WPNC3auKeP8LAIawsnstwzyVM5qxyxmgQ53ZvuxBaDs5LJSJVMLllpfKwT6rTIrOmnOU7vKgLECuUZMvYXX4/SwT7bhaxFeytGjGLSL74hbz/VKeaJTYVn4+JX5Tx08i2ibXQQeKe8Wmobg41EEk02j2zu4m3mJ7FfhQqy7QnTVIkq4gNwcWKadj12/XQZ0Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/12/2025 06:07, Baolin Wang wrote:
> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
> only clear the young flag and flush TLBs for PTEs within the contiguous range.
> To support batch PTE operations for other sized large folios in the following
> patches, adding a new parameter to specify the number of PTEs that map consecutive
> pages of the same large folio in a single VMA and a single page table.
> 
> While we are at it, rename the functions to maintain consistency with other
> contpte_*() functions.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/include/asm/pgtable.h | 12 ++++++------
>  arch/arm64/mm/contpte.c          | 33 ++++++++++++++++++--------------
>  2 files changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 445e18e92221..5e9ff16146c3 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1648,10 +1648,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>  extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep,
>  				unsigned int nr, int full);
> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);
> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>  extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, unsigned int nr);
>  extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> @@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_test_and_clear_young(vma, addr, ptep);
>  
> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, 1);
>  }
>  
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
> @@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_clear_flush_young(vma, addr, ptep);
>  
> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>  }
>  
>  #define wrprotect_ptes wrprotect_ptes
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index e4ddeb46f25d..b929a455103f 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -508,8 +508,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  }
>  EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>  
> -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> -					unsigned long addr, pte_t *ptep)
> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +					unsigned long addr, pte_t *ptep,
> +					unsigned int nr)
>  {
>  	/*
>  	 * ptep_clear_flush_young() technically requires us to clear the access
> @@ -518,41 +519,45 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	 * contig range when the range is covered by a single folio, we can get
>  	 * away with clearing young for the whole contig range here, so we avoid
>  	 * having to unfold.
> +	 *
> +	 * The 'nr' means consecutive (present) PTEs that map consecutive pages
> +	 * of the same large folio in a single VMA and a single page table.
>  	 */
>  
> +	unsigned long end = addr + nr * PAGE_SIZE;
>  	int young = 0;
> -	int i;
>  
> -	ptep = contpte_align_down(ptep);
> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> -
> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> +	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
> +	for (; addr != end; ptep++, addr += PAGE_SIZE)
>  		young |= __ptep_test_and_clear_young(vma, addr, ptep);
>  
>  	return young;
>  }
> -EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
> +EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
>  
> -int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> -					unsigned long addr, pte_t *ptep)
> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep,
> +				unsigned int nr)
>  {
>  	int young;
>  
> -	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
> +	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>  
>  	if (young) {
> +		unsigned long end = addr + nr * PAGE_SIZE;
> +
> +		contpte_align_addr_ptep(&addr, &end, ptep, nr);
>  		/*
>  		 * See comment in __ptep_clear_flush_young(); same rationale for
>  		 * eliding the trailing DSB applies here.
>  		 */
> -		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> -		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
> +		__flush_tlb_range_nosync(vma->vm_mm, addr, end,
>  					 PAGE_SIZE, true, 3);
>  	}
>  
>  	return young;
>  }
> -EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
> +EXPORT_SYMBOL_GPL(contpte_clear_flush_young_ptes);
>  
>  void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  					pte_t *ptep, unsigned int nr)


