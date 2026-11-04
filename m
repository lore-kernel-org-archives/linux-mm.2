Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85D8606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ausYVUHE
Received: by kanga.kvack.org (Postfix)
	id 88C3C6B05B2; Wed,  4 Nov 2026 02:47:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CF36B05B3; Wed,  4 Nov 2026 02:47:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A5E6B05B4; Wed,  4 Nov 2026 02:47:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4EC6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:47:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E5FBA81FF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:47:58 +0000 (UTC)
X-FDA: 85396657836.09.895A908
Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6A319140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:47:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ausYVUHE;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793778476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDlodseTHUYdBDE8U9EBMQzIvxI2E8etBmPnHlBGbe4=;
	b=TCXjHmxAkOV0AQ80BDLi2le05WO82x1o1gJzfN7xCg3XeE01wWNqTYnJZLurN3g1rkk+ME
	NZjUAs9n2jJTeYIuRxzBRGGyUZQ97EVpBZw4YE42vCEvXwnl2B/8GH7FX2n1ZFa5wukqj5
	UpjyJ3gFkzpNxLUfUxlTNX+f3OkIbTM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ausYVUHE;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793778476;
	b=gwQEzYbJ6D0k1CpjuWKoUVTiD4f2C2ePHG6BmedHkdTKH0G3r5M2bRIri1564j/O65hUOU
	QiUAgrcll599qXOsfB6+yNArNtJXMinyt6k9xvFXZv+twi0mDEShQx3HdbETk3O/AzJBh/
	HBGObbUBLi9eipNvR7sRiAr3i11hM3Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0JyHOnRJ/tnwgb0cYunQfYkiNN1NIfUkDxCymd783Zw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793778475; v=1; x=1794383275;
 b=ausYVUHEnf+7Cmfj/IH7nQ0ez9nSmkhHYDug0494EioSTsrf0TXljoawzBN1b0JmlDaCTAAZ
 kNg9qPx3qzumHMB0YwR3X3wyyrsPQ4AjEkuqHezrVVpnMHPZQsQ0kxlKw4i2cJWlDtloX8Ri1T/
 QuRmjvU4nqaTZOF/rCJTHsjk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6abba58bc298b535;
	Wed, 04 Nov 2026 07:47:54 +0000
X-Mizu-Trace-ID: 6abba58bc298b535
X-Migadu-Flow: FLOW_OUT
Message-ID: <ae47e4d2-e847-4ee5-901f-56536527eadd@linux.dev>
Date: Wed, 4 Nov 2026 15:47:47 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: hugetlb: skip CMA allocations under
 PF_MEMALLOC_PIN
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org, azpijr@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
 <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
 <8b7f6573-ed12-494f-9210-d6f6dbf01567@linux.dev>
 <2DE679F1-C87F-4222-A710-C87CDE86D333@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <2DE679F1-C87F-4222-A710-C87CDE86D333@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rsmifrfkjhj4g6se11wa8z9k5pzyyg5g
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6A319140005
X-HE-Tag: 1793778476-159608
X-HE-Meta: U2FsdGVkX19lvoL7lznVfz5/pCvlwOrWUnW0qD/ghZasWOJ3CkpIqaWdZ0TDpWbfOaJbjqwvfoN/Ie3Clj3eMK4OSeQb9jlWLERjBaX+EjT7MEo69j5wfz6XXADGbVeNjXvjmJ3c9LZEY8glp7fnE/Q/Lo73rWpBoykLHHAHHQ14A8m0MZxsmMeoln4i4Pni/Z5ZMyYC940OomGx8fyazi1Bc1LsRAFECAG8PBB97YiZj8OqhRY6sKu7p+2rsNdnEKKM5Vaz3VHOhACEFq4kbv8ow6QLcNUgUTm7kMZcqPlYyOftyqcADxZ45LGivkMNZKJgmnBt4SwkbK4QaAvxhL7Kk3v5AKmVhYzLTM5VuORBkxz8nWkJAffCc+mNvCsnXh4BRlstM7O0sevP73Xx0S8OyOTxl61QEXBCbKc97b3+Gj6neyA2778ttuKGAletdqL5SKr+qfQgXdG/mNHbF1IQWaCk/XL4MF9IsfTw4VVMToMgZ/MeTp6icL4oY9DavcbkFMqbs4RWDGXcI5qtWfBGqY1hR8Nopm2BW6NBlDb7Q7nDzr/+OQosDVtxkeL7plVu5XZQjdsBYnPrDERxV79Nnr47AcZJi9LgPzCywbFfifK3sAcAt8g+GVfIJfUpCnhlJ8kgB6ip44R0xTA/2RBEZPD2fws0fxSKZw8izY9ID3mDOh1hBPUVvzrBQClgPWAiUAwnEXhR1xb6cHsR6IohgppljmZHo03NLvqNC2+xL02+4xUEHsOYX45zXgC6zRw3SuX5JWXd5kx//QcJ0fwPDXYumeV+xTtqS/l4qFdVl0GACPDSDCnwYDCfGIZKAUwCnXWez8fr9fNV5puZQRn9sUvPHglOQek1MNiR9+5JIrha1DfZlZ11WxYHSZzuKUhbkcnkKgsmBFbScWzBhQGIQCHSPTuCfVVYJviXbIHjCh3+SIZMXf7nek4qiWpoY9rFvIldJoLjYp6t4KX
 B1sr5Ddt
 +hc2iK5VJuJxC2nMxwb5346ePJg13k+EJPhhmmKJ7hHeDmBofFxceSZxHqaa9yAITcKAYpz7LIFipp8f1h9jYg9tciUaX4nOtJJUL9MIpVLZfbSzuFKa8lQRGvFAn0qzPVWFgxpVUg1hMjCGotVALHr8p/U46WeQH61hHVo9aN9oWSEoU24bWPPvcKKi7J0F99L8sPDXHzy5aEV658Cl97ZZS+X1yolVWK6e9pezB2qswgIwKZRYKk4wMT1DWL8bg4Sh0PUCITE4F0r6b66pr8pf9ZtlsskTPetRRLyHuCViuo6WoQQNRVnrWOpj7r69e1sSozTBNCU0sP1NM45fEFehDUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

