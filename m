Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A84CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9646B01F8; Mon, 19 Oct 2026 08:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A666B01F9; Mon, 19 Oct 2026 08:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BE06B01FA; Mon, 19 Oct 2026 08:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318926B01F8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:18:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3A4F1404BD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:18:54 +0000 (UTC)
X-FDA: 85339279788.14.86C4BC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9701A000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:18:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h6xAxbdm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3u1HT8y1funuQIDNMJr/wgEzzPt99e6m6N2aOvfKG08=;
	b=xUTvImI/RgpbDr+ndABNiSnjMZI53Eifg2/Fw0xey9sqLph271OfKdj3got31dkcekyTBN
	I6fJUHXLk87oStBZf6RGDQZtaXSyqO8qwJ8+HJko1dZM7D4LLjXvjmyPCg7e5Old3GwQ4x
	UJXE5lY2Z9m6Ol/vbX627jPbQeRQSgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792412332;
	b=sPF/+T0zlVvyEPoQRbajAnrFNCfczyoSUgpjb0j2efCtg37ukaOv69e+0v7UOj0Me+mGWN
	vdsxHgGpvvigJkUipHNynx1IgqHFurwA//AX6FI66qDxqUYlMjkepUODXE0yw1uFXJYGnn
	n04pVImhQi0U5efJN5ECUTpb6ccGRfY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h6xAxbdm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACDF143302;
	Mon, 19 Oct 2026 12:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D680A1F000C5;
	Mon, 19 Oct 2026 12:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792412331;
	bh=3u1HT8y1funuQIDNMJr/wgEzzPt99e6m6N2aOvfKG08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h6xAxbdmmRscN8KquCBh3c6cUyJOHdsi8Scc3e+32LcZ05UCJIk2rlprgoWJs+2m7
	 0bbmfCu5AuKSybaZ3pZIZNfRwqMOMm+pfFnLgQ5fhPk/SMq7iKYjSH0ozmDGbVEbEC
	 3Jc6qBcykfLGMYyQtIITtGNZRD1LB5w0ozsLXW/TAYlDQpFo984i6TsNwmwYo9khM5
	 Xd19hB3d3tevBat6VxnYCj4kXV8+r/jWVpRzk5311pcb7U7EJXXYkwyuRpAZpgeXpj
	 uYEzNQj2Au+AhzmpWu9N6g6dLdV3K3nybdiJXsp/Bivh19oRFo3Lnlh4xYgbvz+LQX
	 ihR6T1abdhYRA==
