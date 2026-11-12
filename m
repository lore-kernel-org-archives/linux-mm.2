Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B965606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LFZVCmgP
Received: by kanga.kvack.org (Postfix)
	id 9F0706B05B5; Wed, 11 Nov 2026 22:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1136B05B6; Wed, 11 Nov 2026 22:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890216B05B7; Wed, 11 Nov 2026 22:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50E696B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:28:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9D0D4045B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:27:59 +0000 (UTC)
X-FDA: 85425033078.28.E4C4E75
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf05.hostedemail.com (Postfix) with ESMTP id B49B9100005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:27:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LFZVCmgP;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794454078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJxtok8nywZ/TQgGJyWa/+E2CH+0K50OeaFCvC/H71M=;
	b=x3VPLSN5WT5jNVJkj37idCdQQzO9ygHfaqcfQyWixAxsDl0Zl+/jqXgT9h+GH3XsMu+9rv
	E/zHuMpMA91SsFn6OWo/SAPe4AbXzMbQcTkjIAALu8lKIsOmdh8CLud8HUWJ0ZW3RgT4f3
	OqgotOE98NbBZN9x5bw89zhNpolQZQM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794454078;
	b=t+JdINr6qbOJrz2IKWXcLju8vt3WeTk1PsosPdjzuf+pFamAlJ8mKpv4nl7srx2Gt5QEry
	EprSR5Kz16GBaovY3MGOaJsQeiGu0HAkEGaS0seBQsnp0kfnCT2CnsMI3Iw7k9EPeoJ9V7
	UMNxb/0XdSrvvdQoD76gF8URdK11LjA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LFZVCmgP;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mcfYyT8ssdEa144YgXQss8K/JkNJiAW/50JOamvyaFE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794454076; v=1; x=1795058876;
 b=LFZVCmgPiTIEZJ1A5tKZkTFVNGFy6F8sQZ2z7v+0VqqrwOkK5MOLVGteCp7csaavOOeLXOx5
 K6UfAumPyZ11XL6I5aYTeBGMC71C1H4tuBPor6bSUp22nfLMw3qyguuCO94Wo7BFwnxfmZ8bw2t
 CXeuegxbcWb8tSb2xRQ7B7Tw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d517d826f1cb946c;
	Thu, 12 Nov 2026 03:27:56 +0000
X-Mizu-Trace-ID: d517d826f1cb946c
X-Migadu-Flow: FLOW_OUT
Message-ID: <64a49d81-c836-49b2-890a-096f5ce5e318@linux.dev>
Date: Thu, 12 Nov 2026 11:27:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Frank van der Linden <fvdl@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com>
 <7abb3aa1-385a-422f-86bd-7aac9661c4d8@kernel.org>
 <423c9b28-ecf2-4fab-817d-2fb326690c73@linux.dev>
 <3a1a3bb5-0b01-4f20-aa0e-74a952544b8c@kernel.org>
 <5f68ffba-9f56-4e31-9e7c-9d110f552efc@bytedance.com>
 <CAPTztWb0XbjCxtihyp=Tx16Z_kjF+M8sa7YcUjvFv0WcS83MAg@mail.gmail.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAPTztWb0XbjCxtihyp=Tx16Z_kjF+M8sa7YcUjvFv0WcS83MAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: pr5ektb7pucwqsws1kibzy7as78dkcy4
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: B49B9100005
X-Rspam-User: 
X-HE-Tag: 1794454077-515962
X-HE-Meta: U2FsdGVkX19Md5SCydVuoVXOkCDRwKsDBK2+OkogUP9Yn+jwZ6j438ofRYIBwZHeXsOz187dZ/nMdBFyvj1XUy9scOnMAWf8jvrSeuB1jwb623PRu/Ipu5tNDy6JPcrNAILW/WbzYCQDDq66jRN+3Yb0OBMmvu/wts6lvDrhDvumI7dBdcF7yfOS6T5DECsyOfpgb5YYEe3Kw4lfhcogNxMnWPZZxh3YdKZyp/ViaPt+gHWCHIMDQvvAclIwlZ0HxxyN9nWlnL9tDGRaGeZzeqKLp6WynvPM+3T4Tvygji57z8+uldELzadjgoHn9yaLaQM8KYUP6nt1JRPkweIAd79CfEB7galpCzZUAo5vzpbK94hb0HJw0CMul4o0RcqwEyzaD489BHQyBNDvhHGMzMIL88SoioD5x3gKdFv2p/z/xEG7T+jL9BP8txaWBf1UzpL4sj1YORdS5Qb9YIgqjJkB5IW9r/ac+tFiCuL4JlnDa8vPG9FDs5SA3jaiQq0P+GTmRMLu2vhTf0d7ncuNCId3E1+xt6uitMavOWHr8OO840kegFn3A5kJ8Y8UWPp2SF3dYafnmr2M5ny7m2PTMc99KMgPTbpLOmiG7ewiZdYYbV2GiMllrvME+Q1BjKCCE0MitrSr0sVVfPG74pdzk1miNdcex33dObJlCXuYrWiigdRG/c9T2Au5NL+28rRf7IoyU0TCiORYfB0RhOJop9J9AV6jq1bMy8zunZZvDLAQmxsD03v2j45iYgrC31BvBOThweSlqdgaQ2xsCaNJOL4Sp5yPsSWD0cdfaAnZIgx0sgum2TJn1epI6EEg5wZSvBZvNc9e66AYhm530lq7ThhSv/jTn56UfQqHXIjx95aDxNlCJkWQdAlB8Ger4T/NDuX/1n8yCGNUR/FrLHIvic7hlpY7dQ7SbUkIEDm2ps8r3oXeBLau56pJsvFkuarDlF76w0D3r7ghj/RN+0+
 /wz2fSFE
 tICLsOuRt8qB0qnJ2uORuSNBzzPQC8gu4pB/QPgPnqhya2NW5LbQZX8pnA7kQ6TLK1q1bl/BUCC2+DIOwfs7e8WaxX8CyoGC8IgS2IjUfa8Kl5Ryr8rEGTZ8D5pj9yqo9bU/st2IhofYS1myze5uoFPqTzp6EAD0D/tzfkfydIewQngvuoOMvzmC9283huoYoGtAmI3692AhMWGYRqi0DJ8QltCo1YwfoiMxbr8yM8YBYLDGkfsvCIcOJ2OIBcQQ2AVdELcRneLl34mgziZwWY0kMjBJz5tkJRXlIexwHnBu52A+gC5rM1YmCcvVaJ1scKuMnFZOXltBBPjgENkLydYAD33a3H74islqhKoFoshVMT8UF2C9R8E5InlqtQeXb0K0YNNOcv9KpjEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 6:26 AM, Frank van der Linden wrote:
> On Wed, Nov 11, 2026 at 2:27 AM Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>>
>> Hi David,
>>
>> On 11/11/26 3:43 PM, David Hildenbrand (Arm) wrote:
>>> On 11/9/26 04:10, Qi Zheng wrote:
>>>>
>>>>
>>>> On 11/8/26 1:58 AM, David Hildenbrand (Arm) wrote:
>>>>> On 11/7/26 11:30, Qi Zheng wrote:
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>>>>>> unpinnable, causing unnecessary migration or pinning failures.
>>>>>>
>>>>>> These folios already own their CMA bitmap ranges, and memory blocks
>>>>>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>>>>>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>>>>>
>>>>>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>> Acked-by: Muchun Song <muchun.song@linux.dev>
>>>>>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>>>>>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>>>>>> ---
>>>>>>     include/linux/mm.h | 29 +----------------------------
>>>>>>     mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>>>>>>     2 files changed, 32 insertions(+), 28 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>>> index 2d0b8a4c9974f..75dd40265d3f4 100644
>>>>>> --- a/include/linux/mm.h
>>>>>> +++ b/include/linux/mm.h
>>>>>> @@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct folio *folio)
>>>>>>             return is_zero_page(&folio->page);
>>>>>>     }
>>>>>>
>>>>>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>>>>>>     #ifdef CONFIG_MIGRATION
>>>>>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>>>>> -{
>>>>>> -#ifdef CONFIG_CMA
>>>>>> -  int mt = folio_migratetype(folio);
>>>>>> -
>>>>>> -  if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
>>>>>> -          return false;
>>>>>> -#endif
>>>>>> -  /* The zero page can be "pinned" but gets special handling. */
>>>>>> -  if (is_zero_folio(folio))
>>>>>> -          return true;
>>>>>> -
>>>>>> -  /* Coherent device memory must always allow eviction. */
>>>>>> -  if (folio_is_device_coherent(folio))
>>>>>> -          return false;
>>>>>> -
>>>>>> -  /*
>>>>>> -   * Filesystems can only tolerate transient delays to truncate and
>>>>>> -   * hole-punch operations
>>>>>> -   */
>>>>>> -  if (folio_is_fsdax(folio))
>>>>>> -          return false;
>>>>>> -
>>>>>> -  /* Otherwise, non-movable zone folios can be pinned. */
>>>>>> -  return !folio_is_zone_movable(folio);
>>>>>> -
>>>>>> -}
>>>>>
>>>>> Moving code while adding new stuff to it, please don't.
>>>>>
>>>>> Move code first, then modify it.
>>>>>
>>>>> I don't want to play "find the difference between two pictures" on a Saturday
>>>>> evening.
>>>>
>>>
>>> You resent your series way too fast.
>>
>> Got it.
>>
>>>
>>> Now we have discussions in to threads, congratulations ;)
>>>
>>>> ;), got it.
>>>>
>>>> I moved the code to resolve a build dependency.
>>>>
>>>
>>> Why can't that be resolved differently? What is the dependency?
>>
>> The dependency is that the new check wants to use
>> `folio_test_hugetlb_cma()`, which is a HugeTLB-specific inline helper
>> from `include/linux/hugetlb.h`.
>>
>> `folio_is_longterm_pinnable()` currently lives in `include/linux/mm.h`,
>> while `include/linux/hugetlb.h` already includes `linux/mm.h`. So I
>> can't simply use `folio_test_hugetlb_cma()` from `mm.h`
>>
>>>
>>>>>
>>>>>> +bool folio_is_longterm_pinnable(struct folio *folio);
>>>>>>     #else
>>>>>>     static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>>>>>     {
>>>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>>>> index 2b405cce2ca5c..f41701c603500 100644
>>>>>> --- a/mm/gup.c
>>>>>> +++ b/mm/gup.c
>>>>>> @@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr, int *locked)
>>>>>>
>>>>>>     #ifdef CONFIG_MIGRATION
>>>>>>
>>>>>> +bool folio_is_longterm_pinnable(struct folio *folio)
>>>>>> +{
>>>>>> +#ifdef CONFIG_CMA
>>>>>> +  int mt = folio_migratetype(folio);
>>>>>> +
>>>>>> +  /* These HugeTLB folios own the CMA memory, so they can be long-term pinned. */
>>>>>> +  if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
>>>>>> +          return true;
>>>>> More hugetlb hackery ... don't like that, sorry.
>>>>
>>>> Agree.
>>>>
>>>>>
>>>>> I think this just goes down to a problem we discussed a while ago that is
>>>>> independent of hugetlb: we'd need some way to identify that the the page was
>>>>> actually allocated by the CMA owner, and it's not just some other movable
>>>>> allcoation that ended up there.
>>>>>
>>>>> For something generic non-hugetlb thing, can't we call into CMA to ask whether
>>>>> the current chunk is marked allocated?
>>>>
>>>> The existing bitmap is set before allocation completes, so the range
>>>> may still contain borrowed movable pages. A set bit alone cannot
>>>> establish ownership.
>>
>> The more accurate code path is as follows.
>>
>> Assuming the 2M buddy allocation is successful, page P is borrowed from
>> the 1G CMA area.
>>
>> Now, proceed to request a new 1G huge page:
>>
>> only_alloc_fresh_hugetlb_folio
>> --> alloc_gigantic_frozen_folio
>>       --> hugetlb_cma_alloc_frozen_folio
>>           --> cma_range_alloc
>>                   /* set bitmap!! */
>>               --> bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
>>
>>                   <time A>
>>
>>                   /* may fail */
>>                   alloc_contig_frozen_range
>>
>>           /* set HPG_cma!! */
>>           folio_set_hugetlb_cma(folio);
>>
>> At time A, for page P, a bitmap was set, but HPG_cma was not set.
>>
>> If a concurrent FOLL_LONGTERM pin uses the bitmap alone to determine
>> ownership, it could incorrectly allow P to remain pinned. If
>> alloc_contig_frozen_range() fails, cma_range_alloc() clears the bitmap
>> bits, while the long-term pin on P remains.
>>
>> HPG_cma is set only after explicit CMA allocation succeeds. It records
>> the folio's own CMA ownership, whereas a set bitmap bit can represent
>> another allocation's in-flight reservation. Therefore, the bitmap
>> alone cannot replace HPG_cma in this check.
>>
>>>>
>>>> A generic query may need separate ownership tracking, such as an
>>>> owned_bitmap recording successfully allocated pages. Its updates and
>>>> lookups would also need to handle concurrency with fast GUP.
>>>
>>> Or simply two bitmaps? "trying allocation - allocated"
>>
>> As a fix, perhaps this is a bit too complex? :(
>>
>> Alternatively, we could adjust the timing for setting the bitmap, though
>> this might introduce new concurrency issues.
>>
>> Thanks,
>> Qi
> 
> Yeah, ideally there would be a way to identify folios allocated
> through cma_alloc. But that would probably require.. dare I say.. a
> page flag. Trying to check bitmaps does seem too complex.

Agree.

> 
> And, since we've had a local change that does exactly the same thing
> for a few years (which I apparently forgot to send along with other
> hugetlb_cma changes), I can confirm that this looks good to me and
> works. So,
> 
> Reviewed-by: Frank van der Linden <fvdl@google.com>

Thanks for your review and confirmation!





