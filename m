Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 738B6C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 12:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B186B0088; Sat, 26 Sep 2026 08:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C356B008A; Sat, 26 Sep 2026 08:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A0F6B008C; Sat, 26 Sep 2026 08:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC3E96B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:37:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5A4E1C37F0
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:37:14 +0000 (UTC)
X-FDA: 85255863588.12.FEEB05A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id CBA5BA0009
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:37:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lU+wYF8y;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790426233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3kUkBhJmhr2Ei/JFKdlVabOX14WHBapnQSt+gsL+Qk=;
	b=7v9Tq6jPQlPsRmIbdgN83fNja9kCtSCqYt7/LglxOCYndCMSQm5KanuxL1jqWYA7AoAxO+
	unv/Rk1Ry1Kg9XfjpbD3tVc4SeQmSs6oswUe6wn25orMnfNWM4KU7FeyrfbUHHhBoNHbqE
	t80liGkHznIZSMhzMrG/ntAzhggGN5Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lU+wYF8y;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790426233;
	b=K5JHJJ5UKj6q/3LGmgUt5DNIf7+cKj3HtRRlI+5xfw/MxBPpqGnqkW8Xtbey00S5UbT3o2
	UZ4HrBrq7Bpa0Entk1utsXd8QaLxzR/M5FhSgsVi2mU9AOwtk5XbN+t68yxxSwiXDwRXxo
	90ThHFEX28tT3NvNTT74D5c2mqFNuiU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2623D1570;
	Sat, 26 Sep 2026 05:37:08 -0700 (PDT)
Received: from [10.164.11.10] (unknown [10.164.11.10])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC5E53F632;
	Sat, 26 Sep 2026 05:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790426231; bh=fqT9PsOPp+2UAi28FvcReu9QnVXrk/rtw2WCU8QbKrg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=lU+wYF8yFaTlGPXksx5u+jeRufLOFvI4NZk4d8f9t+ppVkYT/y/nC0a2E9bNnmNeY
	 EE+7xQcofWP/XBFcEpj22pkNwua73qXM9jRJKp+vUXSisFPSTUb2jnWpXutJHggSXq
	 hQjxxzj6WpGYg4R+vkhUz7wyEE8akuAYyOGrjc+4=
Message-ID: <7a2445ed-0e56-4a87-b4ba-6cf1dabd07d2@arm.com>
Date: Sat, 26 Sep 2026 18:07:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] mm/rmap: batch unmap anonymous swap-backed large
 folios
From: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 davem@davemloft.net, andreas@gaisler.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 jgg@ziepe.ca, thuth@redhat.com, sparclinux@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260924131106.1730494-1-dev.jain@arm.com>
 <20260924131106.1730494-9-dev.jain@arm.com>
 <CAGsJ_4xhGwxQCH4sG4=dyomRkN_PGHeW7e0uz1MsQHFW-Gs6VA@mail.gmail.com>
 <f61fa70f-882a-4787-918e-4b6959062c9c@arm.com>
