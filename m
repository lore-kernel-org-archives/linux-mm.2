Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC84CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 15:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E548E0012; Fri,  3 Oct 2025 11:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE948E000A; Fri,  3 Oct 2025 11:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDA48E0012; Fri,  3 Oct 2025 11:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18ACC8E000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:30:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FF3F87A24
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:30:28 +0000 (UTC)
X-FDA: 83957189736.10.B7F313A
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75E44C0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:30:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSpdsRqy;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759505426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ThghlDWAjurOxYC98aHbkMmCDK/KWDP3RpbWxUD1rs=;
	b=BB3Nvd7U/04bfAgQ8QqmLinJ1eXmtVvh5A7zTdmtt8k8zymBr1JQHA14lXXku12sGuX3os
	mw/trRt4SCGAhYCqVFXDyHeS2mAISGugUbGiz6XqjqiBPN75IdRXjlZrc8CdTNVNvY8u2U
	pHwqNBdb4eUvNlPF8kFZGgqhbHtZcHg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSpdsRqy;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759505426; a=rsa-sha256;
	cv=none;
	b=GsFw9oVd8YeNIBrO90ro1btfWc49K2q5Ij9kk5hMxIqPr7+45IrEzP639bxyGkwqDY6aEE
	yb/6sCF8aYUan8PgnqiFJ+wWCDak8AbWTbzehtFSmPezBzbfTgRuu6gKlvZ8OoHgnwTw75
	JXMxiiNQBI/UnkUZBoqWmUwE0wf6NGk=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e6c8bc46eso14902905e9.3
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 08:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759505425; x=1760110225; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ThghlDWAjurOxYC98aHbkMmCDK/KWDP3RpbWxUD1rs=;
        b=XSpdsRqyg5ass+XrnRmJkqhuKKl2NnXuMWNOqeC0S7aSGLzFLTyYiCjR2pQ7DC8g+S
         TLsPG3j3wVsTE6koGhf1GoRzyw7ceJhr2pkevXUsp7fEqq4XJZ5s+yS841kHHffTK4vB
         a271EmLR7kVh0JRXHX7dWZYxyAyjD27vlPwM9ASQsFOxfJ7XVVA/j6bkhfaLDozGj5KO
         xBFgpX72N5iAawFotDeFb0GpHPLz/tWTzi+cXt0sGxGuk/ocHn9RwT3y74y5Jt6fDhVc
         vockf/Pbh7BFgeM8ix6kwBwhWLLUc7f4fW5p8JolaYFp2YcgMxVF2lozVWfD7J/xuJSL
         tJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759505425; x=1760110225;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ThghlDWAjurOxYC98aHbkMmCDK/KWDP3RpbWxUD1rs=;
        b=V1QqVw8KWQzR49gxkZRGzi84ECW6AChzzL8ApRcZBMwmS1YOZ7QmLYhTTOmmGFcYsq
         +8VqmGQ2RtjorfUkjwOfbqw0HPAnoFJOctKFXUMdGZSJw575GwePIL1EfFf0st3tVvDQ
         FZHhJBDu6fScn+W1adFqMlmXah5iQV2eqBPuqzVDAKG/49aRC/CcC50MIyWh2IQB3nyR
         wC24PxJyfHqmXrvhkVgtv84/MqkDtO2xZ+RXToEabCNpj7YgdlgR1THv7wpJ0kISO3G6
         EnFQX95DG0r3x7DKhYOT6wrzgAHU/qNnZLVKZ9io8g7qyXWPFGt/iprVaxSGcoOaZIJg
         hCvg==
X-Forwarded-Encrypted: i=1; AJvYcCVjaewyDI6h2pnhIQQdWv7t1sB6j9zD0JOKpSWygSrw6Oy0bxb/0E7g/4nyJGiZ/JW1y5T/K1BZ7A==@kvack.org
X-Gm-Message-State: AOJu0YybCZqv3Co2asX0JZvRy+BJykAuLITFq5/CG9AZxW3CYFhYzBKB
	6yDvAsEF37SbOIY7JHANvAASeDr1RoFhbB6J3UKEvemeTcwbYNSyYyJN
