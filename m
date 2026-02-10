Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CEEE94625
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AF76B0088; Mon,  9 Feb 2026 21:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38B36B008A; Mon,  9 Feb 2026 21:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B0A6B0092; Mon,  9 Feb 2026 21:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2D0B6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:01:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50FEC13A9E4
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:01:10 +0000 (UTC)
X-FDA: 84426894300.11.EAD4412
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id 829E71A000A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:01:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RzZNqhju;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770688868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQ50p2KNl3amfBot28o/Z8pfWvYK3Anb03Fg5LdckDw=;
	b=R/uVhjHeLwMmp098tJJqSksCtzYYHnjLBgMXoAOWD4PBwd0q1YNAbLH0eAE2Y8HF9+bxLR
	atb3AsdaNEUwm+ZQ+/YxCDqKk7EPakc4yIcFGJpf0kTuJ1H1OhnHk529RutUp8SfBWFXG5
	lFSAIQ0sgs/njUdkhgaRPEX0nQ6CAxw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RzZNqhju;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770688868; a=rsa-sha256;
	cv=none;
	b=APCu4Fp7B7w5AnbNntxEGtAxyWnolg3YYQE74KS0Vixdqw+CU7q8tGJLLOQI1uOLCwksnu
	Hkxn6OWHH2Pphd+uXgODcksd0goETxXm0g9PPLPmmmxr3A3sdTYrnHKYwLpsbR1Vn7mvtL
	/brPERO4LuXU6hMCKDkI2mPjHgbYgtc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770688864; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nQ50p2KNl3amfBot28o/Z8pfWvYK3Anb03Fg5LdckDw=;
	b=RzZNqhju5pPL81zVsYOXc4q7plI9vLbPuEYCl/qFt68nrkpAd17x1RZ3apS/vRbRhzyVXz4r5sgF3BqUfjklTRnsZW0s67BzD3bNpDcIq+2F7DVwtYCLzlPqyQo9ei8Ksbdr12wlfKY7Frq8gSTCk25M8lnyoBkhFXJYhe3STas=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyxHdcT_1770688862 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Feb 2026 10:01:03 +0800
Message-ID: <de69443f-8e0f-4d83-9f29-0b349ff682c8@linux.alibaba.com>
Date: Tue, 10 Feb 2026 10:01:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] support batch checking of references and unmapping
 for large folios
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <20260209175316.2ef64ee244599765a74a6975@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260209175316.2ef64ee244599765a74a6975@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 829E71A000A
X-Stat-Signature: 44zwx1tyg5efa3hspupkf4optfs3dx4q
X-Rspam-User: 
X-HE-Tag: 1770688866-551788
X-HE-Meta: U2FsdGVkX18I6KRa+x/Ht5oMHrbHSXGSRM7mjgE+YGR4g2QuFCYYGjCfb1O2nMimh0FaQmY7dJyVFS9xd1AZUz6jM4ChqA9To7XVuOQOHjgeqF/gsUzwxUF2Y2WDSAzkvodFHitZ5Zj0qMdvA42RUI4NIprmMlJetQzznTWDo3VSniSimXt9BlDr2ixZzl9kflzi2Z92EitXMnb/6o/gUw6tPUCkE+/aHOlC0RKj8FrPpmRpU0KKZ+0Dnum1mJRVlI7eB4XSOirXrbM2GPOya1k0NhJzZIeHXqTXxzG+r7CEzSEFeIUkc37iUpRt/FVxmN5+wBh2DjInXSCTpxB7OYp8qfvvroGxhLdfYccV1aOYCfN2TmPBENMs1iC30SXM/AA+7XoIZdbwu51pdhiaLBSieUn+VIGTFpDwnev0PvO6i5zW5R0ORbYKA/lcpTMbxIhSUgyqJnxXHKjeM92qiIhrVYw5qv/9I5XaLWSE1Rq3T5PEYGhUBivzlrc6M+HTJYi5VOnbq0QLc+4IpzTVhRpzkBcFUAiZDv2/LxZsbnC5ooMrAmcEL2/kabmwB+ogwGlJOocdYNIrYATB9xGQXdpGMP8VY7mmq7Rx7SGNcW8+n00zW6Hrpjsk599ce7pu2Xa0/DL5UFFT2AEYO+QnuHasJ3EFlSXOVO4l/xryqxoBl3QgEdM44AllBfLfX8ulzWxabiMnHyoFt35coAhbnS1H1vOmt08co0imcLxp/Lko2o2o237cBlajhZiEQ5Sd7gkQBP0Rg2V1rFWG5qp7mgdNvC4nrRaRmexBGYIeLeBkDnROXmEI91Ph2DEy5C8sVNXmcrR6AM3pW6TZRcHwaSwd5burdaewZYNtFGvBWfvcAI7kTDl822Pk2Q+58ba73HfWdGoctxFe8mXuqMUUEwB+nrELnfw5DRu40tvjIaCzjksT/ykmYJyiLT7YvTEpW/PP1HKqsrC6sM2sR1F
 TvTi5uZ3
 y3B4uWZRTR5kCVN5+KkeqUmLN1J96jGWsUBGeHKazrQBbyu3tN2I5RCqcz60HgKnLYABuFRNnn1SuUnR3xg61Wwqu7viJTBQ39nhNTKCqr1InphYGyKBQwrnAM0ZPB4QKHWB3xP5Yl4v3fr45HhjuMqIYp4DXvlErup5YY9zGxQ+7Uai1uTqfS4+qtHFg0LA0kBpQFAD3l3rKgbOBVXhzd0aFaRaF1ABLPgOdPDel0FSEyeK8BfLFZ1pLfbTrqHoa7Y3/cApHc87nLQqdwvHGh5y/UX1DUALVRBqV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 9:53 AM, Andrew Morton wrote:
