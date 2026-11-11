Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73419606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=RCLhcXa5
Received: by kanga.kvack.org (Postfix)
	id 95C346B05B7; Wed, 11 Nov 2026 05:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933AC6B05B8; Wed, 11 Nov 2026 05:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8725D6B05B9; Wed, 11 Nov 2026 05:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69AA76B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:27:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E01ED120246
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:27:29 +0000 (UTC)
X-FDA: 85422461418.14.82A73CD
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf30.hostedemail.com (Postfix) with ESMTP id EDB1280007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:27:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=RCLhcXa5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794392848;
	b=iKq97eY5oR0MpFDU8R6BCnN7YJbdcoRd3SV1qGLHf20HX3vMVY+Ijlbg91r7ZLX125T3iT
	8XVUmVP/XAj8O8lgq6XPZ0CKVGEkXHYWzdtb/Zct4/nk3NCARnq8qAPZSERqwSyqBlgxdN
	2OIioEqROFxwzYz5mvw9NohTJuoUL0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794392848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cZ0TkhgcyZX2/tGIJYKpizu09u/oOKdVnqqr23AXvE=;
	b=FLLcUm3XcU+SyicWChnckk1tSJe/MdkrcbclZMFD0zisLLKLuRDmZmf2+8KSbgC3e+MC1x
	0xxk+EzjBFQV0AIuC9/iiLdEYwYHm4tyuRy7/F49LmovG1+DzfEFoYvNRNJU6N7v12gItQ
	5t0EdWyhEXO+bOJnotViptJyWhIfIR8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=RCLhcXa5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794392840; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+cZ0TkhgcyZX2/tGIJYKpizu09u/oOKdVnqqr23AXvE=;
 b=RCLhcXa5MQfniyrwMiA7R2RvhztQGtFd1uCMdaPJTgKgIpLcp0NMsEGJsqoKZ9tcH11SmL
 e4/OyjxMvUUa35Mld9yhVK4P42mVZ6n9tGZbXJlgOth/8IaPyQVcBL45uT8j0QMSae0V6q
 gfRY5RaygQJw4acnLWjuAjQVzU4k2HGrFCYqmCud8PaXu/D3FeMSCqKZKRsdBjxSBsSCig
 DfFqe6WywIa8T088V3/oREw2YAM/hODO/TzT+ksnyp9iYH4PetyqztJETNdanq0bOF9ncI
 mRG8CIuo+wtTumnMgS8NbEtUJw2LPwNbRJNQoBjCGZ9tXN9hFWBKkAANnlDJag==
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com> <586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com> <7abb3aa1-385a-422f-86bd-7aac9661c4d8@kernel.org> <423c9b28-ecf2-4fab-817d-2fb326690c73@linux.dev> <3a1a3bb5-0b01-4f20-aa0e-74a952544b8c@kernel.org>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Date: Wed, 11 Nov 2026 18:26:58 +0800
Content-Type: text/plain; charset=UTF-8
To: "David Hildenbrand (Arm)" <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <akpm@linux-foundation.org>, <azpijr@gmail.com>, 
	<lance.yang@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>
