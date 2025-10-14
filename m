Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A611CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C456B280003; Tue, 14 Oct 2025 11:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D268E010A; Tue, 14 Oct 2025 11:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BD4280003; Tue, 14 Oct 2025 11:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3098E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:12:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FB2611B128
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:12:26 +0000 (UTC)
X-FDA: 83997061092.04.4316480
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE4CEA0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:12:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HzHOOQpW;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760454744; a=rsa-sha256;
	cv=none;
	b=op4+PfxBBDq1oW+brZf//8wtGcfXDRZxpUBGHMN0hodiRAsJMnhDmXTz9Z8Sw0rvIFC3zt
	34duH/BFIlzgYUZLGK/11renE78+y6jfknfq/LpP9U6UQ4ItKDDnlRwtqCutXyJBXZ8VgY
	2migBXFrATJ8IgR13yJtJqn6w0KA/jU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HzHOOQpW;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760454744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6THLwI9NiseSOzgYZXiKFiqlemIivWD9QQsnFlvKVQ=;
	b=wQe0VVyg8yjyPQ1AG/7xI6Hfb0d7kgRY71THFiTZozMoWOpXIzCDz0zYd//Yr/V3SFxR1Y
	E64ajRWftMqdZ2cH9aoVT0mMMrfuYHnzCFNeDqJgZl+BJJR6DmJUga9DdhttU5QBijcLD2
	Bit2KQ9wCbg+jdjCewgaR7GMjnE9HoE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760454743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q6THLwI9NiseSOzgYZXiKFiqlemIivWD9QQsnFlvKVQ=;
	b=HzHOOQpWjYI2Dk2dFLkFN0hmGqFeo4tzrvPmDF6OMWuuyflZB91Sf0WXMe+dMfapbFVrxt
	Zoh1FpVdI2ByQl5Hjlzr69ve3CBQzkFUg7eGNYbQFMGfzF1Z7U/ZzaZ1didIIFAJRa/EaV
	MWXABZ1qsc2rPd1P7iz3w6ZPRLu/8VQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-KKRStpHxPy6rMgip-xSj2w-1; Tue, 14 Oct 2025 11:12:22 -0400
X-MC-Unique: KKRStpHxPy6rMgip-xSj2w-1
X-Mimecast-MFC-AGG-ID: KKRStpHxPy6rMgip-xSj2w_1760454741
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee10a24246so4731562f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454741; x=1761059541;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q6THLwI9NiseSOzgYZXiKFiqlemIivWD9QQsnFlvKVQ=;
        b=TtKOqgzwKI5E9OgI69SHMFPyR08jS2CYSVBcKSj3RIxIk3eCNh0HxMhXxOs1LHhMsy
         YgYrcXEeFV0T6KvmWoUWKwhpyRA4Xxwk5tbaWe7nbFYmxcN3GEIxi197rBwsCCMf/qVV
         XXGkeBDfS9S2S000ZyNe7gsfiiChGvNaOPaptVvHqw3Y1WYPCY4dWaOgnNLuSZAxiSfz
         0Ec+VLRtu5psT5VcppmlJvSxVYhe1DyL9MxujOmvIoNzzpEVennnR1i/IfKkGdrWQwP3
         lduQIeX17Wu1DPY2V3IYNERMF5EXI/+5CAW/28JLkU0T8BzXcrxi6oxhi/3AFp9YT5Nl
         g5LA==
X-Forwarded-Encrypted: i=1; AJvYcCVA6YvuNCi/SdlEebYdh922wGT5t8f5gQjZ2eHHY2B0s3vHsV7Py8xUGPsc4aGcj2KXNdiBW2Oxiw==@kvack.org
X-Gm-Message-State: AOJu0Yzy6q7pjGq2yScp1mHZv2wul0w5cXmkMBWCk9TjZlKJxHRtmquk
	nLW6DrocA5J1d38E0tmNvX5/Ms+uAwhKe5QjKNQBpPAQ89nPOcgUnXOxWSmXbfL576tTJcM7Oyi
	wmGndsXHIgSavCFJils7BnW4bXP1ggYhdiaU4RcYD3BsnAQIuQpRE
X-Gm-Gg: ASbGnctxDOzySQdt62eBtWcPpVLivzoMi3R5GWoQRhoOmAFwlIxLAKvtouhJB0YbkcJ
	vrqjGx2ORm33biUB97LvkVsUonF8P7cST5EMnuLPWtdDmnvYlOuOqyeiv2pE7F1TYiWnpiGVUCk
	hIHG1AkzlraGEPAXWDUF/DesxjZL/LS2doNQxh4xa1O2nJjm6EqMjItZWB6mjEXDZjCa9/Cz5S0
	hjDkXY8RM8wSZdZl8XUQzsdCe8ZCehk7cDFtQ6/7whA4OejmKibN5qaMI+e5cMbHshk0dxlvk9A
	GDhZQaMQlcbbI2aPIWg6b+bmpEUgrYLOBrfyMS4VD56rF3uko748gX+XvjvwTA1swbR0d+PTCA=
	=
