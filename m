Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31392CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5A76B00B6; Fri, 26 Jun 2026 07:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60B06B00BB; Fri, 26 Jun 2026 07:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02296B00BF; Fri, 26 Jun 2026 07:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91C306B00B6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:31:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08CCD8DC75
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:31:58 +0000 (UTC)
X-FDA: 84921849516.23.7694D57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38A38100003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:31:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DASHT9KJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782473516;
	b=U76v+iZ+tsZoJv0AQAj0Jtw1nyJKgBm9A5Uc8bYosT5XRbLkjmF14y72tiRp4V80CzbA3C
	0il8Y6vNDcOQkf3k7is2KiSAq9bmZ7r6iiOUpGGTnRKnMqx3+zDZVMhBVR2iuX9HdcuBl3
	Odi+DEUzQkD9T760Oac7duHa8sAQvkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782473516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXNMlFvQpQEhVOSE6W4KHuY5nfj10CNnD+tcN4AITD8=;
	b=CNf4LDSztAoqJD1tBgXMMW5KY1uW7iWvcuqbJ9xy5foq57JYyohHzNcLs8Hc39oC123dEK
	VKhX/wQcJ2rq86OewsiwWFYt4dluZG+FxttymWLiIxdeejXM8Y0HYPiH6NsNoQtTKukmTD
	PxRVOw2gQorSGezUHtPPyMtFtIvXMoM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DASHT9KJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A2D560098;
	Fri, 26 Jun 2026 11:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F3E1F000E9;
	Fri, 26 Jun 2026 11:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782473515;
	bh=yXNMlFvQpQEhVOSE6W4KHuY5nfj10CNnD+tcN4AITD8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DASHT9KJdoV1oSrMo9dfIFwRJcr9M/y2wVWgR0pPxmHuHPaEV4U0YMehk9EzZXjZj
	 ID5wUMJmxBxYC/f0YA4s0hTzql53FvCWOf5Z7K8DMb6mikXt7bEpHr2mn0ICKb7gQN
	 zbsy+oAtwZd23G/IDzWxcBznyngSU2cx/Ff0Jw9m8BrNabEP6W57YoOV2ICKj5VZn0
	 JTQyE0Nuo5XGFJk/zDDA/99o5XfPoPm2cEcKgYm2xaz8i1BRZcYtTH6Ypepx5/OlJP
	 F1bQCC6H+6DyvHXOcEQVW26rXuBOZzAMsd0i7QAMWo7JS/a2+bltrp68yQ9jCgbHSN
	 I48MO+HIe9X+g==
