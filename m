Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0199ACA5FFD
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC146B0088; Mon,  5 Oct 2026 03:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED34F6B008C; Mon,  5 Oct 2026 03:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9FF6B0092; Mon,  5 Oct 2026 03:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8A506B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:24:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D55F8016B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:24:01 +0000 (UTC)
X-FDA: 85287733482.27.2410E78
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 25F2080005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:23:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wchswUTx;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791185039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9GiSmyFN+AotyFfYv+69WAwkBv56CpP7oDts31Ov9E=;
	b=c60YkG1kPYMvI3sOs8lVxIDwPiRraNR1Xrd30dcQATKoQpZCHKpqW34SubRQ70W2mTzAKG
	DF7FARP9zuJorPUic9lU13l/LPlkb09iK3n7msBljiftnhf2ldkB7pVBsiFyn2IstSoBqa
	36a+43Jmw2NH5uTL2cpHU5Prub14/KA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wchswUTx;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791185039;
	b=KVzLOPwzNk+Zdj/IyHfPYfjPxCqSPsuilUUCQ2YBjoCUhT4O40ktH8Aas9mPPnItmvdOlZ
	t/qxCDKk3TaRobQhHHFCaNrZRUkm6IHvfFagGkjEN6UZkiNvQL0YRc3MS3WBbawcotNu+9
	xXtNhHc4CA/hQ10KvbkAtwbG9IpLl1s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Gmsh/yjeWQhuRRzt7tOzKvgXe8nse8xEadBQY+u8XjM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791185037; v=1; x=1791789837;
 b=wchswUTx3q4XFhZr3lr+cgPzLyyaYnbldXpuAa9VsE3xssRtOj4zVsJIpyLPxu3HEhVRX2ME
 M3HYnlJv8VM/2eyRq3DwN4cP+SlhP/xQuacqs9sKiTsnAyr7bF6c6H+kpfYvFo7D/R9u7eNhQ0k
 wR66Obpf1Ms+0IuHeSUFnnL4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 943f59b3aa53cf7d;
	Mon, 05 Oct 2026 07:23:57 +0000
