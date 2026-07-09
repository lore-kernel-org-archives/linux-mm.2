Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDC4C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8016B008C; Thu,  9 Jul 2026 08:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080BB6B0092; Thu,  9 Jul 2026 08:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7AE6B0093; Thu,  9 Jul 2026 08:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCEFF6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53188140132
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:16:00 +0000 (UTC)
X-FDA: 84969134880.15.A43E4A3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2B0D840007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:15:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=R4qFR0FM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783599358;
	b=LAZo6owPn7pb7aqNc4xSWiqX8wA925GjyTnz+VbemP/KQJ0bnrqwRYNy+y9ll423jZLrTh
	z9ZeG1lceU6WDr0FN/CSt3FlqsS4iDH9N34nXXX4UrHbxfwKEF4W3N8GnGP1W0+oOnD4Xr
	r1kLmVdL4WD07K0m2CZPHpqr/mwwwsk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=R4qFR0FM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783599358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88kV4HfR1185aTkG45rZZZg0jddTT2S6lRq+KwfdmVE=;
	b=Yb/x4GWOpspOP8+8jJzdN1b6WyOa/W/VfPGRP8GIF4bJUsQWQ1V6auHTBYYZTNUJhfgc/r
	Ii5ERHnDLN4AiIbm5EbEE7utvteEV/d44RO5aVO4iDC4M5t4CooMZrpgbBEeNBsJFhGWQt
	yXxUYmRZoz11XIt+U8INe4mG8TyqZ+A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDB18339;
	Thu,  9 Jul 2026 05:15:52 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C2CB3F66F;
	Thu,  9 Jul 2026 05:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783599357; bh=IiF9dWRN6boDvkLte3SrbvOcX2fLTJgXBzATqAbDt+o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R4qFR0FM1ZNI+D0C/oVCOd8coJP/Y4A1nd/z90kUv/RUHoAnjtB29R4suUDiOQB1P
	 9GmrVHgFbQ8rBxBkifej+aTk10lPpH4YCpOBtSVBabZKF2TkWIN2xRedfqopQP0DV3
	 mc+AxnhAHaEHzsh5JGxYoZqWCM4PFPKy9gXLJTtA=
Message-ID: <b712fafe-1744-4128-be36-4c83895dbe3d@arm.com>
Date: Thu, 9 Jul 2026 17:45:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-3-dev.jain@arm.com>
 <a54ca48f-c776-4b4a-9697-1c2170cb420b@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a54ca48f-c776-4b4a-9697-1c2170cb420b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2B0D840007
X-Rspam-User: 
X-Stat-Signature: cgcwkcu514mf6pm5bzdwgpgjnw7zkx4i
X-Rspamd-Server: rspam03
X-HE-Tag: 1783599357-565573
X-HE-Meta: U2FsdGVkX1+aanjbHUu4QBfpaCVx8i29SHFs2yNd3ZkGtLEPivODdkvQ746r2PgwuRUOqdt6bsNvgAqf00wMx+Ji+5t8idGVX6mjHS9vTm4bW0wy1gsF2v8TeJ9UzZFRpXBUzyyNjNr6zFidYTeSY57auAY9eidgPqeZl20oXBAEcmPZslRI6fZyfoC2l/85qrHkFGBc/cIBIvg4Fi65jeSVObtJ7lCG8FuJ5A+UOXUH7BNvUTcjwWY26J5xaINkpNdA1Fqp+uqtHi0QBugj7Uf6lLGvIUyCE4NkLzs0fl5muxakt4H+agIiWm2xhPI3+9Zc5DTvvvQlUAt/0JpcrF64Htt1lK5hZ1vo5uK1Im2OcnKPzd0akc90UF0rmN0zFokdJ3sDmzZ4jj2YkCxZyGXm7jFuJzjOn5mVXGnMP6T1ilP5obO9GUWrwja/gT22T2nZoPsEEivZLxbjc8oUFZciMSx/6ow2kZY2IIgDAWHRwBA6hs6gOEPBOPNsJ64hJV9XH707Y5CuthybbLgOBkSDBaWGaHA3dZtqvbFqViJE12u937aJn0yd2OuLGVlk4RJyWEN4MpIR4XmAOeeJwIO3kCBmXOn7dBExiFh9t1jhGbixm8oSSlFlgJwoOs7qmGL4SHfC224y2dHPomW1h2WHFuaVoxmvDmr2UdbO4bUbkVyAD2wpL7aqY6mkfkoNOMLoNN2STqa//x2GeAmVvI1M1NU5jwCa3ykpKUjLCUXoGwLAwf38TUKMUpekThYC6+DfN7bP9ICks7u21LB+hiEe2/rRn0VnFDT4CgbnJq649UwNHwY2JiYFJk2nAAR6+uUMWDe7tRWOoGkpViE8jH5LZlzMp38FX0beex00fyFqySzh1S+2Puwu0vjSxhg2JnMb75bhgkSDykaczcEdGvOlwpVoP2jE/1eaX5uPNrzD5Ft3ZH07/ipz9ExQgK+YmN+tMX5I6RkjpAw0Rc7
 KudbWVmw
 D68v9yESeVO3xq7VasfdkTXcrOeiGsl85+zckqGNUX4WebYvt1kG2p9Iou354F2iQU3GWTCIJG6ChfY8LIUl55+BhQaanltSm6rGcNtUpwtkpXtoTgqgTaK4mKy39uoBlx0LjU1lZwokxdJlCFXCSHedPYrQ4GQKb+svdBNDBbptukovkkRDuXKCjbplX7WEXpl1cvdXTdxj9OlAMztSif86/PB/NB05J/0GTX/RMRonoIbWX+WwgLuXU8AeYhWmW1I9QH7bRHIdthdl7lfFuRMMOq/cwdTle223Gg4dPmdC668G1QCFC67gCGFrH5RTfLiN8clx09Sx09obHGEjImMljLZh2kM+2DB5sgray4E2QT+IaBGTWmHBkYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/26 7:45 pm, David Hildenbrand (Arm) wrote:
> On 7/7/26 14:11, Dev Jain wrote:
>> Simplify try_to_unmap_one() by separating the hugetlb parts into
>> try_to_unmap_hugetlb_one().
>>
>> To understand the correctness of the refactoring, the following points
>> are noted:
>>
>> 1. try_to_unmap() is called for hugetlb folios only when they are
>>    hwpoisoned.
>>
>> 2. A hugetlb VMA cannot be mlocked.
>>
>> 3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
>>    and that mapping points at the head PFN.
>>
>> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>>    hugetlb folios are never swapped out, migration entries will be
>>    skipped (PVMW_MIGRATION not passed), and device-exclusive does not
>>    work for hugetlb.
>>
>> 5. The hwpoison entry is constructed from the poisoned folio, just as in
>>    the pre-refactor code. Any previous uffd-wp state is deliberately not
>>    preserved for the hwpoison entry.
>>
>> 6. TTU_HWPOISON is always present; for it to not be present, either the
>>    folio has to be in swapcache, or mapping_can_writeback() is true (see
>>    unmap_poisoned_folio), none of which is true for hugetlb folios.
>>
>> 7. Hugetlb uses separate counters from normal rss counters, therefore
>>    update_highwater_rss() need not be called.
>>
>> While at it:
>>
>>  - Change VM_BUG_* to VM_WARN_*.
>>
>>  - Do not declare variables which are only used once.
>>
>>  - Use huge_pte_dirty() instead of pte_dirty().
>>
>>  - Add 3 VM_WARN_ON_ONCE asserting that TTU_HWPOISON should be present,
>>    pte_present() must be true, and the pfn derived from the huge pte
>>    must be that of the head of the hugetlb folio.
>>
>> Except the BUG->WARN change, no functional change intended.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/hugetlb.h |   1 +
>>  mm/rmap.c               | 177 +++++++++++++++++++++-------------------
>>  2 files changed, 96 insertions(+), 82 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 4115076e4922a..bf7e163e3779d 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -1271,6 +1271,7 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>>  }
>>  
>>  pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
>> +unsigned long huge_pte_dirty(pte_t pte);
>>  
>>  static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>  					  unsigned long addr, pte_t *ptep)
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index dbb077f8443e3..934773dfa2f2a 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,95 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>  
>> +static bool try_to_unmap_hugetlb_one(struct folio *folio,
>> +		struct vm_area_struct *vma, unsigned long address, void *arg)
>> +{
>> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>> +	struct mmu_notifier_range range;
>> +	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	const unsigned long hsz = huge_page_size(hstate_vma(vma));

Okay I'll move this to the second place. I would prefer DEFINE_FOLIO_VMA_WALK
to be the first declaration.


> 
> I would move const variables all the way up.
> 
>> +	bool ret = true;
>> +	pte_t pteval;
>> +
>> +	/*
>> +	 * The try_to_unmap() is only passed a hugetlb folio in the case
>> +	 * where the hugetlb folio is poisoned.
>> +	 */
>> +	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
>> +	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
>> +
>> +	range.end = vma_address_end(&pvmw);
>> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>> +				address, range.end);
>> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
>> +	mmu_notifier_invalidate_range_start(&range);
>> +
>> +	/* There is only a single mapping in a VMA. */
>> +	if (!page_vma_mapped_walk(&pvmw))
>> +		goto range_end;
>> +
>> +	address = pvmw.address;
> 
> Will address ever change due to the page_vma_mapped_walk()? I don't think so, right?
> 
> So this can instead become a VM_WARN_ON_ONCE, maybe?

Yes you are right. address is computed from pgoff_start which for hugetlb folio will
always be aligned.

> 
> 
> 
> Nothing else jumped at me, much clearer to me.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


