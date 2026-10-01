Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E845CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351F86B0095; Thu,  1 Oct 2026 07:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A706B0096; Thu,  1 Oct 2026 07:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219846B0098; Thu,  1 Oct 2026 07:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F34126B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:36:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71CD4A6CBA
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:36:40 +0000 (UTC)
X-FDA: 85273854960.02.231F882
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C90AC140007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:36:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXBFgjFK;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xm4wvdZWya38Tv5HPQOs01QtbugiGek4xDtMzVs3F8w=;
	b=YA64g2acBn9Z9TudKPwW58dFMBgVjJ7naI7v3unIRQSd1KjBVMxGhWfh/WveTrT5lExJUh
	bAgK2Fpg2T0TvZTrUvobCDO/TM7r8+YSdi+zc1cuDYslyohNxQFEyzR9OSOggf1Mxgt1Pq
	LbVzS7b2QiwBaqCTEB2/aEdkuLWS12k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXBFgjFK;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854598;
	b=A2Tc4bpkAKuhf/rfRlGPuaRkeRg3PEkZBYgh4SbqFu7hZrrOnRIik6MnurT1ZhY9zOqifM
	Lwtt7jbUESGF/z3GKRv8IDqyFJojoOGUGZaS8VjtbLT+aJyBOTRVqAsf0/uJYg1uexqwpy
	JkZk6DIgfVgT9ZjtaXPeNIV9bDqF2kg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59DBE601E4;
	Thu,  1 Oct 2026 11:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204A81F000FF;
	Thu,  1 Oct 2026 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854598;
	bh=Xm4wvdZWya38Tv5HPQOs01QtbugiGek4xDtMzVs3F8w=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=mXBFgjFKwBNERzVdoZjaNomeWpe3e8lQdbYE0ZfCu5nbH/GH5tEuNHS+dfHO3QrMK
	 HaZuDubT41hg2PppQgdI3UbIcyvLh/DTUtdTvTqgVj3fvR/EZXwYiHppC+2WzbNlG9
	 TtQcx5HbOcisqysMYBL9T5wxIMwRNr5KUruOb7hdn3Hn+DAMBpVpRjjzj4jCgcQ9/u
	 IuJ9nzw+s61u5LY7WWsKlZbCUQHYKyMLav1uZKFJvV1QXDcYXnDHdsEV2cei8YFWv9
	 LtJjuWuW5NFFdNYedScxnyvlri8/xtBBRdiICnaL5MMCFKblAlvJ8IoNNRRVVS/LMb
	 WSNmnGNHDkRjg==
