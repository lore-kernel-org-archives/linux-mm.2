Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA20D6D22D
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268A96B0088; Thu, 18 Dec 2025 09:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217356B0089; Thu, 18 Dec 2025 09:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115A76B008A; Thu, 18 Dec 2025 09:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2A4E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:36:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC8EB1601C7
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:36:15 +0000 (UTC)
X-FDA: 84232841910.29.9AF8F16
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8E289C001C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:36:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PpMbVtrz;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766068574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/obYsmYE7DxZF0F7CimsIs8ULL/trNGoQu3yuIxJ4Q=;
	b=jeAO2wAFD6gScl4jTf81LxAl2NQIq7gsH6DDvbgU81w5rAGAPHxnhxRfOHTqGCOIZcHDqb
	gDQBpfbf79lkZOTgLDU+QO18eWfxapdYlJvYqgEeu0UNHQUM6w7u4ggh0IPBAgjfvT4q/D
	Y1uWZ71jcvgK3530QZHbpxcfGql7NBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766068574; a=rsa-sha256;
	cv=none;
	b=w+IM/4x0oDS2EFQobfw0VUdGu9BGzgGfjes1IRRYXFeO+2YyiIjcVI+wSfwIj0mTSuQu5I
	l4qZtwSbsS8YVFmu2p0Y9sICcJgaoKlzqAMzMUU+Fs8T3+vgzkTE6FMCDycjCCs0lVNZFE
	vLeBnMqIOSNkT+1KAS7NdFpldP2is5k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PpMbVtrz;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6fdf89ee-3f6a-420f-b4d6-b03e3e2c8c9b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766068571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/obYsmYE7DxZF0F7CimsIs8ULL/trNGoQu3yuIxJ4Q=;
	b=PpMbVtrzF9RqtCYbqHrg5kVIozY0nQPPfUZDye+GfxYxEfRSyrmGid/c8J5DlSEP9uuEaZ
	Rg366J3xLe78dFngON/IJ7OO8n1xI7PKzXlwpQYQvzYImbl3cCw37jX/Pq7r9o4a6Q0eDX
	kD2GtDWnn4voFSAKU1hfnCKTYllD5wI=
