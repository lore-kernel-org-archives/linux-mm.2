Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767D2C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 21:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0D16B009D; Mon,  6 Jul 2026 17:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1D06B009E; Mon,  6 Jul 2026 17:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195D06B009F; Mon,  6 Jul 2026 17:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC2816B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:06:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C103120219
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:06:54 +0000 (UTC)
X-FDA: 84959586348.05.9983959
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id C71D9100004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:06:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oTNGWIqy;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783372012;
	b=zkXdy7OdYjpf11zaaR5gKMqZ5KjNj+BusL72y4uJjohdTrpM531J/wFIkKUGjs5gC1JVNe
	cF/ucD8kNU/mAK3GOtz+/VTpOcSnIqL6KefICy+d7RwQPkcdlsW6qsmagLbeMnfaF3NR66
	5JQhRJXgGentKFA6Eg8yjdX75r20JAk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oTNGWIqy;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783372012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ph6/Sa1sXBzJcwhfmqrguqXnLUqwt68zNWJ+Jfh3a1g=;
	b=wxXXUp0rxw2fh9FxDoPOEjzVon1EVJhx4f7NkNO0GFJb5h9FLZDYDoBHf5Ylm7pk79TIlH
	37Jijk7C5WNxKpTDeTqO71dq+KzzAzxaWhGCOY+UOAll4mjkdpd9gSYzvPLFGPBpf2lvLc
	5YbmyIfAg6TUwobjTj0FxI8KH6uRflc=
Message-ID: <d0d47811-44b2-490f-ad57-f9b57aa70a0a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783372009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ph6/Sa1sXBzJcwhfmqrguqXnLUqwt68zNWJ+Jfh3a1g=;
	b=oTNGWIqy6YtbRzDHp9j5zcAfWylNoie5maqv3I3TU9Gvu/YpDVhw9tlBJpwWbsV7xyBquX
	hGzTtAxz95G/YH5qYlIpndSo4w4NCwB+mEMkyrKNZxNHMZPnBXEvlA+r+fV8K+z0J80Xl2
	C0aG5veOx4fUlvAZ65W5QhAe5fBcwlg=
Date: Mon, 6 Jul 2026 22:06:43 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 09/11] mm: handle PMD swap entry faults on swap-in
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260703173903.3789516-1-usama.arif@linux.dev>
 <20260703173903.3789516-10-usama.arif@linux.dev>
 <CAMgjq7CQ+1gsptFYH+Y0GEqyYj+5QpAKjtZLekRS4h+k4f8QvQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAMgjq7CQ+1gsptFYH+Y0GEqyYj+5QpAKjtZLekRS4h+k4f8QvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C71D9100004
X-Stat-Signature: 39rmxxw5xdzucw8cfa8a7cadi4x69zoo
X-HE-Tag: 1783372011-61951
X-HE-Meta: U2FsdGVkX19veBoWKMehI0majp4FbeVwf+I/YBnp5/ev/OGE/70OpVQkzqSONVcAGLgecepSschY6sxxjkLEa8AaHsVFHUwUyg6zOUhe+Su4tSAr+CeIweLglInDfTD/ZnPx7qwvpV7PpELZYDAtQLXYytPiFTTEVLzTZDlKX3FDIPBqa3IUxccqgzF2IAgY58/m0tCHIS14GzV1CCWtkUTlJBLsgeN63zq3Wcip8jgJHY6VBv4Vpau1rDe65ALggHh1gMAAleAZ9wNTeib/wVlBinRK5pzXX+NPDd2eR32O+C3JbdeupJ0xFDgx4kJiv7rUxYxiCEyRXyHecc2TVrXTUoxqgLUdYDC2RNcmSX6ZarsGTWzA33a0pwmlNHECOLzZClFVkvN/IzvlisWtrUjdxx1HzAZmJLEfNDQaiwDS0WdQOeV5xbxyXUn7QJOysnm31AU8Kfy/QkAsE+mA/OC3cSTMC8VsZabq75BE2YC3UqmpmTWvmCFQ5AlySDC4CPhAJxGRdVNO3wIBrnmXFla4VCUcp6sruauaLznxlr9NjcWheeEqec7jLI20WKSbSNmjyNkrFbQzTW85qlhLgHgrAArHs7HCC9CDLMLrc8Vi+Rwsr1yrG2q+qe6lfPorA3OJ5SeuD9JIP7P3XTKM7V9Dur45mnNEeUfQg5WAuPbcc3yKoutaew7NX5subeZpREkvL90PUAViP8emKKEIuhcS0jd8H9Y2meBMQwgNnAvYSh4/k3OjutZRfD1gbNg2I64zQIscXftXivERbfhN4WFvgx7N/w3N1Nml3ebujJ4g4YQiQ5fmfJR8zxrh6oPfxnOgzx3zYSul7qVIvwquXSKSP6l5C8QBmRCYI+aviBVoQVgFb/xIMm3X6VE70lT2vxJUzdS/SzguppUYEpoOOwjD41C7yWySwsEC76GYbhhvAoDlqwf/vKM4IA7jAfm+BzEjiqEOAqWTzMxLrd8
 hdafZvFi
 glTA+W9eLoveK3IS23I80U/rdCyC5UClf3UJFqna/PDdn8jK9W8pHPzYD4kqnAuCq0rm5dNUyZyT4tbB5UZjhWbwReWg/dTMgs9JhrFa/chfDKd3yykGZQdCUJd4ZinTSWjljO+TBGqZ5d6F8DUgtPbbQw1vHqoisPqVhotvTVNPReWVOSK45s9PqwwyvQ87H6pHdw/vAztUUOSEbZ/2/TV3I8GDNh8R2bxWrN2gHesBzt9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/07/2026 18:56, Kairui Song wrote:
> On Sat, Jul 4, 2026 at 1:41 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> Add do_huge_pmd_swap_page() and dispatch to it from __handle_mm_fault()
>> when vmf->orig_pmd encodes a swap entry.  The handler resolves the
>> entire 2 MB mapping in one shot, mirroring do_swap_page() (PTE path)
>> at PMD granularity:
>>
>>   - Look up the folio in the swap cache; on a miss, allocate a
>>     PMD-order folio via swap_cache_alloc_folio() and read from swap.
>>
>>   - After locking, re-validate that the folio still corresponds to our
>>     entry and is still PMD-sized.  Between the unlocked cache lookup
>>     and the lock, a racing swap-in on the same entry may have removed
>>     it from the cache via folio_free_swap(), or reclaim / memory_failure
>>     / deferred-split may have split the folio into smaller folios.
>>
>>   - Restore soft_dirty and uffd_wp from the swap PMD.  Map writable
>>     only when the entry was exclusive, the VMA permits writes, and
>>     uffd-wp is not armed.  Drop the exclusive marker when the cached
>>     folio is under writeback to an SWP_STABLE_WRITES backend (zram,
>>     encrypted) so the PMD is mapped read-only; a later write COWs
>>     into a fresh folio rather than corrupting the in-flight writeback.
>>     Mirrors do_swap_page().
>>
>>   - When the resulting PMD is read-only but the fault was a write,
>>     update vmf->orig_pmd and call wp_huge_pmd() in the same handler
>>     to COW immediately rather than forcing a second fault.  Mask
>>     VM_FAULT_FALLBACK from its return: a PMD-COW that splits to
>>     PTE-level is normal, but the bit is part of VM_FAULT_ERROR and
>>     arch fault handlers BUG() on it without SIGBUS/HWPOISON/SIGSEGV.
>>     Requires exposing wp_huge_pmd() via mm/internal.h.
>>
>>   - Free the swap slot via should_try_to_free_swap() (hoisted from
>>     mm/memory.c into mm/internal.h so PTE- and PMD-level swap-in
>>     share the heuristic).
>>
>> When PMD-order resources are unavailable (folio allocation fails,
>> the cached folio was split, memcg charge fails, or swapin_folio()
>> races) split the PMD swap entry into 512 PTE swap entries via
>> __split_huge_pmd() and return 0.  The fault retries and do_swap_page()
>> takes over per-PTE.  This avoids returning VM_FAULT_OOM for transient
>> PMD-order allocation failures.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Hello Usama
> 
> Amazing work.

Hi Kairui,

Thanks! and Thanks for the review comments!