X-Mizu-Trace-ID: 943f59b3aa53cf7d
X-Migadu-Flow: FLOW_OUT
Message-ID: <c6421cab-1a21-4d39-87ff-05dc7be6bc02@linux.dev>
Date: Mon, 5 Oct 2026 15:23:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
To: Nadav Amit <nadav.amit@gmail.com>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, riel@surriel.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, thomas.lendacky@amd.com, kernel-team@meta.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, brendan.jackman@linux.dev,
 jannh@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com,
 Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org,
 toshi.kani@hpe.com, david@kernel.org, mikhail.v.gavrilov@gmail.com,
 pfalcato@suse.de
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <D8AEF6EF-D92A-4838-95A7-EB93BE319BE1@gmail.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <D8AEF6EF-D92A-4838-95A7-EB93BE319BE1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25F2080005
X-Rspam-User: 
X-Stat-Signature: knqtqpsef8mban33babnxbdfypwq7ee8
X-HE-Tag: 1791185038-804800
X-HE-Meta: U2FsdGVkX19CF+4oZaEEhj9xv9wWPSjBeghwPxBFYrpPhsOBmrYbttyN9uWTXVQ7AHtHOXsrYd6ZUKuRTw45WgEwupUIBoLx7H/kio46ydd9MIz0ZwtSTPLxxx+rJ98VBGmb6pcfy0dChakoGFV/Zw8sWMiQPTs6K9N5jNloU0PZTIeTNyVlt/k5VFEo35hzlAuGlBvij0D9mj3nxC7caxpt6gA8xVTh4CRT9OoY9ghigpVDAWpLPOjCPvlETMKbJCAifUkJhBsOU5r+jljGBbUWsx9i0TlNVKdD0pdNog4azCTEvGF2O+VFupsOPLoN/kx816/DkXL3qW4BGPGS7g6ism4okr5KUh7HncIYSnqzhzeFb+FDWW/twDUSw8yhfzQNW3qI1rQw1M0XY1mZzyiXimIkwxBiJtjC3ymI3tf1p469mWwp7tIJT6FU/UdnpD1zowlxmYoVURr3gTP3h35FAv3Dt0XSs9g8mhTNFB+f7qrbtzluCi1ysmH4QZKl2X2+kUqFrVJoa6ErRy20KhoSVz5j560Nh1dGVb4Uu2uUjRtwbUSZRXvMGsEpAAly3iC4mXQcYsJqYErY7jybPWqnssC2i75IXr49Hk8wUmtEXcbCUOhNsuDOHql/eOm9adPa391czge9TJY7GOZ/F8XaJN3weXmSlZ50FGzIYebfRJ7e/UX7ewS8fn/p2HcheFmLel6cy1HA9x8LOUEz3GZQsIZsSbLVlOdhm0O6w62ztYnBdKMlbx+zOC1bporW3SkTQxtpkuXLwWdPYxnpBlITC7a63YBy/s595nekdhF6MCUyXC1vo76bxiRvCdtg7AQP9HqpM94PFxwmntQXPcvLG7zN9Mj9Ofc8M076KcmwaU8jmvXTf4R/1/3n0TTS996sBSnJqvpIwhj49qrEMHLQ1QF1zFUZV/nuc3w3NBThAKsrMKJj/zHCBNmuGc+V92nTI0gagz4aNIZqZo6
 jmQGWP54
 GFllRf2+emgirfuz2MZ6A7Cvsa8bfZ0FR3EvYRYsKfqv0yzxVYQXxThwmbzYAVZnEGk7qwP+gh2IgjvEMC85WzPsFY7CZKeKPitZur6o/7CJ7cyqEEr95fV0K4QgLMnou8sYAupSRPWrURBFT6BmHNZVYZXgRrAHTypkDst5aEvWDJEu48mZYfZROz6wKlLZGZEai+cZsaPcy6yCvWUt8cNjLl+UG25wqp4ICm3nY8IyZlOSSAVwnDLb4FvU6L4vngvSgjdq6nVWX54isV05jhOnc+Ujz7mmXpETnKi39YPZk6OjYc3stJaWsTxru/ghTZAIzr376zQF5gFUSTQ6ZrI70Dbdqcxav1UKJ73HhI+Z9ntmRD7eG4iRXcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 14:38, Nadav Amit wrote:
> 
> 
>>
>>
>> On 5 Oct 2026, at 8:23, Lance Yang <lance.yang@linux.dev> wrote:
>>
>> pud_free_pmd_page() uses a single-address invalidation to flush the
>> paging-structure caches before freeing the page tables. With AMD TCE
>> enabled, this only invalidates upper-level entries associated with the
>> target address. Cached PMD entries for other addresses in the PUD range can
>> still reference the PTE pages being freed.
>>
>> The AMD manual quoted in the commit enabling TCE says these instructions
>> remove
>>
>>   "only those upper-level entries that lead to the target PTE in the page
>>   table hierarchy, leaving unrelated upper-level entries intact."
>>
>> Even with all PTEs cleared, speculative page walks can cache present PMD
>> entries after the earlier TLB purge.
>>
>> Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
>> the single-address invalidation otherwise.
>>
>> Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> arch/x86/mm/pgtable.c | 11 ++++++++++-
>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
>> index 4a105f283cfb..6b7fa44f1bf6 100644
>> --- a/arch/x86/mm/pgtable.c
>> +++ b/arch/x86/mm/pgtable.c
>> @@ -727,7 +727,16 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>> 	 * via normal page walks. Make them unreachable
>> 	 * in cached mid-level walks too:
>> 	 */
>> -	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
>> +	if (boot_cpu_has(X86_FEATURE_TCE)) {
>> +		/*
>> +		 * With TCE enabled, a single-address flush does not invalidate
>> +		 * cached PMD entries for the rest of the PUD range.
>> +		 */
>> +		flush_tlb_all();
>> +	} else {
>> +		/* INVLPG to clear all paging-structure caches */
>> +		flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
>> +	}
>>
> 
> 
> It might be cleaner to replace flush_tlb_all() with:
> 
> 	flush_tlb_kernel_range(addr, addr + PUD_SIZE - 1);

Looks much cleaner, Thanks!

> While the flush-ceiling would usually end up doing a full flush, the
> code would be easier to follow (the very least). Maybe adding stride
> to kernel TLB range flushing would make sense in the future.

Ack.

