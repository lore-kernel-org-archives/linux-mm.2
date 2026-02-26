Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25378FC591F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8434A6B0088; Thu, 26 Feb 2026 05:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDA36B0089; Thu, 26 Feb 2026 05:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744DB6B008A; Thu, 26 Feb 2026 05:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 613316B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:27:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FE81160AD6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:27:18 +0000 (UTC)
X-FDA: 84486230556.01.687B5CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id E4697140002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:27:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772101636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tDNeC0J7CLO6kZT4rtD/G9QKlcwzvJg4L88we91SZFU=;
	b=WEfWuz6RXr/3byQVff6UeRgOpRyngmmauUikl/AQDOthgEf9Osp+jhqtgWNkPcl7C36y2f
	coOnlyrq8jLZqYp7wZK1w6x/P84+iSsHg00UZEkL0w0O6H/+blnamwv/jB9EkYHZ3siCF8
	PAVKFvQj3EvpNvJo8eeiEaPe5dmDo6Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772101636; a=rsa-sha256;
	cv=none;
	b=xB4koeWlIAutFPsLA8LVzI1IPd1mIcKFS4Lyrx68Sbre0XK+ncJ00lNUMbosDtGII6w0Xp
	V/wblAjz5NgxA7LzlFxqtFfoV9Ttn2sJG0UE2D4yK+Cw5HzjUryXMnIYFQih24VtrYd8Vb
	SPf1IlkqMkplwiTQMW6ujZWa8RQ5BkY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D9CC1516;
	Thu, 26 Feb 2026 02:27:08 -0800 (PST)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41CCC3F7BD;
	Thu, 26 Feb 2026 02:27:10 -0800 (PST)
Message-ID: <697fe0bf-fd5b-4ea2-b430-37e38dd30590@arm.com>
Date: Thu, 26 Feb 2026 15:57:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, harry.yoo@oracle.com, jannh@google.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable <stable@kernel.org>
References: <20260224110934.881360-1-dev.jain@arm.com>
 <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
 <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local>
 <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
 <40c4917a-cf50-43f6-8ef0-de5a2c7a638f@arm.com>
 <bc4ad689-6dd5-4637-92dd-d16ac8ddd460@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <bc4ad689-6dd5-4637-92dd-d16ac8ddd460@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aaixmr5quwoyn8xq7z96uew3zg3zej1p
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E4697140002
X-HE-Tag: 1772101635-384435
X-HE-Meta: U2FsdGVkX19TVSQWBIRgpWRcrHrAi48U0YgTlGqRW+v1cH7QbXH2soTE5U/txe4lSr38o/ky/GA4ifVGhcgXOWvwzNh7QKGQVclfpYzvD0ZjB8/qi6GVNbkldJY+uEe3Zgs6Mjkkfq4lI/4tEFYJrzbOecs92YG6MmzJrGhnLJHrtRz2Hj3aLT4Mv/9osJPiAMCnhjSOxVZo5eJQVdYkADBKoccYyFWFm9cthAuC7gdat6ez7mK1QgMiLSUFDvq7WxgvAUCSdc6govFbsXx/dllG1rXU+CnBKjKsPMC9wOgMnZQUKxQd2Zn1Y7tznEvyir1DQkIvNL7+p/angzJgk127nICfISMdxt8E4xuarxZAMzDrp3E/wR2wZS/Lml6a8fWBgtyqil6TcQIyScnLho6MayPpRMdfbzRm7FjJclpy9Yis6c6SuCyTNFC2FRXU7k5fz/UugXYicsPtYX6trI4Mp6rhSmKzGl/lKcYvayoSAvXLH3pU0bcFMC6+e/RoA4B+jnoIikgeBH5PSkUd+o6MGVqxmQBqEa1naRsMYxcNc6bMcZLhbO0HYWpKcMT+M9sKP6IDDKnefloo9U4gd5k13wUMKlVfV/SwY+EBCFUy8WkCzBPVDlk2mUpvIEdeCo/bP/VBa9FpGj5FrrJlo/Nq4HrEDnqjL2WkwNaC2cnlyFd9YE/1D+R4EodjGOuorRa0wo8eZLIIulpS5DduG7/T3gBLENrtgHwQkXhHTWx0BIhwu2a0ve8yVP5TVTJnD5uL6Y6OGGD5aonxtjikPniZRiXCDdcbSNtU6ZrsJ238hQNtgmu+72qYzueBV14MaYrSLvOsBlXMEM/cC4YXA1E6c25FJbKkaaRtvkzgj052N5d/ivJ904XWFoH33ENCqDhPW3QTAeAOw6Sw58+TM1QrmuUj5HVARuFmm10ZNMNKGdSKZLAe4zC5ceqZtu5ZDpLUADoHaA4rbwKfeOV
 tPzkE5LQ
 Mv9GfDNfKUByfandI8/Le9+jWGZUVfLSsFTI5A5N820Q1wa0zCJu8BBs9wU5YYryjCOawN9zU/JdMK7xfjzNW6vm8dWCE2l3WdHDdSnrNHT+H8MBC/p92gXzMLnXYtudLmx7cIVj9MVVuDqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/26 3:51 pm, David Hildenbrand (Arm) wrote:
> On 2/25/26 06:11, Dev Jain wrote:
>>
>>
>> On 24/02/26 9:31 pm, David Hildenbrand (Arm) wrote:
>>> On 2/24/26 12:43, Lorenzo Stoakes wrote:
>>>>
>>>> Sorry I misread the original mail rushing through this is old... so this is less
>>>> pressing than I thought (for some reason I thought it was merged last cycle...!)
>>>> but it's a good example of how stuff can go unnoticed for a while.
>>>>
>>>> In that case maybe a revert is a bit much and we just want the simplest possible
>>>> fix for backporting.
>>>
>>> Dev volunteered to un-messify some of the stuff here. In particular, to
>>> extend batching to all cases, not just some hand-selected ones.
>>>
>>> Support for file folios is on the way.
>>
>> Typo - anonymous non-lazyfree folios : )
> 
> Heh, no, not what I meant. We do have file folio support on the way (see
> the other patch set).

Ah I thought that got merged already : )

> 
>>
>>>
>>>>
>>>> But is the proposed 'just assume wrprotect' sensible? David?
>>>
>>> In general, I think so. If PTEs were writable, they certainly have
>>> PAE set. The write-fault handler can fully recover from that (as PAE is
>>> set). If it's ever a performance problem (doubt), we can revisit.
>>>
>>> I'm wondering whether we should just perform the wrprotect earlier:
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 0f00570d1b9e..19b875ee3fad 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>  
>>>                         /* Nuke the page table entry. */
>>>                         pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>>> +
>>> +                       /*
>>> +                        * Our batch might include writable and read-only
>>> +                        * PTEs. When we have to restore the mapping, just
>>> +                        * assume read-only to not accidentally upgrade
>>> +                        * write permissions for PTEs that must not be
>>> +                        * writable.
>>> +                        */
>>> +                       pteval = pte_wrprotect(pteval);
>>> +
>>>                         /*
>>>                          * We clear the PTE but do not flush so potentially
>>>                          * a remote CPU could still be writing to the folio
>>>
>>>
>>> Given that nobody asks for writability (pte_write()) later.
>>>
>>> Or does someone care?
>>>
>>> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
>>> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
>>> architecture (write-only)? I don't think so.
>>>
>>>
>>> We have the following options:
>>>
>>> 1) pte_wrprotect(): fake that all was read-only.
>>>
>>> Either we do it like Dev suggests, or we do it as above early.
>>>
>>> The downside is that any code that might later want to know "was
>>> this possibly writable" would get that information. Well, it wouldn't
>>> get that information reliably *today* already (and that sounds a bit shaky).
>>
>> I would vote for this, since if we were to follow the current patch,
>> the extension to anon folios will make it worse (pte_wrprotect at 5 places
>> - the 3 additional places being in the if conditions consisting of
>> folio_dup_swap, arch_unmap_one, folio_try_share_anon_rmap_pte)
>> The downside being that if we fail in this rmap path, the ptes are all
>> write-protected. But then the page is already there - the fault is going
>> to be processed fast.
> 
> Right, we should only have a single "revert pte", and not have to redo
> that from multiple locations.
> 
>>
>>>
>>> 2) Tell batching logic to honor pte_write()
>>>
>>> Sounds suboptimal for some cases that really don't care in the future.
> 
> As per discussion with Barry, we might just want to do that now as an
> easy and obviously correct fix.
> 
> It's a shame we stop being able to use folio_pte_batch() and have to
> create an inlined version.
> 
>>>
>>> 3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRITE
>>>
>>> ... then we know for sure whether any PTE was writable and we could
>>
>> Well, we don't need this? The problem here is that we are making a decision
>> on the basis of the writability of the *first* pte of the batch - so if
>> the first pte is writable, only then we have the problem we have been
>> talking about.
> 
> That's what I was referring above as "being shaky".
> 
> Some code has to be taught that "there is something writable here, so
> assume it was accessible in a certain way", other code has to be taught
> that "there is something read-only here, so make sure you don't
> accidentally make something writable".
> 
> One way to handle it is to say that "the resulting pte is writable, so
> assume it was accessible", to then say "but just assume it is read-only
> as we are not sure whether everything is writable".
> 
>>
>> We could have had a FPB_MERGE_WRPROTECT (which I know, is totally
>> incompatible with FPB_MERGE_WRITE) - that would tell whether at least one
>> pte in the patch was non-writable, in which case we will be able to avoid
>> the restoration of the entire batch to writeprotected if all the ptes
>> were writable (which I am assuming is the common case). But of course this
>> is not possible to do with the current shape of folio_pte_batch_flags. We
>> will have to revert the FPB_MERGE_* stuff to just collect the "at least one
>> is writable, at least one is dirty, at least one is young, at least one is
>> non-writable" etc information from the function and let the caller handle
>> it. That will kill all the work you did in simplifying that function :)
> Yeah, let's not go down that path. :)
> 
> To fix what we currently have in the tree, probably we should really
> just set FPB_RESPECT_WRITE|FPB_RESPECT_SOFT_DIRTY, saying that this is
> "obviously correct", and revisit it once we expect more cases where
> batching over these PTEs would provide more value.

Yup makes sense, I'll do this.

> 
> For lazyfree, likely it doesn't make a difference.
> 


