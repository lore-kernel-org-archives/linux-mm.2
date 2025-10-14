Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58509CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CFD8E00C9; Tue, 14 Oct 2025 11:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED2A8E0090; Tue, 14 Oct 2025 11:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC2A8E00C9; Tue, 14 Oct 2025 11:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5C28E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:33:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CE101A0957
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:33:26 +0000 (UTC)
X-FDA: 83997114012.19.66201C6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id A8EE54000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:33:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VfmNMPSU;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760456003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1UVYE8sOFf7urKOQ7gZ7h3LRzinBvs61P0Q6ItQr+k=;
	b=xi01GNg/21SJzCSX6s32DFLsrYUj0tGdHa7fwqT89yeNTxLYPiv330mOqFnN7XzNW1wXex
	gvoVlqVZIdiYG785pG1JSD3TZdO6kTs/3bLQ3Empo5N8ozxRjkyVduQJdGsXOM+d9IYibo
	Hd5thDQvEAwMIa2HDjWnNb/7fxrK9zA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760456003; a=rsa-sha256;
	cv=none;
	b=CJNoY6bflE9NPu+3MPuv8zJOtx8xeJyPGzKkVm1xO41yzaUkVwV0DShdYWtj1qUtwOTwKD
	X9adKHIcKFuXWMz8k5EH7veExVtO6vldQ0nen3kmEcfIklpXdLGVADL8a6gv5MISb5EvQK
	iIicbT3G7AhIQS28OB7dHk8YR6EPOO4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VfmNMPSU;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760456002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+1UVYE8sOFf7urKOQ7gZ7h3LRzinBvs61P0Q6ItQr+k=;
	b=VfmNMPSUREAh+HJNXOIvVquQlI/M5czYXD2oalqod8NeIDSwg/AnuqmRodGMz76MkSoXN9
	/ZvVs9f2sUNZruKneZ5X/L9WLI5ETXBktAM/P5R44hMODYXjQim5nj6FmXgtbCRQZyynkq
	g9ttAxKErEuZJqp1j8/N18hVnYbRsmw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-ke64E4ATPbmlQKUHOq-lBA-1; Tue, 14 Oct 2025 11:33:21 -0400
X-MC-Unique: ke64E4ATPbmlQKUHOq-lBA-1
X-Mimecast-MFC-AGG-ID: ke64E4ATPbmlQKUHOq-lBA_1760456000
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e509374dcso24395035e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760456000; x=1761060800;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+1UVYE8sOFf7urKOQ7gZ7h3LRzinBvs61P0Q6ItQr+k=;
        b=kdIYoOi3JagWy3H9mRfOMQwyg4d8YX115+ommu0eVPZZ1ZaVqYRPZ6IMQaUOx3sEOM
         ULdOA3YZpxKCxtu4nGfkNeB9gI6Hc3NrIoaCi09zSlnvUxqjlpHIK7wqBLIsbJZ7qcK7
         hrCjwGC0JpFOsv0F9LGTaPxpgZxaxsuo98CZ41aD1bc8Z0IsOHVkyo1HGLDjn5LA/AIJ
         tvpuk2Da+CbcQ/dGWbkFDe6guGvF6NKVaW2avdrBBvpRTqcn7BzyTxo71YMzZmtyPTMz
         +CRrmJ5t0i4V6RquiZIT6J3GZ8Jc1hxbP1iRfV5wWBcr78QznU+pFBR61T+5HWwgL471
         C0eg==
X-Forwarded-Encrypted: i=1; AJvYcCXD5/JizuDq7FutAZCveH8wzivn1Z9Zyb3vQpRnmw3WsNuWPaqurfJZrO2I9cX4noNkQc1enut15A==@kvack.org
X-Gm-Message-State: AOJu0YyTf7utk9uOepCjL+RKwO586mj1RNxI04iZIPQQjwjOFf6CjRMP
	s7pKs+iJi/uNynm89zPKOJydOAy4xxiAP6QT3EUUagJZVsWMnYW7gAOLlFrykRQSpsyGRjFVXmk
	ymqj/ativMn9dj9M/ZMC4UniecKD2JjclW+0MogFJkGpf8US0gMuH
X-Gm-Gg: ASbGncvQ4foDHZKscBUtPA5IVNMxJJ7DBmqlncWpYJj+9uk3+FvdwV88aWwg7KSL7/H
	vvbE00cDHp7gUxegxEOqGtzzgTdJ866plqeztCzVwIDY9fz6oXsp6UNQwZqoRFh6BqooglAi4mN
	VDya7IjGV76xRPhW2uyFg8GM2qvAgrhC7kXa/2RhKthQTHURFldrH5AW3qhD8xNMceuotG3xCj1
	6MjJLAwH4zdzcIPcx/8f9DYk6ZiHEw2J1zUd6vtp3WrC+InQTZU04oCXLgHDgeKkVtzGyK1mX6y
	EmJkJq4VMFnX094yj+oh9kYiiYDs4HD3zy6b3DzOvPG25yATMojqT5EJO1EvvNFdW8WhjDEMDw=
	=
