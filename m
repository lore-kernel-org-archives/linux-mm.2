Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3409E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E674E6B00D1; Sun, 21 Dec 2025 07:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E154F6B00D3; Sun, 21 Dec 2025 07:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D145D6B00D4; Sun, 21 Dec 2025 07:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFCF26B00D1
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:24:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72EDB60818
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:24:55 +0000 (UTC)
X-FDA: 84243397350.15.59C417B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C1BDB2000B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:24:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tYt8izPK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766319893; a=rsa-sha256;
	cv=none;
	b=KnL8e84zmse+8wT9To4IhyCmQ3IgK4x1OMTvVGAlIR72m3hzFgOJucSzVOSJepiQG2txfU
	igIXPXzLTXPcp2pzmLk+UiBawHB4TpxeQe0FDiGrmT145pFBc/3beKIvUrAK6V3L04lMkq
	oYobxrFi664+G1r/mQHK2cfSqZDT98c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tYt8izPK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766319893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/ywaBG6EJ5czazSPcs1C2vp/zOcZxPNSXdDvsfO30I=;
	b=s1DXL6K8KgcOD/qmrN37FEzDTHXoNBbpoac1nWMitkz8y5q37Levv2doPDdrsEQuqVcf1I
	sCl/kKYJVm1uFy4MnW8sWZebMTlxLUapnacFF/z7aOOY8Q2B5iDEhJ+3/XdZ66dz5W2X2i
	SDmQckUHKz3F3J8ImB6NSI4fKXbZTn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1ACCF60007;
	Sun, 21 Dec 2025 12:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C2FC4CEFB;
	Sun, 21 Dec 2025 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766319892;
	bh=IqPxZ/9JKNcdTw/8izbbZYaeUpAAZSbuuFtctc/CLm4=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=tYt8izPKSJbk40BHKx3r8/+AfFkFWB6BVc8qn87q5kjCcrluSk3OQJNpTrNlz3pGz
	 DVTfFdLV89tLr1ezgV+7vLlihUvuA378IKn4JVcIk8Vd2HqmYFraSVp1wXlhwwVUYv
	 KYmtrINYMvMG8zF0FMzl/iM5xYo3TmTpo1mhf6oe4IhZPB0c7eVXm7tiXMjR1bfC7e
	 MaBaRiCypuOwQ+QWAvt1jEyroS6nscvKF9dlRxn5hBTP4ley/8SO+EcSeW2SFyAIxQ
	 d5aCmShGfRuUxPG8OEeb0HMrBTwBc1XxpdDdafel8nJ2UY0Tp31U2apQoG75akVuFD
	 ZeQRrQZOBQ/Zw==
Message-ID: <e78f5457-43fb-4656-ad53-bfda72936ef5@kernel.org>
Date: Sun, 21 Dec 2025 13:24:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/hugetlb: fix excessive IPI broadcasts when
 unsharing PMD tables using mmu_gather
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20251212071019.471146-1-david@kernel.org>
 <20251212071019.471146-5-david@kernel.org> <aUVHAD9G5_HKlYsR@hyeyoo>
 <d5bf88d9-aedf-4e6d-b5a0-e860bf0ed2e4@kernel.org>
 <3d9ce821-a39d-4164-a225-fcbe790ea951@kernel.org>