> On Mon,  9 Feb 2026 22:07:23 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
>> Currently, folio_referenced_one() always checks the young flag for each PTE
>> sequentially, which is inefficient for large folios. This inefficiency is
>> especially noticeable when reclaiming clean file-backed large folios, where
>> folio_referenced() is observed as a significant performance hotspot.
>>
>> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
>> an optimization to clear the young flags for PTEs within a contiguous range.
>> However, this is not sufficient. We can extend this to perform batched operations
>> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
>>
>> Similar to folio_referenced_one(), we can also apply batched unmapping for large
>> file folios to optimize the performance of file folio reclamation. By supporting
>> batched checking of the young flags, flushing TLB entries, and unmapping, I can
>> observed a significant performance improvements in my performance tests for file
>> folios reclamation. Please check the performance data in the commit message of
>> each patch.
>>
> 
> Thanks, I updated mm.git to this version.  Below is how v6 altered
> mm.git.
> 
> I notice that this fix:
> 
> https://lore.kernel.org/all/de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com/T/#u
> 
> was not carried forward.  Was this deliberate?

Yes. After discussing with David[1], we believe the original patch is 
correct, so the 'fix' is unnecessary.

[1] 
https://lore.kernel.org/all/280ae63e-d66e-438f-8045-6c870420fe76@linux.alibaba.com/

The following diff looks good to me. Thanks.

> Also, regarding the 80-column tricks in folio_referenced_one(): we're
> allowed to do this ;)
> 
> 
> 				unsigned long end_addr;
> 				unsigned int max_nr;
> 
> 				end_addr = pmd_addr_end(address, vma->vm_end);
> 				max_nr = (end_addr - address) >> PAGE_SHIFT;
> 
> 
> 
> 
>   arch/arm64/include/asm/pgtable.h |    2 +-
>   include/linux/pgtable.h          |   16 ++++++++++------
>   mm/rmap.c                        |    9 +++------
>   3 files changed, 14 insertions(+), 13 deletions(-)
> 
> --- a/arch/arm64/include/asm/pgtable.h~b
> +++ a/arch/arm64/include/asm/pgtable.h
> @@ -1843,7 +1843,7 @@ static inline int clear_flush_young_ptes
>   					 unsigned long addr, pte_t *ptep,
>   					 unsigned int nr)
>   {
> -	if (likely(nr == 1 && !pte_valid_cont(__ptep_get(ptep))))
> +	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
>   		return __ptep_clear_flush_young(vma, addr, ptep);
>   
>   	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
> --- a/include/linux/pgtable.h~b
> +++ a/include/linux/pgtable.h
> @@ -1070,8 +1070,8 @@ static inline void wrprotect_ptes(struct
>   
>   #ifndef clear_flush_young_ptes
>   /**
> - * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
> - *			    that map consecutive pages of the same folio.
> + * clear_flush_young_ptes - Mark PTEs that map consecutive pages of the same
> + *			    folio as old and flush the TLB.
>    * @vma: The virtual memory area the pages are mapped into.
>    * @addr: Address the first page is mapped at.
>    * @ptep: Page table pointer for the first entry.
> @@ -1087,13 +1087,17 @@ static inline void wrprotect_ptes(struct
>    * pages that belong to the same folio.  The PTEs are all in the same PMD.
>    */
>   static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> -					 unsigned long addr, pte_t *ptep,
> -					 unsigned int nr)
> +		unsigned long addr, pte_t *ptep, unsigned int nr)
>   {
> -	int i, young = 0;
> +	int young = 0;
>   
> -	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
> +	for (;;) {
>   		young |= ptep_clear_flush_young(vma, addr, ptep);
> +		if (--nr == 0)
> +			break;
> +		ptep++;
> +		addr += PAGE_SIZE;
> +	}
>   
>   	return young;
>   }
> --- a/mm/rmap.c~b
> +++ a/mm/rmap.c
> @@ -963,10 +963,8 @@ static bool folio_referenced_one(struct
>   				referenced++;
>   		} else if (pvmw.pte) {
>   			if (folio_test_large(folio)) {
> -				unsigned long end_addr =
> -					pmd_addr_end(address, vma->vm_end);
> -				unsigned int max_nr =
> -					(end_addr - address) >> PAGE_SHIFT;
> +				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
> +				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
>   				pte_t pteval = ptep_get(pvmw.pte);
>   
>   				nr = folio_pte_batch(folio, pvmw.pte,
> @@ -974,8 +972,7 @@ static bool folio_referenced_one(struct
>   			}
>   
>   			ptes += nr;
> -			if (clear_flush_young_ptes_notify(vma, address,
> -						pvmw.pte, nr))
> +			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
>   				referenced++;
>   			/* Skip the batched PTEs */
>   			pvmw.pte += nr - 1;
> _


