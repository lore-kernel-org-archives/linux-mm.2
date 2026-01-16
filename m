Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E180D4A61D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8156B0088; Fri, 16 Jan 2026 04:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B986B0089; Fri, 16 Jan 2026 04:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8674C6B008A; Fri, 16 Jan 2026 04:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 743FB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:40:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D20B13B2E1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:42 +0000 (UTC)
X-FDA: 84337332324.10.9F3FBA3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id E2108180005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768556440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K9KD86vQIF+22WsOZV4FwgX8MRTUzVjyzO7kYR4hk8g=;
	b=EEB8fmg46TKgEL0t90V+nLyqAW2mwqeCquH4grvhfufaDRodJsuc+8xnWFCNptWOmZJFqJ
	+7CwLRLj7InXpJBlAF0VgvDIQE7iW5ExmZWIjfcs2pdVa0qSlw6iuE2MtAbY3lXjNr4Upg
	Il38wGfKIMPuk2BiulcBugEMlUvJCxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768556440; a=rsa-sha256;
	cv=none;
	b=RPn1cuvyeA/v50t3ywvdCP72Ljo4JdHWVz8H4A79pkfprPAkRaYnGoIf6D/oBLv4eRrIHJ
	a1On8C3KpEdLNFCb0G5KpT/mumccBvfbz3X20/JpqnRJxlOu7foldC9L6IMul1H94YeJYG
	rUyAbP+pk+kyccwDRSTgINQiPQ259F8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C0281515;
	Fri, 16 Jan 2026 01:40:32 -0800 (PST)