Message-ID: <f9290e0c-0841-4b02-baf7-8f03c4cf800e@kernel.org>
Date: Fri, 26 Jun 2026 13:31:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD
 handling
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org> <aj5XVwsQ4rOLTzr5@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aj5XVwsQ4rOLTzr5@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38A38100003
X-Stat-Signature: w8jst1omyz1ia484zy35zqifmuhfdfc8
X-HE-Tag: 1782473516-766590
X-HE-Meta: U2FsdGVkX18lt21KOiWsaCIfsvXl76upUSY1ekprReK3mAdiagaxFT1rBaIpOUlEdSUSjoljr/57PbM/rYIoKbajItCV3u6FPtptLKwHiHwXM0XnyWTPT6SUCju3oFfB27m7gTU7rJ2G/t5bjU+fIVk25GyB0ysglWnh2UKkEeOk8V2HFw5GB3xNl/eamtuuY+gHuFXjOHsJZWrcnkt2357VTk6Xvtv8BtCmYv3wHYPFQwANcYdSqbLQVfjxAZXEeEQDN4OzQj6hvwaOozArEPiWqyrH2uby64w1O+Ght+x00DXkkry6/X7/UcvtAAncs9yGVnRAiviS65WSTQ2ayst2nuMhKJGLQ2BjYXeNWqb/d/jEJhRY5YYMje1+RjFUyqMxJOK6Z3qLqCngSu+M/XyIaMRr0ZNY0haHrtDRk9KPdYCqayz0IaoO4YhPb7Gt0UkpWNAhGg1auMvPzXOM4k79F9gChMDaokhDHnu2wnvqwoAQ7fe0JAjOZnL/cJXfHc91Y0USrJjUsYwGhDuV0w6ylpF/xkktjz2RbfXJQrOWda0R26/Lc+swTo70WNFn2EGEIURnqGlUVaIl3gTW0U77PaQRSJ5V1YznVry+BvW1yE+bGmCa6wihD0cmrw4VHs1cYb8Qj0NvdhUTHGefMKbPJslAY+ZocQzVutUUJvZMHUByfecIfGAeaciG+1p2b1gA6uYFJkbuImJFSERD2FZdZkxUh2xSFxEU/Nlpwup4vmC8jTFckQ3/2iv3jJ24Kd5rJFM1fVfg+FZulaTkyjt/o8meba4hSG9l22gUWC3E4fB4gjpM4gxx4KGqlKhTTlZDTBY3GX4DzaU4nxT/HHCH32CJ5SQXaC6VxRWiHJ+blnOX2aDbFJvcIGIzTEAyI8H4ogpA1Orw8fZrjZ7cpZycPFWJiaaes+QA8OOJTiimh5YslzrTTpTNIz2hoFoL3ctDZVWo+OBwSzIXUZd
 heTwDbmm
 fo3br5gJWo/xEAu54wiTp7w6gJMROKXu0fOqNRLEkoR5USFAhPPGKDSHsyDarvIq3dvrnqWMDSwptKBLVpS+zjcUfKgE1R2duNjRfYPayT2Rv9ylCCHBVr1VbiSBE/Jv2MLRpocvkBUfDNNqqMGDgIRxhM0ZKOVXXCAd74C43cW9g3D2DmHpEwuLc2dxz9Z23T5Ip7/GvEL8AEa7m0TZITB2gIl809fO7NvkE7c9Ds0L/wNbjyzZOT+d/Yt3tuDpAkAU5WVjHvTBGGZlbQeTK8Galbsc1CKkRY4jXjqdEfEsfvnUcWggAlOu3ZiwaTRyN6bUNm7NoEhyLUR+nTGqr4NFHY5bAZfB97PlWM0aRpKS2HMM5zSP6S3YzBHUziyNdArvLcBiITEdfer4eMm8UBj5oDIFWvMoKjKIsD4wioDhehsEt8MWBzxI3FrN5JmI0UY9jnfX6LNz36K8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 12:42, Lorenzo Stoakes wrote:
