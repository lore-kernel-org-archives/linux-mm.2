Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E58FF9EDDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC126B0088; Wed, 22 Apr 2026 10:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1E26B008A; Wed, 22 Apr 2026 10:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AC56B009B; Wed, 22 Apr 2026 10:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 540E36B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:38:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1BB888F9C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:38:56 +0000 (UTC)
X-FDA: 84686448672.11.4D6BFB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id D40ED1C0007
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:38:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W08n2B3Y;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eyUaTU0CVIFtmTrJ8vtbb6QZ7PyYjBInREV0p+07zU=;
	b=hcdnH7rhX45B/pK8SG9pVXPG7YQDrmK+3bQ8iRYlsjprIVnvqkioU6kd+u1/CWen38nCyt
	NF/ADr3j0biIHL+3Ep3VuRWjSImF/62nM8OI9VxKOZAGlwz0JdKwBMibtDtpV4GrbBLsgL
	RXqNK0i5q3JaM0MkYsfipfVYzI9k/E0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868735; a=rsa-sha256;
	cv=none;
	b=B4l6qnNFm05M0HaasYQOMkc5AWZmMWHvQpRAoUKziG9XMchoclXxw5KmmHahL19r5TFdna
	WdZHB9MdiKp2f4Ce9idH3HQRV4twkhMakqnuDg/sEj1w3Dqzl/XrOcJBwK40yHEC3dhZxU
	/kTppKafNF2LA5i/kds5HDMcPl7MAcI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W08n2B3Y;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 173DF1E8D;
	Wed, 22 Apr 2026 07:38:48 -0700 (PDT)
