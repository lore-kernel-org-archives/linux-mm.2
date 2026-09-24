Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C76BC98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A336B0088; Thu, 24 Sep 2026 13:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA7D6B008A; Thu, 24 Sep 2026 13:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA556B0092; Thu, 24 Sep 2026 13:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6E0C6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:35:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38B5E1202D0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:34:59 +0000 (UTC)
X-FDA: 85249356318.03.6F8C7D4
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8C52140014
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:34:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ujNcoCKY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790271297;
	b=GMNL1Gr9efK42baMJOMdLmAmRWvMgRDOIDo4mqpA+oI2SYFBEPlrXatml7vS+r4h8JGMAK
	SXKn/f3h6eTPfyV/SYqcUmf18SvMP3gxITYW09gEjZRgEeSGK5NM8SpHXFwExiWfG/Czt/
	YgV+Vk/F1JYE7fxMgM1Zkw61noG/OyI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ujNcoCKY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790271297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsWUm9lOFd97AbuUlb84GT0EVIl/aMxzy1lD/uof35w=;
	b=IOlv2+E4HFOKX0FzydCVIgzl3RYLLcANSWaqannExH8WY1hBbvZeENHqdsgn+yCrl3/G/Y
	Qxeyh0yPAPekMUkadE4QS21XAhlxWkoid/X7Q8ESyTYdK9AqihPBdw5Bapvi1sueTt8Gv1
	0wz1WPSOujUOchZaiZDxlMowZcCNklo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yZ9rx3BhSXpvURnJe/ABajoUQEwR3f64gTF6zXhSG4A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790271295; v=1; x=1790876095;
 b=ujNcoCKYuR8dbQfyWdHLqzOEPnPhwT7CLW/h5MUyxv0cCg2qskTfbTdooNJcQgs+Ss1J5Arj
 7K9zQwZmBxATu6m1/G7iYMUp/a8ya/kWCkfCQXIwAdqZFOB+GhVCQwclBBeDb6jt8CMMFQ/BHkp
 fSFnUP+SXNzW2RnpVlXwSdsI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f5cad8d26f570659;
	Thu, 24 Sep 2026 17:34:45 +0000
X-Mizu-Trace-ID: f5cad8d26f570659
X-Migadu-Flow: FLOW_OUT
Message-ID: <326b26d5-481e-4524-8b9d-c4d54924626e@linux.dev>
Date: Thu, 24 Sep 2026 18:34:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 11/29] mm: split PMD swap entries into PTE swap
 entries
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-12-usama.arif@linux.dev>
 <7f6eb404-8139-4208-88eb-03ea8a4bf3a9@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <7f6eb404-8139-4208-88eb-03ea8a4bf3a9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: md8putti7d1j9f7m4tc47o9rohnj6wqo
X-Rspam-User: 
X-Rspamd-Queue-Id: E8C52140014
X-HE-Tag: 1790271296-111189
X-HE-Meta: U2FsdGVkX18+xRKaThdX5SUyk4xrGU4zY1lsbmrZCUsqJeuKHmfXKqNrQgU8+tr7JASn5JJWsHkixV9IxlZEERJhitkB9FQzh1yJInwPjEYDPLWf2ecZHcFNwdeSRf5lyi8dB+KI1XrqS8p4jx4bJmBwvshMVKxsrUqT9hB1nIbrHFu034pGLzJebT3zHnNeiRDo2uX8Y+8uuflN8eAwnB7pyFlss6s6mziuVU4LqNwfAH/CYq7w8RAzkqmSjnK00Oevw/tVJm8d2Inl6tRc2IANgNyQs8One2t1xz4yfj8pSCkuaDxarFklIhwX2mpRjA+cgU/UmikjI7pq4GEPeS7jc/tMvI8ifXwJT4jR/Xxe2VIlCZPWFIggq4jVLyDDGRulICa6HJkfQb4bGwQC13P0Owi7rcuBviKsHygngpw8VPLD1GZChWHI7gwXvZ9hqladZkYQjV7zwUPVw3WDln5M0vz2AhnokCj5emduqHQXDRsXesap6PUzjxBYTKu8KxOMzgj1KLBIYtnxw+3wKZ2afYBXGqZD2ofTOR/U14KdvtOksLrp10olNKkflHiuwHKR8RD45mLhnOJ2HI2EoO8PcqNRK3CXjVMU+7uXwuw/WUV7XwXB1346JRgrm2V/annlyKUslG0CtYNKeqxVmjqDmE6aEyHjYHamx2QmIuChnvSm+vLhem1sC5P5GKGdhXNt7wb6xWZ2ce5/qsAnvAq+t3mg2HDSaVUV/Shx38zbrqHjOqiQTHVche381IQPhu/08xDjUXR05LCKxp5L3/Ua7IP3ElcgGLH5ZaI6l4oVU2WAKS2VNTNmRu/XQufXCYKYEXfkhAxX45CwnPpuLP1v/Iujb3z4oC1+skWq8wUqbweDACGzP9jkHX8tlIfP0up6DJlzLHHaskcPzb2qHN/69MsINi9U72FYytF4EeNOqhkEwA3pQJMQEU+ecK2uUdS56BeyKO6bJYAi16j
 iELz0iYf
 hT+bXfYXshAivzzmscEDSLrOXiuTB1QL9HuEss6OdO0qgeEUQPw4JgTX+0WSV1uW1U/tux8hLAGZgr7vEx7uOCrgI6R6mNUoz8c2/6XeYF9fiXKYaP+owRdxoNU5jTKIUtA9pH79zN+Wk1zSqdehOCwm6JBY9HIuxWaLYkVVVX2JYnNjXGcZFUR8lRhnftRWYLY5U1oiv6LV7sreyXcGHXQYRB0dAv6ZYRgcAJUJY+in2OS+6pzO1ck2A9x0d/Jc7xs++LnNxzowMTdAS5SOotDKTJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/09/2026 12:20, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:28, Usama Arif wrote:
>> Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
>> or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
>> handler - has to be able to split that entry too, or the callers that rely
>> on split_huge_pmd() to hand them a PTE table would find the PMD unchanged.
>>
>> No reference counting is needed: a swap entry pins no folio, and swap_map
>> is already one per slot, so the PTEs simply take over what the PMD held.
>>
>> The migration-only entry point cannot reach the new branch, because
>> page_vma_mapped_walk() never hands back a swap PMD for the folio being
>> migrated. Warn if that ever changes, and force the regular split anyway,
>> since the branch leaves folio and page uninitialised.
>>
>> Test the pre-split old_pmd rather than re-reading *pmd in the trailing
>> folio_remove_rmap_pmd() gate, so every entry-type test in the function
>> interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
>> leaves the PMD present as far as software is concerned.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/huge_memory.c | 36 +++++++++++++++++++++++++++++++++++-
>>  1 file changed, 35 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 873887aed0bc2..0e347a545588c 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3304,6 +3304,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>  						 vma, haddr, rmap_flags);
>>  		}
>> +	} else if (pmd_is_swap_entry(*pmd)) {
>> +		/*
>> +		 * A PMD swap entry has no page, so it cannot be turned into
>> +		 * PTE migration entries.  page_vma_mapped_walk() never hands
>> +		 * one back for the folio being migrated, so this should not
>> +		 * happen; warn, but also force the regular split so that a
>> +		 * broken invariant cannot make the code below dereference the
>> +		 * uninitialised folio and page.
> 
> I disagree with the force (and the comment). We cannot make each and every
> assertion that never happens (unless someone messes up real bad and would find
> this during early testing) have recovery code.

Yeah that makes sense, I will fix it for next revision.> 
> The real bug would be calling split_pmd_to_migration_entries() with something
> unexpected. See my reply to #10 where we bail out earlier
> 
> 
>> +		 */
>> +		VM_WARN_ON_ONCE(use_migration_entries);
>> +		use_migration_entries = false;
> 
> Can we just have on the beginning of the function a check that
> use_migration_entries is only ever set on present PMDs or device-private entries.

I have moved it into the previous patch (#10) as

  VM_WARN_ON_ONCE(to_migration_entries && !pmd_present(*pmd) &&
                  !pmd_is_device_private_entry(*pmd));
> 
>> +		old_pmd = *pmd;
>> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>> +		uffd_wp = pmd_swp_uffd(old_pmd);
>> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>>  	} else {
>>  		/*
>>  		 * Up to this point the pmd is present and huge and userland has
>> @@ -3440,6 +3455,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>  			set_pte_at(mm, addr, pte + i, entry);
>>  		}
>> +	} else if (pmd_is_swap_entry(old_pmd)) {
>> +		const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
>> +		pte_t pte_swp_entry;
>> +		swp_entry_t entry;
>> +
>> +		for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
>> +		     i++, addr += PAGE_SIZE) {
> 
> Just squeeze it into one line like the other instances.

Done for next revision.> 
>> +			entry = swp_entry(swp_type(old_entry),
>> +					  swp_offset(old_entry) + i);
> 
> Didn't we have a helper to advance by a delta? Ah, yes, pte_move_swp_offset().
> 
> I guess one could construct the initial pte and then advance one by one through
> pte_move_swp_offset(). Won't remove a lot of code, though, so just a thought.
> 


Done, it reads better than I expected, because the three bit tests
hoist out of the loop rather than running HPAGE_PMD_NR times:

  } else if (pmd_is_swap_entry(old_pmd)) {
          pte_t entry = softleaf_to_pte(softleaf_from_pmd(old_pmd));

          if (soft_dirty)
                  entry = pte_swp_mksoft_dirty(entry);
          if (uffd_wp)
                  entry = pte_swp_mkuffd(entry);
          if (anon_exclusive)
                  entry = pte_swp_mkexclusive(entry);

          for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
               i++, addr += PAGE_SIZE) {
                  VM_WARN_ON(!pte_none(ptep_get(pte + i)));
                  set_pte_at(mm, addr, pte + i, entry);
                  entry = pte_next_swp_offset(entry);
          }


> Apart from that LGTM.
> 

Thanks for the reviews!!

