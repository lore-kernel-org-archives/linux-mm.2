Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9850CEA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF2C6B008C; Thu,  9 Apr 2026 08:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70696B0096; Thu,  9 Apr 2026 08:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5ED16B0098; Thu,  9 Apr 2026 08:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A370A6B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:29:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BCED8C2EF
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:29:47 +0000 (UTC)
X-FDA: 84638948814.08.E3B6120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B991100005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:29:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qn4LlS61;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775737785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCjEhiPu7TqHek/rf08WhJOWg6qgLOSW97ax67VZ3Ws=;
	b=P4Cl50+e2Lu/gQTfg9C0YaKNEQ9F73OGkN2THVolVjMUFxkra+3ZWiMEYrNuvtVxAggLBx
	8db4il+RUXBjI0o76Px1Ixb3Ozby5S1O6E4h7DvReZLwbJoKqEz3VIuq1Sg5On6elzoKrB
	oDSqpGDck1N+vIT8YGmvn5bX+JV6WEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775737785; a=rsa-sha256;
	cv=none;
	b=WHew7o3RWO8JsBLczVKFc1pkmCqmfDcY5skpJ2FM3+DDd66NXN1gLhSIaeevy6UHwx0qQl
	6PUffq1jN2omfGcID9Exo7VXrcF4u846RKI9JFnvv1qDGWzSIUFIpjNkmwAj/mKAVzWbTX
	kDtRzu0D+PewGoIQNV0bAeACfz0306o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qn4LlS61;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45A2E4191D;
	Thu,  9 Apr 2026 12:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AACC4CEF7;
	Thu,  9 Apr 2026 12:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775737784;
	bh=o1pnMljy3NO/nviBZv7VCCVCA0U1jFakSHYePKGRrTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qn4LlS61va7HSew9APqWOk+ljAjB4T+WrPyHcr1pPv5Fu8i7v+r9N8X+tpVGOGvh8
	 5UqhPhFyISEJwa2k2FZEPVmfoDkmiEQYRPyNII9M/2fqLSD9mHdbcoZurS51N681r+
	 OVYK+/3jCRe/a3PO/QwbbqfCP8504dlfMFRwh7nG2d75jBPJhLPkuvfgfN+EciSgDw
	 R40td0DHyVJQS8Tvivul7L6AZM0ND/jpJK29loRRr0VsXtwo00TETFDZXGgAlTMIW/
	 sNSndBPpNq1R0oB6m/QrlBqtI9d0u0/KxiNRdK1DH3kS12DS34viFkOMCbWvX9hVJC
	 /gVUo7Mky5P8A==
Message-ID: <dcc3b56f-5d4c-4bb0-bfd8-49747df30f47@kernel.org>
Date: Thu, 9 Apr 2026 14:29:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
 <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
 <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
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
In-Reply-To: <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7B991100005
X-Stat-Signature: bt7ywjq9z4ex94yh66tp7e495tpub4d1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775737785-210605
X-HE-Meta: U2FsdGVkX193AnK3S+G+huyiQfqqfrrwPJdkWazy/rac86ycrtYZScSlyUeTsWoXGqqXIkBv9Gy/QGP5/Y4ocWf+yTMtv3vaHvTSM3gWc8pknTStPuhg81OG7VMBtzWsjhGRGF0+KP9X9hGBp99XwT43AF26jVBP8Gr8cAQbzniwoX5bNmAWNNMP4yFAoCkhGbclcyraD5xUTOm6i9o/eqbpdc259jrFUyFM5Fc1P9KqXqD/iMNvRxmGx0Tw+k3ygqrs25nF7W/Yv/a4NhquG20/YXiDAyKKGRS+HKHAm6tf3OTwTflL1NLzJ00HJPMLsPKWkPCkaEMUS/RM45O11aWGuibuIwW4dFgmGztE7nzlLr37sSwwnbHGkYtMPJ3UBRNNZTumEGNxfWROu9fqB6nNJxWiBVZVXsEJAHVr1GRgyC3VD7KJCByrW6P4LJEbWocEVuftPeomki8FVasZYtZpkM/7Smfw/pAeDyT5/KP2CdaGXSByo8AX+VhWRTW+rsKfNZhj09YOG/2wZ2XGs354xCFFe9DkxGEeJJFf9bhgwn1th9UHGh3tgo3GeOmPy1koGDWc0tRNvUDdzKnwwMmQvS1cnagl8HUljRnXywUCevM5KpRdZHmrcsZC8YTPI2Um+xsWCjMwKG3soVF1gbgqY/8Qq8URD/FhQnXZ+0miqjDY/zRt27r4ApxwR8VaKhoJOk/SXa4YmbSe2CFmFQuqMBV8YiumULPmA56AtsrIP+nbQWyDQwZTsXBOZzW0/j4XTp5Osyp7Nn/yBWXfc4TAC2Kwe/cAteBFfUcOFox9fdcGmIuRltPpYEXfLe4Uj4CpZW6WuoOnAlGZC6tRDfgV+TdJuzf2C7a+fX70DTHfvoZHMUHkkgt8YXJXqQHWB0CcmLkihq5fo9Z3bcJzuTJeKyawB1f2h4A2CKE+94SEhqnqFA8pRSA10tOneKkJZAcPIAyx/XXpJBQkH1L
 T2AkwzKZ
 otaHl1IkYSNTKJEl2GwO6xCrnVPs65vwBZSnduWE8Ugs20ZTMrcE3Mp1BN2ji0jVZbR+bUvHCtG+V55RQjo0Lrl4UiHQ/0kEy0mgyvUhCpqsz7qhjb6uObXhnTrTg06R+JOyTnedYGp+IRdsv+t8YquL2FGOQYjgs6fRl3XiBlBg2MtDvU4Z1wIgKxAaxoKLndoznbZ7ree5fdXt6RUoB76J/NDDgxpL6wbPq4h0yN7r3z9s+MuKdm+wz/TuAnaoaX71khRIFgsDMkJBeKBInA+dW3T4wgZXWDMWqo9nulCOKbiD+zwrK7+2+kak7pYVXrTOtM78ZM8Yaj9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 13:40, Muchun Song wrote:
> 
> 
>> On Apr 8, 2026, at 21:40, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 4/7/26 10:39, Muchun Song wrote:
>>> The sparse_buffer was originally introduced in commit 9bdac9142407
>>> ("sparsemem: Put mem map for one node together.") to allocate a
>>> contiguous block of memory for all memmaps of a NUMA node.
>>>
>>> However, the original commit message did not clearly state the actual
>>> benefits or the necessity of keeping all memmap areas strictly
>>> contiguous for a given node.
>>
>> We don't want the memmap to be scattered around, given that it is one of
>> the biggest allocations during boot.
>>
>> It's related to not turning too many memory blocks/sections
>> un-offlinable I think.
> 
> Hi David,
> 
> Got it.
> 
>>
>> I always imagined that memblock would still keep these allocations close
>> to each other. Can you verify if that is indeed true?
> 
> You raised a very interesting point about whether memblock keeps
> these allocations close to each other. I've done a thorough test
> on a 16GB VM by printing the actual physical allocations.
> 
> I enabled the existing debug logs in arch/x86/mm/init_64.c to
> trace the vmemmap_set_pmd allocations. Here is what really happens:
> 
> When using vmemmap_alloc_block without sparse_buffer, the
> memblock allocator allocates 2MB chunks. Because memblock
> allocates top-down by default, the physical allocations look
> like this:
> 
> [ffe6475cc0000000-ffe6475cc01fffff] PMD -> [ff3cb082bfc00000-ff3cb082bfdfffff] on node 0
> [ffe6475cc0200000-ffe6475cc03fffff] PMD -> [ff3cb082bfa00000-ff3cb082bfbfffff] on node 0
> [ffe6475cc0400000-ffe6475cc05fffff] PMD -> [ff3cb082bf800000-ff3cb082bf9fffff] on node 0
> [ffe6475cc0600000-ffe6475cc07fffff] PMD -> [ff3cb082bf600000-ff3cb082bf7fffff] on node 0
> [ffe6475cc0800000-ffe6475cc09fffff] PMD -> [ff3cb082bf400000-ff3cb082bf5fffff] on node 0
> [ffe6475cc0a00000-ffe6475cc0bfffff] PMD -> [ff3cb082bf200000-ff3cb082bf3fffff] on node 0
> [ffe6475cc0c00000-ffe6475cc0dfffff] PMD -> [ff3cb082bf000000-ff3cb082bf1fffff] on node 0
> [ffe6475cc0e00000-ffe6475cc0ffffff] PMD -> [ff3cb082bee00000-ff3cb082beffffff] on node 0
> [ffe6475cc1000000-ffe6475cc11fffff] PMD -> [ff3cb082bec00000-ff3cb082bedfffff] on node 0
> [ffe6475cc1200000-ffe6475cc13fffff] PMD -> [ff3cb082bea00000-ff3cb082bebfffff] on node 0
> [ffe6475cc1400000-ffe6475cc15fffff] PMD -> [ff3cb082be800000-ff3cb082be9fffff] on node 0
> [ffe6475cc1600000-ffe6475cc17fffff] PMD -> [ff3cb082be600000-ff3cb082be7fffff] on node 0
> [ffe6475cc1800000-ffe6475cc19fffff] PMD -> [ff3cb082be400000-ff3cb082be5fffff] on node 0
> [ffe6475cc1a00000-ffe6475cc1bfffff] PMD -> [ff3cb082be200000-ff3cb082be3fffff] on node 0
> [ffe6475cc1c00000-ffe6475cc1dfffff] PMD -> [ff3cb082be000000-ff3cb082be1fffff] on node 0
> [ffe6475cc1e00000-ffe6475cc1ffffff] PMD -> [ff3cb082bde00000-ff3cb082bdffffff] on node 0
> [ffe6475cc2000000-ffe6475cc21fffff] PMD -> [ff3cb082bdc00000-ff3cb082bddfffff] on node 0
> [ffe6475cc2200000-ffe6475cc23fffff] PMD -> [ff3cb082bda00000-ff3cb082bdbfffff] on node 0
> [ffe6475cc2400000-ffe6475cc25fffff] PMD -> [ff3cb082bd800000-ff3cb082bd9fffff] on node 0
> [ffe6475cc2600000-ffe6475cc27fffff] PMD -> [ff3cb082bd600000-ff3cb082bd7fffff] on node 0
> [ffe6475cc2800000-ffe6475cc29fffff] PMD -> [ff3cb082bd400000-ff3cb082bd5fffff] on node 0
> [ffe6475cc2a00000-ffe6475cc2bfffff] PMD -> [ff3cb082bd200000-ff3cb082bd3fffff] on node 0
> [ffe6475cc2c00000-ffe6475cc2dfffff] PMD -> [ff3cb082bd000000-ff3cb082bd1fffff] on node 0
> [ffe6475cc2e00000-ffe6475cc2ffffff] PMD -> [ff3cb082bce00000-ff3cb082bcffffff] on node 0
> [ffe6475cc4000000-ffe6475cc41fffff] PMD -> [ff3cb082bcc00000-ff3cb082bcdfffff] on node 0
> [ffe6475cc4200000-ffe6475cc43fffff] PMD -> [ff3cb082bca00000-ff3cb082bcbfffff] on node 0
> [ffe6475cc4400000-ffe6475cc45fffff] PMD -> [ff3cb082bc800000-ff3cb082bc9fffff] on node 0
> [ffe6475cc4600000-ffe6475cc47fffff] PMD -> [ff3cb082bc600000-ff3cb082bc7fffff] on node 0
> [ffe6475cc4800000-ffe6475cc49fffff] PMD -> [ff3cb082bc400000-ff3cb082bc5fffff] on node 0
> [ffe6475cc4a00000-ffe6475cc4bfffff] PMD -> [ff3cb082bc200000-ff3cb082bc3fffff] on node 0
> [ffe6475cc4c00000-ffe6475cc4dfffff] PMD -> [ff3cb082bc000000-ff3cb082bc1fffff] on node 0
> [ffe6475cc4e00000-ffe6475cc4ffffff] PMD -> [ff3cb082bbe00000-ff3cb082bbffffff] on node 0
> [ffe6475cc5000000-ffe6475cc51fffff] PMD -> [ff3cb083bfa00000-ff3cb083bfbfffff] on node 1
> [ffe6475cc5200000-ffe6475cc53fffff] PMD -> [ff3cb083bf800000-ff3cb083bf9fffff] on node 1
> [ffe6475cc5400000-ffe6475cc55fffff] PMD -> [ff3cb083bf600000-ff3cb083bf7fffff] on node 1
> [ffe6475cc5600000-ffe6475cc57fffff] PMD -> [ff3cb083bf400000-ff3cb083bf5fffff] on node 1
> [ffe6475cc5800000-ffe6475cc59fffff] PMD -> [ff3cb083bf200000-ff3cb083bf3fffff] on node 1
> [ffe6475cc5a00000-ffe6475cc5bfffff] PMD -> [ff3cb083bf000000-ff3cb083bf1fffff] on node 1
> [ffe6475cc5c00000-ffe6475cc5dfffff] PMD -> [ff3cb083b6e00000-ff3cb083b6ffffff] on node 1
> [ffe6475cc5e00000-ffe6475cc5ffffff] PMD -> [ff3cb083b6c00000-ff3cb083b6dfffff] on node 1
> [ffe6475cc6000000-ffe6475cc61fffff] PMD -> [ff3cb083b6a00000-ff3cb083b6bfffff] on node 1
> [ffe6475cc6200000-ffe6475cc63fffff] PMD -> [ff3cb083b6800000-ff3cb083b69fffff] on node 1
> [ffe6475cc6400000-ffe6475cc65fffff] PMD -> [ff3cb083b6600000-ff3cb083b67fffff] on node 1
> [ffe6475cc6600000-ffe6475cc67fffff] PMD -> [ff3cb083b6400000-ff3cb083b65fffff] on node 1
> [ffe6475cc6800000-ffe6475cc69fffff] PMD -> [ff3cb083b6200000-ff3cb083b63fffff] on node 1
> [ffe6475cc6a00000-ffe6475cc6bfffff] PMD -> [ff3cb083b6000000-ff3cb083b61fffff] on node 1
> [ffe6475cc6c00000-ffe6475cc6dfffff] PMD -> [ff3cb083b5e00000-ff3cb083b5ffffff] on node 1
> [ffe6475cc6e00000-ffe6475cc6ffffff] PMD -> [ff3cb083b5c00000-ff3cb083b5dfffff] on node 1
> [ffe6475cc7000000-ffe6475cc71fffff] PMD -> [ff3cb083b5a00000-ff3cb083b5bfffff] on node 1
> [ffe6475cc7200000-ffe6475cc73fffff] PMD -> [ff3cb083b5800000-ff3cb083b59fffff] on node 1
> [ffe6475cc7400000-ffe6475cc75fffff] PMD -> [ff3cb083b5600000-ff3cb083b57fffff] on node 1
> [ffe6475cc7600000-ffe6475cc77fffff] PMD -> [ff3cb083b5400000-ff3cb083b55fffff] on node 1
> [ffe6475cc7800000-ffe6475cc79fffff] PMD -> [ff3cb083b5200000-ff3cb083b53fffff] on node 1
> [ffe6475cc7a00000-ffe6475cc7bfffff] PMD -> [ff3cb083b5000000-ff3cb083b51fffff] on node 1
> [ffe6475cc7c00000-ffe6475cc7dfffff] PMD -> [ff3cb083b4e00000-ff3cb083b4ffffff] on node 1
> [ffe6475cc7e00000-ffe6475cc7ffffff] PMD -> [ff3cb083b4c00000-ff3cb083b4dfffff] on node 1
> [ffe6475cc8000000-ffe6475cc81fffff] PMD -> [ff3cb083b4a00000-ff3cb083b4bfffff] on node 1
> [ffe6475cc8200000-ffe6475cc83fffff] PMD -> [ff3cb083b4800000-ff3cb083b49fffff] on node 1
> [ffe6475cc8400000-ffe6475cc85fffff] PMD -> [ff3cb083b4600000-ff3cb083b47fffff] on node 1
> [ffe6475cc8600000-ffe6475cc87fffff] PMD -> [ff3cb083b4400000-ff3cb083b45fffff] on node 1
> [ffe6475cc8800000-ffe6475cc89fffff] PMD -> [ff3cb083b4200000-ff3cb083b43fffff] on node 1
> [ffe6475cc8a00000-ffe6475cc8bfffff] PMD -> [ff3cb083b4000000-ff3cb083b41fffff] on node 1
> [ffe6475cc8c00000-ffe6475cc8dfffff] PMD -> [ff3cb083b3e00000-ff3cb083b3ffffff] on node 1
> [ffe6475cc8e00000-ffe6475cc8ffffff] PMD -> [ff3cb083b3c00000-ff3cb083b3dfffff] on node 1
> 
> Notice that the physical chunks are strictly adjacent to each
> other, but in descending order!
> 
> So, they are NOT "scattered around" the whole node randomly.
> Instead, they are packed densely back-to-back in a single
> contiguous physical range (just mapped top-down in 2MB pieces).
> 
> Because they are packed tightly together within the same
> contiguous physical memory range, they will at most consume or
> pollute the exact same number of memory blocks as a single
> contiguous allocation (like sparse_buffer did). Therefore, this
> will NOT turn additional memory blocks/sections into an
> "un-offlinable" state.
> 
> It seems we can safely remove the sparse buffer preallocation
> mechanism, don't you think?

Yes, what I suspected. Is there a performance implication when doing
many individual memmap_alloc(), for example, on a larger system with
many sections?

-- 
Cheers,

David

