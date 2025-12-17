Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4088AD65C6C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4FA6B008A; Wed, 17 Dec 2025 10:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2BB6B008C; Wed, 17 Dec 2025 10:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE686B0092; Wed, 17 Dec 2025 10:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7816B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:43:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0061D13710A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:43:48 +0000 (UTC)
X-FDA: 84229383336.04.B5F41BF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 297368001A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:43:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765986227; a=rsa-sha256;
	cv=none;
	b=JBPN4IWJFMHO8EC6i+8biyglgqVkQ7rqLMnbRASLBtZfr2tHGcH7LV8gw6hMmL8Q/ALmOw
	t5vdmSoT6R+CT9oU7es0guWl+YibFogsEmaXySGxik8qDL2o7GtSbbtAr9vOZonNmA6M0v
	Fokp4mRqRaphu/lB29Qu0tdJyIWaYcw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765986227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abdvEQJkynthqL8sHDVp2505J170tCfnRSLgiNHWyus=;
	b=dhK5hTkb0SGbnt8U1zf1+M1BNCJ7wPzuoCpKJnjPdIhhdIuN/3wfVfPwUPECziQDAJ84a/
	LTubxLYO03f0iEQ0aE2Z2RS6iDMyNM/XIUXjqzydcmTG0u5kqY+aYZIbx2IuQ6KhUhrTPO
	0bFxh8ZziMgU+WQin73R400Fs6zgBwI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DAC5FEC;
	Wed, 17 Dec 2025 07:43:39 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03E363F73F;
	Wed, 17 Dec 2025 07:43:42 -0800 (PST)
Message-ID: <1beaa7de-4b31-4f19-abee-83872f868e28@arm.com>
Date: Wed, 17 Dec 2025 15:43:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 297368001A
X-Rspamd-Server: rspam04
X-Stat-Signature: 3fg7hwq6g38tc6ub9nfrkbc7emkxenim
X-HE-Tag: 1765986226-232616
X-HE-Meta: U2FsdGVkX1/COYCbq1uHRnJsG5ysNKnrJxOe4tgBvOPKdayhUeaKZBvyW8MuiQzjCetog8FgPN3gFsfgUjmU8bgTlFu8NL28RKez54Dq5JyRkafrINJPxEbKbqs14QVwWJqEE2zN0l2cnQwW4pCOMuijs/x1VvGi7Mxm1Fn7XyKSq6OZ1ttttduJu2Lf8l/G16T94deKA8yUdIk2AHUaQquUqRotHtc+mRvvJ3jvB5c/MUKt01wH3YN8VDZhL6IrQvIHPbj3clUUQpM6V6duhNjN4Kc9dk7jA1924Fqt/eu44K2iSYBLiyxVeFqYx3PL5Mk01a8P6lDQ+TCMQnDYtmLpMTkKrlgqd+KT30ZPFG6gYRsKLOgl9z+y72qafLDtlgtbR2fd3Ptnf47erIP1SrSYvVB/KaaDOg4hrwE5ew9n9tZLNIfrrSlajN01lyCB4L6ilvxwbb8sF4XiGoUEYWAph9zrMJ6IlmFsHZWAQztVLXzvvPrxYE1Qv/eS7dQN63UaHNLrUWZUXdUiEzYLhrrHw19NXFViXnvjVlO6OTkseM9icSGwIok1q/R7A78Xl1bI1A9uOGRP1xlVEU+nJajufT4b0wFWdphlA37BCswKxeGBlu6XEno14IeJRf5jQpvvgbdGakuU1OQ0SxTz1TnLtP/BOTtiKGjAACWfnH2Qi6tZu+I+Pmw+EccoWK+gjxp7rNJeHvg67hnS/BIfBF/ObSqsWBEEY0MGZGRHX0WTgq4DlPQcLLrhZveCDjnKJccmMqzX+Tdbf1fjlJY+R+y3YGpYd9ox51fLBI5jN1735TD7730RBp1J5mrNCqwXRn+tvVKelvDCmwFosrlhQ0u6e/CiMJxJOmPH89nJpWf59hm5q6HLu+rPosTnOt/O9O5meWHsbXBsHvSihQEJn5BdLwGk1iSFJvqv/D16YaFjpLpcb1U6Nav5miqQ1hGLHL6aJlCpidDY9mO0zap
 qftEi2P/
 wqwkJ8nRHT6Ug/y1YX1RfzefgdpxtWmmpjv7//DAm/E9TiveJCmgZULUFwyKHksl72Sa6tYKbUMRoueGLJRm0+CtmAW+vjhipqDUSt0ww4fxKGUoBbmTkJ1PMdphSRMDvE0diJGotfO08VLyPjkBo1+ESFah8lWsee2hmNEMDMmlrSCQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry I'm a bit late to the party...


