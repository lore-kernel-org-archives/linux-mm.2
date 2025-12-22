Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C6DCE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B696B0088; Mon, 22 Dec 2025 05:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7100F6B0089; Mon, 22 Dec 2025 05:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB026B008A; Mon, 22 Dec 2025 05:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6AA6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:10:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 199A7C149A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:10:42 +0000 (UTC)
X-FDA: 84246687924.03.BBFE1B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 395AEC000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:10:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glwFxBeJ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766398240; a=rsa-sha256;
	cv=none;
	b=f4InOkvnAMyBjh1/e7n1xqUuQwa4XJuivQQM3iJ/Sl+Lpru1Uoq1YLF5b56U8H5fiH3ySI
	DvZ+C76j0UM/IQB/6Iw7Vdu431tJa79h+toLXOM8D6ZtJ7XCp0n6FGpNmkeyjnlditYgFZ
	845GrJqNylSXwgWHn96vv0tNsir2vw0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glwFxBeJ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766398240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1L2+dMs6XM8R9PBN3KFS9SU6ZPxzdqK4PvbofUALcIw=;
	b=E7W7acn8BsRPYgutwHTev1a8PpihvjXYCZvok2ZEPRU9h4JnP/R62FAv/JCukFCeLoeVtt
	pD2FBEmq7CE8/zULyWqoAgBDEoTLXOJwrwfNXgZzweWc7W1rQ/8ohp2UT8CzbuianTnbqH
	hiCGIoggYyUjGpN9JT5LCPvQHpN1MFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14A8A41B70;
	Mon, 22 Dec 2025 10:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1F7C116D0;
	Mon, 22 Dec 2025 10:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766398238;
	bh=oqvDU7EcxPgLIt7kqJ6tUYvc7fh9oOd7r5g2Qh/KjTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=glwFxBeJHfy/Hxw8E0IhkNQF2D75sUaWPBU97dBGqQz6RmNddi4AuNDGVRXl11MW5
	 /2XRcRjtcuW+PNO3XYgXDly/+1nqW71Z8wNkiivCJ3Jg7vi/qaEUg8J4toGx7nqkkz
	 RC2z+fWsSeanfTQwGH23Y6Vf5tNpm4TWdbplzUT0YtbQ8eTMrchSyhXYxYhA/YeQFZ
	 OPRiIuCw/OtPCmBpFpOqhk6zayMlQB8WgR7rXpsqEZFJyUY/Z+c80MqXHtj/CR8vcF
	 w1ay/Q/COiczt1kmwNYCUFJSSQcNJyIAUj3oSuM1C7TYwA6NT4ooYHb4wIaUUIsZFD
	 XSI866D9bbWPg==
Message-ID: <c66cb4e4-820e-419a-ae9f-efd2c15aa570@kernel.org>
Date: Mon, 22 Dec 2025 11:10:32 +0100
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
 <d5bf88d9-aedf-4e6d-b5a0-e860bf0ed2e4@kernel.org>
 <3d9ce821-a39d-4164-a225-fcbe790ea951@kernel.org>
 <e78f5457-43fb-4656-ad53-bfda72936ef5@kernel.org> <aUioS4dkTrKgsHGP@hyeyoo>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUioS4dkTrKgsHGP@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 395AEC000B