Content-Language: en-US
In-Reply-To: <f61fa70f-882a-4787-918e-4b6959062c9c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBA5BA0009
X-Stat-Signature: 8ktwiuydsce6319m9hb1nxij3gty59ch
X-HE-Tag: 1790426232-503437
X-HE-Meta: U2FsdGVkX19vbRxNNspM19WUxlEIaEhsIeC3jpPFu1T8iE4LL9C3/7RfdKx60ewZtyvPUX+wN8yigaii0x8x3BBejy1hiT0PvKD0pZQbbhgny/KbWFq2hMDWarRM8paly8aBnyfJoVB4G8/xuFAN7Txi6OY3wbmUTV8li+ys7LdovWZS0LLFq9IC6HQnX6pPOeM/qV2c0y6vjgU4Owxha7HPWXgogm6wGTrT2fvGJQZY+hvqGC3VYGp+qpo6BYXxbxgXv+n3LQkBMcZnSkZ4dZEYEoeWhRXB9bXeM88zTHJH8gEEJGEq3kGn1+g/pdm1eWXbmYuGMnM+di1N2iGK657puaPv5KDw93VdiNA7F7BjgeL7o7GQ0NLVNLSf3qZV1gyI89hYp6BvPIIwrfZ61BgIp6dueYijgDEcSs3OlCmUq6Y8D8oHuapd2wc5Tf/Od+QzRjeqOSvoKqsRkjIRgldf+IKkTLK/4GEShvHyeyqXtP4gyNUXoixKGMYG0LsxeGpIL0Cn5aYwdddfYyk1s9IW0vjTltew/MnlfoO6geAY3yCoUk/mtelfMliKY0Vs8K17BikH9og+ShdNjssv96LCEG4hw+WEqtRf4B+BxkaySXVLSoGvbXjHDeDu3AVsDSaJgdepKHOK4VrVnQansSxXkCwkeNM3jUdYOisn4wXmVskNy8xGQyXZH+sdYf49HIelyGQ2K88sZY01WrkVyHWyuwpdRZ/NU5Wc5gfaGePflMyRi2jreHJPyPbsndNGVy0ThMkXZL5r06YWtallgvRGaDSSfCjd+ab5mMN4MidEw+6sbsrD/PykRpDbsW6uAa7vTnUIVF7IH1XAeuyULyiIApdCTkLmzOMiFzIZf91rMrlxv5HMa/L90LJIFfsVbO4vlWKPWQcfCtgGveaA90gmjdMCOy+9xIeyxd0ZQ8tmTrylM5HNFo14ZECaQDKaCNINMsF3dkXun47yda+
 VteUi0ZB
 B2nm/zvuOUzLVRJOT1eooeK72W3YStyuWAKpf3X4FUMYWglbA0v7hZV1zJmlYsuBHOYzfcCUOVR2SaGQ9Uyu/AdUWw3mqjr8ya4PyQARMcz1ldgk9eLIRYSEJoiv+eZwhT4DqBaBeveP/aHWd+GpealjyjkylBjaQfu1ovYgh1NXkifTilaMFfk4MvBZc06Io/oN5OvNcVrN1tiGSywlh6Bf28NmBCA5toA/9ufNlqiG42xG0G5YKxeQjZyPKQXHVC6TkUHbZ4aAGE6kbNlK1iLDxqM/R5RHDrWqGiYSlGGJAdJfmXBMHLdCnxM3UY6G3Je9U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/09/26 4:55 pm, Dev Jain wrote:
> 
> 
> On 25/09/26 11:45 am, Barry Song wrote:
>> On Thu, Sep 24, 2026 at 9:12 PM Dev Jain <dev.jain@arm.com> wrote:
>>>
>>> Enable batch clearing of PTEs and batch swap setting of PTEs for anon
>>> swap-backed folio unmapping.
>>>
>>> Processing all PTEs of a large folio in one go helps us batch across
>>> atomics (add_mm_counter() etc), barriers in __folio_try_share_anon_rmap(),
>>> and repeated calls to page_vma_mapped_walk(). In general, batching helps
>>> execute similar code together, making the path more memory and CPU
>>> friendly.
>>>
>>> On arm64-contpte, batching also helps avoid redundant ptep_get() calls
>>> and TLB flushes while breaking the contpte mapping.
>>>
>>> The handling of anon-exclusivity is very similar to commit cac1db8c3aad
>>> ("mm: optimize mprotect() by PTE batching"). Since
>>> folio_unmap_pte_batch() does not look at the bits of the underlying page,
>>> process sub-batches of PTEs pointing to pages with the same exclusivity
>>> state, and batch set only those PTEs to swap PTEs in one go.
>>>
>>> Disable batching for sparc (because of arch_unmap_one), we will batch this
>>> later.
>>>
>>> Rmap accounting and reference accounting must happen when anon folio unmap
>>> succeeds. If a large folio is only partially batched or a later sub-batch
>>> fails, account only the pages that were actually unmapped. Put that
>>> accounting in __ttu_anon_swapbacked_folio() itself instead of using goto
>>> jumps at the try_to_unmap_one() callsite.
>>>
>>> Similarly, do the finish_folio_unmap_batch() in ttu_anon_folio() itself for the
>>> non-swapbacked lazyfree case.
>>>
>>> If the batch length is less than the number of pages in the folio, skip
>>> over this batch. page_vma_mapped_walk() handles this: check_pte() returns
>>> true only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the
>>> PTE. Swap PTEs have no underlying PFN, so check_pte() returns false until
>>> the walk reaches the next present PTE to unmap.
>>>
>>> Remove the finish_unmap label since no goto callers are left now.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/rmap.c | 109 +++++++++++++++++++++++++++++++++++++++---------------
>>>  1 file changed, 80 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index fa9fc8374fc26..cdda9efd80bc3 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1966,12 +1966,13 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>         end_addr = pmd_addr_end(addr, vma->vm_end);
>>>         max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>
>>> -       /* We only support lazyfree or file folios batching for now ... */
>>> -       if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>> +       if (pte_unused(pte))
>>>                 return 1;
>>>
>>> -       if (pte_unused(pte))
>>> +#ifdef __HAVE_ARCH_UNMAP_ONE
>>> +       if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>                 return 1;
>>> +#endif
>>>
>>>         /*
>>>          * If unmap fails, we need to restore the ptes. To avoid accidentally
>>> @@ -2141,16 +2142,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
>>>         return swp_pte;
>>>  }
>>>
>>> -static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>>> +static void finish_folio_unmap_batch(struct vm_area_struct *vma,
>>> +               struct folio *folio, struct page *page, unsigned long nr_pages)
>>> +{
>>> +       folio_remove_rmap_ptes(folio, page, nr_pages, vma);
>>> +       if (vma->vm_flags & VM_LOCKED)
>>> +               mlock_drain_local();
>>> +       folio_put_refs(folio, nr_pages);
>>> +}
>>> +
>>> +static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>>>                 struct folio *folio, struct page *page, unsigned long address,
>>> -               pte_t *ptep, pte_t pteval)
>>> +               pte_t *ptep, pte_t pteval, unsigned long nr_pages,
>>> +               bool anon_exclusive)
>>>  {
>>> -       const bool anon_exclusive = folio_test_anon(folio) &&
>>> -                                   PageAnonExclusive(page);
>>>         swp_entry_t entry = folio_page_swap_entry(folio, page);
>>>         struct mm_struct *mm = vma->vm_mm;
>>> +       pte_t swp_pte;
>>>
>>> -       if (folio_dup_swap_pages(folio, page, 1) < 0)
>>> +       if (folio_dup_swap_pages(folio, page, nr_pages) < 0)
>>>                 return false;
>>>
>>>         /*
>>> @@ -2159,21 +2169,57 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>>>          * so we'll not check/care.
>>>          */
>>>         if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>>> -               folio_put_swap_pages(folio, page, 1);
>>> +               VM_WARN_ON(nr_pages != 1);
>>> +               folio_put_swap_pages(folio, page, nr_pages);
>>>                 return false;
>>>         }
>>>
>>>         /* See folio_try_share_anon_rmap(): clear PTE first. */
>>> -       if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
>>> -               folio_put_swap_pages(folio, page, 1);
>>> +       if (anon_exclusive &&
>>> +           folio_try_share_anon_rmap_ptes(folio, page, nr_pages)) {
>>> +               folio_put_swap_pages(folio, page, nr_pages);
>>>                 return false;
>>>         }
>>>
>>>         mm_prepare_for_swap_entries(mm);
>>> -       dec_mm_counter(mm, MM_ANONPAGES);
>>> -       inc_mm_counter(mm, MM_SWAPENTS);
>>> -       set_pte_at(mm, address, ptep,
>>> -                  swp_pte_prepare(entry, pteval, anon_exclusive));
>>> +       add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>>> +       add_mm_counter(mm, MM_SWAPENTS, nr_pages);
>>> +       swp_pte = swp_pte_prepare(entry, pteval, anon_exclusive);
>>> +       set_softleaf_ptes(mm, address, ptep, swp_pte, nr_pages);
>>> +       finish_folio_unmap_batch(vma, folio, page, nr_pages);
>>> +       return true;
>>> +}
>>> +
>>> +static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>>> +               struct folio *folio, struct page *first_page,
>>> +               unsigned long address, pte_t *ptep, pte_t pteval,
>>> +               unsigned long nr_pages)
>>> +{
>>> +       unsigned long batch_idx = 0;
>>> +
>>> +       while (nr_pages) {
>>> +               bool anon_exclusive = PageAnonExclusive(first_page + batch_idx);
>>> +               unsigned long len = page_anon_exclusive_batch(batch_idx,
>>> +                               nr_pages, first_page, anon_exclusive);
>>> +
>>> +               if (!__ttu_anon_swapbacked_folio(vma, folio,
>>> +                               first_page + batch_idx, address, ptep, pteval,
>>> +                               len, anon_exclusive)) {
>>> +                       /* Restore the remaining PTEs that were cleared. */
>>> +                       set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
>>> +                       return false;
>>> +               }
>>> +
>>> +               nr_pages -= len;
>>> +               if (!nr_pages)
>>> +                       break;
>>> +
>>> +               pteval = pte_advance_pfn(pteval, len);
>>> +               address += len * PAGE_SIZE;
>>> +               batch_idx += len;
>>> +               ptep += len;
>>> +       }
>>> +
>>>         return true;
>>>  }
>>>
>>> @@ -2186,15 +2232,22 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
>>>          * See handle_pte_fault() ...
>>>          */
>>>         if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
>>> -                        folio_test_swapcache(folio)))
>>> +                        folio_test_swapcache(folio))) {
>>> +               set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
>>>                 return false;
>>> +       }
>>>
>>> -       if (!folio_test_swapbacked(folio))
>>> -               return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
>>> +       if (!folio_test_swapbacked(folio)) {
>>> +               if (!ttu_anon_lazyfree_folio(vma, folio, nr_pages)) {
>>> +                       set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
>>> +                       return false;
>>> +               }
>>> +               finish_folio_unmap_batch(vma, folio, page, nr_pages);
>>> +               return true;
>>> +       }
>>
>> Hi Dev,
>>
>> if we look at the whole `ttu_anon_folio()` code:
>>
>> static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
>>                 struct page *page, unsigned long address, pte_t *ptep,
>>                 pte_t pteval, unsigned long nr_pages)
>> {
>>         /*
>>          * Store the swap location in the pte.
>>          * See handle_pte_fault() ...
>>          */
>>         if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
>>                          folio_test_swapcache(folio))) {
>>                 set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
>>                 return false;
>>         }
>>
>>         if (!folio_test_swapbacked(folio)) {
>>                 if (!ttu_anon_lazyfree_folio(vma, folio, nr_pages)) {
>>                         set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
>>                         return false;
>>                 }
>>                 finish_folio_unmap_batch(vma, folio, page, nr_pages);
>>                 return true;
>>         }
>>
>>         return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
>>                                          pteval, nr_pages);
>> }
>>
>> The comment "Store the swap location in the pte" is really out of
>> place. Since we are already here, can we move it to the right place?
> 
> I am not sure what is the "right place" you are referring to : ) More
> than that, this comments feels very out of date - it is well-know that
> the "swap location" is stored in the pte.
> 
> In fact, this comment starts on top of the wrong block, which is a
> debug assertion for "when we are here, swapbacked if and only if swapcache".
> So I'd rather just remove it.
> 
>>
>>>
>>> -       /* nr_pages > 1 not supported yet */
>>>         return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
>>> -                                        pteval);
>>> +                                        pteval, nr_pages);
>>>  }
>>>
>>>  /*
>>> @@ -2374,13 +2427,14 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>                          */
>>>                         dec_mm_counter(mm, mm_counter(folio));
>>>                 } else if (folio_test_anon(folio)) {
>>> +                       /* finish_folio_unmap_batch handled internally */
>>
>>
>> let me paste the final code here:
>>
>>                 } else if (folio_test_anon(folio)) {
>>                         /* finish_folio_unmap_batch handled internally */
>>                         if (!ttu_anon_folio(vma, folio, page, address,
>>                                             pvmw.pte, pteval, nr_pages))
>>                                 goto walk_abort;
>>
>>                         if (nr_pages == folio_nr_pages(folio))
>>                                 goto walk_done;
>>                         continue;
>>                 } else {
>>                         ...
>>                 }
>>
>>                 finish_folio_unmap_batch(vma, folio, page, nr_pages);
>>
>>                 /*
>>                  * If we are sure that we batched the entire folio and cleared
>>                  * all PTEs, we can just optimize and stop right here.
>>                  */
>>                 if (nr_pages == folio_nr_pages(folio))
>>                         goto walk_done;
>>                 continue;
>>
>> I am really struggling to read the code here. For anon folios, we
>> handle `finish_folio_unmap_batch()` internally, while for other folios
>> we still do it outside. This feels a bit inconsistent.
>>
>> Also, we are duplicating the code below twice:
>>
>>                 if (nr_pages == folio_nr_pages(folio))
>>                         goto walk_done;
>>
>> Can't we just do `finish_folio_unmap_batch()` like the other cases?
> 
> The core problem is that we may succeed on a partial range.
> 
> ttu_anon_swapbacked_folio can succeed on x < nr_pages. So for x, we
> should call finish_folio_unmap_batch. Either we do it my way, or,
> ttu_anon_folio returns the number of pages successfully unmapped = x,
> and then even in case of "failure" (we should now jump to
> walk_abort since we failed to unmap 'nr_pages - x' pages) we call
> finish_folio_unmap_batch for x pages.
> 
> IMHO that is uglier. I wanted to avoid this label jumping. I would
> be interested in hearing a better alternate : )

I did try this and it looks nicer actually. Will shift to this in v4,
thanks!


>>
>> That would also avoid the duplication.
>>
>> Best Regards
>> Barry
> 


