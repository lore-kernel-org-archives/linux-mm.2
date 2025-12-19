Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B538D78776
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE13E6B0088; Fri, 19 Dec 2025 09:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F016B0089; Fri, 19 Dec 2025 09:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991706B008A; Fri, 19 Dec 2025 09:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC176B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:00:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43C84B75E5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:00:04 +0000 (UTC)
X-FDA: 84236379528.14.807BC49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 467E1C0013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:00:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uxOhiDdn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766152802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7ShADuvrWbzYt9sJu/TL9RJ7Nx42fawQ60gJTlh+Zc=;
	b=Vl7nefZAFXhChkIOPiN54PfeAsF7mIsR/s58zWXk8lcwLgigIKomIybNOY2xTrNLeCPtMn
	yzF1AUR4zZxdurIPdnygD1C75uJTWKe8g5bNBiSmXnVDz0olAohRMMcm891/YksDbrYTN+
	bJNwYfyEn9ivcpG2/4PxiZ/n6XJOuWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766152802; a=rsa-sha256;
	cv=none;
	b=3xAZhb37J9z7HoZfwhk2x7avmVytdM617Wrb1xEaqcDaVJpPX6EMz2jKO4ObClF88bErZf
	b9AtiEpzQxZtHGE9X0zNeSXC3mLrjCwE8N07lLgRa4gSNuQixzRcYB1bht0SHQkf7UJk/e
	hPB1GrDj9t0afkhsYt5pHFdFGBNACOc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uxOhiDdn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1712B41659;
	Fri, 19 Dec 2025 14:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97208C4CEF1;
	Fri, 19 Dec 2025 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766152800;
	bh=JWaw934JDfHKlA5sInvUxyZBA437IYufIDK3wABOHk0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=uxOhiDdn5eNZtMqBuJSX4ivs/799liqB+DIx8GXZ5MehitAvEfEXlwvU0Z3T30ohy
	 7n/Tz90frJB1NvwJWfQ9cdDH7w1OK7iDT3YNnXrSPrCdhacEajjJscD8a5d/1lGyg2
	 b3E/Lo5yexghi+PacPVmA31lfSLDo0JR1YTUbKOFQBvuvWMmWzFunAWO2DaKiM12nd
	 dNiN9smTTqUXTDkIa2G2nX9yBGpdDMiUjy+M6BYrVZf09gFJbjPRsQxMlIo5B4zJGj
	 cEXr3TOPYu9w0FdmzB1aLgRpI74Uo8kfewMV6tRbVHr/zKVm7vdOonj0CIrzSsJ80E
	 +pI+sn3yhU1+w==
Message-ID: <3d9ce821-a39d-4164-a225-fcbe790ea951@kernel.org>
Date: Fri, 19 Dec 2025 14:59:52 +0100
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
Content-Language: en-US
In-Reply-To: <d5bf88d9-aedf-4e6d-b5a0-e860bf0ed2e4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: idaeq4ntmegscfdmkrmrezukmrbdm1wx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 467E1C0013
X-Rspam-User: 
X-HE-Tag: 1766152802-816243
X-HE-Meta: U2FsdGVkX1/N9SLuam70D669m+OxfRZYMK8+qS1VPjeNwSFeXnkiLIzLg0OBIP6aZKX2cFP797DiMi5PDHsijcy2Y0Y/N7IB8KnoeecaXnDd8Nvg63stCfXizrhHPvTiyBj2Z3It4UcsktdQNT+RLd+WnSzlh7olwwojWg32vT7pHabSadhgQGUyydse+PGqEOVKX2oYa7HePJ9nffyb8hQBF2li4m7fstBjcRPqq+ef4rBkBbYbbJYVq+Uko9799f6kruQGca50auNfN1gImG7wm5aW50b7QABEHoEEn7fGw+3qSrzf9v9TgE/P/OSUMyyxaRXlIOD4UJJmcQuLFyQaV5WJ5VHwgsg47GpMtuh3MD7eqqhyb20K1VpeAHhb+nrf4A2qrIvBhqz/vosM1nL9ICWePh5zk4jRXTwIzUHZAhqj0nvs0oVkFffOA+O0VDiK+62lcROEkluNyLSvuC1x1orHNxcNxoZlgM4BEM9G9fop5EpZrD1niPLLN/oDLqHQPvkABE5OP647fcPXAmFiGE23STHYg2mremAhIBov7+mw2eV3OMgvUnHZ9O3hXsmkxPVQAIpdwU5whxmN0xBgFiADONMg6vH7ZZN8S+8vtqyDnWF3fse7c7jnQD2PwR9tmglmymJKy64SQo11YjXfOUpmNmjT+hKTRnxNAHs3vPQ+W4ACZfs8XItsLWRHXalO2Vx0oGz4enT+aF936/Uy+veEL1rxxhaGtk9gEB2bN3X4YFgd4noIUUVeJjqo4NUgb44MLCdag+DoedEJ0Tgn1VCFB5n2fzUdZzCatakOQKy5mso5UTdIpA+GdxY+cvVcB9RlS+RlHPepRFKjSO3I1ODuW6DJbbXvGW20wjGWKdqJv9LnN/4ArPNkD2Rl37m3ku9lXH/TjWwtsw80bZA9jlYs2eqQLCHetvFwRqxTyN+F78ShfahN7U4nGCgYgm6jldF3GsW11UDNgmT
 WnT0S3Wf
 YohfGZSTqsBdzfKKMmzveHfpmSYfY1qymbcp4Rn7MsJNW8PA8BlVBj3RnItfc+Gjc+6TAFonRK99YQh2H8MnU4tjnR4U+AnUAzlxeLC8kIJuwfxE+KDPkoiu6t0WadamPYvCDDDXzd3ZTlP7X0TGSAITRX8IEPkFp3bqTbLQ8etq9pOhKN343NUqd4djJ0z7Q7HbmF1Fm75I8DmMf763Q4lNgekmNFQQzzfx2+5nfNi7iSm8Gf8UV2KVmAG3MBa6VUKY07IBvUx+Bf+kznlehH5mkkvinoz3WOX0l7VV4P6S1HAb4H2L8kiihyAIfkwuENFolzQmcePdZGBvlFhD15GRBqg5wopqjR1frdICOxwxkduATuc6Vgy8m5jcmLVuaGARB9hgavOyPM+yJ1WICweWWydlxIrJy3B9Wpl4QWBkBqlw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 14:52, David Hildenbrand (Red Hat) wrote:
> On 12/19/25 13:37, Harry Yoo wrote:
>> On Fri, Dec 12, 2025 at 08:10:19AM +0100, David Hildenbrand (Red Hat) wrote:
>>> As reported, ever since commit 1013af4f585f ("mm/hugetlb: fix
>>> huge_pmd_unshare() vs GUP-fast race") we can end up in some situations
>>> where we perform so many IPI broadcasts when unsharing hugetlb PMD page
>>> tables that it severely regresses some workloads.
>>>
>>> In particular, when we fork()+exit(), or when we munmap() a large
>>> area backed by many shared PMD tables, we perform one IPI broadcast per
>>> unshared PMD table.
>>>
>>
>> [...snip...]
>>
>>> Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
>>> Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
>>> Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
>>> Tested-by: Laurence Oberman <loberman@redhat.com>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>> ---
>>>    include/asm-generic/tlb.h |  74 ++++++++++++++++++++++-
>>>    include/linux/hugetlb.h   |  19 +++---
>>>    mm/hugetlb.c              | 121 ++++++++++++++++++++++----------------
>>>    mm/mmu_gather.c           |   7 +++
>>>    mm/mprotect.c             |   2 +-
>>>    mm/rmap.c                 |  25 +++++---
>>>    6 files changed, 179 insertions(+), 69 deletions(-)
>>>
>>> @@ -6522,22 +6511,16 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>>>    				pte = huge_pte_clear_uffd_wp(pte);
>>>    			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
>>>    			pages++;
>>> +			tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
>>>    		}
>>>    
>>>    next:
>>>    		spin_unlock(ptl);
>>>    		cond_resched();
>>>    	}
>>> -	/*
>>> -	 * There is nothing protecting a previously-shared page table that we
>>> -	 * unshared through huge_pmd_unshare() from getting freed after we
>>> -	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
>>> -	 * succeeded, flush the range corresponding to the pud.
>>> -	 */
>>> -	if (shared_pmd)
>>> -		flush_hugetlb_tlb_range(vma, range.start, range.end);
>>> -	else
>>> -		flush_hugetlb_tlb_range(vma, start, end);
>>> +
>>> +	tlb_flush_mmu_tlbonly(tlb);
>>> +	huge_pmd_unshare_flush(tlb, vma);
>>
>> Shouldn't we teach mmu_gather that it has to call
> 
> I hope not :) In the worst case we could keep the
> flush_hugetlb_tlb_range() in the !shared case in. Suboptimal but I am
> sick and tired of dealing with this hugetlb mess.
> 
> 
> Let me CC Ryan and Catalin for the arm64 pieces and Christophe on the
> ppc pieces: See [1] where we convert away from some
> flush_hugetlb_tlb_range() users to operate on mmu_gather using
> * tlb_remove_huge_tlb_entry() for mremap() and mprotect(). Before we
>     would only use it in __unmap_hugepage_range().
> * tlb_flush_pmd_range() for unsharing of shared PMD tables. We already
>     used that in one call path.

To clarify, powerpc does not select ARCH_WANT_HUGE_PMD_SHARE, so the 
second change does not apply to ppc.

-- 
Cheers

David