X-Received: by 2002:a05:600c:4506:b0:45b:8a0e:cda9 with SMTP id 5b1f17b1804b1-46fa9a8638dmr184764085e9.2.1760456000245;
        Tue, 14 Oct 2025 08:33:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhJpIXD7XQ5pJSvl2kMtYK5HLrtya1KimSbQX7gY+SFRx0KBjyrmvvoAE0I1/rLJ3ZdqjMkg==
X-Received: by 2002:a05:600c:4506:b0:45b:8a0e:cda9 with SMTP id 5b1f17b1804b1-46fa9a8638dmr184763725e9.2.1760455999749;
        Tue, 14 Oct 2025 08:33:19 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb32a84edsm132343605e9.4.2025.10.14.08.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 08:33:19 -0700 (PDT)
Message-ID: <e2c77ce4-c260-4d10-b9b6-93a507080e61@redhat.com>
Date: Tue, 14 Oct 2025 17:33:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
From: David Hildenbrand <david@redhat.com>
To: Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
 <d2e5b099-94bd-444d-9946-182807443539@linux.dev>
 <c44e198d-7d46-491e-adc1-86cc306c27db@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c44e198d-7d46-491e-adc1-86cc306c27db@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dd3dd4BDuO8Yppq_o6mSPRhTlLVQ2o4jHwQSZMbLEMA_1760456000
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 8kk9z4szsb1p1cwwu4ua4i3nmz1ncwee
X-Rspam-User: 
X-Rspamd-Queue-Id: A8EE54000B
X-HE-Tag: 1760456003-957308
X-HE-Meta: U2FsdGVkX18/mX1OOB0N4hHstrI0TkBTijjCAE/RzVHOLvmsDNkMOfML4nEmg3Lq/srEB/ZdvU/DrxfmaPJS3YPsj5hk8jK3Or0Hu9XecF5U40OpbUCvSs87Vt4FXgDp9KaCkvwxU65oZWPEQ/6pl9nYbo+wBu2u82Y0iHGftDllzXrOU1mka3cTX6TXRhdIfnqjW5v1D3oMOLuPMLH1jyF5aSWe/cZN/xYo3/kZeVb1KhmEsCSTyyhq8aREJr+fHPywD1DMjXfnAKYh1d94/VS9hEureOCsSxsf7TKe9uT8FLriqmHgwGQxb925qYVc+0tR3+a0zxPvAvykmE5PlZMhpxvj6gfNMqp8EPsK54yNtKrmyU3+WaAPwYGm1hrx/4Fw6TFMAiM+CMpmK27zHEUixL02wWMTbVZh6FQO8zWSmO76zrtwbx8CcQnuvfP/Rnsnu+oiggfRng3IgpVkFEqGrxBvc1T15DcPudldTBydhTkG0YjunsffDm10scv92jCbdCchGHybp0tVokWuu1quBG7lBvaJJOmOSa05Sz0FPuIf9CyRfDyVEb94aHHpy5Xw1BlU14Azb0jB29bh/SVWlhnetQPvJ8WYUP5owvjp1JL6hEY+QxVdHiD7vrryKRHL9ikQzgq9LN4RHA83Sjcf692D9jzY+fzZlKpu+UYHnSlSNLaBUqhjJoTqjqCN8uj3IcUDYoNdth0sMCPMVF8H+kR/hXgEdwjloJqEPtUPRUrNj/QWmqKKwoSe27IYTmBxDSyfLKsRbjACYugNljrJvbgJQ0Dj4w2JeUtdo80aftBaKaZb7X/LneZ+yRKjD617IGKwY+Z1mHYO1nceFC74d1dI0oEmxRLtqEnlU9QBzWmqmLRqYZrs+d5tlz4xwzamKcBPr+V1h6LBIYJreCUO0QjOf9ZsuGcmXcEURFRcsRL4m3debgEEsFS/2uGOztmmolmvYs7QSNj9WCT
 1pr7IcI7
 /nRWGZD3Lfdr9+BvnhB7t3RxjfEjljm5LR18zQ/HuhrPf01ujJd4oVArGJra/QvpcmSwuCn98bj9rMkCXzdgTOGYsWtGJwHNNWsgRapRT5ILW7BosvlGHD/Mre+crRxcZG0FNJiLHRJ5O0r/QR5K3C3yRVB80114FJ5huFEppIJmbEh5Odrag4xfeTzjLMWVI3jnNs52rqXuARsV/wfqONKEovsSTv6mzrosUD9xKDANgUsAV24OOILJTJXhgNa0uq8mjoPaYG5Ib+nU8BUs/cZr99eHZHzc61cQ+eU2vgDQwH2wzo+blXS54Nvfp5dRNWFvOIRqgRneWmqIT7AFbItK5oKtdYKYF2z8e36/I4GinX7S8ZmeJIRjC6EwT5iCRCHfRJ8kDEsIH3zM9OcZFR6xcUIlz1c8cFlTcnoDuSzkebej2CHG8ilOsrgJ2ewsX1Q6Eppx+xinrsZUg86q+rstXOsSG46PS0ZOx+UgJfeVMfA6x73opGe1jE1M2UzvRuYQvv3a5zWGrmiz0weOSm7sWxqrJYdrCc106Ss8AUnZOEV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 17:12, David Hildenbrand wrote:
> On 14.10.25 17:01, Lance Yang wrote:
>>
>>
>> On 2025/10/14 22:39, Lorenzo Stoakes wrote:
>>> On Tue, Oct 14, 2025 at 10:26:20PM +0800, Lance Yang wrote:
>>>>
>>>>
>>>> On 2025/10/14 19:08, Lorenzo Stoakes wrote:
>>>>> On Wed, Oct 08, 2025 at 11:26:57AM +0800, Lance Yang wrote:
>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>> index abe54f0043c7..bec3e268dc76 100644
>>>>>> --- a/mm/khugepaged.c
>>>>>> +++ b/mm/khugepaged.c
>>>>>> @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>>>>>      		if (!is_swap_pte(vmf.orig_pte))
>>>>>>      			continue;
>>>>>>
>>>>>> +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
>>>>>> +			result = SCAN_PTE_NON_PRESENT;
>>>>>> +			goto out;
>>>>>> +		}
>>>>>
>>>>> OK seems in line with what we were discussing before...
>>>>
>>>> Yep. That's the idea :)
>>>>
>>>>>
>>>>>> +
>>>>>>      		vmf.pte = pte;
>>>>>>      		vmf.ptl = ptl;
>>>>>>      		ret = do_swap_page(&vmf);
>>>>>> @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>>      	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>>>      	     _pte++, addr += PAGE_SIZE) {
>>>>>>      		pte_t pteval = ptep_get(_pte);
>>>>>> -		if (is_swap_pte(pteval)) {
>>>>>> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>>>> +			++none_or_zero;
>>>>>> +			if (!userfaultfd_armed(vma) &&
>>>>>> +			    (!cc->is_khugepaged ||
>>>>>> +			     none_or_zero <= khugepaged_max_ptes_none)) {
>>>>>> +				continue;
>>>>>> +			} else {
>>>>>> +				result = SCAN_EXCEED_NONE_PTE;
>>>>>> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>>>>> +				goto out_unmap;
>>>>>> +			}
>>>>>> +		} else if (!pte_present(pteval)) {
>>>>>> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
>>>>>
>>>>
>>>> Thanks for pointing that out!
>>>
>>> You've deleted what I've said here and also not indicated whether you'll do what
>>> I asked :)
>>>
>>> Please be clearer...
>>
>> Oh, I didn't delete your comment at all ... It's just below ...
>>
>>>
>>>>>>> Hm but can't this be pte_protnone() at this stage (or something
>> else)? And then <-- Here!
>>>>
>>>> Yeah. The funny thing is, a protnone pte cannot actually get here, IIUC.
>>>>
>>>> ```
>>>> static inline int pte_protnone(pte_t pte)
>>>> {
>>>> 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
>>>> 		== _PAGE_PROTNONE;
>>>> }
>>>>
>>>> static inline int pte_present(pte_t a)
>>>> {
>>>> 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
>>>> }
>>>> ```
>>>>
>>>> On x86, pte_present() returns true for a protnone pte. And I'd assume
>>>> other archs behave similarly ...
>>>
>>> This was one example, we may make changes in the future that result in entries
>>> that are non-present but also non-swap.
>>>
>>> I don't see the point in eliminating this check based on an implicit, open-coded
>>> assumption that this can never be the case, this is just asking for trouble.
>>>
>>>>
>>>>> we're just assuming pte_to_swp_entry() is operating on a swap entry when it in
>>>>> fact might not be?
>>>>>
>>>>> Couldn't we end up with false positives here?
>>>>
>>>> Emm, I think we're good here and the code is doing the right thing.
>>>
>>> I mean sorry but just - NO - to doing swap operations based on open-coded checks
>>> that you implicitly feel must imply a swap entry.
>>>
>>> This makes the code a lot more confusing, it opens us up to accidentally
>>> breaking things in future and has little to no benefit, I don't see why we're
>>> doing it.
>>>
>>> I don't think every little 'aha X must imply Y so just eliminate Z' idea need be
>>> implemented, this feels like a sort of 'mathematical reduction of code ignoring
>>> all other factors'.
>>
>> Understood. Changing !pte_present() to is_swap_pte() will resolve all your
>> concerns, right?
>>
>> ```
>> if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> [...]
>> } else if (is_swap_pte(pteval)) { <-- Here
>> 	if (non_swap_entry(pte_to_swp_entry(pteval))) {
>> 		[...]
>> 	}
>> [...]}
> 
> Can we please take a step back and make sure we are not starting to do
> stuff differently than elswehere in the kernel, please?
> 

For the sake of progress, I assume the compiler will optimize out the 
additional pte_none() stuff.

I absolutely, absolutely hate is_swap_pte(). To me, it makes the code 
more confusing that talking about something that is !present but also 
!none: there is something that is not an ordinary page table mapping.

The underlying problem is how we hacked in non-swap into swap (and 
that's exactly where it gets confusing). Well, which this series is all 
about.

So, I don't care in the end here.

-- 
Cheers

David / dhildenb