X-Gm-Gg: ASbGncsx2fLVYTLyJNrR5gy4sN8pcv/vHWyA84zHBR70YfKzB6zb9cBEitCuYzpIVny
	qM53/Q5+tKb15Vfk9p/nJgChRDC4Oevv+KCLCUKlwn3ypLNiG/4PitKxDBoYLbwyqfWl5byyKpd
	4KhJ7ISjvBMcVztrOJoqRifnujd1v6Uje5OmiPV31Pw6cjdUB8hxnuPrFB+D966gFrO4Zd4i0yS
	S4C/IAB+xO683eFCZJTXAU/oEe67THACYZT74nUuXmfndriq3Emrw+Fpx/NECudgSXVDCjpOw+I
	jNnL8TQFkdG9onUA5cm6sjwdrHkQpz4A3rRn6GTJ5L7pXKzhvpoFrpgkbtEKM9ozZsjljO4fRqE
	fih7nKX+W4aoE02K6O1GGkqLtZj0unAMDRr294gfCslJ9APAprDeDUqMS9mXoyNZmStBGgbYzGa
	pkqUY0y3c096vVgPAdl6zHKpzHPQF5d/MX6iwsNVbFQA==
X-Google-Smtp-Source: AGHT+IEREfLt3SJY1BFKHzWytZfJ9g4dT9ZMKAjBYAjJwr5+hXtXNDgkIQf10sLtLNpFjlYZ9kvUEA==
X-Received: by 2002:a05:600c:a319:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-46e74cc4609mr13969235e9.17.1759505424738;
        Fri, 03 Oct 2025 08:30:24 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4abcsm8332891f8f.53.2025.10.03.08.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 08:30:23 -0700 (PDT)
Message-ID: <29ac3e02-fb60-47ed-9834-033604744624@gmail.com>
Date: Fri, 3 Oct 2025 16:30:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, wangkefeng.wang@huawei.com, stable@vger.kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com,
 baohua@kernel.org, akpm@linux-foundation.org, david@redhat.com
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
 <1286D3DE-8F53-4B64-840F-A598B130DF13@nvidia.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <1286D3DE-8F53-4B64-840F-A598B130DF13@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 75E44C0006
X-Stat-Signature: or3ajaexybefio8o4iesro3cpf48fc5r
X-HE-Tag: 1759505426-139828
X-HE-Meta: U2FsdGVkX18Rhbl2Q7lNXUtpMO5tDHvjfyTJlxokuSSlFDMYSEbFgj6xgfYgNfPFbb/UaXIjKinu+sT1+mvcMl0xzj4c6GoBhFA5xyaDyuiT0KvkbP/U07ofPFjdD7HseNvnfe5t84Lz6fycwl2yjCBQQKe5jj/xgRA0XzpNYTQ7l1Eb7QxrwuCzFsuVEng9u6TK4eimWmQ17BDQZZ86beB1FYXCYHLGXT4NeDyEF219A4phs7YeyRGRHnRdz1Z0qUuV76QSg+W9UvxRlFcav9pDViSTmXxF0x8i8qROeql2B6TWUY6Xxlb86iq+ha+pTdqlSbQhZ7rN61787gumAaCEsDON6DqAsTvPK1Aryfxbmp8Lxzs7ik+cbb7GFnYSkcvS2aFzWAVjppdZqIhkrXZjwN73Sj1PmaTpoh8GeMVSF6BuHThhGkDctBcCbzAF9bTrFcxbr4HTrNawj/FO7XM/yXDKj2F2csM9kqXkxk0oDaggZzQVaA7P1DNwHO8uNCV2sFacP6Nbhl1IRpFDSOS+qdR1Ie5uJryjQ+OmmsKjihraITAQwyJwQZF1lKqHNPaI7St/5Yr69y9sMywxQavWUJahaN9ciiBzLOfUKLSIsNuS7nenoFtjzJvDw3G81J48HuklXoq8xmafzKsmyGAQ0LGekOtdoDnS3+y3N/yGjY4JQXbWmZji1jKSscD+pdgZdW/ZBOQmMoJWChjXTww2rVy2xYUM2EbCtX8JTazArwK5sdXx06zzsM3f49miZ6Ek3aOGkHblOh5Qh1Fq0MEQ9tr3gT75ciWCYJUihV6J2kW3HTzQjgR4GAg9O9i68jXQkzFLE4ycAnRJA/X+6NSvemuilCcrGS8FNTJyiqge7shKSJwefWVldEka5QMpNjdAkYuXVRSROpyfX/+OOSpkx1JKzv8cbtWbG3rKZbIcE2YJDD3EAc+cGW77+ZOOg5gMfyx+bgm5nOy0F1E
 VrmOGEAr
 hvS/6ZKXgTDdAFRs9csmXKFr47RzUv8wgBmuYOj0J8BYJ58mX/5XeA2UtRhbGUA6i/7ZBKvknxiXCf48aVNw9tAnVcTbUhpMDwQ4X8M0fRRpAsA+8OQjUsKDQS9gmSNomX4LLm7tBnsfBqS+MMvCdgnGn1/qLUexDrSzDdHIYxMHuDyWIF76XeEBd394CVa6gkUK4yH9+k7nxr2pi1ywCFCjig/urzpP2AVjJIwAWL4BgdnUm+kTSQqkU1/XrtHUHvV7W2n9HCiV2fdpsQQHq86YHN8oWXk1B3kg9LT6mPmRTKbyR9lAH06SYt1twDfpGAuE5GXaIugqc5xlvbGDHA+6L8bxIaaN/R3j77U1frpGIMciDeYG35c0xyKDe2oOQcGz5jkjT/3q9+kA8rL0afiMZo81V4CPTgQ0DjDWKOo/DYgdT7EY052bQ+7EN+l7fOMlGH9kVRxZD2+Wb2Nj1mI8Whd+KB2IXaeNkU5eS7ERlfZlGCOnexzI46UbkUQ6oHU1BZbVwZq/inxyWwIztq9HSH21wX3tv/p5Txp0ytoRQ3GXsztO1KbfST3C/WFYALpw79yjzGz7LEORyeFLGb63gmz8lTkh2jrqHTzW8JRUhw0oZ9oXTjDtFH4l1d/3ic88y6DQndHML/qSw14YPESe35uzXIJT7AtAY2iQdVzyC3W5So8oSqP/GuLpHHvNz0fN2ywkTUWLMaJ/rj1WkD8BxnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/10/2025 15:08, Zi Yan wrote:
> On 3 Oct 2025, at 9:49, Lance Yang wrote:
> 
>> Hey Wei,
>>
>> On 2025/10/2 09:38, Wei Yang wrote:
>>> We add pmd folio into ds_queue on the first page fault in
>>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>>> memory pressure. This should be the same for a pmd folio during wp
>>> page fault.
>>>
>>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>>> to add it to ds_queue, which means system may not reclaim enough memory
>>
>> IIRC, it was commit dafff3f4c850 ("mm: split underused THPs") that
>> started unconditionally adding all new anon THPs to _deferred_list :)
>>
>>> in case of memory pressure even the pmd folio is under used.
>>>
>>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>>> folio installation consistent.
>>>
>>> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
>>
>> Shouldn't this rather be the following?
>>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
> 
> Yes, I agree. In this case, this patch looks more like an optimization
> for split underused THPs.
> 
> One observation on this change is that right after zero pmd wp, the
> deferred split queue could be scanned, the newly added pmd folio will
> split since it is all zero except one subpage. This means we probably
> should allocate a base folio for zero pmd wp and map the rest to zero
> page at the beginning if split underused THP is enabled to avoid
> this long trip. The downside is that user app cannot get a pmd folio
> if it is intended to write data into the entire folio.
> 
> Usama might be able to give some insight here.
> 

Thanks for CCing me Zi!

hmm I think the downside of not having PMD folio probably outweights the cost of splitting
a zer-filled page?
ofcourse I dont have any numbers to back that up, but that would be my initial guess.

Also:

Acked-by: Usama Arif <usamaarif642@gmail.com>


> 
>>
>> Thanks,
>> Lance
>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: <stable@vger.kernel.org>
>>>
>>> ---
>>> v2:
>>>    * add fix, cc stable and put description about the flow of current
>>>      code
>>>    * move deferred_split_folio() into map_anon_folio_pmd()
>>> ---
>>>   mm/huge_memory.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1b81680b4225..f13de93637bf 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1232,6 +1232,7 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>>>   	count_vm_event(THP_FAULT_ALLOC);
>>>   	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>>>   	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>>> +	deferred_split_folio(folio, false);
>>>   }
>>>    static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>> @@ -1272,7 +1273,6 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>>   		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
>>>   		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
>>>   		mm_inc_nr_ptes(vma->vm_mm);
>>> -		deferred_split_folio(folio, false);
>>>   		spin_unlock(vmf->ptl);
>>>   	}
>>>
> 
> 
> Best Regards,
> Yan, Zi


