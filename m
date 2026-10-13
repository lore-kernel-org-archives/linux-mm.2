Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B22CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16446B0088; Tue, 13 Oct 2026 06:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6A66B008A; Tue, 13 Oct 2026 06:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC2C6B0095; Tue, 13 Oct 2026 06:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 863E46B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:13:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D096A8945
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:13:51 +0000 (UTC)
X-FDA: 85317191862.23.35680D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4CF971C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:13:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="vPt/TJBM";
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791886429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sg9zQ3+1NXirYIMG+ufMcNkrCdzyTyKdW+px0R/cpwI=;
	b=ApKvI5pMDyZw0wGFLFNKUZeF10NQqvV1In5tpVZr1HepnArXjOR9+WqZruWKWJ6XAvYDs8
	tTjnWF/if9AvJ//WU/KAxBCdYN7HzNJDa9vk0prkZl0ogeX7cIy9/JiuGSD8en6qeTuKXa
	SZjHvwXyDVfgzYTDcNAuJRx+oEG9IIM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791886429;
	b=2aCctEEUCC6kdAglx5gz0c1HAshHdtodPLDP4LX3aWkDmOLb4A7FQEZvIFfi6uNrrqzi8e
	VFmFhMFPAx+f8JG4hbrFNuQQzSAf9uLmaKJacQnp6N+JgAbEOxAfGZGwojo7yiKQSWapHg
	OMxcf91DwLB8nBuTG7TPTu/4qE36pAA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="vPt/TJBM";
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A0C4169C;
	Tue, 13 Oct 2026 03:13:45 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE6393F7B4;
	Tue, 13 Oct 2026 03:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791886428; bh=frG0so7TQeI6J8IN5+TVXwZehcv6LBDQHtosnjB44ng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vPt/TJBM5bSkHglczz78hY7BXD6SECatQcMU54W0ej74QhW76cpEiJFbPOEw8K7JU
	 WqyxnjPkS4K6NPE26B912TQjoDzXTTsDExrMgBstckn+8MUOIndkJq14UA0k5lNrJl
	 ao3zLpmO6rM7bJBP3j5Np6l8ehJV6OeOT6g0fdYo=
Message-ID: <6a10b61f-5c4f-4d04-9742-97a358147c39@arm.com>
Date: Tue, 13 Oct 2026 15:43:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Zhao Gongyi <zhaogongyi@bytedance.com>, catalin.marinas@arm.com,
 will@kernel.org
Cc: ryan.roberts@arm.com, baolin.wang@linux.alibaba.com,
 lance.yang@linux.dev, mark.rutland@arm.com, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261013093600.54995-1-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4CF971C0004
X-Stat-Signature: r58cafwift7ytb3citr6kf7uuacq8fts
X-HE-Tag: 1791886429-401883
X-HE-Meta: U2FsdGVkX19r4zq8UEkp4h35RoOjXmxJ9SJ1vqzbowr71IB/SQChGMqM0U9Fnb7Bufmmjv50B81v1E61YkcnJTNdzUlYJnY74kXrzbWc8K1tPKEJ78UWP2MQPtMSlEeARUu/Pe7VJgdH8SjfZLXuDcGGvy0Dm4WGgD8G8OWCJWsimzG3wscjO85t9/ihugNztKubOGFxueRZV+jKFCy9WG5kzeKAsB+J4aizZzuOQJu7N3H6piysGSKWGiyDUyq97OeYwR+h+o02GnCNrwDaR2Mt17DGfXKQntX/jtRZt9u3FS3SsHgxts+MjJeWy46ejtZGemTV4GDOkpXk2/rvlkQyRFRqLkOv1VglkdVv48KNc3q+Pb65V+tsqhDUhY7+ylvd6ihMZe/Nc8/83SWyR9ueIsJ6hZoyM+AnIkYr+G2YXn/KrwQk4iFiizM7W73lnbI6Jlx7kJOKbyZREJ5NSbhJuX7AAIOMxh0Bhk8V8O8Xe3wgtfMvoqNtr56r5N+Ah0RDGAEFOa16JpsMnOflyTFv2gaXBsy7i7nHgUrbtrtmkQz/uoCJtqW52N3W26Fo/Amq9Ey3gUUrRtgzPGs4xNqSxv/78DJN3LbJYGCVxMXkesaSKjzFGcbCX41isz0iegVumrSv9BFwcr1S3TRsmwV1GQOyLHo6TedtOjIPoTx9fcQY5qUq+qEYfB3otuTYwAjD0FxIwN98sgZXHvfiMaROcUFnjjmMNvm6fBdUlhUYP/n4l84cMVR8ib5//mAUweV5ASlqh9R/HC3i9gGIGpntE0CSxtyCVAGXziCZub60hCUh0x8QsmW74h0EhNqDqgE6pswaW+Jk95jh3/ENOKPNoicctsVpf8nC6dzeHf/+Y41RXCm6muBQ0olS0ykUlmuDt2UT13VntCwVZLJ5l9dbu74KSYRimovVC0uklxT7b7Q2HD2phUEQUy4+Ca4wGpUfF5cAzWW7ZNJjrLs
 zcWOC7Fn
 EtCvXTOGmH5dqNIN4QtbhKlGihQvfWm/6ybnnHS5cFtKpsOTxjMu7TAxhMKOK/+DdAmggr8lHj+gZX0Dc7hPIwhOiv7vJIcYnawKXXsQPUBBbPk/hQtieQzZhBM9sX/7ZiqA7mAbWQ0Zq1j2WpyOTTiv7if2J9dV90hyjHWC4VFQe1amDfMPd8GdlS+F/gleRqbRaGL+2MDmF27dP82Ee4eUzS1bbggmCwBKi17vLeyez6CVA/7S112wOTFYOWM63+ORGZ8ozrHfJHBQec+oMGtbGLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/10/26 3:06 pm, Zhao Gongyi wrote:
> The transparent contpte layer treats PTE_CONT as software state: when a
> PTE has PTE_CONT set, the contpte helpers may align the operation to a
> CONT_PTE_SIZE block and operate on the whole block. That invariant only
> makes sense for valid mappings. Explicit users such as hugetlb manage
> their contiguous encodings separately.
> 
> contpte_set_ptes() currently sets PTE_CONT from alignment alone. Batched
> set_ptes() users can therefore install present-invalid PTEs with
> PTE_CONT set, for example mprotect(PROT_NONE), NUMA hinting through
> modify_prot_commit_ptes(), fork() copying a PROT_NONE large folio, or a
> PMD split installing PAGE_NONE PTEs.
> 
> This is not a hardware programming problem: invalid descriptors are not
> translated, so the hardware ignores descriptor bits such as PTE_CONT. It
> is a software-state problem. Some arm64 fast paths intentionally test
> pte_cont() directly instead of pte_valid_cont(), for example commit
> 9970a9a27ffc ("arm64: mm: implement the architecture-specific
> test_and_clear_young_ptes()"). Fixing the producer side preserves these
> fast paths and covers all consumers.
> 
> In the observed failure, mprotect(PROT_NONE) installed a full
> CONT_PTE_SIZE range of present-invalid PTEs with PTE_CONT set.
> MADV_GUARD_INSTALL then zapped one PTE. The nr == 1 clear_full_ptes()
> path only unfolds pte_valid_cont() entries, so the neighbouring
> present-invalid entries kept PTE_CONT while the target entry became a
> guard marker.
> 
> clear_refs_pte_range() then reached the marker through:
> 
>   ptep_test_and_clear_young()
>   test_and_clear_young_ptes()
>   contpte_test_and_clear_young_ptes()
>   contpte_align_addr_ptep()
>   __ptep_test_and_clear_young()
> 
> The marker changed from old_pte=0x00000000000047c0 to
> new_pte=0x00000000000043c0 by clearing PTE_AF. For swap PTEs, bit 10 is
> part of the swap type field, bits 6-10: 0x47c0 is SWP_PTE_MARKER with
> offset 4, while 0x43c0 has type 15 and is decoded as an ordinary swap
> entry. Zap later warned in swap_put_entries_direct() with a bad swap
> entry.
> 
> This is triggerable by a user process against its own address space. On
> systems running with panic_on_warn, the warning becomes a denial of
> service.
> 
> Fix the root cause by making contpte_set_ptes() use the transparent
> contpte encoding only for valid descriptors. After this change, the
> transparent contpte layer preserves the invariant that pte_cont(pte)
> implies pte_valid(pte), so fast consumers can keep using PTE_CONT as
> sufficient evidence of a transparent contpte block.
> 
> Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> ---
> Validation on an arm64 QEMU/KVM KASAN setup with CONFIG_ARM64_4K_PAGES=y
> and CONFIG_ARM64_CONTPTE=y, using an out-of-tree guard-region reproducer:
> 
>   populate a CONT_PTE_SIZE anonymous THP range
>   mprotect(PROT_NONE) on the range
>   MADV_GUARD_INSTALL on one PTE in that range
>   write "1" to /proc/self/clear_refs
>   restore access and remove the guard marker

Thanks, could you please give the code of the reproducer. That will
save us some time.


> 
>   Unfixed kernel: failed in the first iteration, with 65 bad swap
>                   messages and a WARNING in swap_put_entries_direct()
>   This patch:     completed 100 iterations without warnings
> 
> Additional producer-side instrumentation confirmed the same invalid
> batch state outside the mprotect reproducer:
> 
>   Unfixed fork():     copy_page_range() wrote out_cont=1
>   Unfixed PMD split: split_huge_pmd_locked() wrote out_cont=1
>   This patch:        both paths wrote out_cont=0
> 
>  arch/arm64/include/asm/pgtable.h | 5 ++++-
>  arch/arm64/mm/contpte.c          | 7 +++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 6000905a2..d6246042b 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1650,7 +1650,10 @@ extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long ad
>  /*
>   * The contpte APIs are used to transparently manage the contiguous bit in ptes
>   * where it is possible and makes sense to do so. The PTE_CONT bit is considered
> - * a private implementation detail of the public ptep API (see below).
> + * a private implementation detail of the public ptep API (see below). The
> + * transparent contpte layer maintains the invariant that pte_cont(pte) implies
> + * pte_valid(pte); explicit contiguous-encoding users such as hugetlb manage
> + * their entries separately.
>   */
>  extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, pte_t pte);
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index 0acab179f..851fa2e44 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -463,6 +463,13 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
>  	if (!mm_is_user(mm))
>  		return __set_ptes(mm, addr, ptep, pte, nr);
>  
> +	/*
> +	 * Keep the producer-side invariant documented in pgtable.h true even
> +	 * if a direct caller passes an invalid descriptor with PTE_CONT set.
> +	 */
> +	if (!pte_valid(pte))
> +		return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
> +
>  	end = addr + (nr << PAGE_SHIFT);
>  	pfn = pte_pfn(pte);
>  	prot = pte_pgprot(pte);


