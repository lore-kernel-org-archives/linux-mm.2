Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7FBCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A7D6B00A0; Wed, 14 Oct 2026 05:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6906B00A1; Wed, 14 Oct 2026 05:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5002A6B00A2; Wed, 14 Oct 2026 05:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30CE66B00A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:35:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABDE480486
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:35:19 +0000 (UTC)
X-FDA: 85320723558.30.36A7428
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf13.hostedemail.com (Postfix) with ESMTP id 15BD220008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:35:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TuckBnnV;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970518;
	b=WQ5TGuWD1yvkZlNEQPbx8hB1K+Aah9Ie5Bf1aOd2brOKTmhDPy+jJRZ8RFJ02IbSVrcTkK
	+XtC/1K8r8ElVRgC5go8iBL6qkfPeMSvopngh/ljzFFjx2lF5zjLhcuBdvH516ZL2rVpLD
	ENGMsIM96qDT0NBMOmBGn6I5X/PEmww=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TuckBnnV;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzQV53UhB9WLFXZ3kw7JuyZ+RL9WPK13e0F8BsUv4g8=;
	b=kycTw4n/X80MSqXX4jzfTVznoPStXHO/bjeSDlFQbTj1K4D1uZNMNROMOzYeLHRRxppJX6
	WZas0Ry4337SSB8CT5uVKbL93+GkEM086mwQfFEw5VE6xcdENuuYecXilFBU0c2QBzBVkJ
	TsiIn3EQi7nmWB0PgyCecP9fOSrRXFs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791970511; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lzQV53UhB9WLFXZ3kw7JuyZ+RL9WPK13e0F8BsUv4g8=;
	b=TuckBnnV2gndx2Shl2mQgAas0H0K8EeXutDAuWQtam0V0TwEeIIgy917J/NFDbN7sycibBI2Lr0OoHTyA76GpeMq6NGw7aG7Yh/zN6Osk9AoPSIpNEvhBrWqQYfR7r235NVFxsqw3DUkZAXGmrnBqZT9wGoUJ8wH+6Xy1FkeZ54=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCoahw9_1791970509;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCoahw9_1791970509 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 17:35:10 +0800
Message-ID: <b19ee13f-3cfe-4ba2-bbbf-a23d18330bcf@linux.alibaba.com>
Date: Wed, 14 Oct 2026 17:35:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Lance Yang <lance.yang@linux.dev>, Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, mark.rutland@arm.com, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <20261013153953.77575-1-lance.yang@linux.dev>
 <516828fb-558d-4a20-9532-51f50d6ba042@bytedance.com>
 <f111bec5-6148-4649-8805-79a250f6e736@linux.dev>
 <a6feb3f1-c08d-4d54-a38b-55fafcfec7b8@linux.alibaba.com>
 <cb63eec0-4c39-49cb-89c7-15639f51a710@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <cb63eec0-4c39-49cb-89c7-15639f51a710@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15BD220008
X-Rspam-User: 
X-Stat-Signature: 8yr76aju5jge54ituzszacriftmwe147
X-HE-Tag: 1791970514-995412
X-HE-Meta: U2FsdGVkX1+ti74/DIYwqg0ZINAbH5fmmm9xEkGOBdO3qR2llJDO7b9mIq5k3B3/IlLPc5FqzYv4NoOIPpNDzKAJ/LfIyZwI0PDOKFJCXU3I28hkzP7tq3FuA9KxPN6WGt2b9eMcjZdz0jQ6JSzzb7oqKwU+ZdlRxOj2KoYjdzPwgehoDKVr4ZmlcgKWdvsYI/97ZA05/C3UZ3YIb8OXIGZTZ5k4hl7F4mDEwoAElYvxA0t8uSwRq95EW8fY3bfljJWl6R009y6hhRawM9ZmdchdaKRsZMMRUAasQgyDrBqZBRKHXm33uhs8AUocIw7Sz0uIkODuet16+Pw6qIV9M5IJxL5b09NO+o/q2oRlrWQ+Q66bQtjg7t3Dyp9BskBo7g+mxx7ZD0OxyHrhYYwR3TUyBJnrrAs7ymweJbRbgszlcBxGSIewENzs2vzIf4iOGLGThvPEl6ShdszaXAvPzNa3d2PvbREPt/kpkyMqnIwlDrUGIvFJc0EkCB51MblMc0pYc9hKsYWSRR+6DAz86tJ882mTrie7JeAaAfXaWK0+cyl/mWV/0b3AxIwqSiPEw5zaJxtTbUEXFDtPGvyyP1Dx8Aj29rfGNeSIjdBNw0mtap05gjbrp6kuZhi8+VzwxYGOt9OyL4E5QjO1hD0tPW247438DP2C0iN3P7iEFrDoW0PxGGWyXExvdTj0XNr4Mdrxv7ubdfepdxZX2fyDV1WSm+AF4hPNANdQigkECVBMghmucJDmSVeypgk8ZR5sJbqiUIBxLKbQjcyjimDYnVeHLZ0nYOXl/fc8nn6+OiIVqriGXFjyUyd0gnJn/6+Kc9MJaBPXVBbRw3ibXb7ZNRCIQ/L9KFbnS0cHX6SYrT2USRzfPhUFNrWAXXOBEPpnJ3Ryq5PAZ0hRRwyluSw2sNF+lsFVOVbSWrXKroKStZeAmDQyuSAyzb/uu0Xg5k3yL/1e3+I40tgzp/4pEb6
 +BgO5Dta
 zo/Ra9vPHgeEfaLhV9uKsq3PVxFoXkbmUuVvM9H9sCYwRfD/rmghe0TmlQL6q8S6/szQRXFyy1x6+H00Skt5prXyRQcj2B55IgC0JtxxQdOnXs8WTNYVXRoM1uLTszD7eI0xeMt5u2f5esEZuDXAorh1PLslG+wqkAu88e0gnrzjdie6kwtM3pJnSkG2n2mG3/+B4emeM/Fpipy/768ugFJtWIx92BavkSsNfbzXEtKVxluL1EslGAqTKiZR+cFTTvFhYWBT/rEvBRB13FO8W6H9itP5onYSBsJKlbIWdqlrnW+fTjw06iQpZTlHBWFjGn3V9cE0k/xCyX2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 5:24 PM, Lance Yang wrote:
> 
> 
> On 2026/10/14 16:38, Baolin Wang wrote:
>>
>>
>> On 10/14/26 2:46 PM, Lance Yang wrote:
>>>
>>>
>>> On 2026/10/14 14:31, Zhao Gongyi wrote:
>>>> On 10/13/26 11:39 PM, Lance Yang wrote:
>>>>>>
>>>>>> +    /*
>>>>>> +     * Keep the producer-side invariant documented in pgtable.h 
>>>>>> true even
>>>>>> +     * if a direct caller passes an invalid descriptor with 
>>>>>> PTE_CONT set.
>>>>>> +     */
>>>>>> +    if (!pte_valid(pte))
>>>>>> +        return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
>>>>>
>>>>> set_ptes() is the only in-tree caller, and it already clears PTE_CONT
>>>>> before we get here ... no? Why not fold !pte_valid(pte) into the
>>>>> !mm_is_user(mm) check below and return __set_ptes() directly?
>>>>>
>>>>>     if (!mm_is_user(mm) || !pte_valid(pte))
>>>>>         return __set_ptes(mm, addr, ptep, pte, nr);
>>>>>
>>>>> If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
>>>>> rather add a VM_WARN_ON() to catch that. Silently clearing the bit 
>>>>> would
>>>>> hide a caller bug :)
>>>>>
>>>>
>>>> Hi Lance,
>>>>
>>>> Thanks for taking a look.
>>>
>>> Cheers!
>>>
>>>> Yes, you are right. The public set_ptes() wrapper already strips 
>>>> PTE_CONT
>>>> before calling contpte_set_ptes(), so the pte_mknoncont() in the 
>>>> invalid
>>>> path is unnecessary for the current in-tree path.
>>>>
>>>> The issue I was trying to avoid is not that the incoming pte already 
>>>> has
>>>> PTE_CONT set, but that contpte_set_ptes() rebuilds the pte from pfn/ 
>>>> prot
>>>> and then adds PTE_CONT again based on alignment. For an invalid 
>>>> descriptor,
>>>> that transparent contiguous encoding should be skipped entirely.
>>>>
>>>> So your suggested shape makes sense to me. I will change this to return
>>>> through __set_ptes() directly for invalid descriptors, and add a 
>>>> warning
>>>> for any unexpected direct caller that passes an invalid PTE with 
>>>> PTE_CONT
>>>> set, e.g.:
>>>>
>>>>     if (!mm_is_user(mm) || !pte_valid(pte)) {
>>>>         VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
>>
>> mprotect() can trigger the warning here when setting PAGE_NONE for a 
>> batch of PTEs?
> 
> Nope. set_ptes() clears PTE_CONT before calling contpte_set_ptes().
> PAGE_NONE makes !pte_valid(pte) true, but pte_cont(pte) is false,
> so the warning won't fire :)

Ah, right.

>>>>         return __set_ptes(mm, addr, ptep, pte, nr);
>>
>> I am trying to convince myself that the 'nr' passed in is always 
>> CONT_PTE_SIZE aligned, but it seems OK.
> 
> Still nope :)
> 
> IIRC, any partially covered contpte block should already be unfolded
> by the time we get here ...
> 
> We're just installing PTEs without PTE_CONT into cleared entries,
> so nr doesn't need to be aligned to CONT_PTES.

OK. I see. Thanks for explanation. So looks good to me.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