X-Rspamd-Server: rspam04
X-Stat-Signature: se6scqcki6ozwpjg3w3pg6meq7eff5pu
X-HE-Tag: 1766398240-920861
X-HE-Meta: U2FsdGVkX1/H3b5s/5uNvSRngFmB57pYrCeJRHfKXTs4Ri9npgLfFqDWXxGlRRjUwqUHffbMl+LgzsxVgwC8fS7nPXMUvDMNeVoqzdO6XA9SOAjHK+NritFO4raZTG9K17C1hxHZINafO/sIg3YpSb4Gh60kUaJp7+QU3gT7XFStmvaGoVfyoZaZT/OGDnMqTVuGVjqxkO0BSBo6TlENCY3VccycC99ttkZWlMA3pVNt6JeNktgjJ2J9nXBUX9Bwj+7DQOCQYBRniDLWXyMEWenVC1WaRuwJZpbFpWGJtYySqIyrFip9ipISzO1yVCwuzfO8sjpmPVvzk8fgh5dkz3jVPVxgAlWL+sJZ0uUx1FxBf32bE4ngW+E+CWxnXh+zj8VrX5W4iuEVJUnuvSb8WtXm1Yy1VnjAnZJsWTZPAD3q0dvTSvqtMbxFn5DzJUvlxVS9x4EsqHlVGxO9wf1957TUMUjOA7fUbOjOMg0QPyd7mWC+nwgBEXZsa3GWLO+wySzwEpphg+f+yqyOCNcZbfpCuRzHhF0qZsPjtbqV/jYTmD+60V1RqNmZfSSKNZbRIwOCyApQuEk22ZfKegzL/X36F+4z/H2CO7G6kj7YhNGkFiFF8kK9KUsu/0OxaX4ILITpytIfb+prqzH4pRhjIWe+7AK6JVw5c1F+Qt3cPaMUHhOSx0ED6LVJDS7YyTZZV0MTYGSJMtVUwdds9lie++XWr143HEaj34dwdtI9Cekh2LFgw8u2y/Ums6e4rA9xMLc48JoMfDKsAJEAHB6zwhVG8/y2YZAw1iwrRXO5FG14AMmYAAOF/c1zF/n81WR1quEGYiX+qJ31Wn4PeB4ZkY09Wu9f5DOYifqsc4BUX84W5ioTdfUFcg49Oqhks6jr6VGQAoFWWhggbsOwE7LWSuGw/KUJM28ILG0gxKABl5ypZI7EFJNGK3muVWLCVkqTb5hrhcJ/0RqesCh3cV/
 6KNT3Hil
 tVMISerSdXfH4MQ+p6BF1HNu2QYx/SpLxFce8t8sxIBpzl/vnuoaoSZPC3dCh5OpXUDKHQJhYJVg8pQbg/3HcM+Ks/G1xeS+InGYSu8tt41SjXltU5gfGcOlBhS/g0Z9uvwwbXw2EMjxIxzP2QHcHkDv/9PFpapha9T/3Ou2YmzqWyoMRgAmarA/8h/wB8KZ+Z9BYhMK2ztUZPG+Zt7Nc8M+UBx8FPbxTedrNKn18ReUjMBujXyj2dOCLXPuuJ4hIH8epw1F3N4qUA3Mq6EliJ0su7NoMugTQTmbDHPg4URmJPZgKI/e82X7NWwx6GFpgeWqly3UC/ZXYsQMz19WenGrl9/IaB/C2p6stOukw0jHgd0pkguhUjgmE0BjPlU2TcroXt62gLemV/Xf4jZRcouxMqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Okay, the existing hugetlb mmu_gather integration is hell on earth.