> 
>> ---
>>  include/linux/huge_mm.h |   9 ++
>>  mm/huge_memory.c        | 216 ++++++++++++++++++++++++++++++++++++++++
>>  mm/internal.h           |  36 +++++++
>>  mm/memory.c             |  40 +-------
>>  4 files changed, 265 insertions(+), 36 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1487bf4af1a7..9ec475ccfc91 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -531,6 +531,15 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
>>
>>  vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
>>
>> +#ifdef CONFIG_THP_SWAP
>> +vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
>> +#else
>> +static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
>> +{
>> +       return 0;
>> +}
>> +#endif
>> +
>>  extern struct folio *huge_zero_folio;
>>  extern unsigned long huge_zero_pfn;
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index fdc1a503c609..5fa60324a2f0 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/pgalloc.h>
>>  #include <linux/pgalloc_tag.h>
>>  #include <linux/pagewalk.h>
>> +#include <linux/zswap.h>
>>
>>  #include <asm/tlb.h>
>>  #include "internal.h"
>> @@ -2312,6 +2313,221 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>>         return 0;
>>  }
>>
>> +#ifdef CONFIG_THP_SWAP
>> +/**
>> + * do_huge_pmd_swap_page() - Handle a fault on a PMD-level swap entry.
>> + * @vmf: Fault context. vmf->orig_pmd contains the swap PMD.
>> + *
>> + * A PMD swap entry is a compact encoding for HPAGE_PMD_NR consecutive swap
>> + * slots. If the swap cache still has one PMD-sized folio covering the range,
>> + * map it directly at PMD level. If the range has been split into per-page
>> + * cache state, or zswap may have per-page state for it, split the PMD swap
>> + * entry and retry at PTE granularity.
>> + *
>> + * Return: VM_FAULT_* flags.
>> + */
>> +vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
>> +{
>> +       struct vm_area_struct *vma = vmf->vma;
>> +       struct mm_struct *mm = vma->vm_mm;
>> +       struct folio *folio;
>> +       struct page *page;
>> +       struct swap_info_struct *si;
>> +       unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
>> +       softleaf_t entry;
>> +       swp_entry_t swp_entry;
>> +       pmd_t pmd;
>> +       vm_fault_t ret = 0;
>> +       bool exclusive;
>> +       rmap_t rmap_flags = RMAP_NONE;
>> +       enum swap_pmd_cache cache_state;
>> +
>> +       entry = softleaf_from_pmd(vmf->orig_pmd);
>> +       if (unlikely(!softleaf_is_swap(entry)))
>> +               return 0;
>> +
>> +       swp_entry = entry;
>> +
>> +       /* Prevent swapoff from happening to us. */
>> +       si = get_swap_device(swp_entry);
>> +       if (unlikely(!si))
>> +               return 0;
>> +
>> +       cache_state = swap_pmd_cache_lookup(swp_entry, &folio);
>> +       if (cache_state == SWAP_PMD_CACHE_SPLIT)
>> +               goto split_fallback;
>> +       if (!folio) {
>> +               /*
>> +                * PMD swap entries encode ordinary per-page swap slots. If any
>> +                * slot is in zswap, split and let the PTE swap path load the
>> +                * range per page. Otherwise the range is all on disk and can be
>> +                * read back as one PMD-sized folio.
>> +                */
>> +               if (zswap_range_has_entry(swp_entry, HPAGE_PMD_NR))
>> +                       goto split_fallback;
>> +
>> +               folio = swapin_sync(swp_entry, GFP_HIGHUSER_MOVABLE,
>> +                                   BIT(HPAGE_PMD_ORDER), vmf, NULL, 0);
> 
> Hmm, so here we always do a sync swapin which means there is no
> readahead, kind of make sense since PMD is huge, readahead might be
> not helpful and a order 0 readahead breaks following PMD. But maybe
> worth mention it in the commit message at least so it's easiler to
> follow. (partly because the name swapin_sync is a bit confusing at the
> moment, we could change that name as we improve swap readahead later).

Yes, I’ll add this to the commit message. Thanks!

Yes readahead won't be useful for PMD as you said.

> 
> And just an idea that will it be suffient if we just use the return
> value of swapin_sync directly? If a smaller folio covers the PMD start
> entry, the smaller folio is returned and you catched that just fine.
> If a smaller folio covers a follow-up sub-entry or a sub-entry is
> freed, -EBUSY is returned here and you just do the split. And it
> doesn't do the allocation for the first lookup check, so there should
> be no thrashing issue.

The main issue over here is zswap.
zswap still stores the range as order-0 objects. If we call PMD-order
swapin_sync() when the cache is empty but any slot is in zswap, zswap_load()
fails the large-folio load and leaves a non-uptodate PMD-sized folio in
swapcache. Splitting the PMD after that is not enough unless we also delete that
failed large folio, because the subsequent PTE fault can find the non-uptodate
large folio and SIGBUS instead of loading the individual zswap entries.


> 
>> +               if (IS_ERR_OR_NULL(folio))
>> +                       goto split_fallback;
>> +
>> +               /* Had to read from swap area: Major fault */
>> +               ret = VM_FAULT_MAJOR;
>> +               count_vm_event(PGMAJFAULT);
>> +               count_memcg_event_mm(mm, PGMAJFAULT);
>> +       }
>> +
>> +       ret |= folio_lock_or_retry(folio, vmf);
> 
> With PMD sized folio on a slower device, this try lock could fail much
> more frequently, leading to repeated faults. That's not a new issue
> and I remember Barry talked about it at the LSFMM this year, just I'm
> not sure if that will get much worse for PMD?

Agreed that PMD-sized IO can keep the folio locked longer, especially on
slow swap devices. (Which hopefully are dying away :))
The current behavior matches do_swap_page(): on the normal retryable fault
path it drops the fault lock and waits for the folio unlock before returning
VM_FAULT_RETRY, so it should not be a tight retry loop.
The wait can be longer for 2MB IO, but the retry usually comes back to
either an uptodate folio or a PMD that another fault already  installed.
I think this is the right baseline behavior, and any improvement here
belongs with the broader swap readahead / async swapin work.

