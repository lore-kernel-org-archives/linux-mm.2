Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04CB6606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7q/Cux+
Received: by kanga.kvack.org (Postfix)
	id 2E2016B05B1; Sat, 21 Nov 2026 07:39:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292606B05B2; Sat, 21 Nov 2026 07:39:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183B56B05B3; Sat, 21 Nov 2026 07:39:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E685A6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:39:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7ECBD40448
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:39:40 +0000 (UTC)
X-FDA: 85459082520.11.785AB45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 99C5E20002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:39:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A7q/Cux+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795264778;
	b=E80nCWExJjfcMM86IpojmsitoGag9jVjJ2DK3M6PxhTTnx+cIs1pr2Y/s0HoaLLxTZQuWE
	KpyW1+s9t8jhpkirfHoYXIR0t5bx1dG4qBy+J2ivCwjMNhbk5iebGDtfZhCK5HGKEzGX4m
	nKBvokMC7ZcOvwOnnh8HOWrUyGs7EXE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795264778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kRaZlBYwQKaGUWsSpXvjXWu3lCWTflVYkINEhdc9Mo=;
	b=Q51LAvWCeVvKKeOfZSSE2mBEFgDyeh2G6CMuipuG9qz75Eif5Ax0d2/Y2bEsE7QeExVBBc
	rCCJcrvxOdtvHWxrQ8KbBVvPZP2sWELoTonNi7LkLTm8Gf6ID25xligjKP+BSLtz+9vvVl
	+rNC0XlkAbjOEVGx/rJQ+GtoYsEnTb4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A7q/Cux+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD05C4061D;
	Sat, 21 Nov 2026 12:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8D01F000C6;
	Sat, 21 Nov 2026 12:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795264777;
	bh=7kRaZlBYwQKaGUWsSpXvjXWu3lCWTflVYkINEhdc9Mo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A7q/Cux+9C9ZMCksUHX1QSLLT/swgOvr8Pw0Ap3u7eb2qdoixd9E7mr3aJaWtnQsZ
	 0Bmvw9DwzF08JgOoVrk35M2qQLXK5pN3VhhKYIopvEfHHaN2qq4cIRY+6HDL+m1zHj
	 M4pq1PrralIPB6BIIeBXsktubuebNv1uivvFUy7iiZCq1okQeCgQPPfNimybWldepB
	 lEMOVFMaOj4qFeTJMAz0+E+xM73JSdxe50LWhOZpATp9djgCirluirc3nqaYNmKzCK
	 B+Vn1k9LZEpXcf6DW4+76nUr1saZIQVAzkQHf32C9J4Dzvp3UD4J6s2WH5FODkbphN
	 6y9KoP5HubEnA==
Message-ID: <bb3b0f93-f86c-41d8-80a6-2e7691147434@kernel.org>
Date: Sat, 21 Nov 2026 13:39:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] [v3] mm/mempolicy: fix copy_nodes_to_user() for odd
 inputs