Subject: Re: [PATCH v3 2/3] mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<stable@vger.kernel.org>
X-Lms-Return-Path: <lba+26af44306+d27ef8+kvack.org+zhengqi.arch@bytedance.com>
In-Reply-To: <3a1a3bb5-0b01-4f20-aa0e-74a952544b8c@kernel.org>
User-Agent: Mozilla Thunderbird
Message-Id: <5f68ffba-9f56-4e31-9e7c-9d110f552efc@bytedance.com>
X-Rspamd-Queue-Id: EDB1280007
X-Rspamd-Server: rspam12
X-Stat-Signature: yeiyr5dnebj6iyoef8pdmx9semb8f8y5
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794392845-877061
X-HE-Meta: U2FsdGVkX18Ps32/EVe2r5H3UCLnNLaRUQhus/JgePRWNyNoxxA6bIW3Iz1BxrfXcaMgzjbQTFSItTY8lVjtLISBL7o2+iAEepsAettAT1zfZCgn+6LtWa24xLJGrEWOPE5QpKsh+RACO+gfCMHFGSdbsWJpY3pQZ+oLCOaRMyjpgbs/n5fC6SGAgnWXfvxXirug25ulGVU/b0gPcZ4Qt5YATOcl04lg7JLQoqiamsOFMfLCa8vYeb/85amAEraHgTCcLeBClfTaRLb77V/SeJPh9wkjKOZSw+qJJK6e7YUt+s9NDVLkYgmtO8AJWg1rmd72dEJCajs1Iv2NZdyT3kkETEpngD7Klr7yVVg9U0WFj4b3nUHWS75FEDBU+XiF8niNcOFijS3xPp5FBfgWQiKOUWcrNU7kPQClALDJzZKlkVsNFninb9o84YJLBQBP2jXugKprmGCShpQ6DDFvpyKy+A7h4sdDQk3fQfcyoZTyaSyPV0t9h33vZS2Eeg/94W26oBFt5D3YwBnzHY0KO59idsnEQH4ZgJli9KQXpgjXwK02tw/jzLE48F1+j7obYZFeyEtzd2OUUjBOsaLbBhJz7wfvW///3h0m8CzrWOnnF7iBxivVWdUph4UIP8ePBXZG09QePTWoI8KhG+mjudhgFwdV7Im12uV2FAgsX8xcfS3ZNx3DUa9whaHMR02WBa5i7q1AdEqa/qUmelT5B6ofd/m5RBzYRePFVinUnh4WoOxYVrR6AvNWt18ecDdRYUgtzy/HGT5ywV+rorX54GvQqWrqGvJ8l55ECLfTH9H6cj/tcTNcSLU04ps/B1HwHC0JNwAmgcKbp+uXmogmerrFJHcI7XIPi2eWwtehA2D+L/n3DEMKf3zisJXnN5+WW0FdFUtuDQYDWGXSY4bBw6sAHWWANL9Hmo27WpzS4bpC658TMqd6RqlrRJ5QNhAR/0zXuosVGioFS67i6vW
 dzPSgoEl
 XWz0+BbXzGkiQmGpdifD/mchkO3qFvH67Nf4vbYwjePjKCA7EL+YSQfV37PZYgIql0uBIi5gIMKqX4a0c0WiKy/6iuSkxH/inIQgGaArEIY/OhD1fZgyw5gPQ9O1/lPztIGC0Lwopxtr2wbeAljC9dZ3OTNGECK7APelP0uGAayK3TODkwFVB7D2qp1J9QfD+sNkrnUibERJH1GI2WYvqqu8nX/OX8hJCbQQctguWni4O0XhH6nZq23ZWBuF8J7IfYOymKw31BtpFQXzUTKtoQmG8pVN6FDRfgds/xJxvh+fHgC8PGe7PZ+Og8vroxiVFla9Vf/oFEfwnmWdyjzYChIEKdYQ3U70YOPz/Ot0u0+lzba6UKjwjKxm4RZSCAYhL9GwKprf6xlAhBsbYfQdiV07hY/E/DMxzBig3AwEsLkTQviSn7zEYzOc2MW5QphD/GpuyBhou7jsHCD341JvWK03PCQW0RpR5IeebPp6vYVuQK6wQY8zNBJdwpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On 11/11/26 3:43 PM, David Hildenbrand (Arm) wrote:
> On 11/9/26 04:10, Qi Zheng wrote:
>>
>>
>> On 11/8/26 1:58 AM, David Hildenbrand (Arm) wrote:
>>> On 11/7/26 11:30, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>>>> unpinnable, causing unnecessary migration or pinning failures.
>>>>
>>>> These folios already own their CMA bitmap ranges, and memory blocks
>>>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>>>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>>>
>>>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
>>>> Cc: stable@vger.kernel.org
>>>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> Acked-by: Muchun Song <muchun.song@linux.dev>
>>>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>>>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>>>> ---
>>>>    include/linux/mm.h | 29 +----------------------------
>>>>    mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>>>>    2 files changed, 32 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 2d0b8a4c9974f..75dd40265d3f4 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct folio *folio)
>>>>    	return is_zero_page(&folio->page);
>>>>    }
>>>>    
>>>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>>>>    #ifdef CONFIG_MIGRATION
>>>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>>> -{
>>>> -#ifdef CONFIG_CMA
>>>> -	int mt = folio_migratetype(folio);
>>>> -
>>>> -	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
>>>> -		return false;
>>>> -#endif
>>>> -	/* The zero page can be "pinned" but gets special handling. */
>>>> -	if (is_zero_folio(folio))
>>>> -		return true;
>>>> -
>>>> -	/* Coherent device memory must always allow eviction. */
>>>> -	if (folio_is_device_coherent(folio))
>>>> -		return false;
>>>> -
>>>> -	/*
>>>> -	 * Filesystems can only tolerate transient delays to truncate and
>>>> -	 * hole-punch operations
>>>> -	 */
>>>> -	if (folio_is_fsdax(folio))
>>>> -		return false;
>>>> -
>>>> -	/* Otherwise, non-movable zone folios can be pinned. */
>>>> -	return !folio_is_zone_movable(folio);
>>>> -
>>>> -}
>>>
>>> Moving code while adding new stuff to it, please don't.
>>>
>>> Move code first, then modify it.
>>>
>>> I don't want to play "find the difference between two pictures" on a Saturday
>>> evening.
>>
> 
> You resent your series way too fast.