Received: from [10.164.136.46] (unknown [10.164.136.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCA043F59E;
	Fri, 16 Jan 2026 01:40:32 -0800 (PST)
Message-ID: <4b784eef-e874-45a6-828a-4fc2acab6fb7@arm.com>
Date: Fri, 16 Jan 2026 15:10:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 ryan.roberts@arm.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260116082721.275178-1-dev.jain@arm.com>
 <343f8462-44fd-4190-9fe2-8120b5403269@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <343f8462-44fd-4190-9fe2-8120b5403269@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2108180005
X-Rspam-User: 
X-Stat-Signature: 9agrdqrfoh5ihwrdjus7m98npeuqd5xi
X-HE-Tag: 1768556439-394868
X-HE-Meta: U2FsdGVkX18waLCjC7tvIa6sPTTe+063yTaOdO4+WHTy9rWKdh72eAD4T6asFQpBAf1hCjGUCVX+r1WhK3FIMhZsXOHgF/OaN5hQEcdTQ7yx0a+3kJq6bS7ppYvhvYdLMmjMsGhBfZXLpsY3JIZh/2fIm+ML52/a9Y6KzDunlY/IdKebQUOIpLJBlApIQvCYgwRmNOfhr+Q4ey8IW+iMQYFp24aZZtkdh0IrQ96E5z5iXwEDNNaskUT4vUe4WWezOdm2hAy/bwllzs2uqvup6jlApOsvvkX/hDvs0yqToCuSuLvAqxm9ZuYsHmLkrKWp/rNpuxDRGH/Mf0BTpUFbztRCEVGOYnX+k+EbPtO+lW84Ian6wYwEEsUmfdBGsWaNvBHr50bSNsWvOoTz9lu/6+bpgPWcnu/WlBS/yjc9+ZmlyiCtIyrBHUyqZw7ujdWQkJ+lLcD5eL79PCoh8qh9PBR//+Kj+g0n51VZ5AhBr5bF2r19MxFcEdiIAyY+1yWZBU+NNma+tMMk+i8bF1Agm4O6cf3+E9Q8CNYDjE3ecVphKFmCTFRbh6595s8VedwdaFrCItW4TJ8FgArtjiORMUKTg3qzzKHI9b+hF5QieARWBWbTxldZF6yoUIONs5827rSZMms0fMXDqBDfYT1hyVlerFZv57Y7Niwru+sE89uLLwqyjcxuwnkAKA/iDrIJPbQZzadFUPidFOFz6XTjFDYIfxptKx1qDIn7W59wWEC7SSSN4TUM6sTgnnH5gXNfKzs6tdDAZ9uQFr8RniNewwAoK279+e1ysGRm2gcpm6Z6lLqUvXx0otwtz8xYKrwOmevfmm+tBj2ZNz2USBX0v2UALkbjk9P2TmYHskGB/1P0noIwG2qm/qRH6HDlm+mjfGL8IgcftrOMKKCkaqt0t95yZm85H7qDH+VGe+JoFxucVhtKqoktUFSJgc2WQSaTxnnkAm2WmkQZ1/tV1fJ
 GEVZuOMP
 BvIQMYRD9dpz9wSIpnWiGhmKxQOpxqcly9qazlhC5LLvH4DPUIfaD5s2F8OvajWUHBCYJHQ3a2PWkz5hsjStDKQo/mgtWjbWM2e2U3npJzVJuI2xJRJS8y/3h60luWSPPcf95wEKrlCOWaXe7iMQZyji6k4Xf++Iw/T/0qlQvgvEDHsGgFztJo7IHuZ3ZR13wUt9qJ2U9LIaRRG4pZujrfLr1eWVB/dp1+2bgvomHXGeTz1icgkagald5nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 16/01/26 2:09 pm, Lorenzo Stoakes wrote:
> On Fri, Jan 16, 2026 at 01:57:21PM +0530, Dev Jain wrote:
>> The recently added file folio unmap batching support forgets to update
>> pte_install_uffd_wp_if_needed(), which still updates a single pte.
>> We end up jumping to the end of the folio in page_vma_mapped_walk(), thus
>> setting the uffd-wp marker only on a single pte in the batch. Fix this by
>> passing nr_pages into the function, and set the uffd-wp marker on all ptes.
>>
>> Note that, since the nr_pages passed to this function is always derived by
>> some sort of batching, it is guaranteed that the set of old ptevals of the
>> batch have uffd-wp bit on all ptes or no ptes, therefore it is safe to derive
>> the value of the local variable "arm_uffd_pte" from only the particular
>> pteval passed to this function, but apply the result on all ptes of the batch.
>>
>> Use set_pte_at() in a loop to set the markers - we cannot use set_ptes()
>> as that will increment the PFN, but we don't have any PFN to update here.
>>
>> The userspace visible effect of the bug is inaccuracy observed by workloads
>> relying on uffd-wp regions to install their own pages.
>>
>> Fixes: 8798e255b5ec ("mm: rmap: support batched unmapping for file large folios")
> Hmm this patch isn't upstream yet, so wouldn't this patch be better as a comment
> replying to the series so it can be respun?
>
> You only do a fixes tag for either upstream things that obviously have to stay
> in place or perhaps things in mm-stable immediately prior to merge window that
> can't be adjusted.

I saw that the last comment on that series was more than a week back, so best
thought to just do a folded fix on top of it - and I had formed the impression
(from the conversations on list) that akpm prefers fixes over respins : )

If a respin is preferred here then I am fine by that.

>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Let's replace this with a comment on the series at [0] please.
>
> [0]: https://lore.kernel.org/linux-mm/cover.1766631066.git.baolin.wang@linux.alibaba.com/
>
> Also the original series really shouldn't go in without signoff from me/David.
>
> Thanks, Lorenzo
>
>> ---
>> Patch applies on mm-unstable, commit f8ed52ac0cfb.
>>
>> I observed this bug during code inspection, but it turns out that the uffd-wp-mremap
>> selftest will skip some tests with a bogus complain that "MADV_PAGEOUT didn't work,
>> is swap enabled?" even when swap is enabled. It first sets the region uffd-wp,
>> then swaps it out, then checks through pagemap whether it got swapped out. For
>> file folios, this check makes no sense since the ptes are simply cleared, but in
>> this particular case, because of uffd-wp preservation, we need to store PTE_MARKER_UFFD_WP,
>> which is stored as a swap entry, that is why the test works out on a non-buggy kernel.
>>
>>  include/linux/mm_inline.h |  7 ++++---
>>  mm/memory.c               | 14 +-------------
>>  mm/rmap.c                 |  2 +-
>>  3 files changed, 6 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index fa2d6ba811b5..adec1dcb8793 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -568,7 +568,7 @@ static inline pte_marker copy_pte_marker(
>>   */
>>  static inline bool
>>  pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>> -			      pte_t *pte, pte_t pteval)
>> +			      pte_t *pte, pte_t pteval, unsigned int nr_pages)
>>  {
>>  	bool arm_uffd_pte = false;
>>
>> @@ -599,8 +599,9 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>>  		arm_uffd_pte = true;
>>
>>  	if (unlikely(arm_uffd_pte)) {
>> -		set_pte_at(vma->vm_mm, addr, pte,
>> -			   make_pte_marker(PTE_MARKER_UFFD_WP));
>> +		for (int i = 0; i < nr_pages; ++i, ++pte, addr += PAGE_SIZE)
>> +			set_pte_at(vma->vm_mm, addr, pte,
>> +				make_pte_marker(PTE_MARKER_UFFD_WP));
>>  		return true;
>>  	}
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 6b22dd72ebc8..35ac86d29e77 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1588,8 +1588,6 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>>  			      unsigned long addr, pte_t *pte, int nr,
>>  			      struct zap_details *details, pte_t pteval)
>>  {
>> -	bool was_installed = false;
>> -
>>  	if (!uffd_supports_wp_marker())
>>  		return false;
>>
>> @@ -1600,17 +1598,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>>  	if (zap_drop_markers(details))
>>  		return false;
>>
>> -	for (;;) {
>> -		/* the PFN in the PTE is irrelevant. */
>> -		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
>> -			was_installed = true;
>> -		if (--nr == 0)
>> -			break;
>> -		pte++;
>> -		addr += PAGE_SIZE;
>> -	}
>> -
>> -	return was_installed;
>> +	return pte_install_uffd_wp_if_needed(vma, addr, pte, pteval, nr);
>>  }
>>
>>  static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index f13480cb9f2e..d6ca002bf79c 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2171,7 +2171,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		 * we may want to replace a none pte with a marker pte if
>>  		 * it's file-backed, so we don't lose the tracking info.
>>  		 */
>> -		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
>> +		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
>>
>>  		/* Update high watermark before we lower rss */
>>  		update_hiwater_rss(mm);
>> --
>> 2.34.1
>>

