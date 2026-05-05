Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09A2FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 04:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91C66B0088; Tue,  5 May 2026 00:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43626B008A; Tue,  5 May 2026 00:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B583F6B008C; Tue,  5 May 2026 00:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A52826B0088
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:17:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 061DFC1B72
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:17:53 +0000 (UTC)
X-FDA: 84732058026.15.24020FF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id CDB8A40007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:17:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TaOjExPQ;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777954671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+ne5DCscfJM+qFzRLgFY1CIkmmMSUBrQ6mtQyV16+8=;
	b=79WqaYWHL8yYNtmcWyBhdvpR17zqG/alMOcUxaCmZCYIEdeRPuoOooM7+zuCueH4lbs7dm
	WB6Lpjnw69xUYhFbqHLTHUdj8pY4lrQqwQRgJlrMG9nX7hoe2wUYv5xzz/VjCj0rrNJRXU
	Tfi2JUMk8690f6GVc+geOF/DkvzqsYE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TaOjExPQ;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777954671; a=rsa-sha256;
	cv=none;
	b=XEhAaUGubTrj1BmJ8/gBfqIbxuCNcFBuVSx8vUfqYs5C0yUjy6urZwRWOGXpHxjqKV7foU
	OVk+V2Sd1dqI4eC6I1bUWRtHK4/l3IZdaPYod7yBGQaJXQ2iA0GDiZlTrouR52cint1nOi
	ZUfzxTSLVRpywCWYtITJvarRCkyLyco=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47A9B26AC;
	Mon,  4 May 2026 21:17:44 -0700 (PDT)
