Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AD3C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C3F6B08BE; Mon, 17 Aug 2026 22:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED546B08C1; Mon, 17 Aug 2026 22:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC266B08C3; Mon, 17 Aug 2026 22:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC76A6B08BE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:56:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38ADA1A0A88
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:56:43 +0000 (UTC)
X-FDA: 85112877486.19.F706F64
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf25.hostedemail.com (Postfix) with ESMTP id A770EA0003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:56:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=G6t8z4aO;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787021801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mmzy2KRppiE9A8Y8ELPAoQZxfCoaZ+1Mf41Owvy1ldo=;
	b=5pWGvoD6WJ5H8OhFgPwi1JgdwHpmncnlWb3sjfIr0DXpOpnR0DXrnPu5k0N9IiWo3bMaRi
	UftjkQFi7XZx8yeie7x08ZF946E6W6J9/pOFCq/Upqk2umtZAA8voAv5iVxev8XrvzEwxP
	vdJdrdVGQAIHprxVKXbYxqNCCUJDU3U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787021801;
	b=lOg4UY3BPL8D3Bg35XUXFx4VaABT8jO4whx+iUqr03YHMhw1YyGaulhP5cerV4izX0cL+m
	xbOn3qnNCREFw9RcRQP3cdIgJbCZhGclPyFKrU4fuI6tkmGtxe5qf/F2sVUDDegHITavAP
	+YLwG6qwJc4k9dRoDRwmAZw3DgMhouA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=G6t8z4aO;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1787021794; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Mmzy2KRppiE9A8Y8ELPAoQZxfCoaZ+1Mf41Owvy1ldo=;
 b=G6t8z4aOiaCzjzAN2kz662NjpkK/owVRzHLTQhAZXx54Yi1Sg/N02PJ+48Rg9zDruutufI
 J6WcnvsV5ly2B+1/Eii501RlXt3ImOEXcUw/PbsT15f4+6F6nZ8nRCh5pmKC/k8iM5ITkh
 71rQw74bCPphV3R6fxGOk7j5foh8qUZ4sTI3T7V/uJHDYYHro0ZbQ1jqifb8RCd7CtqM9L
 FzoKg1JMMqvpE0LF7hn3zorSAdJWVP3aCiD4yFjMtXqedwFgrSRlrT8pxlDqqf1T17rKgk
 PryGbnxPFVBVe8kAL0nRUk7lkKQICKoKzBbFUp1YojXUmxBYxDDjyx+Sbvyv5w==
