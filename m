Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543DECCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C8B6B0088; Fri, 16 Oct 2026 09:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDD56B008A; Fri, 16 Oct 2026 09:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5D56B008C; Fri, 16 Oct 2026 09:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C78E86B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:39:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54CE81A0446
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:39:02 +0000 (UTC)
X-FDA: 85328595324.03.0399146
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7FEBB140004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:39:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwcB1ovb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792157940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+En0gA6B8vPLtRXwr0jKEMbdqQdsLWsiXreHdl4F3ho=;
	b=1gcjbkv0Wv3nHO1lxZQUi/lJCzOrsGLkyWMebQTgXpTMXTe8iPepXyQQSxB/SG9qss3U9n
	UHCHNOu989osc8O+v0lZqUASIq1AsCEcDMHCD/HsGHy4PmlDqXtqlY4RirHnUgTAGJ0aih
	8LHlpGSOAnvoTC01efm2stDPj8nC8Lw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwcB1ovb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792157940;
	b=xrrF/Ko0qcqxFRaRnfZKG2egEGZKiOYEkZGfmkXBY1bdK0g7H8eyCswLaygp8ZiSCLrTX6
	cRxETKqzZawjza9IJPlme6lqSSbPiwjdowdiVnI9bGcxbBxATczNO2Tc+wGZj5nhRe4QcZ
	YwmA3ke6dIE759BUzorp1S9ZH/WNtRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55B1A40BC7;
	Fri, 16 Oct 2026 13:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4E91F000C4;
	Fri, 16 Oct 2026 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792157939;
	bh=+En0gA6B8vPLtRXwr0jKEMbdqQdsLWsiXreHdl4F3ho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jwcB1ovb7MJtPbMrAsQG4leITS+9JZTHJPaLMiFcWJqh+CbCAcAC+9u4icXtz2huV
	 QldZKk8GfBUieutJsnpGgRUDZJpgLWqBpgR0x1LSeZOmpnQy5nUsrY4iXL1K+yVI89
	 5RUm2GQIDsEOmu2xe59Lx/OKJXGJKLLALYYYQdCILsqbyYzw8zciVJG9zX0Z//xCKV
	 hBflzXni9F/+lv+K4ClzwLPGYrZBpXp+B9njbMP7PyftVKJ0Atw8RpSYkJn5MoFwjt
	 qcQh6yyJFVvkju/X45KxfW2AX9NxyGR6FPRr/aO7B1RAm9rP0dlsBlR/fK8HI6Fi2H
	 lQoahBHwLu5cA==
Message-ID: <8a30da60-a177-4c38-b914-18d31dc7f926@kernel.org>
Date: Fri, 16 Oct 2026 11:12:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
To: Li Zhe <lizhe.67@bytedance.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
 <arzVaC2IYkqSb0_U@gmail.com>
 <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
 <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org> <asjVUa6XBZ8ti-0_@gremlin>
 <70ea8ee6-6fc5-4209-8cee-362da37f5035@kernel.org>
 <86de1ee5-be14-4123-b372-b4691cea8e67@bytedance.com>
 <fedff1b6-0522-4398-a0d4-d4111a570159@kernel.org>
 <98d4a305-51e4-4374-b09d-7d251dbf166d@bytedance.com>
 <33e26c40-45f4-44a4-bfea-1ae7ff74e4cf@kernel.org>
 <f529ea30-2e93-4862-9642-21dc1b233e0c@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f529ea30-2e93-4862-9642-21dc1b233e0c@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7s8zhr5jtagjjnms8ocmb7fr43ac3ij6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FEBB140004