X-Received: by 2002:a05:6000:1887:b0:3ff:f55b:274a with SMTP id ffacd0b85a97d-4266e8dd6dcmr15926330f8f.43.1760454740909;
        Tue, 14 Oct 2025 08:12:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEq+W1M3EcCNfbgeJOxtxwFkDVr4f4yjSQjLxfgd4obliSe1n1z2a4LOUNi5Ap8U3KdJU978A==
X-Received: by 2002:a05:6000:1887:b0:3ff:f55b:274a with SMTP id ffacd0b85a97d-4266e8dd6dcmr15926308f8f.43.1760454740415;
        Tue, 14 Oct 2025 08:12:20 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce583424sm23814996f8f.21.2025.10.14.08.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 08:12:19 -0700 (PDT)
Message-ID: <c44e198d-7d46-491e-adc1-86cc306c27db@redhat.com>
Date: Tue, 14 Oct 2025 17:12:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d2e5b099-94bd-444d-9946-182807443539@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Os99KxfwjNVLLA6WX43Shd3sHxqYJenludObM-DMDTY_1760454741
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dgeb98789a7jurfznmmr1u8k34gt8c19
X-Rspamd-Queue-Id: EE4CEA0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760454743-210633
X-HE-Meta: U2FsdGVkX1+gh5lyh1XID2+zeJ5aH9ll/tczfMBDfVopD6yhBwoDWVnIf9dPRUZozbnbT/APyQSt2AaDWvmxKAbJQmi/YMKNialEqr1a8Ly1Nv+Z7aIOLexiDDPktPdJuVqFkQOTXw7/2HJhtpEQoIwnA/F+m1+XT65FVlDEX+TpnOjAaIzLFtZ3gHBtGEkvLQ80+7N+oDZW0D2Nfa2egGg6T/0AXWAMaRdfINUVBFnstQV0Xs+aySaAkYfWrpx/GGfcZ/4zsBOYD+vGEhkzeJ2KmO1/HNQqoh9QF8kY3TnfXSjSzKBMBXXJnvU/fQEiLipWuQ2NGQGW5xcigTLYTk5qS5SSaLC99x4WbV+pxeWF81CthzYVPRQxycU4C00VWxQZrFj6YKUEnB60wlhYOCNnv0zQ4h+mmBFFTb7RWcbcOjB8y/2piy+7ZCSPw6LmcyF7057wVBL/m5/kFmzC6ivh87YSt5ITfdq9OCa89PfaPZSmWGUtyPoG4cpM87+F5CrM0OJg629uwCeQuZKrLO0t6AEF6oYEsG7uCNh9VLSbtSalCChGpcrVet6Nvy5E59pBTx1HxSSnJ0Su/aceQbzQen0fGirocZs/bZiN635CZdJuZjYy1OR/vcOa/hfq9+tTBdgFM1dnrd9rwYRLWlARXLtqjMDOvwGvdt7VY5VyZyh+tYEhMHOXgNmIamFrwzNkVzWNdUCkKsO8FvfTHDXMA86vIjg2+H1zxrpccEAzoUO/EretsXRPH9629lOqrvWzwRYZYDV2LO7y0MWx4J0e++7h8Jm9+KnSHmq21IfPaqtDCV4MyRfTw3FJEc1TVRnzNIlBizzhqbDKEUAgEIXJnkBAJ/gEM8+aDwSHeEVQDuoNx0XCqEN8sYzDMajERE3YjTNZLoOfj8O26Yoh9Nap63THfolSU6mRWO545lL/oxCPIbgCOJNKeyHJrZUc1TOXicoO5+Y9TdtGYNz
 Tf97/Jxj
 GX71TIm/Xo8uX8zP3dP1PfSQFPeVX2JCxweTfuAObQD4yvZB4hFF6lcRKMC4sHYpGV+zF2wmotUnEu6/Kf3t6FUXpdMmso5dmLCyFqLt8YaH7zKJtMl3ARazoFwQt4zTxKNlXl/AIiXbn63m7I75Ik2bv40gZ85K8SfUxHSPHpVJJWMl2aClpQ7/3dJ+ZF0QeF1GpqAvbr78yaSopnUYIZsCgB6G59XcByYKbZnCcyAd/5Aj89HDkxCwrM049zqvLn/J1XGf/kgiKptiAcbYuyHgf4xPqSfE+vBHU0x3k1C+GRbBddta0tzYjpU89115eyd29jpj6YBf4mIXs7hnt78dDMlAEOBl5idNWcD3GqKoadzbMW3bi+remhxRp+Z4sVJeLwWukEFEisTHzmJUVcXeW22Cq1HjB/Hzjgxj42P0E6L3jBY6S2xltiaJhCv3E8OZRRFfDFeHonkCjg6XcUbiO5V5qFN+IWi+mpSO9tLmrj5YaatK5DHo8wQKC1izr5D60+iY/sf5sc9Jqs4XnA5X6epBaQ4hg6G78NKGMFrkX/+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 17:01, Lance Yang wrote:
> 
> 
> On 2025/10/14 22:39, Lorenzo Stoakes wrote:
>> On Tue, Oct 14, 2025 at 10:26:20PM +0800, Lance Yang wrote:
>>>
>>>
>>> On 2025/10/14 19:08, Lorenzo Stoakes wrote:
>>>> On Wed, Oct 08, 2025 at 11:26:57AM +0800, Lance Yang wrote:
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index abe54f0043c7..bec3e268dc76 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>>>>     		if (!is_swap_pte(vmf.orig_pte))
>>>>>     			continue;
>>>>>
>>>>> +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
>>>>> +			result = SCAN_PTE_NON_PRESENT;
>>>>> +			goto out;
>>>>> +		}
>>>>
>>>> OK seems in line with what we were discussing before...
>>>
>>> Yep. That's the idea :)
>>>
>>>>
>>>>> +
>>>>>     		vmf.pte = pte;
>>>>>     		vmf.ptl = ptl;
>>>>>     		ret = do_swap_page(&vmf);
>>>>> @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>     	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>>     	     _pte++, addr += PAGE_SIZE) {
>>>>>     		pte_t pteval = ptep_get(_pte);
>>>>> -		if (is_swap_pte(pteval)) {
>>>>> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>>> +			++none_or_zero;
>>>>> +			if (!userfaultfd_armed(vma) &&
>>>>> +			    (!cc->is_khugepaged ||
>>>>> +			     none_or_zero <= khugepaged_max_ptes_none)) {
>>>>> +				continue;
>>>>> +			} else {
>>>>> +				result = SCAN_EXCEED_NONE_PTE;
>>>>> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>>>> +				goto out_unmap;
>>>>> +			}
>>>>> +		} else if (!pte_present(pteval)) {
>>>>> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
>>>>
>>>
>>> Thanks for pointing that out!
>>
>> You've deleted what I've said here and also not indicated whether you'll do what
>> I asked :)
>>
>> Please be clearer...
> 
> Oh, I didn't delete your comment at all ... It's just below ...
> 
>>
>>>>>> Hm but can't this be pte_protnone() at this stage (or something
> else)? And then <-- Here!
>>>
>>> Yeah. The funny thing is, a protnone pte cannot actually get here, IIUC.
>>>
>>> ```
>>> static inline int pte_protnone(pte_t pte)
>>> {
>>> 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
>>> 		== _PAGE_PROTNONE;
>>> }
>>>
>>> static inline int pte_present(pte_t a)
>>> {
>>> 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
>>> }
>>> ```
>>>
>>> On x86, pte_present() returns true for a protnone pte. And I'd assume
>>> other archs behave similarly ...
>>
>> This was one example, we may make changes in the future that result in entries
>> that are non-present but also non-swap.
>>
>> I don't see the point in eliminating this check based on an implicit, open-coded
>> assumption that this can never be the case, this is just asking for trouble.
>>
>>>
>>>> we're just assuming pte_to_swp_entry() is operating on a swap entry when it in
>>>> fact might not be?
>>>>
>>>> Couldn't we end up with false positives here?
>>>
>>> Emm, I think we're good here and the code is doing the right thing.
>>
>> I mean sorry but just - NO - to doing swap operations based on open-coded checks
>> that you implicitly feel must imply a swap entry.
>>
>> This makes the code a lot more confusing, it opens us up to accidentally
>> breaking things in future and has little to no benefit, I don't see why we're
>> doing it.
>>
>> I don't think every little 'aha X must imply Y so just eliminate Z' idea need be
>> implemented, this feels like a sort of 'mathematical reduction of code ignoring
>> all other factors'.
> 
> Understood. Changing !pte_present() to is_swap_pte() will resolve all your
> concerns, right?
> 
> ```
> if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> [...]
> } else if (is_swap_pte(pteval)) { <-- Here
> 	if (non_swap_entry(pte_to_swp_entry(pteval))) {
> 		[...]
> 	}
> [...]}

Can we please take a step back and make sure we are not starting to do 
stuff differently than elswehere in the kernel, please?

-- 
Cheers

David / dhildenb


