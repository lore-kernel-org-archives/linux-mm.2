Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D9BC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58DB6B008A; Thu, 10 Sep 2026 00:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09C46B008C; Thu, 10 Sep 2026 00:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A201B6B0092; Thu, 10 Sep 2026 00:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 791726B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:39:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9056403E7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:39:53 +0000 (UTC)
X-FDA: 85196599866.23.8E3AB55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0FF6140003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:39:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e110XXj7;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789015192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ByQlfTm4fBJpClpN59VPtxsL839b+Tm243E3GM9+PE=;
	b=zSD40p2xCxlW3QARTBCWvgvcAh/VUyckpg9QSuMemjWJsrnKFIaKRpusAMaFiyVdpdSYwP
	NpbgPKO6zmETHCAzxr/BsNqLsVno8I4c6Bi2SCsog6sodXQVFFmPTPLvjR+apcjzhXR94y
	6YxzMCZvfGBt7hD9AuAyLABP7/agjsQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789015192;
	b=sU5XIrrD6LqJ3F+JD2gP0rZ5BN1l0aqq1O7Jx+E+Qk4937nvlnCfOpES3Wl/B57WToQa2b
	TC38Xi563SV0O1qG52V/64F30cPgMaksa3SSSoCzdDUQuZTcb5i2+tenAd+GjU07MtYmPD
	B5EL3pryMCsJvMH9FMlfnmJWXyBhYwk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e110XXj7;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD9171570;
	Wed,  9 Sep 2026 21:39:46 -0700 (PDT)
