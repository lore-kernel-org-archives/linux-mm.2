Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A72606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gtbDVREB
Received: by kanga.kvack.org (Postfix)
	id 367716B05B1; Sun,  8 Nov 2026 22:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3173E6B05B2; Sun,  8 Nov 2026 22:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255896B05B3; Sun,  8 Nov 2026 22:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00C216B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:10:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68726A8179
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:10:18 +0000 (UTC)
X-FDA: 85414102116.01.F44D00D
Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB35740003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:10:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtbDVREB;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794193816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7YFoYH+pqizVWJtbykpYVkcry3ho5h+U0NhjdmQOV4=;
	b=w36CwFrDtg/lPUx1vzGZSzfmOaksA1R1/hDY9wUQOHpA8glXFKShvzwZodcuVCm2ZebfDy
	hgXjc2qOU80Ml6MiQJ7zLyIHp6rqZi/TbLMZt+BGTj2TkTbVKvjWSAtzoc3Q2f866zyRmM
	diQuQFm8gxiunU+LUjiPE1An+wJQbb0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtbDVREB;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794193816;
	b=xUt5ld1BTI11xh+1p+sviiF8bTrqbBfYrwT0TWX2lUfmxaos56budkQOMD/KoIYc/xlRgZ
	E0XdU7CY0BLOSdoP0uwq828A51Lu+nGkgsCzS2/Ah0MzixqfLTsCBo3vsZZbAGL4UAlVEx
	D8W8t+3SuorSc0WJTqq1kQmcat7KEV4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7Na7xjzcQd16juEXNoMu7pYk4KLFnTP5KHehCh6IFWE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794193813; v=1; x=1794798613;
 b=gtbDVREBKlXmZiiQn37nboEHI2/a0a20du9yKFge83pgGuSGnnJnWOdvyIUGVWhK9MPfmf8b
 RX9ADc8PDttBKuZ8wChz8b+rwNyNdarOiNrWfZR3x4yHDAAzQhnU5Xp0wtDMKweiSWKCeHnDzs5
 W45HOEGmg5bHLrY9e6j8bN9s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1ae66134428fd04f;
	Mon, 09 Nov 2026 03:10:10 +0000
X-Mizu-Trace-ID: 1ae66134428fd04f
X-Migadu-Flow: FLOW_OUT
Message-ID: <423c9b28-ecf2-4fab-817d-2fb326690c73@linux.dev>
Date: Mon, 9 Nov 2026 11:10:02 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com,
 lance.yang@linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com>
 <7abb3aa1-385a-422f-86bd-7aac9661c4d8@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <7abb3aa1-385a-422f-86bd-7aac9661c4d8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cchqx44herir6ahccmtb4siioredx78a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: BB35740003
X-HE-Tag: 1794193814-448601
X-HE-Meta: U2FsdGVkX1/N5qTh0pfPymVr21Ii5GqVZK5CP0ziHTGyRghB1mBXpjaR17wgzdlF7TAxTzHz+jbdr5JgIeo5WEEqpLslLMWDk/drmFdTomRoyPfnwY+baDx3C6mZ9yU9XM79uT9ymPsyZUwpW03mkxXaIwvryhJdUaQCh/f59RF/vMU95wK/M2KL2hhdPOHKb5e1tVAjmIeQWhBJjKlBIr7+yiLNPUOCXfXzRno/BBtx7dHWMQ7DtyH+SKKfBN6nr/rWY932lMTnnxsyH+a+OW9qPlK5Pn+qmYZAgFzVyWmScSGIeuFkAmwrOeKGz0p7jVcMbFJeCgc4Lhe9jklHQ3/h0nj1gTOSpbXYXkolKtOKZ8Itg2qqP3FWLUAwvqMkgqZEqoXCrOLhh/BKEktDrhYnvD6XdjBG8HKhxGOTN2K4Qj8Jj1pzRhHEeoFsk1FAmcm4QrlqhEsOt4U349rJx4XJeRuagTIDIuXDunMX55CAp/FTSZHm/6pV979ptXkkJR6L4MEzY7DvdIiVma4s917rqEEENAnuEjmMIVO42TrJ7w/4UfVRV3ze7SaDhzR6uILu0mYWE760lyuNkq9bb3zfeKdQLa8jcD6ZGPYjvwTvYpBaqRb+Z3NjjSbY1YBEOCAfuq23fqpktlxxKa3V+Rpg3WnbLo4sblYe32yadfKLoWb6JGbCFyOpVX11JOHDsDBvm9odcq66RW0UvIfVGbJlJBuX/RJv70pQtPEPZEC73N/y/Sjk0/WkLzD2dGDhTVDMacaRJ552GuraC7CHEFJL5IdUKWPf9fDqNYl60fVA1NVcz50M0ihJCNPF3KHMei111AIDaXyBpRFECvha8NaE79K4lUwtPop1cSwzAwCRu/svGH6q3zQ4YVf3vwL/jHb+9U+pTT77jPyvKQEfOyP5DM1g9XhH5GOv9qhIie2RZaRoI4reAbJ3rpkqNM7nhdovfY3a/1OOXEyCd68
 Nrl/6xGR
 V15Le75Oc4FfJ6s+VH8567KKRwuP1syXcDSNqf5eNrcoAjWOSUJoqBsDZqWAYUJpe6q8EU0Ew8SDXndC4sCmqYpywynhWcRK/HkYjULTEIWV+hjOazNAQ1IorpgSmi9wlF2XSuS/4w/AfucpBmvZPyEyEFYEVJe65CKcqg5ZFTKQnlm+wK9dAYH8EVfaWNgHN4YMvcI69enQ6ud+zeb7Vp0OtZPQfH7eusqluYALR6qmtqQX7VSoiNL0ckvzQsMcCCOKnVtZyOCGHgFV+y7LJFYLX8LRPNTBiWX4KvhPdzrTZvNYqpYDulL+dID++cV1kogMQnt/VtHPQ7d+EKePgufqQUDtL1Rk2S+Hd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/8/26 1:58 AM, David Hildenbrand (Arm) wrote:
> On 11/7/26 11:30, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>> unpinnable, causing unnecessary migration or pinning failures.
>>
>> These folios already own their CMA bitmap ranges, and memory blocks
>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>
>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>>   include/linux/mm.h | 29 +----------------------------
>>   mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>>   2 files changed, 32 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 2d0b8a4c9974f..75dd40265d3f4 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct folio *folio)
>>   	return is_zero_page(&folio->page);
>>   }
>>   
>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>>   #ifdef CONFIG_MIGRATION
>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
>> -{
>> -#ifdef CONFIG_CMA
>> -	int mt = folio_migratetype(folio);
>> -
>> -	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
>> -		return false;
>> -#endif
>> -	/* The zero page can be "pinned" but gets special handling. */
>> -	if (is_zero_folio(folio))
>> -		return true;
>> -
>> -	/* Coherent device memory must always allow eviction. */
>> -	if (folio_is_device_coherent(folio))
>> -		return false;
>> -
>> -	/*
>> -	 * Filesystems can only tolerate transient delays to truncate and
>> -	 * hole-punch operations
>> -	 */
>> -	if (folio_is_fsdax(folio))
>> -		return false;
>> -
>> -	/* Otherwise, non-movable zone folios can be pinned. */
>> -	return !folio_is_zone_movable(folio);
>> -
>> -}
> 
> Moving code while adding new stuff to it, please don't.
> 
> Move code first, then modify it.
> 
> I don't want to play "find the difference between two pictures" on a Saturday
> evening.

;), got it.

I moved the code to resolve a build dependency.

> 
>> +bool folio_is_longterm_pinnable(struct folio *folio);
>>   #else
>>   static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>   {
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 2b405cce2ca5c..f41701c603500 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr, int *locked)
>>   
>>   #ifdef CONFIG_MIGRATION
>>   
>> +bool folio_is_longterm_pinnable(struct folio *folio)
>> +{
>> +#ifdef CONFIG_CMA
>> +	int mt = folio_migratetype(folio);
>> +
>> +	/* These HugeTLB folios own the CMA memory, so they can be long-term pinned. */
>> +	if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
>> +		return true;
> More hugetlb hackery ... don't like that, sorry.

Agree.

> 
> I think this just goes down to a problem we discussed a while ago that is
> independent of hugetlb: we'd need some way to identify that the the page was
> actually allocated by the CMA owner, and it's not just some other movable
> allcoation that ended up there.
> 
> For something generic non-hugetlb thing, can't we call into CMA to ask whether
> the current chunk is marked allocated?

The existing bitmap is set before allocation completes, so the range
may still contain borrowed movable pages. A set bit alone cannot
establish ownership.

A generic query may need separate ownership tracking, such as an
owned_bitmap recording successfully allocated pages. Its updates and
lookups would also need to handle concurrency with fast GUP.

> 
> If that's too hard, we could add a temporary hugetlb hack.

For this fix, I'd prefer to keep the current check.

> 
> But we all hate hugetlb hacks. :)

+1.

> 