Subject: Re: [PATCH v10 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
To: "Mike Rapoport" <rppt@kernel.org>
References: <20260810122057.30447-1-lizhe.67@bytedance.com> <20260810122057.30447-3-lizhe.67@bytedance.com> <178688187038.2799959.7900723270155108493.b4-review@b4> <050c317f-111e-4293-aee5-ac8e154ebc7e@bytedance.com> <aoLtbbv5euE4H1xO@kernel.org>
Content-Transfer-Encoding: 7bit
In-Reply-To: <aoLtbbv5euE4H1xO@kernel.org>
X-Lms-Return-Path: <lba+26a83c9e0+875291+kvack.org+lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Tue, 18 Aug 2026 10:56:10 +0800
Message-Id: <6a066922-4528-4c4d-9bb5-bbdb2b6cd56f@bytedance.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: wx86nu6fdkc95pxjfzh81r87gojwd6qk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A770EA0003
X-HE-Tag: 1787021800-494870
X-HE-Meta: U2FsdGVkX18fiXmgULwUPTX5FFEvA1XnU+RvZ1Y9Is8BRUEOo/1rWHdJSKz7IZbaMtrpEnekQIa3p2Jvzf+1+8eyl7thLwUvJfou4dB6NwGtOE8dPhlTDn2ajxrvsaI5QM/oViyDiXNqv/0yQ9tWllYZ1nu+AyLxFigbBtDenskPWPqHt8+Wy8ndUfmS1ZxfSZ+9xbky/J1O1JRxi/hHP19f6Sx09qfYKR3nIWnP+ZJdP7HjNzXu5oSR1giBpPhwTx46fXKuUgd7rTxfgLfJsOXUpPWhQIFSm6eDjcETe6JJLuVTzNe81tMptHeafNyhFh4LpAVnIyQQkdFJrIZCVwo9YfD6bfDi11C4Rg7cxfKPTEFTqRuMhbbKywuDzfxo0yO3HJzWmNhAP1urhafzoJBnKpBByjBHRw8J/VrSMh5KNQdACd1p0A4w/HnkuMWYxSFFOwPi5Zb2hEJxsH8ie/1IUjbxdexN9qcBzwMEk15oabJNF7/pyxfvto2AQba5Lpq57lSuTZx7d2xuQjJJxozCqS6aZd7UpjmkSm8Dl1ji+2bE3I67jn1S5ln6D33ptDZDEwsltZWZfKzJ/sbifod+D2osx26JMbiFcEieTX5hj0W6pdwxVjAIbAlwb6peAIq9JBIF+Hvr2ctl3OEfbw/Id3HuZY7VnrAOtNdznH93jmW6HrjNvDsUOQiTQa2CZHhqiIDBwf9GMYsOWmt7tVf1muQr/Rcy6u9dGvcUSMIY/rEjfrpswLwUA4XdZDEnnYR+Ox+fJy3F8k0AlgsZ0KokGYy0Ttj2x5YtquuX5+9sRX7zgnbCDYysZowtRYk+sMFGkCToCu8uKxZ+R/iQbZfZZOf228IF3UwDx78y9fcOpmDHi4ooCdWe1hav28WN8UrHT9ckOVZ0vKQ7JDD/ZySXxW08WQxyLIvsuiMgLNyQX5bsvs2oiqscyDW9M7rodPXJDh/QWhvzePCqqFN
 /s72UcvD
 gt1R9N8/2RG7MxbBXzKss5wmvPmX4AH+DT2mPWMFI42FPRLmUT9TMdk8QgtupiWHh73CxLnJZn5ByqNx9kdpukaDIQaAR5hgbbREpQZlcd6i92dUs6wuo6cTPIoliC7WDsmBl/c+XFTudavLEhS3UmfSp61KXnJOvCTI9YihQthscDQ0ZC0SrnZcmxMJxf3l7hXBvDU5QgwTRLHPrbGQv2e7dSUWkjr2uoATB5qvCebwjexQlhdPE0hU6o+2azvJzlJTHLEGkv8mXBAi2KXLUzsyaWDu1xx9comyexThi9AHvZMRelm9pBT0CCri1DogzLkmwPYuBA3BV1oumgD9q98j7qculwvAzXgRVj03dTTWpH/wV7nFUKAM+lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 7:15 PM, Mike Rapoport wrote:
> On Mon, Aug 17, 2026 at 03:11:56PM +0800, Li Zhe wrote:
>> On 8/16/26 8:04 PM, Mike Rapoport wrote:
>>> Hi,
>>>
>>>> memmap_init_zone_device() currently mixes refcount policy and core
>>>> ZONE_DEVICE page setup in a single helper.
>>>>
>>>> Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
>>>> move the common page initialization into __zone_device_page_init(), and
>>>> wrap the existing slow path in zone_device_page_init_slow().
>>>>
>>>> This keeps the slow-path behaviour unchanged and gives later patches
>>>> reusable helper boundaries.
>>>>
>>>> No functional change intended.
>>>>
>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>
>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>> index 95808ab5cfdb..a70acb7431a6 100644
>>>> --- a/mm/mm_init.c
>>>> +++ b/mm/mm_init.c
>>>> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
>>>>    }
>>>>    
>>>>    #ifdef CONFIG_ZONE_DEVICE
>>>> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>>> +/*
>>>> + * Return true when memmap_init_zone_device() must initialize the page
>>>> + * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
>>>> + * the free path, while the remaining ZONE_DEVICE types start from 0 here
>>>> + * and raise the count again when the allocator or driver hands the page
>>>> + * out.
>>>> + */
>>>> +static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
>>>> +{
>>>> +	/*
>>>> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
>>>> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
>>>> +	 * the count again when the allocator or driver hands the page out.
>>>> +	 */
>>>> +	switch (pgmap->type) {
>>>> +	case MEMORY_DEVICE_FS_DAX:
>>>> +	case MEMORY_DEVICE_PRIVATE:
>>>> +	case MEMORY_DEVICE_COHERENT:
>>>> +	case MEMORY_DEVICE_PCI_P2PDMA:
>>>> +		return true;
>>>> +	case MEMORY_DEVICE_GENERIC:
>>>> +		return false;
>>>> +	}
>>>> +
>>>> +	return false;
>>>> +}
>>>> +
>>>> +static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
>>>>    					  unsigned long zone_idx, int nid,
>>>>    					  struct dev_pagemap *pgmap)
>>>>    {
>>>> -
>>>>    	__init_single_page(page, pfn, zone_idx, nid);
>>>>    
>>>>    	/*
>>>> @@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>>>    	 */
>>>>    	page_folio(page)->pgmap = pgmap;
>>>>    	page->zone_device_data = NULL;
>>>> +}
>>>>    
>>>> -	/*
>>>> -	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
>>>> -	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
>>>> -	 * the count again when the allocator or driver hands the page out.
>>>> -	 */
>>>> -	switch (pgmap->type) {
>>>> -	case MEMORY_DEVICE_FS_DAX:
>>>> -	case MEMORY_DEVICE_PRIVATE:
>>>> -	case MEMORY_DEVICE_COHERENT:
>>>> -	case MEMORY_DEVICE_PCI_P2PDMA:
>>>> +static void __ref zone_device_page_init_slow(struct page *page,
>>>> +		unsigned long pfn, unsigned long zone_idx, int nid,
>>>> +		struct dev_pagemap *pgmap)
>>>> +{
>>>> +	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
>>>> +	if (pagemap_requires_refcount_reset(pgmap))
>>>>    		set_page_count(page, 0);
>>>> -		break;
>>>> -
>>>> -	case MEMORY_DEVICE_GENERIC:
>>>> -		break;
>>>> -	}
>>>>    }
>>>>    
>>>>    /*
>>>> @@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
>>>>    	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>>>>    		struct page *page = pfn_to_page(pfn);
>>>>    
>>>> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>>>> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>>>>    		prep_compound_tail(page, head, order);
>>>>    		set_page_count(page, 0);
>>>>    	}
>>>> @@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>>>    	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>>>>    		struct page *page = pfn_to_page(pfn);
>>>>    
>>>> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>>>> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>>> It looks like all callers of __init_zone_device_page() are now calling
>>> zone_device_page_init_slow() that with series evolution became a thin
>>> wrapper for __zone_device_page_init().
>>>
>>> Maybe we can just rename __init_zone_device_page() to
>>> __zone_device_page_init() and replace the open coded setting of the page
>>> count with the call to pagemap_requires_refcount_reset() an be done
>>> here?
>>
>> Yes, that would make patch 2 simpler.
>>
>> The reason I kept the refcount policy outside __zone_device_page_init()
>> is the compound-tail initialization added later in patch 5. Tail pages
>> still need the same basic ZONE_DEVICE struct page initialization as head
>> pages, including __init_single_page(), PageReserved, pgmap and
>> zone_device_data setup. After that, the tail-page path calls
>> prep_compound_tail() and sets the tail refcount to 0 unconditionally.
>>
>> Folding pagemap_requires_refcount_reset() into __zone_device_page_init()
>> would make that helper include the head-page refcount policy even for
>> callers that will immediately apply the tail-page refcount rule
>> afterwards.
> But you still call zone_device_page_init_slow() from
> zone_device_tail_page_init() so it's anyway there.


Thanks for pointing this out. I was mistaken about the current split.

>
> I'd suggest combining this and the next patch into one, keeping
> __init_zone_device_page() name without renaming it at all and open-coding
> the initialization of the first head and the first tail page to properly
> set refcount and call other prep methods.
>
> I'd also pull the initialization of the first page in both cases out of the
> loop and make the loop only use the _template version.


Thanks for the suggestion. This is indeed clearer. I will fix this in v11.

Thanks,
Zhe

>   
>> That preserves the final state, but I was trying to keep the common
>> ZONE_DEVICE page setup separate from the head-page refcount policy for
>> this reason.
>>
>> Would you still prefer the simpler renamed helper here, or should I keep
>> the common ZONE_DEVICE page setup separate from the refcount policy and
>> make the naming clearer in v11?
>>
>> Thanks,
>> Zhe
>>

