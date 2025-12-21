Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5C8D68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 10:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD55C6B00C2; Sun, 21 Dec 2025 05:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACCD6B00C3; Sun, 21 Dec 2025 05:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3AE6B00C4; Sun, 21 Dec 2025 05:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADEA66B00C2
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 05:43:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AFAA5B344
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 10:43:53 +0000 (UTC)
X-FDA: 84243142746.23.91E0338
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 362CC14000E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 10:43:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWhqflV4;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766313831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/nJw25aoa6JK8nypoTwLkmJKFtsfe7JaJlTBhslbOk=;
	b=QMVgEqRzFbyNH79/VF1VisVaJ7h+WP5WrgESdd/NmLFkfo4Q1VbEtMcGASU2ZgMdlSjbWu
	sMKSLwpdYDFu2AL+p/+3uLcYT5lu91f9sRvNo7affhbHdNXuj50vdg2Au70zlXxFW2iMd6
	qcwJ/KYoMOrqhpPAhGVedY7169G0bHY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWhqflV4;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766313831; a=rsa-sha256;
	cv=none;
	b=0ufCq7cpZHVlC0aEESfBWOZHf0k/qG9B60vO2tb/KQkdSHTEWdLvgY/oJ8tTirJt1hY76S
	jMOA5bA2jHRpZ130velu+oKQlFrYwYmKpQmYnE/a83nFypKD76uCm846QcnSFg3YW4MDWt
	m71Yq4sHrHuryzLTHHTP9Yhw0Ksb2yA=
Message-ID: <90c1ff67-46fb-4ddd-9bdd-43633f89dda2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766313826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/nJw25aoa6JK8nypoTwLkmJKFtsfe7JaJlTBhslbOk=;
	b=CWhqflV4t5sakvP8LVfvQLFJPUtApAiiqmvV0P8zoWeb8DX7MR5Iv59vb1r8AvOQvLi+dk
	d6wSA9+/L49daP6cNHmR3BWi7PRdBT1dNfmGLkiimtSAJNAgd7gRUFe+4IleLoukOg9bEm
	gA3HS59ZiYQcyO8QMu/kdTosDXgdahA=
Date: Sun, 21 Dec 2025 18:43:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 3/3] mm/khugepaged: skip redundant IPI in
 collapse_huge_page()
Content-Language: en-US
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
 <6fdf89ee-3f6a-420f-b4d6-b03e3e2c8c9b@linux.dev>
 <6dcfeb2a-dba6-4de9-ac1b-39312c6bbcb6@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6dcfeb2a-dba6-4de9-ac1b-39312c6bbcb6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 362CC14000E