Date: Thu, 18 Dec 2025 22:35:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 3/3] mm/khugepaged: skip redundant IPI in
 collapse_huge_page()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20251213080038.10917-1-lance.yang@linux.dev>
 <20251213080038.10917-4-lance.yang@linux.dev>
 <948d425a-2d6e-4439-a280-0ca9e7521b13@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <948d425a-2d6e-4439-a280-0ca9e7521b13@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 77iyigp1ywaaz6yxya3rzqxcd7tyoty9
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E289C001C
X-Rspam-User: 
X-HE-Tag: 1766068573-133939
X-HE-Meta: U2FsdGVkX19USJZQsL9+BbBHroOM5w+VMeddwzb99TpEMqTO0Ux2cAnzZMNFGXQenXlPVFLHTsTVapFFLpYoWLg3UmxGRGJf1wh8KmT9qX23WUNlU2nckLwC9MhX6jX5YTrQjMO7nZTej7kIdQHM3ttoLeWwMXxxIhy+repPE5G4Ws1pQicAgAfZFLfsAXBSv1y9OOw75Da39HFe0ec9FPiEDrQ64Tff5K10SGKUV3AoEYr7sxeoC7HOjyXvJWPG/OzHeybV/xBv+rRsbF+XXKFjCvG8xr88yHqJulV3Pjs/R0C/jHucsABXNDdPFY3hvc5aeb4kjY9jDXLNOorcF0HduVynIBOQvxJ4oDy4ulDwGa0ChyZBLWOBeb669u+xaiOM5qgQQAe58ptk/4361gMCvV3UvUxuB1e87Bo4pQNUBtDEW0Ut9ZeaNkQZhW1gwyfUtSAgGjXouR07nwpF87yvwIeir4x6KIESJwAbQZK6oGy/oBmlGUn8wALZi/54KxLQMkOhTQdRfOqGpT9122m2idGQiDh9AC5AHarybgD3BH1cs7Hq5jEP0RuDnOtSLagT2E3iQwZ4u2rNKB/LjnzjCupMhRclRjFmMVlv+UMCfOpx5H8EguNpj7Syan1+OyLx/u/+z/HYco3njLpRaMRhqBdv5sLzVBdk2r7RDhNKeElapHipO3qOIvfMQ6xVqOIeFjIZryVu7Om8T5sY1AGVMkNFm5YxdmIuMU5shmdG/Y1CatzUcXQU2yvYGQzHX9ERXr2SsXzE5Sx3zvs4Gxjoj99wjPGnndfrvG0BroJIjZvBoFgHaA4dzRfpvkFc/KJu0ii8i/jHJSglQ2cm48CgDT0pJT7KtlDcN5923RkauqsjCODkfU+WCxJy101VdBC1dyqTarG1/Kmpn478fhsTS219mBzX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 21:13, David Hildenbrand (Red Hat) wrote:
> On 12/13/25 09:00, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Similar to the hugetlb PMD unsharing optimization, skip the second IPI
>> in collapse_huge_page() when the TLB flush already provides necessary
>> synchronization.
>>
>> Before commit a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
>> unconditional"), bare metal x86 didn't enable MMU_GATHER_RCU_TABLE_FREE.
>> In that configuration, tlb_remove_table_sync_one() was a NOP. GUP-fast
>> synchronization relied on IRQ disabling, which blocks TLB flush IPIs.
>>
>> When Rik made MMU_GATHER_RCU_TABLE_FREE unconditional to support AMD's
>> INVLPGB, all x86 systems started sending the second IPI. However, on
>> native x86 this is redundant:
>>
>>    - pmdp_collapse_flush() calls flush_tlb_range(), sending IPIs to all
>>      CPUs to invalidate TLB entries
>>
>>    - GUP-fast runs with IRQs disabled, so when the flush IPI completes,
>>      any concurrent GUP-fast must have finished
>>
>>    - tlb_remove_table_sync_one() provides no additional synchronization
>>
>> On x86, skip the second IPI when running native (without paravirt) and
>> without INVLPGB. For paravirt with non-native flush_tlb_multi and for
>> INVLPGB, conservatively keep both IPIs.
>>
>> Use tlb_table_flush_implies_ipi_broadcast(), consistent with the hugetlb
>> optimization.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 97d1b2824386..06ea793a8190 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1178,7 +1178,12 @@ static int collapse_huge_page(struct mm_struct 
>> *mm, unsigned long address,
>>       _pmd = pmdp_collapse_flush(vma, address, pmd);
>>       spin_unlock(pmd_ptl);
>>       mmu_notifier_invalidate_range_end(&range);
>> -    tlb_remove_table_sync_one();
>> +    /*
>> +     * Skip the second IPI if the TLB flush above already synchronized
>> +     * with concurrent GUP-fast via broadcast IPIs.
>> +     */
>> +    if (!tlb_table_flush_implies_ipi_broadcast())
>> +        tlb_remove_table_sync_one();
> 
> We end up calling
> 
>      flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
> 
>      -> flush_tlb_mm_range(freed_tables = true)
> 
>      -> flush_tlb_multi(mm_cpumask(mm), info);
> 
> So freed_tables=true and we should be doing the right thing.

Yep ;)

> BTW, I was wondering whether we should embed that 
> tlb_table_flush_implies_ipi_broadcast() check in 
> tlb_remove_table_sync_one() instead.
> It then relies on the caller to do the right thing (flush with 
> freed_tables=true or unshared_tables = true).
> 
> Thoughts?

Good point! Let me check the other callers to ensure they
are all preceded by a flush with freed_tables=true (or unshared_tables).

Will get back to you with what I find :)

Cheers,
Lance

