Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31815CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD286B02AD; Mon,  1 Jun 2026 03:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984836B02AF; Mon,  1 Jun 2026 03:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1476B02B0; Mon,  1 Jun 2026 03:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD7F6B02AD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:51:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A8FB1C0A0E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:51:30 +0000 (UTC)
X-FDA: 84830573940.11.7EC1F8A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3EE7AC000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:51:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I6w2WUk6;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780300288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdixgpShH7hYpW9sMn1MMnWna0aWkb3QEt/4zti9SVk=;
	b=A/94D+tCi45w3HIMX5xxAEZ5W4RpZllmGdZ9NFQsQjp9WFglXKQjQ7pV90PPdceTBrHWvs
	/7DZbD9n0gnsuyjMV6e3vtFVygeTwoGwB/cQ0J0wI4CLoD4X3cZd+kU372JdQ6Sr5eFwqk
	9VhnzA4ydHCq+fr7TYM32huAJyHDtqk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I6w2WUk6;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780300288; a=rsa-sha256;
	cv=none;
	b=7pU0ZSrDQTcJdxCdxr9/blS+IJdlUVAvIWbGJGFhv+4RRd9jd8CSpI8tAPPxgFnUhZYHPQ
	7N44Fz7epGV8PAReh9N3nYBZ4ngXQ/cilCDoPsaK4xaD0vMn2Z/rMxjpnHriJs/6AIQ+kB
	2Jd1osa8QBLI6Ykw21ecoyWcHAxAadQ=
Message-ID: <fb8f24b1-ce8e-4f06-bbd8-f148a9bcaeee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780300283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xdixgpShH7hYpW9sMn1MMnWna0aWkb3QEt/4zti9SVk=;
	b=I6w2WUk6rUegOHmHPsCN+sU/WijwIVnKCXVcyzIteQdgNXRTPeOOhpcSHT3+10mY+wLtzg
	IAi0m7kp4H10MnJHt9y8RR7DiqInQQLPDeCRMbGQDyzwk3oSoJRXK+GNveolJHCSPX5qIP
	4XbQrnx3pi0RV1OcITXmtcmXWh9Ez1M=
Date: Mon, 1 Jun 2026 15:49:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 781fqhw9tetx69869d84hqzr7ofm45qz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE7AC000C
X-HE-Tag: 1780300288-850681
X-HE-Meta: U2FsdGVkX19fziGuTCMXgW6e1uinxcockh6mx7AHCtgVs3NNyvbHwECCNmSaBOXFNrdQbrXmzmBHb94WhFmXagIoz+hf7yh76svsW7jAaIpWHsty37hip4yNC5bB68iNitaU1Qrs+fAnGIBOqwIaohbDmqaIkl8gZjeqW4EnKgkWkDJy+bN1vfLxuDdA6nlkL3O6OEImfvOwaGt85cRVpuScF5d4GpUqtVNTUc40gINGyBfh9yQET9vpEjkBlfW934JVt751y2ooP+Ctf7FIjS/L3JQ0Zu2mvjxL5wS19GUajoAYe84XnPqO5IqHEqO9LdxLT4cz2BOrNZWoR1I3wdfPcemsJE9/Bw3z4wDpHTZjFxjsmXhN1yZH6dQWeIplx1BStoZPY4jPNMiDXTCX2dx56xXAhBWevWgdaxHW3ht+/qu8auzfTS1WdDTDnEJQimrfrMRHf4IQgEAtzZy79NE9FrxMPstKCQEpJvjmPD7xBri8wLE986I+ZZ9uAa9gdOs2yZfZWFNdxv389g1/cOPpWlmhgGk2CBQiEFJodT2U/fkkb5Cu2aO0ueu2wq/gF/tPQhTLQyJegmMGvWGTgW82I54fPUPqV0ogzqEJ0MnS33HCHMTy6WLa5OkVNElQRJlxM2MzejbAa5V5azLIo8fYZaZF9th48OWmYzqsiat1GqMUUsgV3Fv60nflMgPrTf9wfPJNnGMPrNLM1BTKbI52l4OxVADgQeR0OTGhYdps8vBZnf73i4CIf6gEuVY9buohiuQi3jSYWc5BpkmTi7xAyISe9B4NcTM1ctUmK6ilijyZwf7dEsv4aCYxzCSliugg88YQSg7aH6KsObu9FNUNzO5rLV9nA1dyBj19lbZAiwi/zz9SbnNAv8xhiDsBYAmUJqvbCI1aHCudkbUjIYM9fPRy6odGUhusGIweQxk6e7xX4DTjgn3IfkCg+AYdfFMaQSm3of2R6RShyhn
 a8uCYGnS
 vO54n5VtJsu5T1LslqcKp99Nu8Gspate+uKVBwFhMX04TJWTAc8ScDcoY7AMECPRKsPJHG7cs/LpqIxubRTdz4u+HP8NPeKqinzAY7OafThXJnXl90K5ok+5FumTxoVeuICuPjPF0YU8sWR3ylqGJvLTHoHFt12Ye79jF49csMPc8RCmrzfdrbrbeFX8jsXDUn5CCgrp7xRyMq5wIIo71PDyiTs7KJlcfL0pr5lkq4Uel1BN2jDzN/a2X5oXmVB0kVfr99fmnjJ14p0a//iO5r9GD1n8E0OdHaE6ugF/Mhom6XB0+i1O0MWTke++usKUTHtVxgRuIcYpu3TRxI3REZJblvWI3jj0H2lwcKv564lNoXs39qU8xgowOCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 14:54, David Hildenbrand (Arm) wrote:
> On 6/1/26 05:28, Lance Yang wrote:
>>
>> On Sun, May 31, 2026 at 10:00:17PM +0200, David Hildenbrand (Arm) wrote:
>>> On 5/31/26 11:39, Lance Yang wrote:
>>>>
>>>>
>>>> Emm ... is it safe to use map_anon_folio_pte_nopf() here?
>>>>
>>>> At this point pmdp_collapse_flush() has cleared the PMD from the page
>>>> tables. The PTE table we are updating is only reachable through the saved
>>>> old PMD value, _pmd, until pmd_populate() below.
>>>>
>>>> map_anon_folio_pte_nopf() does set_ptes() and then calls
>>>> update_mmu_cache_range(). Documentation/core-api/cachetlb.rst describes
>>>> that hook as:
>>>>
>>>> "
>>>> 	At the end of every page fault, this routine is invoked to tell
>>>> 	the architecture specific code that translations now exists
>>>> 	in the software page tables for address space "vma->vm_mm"
>>>> 	at virtual address "address" for "nr" consecutive pages.
>>>> "
>>>>
>>>> But that does not seem true here yet, since the PTE table is not
>>>> reachable from vma->vm_mm when update_mmu_cache_range() is called.
>>>>
>>>> Should we avoid calling update_mmu_cache_range() until after the PTE
>>>> table is reinstalled with pmd_populate()?
>>>
>>> I recall that update_mmu_cache* users mostly care about updating folios flags,
>>> for the folio derived from the PTE ... or flushing caches for the user address.
>>>
>>> So intuitively I would say "the architecture code doesn't care that the PMD
>>> table will only be visible to HW shortly after". The important thing should be
>>> that it will definetly happen, and that nothing else is curently there or can be
>>> there?
>>
>> Ah, fair point.
>>
>> I was mostly worried about arch hooks that walk vma->vm_mm again, rather
>> than only using the pte pointer passed in. For example, mips does:
> 
> Right, a re-walk would be the real problem.
> 
>>
>>    update_mmu_cache_range()
>>      -> __update_tlb()
>>        -> pgd_offset(vma->vm_mm, address)
>>        -> pte_offset_map(...)
>>
>> and __update_tlb() has this assumption:
>>
>> 		/*
>> 		 * update_mmu_cache() is called between pte_offset_map_lock()
>> 		 * and pte_unmap_unlock(), so we can assume that ptep is not
>> 		 * NULL here: and what should be done below if it were NULL?
>> 		 */
>>
>> So if khugepaged happens to run with current->active_mm == vma->vm_mm
>> here, could __update_tlb() hit the none PMD, get NULL from
>> pte_offset_map(), and then dereference it?
> 
> Likely yes -- that MIPS code is horrible. And the comment in MIPS code
> even spells that out. :(
> 
> Do you know about other code like that, or is MIPS the only one doing a
> re-walk and crossing fingers?

I had Codex do the boring grep-work through the arch update_mmu_cache*
code :D

MIPS doesn't seem to be the only code doing a re-walk, but it is the
only one I found that appears to assume the PMD/PTE walk cannot fail,
without checking whether the PMD is none ...

Cheers, Lance

>>
>> Just wanted to raise it since some arch code may still have assumptions
>> like this, and the always-enable-mTHP work is getting closer ...
> 
> Right. I assume set_pte_at() couldn't trigger something similar (re-walk) in arch code,
> because we simply provide the ptep. update_mmu_cache_range() only consumes the pte.
> 
>>
>> Probably very very very hard to hit, though :)
> 
> Delaying update_mmu_cache_range() is nasty, as we'd have to make sure that
> nobody can interfere in the meantime ... and the PMD lock will not be sufficient.
> 
> Maybe we could reinstall the page table with the cleared (none) entries while
> still holding the PTL?
> 
> Thinking out loud:
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5ba298d420b7..e39b750b1e6f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1413,13 +1413,17 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>                  map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>          } else {
>                  /*
> -                * set_ptes is called in map_anon_folio_pte_nopf with the
> -                * pmd_ptl lock still held; this is safe as the PMD is expected
> -                * to be none. The pmd entry is then repopulated below.
> +                * Re-insert the page table with the cleared entries, but
> +                * hold the PTL, such that no one can mess with the re-installed
> +                * page table until we updated the temporarily-cleared entries
> +                * through map_anon_folio_pte_nopf().
>                   */
> -               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> -               smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> +               if (pte_ptl != pmd_ptl)
> +                       spin_lock(pte_ptl);
>                  pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> +               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> +               if (pte_ptl != pmd_ptl)
> +                       spin_unlock(pte_ptl);
>          }
>          spin_unlock(pmd_ptl);
>   
> 
> 