X-Stat-Signature: r1b6se1m5j9bbx18x777n5tge9g9hfx3
X-HE-Tag: 1766313830-871016
X-HE-Meta: U2FsdGVkX18/PEUaFb7ORSQIOXfFW8gF8OqdfJr0aFEMVfraBw5oOGt919L2a2pDO6onQviyVT9RcOBADsoz9XOW3xRDz4sHDgWFehNE75kjmnTjKosiq096mpQ6BJfNR/wHuKvHfIUWC2S7+Kn0cxN2ZWeRTmpHACD8i5KuK9p+m5qONrtr5TyH8ET46Y9Iy/rqixcIKa+gSXLMRD8BjdZb3KgaE2R7m1wz21jFs8DHzLIlF02xKOkm5keVePuvov0iVF5D25UxaKhLVjeCwXGtRyqRsva8gwWh5t6oAgdWNEIGgF2FOVmtSEfXD0XSQ/A1qdWzrvTY1ANZalFy3V9FeFd+rmLXjQAO0cDfgDGE8PrGcUtmt61X+2sGizmQIaNe/GIvIorrBqiocTMTmgUgIuUSkmQju6ktM/nLpvX1SsooN4NE2xvR3uxCAhBKQ4xkQZW521MEYe18CZGewjakWl6dtkbsmh+QFQBWY5sWQKdLTuEC0AhUUeJ2t5F0jG9syRMgbPympcVdeAw+gUSZCw8qgQ3A3q+EZrsYpVCL8Oak/qcgfIZw80vGK1/p8wQ7/F+mfps/vHGSZT68qu6f6P4BXwekCTKwuie9ZWVuEzq3p951/mAHKTKxjusWqgjtVyAUhNjYJBVDkhOe2wamxVnqp4vkEAzYaHgRpeI+4spB5Jl3zWGt7rfHyBlUKmOiqtDlGoT96Xy5XXkrMCEhCGUSdG5AgX1PFaEmsJeRNoJLSUsvktRTr3/8/jTmqxIW0dB48S8VBBFuL4OP1G84s2Al+Ph/qrhxvTN0GBr6htDOFnshApmSj1xfBi3KSj+k+ObCd/uqgFKzDcXBN6iqyt235VmiFqbqzjS2LEqHEzFrN0Ps5a9ldqJxP0vt5C5YmzBPq/wDdrhkSrJ+4c7SEBeQ19k8sH8oSeHejAN4K5qdyQIxs6JN6DYbxgdYdNL+Y0Cr/V/AXb/kCI7
 l2DpCv1H
 T6SSisNftbrqViAdp32BJDspOC+NAxaHI6tLU8CL9wIuSayBkDyPnKv76KLLJsRBS0VZ7ble3I5nb5LYyjSCaD0xtPr5Pmf38TAKQesKCcMCZ9R4OmCYMKF7rpzY0Tk+e5kcGm7tUs+kJvSopTbBpxXMYMqaJD86HpVJMBdZaAXQioPEGqAQxywb5Yel+eujf/QwQju1PCLF/GSHDUGIx7H8Ndo8esr7jm8edkhCLSOU5OXlaAZDP9KhaslAFvhFlw81a5pcJnSmm4z9DCHKr7EEAiejXQ9XNKp4EkyE1x98x74b6djRu9ZuhtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/19 16:25, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 15:35, Lance Yang wrote:
>>
>>
>> On 2025/12/18 21:13, David Hildenbrand (Red Hat) wrote:
>>> On 12/13/25 09:00, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> Similar to the hugetlb PMD unsharing optimization, skip the second IPI
>>>> in collapse_huge_page() when the TLB flush already provides necessary
>>>> synchronization.
>>>>
>>>> Before commit a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
>>>> unconditional"), bare metal x86 didn't enable 
>>>> MMU_GATHER_RCU_TABLE_FREE.
>>>> In that configuration, tlb_remove_table_sync_one() was a NOP. GUP-fast
>>>> synchronization relied on IRQ disabling, which blocks TLB flush IPIs.
>>>>
>>>> When Rik made MMU_GATHER_RCU_TABLE_FREE unconditional to support AMD's
>>>> INVLPGB, all x86 systems started sending the second IPI. However, on
>>>> native x86 this is redundant:
>>>>
>>>>     - pmdp_collapse_flush() calls flush_tlb_range(), sending IPIs to 
>>>> all
>>>>       CPUs to invalidate TLB entries
>>>>
>>>>     - GUP-fast runs with IRQs disabled, so when the flush IPI 
>>>> completes,
>>>>       any concurrent GUP-fast must have finished
>>>>
>>>>     - tlb_remove_table_sync_one() provides no additional 
>>>> synchronization
>>>>
>>>> On x86, skip the second IPI when running native (without paravirt) and
>>>> without INVLPGB. For paravirt with non-native flush_tlb_multi and for
>>>> INVLPGB, conservatively keep both IPIs.
>>>>
>>>> Use tlb_table_flush_implies_ipi_broadcast(), consistent with the 
>>>> hugetlb
>>>> optimization.
>>>>
>>>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>    mm/khugepaged.c | 7 ++++++-
>>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 97d1b2824386..06ea793a8190 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1178,7 +1178,12 @@ static int collapse_huge_page(struct mm_struct
>>>> *mm, unsigned long address,
>>>>        _pmd = pmdp_collapse_flush(vma, address, pmd);
>>>>        spin_unlock(pmd_ptl);
>>>>        mmu_notifier_invalidate_range_end(&range);
>>>> -    tlb_remove_table_sync_one();
>>>> +    /*
>>>> +     * Skip the second IPI if the TLB flush above already synchronized
>>>> +     * with concurrent GUP-fast via broadcast IPIs.
>>>> +     */
>>>> +    if (!tlb_table_flush_implies_ipi_broadcast())
>>>> +        tlb_remove_table_sync_one();
>>>
>>> We end up calling
>>>
>>>       flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
>>>
>>>       -> flush_tlb_mm_range(freed_tables = true)
>>>
>>>       -> flush_tlb_multi(mm_cpumask(mm), info);
>>>
>>> So freed_tables=true and we should be doing the right thing.
>>
>> Yep ;)
>>
>>> BTW, I was wondering whether we should embed that
>>> tlb_table_flush_implies_ipi_broadcast() check in
>>> tlb_remove_table_sync_one() instead.
>>> It then relies on the caller to do the right thing (flush with
>>> freed_tables=true or unshared_tables = true).
>>>
>>> Thoughts?
>>
>> Good point! Let me check the other callers to ensure they
>> are all preceded by a flush with freed_tables=true (or unshared_tables).
>>
>> Will get back to you with what I find :)
> 
> The use case in tlb_table_flush() is a bit confusing. But I would assume 
> that we have a TLB flush with remove_tables=true beforehand. Otherwise 
> we cannot possibly free the page table.

