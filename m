Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E6CEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059516B00AC; Tue,  7 Jul 2026 10:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031556B00AD; Tue,  7 Jul 2026 10:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E650F6B00AE; Tue,  7 Jul 2026 10:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0DCA6B00AC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:15:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DED81C745E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:15:57 +0000 (UTC)
X-FDA: 84962179554.02.E542B29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7ACD20002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:15:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LTM7/J/L";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783433755;
	b=Efh2Z0+/IWrZLitnXwQQdGn4QtqEa7IR0f7sivU5pRI7uUZoXEvuomLAFaN7j4DDPQjXPJ
	5/Wtwp9n+/AgjghAN7KRSEzjRWxicM3I9E1iCSQIEXYGXVLErC+rUR7asBenohjDGqlNaS
	L3znVTBnWvTzkIYF2xAe3Dvef6QqEek=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LTM7/J/L";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783433755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Je8n/wdoymxGQHenCCf7yyFcACysXlS+ymbtqKSEW8=;
	b=0zmHrjAvBrebBVGt1f8ZLxsML543IhsRO6Exd41maEgrEwI4SQk02dFheM8nXkCcvhSZPX
	N2QPw4+fk4Q6LryhkpBQOJmXYVXjPTCxwAZtpPVxYXI6ITxnhu8oj2pOrJYQnh0nXXPenA
	im8N2B+wfS3zDAESbK06etcQJUO7JRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B75E600BB;
	Tue,  7 Jul 2026 14:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00141F000E9;
	Tue,  7 Jul 2026 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433755;
	bh=3Je8n/wdoymxGQHenCCf7yyFcACysXlS+ymbtqKSEW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LTM7/J/LZeFUkiA0UYeYqmXv6kZhSrg7UVhYi52Mqw+clZlr+5XAvWHRjhC3+Q1Iz
	 XLHdtDiil/mdzgCMRMzXfIDAxR9KEUp3AvBHbtYBFEbWUGB7wO12i5qNR6+dpsk1uH
	 h4DKuXuFnGDRDBNVjcOQ0VISHnbVncUw/dOiXAXJcrnRNmsOKQ1r+IRQQOVpC419c4
	 vMN8mrOM6xmyG5zCcTDW3twLwjtRPJnffTmxLtoXCakesDSMeU6+hNahJLZwhsW3ga
	 +o+xiytDm2FUF5ZkfKzjsDkWc7FzPRp/ssBuZPFHp1t6OAIQ8pfwYADa8O8Ay4VBKJ
	 jcDX407DgCQ0Q==
Message-ID: <a54ca48f-c776-4b4a-9697-1c2170cb420b@kernel.org>
Date: Tue, 7 Jul 2026 16:15:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707121128.373192-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C7ACD20002
X-Stat-Signature: wppy3oex3ybmuho7mm396nhwja9jeqhr
X-HE-Tag: 1783433755-339643
X-HE-Meta: U2FsdGVkX1/7NZiHs6EVuqODKh40rMfgBqGMwJNZyGHoBMIIPPrykAA5C18oo6xvD1DPpdNQnm8mWq7w3/Hs+uQsDXsyEjyDmPRZv7blRXVJ3H6WiWaomVBC/WiQa+lWpQ4bqEI139QeifkR8H+zE/HK6ua2cDD2PsRrr/bJXR3CwbRr4ZQouLVWYcxUFR+wJeFrs2aW7DfdREvxRKsANR9Bwt3W8Akv3zJk2rliA51od/z5h3UTyVPrXjty2O9KfWGi8u/xYW4OnfTcGQBA5WUWmsH7mk2C9vZG+lU+Un5TvcKhjUxMx77nmaT3hAYakxmrQXhvKd6wOXdb69+WKHoRJf0sz56igDmpOMB7kybAT7qhI7EX9SQKuh9+6R+cdAMVFRqG4RaYa6tV5kH7w2ZSNNaMaDHdCayKUA6n1jQjOLvLhzo4LYxLtz96CwGnWyXKpXtXr8UPRwYIpXiSRdj761t/3kgZrLdWB4/8gD8hA79NwdKYE1l6xFPHEqtNH/03EGMBKgDc+83sPYeW2OUd1/uVbePZdmCbTUNPU/2r19742E+TaQVRSeKho8vIBQkNI8AUiSBZP9+M1S3GXYcomkHFOOihwxD9yaQnyrMslpqvmay2mKgGJsig8kxYCHklxI3PNfwpMpsXaMSTxAshSPrvFXPnh7Qsrqcp6izPkJU8lamGxnYcjNkDSPSp/F1u2hUC22S/QnJy4p4h+gs8bBR1v6rJMczOPxAREHF5cwCzdbxSLQBE2PjWPEUupz6aoz67e3E6+os+CBToDQchl7IO10fF4OiNuUxTzQMs+Q1yqe+cTtKZakwQDGGpS1VDmpCAsSiWMcblT5dT9c+NcbaNIKHt7COLAe89hWMdCoH4ESouZgs6ME0GGW9iiC+r8WnyRT1F/vihj3hIb9vO+IR0jiRHWLTTPEjZM5kz4R7FVXe1RTjJ1JMoghR93bK2n36KJ2DCmx+pGUA
 wt1zuydI
 AgIfg+BiA1K5N48M0tydv//Z/o5bYUJ1av+plJciqruHKTeSMevBmfKgULxEjdAhTTaPyNn8Fh6xddhG9TA81R6hPMQ1QpcDkXK5igFgngqK7sPqLqqhbf6IqDnKQ9gspCZzM5QyHKa2F5Ts8m7EYmB9JUmEXGz3GVtVKjF1AjXOvWD99+SfzxOViAL0CUD8Vu+Pc0Oc6Qxeub+2uWy574dkG4wtUUQiBsMwutMZq50A40DLP+y0zO5IH5vrsnqeti6L3ULk8LqQsDfCVxM1G4VLLDFv2gSE4iL82EBvIF6Lm23WiVYbLtI0e6QLpVPpP0fbcnocH97ex0dAoCMwimQ7ZhSfUsEVru6dH0Nlvzq9/DA5oHK9PaSJz5Fbv49/S5G9MVrBH8GcEz+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 14:11, Dev Jain wrote:
> Simplify try_to_unmap_one() by separating the hugetlb parts into
> try_to_unmap_hugetlb_one().
> 
> To understand the correctness of the refactoring, the following points
> are noted:
> 
> 1. try_to_unmap() is called for hugetlb folios only when they are
>    hwpoisoned.
> 
> 2. A hugetlb VMA cannot be mlocked.
> 
> 3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
>    and that mapping points at the head PFN.
> 
> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>    hugetlb folios are never swapped out, migration entries will be
>    skipped (PVMW_MIGRATION not passed), and device-exclusive does not
>    work for hugetlb.
> 
> 5. The hwpoison entry is constructed from the poisoned folio, just as in
>    the pre-refactor code. Any previous uffd-wp state is deliberately not
>    preserved for the hwpoison entry.
> 
> 6. TTU_HWPOISON is always present; for it to not be present, either the
>    folio has to be in swapcache, or mapping_can_writeback() is true (see
>    unmap_poisoned_folio), none of which is true for hugetlb folios.
> 
> 7. Hugetlb uses separate counters from normal rss counters, therefore
>    update_highwater_rss() need not be called.
> 
> While at it:
> 
>  - Change VM_BUG_* to VM_WARN_*.
> 
>  - Do not declare variables which are only used once.
> 
>  - Use huge_pte_dirty() instead of pte_dirty().
> 
>  - Add 3 VM_WARN_ON_ONCE asserting that TTU_HWPOISON should be present,
>    pte_present() must be true, and the pfn derived from the huge pte
>    must be that of the head of the hugetlb folio.
> 
> Except the BUG->WARN change, no functional change intended.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/hugetlb.h |   1 +
>  mm/rmap.c               | 177 +++++++++++++++++++++-------------------
>  2 files changed, 96 insertions(+), 82 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 4115076e4922a..bf7e163e3779d 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1271,6 +1271,7 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>  }
>  
>  pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
> +unsigned long huge_pte_dirty(pte_t pte);
>  
>  static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>  					  unsigned long addr, pte_t *ptep)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index dbb077f8443e3..934773dfa2f2a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,95 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>  
> +static bool try_to_unmap_hugetlb_one(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long address, void *arg)
> +{
> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
> +	struct mmu_notifier_range range;
> +	enum ttu_flags flags = (enum ttu_flags)(long)arg;
> +	struct mm_struct *mm = vma->vm_mm;
> +	const unsigned long hsz = huge_page_size(hstate_vma(vma));

I would move const variables all the way up.

> +	bool ret = true;
> +	pte_t pteval;
> +
> +	/*
> +	 * The try_to_unmap() is only passed a hugetlb folio in the case
> +	 * where the hugetlb folio is poisoned.
> +	 */
> +	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
> +	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
> +
> +	range.end = vma_address_end(&pvmw);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
> +				address, range.end);
> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> +	mmu_notifier_invalidate_range_start(&range);
> +
> +	/* There is only a single mapping in a VMA. */
> +	if (!page_vma_mapped_walk(&pvmw))
> +		goto range_end;
> +
> +	address = pvmw.address;

Will address ever change due to the page_vma_mapped_walk()? I don't think so, right?

So this can instead become a VM_WARN_ON_ONCE, maybe?



Nothing else jumped at me, much clearer to me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

