Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97108CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 07:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5726B00B6; Fri, 15 May 2026 03:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066AA6B00B8; Fri, 15 May 2026 03:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6276B00B9; Fri, 15 May 2026 03:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF2FB6B00B6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:04:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7A68160F0B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:04:31 +0000 (UTC)
X-FDA: 84768765942.27.587188B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2603840009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:04:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eN3JnKs3;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778828669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxD6VrfWhomMPZzRUSB6W2zCt1+HCfr1uw9zey/t9No=;
	b=ZXpDRvkQ1KDCOlZnTH6TlKY53PGOWL5KaRJQyeOyODjh5oxt45NRzHQ9X+Z8/x78M2WlBA
	YjVydnrZiVCoEfRTaAb/pnpNXB/0Vg0YlzswCsAj8pGtTlZNm6WX0V7MWLdmvX7jfEsu5y
	5USJPoq0UNH1/GB/OGI5lZDZ+y3BI+w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eN3JnKs3;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778828669; a=rsa-sha256;
	cv=none;
	b=jKSvlzY4jAR4L9nBBkQ/5OwKsqtvfKqSNTvszArjYSO25adnruEceqQt8g/hKdZJgyVeQf
	U1EgYUeQEbrbCIp0mVtF4Va+IpVqsxvkvxi25oD4bKL01ZjZPB3leIvlGdX+97ncNdpJpo
	XFXaU23k292OpibC8e3dCvhq0RNwXl8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F0EB26A4;
	Fri, 15 May 2026 00:04:22 -0700 (PDT)