Right! I assume you meant freed_tables=true (not remove_tables) ;)

Verified all callers have proper TLB flushes *beforehand*:

-> 1. mm/khugepaged.c:1188 (collapse_huge_page)

	pmdp_collapse_flush(vma, address, pmd)
	-> flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE)
		-> flush_tlb_mm_range(mm, ..., freed_tables = true)
			-> flush_tlb_multi(mm_cpumask(mm), info)

So freed_tables=true and we should be doing the right thing :)

-> 2. include/asm-generic/tlb.h:861 (tlb_flush_unshared_tables)

	tlb_flush_mmu_tlbonly(tlb)
	-> tlb_flush(tlb)
		-> flush_tlb_mm_range(mm, ..., unshared_tables = true)
			-> flush_tlb_multi(mm_cpumask(mm), info)

unshared_tables=true (equivalent to freed_tables for sending IPIs).

-> 3. mm/mmu_gather.c:341 (__tlb_remove_table_one)

When we can't allocate a batch page in tlb_remove_table(), we do:

	tlb_table_invalidate(tlb)
	-> tlb_flush_mmu_tlbonly(tlb)
		-> flush_tlb_mm_range(mm, ..., freed_tables = true)
			-> flush_tlb_multi(mm_cpumask(mm), info)

	Then:
	tlb_remove_table_one(table)
	-> __tlb_remove_table_one(table) // if !CONFIG_PT_RECLAIM
		-> tlb_remove_table_sync_one()

freed_tables=true, and this should work too.

Why is tlb->freed_tables guaranteed? Because callers like pte_free_tlb()
(via free_pte_range) set freed_tables=true before calling __pte_free_tlb(),
which then calls tlb_remove_table(). As you mentioned, we cannot free page
tables without freed_tables=true.

Note that tlb_remove_table_sync_one() was a NOP on bare metal x86
(CONFIG_MMU_GATHER_RCU_TABLE_FREE=n) before commit a37259732a7d.

-> 4-5. mm/khugepaged.c:1683,1819 (pmdp_get_lockless_sync macro)

Same as #1.

So all callers satisfy the requirement! Will embed the check in v2.

Hopefully I didn't miss any callers ;)

Cheers,
Lance