Received: from [10.164.148.38] (unknown [10.164.148.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7ADDC3F763;
	Mon,  4 May 2026 21:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777954669; bh=3niOScSs9vDuIoOXeNfLH2FfR3PwvJa8d1SMHBMmudg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TaOjExPQK1qTV0xeD1xjGLwLWEehBwxndVA0mwb4KWqiXfbYVVjWMVMZ6k/orqpwY
	 0nw6Wz73l1pPh2Kzpibwigm/zPgyWpTmoS84+/2Qnnk+XTMKPOUA0UvwxLNRQe+6/1
	 lArMX9rEBL02CHDipEGKrxjkm4EGPOJ0eY1LINAU=
Message-ID: <ae253daa-c60f-443a-9c09-ce66a2210207@arm.com>
Date: Tue, 5 May 2026 09:47:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc()
 failure
To: Lance Yang <lance.yang@linux.dev>, ye.liu@linux.dev
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liuye@kylinos.cn, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <aed7c1d5-2189-4ee2-b0f3-ce5a3e3c2118@arm.com>
 <20260501132438.21298-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260501132438.21298-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CDB8A40007
X-Rspam-User: 
X-Stat-Signature: dy618x94ozk7forjggkc3r5jkxb6pxdp
X-HE-Tag: 1777954670-938075
X-HE-Meta: U2FsdGVkX1/0FOOEepi7TUec8ywGSRHUAAqPVnw+CbfEy1uEkUwkRe0n1U3vH+Gm9YYOacslopNYu1oN14WZqBuGwq+uwJVVLfpDnjJrU1aqlSD/i7IW1wK7TjGf8/tUE5OcpF9aoj1siLEsa62H5JuArQ70m1KIRLue7ibCBDXoth4Uh5g5BdRDrFfBgYKZILAf/i/I4jAysTpbJEiPcKd5HygCHr7+eX9t7DnS/DiEyE2Oa5gFiUsW+DIoS9AFsBg6IppBi9fUecxA5/R3qwqEhZuE+4O2aTSN1S927IV6FxBLEn0UKL8zxA6nnghk1IDcEUK31QHMb13nPFacKuaXEOJb4JdOOxjyFV79+lZnylnfUkMElOHVQEW1uF6Qz+4BIIWHcW0J0R6L09SHAKxhu1PfwqU3EA93faZgDbs+k+Tf284uIDisePf0K8q5Rtl9cL2ZPMIefWxrgzIFFnoE/Gyl53UfgWGECHecYGxb5Ijl/V5rzFmN4kTsIByOlm6WNE1M2xqLD9d5CdGOSx6Aw+8FyCvKwBUwyWXb2R9D/Bg42qIrhlfJzpANTs/O+34PL7gxxZBcn6fSwxI2DUm7CZ5bNOH/tNgKEFB/hMeRG4MzeR9KSNLHViXHbQK3w7LIMPfqmVT7GwC6hhTzzRTwMEkqW19NV/2dQda4Grprwuze10iGwQuC8A0C0psklYKHqlAVO+ujU3mj9pL/sxDt5MK83QSHIRi4L4Va27YmptEjIUld/F+xG21LvV9jDD2J+K9QBl9R2UyN9AkjppXHyrlGNZ59amOCZJ8Jkxgvi1wkeixZyFENq75fyIDinyCvYHeJPhWJEGOLW9+4B54pt0tOIVxKdyy17v+AVmVtajEnsGvtW3kda62LsHB7j20pacBLj9hHphZVThpoh3rAOl4uCoabW4MJqhFysrB3JrnLDoK7JlR1oR0DfYn3W4BHGyuVDhGWHr/GS3v
 /gpG2xX6
 HG5eQWX8eDN5Bekh57oi2Vzq2R+uoqK6paMOKjcK4ZuFInChAb1D6zKUCUdAn3xY85l4Jet75cXdkbGLMT42UnMCsra7WBlkBaM/T2ShiiiAvmYgGlRy9a5ApJcDCFz83vk2vG7Yf/ojRO707/287HbAMhdzmLRFza5+8B+Uz51cWAcJ2yrpt67Tqmo2gHWqCl7uiutnVxL4qSOJVoT1FBhYt/1PD9Fm2/iEh9z59GteV0bRpDcKOjpCySk8W4r/GZddhSsmDWEWHW2U2Aa+0gDMR1CD7MjzwPpWm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/05/26 6:54 pm, Lance Yang wrote:
> 
> On Fri, May 01, 2026 at 04:10:58PM +0530, Dev Jain wrote:
>>
>>
>> On 01/05/26 1:27 pm, Ye Liu wrote:
>>> From: Ye Liu <liuye@kylinos.cn>
>>>
>>> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
>>> corresponding mm_slot.  If mm_slot_alloc() fails, the function
>>> returns with the flag set but without inserting the mm into the
>>> khugepaged tracking structures.
>>>
>>> This leaves the mm in an inconsistent state: it is marked as
>>> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
>>> khugepaged.  Future attempts to register the mm are skipped since
>>> khugepaged_enter_vma() checks the flag and returns early.
>>>
>>> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
>>> restoring the ability to retry registration later.
>>>
>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>> ---
>>>  mm/khugepaged.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 7d48d4fbd5f3..60ab7c1b61dd 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>>>  		return;
>>>  
>>>  	slot = mm_slot_alloc(mm_slot_cache);
>>> -	if (!slot)
>>> +	if (!slot) {
>>> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>>>  		return;
>>> +	}
>>
>> You could just move the test_and_set() after this no?
> 
> Yep, that sounds better :)
> 
> Just one small thing: if we move the test_and_set(), after
> mm_slot_alloc(), we need to free the slot when test_and_set() says that
> the flag was already set. Otherwise the racing caller that loses would
> leak the slot :)
> 
> Something like:
> 
> slot = mm_slot_alloc(mm_slot_cache);
> if (!slot)
> 	return;
> 
> if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
> 	mm_slot_free(mm_slot_cache, slot);
> 	return;
> }

My bad, I missed the fact that test-and-set may also fail.
So I think Ye's patch is also fine.
> 
>> So if slot allocation fails then MMF_VM_HUGEPAGE is never set.
>>
>> Fixes tag is probably required but not sure about Ccing stable.
> 
> Yes, Fixes sounds good. khugepaged collapse is best-effort though,
> anyway :)
> 
> So I'm also not sure about Ccing stable.
> 
>>>  
>>>  	spin_lock(&khugepaged_mm_lock);
>>>  	mm_slot_insert(mm_slots_hash, mm, slot);
> 
> Cheers, Lance


