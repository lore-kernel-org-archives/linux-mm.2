Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A110C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210E26B007B; Fri, 24 Jul 2026 06:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C3E26B0088; Fri, 24 Jul 2026 06:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB966B0096; Fri, 24 Jul 2026 06:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D948A6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:05:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50911A1009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:05:42 +0000 (UTC)
X-FDA: 85023238524.18.F30CD5D
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8113C10000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:05:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a2wTIYut;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784887540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXYzAMJrIyhnjgtgqeRInUg03/n0tGgIY8htWWcGIJA=;
	b=IsUSbplMQ22ueAgCcmAKbX1oEEi1Ns7YrlR8b2limvu/oFdNEQN/Lcow2Fy9eMZCywktVy
	ukjCxwzvytaGvbWUo7RTtdTwBUh/mSetfVv4qfgG5cDlzZmayRmU6uZo8ffTMSG/EpCinU
	U2Uv5RXRat8XN0B9bA3WzQRN+oX2EHU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a2wTIYut;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784887540;
	b=iFqKgYqBiPyL799fblQfjGqbYsXTJRORhHBCnGmf8EuNCjyoeH/8filCdaVo0FPJ8tCwCQ
	viXks9N5SarkD2B1OyM9opUm5bOWBhG3+2bZAC5ko0/qo6RmQJt++cc0VlD36nca5p4eEs
	7rVNOKs6ha8KQJlryOAuGTib3a5ejXQ=
Message-ID: <740589e1-0c1e-4457-8781-05589151c06f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784887538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lXYzAMJrIyhnjgtgqeRInUg03/n0tGgIY8htWWcGIJA=;
	b=a2wTIYutEZ0AFU+lwq6wQDQOLLm/VBDKtpQHds8WfHvu2c3a5ZIAo0qmSR6aCEjg5MMuDk
	AripeeEuk01hjqotkbVkaEAbRURYxkZR9JAcgsf1XfCOQD1Oexesd4Y8Y/pUqQL1fur7cY
	CTIIud+yQ5soiCnxdTkswW8xmFatxxw=
Date: Fri, 24 Jul 2026 11:05:34 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 02/11] mm: add PMD swap entry splitting support
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-3-usama.arif@linux.dev>
 <7c8b0e38-f13e-449d-a2a7-de1032b831dd@arm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <7c8b0e38-f13e-449d-a2a7-de1032b831dd@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8113C10000C
X-Rspam-User: 
X-Stat-Signature: m85a4eryt13suaqqruuwb6wbpuaq1rw5
X-Rspamd-Server: rspam04
X-HE-Tag: 1784887540-532755
X-HE-Meta: U2FsdGVkX18hxftg+YxvCgj9VWdZXPduixMYtNZG8wVBe3h64/7wvE5KQNkMdN/LAwMbM6R5T5BOielHYxEt+riwAEcYGrSwB9NSvk0hY6Vn99i68cnsNmD++4xxIp9s8tWMphiUiXX8raPSK9bYmnwbp0wTjnQxBYnfhsW6EmKebaOcz0lf8DF4M7ZAcohSVpsvKsZfbrt1txaQrz2I8934tYWF4Q/D7fPxHKTehLZ9YYnas1CP/8AyrxSKfEGKBisM4mWm54UQdvSu73BjkwX6zqOMVTWAe0N1k5+lXqh25jdUOK/wctyRcVGS85sxGGoDuxH50yhw3QeDTG4MsNDG/f2VrwoZnP5B/LclF/kRTu7TM3He6QlUANzpgOzw5B5n9RsD3HAB5o4RGdRfcL60XijiYrmrNC5Lh8Pi/XEWoH21z0h5Az++eRgI8GBQbszFG4N3YRK2lQMMCgS7rX/NlXTMPGFv2zSRcK5ipSawLLG5mRuJga97DtcTKIERI+MvPOIVEX8Fj20UQBy4IgXFv6VM7bH56k1TyQoCxgPmEsjDvcR4XYOdFNmx4Z6Htdhwol59N7rFHSDReiCzm9fC6qqtYkQ+uZfkHrUwBqVvg3lgDHN5Bfz+Vvrc3sIyg5L8UgGesAK6gGcGjX2QMKtTyFiG5VCuQ1+jRevoMvYBTuEuxr6Wyq9a+t9bRipAduJwtHhBWt3sW7BM0gKOrMPSQHD7Sma9QmozTfQ/Lr6BQw0MuguvMC76RR97HB/r+DkcBDu7ufFGc7z1I8QPBJ8uj73WGPcLI9UponfQUID5e5Uvv2TERQ9HoOp2JAi3fD876GlleISX1Yc9yWAmPRna54oQ6gX52m5GPff/mZZ3FoEVu/h19WtHhqM3D8I5sQ2sKU07gfKB+DvNdawaEL31GLaBhLEmQQXrp1wl1wQrgwUt34u437tMda+C4dBlE8unb8gNJezE2YOzJVt
 zQvGK4Sy
 b5Ws+OSxjpiTpiyqcRJhro5Xc+4UN5Wiv2iI5QZ7iJvBanHAHVGr4BWMpZn5niwsqaojDKMe1soGTdwntZnyWbVxDxcbzpOf9Nb6vmnmQWmVoMfE5/KbrPQqS0A4YrOKo6ysDeNnVSuIrdhAOTxOTXOHtz5t5ibtRWlTjV0GL/QFu+EH4ozHE64pVtUivsfM795gChZoPcnSfdGgnA3lcPClFjMdoXqRLfBMbFOdagbHXR1nh8rVS6++eSv+xD2uXnVB0L08jKoiXnrlOY0GaetVzsjkviDg+VB4rHltqyPfQZuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/2026 07:52, Dev Jain wrote:
> 
> 
> On 22/07/26 8:49 pm, Usama Arif wrote:
>> Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
>> entry into 512 PTE swap entries.  Unlike migration splits, no folio
>> reference is needed because swap entries point to swap slots, not
> 
> Confusing wording. swap entries need reference of swap slots instead
> of folios. I would drop the mention of migration here.

I added about migration because its the other if part of the if else and
was a good comparison. Will remove it. Thanks!


> 
>> pages.  Each PTE inherits the correct sub-slot offset and preserves
>> soft_dirty, uffd_wp, and exclusive flags.
>>
>> The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
>> rather than *pmd: for a present THP split, *pmd has already been
>> cleared by pmdp_invalidate(), and that invalidated bit pattern can
>> decode as a plausible swap entry.
>>
>> This branch is reached from the explicit __split_huge_pmd() callers
>> that hit a non-present PMD: partial-range mprotect / munmap, the
>> wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
>> added in later patches when the cached folio is no longer PMD-sized.
>> page_vma_mapped_walk() does not iterate PMD swap entries, so
>> try_to_unmap_one() and try_to_migrate_one() do not reach this branch
>> and freeze=true cannot occur in this branch today.  page and folio
>> are therefore left uninitialized in the swap branch; a
>> VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
>> invariant before the freeze path dereferences page_to_pfn(page + i)
>> or put_page(page).
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 04e8a6b55343..9819c0ae228a 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3210,6 +3210,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>  						 vma, haddr, rmap_flags);
>>  		}
>> +	} else if (pmd_is_swap_entry(*pmd)) {
>> +		VM_WARN_ON_ONCE(freeze);
>> +		/* Swap entries have no page for the migration freeze path. */
>> +		freeze = false;
>> +		old_pmd = *pmd;
>> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>> +		uffd_wp = pmd_swp_uffd(old_pmd);
>> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>>  	} else {
>>  		/*
>>  		 * Up to this point the pmd is present and huge and userland has
>> @@ -3346,6 +3354,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>  			set_pte_at(mm, addr, pte + i, entry);
>>  		}
>> +	} else if (pmd_is_swap_entry(old_pmd)) {
>> +		softleaf_t sl_entry = softleaf_from_pmd(old_pmd);
>> +		pte_t swp_pte;
>> +		swp_entry_t sub_entry;
>> +
>> +		for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
>> +		     i++, addr += PAGE_SIZE) {
>> +			sub_entry = swp_entry(swp_type(sl_entry),
>> +					      swp_offset(sl_entry) + i);
>> +			swp_pte = swp_entry_to_pte(sub_entry);
>> +			if (soft_dirty)
>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +			if (uffd_wp)
>> +				swp_pte = pte_swp_mkuffd(swp_pte);
>> +			if (anon_exclusive)
>> +				swp_pte = pte_swp_mkexclusive(swp_pte);
>> +			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>> +			set_pte_at(mm, addr, pte + i, swp_pte);
>> +		}
> 
> All these for loops could later benefit from the set_softleaf_ptes() helper:
> https://lore.kernel.org/all/20260723070905.3422276-6-dev.jain@arm.com/
> 
> 
>>  	} else {
>>  		pte_t entry;
>>  
>> @@ -3373,7 +3400,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  	}
>>  	pte_unmap(pte);
>>  
>> -	if (!pmd_is_migration_entry(*pmd))
>> +	if (!pmd_is_migration_entry(old_pmd) && !pmd_is_swap_entry(old_pmd))
>>  		folio_remove_rmap_pmd(folio, page, vma);
>>  	if (freeze)
>>  		put_page(page);
> 


