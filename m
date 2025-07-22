Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F23C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420896B00A7; Tue, 22 Jul 2025 07:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8106B00A8; Tue, 22 Jul 2025 07:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334EB6B00A9; Tue, 22 Jul 2025 07:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 235AF6B00A7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:35:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDD0E140364
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:35:08 +0000 (UTC)
X-FDA: 83691694296.17.2AA18C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 245B81C000A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:35:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753184107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rCLpGdWUS8REAwOwDqtj2Tc6HRfOgEsVFR54SmJidZ8=;
	b=hGx57Q8+pXCe/D2/D7fiskbn26LSZalP0ASh0TOvEImWzbWxkyxCxZoF/oaGY0TrKJKtBv
	xE948oLX81ZqaeB8aipMJlJT9gwq2ItmLcc79O4LXI5xgs/v32nX+t3qBXO4UNohQQdAeU
	pW0IuxHxk8V5Je2y7YrC/KO1SD+VA1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753184107; a=rsa-sha256;
	cv=none;
	b=iObezRbzJ2GHVSdnk5ZVHVJJOqCntnjn5SOhP6t0zFMiKIe5a9pq7WfKIsTsdhnoP258Uj
	QnsD9r3yh3E6yT0c5mKa9PTC46S0ObXtNg6Og8oy+C769dGjLusRx8SjVGmT21rst7nFv7
	/js5AuMekCdi1YH2eX1z46HEBMcAFxc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8A33152B;
	Tue, 22 Jul 2025 04:35:00 -0700 (PDT)
Received: from [10.1.30.167] (XHFQ2J9959.cambridge.arm.com [10.1.30.167])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6488A3F66E;
	Tue, 22 Jul 2025 04:35:03 -0700 (PDT)
