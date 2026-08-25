Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A842C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA236B0092; Tue, 25 Aug 2026 12:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B9F6B0095; Tue, 25 Aug 2026 12:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452E66B0096; Tue, 25 Aug 2026 12:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A57F6B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:47:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83C9BC010D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:47:00 +0000 (UTC)
X-FDA: 85140371400.15.E4E35A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B63DC1C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:46:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1QvjT4C;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787676418;
	b=raRJKzmAvVt5PsjlFrhsJr6USIHs9Lk2+Ie9sPzxYO2BttpZhZ3x95cmYscMXsfJcoimzO
	koK9r+LLMsCl9q9HwlIDUcSwQTT1hON2nTM/6/+c4/r4dgZ3jM1BtRFYXpIopbOg6ChZF8
	e5fos3dSj8jExskVf6nyK4d3SYu043Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1QvjT4C;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787676418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fljagmBbQwC/iRaXRhNF4fLMKhBQZFdPhsqh8nbR+XQ=;
	b=hbkIFgZCTEvlGLa1Sqv3Zyto+wda9/aOvNPgd/7kmT3EhvnkBGNRTqRdeNMRAH0yZu+NaT
	reqsJwVWPMW5d1/222XP34DLT3igeAob01zghxHZlxDoTTuaTweBtegjkCsmJAZNqppgnf
	qU0onMVkWNrHaM0S68ao3GHFEcBTTfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DFFC40729;
	Tue, 25 Aug 2026 16:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F61F1F00A3A;
	Tue, 25 Aug 2026 16:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787676417;
	bh=fljagmBbQwC/iRaXRhNF4fLMKhBQZFdPhsqh8nbR+XQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A1QvjT4C2hH4HwlAkKlxYcWyc7NJSnyh31obmC1DkPVWqDcK89dcrWToUUBfqLiHc
	 pGrP7OqyMSNK3b2H6WZQ8bOeI/ahyqXC7GDoF12FYzhyNoVEtHdSHNkH0E0Grm0Ves
	 GHJDw/X/P914CN6y57NDnIm8ZICMmFbkfFhFAechratc0JrKodyCz7wivd7p1YdcWT
	 zca8nPTVuDvm8iNXaOIpVnRWwMWY1OjAJ8EP1sTn+50sjK5P1ghesUTpLPgvdDCdI1
	 D1zUrj/QuN/cG8qkFZ/Hv9Ki23QBuXPhDduH9rs88/TlA9R1JXHOMItDD9E4YaAuv/
	 2jYMB3UX+FQCQ==
Message-ID: <86823e2b-f739-4ebe-b92f-a35b9dcfa0c7@kernel.org>
Date: Tue, 25 Aug 2026 18:46:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] arm64/mm: add set_direct_map_ro_noflush()
To: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, usama.arif@linux.dev, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-3-xueyuan.chen21@gmail.com>
 <c81ff923-800c-4ef4-b6e4-ec9f5eb1671f@kernel.org>
 <ao3GXvT2ltf89_rG@willie-the-truck>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <ao3GXvT2ltf89_rG@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B63DC1C0003
