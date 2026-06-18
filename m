Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E03CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359E06B008C; Thu, 18 Jun 2026 09:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A266B0092; Thu, 18 Jun 2026 09:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2222F6B0093; Thu, 18 Jun 2026 09:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E714C6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:10:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B017C2C4A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:10:40 +0000 (UTC)
X-FDA: 84893067840.29.D414E20
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F75B18000E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:10:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gfvSmD64;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781788238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkOTwqQs/N/mnmxjTScE9xaxxLkv4cV9vO/7AOkjmu0=;
	b=5mQvBjCxP5ruVKb1dp+rUnTzhqD/d21VSDjPvfMhj7zJP5pmmHwPFoU9ow7cmix7YNDsSA
	4+Lmhx6S6yAY1TYpUiNgoAMowVsaRJUZPhcS0wnLROSyNJHBwmKJecvPKMlz2r96eN0Y2r
	48SxnuGxj61MQiys7P45rF/nw+x3AjY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gfvSmD64;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781788238;
	b=qkSPAKhAq5xfLFm5u0MOH/iHMtvSl+N4Qf9YAfzw3yyy31VkwPZeaI91BdvMNjidCoCQ6s
	XelGrKN7ji4b6sJklmDDYwxPSq+AjBc9aw89GXc9eTPhijZkaivEfkdqh6403weH92au2m
	mWQugu66t2ulzg9XUIjX5YsUkfbfF38=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781788233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NkOTwqQs/N/mnmxjTScE9xaxxLkv4cV9vO/7AOkjmu0=;
	b=gfvSmD64mQNX8BlNhxrqUvCXp9eA0vuWHhTSORjYMYIQ0MFsBmEFEDFmmYoko9XgdTeILL
	pbu0FNWRzWl7bAzitg9Egw+kLqINSjPx7+Z8/zx01mNqd/zuIC2NvHNTybzvwkvw3moMfj
	5MaE/AGAE0RbkE0Uumo1s+WRopBYFOQ=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	ljs@kernel.org
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic into a new helper
Date: Thu, 18 Jun 2026 21:10:24 +0800
Message-Id: <20260618131024.69667-1-lance.yang@linux.dev>
In-Reply-To: <CAA1CXcDv7WVxMcGv9OOZDzTzzcfEAnaGbX5dJGwqN5mSWkmRvA@mail.gmail.com>
References: <CAA1CXcDv7WVxMcGv9OOZDzTzzcfEAnaGbX5dJGwqN5mSWkmRvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0F75B18000E
X-Stat-Signature: mhix64ueazxqjimrz6urt34jae8wa6no
X-Rspam-User: 
X-HE-Tag: 1781788236-257494
X-HE-Meta: U2FsdGVkX1+UoMbPK1ebMX0TpWnhAtRQaqjjBaxm/qH7Bh3rKvqJjFbGPTWxtQBTb9r7bNK7cOr9rvMtZ4LQI9obblOPjvgYshdhSZDx2I9e9G8ebf3gFgzlH8uxe1QdRK3Nip2oLKFXO0Ca/NVjAx3N8ox9PCdnTqqt4N5Zh43ZVcRKUFFYzM2jVJgUqW73TlyYdyKWHtss+8ro2h5WpZQsYUm5J19cD2+uRogqqwbeQRxiVHpZgHEbC8KHnjVe3EJZfekQusl+XAYnadB7YoLrBCnyD8RzTGnebAiaeqJAVA+JZAkCd/K6vBzX1Hd+yEQ5JVchJLLK4FeGqUGZZPkl9O1TadPzaZCGyDzC1SXIUUpwtTbTqZyMA9q9Zb7o0AMn6iUaKEyfSw1YFZ0Y5GJOu50LZbz/1vylzYARl8yAThMEjR+vTsd3VmDIWb2n9Cog5vr2DU1DMtGpM1UZVaSy09+eblcUoiKhkLyYYt3ZCWpIyjw1i18gaqy28WFArFTJ83DZEHfoG3y3qalgjE5UV7XHdC017DGrnIUGRx637NdG8HOCdPh23XXgnd1Ww/ly5+ssbWbkmOLoP8VLI35iEfbKAX1ZCBazKVqZzGt3OgpQ0qodSS5QiMNB9pPZGi513Y10dxE1y7wo8veMbH9cp9R6+l18ksAU1tKAgAav9Wnd2K2g3nAl3nKra9O6bAFa46dT1b6hr0QEfmPBwb3C22ZFDlbT/gOR/hPgqa/iBsmnAA/++9N1/LXPOb4nGIHZq4cq8gzpODMCJaqGftqAxqiDfv+LmeZyv6UQsWDjBY3QFuSKObRcYVVXPpTuzpMTUWDwGFPt4UnT2bugbeeZ4bo+o2B9aSX01sJ2KKcddP7/61mVnRU6uRyI6TcXhK2pqRXkKoT1EQ8CXoUsDdOFnWkZZlL0tDQVw6BwlIRjF+sBY+6bRfyCF7JUyWks9bTceeMsNOLTV4OIxdN
 USxTrzhw
 epeAVFGYXake4pKB+ggY+Baim3wm8aozsoXTDQfMY6CtNmjkdo/0HyW7+03wTuYad4cQHkLUyoH4JQfko/JZ8GWa1Z8Nz+vm+IpIlUw+Ai/zv5oN4Mn2jeZHS7BGI14m3CToOgCOw1sUdMppgAs+0ZY7rwFCuz+j3NMX4gDwmBSiX6PCsDy61ssNzH/FKgD1QfD9EBZ83KBiV6DjEEPmF2+2Sq4CJYGrHUGNWSLk1NgrXp8sKl1V/vkfD4+0Wz4840qCadx1uClPM/r5LBo92keVwkMp3PrJL/ouiRmAsHbJWOP2D1RvqZXEZ573jPemFuXWC6mffs/RnkR6QyMRdgzU1754U5Xn8wSVcw1rx23q0kzCAu4xqqbJL32B2p9BMx4hlHMPWGwfuivS09zZfUdvV4Uj3X4fUJmkm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc David and Lorenzo, address oops fixed :)