Message-ID: <86dabeec-c40c-43c0-adab-b95fb7825ddc@kernel.org>
Date: Thu, 1 Oct 2026 13:36:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] maccess: Batch TCO handling in kernel nofault loops
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)"
 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)"
 <bpf@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
 <20260824160523.3907021-7-usama.anjum@arm.com>
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
In-Reply-To: <20260824160523.3907021-7-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C90AC140007
X-Rspam-User: 
X-Stat-Signature: 4cg9ynrw5ap19j7ifzi85kwtzispph69
X-HE-Tag: 1790854598-914829
X-HE-Meta: U2FsdGVkX1/UWc1/Qt2ayQpZxcrC7m0NhRqZmh2Bg9YROq9Lu3JG5sx+RyFFUHmug+Dc60lKqkaTxzws5sNdb8r2yuPodGwRI66kxyg3+GhrDla4rgroVGbFDonn6TcFQ1eMcRl9Im+7EJpAjcTkU/SRqisYhUICGGsGGU3SN6uXFk2uZPfGNeU0ptbhANDOh72oZsJXNXhtmTUQooUfyFQ2ie2rPjb9p5cwjGUg1XHGYdZqm5jIUUHy5HaGO9KUpvsj8Nxizutrp0gTOGVfHwyX6u8j6cXxJq6yxHx4L2VKoLTF8rD8wMgAc992Kxmf6sE1fJgkEd5vxNxxI4cMQNCianBRqdQce58vDL6hcUQ/x4qK2rOyBymdc0cILqe2VywyQssF3gilUOiKysBVb5/kgWfymgOnccNSAjU1kbg3s/yuGmnc1xzbIXFZZaqrIu+TtYLBvoyZ0KpP8F5GzHXBRROQn9x4ALirnHhvoTEM5qzlXCi7bcM0Sf9QfjtKZs+yjvgXCd9Hos4T7B2RFVr34puDqyFgMLpvMSdR6dNYHREAwFXK4cJJTr46OW55mH3Yv1fdvzKA2Ii1mJ2dMCsaGBcqk80tTB3CYAKQfpc2SNKSoNj4+ppog3+VSqHN74TKKibglP91UHatutcIJzfotDyGPdwWIFXLKE/iiReYSVamqQwCp2EVvsrzLYUqiZ1bwaUblHeNh5u7sXLrGrAhdeVYpebZEgrDbjmBUNvG05cUDb0M81W4EKippUGRHTHvYLTbEvEDSrbo0nDDuY5XdFju/2WCFLYA58Nhy8+j/QGTjsPRS37h0VFnq6Q1KEL2r027hKN8XA9qS5zhyD9hhPbGJKNAUyLiqhtVrVd/iF7k+FfOuYop3sCtz8hXVzB66rOyzK7wNDFXOk2cZlEwrwfSCyiCWAR2GdNpzcFRg1tde9YHCRIDXJAYr8D/K+VYZcqEVpYn5A3k6Xf
 azZeSZzY
 xPaK+yU64Mmkr2vxqVE5vGycb/vYbzfSVk1gYHFcgoqpOiWmg6QqNkipPTMrmGG6sax+6v/MFFdYHxDMST+gccpxKb+4vjh3g4Ky6KcKxcrfTL0qM/USmLDVtz1VRKqwUSbHubHD5we7N1v1KFGjWxa6jUMvm78BCU5K3QiAOejNfQ8jadQSWgK1ADtlLvQRLZyGZ5ysSJj1uDjTtmXiBVHLCIFQnkTM3aSUIHLClS/WTw7y46S+r6/NIjAzAShilczdnSqf/aIwJ5HYQGpvTXX1UfSl83s2jGLKFeukMRcSo9M6lhyh7IzODzb2EYEUUdwtf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 18:04, Muhammad Usama Anjum wrote:
> With Hardware Tag-Based KASAN in asynchronous or asymmetric mode, every
> arm64 kernel nofault access sets and clears PSTATE.TCO. Copy and string
> loops repeat that pair even though tag checking can stay disabled for the
> whole operation.
> 
> Cover each non-empty operation with one bare nofault region and use bare
> accessors in the loop. Leaving the region restores TCO before page faults
> are enabled again, including after an access fault. Existing empty-work
> checks ensure that every new region performs at least one access.
> 
> The number of dynamic MSR TCO executions therefore changes as follows:
> 
>     Work                         Before    After
>     N nofault accesses          2N        2
>     4 KiB nofault copy          1,024     2
>     N-byte strncpy              2N        2
> 
> The 4 KiB case assumes 512 64-bit accesses. These figures come from the
> control flow rather than a runtime measurement, so the time saved depends
> on the CPU and workload. Generic fallbacks leave other architectures
> unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

[...]

>  Efault:
> @@ -96,11 +100,13 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
>  		return -ERANGE;
>  
>  	scoped_guard(pagefault) {
> -		do {
> -			__get_kernel_nofault(dst, src, u8, Efault);
> -			dst++;
> -			src++;
> -		} while (dst[-1] && src - unsafe_addr < count);
> +		scoped_guard(__kernel_nofault_bare) {
> +			do {
> +				__get_kernel_nofault_bare(dst, src, u8, Efault);
> +				dst++;
> +				src++;
> +			} while (dst[-1] && src - unsafe_addr < count);
> +		}

Reading the same thing multiple times, why can't we have a new guard that wraps
both these things?

-- 
Cheers,

David