Content-Language: en-US
In-Reply-To: <3d9ce821-a39d-4164-a225-fcbe790ea951@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C1BDB2000B
X-Stat-Signature: 1fhpbono4do6iyytrxxsx1nfx8wy5a9j
X-Rspam-User: 
X-HE-Tag: 1766319893-891413
X-HE-Meta: U2FsdGVkX18vrFPoFO4aHIWjcKIjK2lTPj2n0Zj8yqb3GlL5yDLk0CgpBrpf8rsvmWTC5vaKsz9gWtb+6Cx3ukud/vjfXnCZcwBdXLyFIewuciUoopUk4sc2+lp9zxp27NA4XrtmjiMMCi1p8UE1SePW8T58sUoqA9LGUubO8AsNpLZZupkL6j5QB6JipRO1dpXFv+CJrUAXzD3Yy25HG4yLQI5+98M0EXzf7XbDv1fT7HpuBWDSixg6MWO+DShYZ79u3pJh0DxUX/EfiUoTkB82e0pMrYhRoYY4cbBBHoJPXnmxtOzIWWkSgg4KmA0vpvEDAvEN5vfk4ukZUN9xqN7t8IsA+6vlh7+S6fXXZxVdbb8SiiwWL+lyC7q45LdG9g/tXt6dTF09DbhnL1+mo+Lugj5jNzPFgaVKYirDD34tPZsr1VyebjIc8CnzeHx4SHeyDkZcb6Hv9xUdJlfgEbrFunX/GoE9cYIa+aCCbusKMd2Ms+8cAubYe+6w66xEkeGve8Nhk8uY/rtLow32sw6lQsA673KuPscD1k9vUOKPhF64HJljkM+vCKMVCf7qh1WlzxrjHJmY+oZhkRmxvzzFJZppuk1Y+qhe50eg97gbgcc+E4yenZw2Wlo0o9cjiUGQLYOg60LmNeSSvvb3lOmHlKp98ICzK6LYagz5ejoeMeYkykmhOwCxoG94wKUnFeXuRhresyaoiEkpVSB1emB2kK2aqqdnvTkMsml+V6/ftYY10cJmATeFRSVf/0htfE87yVJVa6/3BmCWaO8vGAE9S/NppL8yDq1Ff11/JwpkqSguu4uzkV+KRZHBH1i+D1Fpe0aXsyV48oTwZOqGJmLN2eY8K7c6pS+5nwg/WHODSqAOqE08HR21/0qyAf5vNCP0jHKK4mmqt2Mt3JMgVoS8guxatZ9TELcfKBTonzhznh0eKY4MhbolIwf6KPPtMxwpOR3KebORa+DDVqU
 /iS4XaSV
 3rGqEEciMRuoDanUEK+04o12EO27Eb2ND5Rrswf2Q8vFAIha8xS1MuxJc1h/g4Jh/GuCzrv++hRyv6p8sRaPJ5vctdsYt1Tw+N3Tdlj7uBpqQZDm9j8AVokABlxWHdVWytGuJW+EjDSM3UH8xgHxXjZgMa/i6dFBq6DP/bly7Aa0YJXOlg/ZhMf2rWtCCk3llk/Sh1G3SI1rB1VmSl+pGd1/aAUIk5ZWCo07Qih2LVXfe1LFRTg5xJcgae0XZLUKsZYSUvXPNm2rVVQ88BUaK2PEVCl5931pBui3LorCsMxy7MBHboN1lSck+hzxQpbLjWBKmiNx8Xd72tkcz9xJBdasDmxrwCsQI9an3FEx6z3zDVRyiavbjRDpOoVLEOrfFvhYhzgGBCI21N8EqwuUaAdeUTxUB+KG+FPf6ygOUwqaNoXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 14:59, David Hildenbrand (Red Hat) wrote:
> On 12/19/25 14:52, David Hildenbrand (Red Hat) wrote:
>> On 12/19/25 13:37, Harry Yoo wrote:
>>> On Fri, Dec 12, 2025 at 08:10:19AM +0100, David Hildenbrand (Red Hat) wrote:
>>>> As reported, ever since commit 1013af4f585f ("mm/hugetlb: fix
>>>> huge_pmd_unshare() vs GUP-fast race") we can end up in some situations
>>>> where we perform so many IPI broadcasts when unsharing hugetlb PMD page
>>>> tables that it severely regresses some workloads.
>>>>
>>>> In particular, when we fork()+exit(), or when we munmap() a large
>>>> area backed by many shared PMD tables, we perform one IPI broadcast per
>>>> unshared PMD table.
>>>>
>>>
>>> [...snip...]
>>>
>>>> Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
>>>> Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
>>>> Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
>>>> Tested-by: Laurence Oberman <loberman@redhat.com>
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>> ---
>>>>     include/asm-generic/tlb.h |  74 ++++++++++++++++++++++-
>>>>     include/linux/hugetlb.h   |  19 +++---
>>>>     mm/hugetlb.c              | 121 ++++++++++++++++++++++----------------
>>>>     mm/mmu_gather.c           |   7 +++
>>>>     mm/mprotect.c             |   2 +-
>>>>     mm/rmap.c                 |  25 +++++---
>>>>     6 files changed, 179 insertions(+), 69 deletions(-)
>>>>
>>>> @@ -6522,22 +6511,16 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>>>>     				pte = huge_pte_clear_uffd_wp(pte);
>>>>     			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
>>>>     			pages++;
>>>> +			tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
>>>>     		}
>>>>     
>>>>     next:
>>>>     		spin_unlock(ptl);
>>>>     		cond_resched();
>>>>     	}
>>>> -	/*
>>>> -	 * There is nothing protecting a previously-shared page table that we
>>>> -	 * unshared through huge_pmd_unshare() from getting freed after we
>>>> -	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
>>>> -	 * succeeded, flush the range corresponding to the pud.
>>>> -	 */
>>>> -	if (shared_pmd)
>>>> -		flush_hugetlb_tlb_range(vma, range.start, range.end);
>>>> -	else
>>>> -		flush_hugetlb_tlb_range(vma, start, end);
>>>> +
>>>> +	tlb_flush_mmu_tlbonly(tlb);
>>>> +	huge_pmd_unshare_flush(tlb, vma);
>>>
>>> Shouldn't we teach mmu_gather that it has to call
>>
>> I hope not :) In the worst case we could keep the
>> flush_hugetlb_tlb_range() in the !shared case in. Suboptimal but I am
>> sick and tired of dealing with this hugetlb mess.
>>
>>
>> Let me CC Ryan and Catalin for the arm64 pieces and Christophe on the
>> ppc pieces: See [1] where we convert away from some
>> flush_hugetlb_tlb_range() users to operate on mmu_gather using
>> * tlb_remove_huge_tlb_entry() for mremap() and mprotect(). Before we
>>      would only use it in __unmap_hugepage_range().
>> * tlb_flush_pmd_range() for unsharing of shared PMD tables. We already
>>      used that in one call path.
> 
> To clarify, powerpc does not select ARCH_WANT_HUGE_PMD_SHARE, so the
> second change does not apply to ppc.
> 