X-Rspamd-Server: rspam08
X-HE-Tag: 1792157940-175247
X-HE-Meta: U2FsdGVkX1+XYYyHYoaWsffcrqxmk8yq7TL9a3rBJTSrmgqh6Mt/McOtDl5Htmk3LWoFp1wCLl9/uwt3HiqGKl3tHD4imS5xFa8/9ENmCyS7BwYTuiBBdBrK6is+kk+J4pxQltpiRn5VkiEAp4My+RI/zHuGmdq24N4Ql8Q8Jr44kN9q5PCOUdicyKgQNyIe4MABlzZEmMtkaRMXqmeJosfT3GQrJ128xyTdhNyhsswLqvwfzfY1Y2DOIPVfZJJlevozgVkbqVi/euJYXViXAtru7KRJir+6SWWbPb67uqjTj2nOyGAnbMf9YRN5BcxVfgdEgYs5B6R1iCr9+89vCveRxr4YuAky3z+FRq1V90paLipEtL3bETGC0mKRbGH26cATilPkQuxH0J/JSxI0oScMA76QzdpHbvPkLUfeys2dHcmjwqMY0vOGUx3jr2jpKHWeJqsYdiUsQLGaBre3xZ5jC5LICy/unedMGMAaf0j7oddd95yIiw4Zbl62gQgcjwvVyA5Pwt/BVdpzlK4NGUccQ9j4zx3jc49TBaY4rY6Wc6EhYB1yZyZ2PJf6zE8+Wo3sIztTeenDNAkJkpxxsRQ2wDMSmgckpcTRgw6t2pGrXEpyMPhNMKq4EhmULXNh9CfEQyqblVA/susgqcBox0YayxXaDCNS6fZ8tYUdhmPGOWwkXpg6bbJVNpaXbXs1RpUsSKjm3S/0JcSDQghP6cVMltAUkHHEkyub/3y1FLV9ZtzsfNQu2DEhAjjmMtirq9Ji+g2li+tNHRBxvb9N4PG3sYukDchIKCDvCq4mcgkYUm5aTxEiK9vrUFZIANOzwI7rT3j6WzLJO1jHVh7YnBxwt+jyjREvnF82+ENXD+dqINdR3xT6jcnj8xwD8Ii48MJ1GlVGdTzusC1pFBqqmhd/qID0CvD3KQmw2n5XABuB/+IxUfNbym/7eZRDsJUTQxsgnhDCv+IZHZKJ2/9
 0qAW0y9X
 KtWMYQ2O4/J58w2K6f90g9Ok+BxYrTjIUvXjQvNwU/o1H+pIac/vSvdS+WKkmoZAUiuQgnStJQ/sLVZ5244elCp7kpgk4wSJTsMTuTqW9XeNZncBw86CV5gnuyt7bS5CBZfQWSZq5p+PDmIwMiM2X1rqLyNJez1JJ4AR/ZTFTTfvYQZ/dew0lQUYFfGpS+9h0+xNVR0gNSQ4Vx/TmcZqQ9gA22HF0Hn45/4VZviaf/5vpnfi8G5NFoiH+qVrl6b0y31vx7c8ScfkmO4iCuu2XW21xJFG0Lo6TbnvwHx1wI5zjj/WGTDJHM4oIURXAdhrymIsl7jLcFXTQcXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 10:56, Li Zhe wrote:
> On 10/16/26 3:33 AM, David Hildenbrand (Arm) wrote:
>> On 10/15/26 04:40, Li Zhe wrote:
>>> Yes, mostly.
>>>
>>> If the source PMD table is shared, huge_pmd_unshare() already drops that
>>> shared PMD table from the source side and we skip moving individual PTEs
>>> from that table.
>>>
>>> If the source PTE is not in a shared PMD table, but the destination PTE
>>> is in a shared PMD table, then I think we should not install the source
>>> PTE into the destination page table. The destination mapping is already
>>> represented by the shared PMD page table.
>>>
>>> However, move_huge_pte() still has to handle the source side as an
>>> unmap: clear the source PTE, record the TLB removal, and update the
>>> source-side hugetlb accounting/rmap state. Otherwise the source mapping
>>> is removed from the page table without the matching source-side
>>> accounting. I was able to reproduce this as:
>>>
>>>     BUG: Bad page cache in process init
>>>     page dumped because: still mapped when deleted
>>>
>>> when keeping the preallocation approach but dropping the special handling
>>> for a destination PMD-shared page table.
>>>
>>> So my current understanding is:
>>>
>>>     1. source PMD shared: unshare it and skip the PMD-sized range;
>>>     2. destination PMD shared: do not modify the destination PTE, but
>>>        still clear and account the source PTE removal.
>> Yes, I think this makes a lot of sense. Given that this issue has been
>> in the works for more than one month without a fix I tried to see how to do
>> it cleaner than your version:
>>
>> This is what I came up with quickly, using existing helpers by refactoring them.
>>
>> Is this what you had in mind? I didn't actually test this yet. If it makes sense,
>> could you test it and possibly clean it up further?
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index fb51f7d02cebf..0c3aebea7a2f8 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -124,6 +124,9 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
>>   		bool check_locks);
>>   static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
>>   		unsigned long start, unsigned long end, bool take_locks);
>> +static void hugetlb_unmap_range(struct mmu_gather *tlb,
>> +		struct vm_area_struct *vma, unsigned long start, unsigned long end,
>> +		struct folio *folio, zap_flags_t zap_flags);
>>   static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
>>   
>>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>> @@ -5172,6 +5175,8 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
>>   		const unsigned long offset_to_last_entry =
>>   			(old_addr | last_addr_mask) - old_addr;
>> +		const unsigned long offset_to_last_dst_entry =
>> +			(new_addr | last_addr_mask) - new_addr;
>>   
>>   		src_pte = hugetlb_walk(vma, old_addr, sz);
>>   		if (!src_pte) {
>> @@ -5188,6 +5193,23 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   			continue;
>>   		}
>>   
>> +		/*
>> +		 * Don't try to install a shared PMD table and move stuff into
>> +		 * them. Instead, just zap the source PMDs and share the PMD
>> +		 * table later lazily.
>> +		 */
>> +		if (sz == PMD_SIZE && want_pmd_share(new_vma, new_addr)) {
>> +			const unsigned long unmap_size = min(old_end - old_addr,
>> +							     offset_to_last_dst_entry + sz);
>> +
>> +			hugetlb_unmap_range(&tlb, vma, old_addr,
>> +					    old_addr + unmap_size, NULL,
>> +					    ZAP_FLAG_DROP_MARKER);
>> +			old_addr += unmap_size - sz;
>> +			new_addr += unmap_size - sz;
>> +			continue;
>> +		}
>> +
>>   		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
>>   		if (!dst_pte)
>>   			break;
>> @@ -5207,9 +5229,9 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   	return len + old_addr - old_end;
>>   }
>>   
>> -void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>> -			    unsigned long start, unsigned long end,
>> -			    struct folio *folio, zap_flags_t zap_flags)
>> +static void hugetlb_unmap_range(struct mmu_gather *tlb,
>> +		struct vm_area_struct *vma, unsigned long start, unsigned long end,
>> +		struct folio *folio, zap_flags_t zap_flags)
>>   {
>>   	struct mm_struct *mm = vma->vm_mm;
>>   	const bool folio_provided = !!folio;
>> @@ -5227,13 +5249,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   	BUG_ON(start & ~huge_page_mask(h));
>>   	BUG_ON(end & ~huge_page_mask(h));
>>   
>> -	/*
>> -	 * This is a hugetlb vma, all the pte entries should point
>> -	 * to huge page.
>> -	 */
>> -	tlb_change_page_size(tlb, sz);
>> -	tlb_start_vma(tlb, vma);
>> -
>>   	last_addr_mask = hugetlb_mask_last_page(h);
>>   	address = start;
>>   	for (; address < end; address += sz) {
>> @@ -5362,6 +5377,15 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   		if (folio_provided)
>>   			break;
>>   	}
>> +}
>> +
>> +void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>> +			    unsigned long start, unsigned long end,
>> +			    struct folio *folio, zap_flags_t zap_flags)
>> +{
>> +	tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
>> +	tlb_start_vma(tlb, vma);
>> +	hugetlb_unmap_range(tlb, vma, start, end, folio, zap_flags);
>>   	tlb_end_vma(tlb, vma);
>>   
>>   	huge_pmd_unshare_flush(tlb, vma);
> 
> 
> Hi David,
> 
> Your patch looks good to me.
> 
> Sashiko pointed out one corner case around UFFDIO_POISON.  In the
> destination-PMD-sharing path, the patch zaps the source range and lets
> the destination fault path populate or share the PMD lazily.  That works
> for normal hugetlb mappings, but if the source PTE contains
> PTE_MARKER_POISONED, the marker is not copied to the destination. 

Any UFFD activity must necessarily disable PMD sharing.

That's why want_pmd_share() checks uffd_disable_huge_pmd_share().

We cannot possibly move a UFFD marker into shared page table, that would be
completely broken already.


> The
> source zap uses ZAP_FLAG_DROP_MARKER, so the marker can be dropped, and a
> later fault at the new address would see an empty entry instead of the
> poisoned marker.
> 
> One possible way to avoid this is to make VM_UFFD_MISSING participate in
> the existing uffd_disable_huge_pmd_share() logic, because UFFDIO_POISON
> can install PTE_MARKER_POISONED and the poison state is stored in the
> PTE, similar to the existing UFFD-WP/RWP per-PTE state.
> 
> For example:
> 
> ---
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index a4351cffc60c..9a057d7531c3 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -183,8 +187,8 @@ static inline bool 
> is_mergeable_vm_userfaultfd_ctx(struct
> vm_area_struct *vma,
>   static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>   {
>       return vma_test_any_mask(vma,
> -        mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
> -                    VMA_UFFD_MINOR));
> +        mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP,
> +                    VMA_UFFD_RWP, VMA_UFFD_MINOR));


I think we can currently install POISON markers into shared PMD tables. What a
mess. Let me dig, that all needs a proper fix.

-- 
Cheers,

David

