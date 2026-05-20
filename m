Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A275CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9315D6B0088; Wed, 20 May 2026 17:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAB76B008A; Wed, 20 May 2026 17:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3D66B008C; Wed, 20 May 2026 17:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 666656B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:22:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0CC211602D4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:22:53 +0000 (UTC)
X-FDA: 84789073026.25.E4983C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3AC5014000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:22:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5yhYWvB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779312171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZD8qPPFqgaVsJrT+bNhoJDKlvxEOAlYooRCBoZWKDeg=;
	b=20zj3wIa4HcaB6qtFVL/Qa8MpGHK4Wdph6utne5aW7N5F9OUJNGY4eVXIfIZFl0SmN450N
	zRsy2b1Ysn3Nal02SNG7a9Za/fBygMfbmQKte2UsKIeOhcLBJ6jQ2SngqnRtwGb/h5DBFp
	yDrMKkb+3pDsvR9Z9mqv4+qQlNW6ZVI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5yhYWvB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779312171; a=rsa-sha256;
	cv=none;
	b=VCrhGDrKdgu9BWdJpMMlJXwfLrkN83SRux6vUqrKXdqnmpVt5j/tnpCKcvlV3lh7z1uDLj
	vdRM1Rj0eSuZS8Y50eeKtrSwHaaQSezfEwYLsJyWfItw+JHzQx5Dob+shGYeRavk2XTgTd
	S1HfnNLtIdg8Q5gU4XP9duHrdkdHht0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EEDD43A22;
	Wed, 20 May 2026 21:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DFD1F000E9;
	Wed, 20 May 2026 21:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779312170;
	bh=ZD8qPPFqgaVsJrT+bNhoJDKlvxEOAlYooRCBoZWKDeg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S5yhYWvBFRRzb7ajya43HMybpM6sLW0lPBQvPDR2wRsGnCzAsRKRuTyzVUhdCHS/m
	 hXcSTjHoDGmfM05SPuXedm3o/TZXUnAsNvOndmOJdzLlTJAHoYuk/3UfgELKFcN6Pg
	 vx+ThFNX3B1KnL2tBIsHjGZNwt7Gmn+CildY2rgO9eEuEMr7YS8FR8tEjHtY8htC6g
	 UlzPdcM08Xww1Ekb4vltqOkE9lVLpR6QWjdei0XFf54taKesaUUqu+xliTluF0NZw7
	 CMyrZ6NaetCNwkoCITv8jwuuQPQSTcgmutsq7EdubZMntf92fEkFYC7vfPwLlnbBuG
	 M3tf5YcnSuX8A==