Okay, the existing hugetlb mmu_gather integration is hell on earth.

I *think* to get everything right (work around all the hacks we have) we might have to do a

	tlb_change_page_size(tlb, sz);
	tlb_start_vma(tlb, vma);

before adding something to the tlb and a tlb_end_vma(tlb, vma) if we
don't immediately call tlb_finish_mmu() already.

tlb_change_page_size() will set page_size accordingly (as required for
ppc IIUC).

tlb_start_vma()->tlb_update_vma_flags() will set tlb->vma_huge for ...
some very good reason I am sure.


So something like the following might do the trick:

 From b0b854c2f91ce0931e1462774c92015183fb5b52 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Date: Sun, 21 Dec 2025 12:57:43 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
  mm/hugetlb.c | 12 +++++++++++-
  mm/rmap.c    |  4 ++++
  2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7fef0b94b5d1e..14521210181c9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5113,6 +5113,9 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
  	/* Prevent race with file truncation */
  	hugetlb_vma_lock_write(vma);
  	i_mmap_lock_write(mapping);
+
+	tlb_change_page_size(&tlb, sz);
+	tlb_start_vma(&tlb, vma);
  	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
  		src_pte = hugetlb_walk(vma, old_addr, sz);
  		if (!src_pte) {
@@ -5128,13 +5131,13 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
  			new_addr |= last_addr_mask;
  			continue;
  		}
-		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
  
  		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
  		if (!dst_pte)
  			break;
  
  		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
+		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
  	}
  
  	tlb_flush_mmu_tlbonly(&tlb);
@@ -6416,6 +6419,8 @@ long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vm
  
  	BUG_ON(address >= end);
  	flush_cache_range(vma, range.start, range.end);
+	tlb_change_page_size(tlb, psize);
+	tlb_start_vma(tlb, vma);
  
  	mmu_notifier_invalidate_range_start(&range);
  	hugetlb_vma_lock_write(vma);
@@ -6532,6 +6537,8 @@ long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vm
  	hugetlb_vma_unlock_write(vma);
  	mmu_notifier_invalidate_range_end(&range);
  
+	tlb_end_vma(tlb, vma);
+
  	return pages > 0 ? (pages << h->order) : pages;
  }
  
@@ -7259,6 +7266,9 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
  	} else {
  		i_mmap_assert_write_locked(vma->vm_file->f_mapping);
  	}
+
+	tlb_change_page_size(&tlb, sz);
+	tlb_start_vma(&tlb, vma);
  	for (address = start; address < end; address += PUD_SIZE) {
  		ptep = hugetlb_walk(vma, address, sz);
  		if (!ptep)
diff --git a/mm/rmap.c b/mm/rmap.c
index d6799afe11147..27210bc6fb489 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2015,6 +2015,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
  					goto walk_abort;
  
  				tlb_gather_mmu(&tlb, mm);
+				tlb_change_page_size(&tlb, huge_page_size(hstate_vma(vma)));
+				tlb_start_vma(&tlb, vma);
  				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
  					hugetlb_vma_unlock_write(vma);
  					huge_pmd_unshare_flush(&tlb, vma);
@@ -2413,6 +2415,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
  				}
  
  				tlb_gather_mmu(&tlb, mm);
+				tlb_change_page_size(&tlb, huge_page_size(hstate_vma(vma)));
+				tlb_start_vma(&tlb, vma);
  				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
  					hugetlb_vma_unlock_write(vma);
  					huge_pmd_unshare_flush(&tlb, vma);
-- 
2.52.0



But now I'm staring at it and wonder whether we should just defer the TLB flushing changes
to a later point and only focus on the IPI flushes. Doing only that with mmu_gather
looks *really* weird, and I don't want to introduce some other mechanism just for that
batching purpose.

Hm ...

-- 
Cheers

David