X-Stat-Signature: 6krjjzrz3p9s5xgmstqyaxyhtwkwqoc7
X-HE-Tag: 1787676418-62824
X-HE-Meta: U2FsdGVkX1+n2NpMIOy1bB2GrPY7n4owA+wGonIeG5BWhit4LUhAN2eJR3wFYUCm+HEZSpSc3JLm4eF1gYuozyRzWq+GxcIWA+C0tbRjWPeJiqZRoQAxAs3vIqPqT+4CDQZf0EtHXb2lypcr5TivctLnM9hRBwWP14oiHVRBUoHiBHVbAHgrpSZngMq/MB6nextrp9WAAhT3YFCHQfo17Tr833eGZRYJ+nZ6xS+vjIkbUHi+OKWILq+V3wBL/+NnFYTwD9pF1q6He1WLDiZVNdcU6pWCLn8R4Fw9r4swnssHX5zskSZGyG+5QJ7nxgCE3XR0Jgf34yc997Le0MUrEfnN6tnX6qEW8APS1S2BoLdYuRZi6SS4mGaJhQXpXR+VCogjMHRTcXU7ychmjEbCyOtEyve6T+3SkN9gbjfeQN3G7Av8B1Dr3bcda8s7JeX/0vDNxj4t33U4IaYlDq+fs7bm6elJnJ1SSfwjJk4Hjv2OK+ETB25feW4zJYxxERDEQxnNSLEOKqMXjLw+lEFZW32F79DdoX3HAamIBqbJecwnoq7rqeV5C8cL9odkmDX0SAEkPkSLcAu0IKP+Skuiemsinp9uTBvqI9asftgou64hIdpBD+88fK+WCmb3JvDu11TvSL0pf4uzftdD/4tVqhHmPNHJ0pEfB5sXnKLhtABlhgwN3sHMzN16JicPwO4ttP4kFVYRyNM4wW336hDFCiN+V7l6xu/HisFZxf1Jt9D90TrgwPpoLgL0/y3SYHRAvuh0zo2UmwSCwj5wBbKNPTQD2zCFTO+HwP3dVsRYVG028jYShY+GqwIIyQAF9U2X2S9hnfeReSQnF4SUA4O+dIhJmTwRlc8qZhHxawqdEROaxjYeLMWonmh5b3M0spxcr6uR+xeJyqIPaaxzXvFjNvUzvHZgSWfM9pJNIUvIsxRY8RUiNu+nS9f/xtsqmwSGL5bk8jrDaZEoxbHnlqQ
 x5E73mnt
 NNzCOePeD9chbItq9X1Yj5JwWbZTr5gHkv+DeqPgA3S2yrFZnzXoNYvd3QfcqPPELSink+sKSP506FlhCYApiwJu1ixcbyIpnlRj3jthRv52dMRqBLwhj6zzMVfUDEMMiI83BHq+2GUM1M8FjCP+n+5IzUrIfkJEOmxu1HEqZnnLfpHWl017phbap3S6UJwn42n0z5YdjULYbCpTfGe9NUSPQcYu6DW/YszFQxI6aNI2RlSggGNCCCDFjN11thSflrPuCB+KKmZcaTazZ9QUVWPbKQYYO+3JlgSGD9ZX250R8UN+0fiZAhK1vsbPiuROv1rn50pxovDuZlPTVLuT52aECGG2qKdgOc0asKyMxGxmxM81WuHnQD+xxKGn6JCfLsb6z18BYDhqhExMd0TNewkAYyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 18:44, Will Deacon wrote:
> On Tue, Aug 25, 2026 at 05:52:20PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/30/26 11:06, Xueyuan Chen wrote:
>>> Implement set_direct_map_ro_noflush() for arm64 with update_range_prot() on
>>> the linear map, setting PTE_RDONLY and clearing PTE_WRITE. Keep the
>>> existing can_set_direct_map() guard and leave TLB invalidation to the
>>> caller.
>>>
>>> Co-developed-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>>> ---
>>>  arch/arm64/include/asm/set_memory.h |  2 ++
>>>  arch/arm64/mm/pageattr.c            | 10 ++++++++++
>>>  2 files changed, 12 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
>>> index 90f61b17275e..7083260303c3 100644
>>> --- a/arch/arm64/include/asm/set_memory.h
>>> +++ b/arch/arm64/include/asm/set_memory.h
>>> @@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
>>>  int set_direct_map_invalid_noflush(struct page *page);
>>>  int set_direct_map_default_noflush(struct page *page);
>>>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
>>> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
>>> +#define set_direct_map_ro_noflush set_direct_map_ro_noflush
>>>  bool kernel_page_present(struct page *page);
>>>  
>>>  int set_memory_encrypted(unsigned long addr, int numpages);
>>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>>> index ce035e1b4eaf..c51236b61651 100644
>>> --- a/arch/arm64/mm/pageattr.c
>>> +++ b/arch/arm64/mm/pageattr.c
>>> @@ -365,6 +365,16 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>>>  	return set_memory_valid(addr, nr, valid);
>>>  }
>>>  
>>> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
>>> +{
>>> +	if (!can_set_direct_map())
>>> +		return 0;
>>> +
>>> +	return update_range_prot((unsigned long)addr, PAGE_SIZE * nr_pages,
>>> +				 __pgprot(PTE_RDONLY),
>>> +				 __pgprot(PTE_WRITE));
>>> +}
>>> +
>>>  #ifdef CONFIG_DEBUG_PAGEALLOC
>>>  /*
>>>   * This is - apart from the return value - doing the same
>>
>> We'll need an ACK from arm64 maintaines. To me this looks good.
> 
> I generally dislike deferring critical things like TLB invalidation to
> the caller, so it would be good to see an example of a caller that really
> needs that. The caller in patch 1 unconditionally  calls
> flush_tlb_kernel_range() immediately after calling
> set_direct_map_ro_noflush().
> 
> In fact, that means we have a pointless invalidation if
> !can_set_direct_map(). See exhibit A :)

Ack. I recall that the patch set originally didn't do any flushes, but we really
have to flush even though we are early during boot.

So agreed, the interface should just flush internally.

-- 
Cheers,

David