To: Arnd Bergmann <arnd@kernel.org>, Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
Cc: larips <larips950@gmail.com>, stable@vger.kernel.org,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20261120185248.823415-1-arnd@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261120185248.823415-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cf6535pzch7skb9syu5bno14xa3ris1b
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 99C5E20002
X-HE-Tag: 1795264778-919668
X-HE-Meta: U2FsdGVkX18wrVjukJkeQJFvJNzrbdf54icPg3KQ1Ri/NKiVaOpeEF8Ks7kvS/El2ZGC6UH3bRH9lly58vYYXETWFMmKSn8L8ScONYxVxEDH998TvwUTV9NItbxW33ei88QfiExxjJYQwkDJgW/B4DoxTFYDJLG9JricH+APFJQl7n1aFdbcX56VZtT7YZ7RqCj7H1549UllbfuBOzd6zJOt8SM3gQYw9Aac/ILAmqBXA7qFZv8PoOCrGrSioazzlXDwOJ+2v+a9RrHiH2pc4buzoh0ejWGCBGdW9lCokCv2pytYRG6Ptaslb8ghff9B0bne5lHPqPoGhpS6T8U9C2d0JV4ujNQO/snTjfeekFRvWX3QCnsi40LWRsYA9DfJjHCee/T28fdOMlmAAi3h8/7k6OfpoAPQZD4g1GMVB8Bfi+sELz8W7e9v3VbKvAJ3cHSFUGiNGDZTg+GUHM1wHWKiZV6PoBJ72HBlcW0h/QhmtHxnRRZP1qRyjJlD3CiMw+kT0bBxl4OQAkXXWRSgVe14EX4erKiHi5I23BDy+098FyuT5PhI3lHS1fo1/LivF3gqdsTFta4yOJfS5LeBDVcYgnCEGYqv5ZPox7kEKRq2LwoIH4X6DcmpZSPTbWKsNX8lX02tdfCw7cXXGy3QO0TH2OkatAds4DkYm2ST/7rlx1V+VUY0utwSUxqjKM9St0qvB7L/dUyXfCmVt+iMhjtio0n7/KvjID1lovb/hbDGqpfEo9qad2CBh7F3qXG8Fidg9IBmv3kV+5qBVFESpR45CGvStX76d7hm0+oy5WUqmq4+P9jPCIbgzQxAArIdqPYUxSh5IE4XxQyboeDJPutq+Ni9YMm8jbSS4rHIjl/Oon5/SnH6+hYg6eTm3UFrzTUTZ40PoJCDpSzsllK4/+H2+2uA7QwpdoPlJ7WpMLckzCA/PyVHY8JpDkf8xePXt3mIaGG7uCR1x2bhWxo
 Jde97UZc
 I77SfftAuWMQX1MQhQKw32i865GlUf01f124+LCuNgmU/1ZCcQnlvODRfB3dqubCQ6knXS2GNywF2XVjvdLGHLmnB3i/PZTISSYdJxctpDl8Tdrx9pL8i4vlTvdsbR9U68o0y2t3fGhDTqCuTcqznyT3GKNPY3wGembDGsS9HNefaL7UptVKEqBuMGrHbcEQIpZ4Rfga/KHkAzVBo0y2DPWLzKvalrap66I+9ftbBGsmrzg0t6rTxuigLF3m5wO8HmvgYkFUdMq3j97tzgv0b/q3sRomRaupVE14JxqyQacLrimntuYOdsijhDTzzPHuY1x0Ay1ev4mcTnY5H8dO4Sh9JedcODzrQJvkddvys1Cuh4Mov0LRviULjXpPgwFwI286Iq81ixysf+BQ65JTCfBeLVLtkZbmyClnsfa8xkaY/5hCNpSjGcsgtqtaK4MpWwBfYmnG6s1QDx0sVunz3PoxSsW+EPouRPK8L0Qnsp1/KS7YaxqYg63uj86+qafdI4cBx0stk1p2LqTE20/zAXDNbQG5cqFLnwVDTIaEaR2WtG1FEjthl61MegGvxAPUGAj1XyUQgfIoyonk3V7gOY+ak6lyjVP9QdqqmJiNRrVG42QF7P/e5Grw8BNj6UdM1jsibrR/MqqVTG+LWzWXsiaU7K8ESbJ6diaX5mx6+umspDEMcYbQ4A7fA1S9LQR0eObZzkpOQvKYcPqznYVZI9bd/9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 19:52, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> copy_nodes_to_user() is broken for compat userspace in three
> distinct ways:

"Three" but below you list two. So I assume this should be "two" ?

> 
>  - Passing a power-of-two size plus 1 as most normal userspace
>    does can end up calling compat_put_bitmap() with the wrong
>    size, copying an extra 32-bit word from the stack into
>    userspace and overflowing both arrays as compat_put_bitmap()
>    expects the actual number of bits, not the number plus 1.
> 
>  - Asking for an odd number of 32-bit words rounds up the
>    userspace buffer size full 64-bit words, leading to
>    an out-of-bounds access in userspace.
> 
> Fix the calculation of 'copy' to be based on the userspace
> word size and use this to for calculating the final number

s/to for/for/

> of bits to copy as well.
> 

You might also want to link to Gregory's test case.

> Reported-by: larips <larips950@gmail.com>
> Reported-by: Gregory Price (Meta) <gourry@gourry.net>
> Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
> Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.net/

Should this be a Closes: for Gregory's report?

> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v3: don't introduce a bug that skip setting a 32-bit word to zero
>     where needed.
> v2: as Lorenzo pointed out, the off-by-one mistake is part of the ABI
>     and cannot change, we just have to use it consistently.
> ---

I can fix the description up when applying.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

