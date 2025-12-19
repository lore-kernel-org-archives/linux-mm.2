Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D08D7877B
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 13:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DE86B008A; Fri, 19 Dec 2025 08:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C886B008C; Fri, 19 Dec 2025 08:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F496B0092; Fri, 19 Dec 2025 08:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14F846B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:52:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD65C1A0219
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:52:52 +0000 (UTC)
X-FDA: 84236361384.20.9413EF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2A879A000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:52:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BZTh/akB";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766152371; a=rsa-sha256;
	cv=none;
	b=GV+0f1oM4W+zLSmZV8+8czRffpvgdbxRcTC6do/pzpIoFuMavqHMzpyBzWce8rYn3f6afy
	F01A/QVC005JyffTzbPfOyGfeG7rLMlsla/GXWtFWFzNfSuS2Ektz1RlwaX+HMp1/yk8sf
	klpFZr0WfLRh+UYv+3vNsz7p6cuoWMs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BZTh/akB";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766152371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QblSaB1+wCLYuIQseyzgvn2OwNzEIRa9VXBaHq2xGf0=;
	b=g+9HEElMLTrLJ2HaTZE3kVC49rgBS9c417JRg2I7YCW5wb1InCIC5tl344PkY/wJEp9LNy
	tgPeM8v9390C5/STlyYc7XmVfD1qR+DFjrpafM6AgsWVVZmgMb7G7lx1zbSUcZZ2aWG2aN
	xSWWt7IaoqtaopV6UMJFEYMswTi0wJc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33BA660008;
	Fri, 19 Dec 2025 13:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840A5C4CEF1;
	Fri, 19 Dec 2025 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766152369;
	bh=kp11YU2QH+WTDS76e4SebHd/dxUjhu1pW98eOwe8K0w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BZTh/akBrk0EFUsB0mnnrGI4bSdbDF3g3y2Tib8PutDKdve9TMuIWjcv9u2LLNdIX
	 ADG1T0x8r9IcGlyAB5/mldOvYLs5PCnr+afNXRsNJvt+VsnshEE3B7EhHkawPk/Bdy
	 S8FORjtngC0ok6jYoVShmyBc4dYpbN45kXgzzGtFXA4LOp8ChVkABePp5Bj9KN6NTi
	 WwpW+GdParMGATH8cbUsN4GqanpHT5ornzR3FJFIqS/7duGdYRphCyiiTquvWaMA8h
	 8fNb0YcKhcskSfvgYd7X5jdCHEkSirsMW40Bi0pn+61Me+MMQYToQG/Xxu8mLzUeEK
	 pQ1h0rbMtfKRA==
Message-ID: <d5bf88d9-aedf-4e6d-b5a0-e860bf0ed2e4@kernel.org>
Date: Fri, 19 Dec 2025 14:52:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/hugetlb: fix excessive IPI broadcasts when
 unsharing PMD tables using mmu_gather
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUVHAD9G5_HKlYsR@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A879A000F
X-Rspamd-Server: rspam04
X-Stat-Signature: nxyw868h7gbrgw55ek7nphehxckksyhc
X-HE-Tag: 1766152371-736100
X-HE-Meta: U2FsdGVkX18Oyzfi18PtnVswUNIi2uIwblAYB2Nm9N9KcZ7LRyoM5Mfzw3nftBU1/P4nlSRpBPhIgf+fiAKigQaWn8gm9kHE5Ltr56VQXimefDBNGW6pSA0t0hCgP+vRNlSTEr8+JFlkEao056cWnzbz/MzuRUjPNti2r+dooKbA01IbaDxW9CDBQRcXqf+AdMASBkft1pJxZnqSUM0+j042JtDsY6p0ChHSUN7ZYh5MfPkLWB0bKHIeMYG4+UjePt+k57ZY38Wro5HGDqef0/hTYpXKq16FBilYbeFML+9/lJ1HOZ4EqXmuqkjqgF2izjM3ajriA45qQAu7nrinS97GmCc3UPY+dW9AEYVlf5Qx1F5eN5pzLH86MNsnVU7o+CYQr/2OMKSqtzHUubV6CVIXIwQgP/y8dlzxTWNMExg7WUkSlPxLWngyJHfNMrV/zyrEZGXbZFAzIKBQgK26zGYYna8+o66gkjX0DXr+Svuc2ZGIV2IY2TLUJlwy5azisAF8w6WgU6Qjs2OG/Pj5MDzgSC9ypgJ3FCZ+66Y1i10/W5YFr5zpE771EIpJ7BH3+j9IyUkfafHeedxxAXHErP4SOADQmJB3NdD31WnZKjewaGaHL5pHBUJaDTLw9sbKjUXIYx+nOeZ/L4xT+Ddqj/6AzFt9ESsr2UUebXdR8ZQGGIL34eoNl1j8vx9fF5JnhsdcQ6gZWl+2PZQblhDwcIYUiphdn7h72BQydsJI68nRCnlPezwgBR8sDfVn3UQg1LcyKDLoFQXKtGf4kQjf2Q88C/bD5qc7tVKfEPk1tTRnKLfR/iciVnL8SGghPKxngJAjsTpozX3qsQplPhhmovg0fsA6kaIvCMzYH77VBI4sHtTIO5ilwCiwlBuE9qOA6UMMHngzGNstCFcAj0LHtiFB47dgbwErDwXsAil141JzNomLVnuwmbqR4nuPnYfb2klAKhovHDdOOOS2EtG
 sGNhdGwF
 whdrJZRnTUB/Odq3zjc/lYACV+bqVFDQBtTdKznoWuZWVAS0sm1hZ7BlwhG1xfbmv4kYM3RHbfOgdLRp9yfzf78VaGmkDEdKLIIuhAevlDKOXqjakMvfp1ey3vbbPULSTwVGfVOuct9s4Llbowgz2DRTezpBfFP/5dVZ1v1Ln93XfXQpL38beVGDLT44U/mu00Vv0I91v7fPUgN7CFl2y9F6NnxhwKH/ubF4ZWcH9bSHqdQkVIPwTRNlE0I0AZwIMieZ2Tx3PVdNqOT/EehPTSBg/BDCMjUVWgMi99q7q7CLwpSyH4I3ZFGgrKNz8/ElqhqiDz4ChoIx+o0+ruBmS7v0WC+hJNHr+JdiGuNz08RuKLCiyrw6b7f/uub6P8KL2XCxlNmoFAumc9EB5V5L81QnBwB348+wsI1yaXp983vKdr8Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 13:37, Harry Yoo wrote:
> On Fri, Dec 12, 2025 at 08:10:19AM +0100, David Hildenbrand (Red Hat) wrote:
>> As reported, ever since commit 1013af4f585f ("mm/hugetlb: fix
>> huge_pmd_unshare() vs GUP-fast race") we can end up in some situations
>> where we perform so many IPI broadcasts when unsharing hugetlb PMD page
>> tables that it severely regresses some workloads.
>>
>> In particular, when we fork()+exit(), or when we munmap() a large
>> area backed by many shared PMD tables, we perform one IPI broadcast per
>> unshared PMD table.
>>
> 
> [...snip...]
> 
>> Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
>> Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
>> Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
>> Tested-by: Laurence Oberman <loberman@redhat.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
>>   include/asm-generic/tlb.h |  74 ++++++++++++++++++++++-
>>   include/linux/hugetlb.h   |  19 +++---
>>   mm/hugetlb.c              | 121 ++++++++++++++++++++++----------------
>>   mm/mmu_gather.c           |   7 +++
>>   mm/mprotect.c             |   2 +-
>>   mm/rmap.c                 |  25 +++++---
>>   6 files changed, 179 insertions(+), 69 deletions(-)
>>
>> @@ -6522,22 +6511,16 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>>   				pte = huge_pte_clear_uffd_wp(pte);
>>   			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
>>   			pages++;
>> +			tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
>>   		}
>>   
>>   next:
>>   		spin_unlock(ptl);
>>   		cond_resched();
>>   	}
>> -	/*
>> -	 * There is nothing protecting a previously-shared page table that we
>> -	 * unshared through huge_pmd_unshare() from getting freed after we
>> -	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
>> -	 * succeeded, flush the range corresponding to the pud.
>> -	 */
>> -	if (shared_pmd)
>> -		flush_hugetlb_tlb_range(vma, range.start, range.end);
>> -	else
>> -		flush_hugetlb_tlb_range(vma, start, end);
>> +
>> +	tlb_flush_mmu_tlbonly(tlb);
>> +	huge_pmd_unshare_flush(tlb, vma);
> 
> Shouldn't we teach mmu_gather that it has to call

I hope not :) In the worst case we could keep the 
flush_hugetlb_tlb_range() in the !shared case in. Suboptimal but I am 
sick and tired of dealing with this hugetlb mess.


Let me CC Ryan and Catalin for the arm64 pieces and Christophe on the 
ppc pieces: See [1] where we convert away from some 
flush_hugetlb_tlb_range() users to operate on mmu_gather using
* tlb_remove_huge_tlb_entry() for mremap() and mprotect(). Before we
   would only use it in __unmap_hugepage_range().
* tlb_flush_pmd_range() for unsharing of shared PMD tables. We already
   used that in one call path.

[1] https://lore.kernel.org/all/20251212071019.471146-5-david@kernel.org/


> flush_hugetlb_tlb_range() instead of ordinary TLB flush routine,
> otherwise it will break ARCHes that has "special requirements"
> for evicting hugetlb backing TLB entries?

Yeah, I was briefly wondering about that myself (and the inconsistency 
we had in the code). I would hope that we're good, but maybe there are 
some nasty corner cases we're missing. So thanks for raising that.


Given tlb_remove_huge_tlb_entry() exist (and is already getting used) I 
would assume that it does the right thing.

In tlb_unshare_pmd_ptdesc(), I am now using tlb_flush_pmd_range(), 
because we know that we are dealing with PMD-sized hugetlb folios.

And in fact, we were already doing that in case of 
__unmap_hugepage_range(), where we did exactly what I do now:

	tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);

So, again, something would already be broken there unless I am missing 
something important.


Looking at it, I wonder whether we must do the 
tlb_remove_huge_tlb_entry() in move_hugetlb_page_tables() after the
move_huge_pte(). Looks like tlb_remove_huge_tlb_entry() might do some 
flushing on ppc (and not just updating the mmu_gather) through 
__tlb_remove_tlb_entry(). But it's a bit confusing.

-- 
Cheers

David