Message-ID: <8f375e61-1a6d-4d9c-8980-849c0ab29063@arm.com>
Date: Tue, 22 Jul 2025 12:35:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] mm: Add batched versions of
 ptep_modify_prot_start/commit
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: david@redhat.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-4-dev.jain@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250718090244.21092-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 245B81C000A
X-Stat-Signature: pc1s96x4j851pbyhnd4hd77fsg4d6p3s
X-Rspam-User: 
X-HE-Tag: 1753184106-601433
X-HE-Meta: U2FsdGVkX18lDZTnJUAvaLofjJKBraQjNZ1vxqKgJT8qKdp3I364Nl56jyQoeMm/G+JDe1ffLPckaaFuOzBuF9KxazbvJHYpmE0nvH2wZ+kzeMpYFZ1p1sNuWZkueLDQu4hHDblPC3pEJiBA7W36MAEyD0H8iRvBFf3qfzwDNCwszrMnTLI83Nfi/eT24v9V1KetD5qEK/jf13UUk8bVC3v8s6dF6EaJNOWVe/elWPYVGxday5YjWI0YtTc6XvZiH7S/xNWSUswaCeO6weuuP9mXGe9hXgqSv3m+p0pNJ/CAJvoV3PO4/0dhJ+/QOpR9V3SzJiB9/8Ou6U8ueKbdlleKwT2wK/ZQffnlYm1i4UoskTkxLnrH9xJk72THKeV2LoH8Mn23PIpkEQjHFk2I2r1KFvklHVGASSoydLzDoVFRbQtMAIL1wOEsiyo875Tj/Or646n8PaeBt5DJ8oQExr1lzU9oK5YmUdQZRTKztZcw6FYwoRkkT2KS3Favurpbr/vPLWWrQfHzcQ9f+09dtwxxw4pGndWbzPL9tRmT38oIEso7AD4CtemUELdlQGzhujoIjiTKHso1mLdcE1KuMMTpVsYaHC3mQrvQzNBcbgeRCJRVktIrUkcO37zKglNhrM7auEgff/tDuk7rmnlLUUAfjdmF8wY34j6vrt+ZOze7pZRIxTpkDh6BqUwS0xPOdzUZe9ZqBatClQ4wn+//ZVvc4FECP5MtkYilkMLXtquwTfb4uciDuOSKxC8InYDEW6SqAXsQzu5qYLN0QOit4M7QO7t55KqDDThkHg57haoqYPx4L2lH/4iYtP397EdG2o6S38KXNgN4a8nTMzcO36xh78rwbHtWxsEiG7Sn/F5iiUVDGo3iA4ecHZ98Y+MZY+IYnEf4NC5qvveiYIDTabMeYJeT5f8jt05eLBJkBi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/07/2025 10:02, Dev Jain wrote:
> Batch ptep_modify_prot_start/commit in preparation for optimizing mprotect,
> implementing them as a simple loop over the corresponding single pte
> helpers. Architecture may override these helpers.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  include/linux/pgtable.h | 84 ++++++++++++++++++++++++++++++++++++++++-
>  mm/mprotect.c           |  4 +-
>  2 files changed, 85 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index cf1515c163e2..e3b99920be05 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1331,7 +1331,9 @@ static inline pte_t ptep_modify_prot_start(struct vm_area_struct *vma,
>  
>  /*
>   * Commit an update to a pte, leaving any hardware-controlled bits in
> - * the PTE unmodified.
> + * the PTE unmodified. The pte returned from ptep_modify_prot_start() may
> + * additionally have young and/or dirty bits set where previously they were not,
> + * so the updated pte may have these additional changes.

nit: I still find this difficult to parse (Although I expect you might tell me
that this is the text I suggested last time around :) ). I think you mean that
"it is permissable for young and/or dirty bits to be set in old_pte, despite
beling clear when originally returned by ptep_modify_prot_start()".

Anyway, no big deal. I think we all know what it's getting at.

Thanks,
Ryan


>   */
>  static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
>  					   unsigned long addr,
> @@ -1340,6 +1342,86 @@ static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
>  	__ptep_modify_prot_commit(vma, addr, ptep, pte);
>  }
>  #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
> +
> +/**
> + * modify_prot_start_ptes - Start a pte protection read-modify-write transaction
> + * over a batch of ptes, which protects against asynchronous hardware
> + * modifications to the ptes. The intention is not to prevent the hardware from
> + * making pte updates, but to prevent any updates it may make from being lost.
> + * Please see the comment above ptep_modify_prot_start() for full description.
> + *
> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @nr: Number of entries.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a simple
> + * loop over ptep_modify_prot_start(), collecting the a/d bits from each pte
> + * in the batch.
> + *
> + * Note that PTE bits in the PTE batch besides the PFN can differ.
> + *
> + * Context: The caller holds the page table lock.  The PTEs map consecutive
> + * pages that belong to the same folio. All other PTE bits must be identical for
> + * all PTEs in the batch except for young and dirty bits.  The PTEs are all in
> + * the same PMD.
> + */
> +#ifndef modify_prot_start_ptes
> +static inline pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
> +		unsigned long addr, pte_t *ptep, unsigned int nr)
> +{
> +	pte_t pte, tmp_pte;
> +
> +	pte = ptep_modify_prot_start(vma, addr, ptep);
> +	while (--nr) {
> +		ptep++;
> +		addr += PAGE_SIZE;
> +		tmp_pte = ptep_modify_prot_start(vma, addr, ptep);
> +		if (pte_dirty(tmp_pte))
> +			pte = pte_mkdirty(pte);
> +		if (pte_young(tmp_pte))
> +			pte = pte_mkyoung(pte);
> +	}
> +	return pte;
> +}
> +#endif
> +
> +/**
> + * modify_prot_commit_ptes - Commit an update to a batch of ptes, leaving any
> + * hardware-controlled bits in the PTE unmodified.
> + *
> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @old_pte: Old page table entry (for the first entry) which is now cleared.
> + * @pte: New page table entry to be set.
> + * @nr: Number of entries.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a simple
> + * loop over ptep_modify_prot_commit().
> + *
> + * Context: The caller holds the page table lock. The PTEs are all in the same
> + * PMD. On exit, the set ptes in the batch map the same folio. The ptes set by
> + * ptep_modify_prot_start() may additionally have young and/or dirty bits set
> + * where previously they were not, so the updated ptes may have these
> + * additional changes.
> + */
> +#ifndef modify_prot_commit_ptes
> +static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
> +		pte_t *ptep, pte_t old_pte, pte_t pte, unsigned int nr)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE) {
> +		ptep_modify_prot_commit(vma, addr, ptep, old_pte, pte);
> +
> +		/* Advance PFN only, set same prot */
> +		old_pte = pte_next_pfn(old_pte);
> +		pte = pte_next_pfn(pte);
> +	}
> +}
> +#endif
> +
>  #endif /* CONFIG_MMU */
>  
>  /*
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 97adc62c50ab..4977f198168e 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -204,7 +204,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				}
>  			}
>  
> -			oldpte = ptep_modify_prot_start(vma, addr, pte);
> +			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
>  			ptent = pte_modify(oldpte, newprot);
>  
>  			if (uffd_wp)
> @@ -230,7 +230,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			    can_change_pte_writable(vma, addr, ptent))
>  				ptent = pte_mkwrite(ptent, vma);
>  
> -			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
> +			modify_prot_commit_ptes(vma, addr, pte, oldpte, ptent, nr_ptes);
>  			if (pte_needs_flush(oldpte, ptent))
>  				tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
>  			pages++;


