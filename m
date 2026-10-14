Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12ECBCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67796B008A; Wed, 14 Oct 2026 05:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18736B0092; Wed, 14 Oct 2026 05:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E766B0095; Wed, 14 Oct 2026 05:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 921EB6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:24:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F99C12048C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:24:30 +0000 (UTC)
X-FDA: 85320696300.10.C0821B0
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf30.hostedemail.com (Postfix) with ESMTP id D5D1A80005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:24:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QsAt5ZEc;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791969868;
	b=FK4STcXfnaHi1NeuJoQp4XoJR1gkwkkrMkEBeXmgQse6Y4Lqd3vPBZ6wu2dZs5qefbZ3nQ
	KR07qGz/uGnfhnHuCC+iSEFnxngHjfkJX7yrHaySnQi4H9KpK0bUj5EUeL5YDDXx1bm4s9
	5WiI+qChCrxVVJ2kJ3bkDti+Cf/jDPI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QsAt5ZEc;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791969868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVBZSWzhmTgsQbjaqm+RNdeGA3BriAh5gCRFbByzJ/o=;
	b=aXZd/64iYCyYQYsIMT/UNDXvIbbieQeefui60RH4UwlmcIczWXaBu/usJETGWbvWvXf/YE
	UOS9ZNs4TxAgPF8/xHppqGLur86XI5PYSw1g34G8Yk25sQZIAHZxBzpkowZ/M7UvDnUz4z
	Re+8xApSWGNyd4F92+4Zod2g+CLVrIE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9Rp6gok1+Kio/TSq1E9OFvpUWzUtlcEW1k6DFeMPFSc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791969866; v=1; x=1792574666;
 b=QsAt5ZEclRMMg12FhNOY82qAWJ43LLKUyGzqS4fUrOpY2hevdQaeubEMXxB/gT+X9a/DMywM
 ImjsyePcYO+M+dJNxL4/8ba7gQIOVXkPxbO15BPSuiMJ4vDSUkx8SSKT5S7XHUuMmGnLe/V8kZJ
 eydlowQxz6sJpXiH1mKOqIkY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f4836833ee7be581;
	Wed, 14 Oct 2026 09:24:25 +0000
X-Mizu-Trace-ID: f4836833ee7be581
X-Migadu-Flow: FLOW_OUT
Message-ID: <cb63eec0-4c39-49cb-89c7-15639f51a710@linux.dev>
Date: Wed, 14 Oct 2026 17:24:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Zhao Gongyi <zhaogongyi@bytedance.com>
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
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a6feb3f1-c08d-4d54-a38b-55fafcfec7b8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qr8h4hyt9qbazazwpitmpsxew1h1cesu
X-Rspamd-Queue-Id: D5D1A80005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791969867-419106
X-HE-Meta: U2FsdGVkX18hSTgxYhvrRAeL/fm50E/j+Zby9pzY8N21pHLrtk97JiZkIkdSMZWblqJTZGhKJtEYzxsy5eFFf41QFg+cEok0689ShvMINw7OZk9p+G/yzPXHPOxTDnZnp/MoRj8WVSamN9umjLSldBzJ+6VpgpiiuQwj3pbFcmuBebltkWpOXi216FxvoJRIQSNXi32Cz2mRgdvVjrSRemNA/4yLcLM03mG1oJSSKGzV9jK0cTmdEFIzKAuHuojyc5pMh8Ywtd/4XMP7PBdwA/AKnnBybYCAYKCir3gro3sZuTSef/h3Cv0mM1Fsk6dByM9SAWrqLa1DFNz/H48z/PEKUf2CCiYOWmWPk05Jwey0ctjZrm7zltk1RRn8FReNBpxc3IpLlee5dqQl8hnBYFq+dAj1dDkk3j3//3KavfmdzsnEFWhyNWr1fVME/AE4YNtc7dm9WTBnkzIOb4EN/cpcHuPdduOnnL8MuuTGE4hV6cn9KGaWwodYQz0gW1wjBI0wjwLZto45cjb+k+UIqk/yHUdQqFjZljZDAUs3VfPyLqAB21bwi3BUp1q7PoR78ZuLIIYGvhMgdlRUWNLL7EsBA7Iu6n+itg4E4VPMHEGyjwqbMCtwR7ChA7Bslv2WlNa7msiDf3AhSAb7qWMbpw+KIO4PmzwfH6FmGpmpt+rkeejP/JVAy1Vgq9NaMhMc5beqFuFPb2FINCIoFq4hTr3fPGgNJjqT9FEtf2AzPDeDu1QJTgxAI/rQhTkWv9dcah3diK5S1XTUBAoX2I4wvtpe/ZUV5rGaLcVItY3aiZsxbx+SRLiwJR4eqdlTO9Z3GHWv07KHYlBdNNBx1x5IURMuQKRB4xRDBFq/7o0J2+TOH7ms/nQs1pYOUb9s7C6EJI8K2oEyF0Iiu7+z5ZGBJH9u2/5gQ8xDsd4VyEC9P8w1Jpp+Aybitp3Qivl+j004wFhWdkLxF1D+zwl3hXb
 oyrOlCA0
 7GfpVd+PoCuBtsuD3XG97FO4XPgjluF02YqdyJQrKhHL68Gx2VioYbq2pzk3rh4kz82l51b0raJONlbl0T5yQVd+LvPQ5xEV+nB2RHnde/EY7mJ/Tm//xkrzPG/r3QyidyYB8hAHDN6TJdkhziCUnOkTAQsKkeWOGODVrkWVHV/zJ0QDcZfR9L5euCKg4CgF3ueonk4n+9eGvYQGE7Ds/selO2iU3+BAywuHkFW/jSw9s+gNppCXIxvPamrsekhXhnFrhH8nhs3ILkMDK8PLs1BDsHY8YsrOZhOoM682cSPPbb8dUL/fuXqtYBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/14 16:38, Baolin Wang wrote:
> 
> 
> On 10/14/26 2:46 PM, Lance Yang wrote:
>>
>>
>> On 2026/10/14 14:31, Zhao Gongyi wrote:
>>> On 10/13/26 11:39 PM, Lance Yang wrote:
>>>>>
>>>>> +    /*
>>>>> +     * Keep the producer-side invariant documented in pgtable.h 
>>>>> true even
>>>>> +     * if a direct caller passes an invalid descriptor with 
>>>>> PTE_CONT set.
>>>>> +     */
>>>>> +    if (!pte_valid(pte))
>>>>> +        return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
>>>>
>>>> set_ptes() is the only in-tree caller, and it already clears PTE_CONT
>>>> before we get here ... no? Why not fold !pte_valid(pte) into the
>>>> !mm_is_user(mm) check below and return __set_ptes() directly?
>>>>
>>>>     if (!mm_is_user(mm) || !pte_valid(pte))
>>>>         return __set_ptes(mm, addr, ptep, pte, nr);
>>>>
>>>> If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
>>>> rather add a VM_WARN_ON() to catch that. Silently clearing the bit 
>>>> would
>>>> hide a caller bug :)
>>>>
>>>
>>> Hi Lance,
>>>
>>> Thanks for taking a look.
>>
>> Cheers!
>>
>>> Yes, you are right. The public set_ptes() wrapper already strips 
>>> PTE_CONT
>>> before calling contpte_set_ptes(), so the pte_mknoncont() in the invalid
>>> path is unnecessary for the current in-tree path.
>>>
>>> The issue I was trying to avoid is not that the incoming pte already has
>>> PTE_CONT set, but that contpte_set_ptes() rebuilds the pte from pfn/prot
>>> and then adds PTE_CONT again based on alignment. For an invalid 
>>> descriptor,
>>> that transparent contiguous encoding should be skipped entirely.
>>>
>>> So your suggested shape makes sense to me. I will change this to return
>>> through __set_ptes() directly for invalid descriptors, and add a warning
>>> for any unexpected direct caller that passes an invalid PTE with 
>>> PTE_CONT
>>> set, e.g.:
>>>
>>>     if (!mm_is_user(mm) || !pte_valid(pte)) {
>>>         VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
> 
> mprotect() can trigger the warning here when setting PAGE_NONE for a 
> batch of PTEs?

Nope. set_ptes() clears PTE_CONT before calling contpte_set_ptes().
PAGE_NONE makes !pte_valid(pte) true, but pte_cont(pte) is false,
so the warning won't fire :)

>>>         return __set_ptes(mm, addr, ptep, pte, nr);
> 
> I am trying to convince myself that the 'nr' passed in is always 
> CONT_PTE_SIZE aligned, but it seems OK.

Still nope :)

IIRC, any partially covered contpte block should already be unfolded
by the time we get here ...

We're just installing PTEs without PTE_CONT into cleared entries,
so nr doesn't need to be aligned to CONT_PTES.

Cheers, Lance