Got it.

> 
> Now we have discussions in to threads, congratulations ;)
> 
>> ;), got it.
>>
>> I moved the code to resolve a build dependency.
>>
> 
> Why can't that be resolved differently? What is the dependency?

The dependency is that the new check wants to use
`folio_test_hugetlb_cma()`, which is a HugeTLB-specific inline helper
from `include/linux/hugetlb.h`.

`folio_is_longterm_pinnable()` currently lives in `include/linux/mm.h`,
while `include/linux/hugetlb.h` already includes `linux/mm.h`. So I
can't simply use `folio_test_hugetlb_cma()` from `mm.h`

> 
>>>
>>>> +bool folio_is_longterm_pinnable(struct folio *folio);
>>>>    #else
>>>>    static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>>>    {
>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>> index 2b405cce2ca5c..f41701c603500 100644
>>>> --- a/mm/gup.c
>>>> +++ b/mm/gup.c
>>>> @@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr, int *locked)
>>>>    
>>>>    #ifdef CONFIG_MIGRATION
>>>>    
>>>> +bool folio_is_longterm_pinnable(struct folio *folio)
>>>> +{
>>>> +#ifdef CONFIG_CMA
>>>> +	int mt = folio_migratetype(folio);
>>>> +
>>>> +	/* These HugeTLB folios own the CMA memory, so they can be long-term pinned. */
>>>> +	if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
>>>> +		return true;
>>> More hugetlb hackery ... don't like that, sorry.
>>
>> Agree.
>>
>>>
>>> I think this just goes down to a problem we discussed a while ago that is
>>> independent of hugetlb: we'd need some way to identify that the the page was
>>> actually allocated by the CMA owner, and it's not just some other movable
>>> allcoation that ended up there.
>>>
>>> For something generic non-hugetlb thing, can't we call into CMA to ask whether
>>> the current chunk is marked allocated?
>>
>> The existing bitmap is set before allocation completes, so the range
>> may still contain borrowed movable pages. A set bit alone cannot
>> establish ownership.

The more accurate code path is as follows.

Assuming the 2M buddy allocation is successful, page P is borrowed from
the 1G CMA area.

Now, proceed to request a new 1G huge page:

only_alloc_fresh_hugetlb_folio
--> alloc_gigantic_frozen_folio
     --> hugetlb_cma_alloc_frozen_folio
         --> cma_range_alloc
                 /* set bitmap!! */
             --> bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);

                 <time A>

                 /* may fail */
                 alloc_contig_frozen_range

         /* set HPG_cma!! */
         folio_set_hugetlb_cma(folio);

At time A, for page P, a bitmap was set, but HPG_cma was not set.

If a concurrent FOLL_LONGTERM pin uses the bitmap alone to determine
ownership, it could incorrectly allow P to remain pinned. If
alloc_contig_frozen_range() fails, cma_range_alloc() clears the bitmap
bits, while the long-term pin on P remains.

HPG_cma is set only after explicit CMA allocation succeeds. It records
the folio's own CMA ownership, whereas a set bitmap bit can represent
another allocation's in-flight reservation. Therefore, the bitmap
alone cannot replace HPG_cma in this check.

>>
>> A generic query may need separate ownership tracking, such as an
>> owned_bitmap recording successfully allocated pages. Its updates and
>> lookups would also need to handle concurrency with fast GUP.
> 
> Or simply two bitmaps? "trying allocation - allocated"

As a fix, perhaps this is a bit too complex? :(

Alternatively, we could adjust the timing for setting the bitmap, though
this might introduce new concurrency issues.

Thanks,
Qi