Received: from [10.164.148.54] (MacBook-Pro-3.blr.arm.com [10.164.148.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AB423F7B4;
	Wed,  9 Sep 2026 21:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789015190; bh=izvED01tg/879C7XLl932EOi/nkbDrejanQk+B6QoWU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e110XXj7oewKsCFtLRqBGdB7kyHD6x8VwRK1H7teHa1pMRiQn/wmyX8xcoPJqxUPE
	 5Pf5oo8Ek25CitGRDtD03Qzvm2K3gR1diYvLme3o3Fdx7YfguyEOSNoOYV8gzSYdAj
	 YlBCteqqw5ey3VMClAeDzsv3ihj+9LRy+HfsbFkE=
Message-ID: <3f1798bb-c6b9-4c1f-9a9a-fe312c1a0602@arm.com>
Date: Thu, 10 Sep 2026 10:09:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] mm/rmap: batch unmap anonymous swap-backed large
 folios
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, davem@davemloft.net,
 andreas@gaisler.com
References: <20260901054358.4049095-1-dev.jain@arm.com>
 <20260901054358.4049095-9-dev.jain@arm.com>
 <CAGsJ_4yQhafd8zoESxFza3N8kxWxpOpa1Pv-Sf+N=mCPz5or=w@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yQhafd8zoESxFza3N8kxWxpOpa1Pv-Sf+N=mCPz5or=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0FF6140003
X-Stat-Signature: 5mq44hcj5k6d7cm56hc9jppkn9zxu6w4
X-Rspam-User: 
X-HE-Tag: 1789015191-818298
X-HE-Meta: U2FsdGVkX1+TE8wTUyne+y8M0mlJqgDBrljRtcRDRD5SYN15n12Di+YsYGWG0RZe+rdhZKxailQTBP0vmRG/sUBX8F8BsxOZaRIK7tJC9WqdYPFIXWjWzgn6XQULX/1FeEzrua+in1vQwU6a1c2OYqUARK8Bcin17BS/gsHH/35vLuIzgPuqwuDeEc+oYdWbnpczr6ZsFR4KvGdYfKCnhDQg7lXu33v55Zx7Ss9NnyoBiheeT+DClvmkDmlH4vFsUDToFQzwzvrt+lR53iRJ0u+WMoqtON8MNEXmmU0N3gHdT78iJLza8oMperx8FZpKMiUKnr9Z2iLMF707yzYlsiaxLHolMFU2BqxgFAXtN9Of376xa1BigbpgXASd9kvaaWfnFfdx4Njb6NvfMy6yKkMXBxpWJjVDVHITwhgTPUUSAx1zuIXPABRp+xpTT9tcvmkBfVkl5rVyV9OYICco8xYhX8Qvena94o8MW+iK5fm2x7ClKuVwTR+4AUB8PanPHvsMPvMSrSQSPPhF2dVfHoo/g91p9YA9YoFCY4KDVaG41GnMOw4LxR2TfZYqFsDBN3qyVtTSNrJeHtq0W9YbIWjj5JSG+qYtcjjjy9lrRd5bUX2uZoGhAAPb1DuHquc59HeYM4wZkINzz/UU4LlapdWEuupJQmQOwUZSy9ID6sSEDpquxuw+ykvY1pxEOQnvtAYlHXLb6xWtW7nL922yVdxPInWgKVs9OjiRUJJuIB3xbRCOpvbOHiPLMzJjKWdgQL75zLioW4oEt8+F614DbT4L7qnfPmREOMcJiwgTHVZnz04Hbk1gngap7FU8GNr+DMkRX8Ev7p8GcpKIagMrrIsgXF+bGTOrqFMRvJJZHY5P2lGOqh8VrZJ8Yv+7FpnV9ZysqqW5/5f992btoj7FmsZnfzbAYWA2bedIycta6ASN0TYyLB7k8lWUDyaV7tN5iyfo90cAqwj+ItCEwWX
 v/btQ1Z7
 iQGaU354LPglxB1IXflvWo9pAijCXCUMfZWiHL/Lr8sTwS1aBrzt94lzbubQ9oAfYNAIst/IMnd4f710wW6zE+t+dvU7Db+1XDD0i8129j8cbnXmX/q/ZBUkeFyqKBUfcmY/kU2hty1QB8KsCgE4YaMB+Fn4AomPWqVz4pn+OXsj8nC/Dil3rLAjTwpznmMsjb4NR/yEth5y3KbEKNyaXsaxdUKi2D+wQuMr8deB9szc14T93gjTryKPaD3O1ZDl0dwiOby8zI1P4lVS+BFTrkVb21fV5lNQuCVe7FnPAtsG/lvc3fFyJ2R1hE7uQwtRzlmMe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ sparc guys for batching arch_unmap_one

On 09/09/26 3:18 am, Barry Song wrote:
> On Tue, Sep 1, 2026 at 1:45 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> Enable batch clearing of ptes, and batch swap setting of ptes for anon
>> swap-backed folio unmapping.
>>
>> Processing all ptes of a large folio in one go helps us batch across
>> atomics (add_mm_counter etc), barriers (in the function
>> __folio_try_share_anon_rmap), repeated calls to page_vma_mapped_walk(),
>> to name a few. In general, batching helps us to execute similar code
>> together, making the execution of the program more memory and
>> CPU friendly.
>>
>> On arm64-contpte, batching also helps us avoid redundant ptep_get() calls
>> and TLB flushes while breaking the contpte mapping.
>>
>> The handling of anon-exclusivity is very similar to commit cac1db8c3aad
>> ("mm: optimize mprotect() by PTE batching"). Since folio_unmap_pte_batch()
>> won't look at the bits of the underlying page, we need to process
>> sub-batches of ptes pointing to pages which are same w.r.t exclusivity,
>> and batch set only those ptes to swap ptes in one go.
>>
>> arch_unmap_one() is only defined for sparc64; I am not comfortable
>> regarding the nuances between retrieving the pfn from pte_pfn() or from
>> (paddr = pte_val(oldpte) & _PAGE_PADDR_4V).
>>
>> (And, pte_next_pfn() can't even be called from arch_unmap_one() because
>> that file does not include pgtable.h) So just disable the
>> "sparc64-anon-swapbacked" case for now.
>>
>> We need to take care of rmap accounting (folio_remove_rmap_ptes) and
>> reference accounting (folio_put_refs) when anon folio unmap succeeds.
>> In case we partially batch the large folio and fail, we need to correctly
>> do the accounting for pages which were successfully unmapped. So, put
>> this accounting code (which is finish_folio_unmap()) in
>> __ttu_anon_swapbacked_folio() itself, instead of doing some horrible
>> goto jumping at the callsite of ttu_anon_folio().
>>
>> Similarly, do the finish_folio_unmap() in ttu_anon_folio itself for
>> the non-swapbacked (lazyfree) case.
>>
>> If the batch length is less than the number of pages in the folio, then
>> we must skip over this batch.
>>
>> The page_vma_mapped_walk API ensures this - check_pte() will return true
>> only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
>> There is no pfn underlying a swap pte, so check_pte returns false and we
>> keep skipping until we hit a present pte, which is where we want to start
>> unmapping from next.
>>
>> Remove the label finish_unmap since no goto callers are left now.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 110 ++++++++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 81 insertions(+), 29 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 1b9f07d4d1be9..68e0201ffd003 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1964,12 +1964,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>         end_addr = pmd_addr_end(addr, vma->vm_end);
>>         max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>
>> -       /* We only support lazyfree or file folios batching for now ... */
>> -       if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>> +       if (pte_unused(pte))
>>                 return 1;
>>
>> -       if (pte_unused(pte))
>> +#ifdef __HAVE_ARCH_UNMAP_ONE
>> +       /* Add batching support to arch_unmap_one() to remove this */
> 
> I'd like to make this clearer. For example, could we say that
> sparc has `arch_unmap_one()`, which doesn't support batching?
> 
> BTW, it shouldn't be too hard to save `nr_pages` tags, looking at
> the code:
> 
> static inline int arch_unmap_one(struct mm_struct *mm,
>                                  struct vm_area_struct *vma,
>                                  unsigned long addr, pte_t oldpte)
> {
>         if (adi_state.enabled && (pte_val(oldpte) & _PAGE_MCD_4V))
>                 return adi_save_tags(mm, vma, addr, oldpte);
>         return 0;
> }
> Maybe the sparc folks can handle this.

I have mentioned in the patch description why I wasn't comfortable changing
this.

Perhaps the sparc guys can help me with the best way. Otherwise I'll try
harder in the next iteration to solve it myself : )
> 
>> +       if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>                 return 1;
>> +#endif
>>
>>         /*
>>          * If unmap fails, we need to restore the ptes. To avoid accidentally
>> @@ -2139,16 +2141,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
>>         return swp_pte;
>>  }
>>
>> -static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>> +static void finish_folio_unmap(struct vm_area_struct *vma,
>> +               struct folio *folio, struct page *page, unsigned long nr_pages)
> 
> We are not necessarily finishing the whole folio here, right?
> The name is a bit misleading to me, as it sounds like we're finishing
> the whole folio.
> 
> Maybe `finish_folio_unmap_batch()`?

Yes makes sense, it finishes the batch rather than finishing the folio.


> 
>> +{
>> +       folio_remove_rmap_ptes(folio, page, nr_pages, vma);
>> +       if (vma->vm_flags & VM_LOCKED)
>> +               mlock_drain_local();
>> +       folio_put_refs(folio, nr_pages);
>> +}
>> +
>> +static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>>                 struct folio *folio, struct page *page, unsigned long address,
>> -               pte_t *ptep, pte_t pteval)
>> +               pte_t *ptep, pte_t pteval, unsigned long nr_pages,
>> +               bool anon_exclusive)
>>  {
>> -       const bool anon_exclusive = folio_test_anon(folio) &&
>> -                                   PageAnonExclusive(page);
>>         swp_entry_t entry = page_swap_entry(page);
>>         struct mm_struct *mm = vma->vm_mm;
>> +       pte_t swp_pte;
>>
>> -       if (folio_dup_swap_pages(folio, page, 1) < 0)
>> +       if (folio_dup_swap_pages(folio, page, nr_pages) < 0)
>>                 return false;
>>
>>         /*
>> @@ -2157,21 +2168,57 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>>          * so we'll not check/care.
>>          */
>>         if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>> -               folio_put_swap_pages(folio, page, 1);
>> +               VM_WARN_ON(nr_pages != 1);
>> +               folio_put_swap_pages(folio, page, nr_pages);
>>                 return false;
>>         }
>>
>>         /* See folio_try_share_anon_rmap(): clear PTE first. */
>> -       if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
>> -               folio_put_swap_pages(folio, page, 1);
>> +       if (anon_exclusive &&
>> +           folio_try_share_anon_rmap_ptes(folio, page, nr_pages)) {
>> +               folio_put_swap_pages(folio, page, nr_pages);
>>                 return false;
>>         }
>>
>>         mm_prepare_for_swap_entries(mm);
>> -       dec_mm_counter(mm, MM_ANONPAGES);
>> -       inc_mm_counter(mm, MM_SWAPENTS);
>> -       set_pte_at(mm, address, ptep,
>> -                  swp_pte_prepare(entry, pteval, anon_exclusive));
>> +       add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>> +       add_mm_counter(mm, MM_SWAPENTS, nr_pages);
>> +       swp_pte = swp_pte_prepare(entry, pteval, anon_exclusive);
>> +       set_softleaf_ptes(mm, address, ptep, swp_pte, nr_pages);
>> +       finish_folio_unmap(vma, folio, page, nr_pages);
>> +       return true;
>> +}
>> +
>> +static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>> +               struct folio *folio, struct page *first_page,
>> +               unsigned long address, pte_t *ptep, pte_t pteval,
>> +               unsigned long nr_pages)
>> +{
>> +       unsigned long batch_idx = 0;
>> +
>> +       while (nr_pages) {
>> +               bool anon_exclusive = PageAnonExclusive(first_page + batch_idx);
>> +               unsigned long len = page_anon_exclusive_batch(batch_idx,
>> +                               nr_pages, first_page, anon_exclusive);
> 
> `len` is really a bad name, as `len` usually describes a size.
> Maybe `batch_pages`?

I disagree here : ) I don't think someone should mistake len with size.
len is ... "length". So in this case it is the length of pages in the
array, starting from batch_idx, upto nr_pages, which are all exclusive
or not. Also I would prefer short variable names.

> 
>> +
>> +               if (!__ttu_anon_swapbacked_folio(vma, folio,
>> +                               first_page + batch_idx, address, ptep, pteval,
>> +                               len, anon_exclusive)) {
>> +                       /* Restore the remaining PTEs that were cleared. */
>> +                       set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
>> +                       return false;
>> +               }
>> +
>> +               nr_pages -= len;
>> +               if (!nr_pages)
>> +                       break;
>> +
>> +               pteval = pte_advance_pfn(pteval, len);
>> +               address += len * PAGE_SIZE;
>> +               batch_idx += len;
>> +               ptep += len;
>> +       }
>> +
>>         return true;
>>  }
> 
> Best Regards
> Barry


