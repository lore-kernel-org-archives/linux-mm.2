Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40ACCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 10:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96BF6B008C; Wed, 14 Oct 2026 06:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C479B6B0096; Wed, 14 Oct 2026 06:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EE96B0098; Wed, 14 Oct 2026 06:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9024A6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:52:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 235B6404BB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:52:28 +0000 (UTC)
X-FDA: 85320917976.27.946C985
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5B0EF20008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:52:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALUatxx7;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791975146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A40pvqxsAljXMht0uJoUDXzF1WEP0B00UO/a2qcSq5c=;
	b=LN5eruNtAt3GjtyyBGLVkx1Wng0Nojcl6D/FGdiir88qtRFga0MeVhpyuaBxIq4QwGZONg
	CHZxxTuFNeC0zOaOJUZ5eLLJk4+dmWGxY97wHQg1yaaY36qBKLskGIGlczyIBqF8MkVpvB
	qtbCcw/VNMvDXaDvS2l+nF1+f4TwZnw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALUatxx7;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791975146;
	b=5lbS3nYaDCTL2xfc7FKAj47zu/KdxQ+GOem1+y9CI2uoMoRmBapuB9xy6mHNeCgdfkXW0e
	S/kGofhidonV2yGXyST/+NdkElFkgp4ibtfgLJ5lShts+raV79Ac3ebez3KeJyVRb3RozE
	GWSXd6w8p2DsEHpuYBqMcUzOVxySMNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6924E42DB7;
	Wed, 14 Oct 2026 10:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462021F000FF;
	Wed, 14 Oct 2026 10:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791975145;
	bh=A40pvqxsAljXMht0uJoUDXzF1WEP0B00UO/a2qcSq5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ALUatxx7upV3SZkfTnvX3IgE4XE+F0RxjUatM7WzbYQ58SeOSupRbXZp9Rs4KDDqb
	 Yx8oUW/jtDikFJHSuTlvN5n3Q9pyBZundVS5MQjW9e5SRXjsayfxpDyQOihfdJ3GUn
	 6Kchw16CYAjiKisdIGTDFi2pxpgtZYYmARcaI9bkxGSkpSJOpGXTm0umd7ZSo+Veto
	 44qiHVrdUirbmIKKUdfVmndXENVDTLdDTTCwJISfk/mjIxWaSgfkCZsgftHVFkvODn
	 fZXUrTMrkJG0nntGG7Mp/FpI/H/aA6k8pY/fBEgtvemb/M3i43UYGXt3JoMgavGHYU
	 gWgh4rgFHLPXg==
Message-ID: <fedff1b6-0522-4398-a0d4-d4111a570159@kernel.org>
Date: Wed, 14 Oct 2026 12:52:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
To: Li Zhe <lizhe.67@bytedance.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
 <arzVaC2IYkqSb0_U@gmail.com>
 <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
 <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org> <asjVUa6XBZ8ti-0_@gremlin>
 <70ea8ee6-6fc5-4209-8cee-362da37f5035@kernel.org>
 <86de1ee5-be14-4123-b372-b4691cea8e67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <86de1ee5-be14-4123-b372-b4691cea8e67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B0EF20008