> On Fri, Jun 26, 2026 at 12:07:56PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/24/26 08:53, Wei Yang wrote:
>>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>>> device-private entries") introduced the concept of device-private
>>> PMD entries, but did not correctly update the rmap walk code to
>>> account for them.
>>>
>>> As a result, when page_vma_mapped_walk() encounters device-private
>>> PMD entries, it takes no action other than to acquire the PMD lock
>>> and exit.
>>>
>>> However this is highly problematic for two reasons - firstly,
>>> device private entries possess a PFN so check_pmd() needs to be
>>> called to ensure an overlapping PFN range.
>>>
>>> Secondly, and more importantly, if PVMW_MIGRATION is set the
>>> caller assumes the returned entry is a migration entry, resulting
>>> in memory corruption when the caller tries to interpret the device
>>> private entry as such.
>>>
>>> In addition, commit 146287290023 ("mm/huge_memory: implement
>>> device-private THP splitting") allowed device private PMDs to be
>>> split like THP mappings, but again did not update this code path.
>>>
>>> As a result, we might race a PMD split prior to acquiring the PMD
>>> lock.
>>>
>>> This patch addresses all of these issues by invoking check_pmd(),
>>> ensuring PMVW_MIGRATION is not set and checks whether a split raced
>>> us we do for PMD THP and migration entries.
>>>
>>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>> Cc: SeongJae Park <sj@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>
>>> ---
>>> v4:
>>>   * refine subject and commit log based on Lorenzo's suggestion
>>>   * put pmd device-private entry handling in its own if branch,
>>>     suggested by Lorenzo
>>>
>>> v3:
>>>   * remove cleanup part, only fix the issue for device-private entry
>>>   * refine user effect description based on Lorenzo's suggestion
>>>
>>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>>   * specify the possible error case of current code and user visible effect
>>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>>>
>>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>>> ---
>>>  mm/page_vma_mapped.c | 20 +++++++++++++++-----
>>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index 2ccbabfb2cc1..17dff8aab9f9 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>  			/* THP pmd was split under us: handle on pte level */
>>>  			spin_unlock(pvmw->ptl);
>>>  			pvmw->ptl = NULL;
>>> -		} else if (!pmd_present(pmde)) {
>>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>>> +		} else if (pmd_is_device_private_entry(pmde)) {
>>> +			softleaf_t entry;
>>> +
>>> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> +			pmde = *pvmw->pmd;
>>> +			entry = softleaf_from_pmd(pmde);
>>>
>>> -			if (softleaf_is_device_private(entry)) {
>>> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> +			if (likely(softleaf_is_device_private(entry))) {
>>> +				if (pvmw->flags & PVMW_MIGRATION)
>>> +					return not_found(pvmw);
>>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>> +					return not_found(pvmw);
>>>  				return true;
>>>  			}
>>> -
>>> +			/* device-private pmd was split under us: handle on pte level */
>>> +			spin_unlock(pvmw->ptl);
>>> +			pvmw->ptl = NULL;
>>> +		} else if (!pmd_present(pmde)) {
>>>  			if ((pvmw->flags & PVMW_SYNC) &&
>>>  			    thp_vma_suitable_order(vma, pvmw->address,
>>>  						   PMD_ORDER) &&
>>
>> This is extremely hard to review given the existing crap handling here. I'm
>> really sorry, but it makes my head hurt (I'm not kidding :) ).
>>
>> It's completely unclear why we only have to check for a subset of the cases
>> after taking the lock.
>>
>> Could we simply extend the existing migration pmd handling and leave the
>> !pmd_present() case for pmd_none()?
>>
>> That leaves no question to "which transitions are actually allowed", including
>> "could we accidentally assume something is a page table when really it isn't".
>>
>>
>> So what about something like the following?
>>
>> The "thp_migration_supported()" is not required when checking for
>> pmd_is_migration_entry(), as that defaults to "false" when not compiled in.
>>
>> Untested:
>>
>>
>> From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Fri, 26 Jun 2026 12:03:40 +0200
>> Subject: [PATCH] tmp
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/page_vma_mapped.c | 29 +++++++++++++++++------------
>>  1 file changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  		 */
>>  		pmde = pmdp_get_lockless(pvmw->pmd);
>>
>> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>> +		    pmd_is_device_private_entry(pmde)) {
>>  			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>  			pmde = *pvmw->pmd;
>> -			if (!pmd_present(pmde)) {
>> +			if (pmd_is_migration_entry(pmde)) {
>>  				softleaf_t entry;
>>
>> -				if (!thp_migration_supported() ||
> 
> Do we care about this? Or is !tmp_migration_supported() -> implies you
> wouldn't see a migration entry here anyway?

Yeah, I noted above

"The "thp_migration_supported()" is not required when checking for
pmd_is_migration_entry(), as that defaults to "false" when not compiled in."

Given that

tmp_migration_supported() -> IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);$

And

pmd_is_migration_entry() -> softleaf_is_migration(softleaf_from_pmd(pmd));

whereby softleaf_from_pmd() only returns something non-none for
CONFIG_ARCH_ENABLE_THP_MIGRATION.

> 
> Maybe worth a VM_WARN_ON_ONCE()?

I think it was primarily a a hack to slightly optimize code generated for
!CONFIG_ARCH_ENABLE_THP_MIGRATION, not really something for correctness as it seems.

So I think we can safely drop it. :)

-- 
Cheers,

David