On 11/12/2025 08:16, Baolin Wang wrote:
> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
> only clear the young flag and flush TLBs for PTEs within the contiguous range.
> To support batch PTE operations for other sized large folios in the following
> patches, adding a new parameter to specify the number of PTEs.
> 
> While we are at it, rename the functions to maintain consistency with other
> contpte_*() functions.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 12 ++++-----
>  arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>  2 files changed, 37 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 0944e296dd4a..e03034683156 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>  extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep,
>  				unsigned int nr, int full);
> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);
> +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);

The "contpte_" functions are intended to be private to the arm64 arch and should
be exposed via the generic APIs. But I don't see any generic batched API for
this, so you're only actually able to pass CONT_PTES as nr. Perhaps you're
planning to define "test_and_clear_young_ptes()" and "clear_flush_young_ptes()"
in later patches?

>  extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, unsigned int nr);
>  extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_test_and_clear_young(vma, addr, ptep);
>  
> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>  }
>  
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
> @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_clear_flush_young(vma, addr, ptep);
>  
> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>  }
>  
>  #define wrprotect_ptes wrprotect_ptes
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index c0557945939c..19b122441be3 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
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
> @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	 * having to unfold.
>  	 */
>  
> +	unsigned long start = addr;

Personally I wouldn't bother defining start - just reuse addr. You're
incrementing start in the below loop, so it's more appropriate to call it addr
anyway.

> +	unsigned long end = start + nr * PAGE_SIZE;
>  	int young = 0;
>  	int i;
>  
> -	ptep = contpte_align_down(ptep);
> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> +	if (pte_cont(__ptep_get(ptep + nr - 1)))
> +		end = ALIGN(end, CONT_PTE_SIZE);
>  
> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
> +	if (pte_cont(__ptep_get(ptep))) {
> +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
> +		ptep = contpte_align_down(ptep);
> +	}
> +
> +	nr = (end - start) / PAGE_SIZE;
> +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)

Given you're now defining end, perhaps we don't need nr?

	for (; addr != end; ptep++, addr += PAGE_SIZE)
		young |= __ptep_test_and_clear_young(vma, addr, ptep);

> +		young |= __ptep_test_and_clear_young(vma, start, ptep);
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
> +		unsigned long start = addr;
> +		unsigned long end = start + nr * PAGE_SIZE;
> +
> +		if (pte_cont(__ptep_get(ptep + nr - 1)))
> +			end = ALIGN(end, CONT_PTE_SIZE);
> +
> +		if (pte_cont(__ptep_get(ptep)))
> +			start = ALIGN_DOWN(start, CONT_PTE_SIZE);
> +

We now have this pattern of expanding contpte blocks up and down in 3 places.
Perhaps create a helper?

Thanks,
Ryan

>  		/*
>  		 * See comment in __ptep_clear_flush_young(); same rationale for
>  		 * eliding the trailing DSB applies here.
>  		 */
> -		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> -		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
> +		__flush_tlb_range_nosync(vma->vm_mm, start, end,
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