X-Stat-Signature: e4t6fo9yys4a3c4ni7sjss37kjt3kuuy
X-HE-Tag: 1791975146-850180
X-HE-Meta: U2FsdGVkX1/QVV6YI29oP86dOKIqZnG49CP9WVz0yuj+BYDVASOCr8ykGhTOMbkrr9n64nri7t/FtpnI6vLTM5QEjfv50+EPmYVnP6+JoRA2/eBEGYmEIiSWPuMa6iOWhznGSorIUdugex2CpRiyGDYANcHs+8nPTSXwpc14QXsWO58uOb6efjJ/+7i/1WTf2Mv0eeQXRSjz2rO2N/WNlcNMpcTr3JvlEGXl1YjGL+ysla3vG0T+u59+h+CMpEH71FWokz7b+DMgbUpab39eirl24oTUO4Djdg9wzoijU4VDXAeJoRD4yLTqoY7UkDmJz2FCzrj9WazIN8mut/fG2SjmJu6is8YVsEi35bVKnkjUxzo6P7WXfY1XbFabx0Gzubw8txKnfv8vQx2P5NbpjiKfwi441lmvfWUrUvYpYYLUz+5GZ9gZN9J2rvgRQR3NSAjcLux4LlfzUUKv9lYXwEM4IMsXhUhpZbHZPd2YZun97+NTwK9M6DnQJGUfLRH5uAQue43voqb54AOhE9ijAUnUJcGhu9LbRFphyLTLQqkwBEaU7cMSY5N7UiRpxvS/aVkuljCsZmz18M1Y9TG9LQt/tGIfEmXn/angjMOb6jaztt4YqVQXOqPDU5C/ThjEvIzOOZXzdc4ihX9Wcx6Bq799EO3sDfgnRdHo3hxKKgGg/3+jMGVdUiQmag656L1KX5H0plhxnzq5/TP1rN9HZKQZKpg07Ab1e9ahg8RXRjHrRjBee5Z7kRQcbBpORFDhh6T4uOM7GVansQLxoxmPEKJ8STWLdB1l7UOb7NQ6tk98JwiETghZOkxEQp9duDTXgi/VWy16cIJ5DFaamVMX9QR1fLWt/E9OV8FxPbecxoPm2QLfN+d0T+EjwtIW5/gXOTT8yBrNc6RKBqowBflLBC6ujzfJ1eVs8gN7/Bdsaq0XTU8kGrmpaPhAfZxuftgLBkRUSToAcK8Rw1X6a0i
 skEECQZK
 xA2rOpPvmk4oVu2ucRNI7G/akyYNqeMPsiI1H76Na4fbLhlLWGeska718dRja8+wdW0860MYfWbJ895Li9fpm/gOxKPlSatYhn3RLtZobLd96f16s0eMIH73BDqCi4kRTwxnZCTNa7RfEHV+xXY8brSV7RBPxhtwRRuKsPKRCHpi00PHWhv3IGfifaot3Q4kWp79LMM8NV2y5pLUZSrdNl4u95OJUO91pd21mNwsICpxY8oN0UEVOPFy7tSz6pHRGIBf4Li1U+oHSDuaK/GjYP/gJTskrX78KyAbsB6a1j/VjhGQX6+MJXc4MvSrwkxevobgKvz4ZhcCgGQ1hzD1B8+fEMbl1MVG9Hf+9/4q45v0f0cY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 08:39, Li Zhe wrote:
> On 10/10/26 2:05 AM, David Hildenbrand (Arm) wrote:
>> On 10/9/26 13:52, Lorenzo Stoakes (ARM) wrote:
>>> Yeah I don't see why not! I don't think there's anything that needs to be
>>> private here.
>> Li, see below, can you work with the below?
>>
>>
>> ----8<----
>>  From 9e1c0676ea6c9cbcabf91cd8badf81a9d88fd3ef Mon Sep 17 00:00:00 2001
>> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
>> Date: Wed, 29 Jul 2026 18:33:08 +0100
>> Subject: [PATCH] fix
>>
>> ---
>>   mm/hugetlb.c | 103 +++++++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 79 insertions(+), 24 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index e93c4d2456aa..88ff2c4ad483 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5077,6 +5077,79 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
>>   	spin_unlock(dst_ptl);
>>   }
>>
>> +/* Returns last address processed */
>> +static unsigned long prealloc_or_move_page_tables(struct vm_area_struct *vma,
>> +		struct vm_area_struct *new_vma, unsigned long old_addr,
>> +		unsigned long new_addr, unsigned long len, unsigned long sz,
>> +		unsigned long last_addr_mask, struct mmu_gather *tlb,
>> +		bool is_prealloc)
>> +{
>> +	unsigned long old_end = old_addr + len;
>> +	struct hstate *h = hstate_vma(vma);
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	pte_t *src_pte, *dst_pte;
>> +
>> +	hugetlb_vma_assert_locked(vma);
>> +
>> +	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
>> +		src_pte = hugetlb_walk(vma, old_addr, sz);
>> +		if (!src_pte) {
>> +			old_addr |= last_addr_mask;
>> +			new_addr |= last_addr_mask;
>> +			continue;
>> +		}
>> +		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
>> +			continue;
>> +
>> +		if (is_prealloc) {
>> +			if (!huge_pte_alloc(mm, new_vma, new_addr, sz))
>> +				break;
>> +			continue;
>> +		}
>> +
>> +		if (huge_pmd_unshare(tlb, vma, old_addr, src_pte)) {
>> +			old_addr |= last_addr_mask;
>> +			new_addr |= last_addr_mask;
>> +			continue;
>> +		}
>> +
>> +		dst_pte = hugetlb_walk(new_vma, new_addr, sz);
>> +		if (!dst_pte)
>> +			break;
>> +
>> +		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
>> +		tlb_remove_huge_tlb_entry(h, tlb, src_pte, old_addr);
>> +	}
>> +
>> +	return old_addr;
>> +}
>> +
>> +/* Returns true if preallocation succeeded across range, otherwise false. */
>> +static bool prealloc_hugetlb_page_tables(struct vm_area_struct *vma,
>> +		struct vm_area_struct *new_vma, unsigned long old_addr,
>> +		unsigned long new_addr, unsigned long len, unsigned long sz,
>> +		unsigned long last_addr_mask)
>> +{
>> +	unsigned long old_end = old_addr + len;
>> +	unsigned long addr_end;
>> +
>> +	addr_end = prealloc_or_move_page_tables(vma, new_vma, old_addr, new_addr,
>> +			len, sz, last_addr_mask, NULL, /*is_prealloc=*/true);
>> +
>> +	return addr_end >= old_end;
>> +}
>> +
>> +/* Returns last processed address. */
>> +static unsigned long __move_hugetlb_page_tables(struct vm_area_struct *vma,
>> +		struct vm_area_struct *new_vma, unsigned long old_addr,
>> +		unsigned long new_addr, unsigned long len, unsigned long sz,
>> +		unsigned long last_addr_mask, struct mmu_gather *tlb)
>> +{
>> +	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
>> +	return prealloc_or_move_page_tables(vma, new_vma, old_addr, new_addr,
>> +			len, sz, last_addr_mask, tlb, /*is_prealloc=*/false);
>> +}
>> +
>>   int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   			     struct vm_area_struct *new_vma,
>>   			     unsigned long old_addr, unsigned long new_addr,
>> @@ -5088,9 +5161,9 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   	struct mm_struct *mm = vma->vm_mm;
>>   	unsigned long old_end = old_addr + len;
>>   	unsigned long last_addr_mask;
>> -	pte_t *src_pte, *dst_pte;
>>   	struct mmu_notifier_range range;
>>   	struct mmu_gather tlb;
>> +	bool preallocated;
>>
>>   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, old_addr,
>>   				old_end);
>> @@ -5106,30 +5179,12 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>   	last_addr_mask = hugetlb_mask_last_page(h);
>>   	/* Prevent race with file truncation */
>>   	hugetlb_vma_lock_write(vma);
>> +	preallocated = prealloc_hugetlb_page_tables(vma, new_vma, old_addr,
>> +			new_addr, len, sz, last_addr_mask);
>>   	i_mmap_lock_write(mapping);
>> -	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
>> -		src_pte = hugetlb_walk(vma, old_addr, sz);
>> -		if (!src_pte) {
>> -			old_addr |= last_addr_mask;
>> -			new_addr |= last_addr_mask;
>> -			continue;
>> -		}
>> -		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
>> -			continue;
>> -
>> -		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
>> -			old_addr |= last_addr_mask;
>> -			new_addr |= last_addr_mask;
>> -			continue;
>> -		}
>> -
>> -		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
>> -		if (!dst_pte)
>> -			break;
>> -
>> -		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
>> -		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
>> -	}
>> +	if (preallocated)
>> +		old_addr = __move_hugetlb_page_tables(vma, new_vma, old_addr,
>> +			new_addr, len, sz, last_addr_mask, &tlb);
>>
>>   	tlb_flush_mmu_tlbonly(&tlb);
>>   	huge_pmd_unshare_flush(&tlb, vma);
>> --
>> 2.55.0
> 
> Hi David,
> 
> I thought more about the case where the destination page table was
> preallocated as a shared PMD.
> 
> I do not think the current move_huge_pte() handles that case very well. The
> reason is that it assumes the destination PTE is not part of a shared PMD
> page table: it clears the source PTE and then installs that PTE into the
> destination. That works when the destination PMD page table is not shared,
> because the source removal and destination install have a net-zero effect on
> rmap and hugetlb accounting.
> 
> If the destination PTE belongs to a shared PMD, that assumption does not
> hold. In that case, I think we should leave the shared destination page
> table untouched and treat the operation as a source-side unmap. Otherwise
> move_huge_pte() either writes through a shared page table or skips the
> source-side unmap accounting. That can make the rmap, hugetlb count and
> folio release handling inconsistent with the actual PTE update.
> 
> So I think the change should be roughly:

IIUC, what you are saying is:

A) If the source table is shared, unshare it.

b) If the destination table is shared, there is nothing to do.

?

-- 
Cheers,

David