Message-ID: <1eff2f1a-b7bc-4541-82f0-9836d0a5db5c@kernel.org>
Date: Mon, 19 Oct 2026 14:18:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>, Qi Zheng <qi.zheng@linux.dev>,
 osalvador@suse.de, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
 <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com>
 <BEADD50D-94AA-4B05-B9AD-136E37247FDD@linux.dev>
 <988249c7-abf0-4f4f-9386-27e835a4d2de@gmail.com>
 <EE02C2AF-E4BD-4854-B235-928842456253@linux.dev>
 <1385f5a1-b842-45e6-8986-fec4123037f1@gmail.com>
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
In-Reply-To: <1385f5a1-b842-45e6-8986-fec4123037f1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9701A000C
X-Stat-Signature: po8gth9stajrih4s6gh1bkmpakrm4rxq
X-Rspam-User: 
X-HE-Tag: 1792412332-952010
X-HE-Meta: U2FsdGVkX18TsTLzrvNqr9wbrxLUmeaOGu2MCYPhxDehI/x3Zc5FuwV//16KI7bk96NGWiRv/UOBxZGtCu0NwqUddCb4+1Kj6b9G2hXOblv7hPGm5GLvkAd1C2glW/iuT/E3iEugkzbHn2XOAWcPG5u9UVlToQS7IE7QmMhYzQtmCMGIm7PGhNdPTDAtrYjv43/ZDNBxPEYRLb9wa+avjDOT2EKOjjTzWz9s2LFVN6DnNXja6wJQDKrIO4CX/zQ06aZL4w9fvhjPRgq3+JALBnhjPh5VODrVh+gclgrbmpP7xD/Rvf0ycsrvC6yxMsLgqCyEV3anEKm8uvO6lbtfdy/JkH9eSVrNmw8DKpl/wZhHXHZr91vJ4yYkoJ8pTcpDOWBCmQPkM1nwTYZbm7TpAnD9hETqy8DREeem1tYZLtENrYwyxyPgHSmn/SIi5iZQRJ5l1FIxjtQi31VAqEVJChTKyBaEonukDrMTgdrXvrAI1hi4QWpbAIfft+SMgB0B1BkASqgYnXPlY5g15YG3lAaV7vxxY9gWLjqZ7ZmssnPdiNT13QzYLuAqFiMoURR2su1HebYL2w86GDcbIKeWaXdnRc4OFC6lnxpQ0LiBYJEjxgeDuvHvw7VD+9Tnj3VCJkXKrzr8otRJUjzCQn0gI2ouXZWXHb4JxsGa4OplwEMZHxAsjK5VZJYWZv2a2XY2zy2B0aN0YNrNYI7RV8onQuOip3bZutoblvGHoVYQyYsKj4dpUg+CgnLBF8+quW06k7Ds7IdVXL9ipH4THAE6huF/tgS65MjJotuuF65FslDHlydJAAjFMf8FNP3ZSuJuMsnxdkAC7GsZ/qnQLV7ubi2j/0AmaCPZgY+mbMj04oqVK7VT1+KBKx0f73VtD888qM6Sz+CPGFGWjpJ03MT6bm84sdOnhJhQ/OOa4wdMcHsSnUN9hQwicOziEoC4dhxBGL1wx1LsT8yfKVEBVQj
 MnC52/Sk
 038iFNBAxyoJ+YzFoukO+Tf2ffUjrH92KgMfgbBMhN9T3khVj2S00rvVz2Z7jLxogZ6Sf1hUia30cLoEoTIBMaBPDQZkBch9GXRmWr7eGbrFmyQzLsx9hkW6LY2ZbC4UWi7rXpNCOYPubUTdrWCkmKh6TuHvJ/erFe+Az8aFNh6qqKBPQn6mWYB+W+4uP9Srq5JghA8q6j6WD/Y4g3GfBY5FQbPn0LcbbuepYaf0gQFBD0CWGQVY4cilrUKIyHkCIf6+2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/19/26 11:17, Jose A. Perez de Azpillaga wrote:
> On 10/19/26 10:43 AM, Muchun Song wrote:
>>
>>
>>>
>>>
>>> wouldn't a shared pool still be sized and aligned for 1G? then the 2M
>>> headroom stays a multiple of 1G and the 1G-aligned reservation can still
>>> fail, which is what the series is trying to avoid.
>>
>> If we decide to use a shared pool, I think the current alignment strategy
>> should be adapted as well, it should be changed to align with the minimal
>> acquirement, like 2M.
>>
>> For example, if a user reserves 1G+2M through hugetlb_cma, then the memory
>> reserved by the pool is also 1G+2M, except that the starting address needs
>> to be aligned to the largest gigantic page (1G). Therefore, this pool is
>> suitable for both 1GB and 2MB allocation. The only problem I see with a
>> shared pool is that it may not support mixed-use scenarios very well.
>>
>> What do you think?
> 
> makes sense to me. existing hugetlb_cma= users with WM pages would get
> mixed use without asking for it though.

Yeah, my intuition tells me that having 1 allocation size per CMA area might be
cleaner.

Assume you allocate 512 2 MiB hugetlb folios. You'd think that you would then be
able to allocate 1 GiB hugetlb folio less. But that's not guaranteed, as CMA
might just fallback to other areas fairly easily.

If someone wants to convert from 1 GiB to 512 x 2MiB, I think the demotion
interface allows for that.

-- 
Cheers,

David