On Thu, Jun 18, 2026 at 06:22:49AM -0600, Nico Pache wrote:
>On Tue, Oct 14, 2025 at 6:37 AM Lorenzo Stoakes
><lorenzo.stoakes@oracle.com> wrote:
>>
>> On Wed, Oct 08, 2025 at 12:37:48PM +0800, Lance Yang wrote:
>> > From: Lance Yang <lance.yang@linux.dev>
>> >
>> > As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>> > and __collapse_huge_page_isolate() was almost duplicated.
>> >
>> > This patch cleans things up by moving all the common PTE checking logic
>> > into a new shared helper, thp_collapse_check_pte(). While at it, we use
>> > vm_normal_folio() instead of vm_normal_page().
>> >
>> > Suggested-by: David Hildenbrand <david@redhat.com>
>> > Suggested-by: Dev Jain <dev.jain@arm.com>
>> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>
>> In general I like the idea, the implementation needs work though.
>>
>> Will check in more detail on respin
>>
>> > ---
>> >  mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
>> >  1 file changed, 130 insertions(+), 113 deletions(-)
>> >
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index b5c0295c3414..7116caae1fa4 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> > @@ -61,6 +61,12 @@ enum scan_result {
>> >       SCAN_PAGE_FILLED,
>> >  };
>> >
>> > +enum pte_check_result {
>> > +     PTE_CHECK_SUCCEED,
>> > +     PTE_CHECK_CONTINUE,
>>
>> Don't love this logic - this feels like we're essentially abstracting
>> control flow, I mean what does 'continue' mean here? Other than you're in a
>> loop and please continue, which is relying a little too much on what the
>> caller does.
>>
>> if we retain this logic something like PTE_CHECK_SKIP would make more sense.
>>
>>
>> > +     PTE_CHECK_FAIL,
>> > +};
>> > +
>> >  #define CREATE_TRACE_POINTS
>> >  #include <trace/events/huge_memory.h>
>> >
>> > @@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>> >       }
>> >  }
>> >
>> > +/*
>> > + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
>> > + * @pte:           The PTE to check
>> > + * @vma:           The VMA the PTE belongs to
>> > + * @addr:          The virtual address corresponding to this PTE
>> > + * @foliop:        On success, used to return a pointer to the folio
>> > + *                 Must be non-NULL
>> > + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
>> > + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
>> > + * @shared:        Counter for shared pages. Must be non-NULL
>> > + * @scan_result:   Used to return the failure reason (SCAN_*) on a
>> > + *                 PTE_CHECK_FAIL return. Must be non-NULL
>> > + * @cc:            Collapse control settings
>>
>> Do we really need this many parameters? THis is hard to follow.
>>
>> Of course it being me, I'd immediately prefer a helper struct :)
>
>Hey!
>
>Ive been trying to reimplement this patch, and started converting this
>to a helper struct... At first glance it seems like the right
>approach, but because the scan/isolate share two slightly different
>implementations, we need to leave some logic in the parent. This
>results in polluting the rest of the code significantly just to save
>one ugly function call with many parameters.

Been a while ... so I don't fully recall anymore :)

If you already have a patch or series, maybe just post it and we can look
at the actual diff.

Probably easier than talking about it without seeing the code :D

Cheers, Lance

>
>not sure what to do about that tbh.
>
>e.g., (just one of many examples)
>
>
>-                               NR_ISOLATED_ANON + folio_is_file_lru(folio),
>-                               folio_nr_pages(folio));
>-               VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>-               VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>+                               NR_ISOLATED_ANON + folio_is_file_lru(ctx.folio),
>+                               folio_nr_pages(ctx.folio));
>+               VM_BUG_ON_FOLIO(!folio_test_locked(ctx.folio), ctx.folio);
>+               VM_BUG_ON_FOLIO(folio_test_lru(ctx.folio), ctx.folio);
>
>-               if (folio_test_large(folio))
>-                       list_add_tail(&folio->lru, compound_pagelist);
>+               if (folio_test_large(ctx.folio))
>+                       list_add_tail(ctx.folio->lru, compound_pagelist);
>
>Are we sure this helper structure is the right approach?
>
>-- Nico
>
>>
>> > + *
>> > + * Returns:
>> > + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
>> > + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
>> > + *   PTE_CHECK_FAIL     - Abort collapse scan
>> > + */
>> > +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
>>
>> There's no need for inline in an internal static function in a file.
>>
>> > +             unsigned long addr, struct folio **foliop, int *none_or_zero,
>> > +             int *unmapped, int *shared, int *scan_result,
>> > +             struct collapse_control *cc)
>> > +{
>> > +     struct folio *folio = NULL;
>> > +
>> > +     if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>> > +             (*none_or_zero)++;
>> > +             if (!userfaultfd_armed(vma) &&
>> > +                 (!cc->is_khugepaged ||
>> > +                  *none_or_zero <= khugepaged_max_ptes_none)) {
>> > +                     return PTE_CHECK_CONTINUE;
>> > +             } else {
>> > +                     *scan_result = SCAN_EXCEED_NONE_PTE;
>> > +                     count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> > +                     return PTE_CHECK_FAIL;
>> > +             }
>> > +     } else if (!pte_present(pte)) {
>>
>> You're now making the if-else issues with previous patches worse by
>> returning which gets even checkpatch to warn you.
>>
>>         if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>>
>> (of course note that I am not convinced you can drop the pte_present()
>> check here)
>>
>>                 (*none_or_zero)++;
>>                 if (!userfaultfd_armed(vma) &&
>>                     (!cc->is_khugepaged ||
>>                      *none_or_zero <= khugepaged_max_ptes_none))
>>                         return PTE_CHECK_CONTINUE;
>>
>>                 *scan_result = SCAN_EXCEED_NONE_PTE;
>>                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>                 return PTE_CHECK_FAIL;
>>         }
>>
>>         if (!pte_present(pte)) {
>>                 ...
>>         }
>>
>> But even that really needs seriously more refactoring - that condition
>> above is horrible for instance so, e.g.:
>>
>>         if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>>                 (*none_or_zero)++;
>>
>>                 /* Cases where this is acceptable. */
>>                 if (!userfaultfd_armed(vma))
>>                         return PTE_CHECK_SKIP;
>>                 if (!cc->is_khugepaged)
>>                         return PTE_CHECK_SKIP;
>>                 if (*none_or_zero <= khugepaged_max_ptes_none)
>>                         return PTE_CHECK_SKIP;
>>
>>                 /* Otherwise, we must abort the scan. */
>>                 *scan_result = SCAN_EXCEED_NONE_PTE;
>>                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>                 return PTE_CHECK_FAIL;
>>         }
>>
>>         if (!pte_present(pte)) {
>>                 ...
>>         }
>>
>> Improves things a lot.
>>
>> I do however _hate_ this (*blah)++; thing. A helper struct would help :)
>>
>>
>>
>> > +             if (!unmapped) {
>> > +                     *scan_result = SCAN_PTE_NON_PRESENT;
>> > +                     return PTE_CHECK_FAIL;
>>
>> Can't we have a helper that sets the result, e.g.:
>>
>>         return pte_check_fail(scan_result, SCAN_PTE_NON_PRESENT);
>>
>> static enum pte_check_result pte_check_fail(int *scan_result,
>>                 enum pte_check_result result)
>> {
>>         *scan_result = result;
>>         return PTE_CHECK_FAIL;
>> }
>>
>> And same for success/skip
>>
>> Then all of these horrible if (blah) { *foo = bar; return baz; } can be
>> made into
>>
>>         if (blah)
>>                 return pte_check_xxx(..., SCAN_PTE_...);
>>
>> > +             }
>> > +
>> > +             if (non_swap_entry(pte_to_swp_entry(pte))) {
>> > +                     *scan_result = SCAN_PTE_NON_PRESENT;
>> > +                     return PTE_CHECK_FAIL;
>> > +             }
>> > +
>> > +             (*unmapped)++;
>> > +             if (!cc->is_khugepaged ||
>> > +                 *unmapped <= khugepaged_max_ptes_swap) {
>> > +                     /*
>> > +                      * Always be strict with uffd-wp enabled swap
>> > +                      * entries. Please see comment below for
>> > +                      * pte_uffd_wp().
>> > +                      */
>> > +                     if (pte_swp_uffd_wp(pte)) {
>> > +                             *scan_result = SCAN_PTE_UFFD_WP;
>> > +                             return PTE_CHECK_FAIL;
>> > +                     }
>> > +                     return PTE_CHECK_CONTINUE;
>> > +             } else {
>> > +                     *scan_result = SCAN_EXCEED_SWAP_PTE;
>> > +                     count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>> > +                     return PTE_CHECK_FAIL;
>> > +             }
>> > +     } else if (pte_uffd_wp(pte)) {
>> > +             /*
>> > +              * Don't collapse the page if any of the small PTEs are
>> > +              * armed with uffd write protection. Here we can also mark
>> > +              * the new huge pmd as write protected if any of the small
>> > +              * ones is marked but that could bring unknown userfault
>> > +              * messages that falls outside of the registered range.
>> > +              * So, just be simple.
>> > +              */
>> > +             *scan_result = SCAN_PTE_UFFD_WP;
>> > +             return PTE_CHECK_FAIL;
>> > +     }
>> > +
>>
>> Again as all of the comments for previous series still apply here so
>> obviously I don't like this as-is :)
>>
>> And as Andrew has pointed out, now checkpatch is finding the 'pointless
>> else' issue (as mentioned above also).
>>
>> > +     folio = vm_normal_folio(vma, addr, pte);
>> > +     if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
>> > +             *scan_result = SCAN_PAGE_NULL;
>> > +             return PTE_CHECK_FAIL;
>> > +     }
>> > +
>> > +     if (!folio_test_anon(folio)) {
>> > +             VM_WARN_ON_FOLIO(true, folio);
>> > +             *scan_result = SCAN_PAGE_ANON;
>> > +             return PTE_CHECK_FAIL;
>> > +     }
>> > +
>> > +     /*
>> > +      * We treat a single page as shared if any part of the THP
>> > +      * is shared.
>> > +      */
>> > +     if (folio_maybe_mapped_shared(folio)) {
>> > +             (*shared)++;
>> > +             if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
>> > +                     *scan_result = SCAN_EXCEED_SHARED_PTE;
>> > +                     count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>> > +                     return PTE_CHECK_FAIL;
>> > +             }
>> > +     }
>> > +
>> > +     *foliop = folio;
>> > +
>> > +     return PTE_CHECK_SUCCEED;
>> > +}
>> > +
>> >  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> >                                       unsigned long start_addr,
>> >                                       pte_t *pte,
>> >                                       struct collapse_control *cc,
>> >                                       struct list_head *compound_pagelist)
>> >  {
>> > -     struct page *page = NULL;
>> >       struct folio *folio = NULL;
>> >       unsigned long addr = start_addr;
>> >       pte_t *_pte;
>> >       int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>> > +     int pte_check_res;
>> >
>> >       for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>> >            _pte++, addr += PAGE_SIZE) {
>> >               pte_t pteval = ptep_get(_pte);
>> > -             if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> > -                     ++none_or_zero;
>> > -                     if (!userfaultfd_armed(vma) &&
>> > -                         (!cc->is_khugepaged ||
>> > -                          none_or_zero <= khugepaged_max_ptes_none)) {
>> > -                             continue;
>> > -                     } else {
>> > -                             result = SCAN_EXCEED_NONE_PTE;
>> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> > -                             goto out;
>> > -                     }
>> > -             } else if (!pte_present(pteval)) {
>> > -                     result = SCAN_PTE_NON_PRESENT;
>> > -                     goto out;
>> > -             } else if (pte_uffd_wp(pteval)) {
>> > -                     result = SCAN_PTE_UFFD_WP;
>> > -                     goto out;
>> > -             }
>> > -             page = vm_normal_page(vma, addr, pteval);
>> > -             if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>> > -                     result = SCAN_PAGE_NULL;
>> > -                     goto out;
>> > -             }
>> >
>> > -             folio = page_folio(page);
>> > -             if (!folio_test_anon(folio)) {
>> > -                     VM_WARN_ON_FOLIO(true, folio);
>> > -                     result = SCAN_PAGE_ANON;
>> > -                     goto out;
>> > -             }
>> > +             pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
>> > +                                     &folio, &none_or_zero, NULL, &shared,
>> > +                                     &result, cc);
>> >
>> > -             /* See hpage_collapse_scan_pmd(). */
>> > -             if (folio_maybe_mapped_shared(folio)) {
>> > -                     ++shared;
>> > -                     if (cc->is_khugepaged &&
>> > -                         shared > khugepaged_max_ptes_shared) {
>> > -                             result = SCAN_EXCEED_SHARED_PTE;
>> > -                             count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>> > -                             goto out;
>> > -                     }
>> > -             }
>> > +             if (pte_check_res == PTE_CHECK_CONTINUE)
>> > +                     continue;
>> > +             else if (pte_check_res == PTE_CHECK_FAIL)
>> > +                     goto out;
>> >
>> >               if (folio_test_large(folio)) {
>> >                       struct folio *f;
>> > @@ -1264,11 +1347,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> >       pte_t *pte, *_pte;
>> >       int result = SCAN_FAIL, referenced = 0;
>> >       int none_or_zero = 0, shared = 0;
>> > -     struct page *page = NULL;
>> >       struct folio *folio = NULL;
>> >       unsigned long addr;
>> >       spinlock_t *ptl;
>> >       int node = NUMA_NO_NODE, unmapped = 0;
>> > +     int pte_check_res;
>> >
>> >       VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>> >
>> > @@ -1287,81 +1370,15 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> >       for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> >            _pte++, addr += PAGE_SIZE) {
>> >               pte_t pteval = ptep_get(_pte);
>> > -             if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> > -                     ++none_or_zero;
>> > -                     if (!userfaultfd_armed(vma) &&
>> > -                         (!cc->is_khugepaged ||
>> > -                          none_or_zero <= khugepaged_max_ptes_none)) {
>> > -                             continue;
>> > -                     } else {
>> > -                             result = SCAN_EXCEED_NONE_PTE;
>> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> > -                             goto out_unmap;
>> > -                     }
>> > -             } else if (!pte_present(pteval)) {
>> > -                     if (non_swap_entry(pte_to_swp_entry(pteval))) {
>> > -                             result = SCAN_PTE_NON_PRESENT;
>> > -                             goto out_unmap;
>> > -                     }
>> >
>> > -                     ++unmapped;
>> > -                     if (!cc->is_khugepaged ||
>> > -                         unmapped <= khugepaged_max_ptes_swap) {
>> > -                             /*
>> > -                              * Always be strict with uffd-wp
>> > -                              * enabled swap entries.  Please see
>> > -                              * comment below for pte_uffd_wp().
>> > -                              */
>> > -                             if (pte_swp_uffd_wp(pteval)) {
>> > -                                     result = SCAN_PTE_UFFD_WP;
>> > -                                     goto out_unmap;
>> > -                             }
>> > -                             continue;
>> > -                     } else {
>> > -                             result = SCAN_EXCEED_SWAP_PTE;
>> > -                             count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>> > -                             goto out_unmap;
>> > -                     }
>> > -             } else if (pte_uffd_wp(pteval)) {
>> > -                     /*
>> > -                      * Don't collapse the page if any of the small
>> > -                      * PTEs are armed with uffd write protection.
>> > -                      * Here we can also mark the new huge pmd as
>> > -                      * write protected if any of the small ones is
>> > -                      * marked but that could bring unknown
>> > -                      * userfault messages that falls outside of
>> > -                      * the registered range.  So, just be simple.
>> > -                      */
>> > -                     result = SCAN_PTE_UFFD_WP;
>> > -                     goto out_unmap;
>> > -             }
>> > +             pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
>> > +                                     &folio, &none_or_zero, &unmapped,
>> > +                                     &shared, &result, cc);
>> >
>> > -             page = vm_normal_page(vma, addr, pteval);
>> > -             if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>> > -                     result = SCAN_PAGE_NULL;
>> > -                     goto out_unmap;
>> > -             }
>> > -             folio = page_folio(page);
>> > -
>> > -             if (!folio_test_anon(folio)) {
>> > -                     VM_WARN_ON_FOLIO(true, folio);
>> > -                     result = SCAN_PAGE_ANON;
>> > +             if (pte_check_res == PTE_CHECK_CONTINUE)
>> > +                     continue;
>> > +             else if (pte_check_res == PTE_CHECK_FAIL)
>> >                       goto out_unmap;
>> > -             }
>> > -
>> > -             /*
>> > -              * We treat a single page as shared if any part of the THP
>> > -              * is shared.
>> > -              */
>> > -             if (folio_maybe_mapped_shared(folio)) {
>> > -                     ++shared;
>> > -                     if (cc->is_khugepaged &&
>> > -                         shared > khugepaged_max_ptes_shared) {
>> > -                             result = SCAN_EXCEED_SHARED_PTE;
>> > -                             count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>> > -                             goto out_unmap;
>> > -                     }
>> > -             }
>> >
>> >               /*
>> >                * Record which node the original page is from and save this
>> > --
>> > 2.49.0
>> >
>>
>
>