On 11/4/26 3:07 PM, Muchun Song wrote:
> 
> 
>> On Nov 4, 2026, at 11:27, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> Hi Muchun,
> 
> Hi,
> 
>>
>> On 11/3/26 6:56 PM, Muchun Song wrote:
>>>> On Nov 3, 2026, at 16:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>>
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> With gigantic overcommit enabled, a fault during long-term pinning
>>>> can allocate a fresh HugeTLB folio from CMA despite PF_MEMALLOC_PIN.
>>>>
>>>> The folio must then be migrated before it can be pinned. However,
>>>> fresh gigantic migration targets are not supported, so pinning fails
>>>> when the HugeTLB pool has no suitable target, even if the original
>>>> fault could have allocated pinnable memory outside CMA.
>>>>
>>>> Honor PF_MEMALLOC_PIN in the HugeTLB CMA allocator so the fault can
>>>> try the non-CMA fallback, or fail when allocation is restricted to CMA.
>>> Wait... I think my Acked-by got ahead of me here. :)
>>> There seems to be a rather odd distinction that GUP is missing.
>>> The usual reason long-term GUP must migrate a page out of a
>>> MIGRATE_CMA pageblock is that the page was only borrowed from CMA by the
>>> normal page allocator.  The corresponding CMA bitmap range is still
>>> available, so a future CMA allocation relies on being able to migrate
>>> that page away.  A long-term pin would prevent that.
>>> However, a HugeTLB folio returned by
>>> hugetlb_cma_alloc_frozen_folio() is different.  It is the actual CMA
>>> allocation, not merely a movable page that happens to reside in a
>>> MIGRATE_CMA pageblock.  Its range has already been marked allocated in
>>> the hugetlb CMA bitmap.
>>> Therefore, CMA cannot allocate that range again until the HugeTLB folio
>>> is freed anyway.  Long-term pinning the folio does not seem to make the
>>> CMA area any less available than keeping the HugeTLB folio mapped for
>>> the same amount of time.
>>> folio_is_longterm_pinnable() currently only sees MIGRATE_CMA and does
>>> not distinguish these two cases.  In that light, rejecting
>>> PF_MEMALLOC_PIN in hugetlb_cma_alloc_frozen_folio() looks like working
>>> around an overly broad GUP classification.  It also means that
>>> hugetlb_cma_only users will fail the fault, while other users may consume
>>> a gigantic contiguous range outside the dedicated hugetlb CMA area even
>>> when that area has free space.
>>> Would it make more sense to fix the long-term GUP check instead, so that
>>> an explicitly CMA-allocated HugeTLB folio is considered pinnable, while
>>> ordinary pages merely borrowed from MIGRATE_CMA pageblocks remain unpinnable?
>>
>> Make sense!
>>
>> I'll replace this patch with an exception for HPG_cma folios in the
>> MIGRATE_CMA check. This also lets the HugeTLB allocator select preallocated
>> CMA folios during long-term pinning. MIGRATE_ISOLATE and ZONE_MOVABLE
>> remain restricted.
>>
>> Fresh CMA allocations under PF_MEMALLOC_PIN also need to skip ranges
>> in ZONE_MOVABLE. Returning -EBUSY here lets CMA try its remaining ranges.
>>
>> The incremental diff against this patch is below.
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 8555d38a97b1..7fd1b6e65b58 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -21,11 +21,13 @@
>> #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
>>
>> struct cma;
>> +struct folio;
>>
>> extern unsigned long totalcma_pages;
>> extern phys_addr_t cma_get_base(const struct cma *cma);
>> extern unsigned long cma_get_size(const struct cma *cma);
>> extern const char *cma_get_name(const struct cma *cma);
>> +bool cma_folio_is_pinnable(struct folio *folio);
>>
>> extern int __init cma_declare_contiguous_nid(phys_addr_t base,
>> 			phys_addr_t size, phys_addr_t limit,
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index cb993a1d0728..d15810be7d96 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3,6 +3,7 @@
>> #define _LINUX_MM_H
>>
>> #include <linux/args.h>
>> +#include <linux/cma.h>
>> #include <linux/errno.h>
>> #include <linux/mmdebug.h>
>> #include <linux/gfp.h>
>> @@ -2975,14 +2976,16 @@ static inline bool is_zero_folio(const struct folio *folio)
>> 	return is_zero_page(&folio->page);
>> }
>>
>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>> +/* Borrowed CMA pages and ZONE_MOVABLE folios cannot be pinned long term. */
>> #ifdef CONFIG_MIGRATION
>> static inline bool folio_is_longterm_pinnable(struct folio *folio)
>> {
>> #ifdef CONFIG_CMA
>> 	int mt = folio_migratetype(folio);
>>
>> -	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
>> +	if (mt == MIGRATE_ISOLATE)
>> +		return false;
>> +	if (mt == MIGRATE_CMA && !cma_folio_is_pinnable(folio))
>> 		return false;
> 
> Actually, we do not need cma_folio_is_pinnable(), does the following work for you?

OK, will do.

> 
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2982,6 +2982,9 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
>   #ifdef CONFIG_CMA
>          int mt = folio_migratetype(folio);
> 
> +       if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
> +               return true;
> +
>          if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
>                  return false;
>   #endif

We should move the implementation of folio_is_longterm_pinnable() to
mm/gup.c to avoid the header dependency and build errors.

> 
>> #endif
>> /* The zero page can be "pinned" but gets special handling. */
>> diff --git a/mm/cma.c b/mm/cma.c
>> index a10ea37a261d..c2814f54f86a 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -27,6 +27,7 @@
>> #include <linux/log2.h>
>> #include <linux/cma.h>
>> #include <linux/highmem.h>
>> +#include <linux/hugetlb.h>
>> #include <linux/io.h>
>> #include <linux/kmemleak.h>
>> #include <trace/events/cma.h>
>> @@ -55,6 +56,12 @@ const char *cma_get_name(const struct cma *cma)
>> }
>> EXPORT_SYMBOL_GPL(cma_get_name);
>>
>> +bool cma_folio_is_pinnable(struct folio *folio)
>> +{
>> +	/* Explicit HugeTLB CMA allocations own their bitmap ranges. */
>> +	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
>> +}
>> +
>> static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
>> 					     unsigned int align_order)
>> {
>> @@ -792,6 +799,11 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>> 	int ret = -EBUSY;
>> 	struct page *page = NULL;
>>
>> + 	/* Each range lies within one zone; try other ranges if needed. */
>> +	if ((current->flags & PF_MEMALLOC_PIN) &&
>> + 	    is_zone_movable_page(pfn_to_page(cmr->base_pfn)))
>> +		return -EBUSY;
> 
> I don't know why we need this.

I had assumed that ZONE_MOVABLE pages must always remain unpinnable.
But Documentation/admin-guide/mm/memory-hotplug.rst explicitly states:

   - Memory blocks overlapping with CMA areas cannot be offlined, this 
applies to
     memory blocks present during boot only.

So pinning explicitly CMA-allocated HugeTLB folios does not introduce
an additional offlining restriction. The ZONE_MOVABLE check I added
in cma_range_alloc() is unnecessary, and I'll drop it.

Thanks,
Qi


