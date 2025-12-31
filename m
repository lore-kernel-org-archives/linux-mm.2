Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48319EE57D1
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 02:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798556B0088; Tue, 30 Dec 2025 21:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BB46B0089; Tue, 30 Dec 2025 21:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6522C6B008A; Tue, 30 Dec 2025 21:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 501656B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:29:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C4FB13AD34
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:29:45 +0000 (UTC)
X-FDA: 84278185530.05.2FADFE1
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E10A1C000A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:29:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWjmBNlf;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767148184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37nD/3cQoIBI0/8IexFOw2YpceIM7p2wvl3IFIN7jQc=;
	b=UAahzGD0yMwKhMS021nQR884weLn1YqtZYHGvMauVd1PsFWwEesB1sAyXFjnt+pTtsZARW
	4HWFro2d6vOK2xCsk3l4cKaHA7ii9i3fjEjw5DDQi5BikhM4pSSY0f/2NTKvk6a0CatAk0
	KJ5AmoXzM2D7okIs+61CBCPqHIHbID8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWjmBNlf;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767148184; a=rsa-sha256;
	cv=none;
	b=de6bKgKRR+LvO6fVenq7gUF+UJ++7dVNXkJvfPgWdqln1mHwwTn9L902Vfn8mwJUB5p1On
	EER20wN8UnaujzLf2izEONjVe7Gv5Bmrnrg1YCzhw+4GlmfKo/ckGAN8bZY77kZ53t7ENV
	CTJVoD7OQlwOOyWepZJ/mAkouJtqpIY=
Message-ID: <af13561e-c512-4ab3-af5f-3b2057ac6667@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767148180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=37nD/3cQoIBI0/8IexFOw2YpceIM7p2wvl3IFIN7jQc=;
	b=XWjmBNlfSH4f7yYWlEW51gqh/6yRLbDw2YvyaNBHRcNpxz64Ud8N5126J65U7ERVSnQQfr
	59jIGP68fKaJXi4HB2xgjLejyEflrzDJT8yqvo2Xzz5i73aE1om/wwQUGbnV2tYXPzjyTx
	xbZc/lV026OlxMR2SGFTkWLyaXCHkQo=
Date: Wed, 31 Dec 2025 10:29:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] mm/tlb: allow architectures to skip redundant TLB
 sync IPIs
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <20251229145245.85452-2-lance.yang@linux.dev>
 <725b85bf-ff5e-45d6-991e-d92598779f98@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <725b85bf-ff5e-45d6-991e-d92598779f98@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E10A1C000A
X-Stat-Signature: c7quj74eeitg3sgrhjbu59xdif3kfazb
X-Rspam-User: 
X-HE-Tag: 1767148183-632176
X-HE-Meta: U2FsdGVkX1/MwsanGLPNGXt+R31bdq8lCqtN9KAZ7XYk4enxlBYfuLcbARpqbJyO1vVtNjFZXvizVP+I7RPUhiu8EYDx4GrGo6y9nJazsoXf0iF7QYdj3Q8TAHQ1XKpOjR1yDUvZgg+BPQ0PoidAbWX1+R2PjR3GdZyXDYzRcxB2pso1tCyEEzrZA+LXYU/lIsubY8q8W+85IfNhbyMqUzzLrGKLWX6uZn44sNB+Qv5jWikPJRobYbnMyq2MbZUOuZOt4yWBkBOuOrq7GcAFmFZ/T0mkFWIEaEc5Rl0qndV15N4sXmaAL4Jp0Nv79LPT5vsS0crXCuYesvXBA3W+z4MaACnCLtqEiJKzV6Xi9kUzH0M7NOre5wLEY0oBaSnCxWHCf1M7zUWZvXwrUgaWncDnnXcMjGoq+lc2HXf4BIXCbVpJs5jtneLj7Q1YTMULwpO7IZa1CPXuHfBeLehsGFDZBhB/MI+r6VPlxLRYo1To7wZ9yCEghheccZPt+o+yW1RU2vwDx5XFPcRB8oQ5PRPQ06O9qCT8GLF5NkIqluCqbph2sny7VAcYtlXUm+yD4CKNE3CMVd2HPxE1/je76M+hUTw9aCFHCxKg0vEwfsT2ZnmP/21kGFR7k0WlWJL5pZXlCNPhzj7+xYEgndDuzhPowNfH2SWg6X0eYp4NBXro+10eTQM9ESCFnsjbn9FSYvTrQ6JdnjHdA7RGNd6u07YQf0l7s7k03RTjVTVN8l0ntQcggoaLsaSrjuGWhcNUOXqmQRcIdd4UBErB8bgYDZyBxlgzzJJw8ouWS6heIUEK8AdojvI2mNuCfIMBWr0WPq2ia+w8+UdHGFxfmrSOvHC96OkLVVPYL7WPXGw43Q/zy9RFu1WYVitNRAJlXBdrRlv17e2sUd6ml4C5ZqxpJXfs8KPgjD6mSmA1tBaYejGAtxmhjWHShaT0vHpxc9u7238NmPLIdjXgHTQS6WT
 M9lVrtYj
 vdeSSccm6IwckKoZBrqBC0EtsvSaHlCzZ+DJTCtx3gBtDcSdr5LNARf11Ud1c+v+mTJ+zhy6NElRflLky3SuXRRlx85dD+xBzNRouPpgisfeENNGma5jNRQEprc0b3ynrjfpHKiWli2gQEWt3EZux10QSfBT1TArJXoriQHXPsFl/inHHrwmRq9LT/kxdLuSBx7HhZtlCRi6kr1nmEq/U+GM57MTx5JMsUu13
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/31 04:31, David Hildenbrand (Red Hat) wrote:
> On 12/29/25 15:52, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When unsharing hugetlb PMD page tables, we currently send two IPIs: one
>> for TLB invalidation, and another to synchronize with concurrent GUP-fast
>> walkers.
>>
>> However, if the TLB flush already reaches all CPUs, the second IPI is
>> redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
>> completes, any concurrent GUP-fast must have finished.
>>
>> Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
>> their TLB flush provides full synchronization, enabling the redundant IPI
>> to be skipped.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   include/asm-generic/tlb.h | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
>> index 4d679d2a206b..e8d99b5e831f 100644
>> --- a/include/asm-generic/tlb.h
>> +++ b/include/asm-generic/tlb.h
>> @@ -261,6 +261,20 @@ static inline void 
>> tlb_remove_table_sync_one(void) { }
>>   #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>> +/*
>> + * Architectures can override if their TLB flush already broadcasts 
>> IPIs to all
>> + * CPUs when freeing or unsharing page tables.
>> + *
>> + * Return true only when the flush guarantees:
>> + * - IPIs reach all CPUs with potentially stale paging-structure 
>> cache entries
>> + * - Synchronization with IRQ-disabled code like GUP-fast
>> + */
>> +#ifndef tlb_table_flush_implies_ipi_broadcast
>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>> +{
>> +    return false;
>> +}
>> +#endif
>>   #ifndef CONFIG_MMU_GATHER_NO_GATHER
>>   /*
> 
> 
> This should likely get squashed into patch #3. Patch #1 itself does not 
> add a lot of value to be had separately.
> 
> So best to squash both and have them as #1, to then implement it in #2 
> for x86.

Sounds good, will do! Squashing #1 and #3 together, keeping the x86
implementation as #2 ;)

Cheers,
Lance