Received: from [10.57.89.34] (unknown [10.57.89.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 904E93FAA1;
	Wed, 22 Apr 2026 07:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776868733; bh=Xrgkm+0kXePlk4LD7snBzLT1KSb19JMomxWo9tugXj8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=W08n2B3YtUPquAxkxgpBOQgH5VzHwppyE3On+NLo3MUHthAWqV1lcdHjKIpPCJ3cA
	 5vxvmBluQsszoElgXA6YnvTy4A7KCnVDa6fSUubOJDf1EFAQC0pRaNoEPHNH2tPE8s
	 rGgnCwPEq+dJkBpjYw8jJEpsNkx3aEoyHfqhZJx4=
Message-ID: <25c78859-f514-47ac-a3b9-7dcde101f72d@arm.com>
Date: Wed, 22 Apr 2026 15:38:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] vmalloc: add __GFP_SKIP_KASAN support
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-2-usama.anjum@arm.com>
 <727df89e-2069-4a7d-b3c0-88f89cd3dcf8@arm.com>
 <e772bbfc-1f77-478e-b378-7947ca7a8b3f@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <e772bbfc-1f77-478e-b378-7947ca7a8b3f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hwm613esfzyeqskmpmi8nhzarzmncb94
X-Rspam-User: 
X-Rspamd-Queue-Id: D40ED1C0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1776868734-423822
X-HE-Meta: U2FsdGVkX1+eGpgHMHATSe7HiSwFT9yJzYiZeWtrs1e0swxCtHvtPfLvQXYm/lg25YzIOi0otOcFqrMP5ZnBetNaFrho6Tegmx/a9svWPAdOsCpBe6Z75QIO7wdVl9r6u1tT0u1jIt8BQs7cgJUpmmxLrPptAXi86sXJrFrPE5tBsoCtRIWg4K5sLiQWfPiXt33gMOSrfwAummJqvKF0ZqlBR1H9FirSHyWOK6UDIWjk3l16GqcxPFesZCkUegGGmz3Wy9ki3dl2CHEgApnJBCKKrBSu8k+AmLzR4aJAryAFjX14yffARcSrZdrg/JdOX9H0Gd72lO8fEYJcuVZBxHb46FRSX9WkjHxFOtq8SDGYnwuRH+Oi4mCtYInZTB7tm2cyL1s6Huf9mduWpbBdPa+q7xSoUs9vyUB0bqrWP/QHjMku+rBSHQj54aU1GzcxbKgGCrILr8LhBqITbXI1H6Nh2EL3fOygHivnaWvztNHY+8Aa5vC+2qqwf9pbQHq06D34w5QwcHwFYNCBlARCv5UZsXw7YELfjf/TnH0lqPb3VE07n6X5gCPExEEJXdRurOzjmFoxjzSjROk2wcjnxXl9tSBvIppZb0aF0MUT/lhkqvMwAAWEobz0McBMinxONUQ8xKxWS0/fZjSKgMqRBfwavt2FMeWJK9vJGwuZ8JheW1A93IMzkmlPTVWpOAwrz4Ogjn1JLFnZd/nj/hqIJIbNN6M19qo9muBawqN4z2IYBh2tkyw3VChnol5SApYvSbVpne+FaiArJ4GFvAqYf2wDn4rmr24kVRM2sH7cX9zok7s81lA4u/4+a+VDTgpTlcQ0d4+GXxyz4uN8ab+QeYUip3AhlwXM+3xnbqsSU4jGh70YV9IhfDM0VZG85u9FHTn4qpKwRGum5RynPAF+fLT9dwWiSxOA+Egi7D6GtnOOIZfZzXSpVrVAPzek0Dfqu/t4ktXVsEYTzSUNbDH
 CTZBMznQ
 1/idKvkegkixhXZUF9I3jUgO8KbR6yNVGgpc4PjrgqvgG58z3FnRvcQORD5+ayp35OlpjWQsElGPKrBR4dW5k4VgLXr/Z/hwm7YeJK15YrQEuwqK9rM2n4KJA9x71sFEauyDvlXvZQjoYAbp+A2CCs3vztfWexiBs4i/hxY2ODUFoa8KHlrNjDEt3GN54wlYlPbbFqLIzr82NcId2rDoyjLpfTAwwEKvZIK43DBeLHq+o4MNIOat4QCktdplq7hLcVIjbuA0NQhkvJAjGKF9Hxzdrfn7KZnv0IOCejiss6N15ZAhatWYzYxD0jskvmOnhsOBMvb4ULdXD8Rc1x7o0v82XpGSvQdx3eXrFGDdUWOEv28cEr7/C+XctLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/04/2026 15:23, Dev Jain wrote:
> 
> 
> On 22/04/26 6:51 pm, Ryan Roberts wrote:
>> On 24/03/2026 13:26, Muhammad Usama Anjum wrote:
>>> For allocations that will be accessed only with match-all pointers
>>> (e.g., kernel stacks), setting tags is wasted work. If the caller
>>> already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
>>> don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
>>> returns early without tagging.
>>>
>>> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
>>> APIs. So it wasn't being checked. Now its being checked and acted
>>> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
>>> defined there.
>>>
>>> This is a preparatory patch for optimizing kernel stack allocations.
>>>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>> Changes since v1:
>>> - Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
>>>   is zero in non-hw-tags mode.
>>> - Add __GFP_SKIP_KASAN to GFP_VMALLOC_SUPPORTED list of flags
>>> ---
>>>  mm/vmalloc.c | 11 ++++++++---
>>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index c607307c657a6..69ae205effb46 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>>>  				__GFP_NOFAIL | __GFP_ZERO |\
>>>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>>>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>>> -				GFP_USER | __GFP_NOLOCKDEP)
>>> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>>>  
>>>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>>>  {
>>> @@ -3980,6 +3980,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>>>   *
>>>   * %__GFP_NOWARN can be used to suppress failure messages.
>>>   *
>>> + * %__GFP_SKIP_KASAN can be used to skip poisoning
>>
>> You mean skip *un*poisoning, I think? But you would only want this to apply to
>> the actaul pages mapped by vmalloc. You wouldn't want to skip unpoisoning for
>> any allocated meta data; I think that is currently possible since the gfp_flags
>> that are passed into __vmalloc_node_range_noprof() are passed down to
>> __get_vm_area_node() unmdified. You probably want to explicitly ensure
>> __GFP_SKIP_KASAN is clear for that internal call?
>>
>>> + *
>>>   * Can not be called from interrupt nor NMI contexts.
>>>   * Return: the address of the area or %NULL on failure
>>>   */
>>> @@ -4041,7 +4043,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>>  	 * kasan_unpoison_vmalloc().
>>>  	 */
>>>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
>>> -		if (kasan_hw_tags_enabled()) {
>>> +		bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
>>> +
>>> +		if (kasan_hw_tags_enabled() && !skip_kasan) {
>>>  			/*
>>>  			 * Modify protection bits to allow tagging.
>>>  			 * This must be done before mapping.
>>> @@ -4057,7 +4061,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>>  		}
>>>  
>>>  		/* Take note that the mapping is PAGE_KERNEL. */
>>> -		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
>>> +		if (!skip_kasan)
>>> +			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
>>
>> It's pretty ugly to use the absence of this flag to rely on
>> kasan_unpoison_vmalloc() not unpoisoning. Perhaps it is preferable to just not
>> call kasan_unpoison_vmalloc() for the skip_kasan case?
>>
>>>  	}
>>>  
>>>  	/* Allocate physical pages and map them into vmalloc space. */
>>
>> Perhaps something like this would work:
>>
>> ---8<---
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c31a8615a8328..c340db141df57 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3979,6 +3979,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>>   * under moderate memory pressure.
>>   *
>>   * %__GFP_NOWARN can be used to suppress failure messages.
>> +
>> + * %__GFP_SKIP_KASAN skip unpoisoning of mapped pages (when prot=PAGE_KERNEL).
>>   *
>>   * Can not be called from interrupt nor NMI contexts.
>>   * Return: the address of the area or %NULL on failure
>> @@ -3993,6 +3995,9 @@ void *__vmalloc_node_range_noprof(unsigned long size,
>> unsigned long align,
>>  	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
>>  	unsigned long original_align = align;
>>  	unsigned int shift = PAGE_SHIFT;
>> +	bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
>> +
>> +	gfp_mask &= ~__GFP_SKIP_KASAN;
> 
> Okay so this is so that metadata allocation can keep using normal
> page allocator side unpoisoning.

Yes.

> 
>>   	if (WARN_ON_ONCE(!size))
>>  		return NULL;
>> @@ -4041,7 +4046,7 @@ void *__vmalloc_node_range_noprof(unsigned long size,
>> unsigned long align,
>>  	 * kasan_unpoison_vmalloc().
>>  	 */
>>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
>> -		if (kasan_hw_tags_enabled()) {
>> +		if (kasan_hw_tags_enabled() && !skip_kasan) {
> 
> Why do we want to elide GFP_SKIP_ZERO (set below) in this case?

You mean why do we want to skip initializing the allocated memory to zero for
the case where kasan HW_TAGS is enabled and we are not skipping kasan unpoisoning?

Because setting tags at the same time as zeroing the memory is less expensive
than doing them both as separate operations. So we tell page_alloc not to bother
zeroing the memory and kasan_unpoison_vmalloc() does it at the same time as
setting the tags instead. See kasan_unpoison() which ultimately calls
mte_set_mem_tag_range().

> 
>>  			/*
>>  			 * Modify protection bits to allow tagging.
>>  			 * This must be done before mapping.
>> @@ -4054,6 +4059,12 @@ void *__vmalloc_node_range_noprof(unsigned long size,
>> unsigned long align,
>>  			 * poisoned and zeroed by kasan_unpoison_vmalloc().
>>  			 */
>>  			gfp_mask |= __GFP_SKIP_KASAN | __GFP_SKIP_ZERO;
>> +		} else if (skip_kasan) {
>> +			/*
>> +			 * Skip page_alloc unpoisoning physical pages backing
>> +			 * VM_ALLOC mapping, as requested by caller.
>> +			 */
>> +			gfp_mask |= __GFP_SKIP_KASAN;
>>  		}
>>   		/* Take note that the mapping is PAGE_KERNEL. */
>> @@ -4078,7 +4089,8 @@ void *__vmalloc_node_range_noprof(unsigned long size,
>> unsigned long align,
>>  	    (gfp_mask & __GFP_SKIP_ZERO))
>>  		kasan_flags |= KASAN_VMALLOC_INIT;
>>  	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
>> -	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
>> +	if (!skip_kasan)
>> +		area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
> 
> I really think we should do some decoupling here - GFP_SKIP_KASAN means,
> "skip KASAN when going through page allocator". > Now we reuse this flag
> to skip vmalloc unpoisoning.
> 
> Some code path using GFP_SKIP_KASAN (which is highly likely given that
> GFP_HIGHUSER_MOVABLE has this) and also using vmalloc() will unintentionally
> also skip vmalloc unpoisoning.

If a caller wants to vmalloc() memory with GFP_HIGHUSER_MOVABLE (which seems
HIGHLY suspect to me) then surely leaving the memory poisoned is *exactly* what
they expect?

> 
> I think we are doing patch 1 because of patch 2 - so in patch 2, perhaps
> instead of calling __vmalloc_node we can call __vmalloc_node_range_noprof and
> shift this "skip vmalloc unpoisoning" functionality into vmalloc flags instead?

This is exactly how Usama was doing it in v1. I suggested we should just reuse
the existing flag since it already provides the semantic we want and is less
confusing than introducing a new flag.

I know David is keen to do a wider rework and remove/rename/change the semantics
of __GFP_SKIP_KASAN, but I'm hoping that if we just continue to use the existing
flag and its semantics for vmalloc then there is no reason why this series can't
be merged independently of that wider rework.

Thanks,
Ryan


> Perhaps this won't work for the nommu case (__vmalloc_node has two definitions),
> just a line of thought.
> 
> 
>>   	/*
>>  	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
>>
>> ---8<---
>>
>> Thanks,
>> Ryan
>>
>>
> 


