Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F84C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DA46B0258; Tue, 18 Aug 2026 05:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105EC6B045E; Tue, 18 Aug 2026 05:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A976B0520; Tue, 18 Aug 2026 05:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D31D46B0258
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:50:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69DED1606E5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:50:18 +0000 (UTC)
X-FDA: 85113919716.19.65C78B0
Received: from mta1.migadu.com (out-97.mta1.migadu.com [95.215.58.97])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4BD9E40008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:50:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vrDI1CzN;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787046616;
	b=BfZP8lUyvs13/lUk39XeEVBNffXB05RCLrWub1wZPGHzoGGauiDE5cHLQzshq9c72s2NMD
	e5AgQfxa3tQlkWh/cY0JC3vGsrNupimbDzc+ZPNE6W2ncxhA1i9DbDIkSp+4P4dvjkEx+3
	WiJ4SyJ0Of3AY9HhQkMrs3rLYTTC1cs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vrDI1CzN;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787046616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJOC/13go4ZKldSu3HLK/269fGqVbPJfYdeJU4yFZ4A=;
	b=eYA6+V/vdv9ZU3hamM+DRckKnhkCRQ5YF5kAoF4Q3o20Ry3fEpPnMwW09LqogmnfM3uRjM
	k5S3/+idE94lFeFhtY/ozOHifxcCK4It9FAkGkrVjtU8xChpH3NNq0BKakiVADVz/NjYh3
	iNn6WMg+JdU4rjMJ87CAY+NHfmoQviM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UlfNwq9i0Izd95buPQLfyQ20iUq29NLoc+MekKaF5hA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787046613; v=1; x=1787651413;
 b=vrDI1CzNWx0GrsXYkU9bKe6X2e99WlhCiMqZz3zU0uBRB1dDYZO1sBvbfBBIJBx8z+vIATAT
 w8WFNfCF7GkNWfSl2xBcZxFo0HszQNd+hY1oCH4HZu55iSMb/Ok/g0brdJIvkJABlXvXJFtiR0K
 nChGx7KCcVtStSg/TMCVhCIA=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.109.123] (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 155241efdf8f6d39;
	Tue, 18 Aug 2026 09:50:10 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <73cbb2f3-98ad-498d-8f33-ff7e39fe6ac0@linux.dev>
Date: Tue, 18 Aug 2026 17:50:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, akpm@linux-foundation.org, liam@infradead.org,
 lihongfu@kylinos.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
References: <d0d781bf-43fd-4a59-ae0f-960c1e942f19@kernel.org>
 <20260818021326.5910-1-hongfu.li@linux.dev>
 <f27cc496-d9c8-4642-9d33-15c629623d1f@kernel.org> <aoQXk1PmUDD2hxZF@lucifer>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <aoQXk1PmUDD2hxZF@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4BD9E40008
X-Stat-Signature: 7wd6aycpdmsyxqukmmz5gdhrbgbzmpbe
X-HE-Tag: 1787046616-37613
X-HE-Meta: U2FsdGVkX1+YvJbKOLR+qqXCLOfHuFKMb+5iTc1xsxG7HLU11BSP8H5uwe/9Xl34xjgIAvEDYfvHJGw+VppyUg+QFL7haqWFXEWaEjAMY5vIGG5Bt+ez4bUGRQr3RGxG2s1w/18zrrtiU+L6N2BPO5V6DDZEoqxVL756QzXnSGI2r4YWwt3slFFAePCFRjoHNwc4a9JZNtYxrrdr25CeL41VVakNuq4Uc8FVOKpNPEj3sxRnF3rp2K2HDTn8YOmDKSyZQUILnk6cb1kPsxwt9VwFT4PoedmnjQlMZ0U2vdHdvpIOxrcrjI3ytmBVqDHCrZhWSk4IesSO297hdeLNcAUaR+phTkvdpfmxlLjioxLFfqdKCnHgdNEU3sZvq41IbvL/22PLNqRnrz5JKzvMT68ShH99JX9y58DWae/zbuDzD9DO9uxI38LbNvVA7ZS/Ej44Hx/GlZyphl27nHE62jAtaldkHU3GBoGYALrwcegGBA/syMeqAnqdJAF58+cKQLlPgWQ/k0LCTlGKUFbNcT3hwbW4cfnIa83qCSb9MpdwGvsQod/QWrtEMWPYCpoSv3Ca90PFCUzfPMZIZkNIVj+sQqyTf8oFk7/n+rcLr3cJ5ozpqdCsxzadiJMmmOm+3mLj2wOkJ+nxj7AO9urqJVoPYqUrb2Op/H3qyv3YuMUOKmwOkjSTfe0CKw/YIGNqtzNH++1mRqKtq10ERyjd2STEGkua1fuLDK6FzK98NJ0GxnVMgGmvHw7BknC00qc+H84EFaTr1ZHKcO1vDLuyNo3aQ883QLLJ0kPNtia2pmzzWpqIDOWDvCVi/xYhwfJ+zgr92sSycASsFw+yN7AMYZ0rWZUrLB4mT+GhYEdilHC4DIiLq01dCqAYTKOjzuWJgOhSaH4qd1YdCXlrzRnPntUlHbqaPkgKp/rjbGBxy2cohKyz39FY0CVrcYzsEtP74nhB20s9SJbtg9vk69Q
 Q/3hhOWb
 3mGmDipv9Z/A8+7zIacYziH6OYtLGPE4cWDRYbSVPhcaZ4wd7GLBjDNTpkNa3Do4LZShvKA3zVRwz5bgt36Auc3wMV0gus+UV3i7LSHOuEuwQkzFAG5UObI9LoW6YIdmDjy3xCkURl3KKUBebElxARWEXpMINoTNZglauWfI9176IbLHJ3wAhMbyYrqEiWzkfwBzmApmFJ6KPTchmnWIzKDfC2YS0K5TVGCTKSzkFG2Vd7QnYZAYKowfyvJ5LL6FV9r37UYTQ8HqMxqZuuSwICK4jfGbwfUOUfUl8O+3GlZCfumeqXFPjm1I9vHi/x85M8B0PPMjy9YRnTOoDZRZeLd9C3ZAF88E78MJc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/18/26 4:56 PM, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 18, 2026 at 09:30:40AM +0200, David Hildenbrand (Arm) wrote:
>> On 8/18/26 04:13, Hongfu Li wrote:
>>>>> So after migrate_to_ram() the folio might have been split or otherwise somehow
>>>>> the page doesn't belong to the same locked, refcount-incremented folio it did
>>>>> before?
>>>> I suspect a split.
>>>>
>>>>> That's kinda a footgun... but this documents it at least.
>>>>>
>>>>> I think a comment explaining how this can happen would be helpful though as this
>>>>> doesn't seem intuitive.
>>>> I think, conceptually, calling into something that consumes a page (vmf->page)
>>>> always needs care when operating on folios.
>>>>
>>>> Passing the vmf to some callback might be the odd thing here, because the
>>>> vmf->page contract is not really clear.
>>> I'm very sorry for introducing this regression.
>>> Thank you for identifying and testing this issue.
>>>
>>> I will double-check this code path and apply your fix to run further
>>> tests locally.
>>>
>>> Would it make sense to add a comment here like the below, to make this
>>> subtle behavior clearer for future readers?
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 4134ac607ee0..2b6d6c863ecb 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4937,6 +4937,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>>                                  pte_unmap_unlock(vmf->pte, vmf->ptl);
>>>                                  pgmap = page_pgmap(vmf->page);
>>>                                  ret = pgmap->ops->migrate_to_ram(vmf);
>>> +                               /*
>>> +                                * migrate_to_ram() can split a large folio, updating
>>> +                                * vmf->page to a different folio. Re-fetch folio for
>>> +                                * correct unlock/put.
>>> +                                */
>> "migrate_to_ram() might have split the folio."
>>
>> Should be sufficient I guess.
> Agreed, no need for a schloppy long comment here!
>
> 	/* migrate_to_ram() might have split the folio. */
> 	folio = page_folio(vmf->page);
>
> Should be fine.
>
> The commit message should be updated to reflect it too and mention that we are
> going from 4 -> 2 compound_head()'s now.

Thanks a lot for the suggestion. A shorter comment is indeed better.

Will use your suggested one‑line comment, add the folio re‑fetch, and
update commit message for v5.

>> --
>> Cheers,
>>
>> David
> --
> Cheers, Lorenzo

-- 
Best regards,
Hongfu