Received: from [10.164.19.30] (unknown [10.164.19.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 005203F85F;
	Fri, 15 May 2026 00:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778828667; bh=Teq4aEV47b5xc1xDbc9sNZiP3VZUXGcetKGt0Nj8jj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eN3JnKs3EzS0t8ox0F9OPSRe2IdraPZxQZz4lC5+FzUfJpVjaxcEi6Otz6sc0BiAv
	 tiKjVgEAXkLleHeGlaRilLr8esdBsvELnrUCFeqTNFz4370OKxKOz040DwWBIBbXzN
	 eMt/BlMsKJF7KgZkYOrnCXqjIpNQDJgGX+pOG0FM=
Message-ID: <ec920fff-58cc-4773-b8ea-e4239c765b9c@arm.com>
Date: Fri, 15 May 2026 12:34:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/slub: hw_tags: skip page-allocator unpoisoning on
 slab allocation
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, harry@kernel.org, ryabinin.a.a@gmail.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <20260513105734.3380544-2-dev.jain@arm.com>
 <83aca9c5-6bd0-438e-b571-c4d0335c9901@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <83aca9c5-6bd0-438e-b571-c4d0335c9901@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2603840009
X-Rspamd-Server: rspam06
X-Stat-Signature: bk4rsdgwpp86mewoxinrjrcdqfxgoike
X-HE-Tag: 1778828668-314955
X-HE-Meta: U2FsdGVkX1/3nduZ2XKRqW9ImT8UuiOBbxBW7i0qAIaodegkOghUnlk4OwXsaMug0OMjOX2svEt3szBagimv2ouBZE14BBPy09HR30OHHTBnrOvi59odHuWAtlX/XE0lp8FJGU2EDju6pDlMFcshiare52oZL92iogQCwEt6M8o5Sufr11gOKuElPSfqhDhPszTFoM6mAcqJCGHA3PdGd3UD8pLDoEf5QXS+2PD+inO/Og2jPEGKmXdG1r7ZHMiqpCdmqzuA0HVRGXIsHOAi8iad6O88YuIw2WiC8FvhMgXCtDc4XyQzkGbCGPFpdI7YYXX42z92eDZVBgRO5/SaDJwQHtx0v63DcCdRIMw9iCWRFNY3mjIcD9PzmMafBSd3uE0t7XBHMiOw22ofZa87oLKO1WoyctlD5UbOOww5ribsdPO5ia5G0yJNRiYolLoG2hj82gHG8oywUM7nY40D2lNvqEiNIZaqeA+SLiRe0rwt5GLC0DDqV1QJVrQpjZ1jL3UKoZAoWQS++wrBbpqtE7kLoeJGg61LxwaM9A9PeVYaApfzJOW036jnIGqdtwWK32lC+jRLPD6cUDlonNRgKfTzL1++yMm7MAAR4c+msF9MeW6einch6XbAr7R2YXotGIKDeIGfd9N45ERs9OTyNAacI14kwxp08y1yYRklQ+I2L9xoMWzaBBvkLE6m1ra7ASNaSjVIIOIvx+mNgCEcRAjxHGbddE5dCo7PTcFAsiFBxqU1l+QSanoBtRFViUtIW1TWJ9dhCL+12ayerb4rFxIYBP65ZCRY7Jn65g97TR9CcchRaE8wRefXzMnyEkES41BQ9R1AUIhijtoQ2xR4y1/SnEZckbN6sy923uAWTIwXAiNMt6ZoWwsKAsxW4TOHnmoweq7Mp03/MH2wTphnbM1VW/pr4Odd+OY/F0mT6/a44DoItgDosyvWo2kMeT5MKZkq/mKBWlawjT0DQeM
 O08YguID
 797n5MGIoT517cNFrs9Sn+kKU5a4M1Rd2jGC7HaA7aJhC4VQ8nJJ4Ssz2Sd16Zoma9SnkEoqLKOmQPFi0f0MV2j8Rk473io2yqq/+B2+LRyMv7xkXJb35dLkiG+d9wRl4/cwRZSW3g6nxvw1hRaqPysJpbvnh7itTBFDXWgHQxpQmPOB7dgZbIKhR2e1LbD9itZXOZtJw6aw55nx4P7ZWVeI09Z7ql3hgVSz6XBqj0LgFAlQHfh58db5LFK0Wm1J0R6nooQ1vCbgGNdqQwK72dy/puhmEdhYiNOfeHAjrS0Sm4RjfAVeJBwCWYqsnxZgu4QQ1se85ZOtLAg3mwEHkDpbMCFfMsxk1rLcUtlFvKzqRW8xT5c6Zl/ilPzolBXkGOUdMe5v9+LcKnFfwdGcW/1PdlCgfDAFSbvYn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/05/26 5:41 pm, Ryan Roberts wrote:
> On 13/05/2026 11:57, Dev Jain wrote:
>> When a new slab page is allocated, the buddy will unpoison the page.
>> Then slab immediately poisons the page via kasan_poison_slab(). This
>> is wasted work.
>>
>> Similar to what is done in vmalloc currently, use GFP_SKIP_KASAN
>> (hw tags flag only) to skip unpoisoning of the slab page.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/page_alloc.c |  2 +-
>>  mm/slub.c       | 11 +++++++++--
>>  2 files changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 227d58dc3de6..c3a69913aaa9 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7723,7 +7723,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>>  	struct alloc_context ac = { };
>>  	struct page *page;
>>  
>> -	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
>> +	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_SKIP_KASAN));
>>  	/*
>>  	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>>  	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 0baa906f39ab..da3520769d1f 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3269,9 +3269,16 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
>>  	struct slab *slab;
>>  	unsigned int order = oo_order(oo);
>>  
>> +	/*
>> +	 * New slab pages are immediately poisoned by kasan_poison_slab()
>> +	 * before any object is handed out, so page allocator unpoisoning
>> +	 * is wasted work for HW_TAGS KASAN.
>> +	 */
>> +	flags |= __GFP_SKIP_KASAN;
> 
> You will also want to elide kasan_poison_slab() right? In which case, it might
> be better to handle __GFP_SKIP_KASAN in allocate_slab() (which calls
> alloc_slab_page()), because that's the place where kasan_poison_slab() currently
> is and it's probably better to keep the logic together.

Okay.

> 
> Note that there is a wrinkle though; logically, there are different types of
> memory poison; KASAN_PAGE_FREE, KASAN_PAGE_REDZONE, KASAN_SLAB_REDZONE, etc.
> Memory returned by the page allocator with __GFP_SKIP_KASAN set, will have
> KASAN_PAGE_FREE poison (I think). But kasan_poison_slab() sets
> KASAN_SLAB_REDZONE poison.
> 
> However, this is only distinguished in practice for KASAN_GENERIC. For
> KASAN_SW_TAGS and KASAN_HW_TAGS these distinct logical types all map to the same
> KASAN_TAG_INVALID tag. So this optimization can only be safely applied to
> KASAN_SW_TAGS and KASAN_HW_TAGS.

GFP_SKIP_KASAN is only for HW_TAGS.

I will mention the KASAN_SLAB_REDZONE = KASAN_PAGE_FREE for hw tags in
the description.
> 
> It would be nice if this could be abstracted away somehow...
> 
>> +
>>  	if (unlikely(!allow_spin))
>> -		page = alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
> 
> nit: you may want to keep this comment around?

Yes I will keep this.

> 
>> -								  node, order);
>> +		page = alloc_frozen_pages_nolock(__GFP_SKIP_KASAN,
>> +						 node, order);
>>  	else if (node == NUMA_NO_NODE)
>>  		page = alloc_frozen_pages(flags, order);
>>  	else
> 