Message-ID: <029df55b-5542-4f8a-bf13-7649bd9454cd@kernel.org>
Date: Wed, 20 May 2026 23:22:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
 Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
 <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
 <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org>
 <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
 <agyZxmHoueGwBAQg@slm.duckdns.org>
 <CAADnVQJt0p7hSn2G074QZRh2LEdthy3RKYJ9j3w5yeJ-e8UQLw@mail.gmail.com>
 <fb889bfc-af0e-491e-a69f-38c2abf88d22@kernel.org>
 <CAADnVQ+j4o0Xy+cykSdx9txSqCouy0yHFaA09qTJp3OVF3VaRA@mail.gmail.com>
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
In-Reply-To: <CAADnVQ+j4o0Xy+cykSdx9txSqCouy0yHFaA09qTJp3OVF3VaRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a1h5m3p5aiahzasikjjzwf7ocmgpkxrt
X-Rspamd-Queue-Id: 3AC5014000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779312171-961100
X-HE-Meta: U2FsdGVkX1/83iUHREZTta5mlps10xy1wzKzTqdqvcYcci8v3G8LPvwKdCK0GyWAF54YoAoXYBw2FJKb+KrqoMRZS7d3HK5JlYVOEKcfCHewnH+CS5fYWvwSkTRh0GbOdltRnEBxcIzaYK6Szv9StdaCx0bpeDRWGSxdB4/3gfykk1qR+/AjoJVQN2r0O7j9+YA8OQ7Lbcob6g0n5zW5SuxCAfn3IveK25+rVbR2CuekOwZfMW9yG+3rbD5mCN+lAlHF9ozBJdZgvP7ZR9kb3mLV1pP9CLmMy5vMsR/CFxcWl1oqdxIe1o9pbEohOqYM9Jv6dg8Bt6NOU3arM3HUqydEd4Le0kJ7QLQLLJEw+aEviUHw2YmRU8tri8F6za0gOV8v9S4hcgQ8E1fQrE+1dx2GJzal6FJltnWxSmb7fugjucCUm8cpPrqW5e7Vx9bWE4Ytato5WAUaAo6dF8PIU0jcHfF2d25LqgfRmM8KijFGBvgqYdQZCTXdKhapCcvqH4fNsllDCv6BCjvJImZqqh4PfjgxqHTS/mlnouxECf6YNOs3XIVAKGB9wv7zttrJ8Lho4/9IQOoqCXav8LVmhASanDEdcf1WOiCSchO3qP/6LPBqiAvgPZIuno7LXfjTbScBLRREIiPNqBHaHW+1GesM9yUl1lPvVKzgNtuA16NonTvMhX6b4bO3f4PpdnDkQ346i2D6ocu+DpUwkw8sLQfSpiaBhwZFT8NQ9BryZJ+7h0iegKwAIAKxHDOeGbn6NzBoYyigJXSNzt/odN/KoB0gLmwRQWDiWZND/bUTCnfoN5imTny+M+9cmqmFEdaF3qsJg24UxGi5gQvqSZxgeMdzcBoL4JP6XgFYQum4XpFWdEPw4y/0zMi2lM/ZupeXiSQS7RlbUs5dn0a08ik1s1qf0veRwM+60ZybRSLTd5giBMX8xb5MARionXA2IdSZEr7n7NkD9O0iJ6KVC4K
 pwKFqRqw
 qHn9Cmm1ZaghZLqbP0pKxKWaOt5TebZJPEEkoO6zQM2cwV5RD6qGH3iKDdeiccKwj1QkeHj4/E0lfYyYrX2BrZVHug++bljrm86S76dTd8k41Xf2ZjrADPSJhsxiPcKUq2GnphgCA2NUk4QLTDpRWbvGHwzs9xIdON4M45xIJB/l+hUbtO0RT9WfwI7s+4EGNxTAq8MukJ3op7fTTUqZUHdJ5wrQhFbGRC8dIs+ZoxleDRa2KGTwPQSm+LoF7thnRR6jzmrUCxVW4pcblgaUGsGAhedTJ4X9sqMn9tkxVEKa8x7I0RbS4QN5wN6UepUc6fAxJMtE2EoGBmz7tzVT275kohGd5Rbd5vcMh3ruJHyQhRma1TNvV2KWCqZI2AAnaGmTi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> At least in apply_range_clear_cb() one could similarly switch to
>> ptep_try_install() to at least have both these paths handle races in a
>> reasonable way. (having to handle when ptep_try_install() is not really implemented)
> 
> You mean to use ptep_get_and_clear() ?
> Makes sense to me.
Yes, using also an atomic to replace it.

I recall that ptep_get_and_clear() might not be atomic, but I guess it is on the
architectures where ptep_try_install() is currently implemented.

> 
>> Anyhow, the documentation of ptep_try_install() must clearly spell out that this
>> must be used very carefully, and only in special kernel page tables, never user
>> page tables. There are likely other scenarios we should document (caller must
>> prevent concurrent page table teardown somehow, and must be prepared to handle
>> races if other code is not using atomics).
>>
>> To highlight that, we should likely consider adding a "kernel" in the name, like
>> "ptep_try_install_kernel()".
>>
>> I am also not sure if "install" is the right terminology and whether it should
>> instead be "ptep_try_set()". (set_pte_at is the non-atomic interface right now)
> 
> I suggested using the ptep_try_set() name too :)
> 
>> Further note that last time I talked to Linus about arch helpers, he preferred
>>
>> #define ptep_try_install ptep_try_install
>>
>> over __HAVE_ARCH_PTEP_TRY_INSTALL
> 
> ok.
> I guess __HAVE_ARCH_PTEP_GET_AND_CLEAR is legacy ?

Yeah ... and we have plenty of legacy around :)

-- 
Cheers,

David