>>
>> I *think* to get everything right (work around all the hacks we have) we might have to do a
>>
>> 	tlb_change_page_size(tlb, sz);
>> 	tlb_start_vma(tlb, vma);
>>
>> before adding something to the tlb and a tlb_end_vma(tlb, vma) if we
>> don't immediately call tlb_finish_mmu() already.
> 
> Good point, indeed!
> 
>> tlb_change_page_size() will set page_size accordingly (as required for
>> ppc IIUC).
> 
> Right. PPC wants to flush TLB when the page size changes.
> 
>> tlb_start_vma()->tlb_update_vma_flags() will set tlb->vma_huge for ...
>> some very good reason I am sure.
> 
> :)
> 
>> So something like the following might do the trick:
>>
>>  From b0b854c2f91ce0931e1462774c92015183fb5b52 Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Date: Sun, 21 Dec 2025 12:57:43 +0100
>> Subject: [PATCH] tmp
>>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
>>   mm/hugetlb.c | 12 +++++++++++-
>>   mm/rmap.c    |  4 ++++
>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 7fef0b94b5d1e..14521210181c9 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5113,6 +5113,9 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   	/* Prevent race with file truncation */
>>   	hugetlb_vma_lock_write(vma);
>>   	i_mmap_lock_write(mapping);
>> +
>> +	tlb_change_page_size(&tlb, sz);
>> +	tlb_start_vma(&tlb, vma);
>>   	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
>>   		src_pte = hugetlb_walk(vma, old_addr, sz);
>>   		if (!src_pte) {
>> @@ -5128,13 +5131,13 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   			new_addr |= last_addr_mask;
>>   			continue;
>>   		}
>> -		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
>>   		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
>>   		if (!dst_pte)
>>   			break;
>>   		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
>> +		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
>>   	}
>>   	tlb_flush_mmu_tlbonly(&tlb);
>> @@ -6416,6 +6419,8 @@ long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vm
>>   	BUG_ON(address >= end);
>>   	flush_cache_range(vma, range.start, range.end);
>> +	tlb_change_page_size(tlb, psize);
>> +	tlb_start_vma(tlb, vma);
>>   	mmu_notifier_invalidate_range_start(&range);
>>   	hugetlb_vma_lock_write(vma);
>> @@ -6532,6 +6537,8 @@ long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vm
>>   	hugetlb_vma_unlock_write(vma);
>>   	mmu_notifier_invalidate_range_end(&range);
>> +	tlb_end_vma(tlb, vma);
>> +
>>   	return pages > 0 ? (pages << h->order) : pages;
>>   }
>> @@ -7259,6 +7266,9 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
>>   	} else {
>>   		i_mmap_assert_write_locked(vma->vm_file->f_mapping);
>>   	}
>> +
>> +	tlb_change_page_size(&tlb, sz);
>> +	tlb_start_vma(&tlb, vma);
>>   	for (address = start; address < end; address += PUD_SIZE) {
>>   		ptep = hugetlb_walk(vma, address, sz);
>>   		if (!ptep)
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index d6799afe11147..27210bc6fb489 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2015,6 +2015,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>   					goto walk_abort;
>>   				tlb_gather_mmu(&tlb, mm);
>> +				tlb_change_page_size(&tlb, huge_page_size(hstate_vma(vma)));
>> +				tlb_start_vma(&tlb, vma);
>>   				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
>>   					hugetlb_vma_unlock_write(vma);
>>   					huge_pmd_unshare_flush(&tlb, vma);
>> @@ -2413,6 +2415,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>   				}
>>   				tlb_gather_mmu(&tlb, mm);
>> +				tlb_change_page_size(&tlb, huge_page_size(hstate_vma(vma)));
>> +				tlb_start_vma(&tlb, vma);
>>   				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
>>   					hugetlb_vma_unlock_write(vma);
>>   					huge_pmd_unshare_flush(&tlb, vma);
>> -- 
>> 2.52.0
>>
>>
>>
>> But now I'm staring at it and wonder whether we should just defer the TLB flushing changes
>> to a later point and only focus on the IPI flushes.
> 
> You mean defer TLB flushing to which point? For unmapping or
> changing permission of VMAs, flushing at VMA boundary already makes sense?

Defer converting to mmu_gather to a later patch set :)

I gave it a try yesterday, but it's also a bit ugly.

In the code above, primarily the rmap change is nasty.

> 
> Or if you meant batching TLB flushes in try_to_{migrate,unmap}_one()...
> 
> /me starts wondering...
> 
> "Hmm... for RMAP, we already have TLB flush batching
>   via struct tlbflush_unmap_batch. Why not use this framework
>   when unmapping shared hugetlb pages as well?"

Hm, also not what we really want in most cases. I don't think we should 
be using that outside of rmap.c (and I have the gut feeling that we 
should maybe make use of mmu_gather in there instead at some point).

Let me try a bit to see if I can clean the code here up, or if I just 
add a temporary custom batching data structure.

Thanks for bringing this up!

-- 
Cheers

David

