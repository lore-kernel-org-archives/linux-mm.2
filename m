Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B689CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0556B02EB; Mon,  1 Jun 2026 05:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6EE6B02ED; Mon,  1 Jun 2026 05:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCF76B02EE; Mon,  1 Jun 2026 05:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF6E6B02EB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:08:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8EB88FD8F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:08:41 +0000 (UTC)
X-FDA: 84830768442.13.D56FFEE
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED124180003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:08:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KxtyW1yS;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780304920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VK++rQga/i6Qi+LoraofDjTFK/zBvGqjLp0spI1XrxM=;
	b=ON/f4o1yTlJwfR5a5fJxIhjG/okX4+Uq9pAQLOFnReYsxS/8aMRQ+ff+1dcoU8KvwhRByB
	KLqlClmw5ikAUvoATh+iTBJJ/XusiRYDLAjbCYDc4ON9wrnhKVvwgxGhUENpvdAt3DeR3g
	l5o7RkdaDiW70pEile8pO3aOqJjyxN4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KxtyW1yS;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780304920; a=rsa-sha256;
	cv=none;
	b=1CwjQwzkqTPvC53mZyyCuwfdXV/FltL5sDeiOMnFgVYAjr/OAiD91gVohGdU4TlEAbz+tE
	Im8uMRletMzy3SJa2NJS9Px5+kZXuvnTEEARfYG9IPFlx+joEA6n8oy6TLOEwjc56KYMZV
	uNWrkUOwJCQhwzqsXV77LRInD80VdrU=
Message-ID: <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780304917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VK++rQga/i6Qi+LoraofDjTFK/zBvGqjLp0spI1XrxM=;
	b=KxtyW1yS8Bmvb5wfbc9LV85WFpETDo57OXPUYHvytoo6p29K7gINb2qVNlWklQtImBbsCy
	BZSH9y6GovK0MeDLyz+cyKp1wb+IItvlaXIN9a9BkWzX99qxM2xoSFd0wS3MFukyIO5Zaf
	MJkTSeNaWw9rlrbF0NUQyagIy3Fpuq8=
Date: Mon, 1 Jun 2026 17:08:11 +0800
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED124180003
X-Stat-Signature: cdm3hur9zdoxtaasn71b9ssne47mf8fh
X-HE-Tag: 1780304919-561598
X-HE-Meta: U2FsdGVkX1+aylUdoLR76bIlmbMy4eEwZiQ53Y2lUx1HQ8eReo7fE3ibML+KfIgDYg3DJxo1H5sfHKX3bS+0kBj4HQeEKc2vNy+/Cp4zPyzDbj2JnSldNwPig60QGIdM9cpbeowztYRjv/f56HCoShPzj9ymwNayeO6npIRxMpfvBILH2KjFClcrjK/dxNts3XVFPj08vNnHscrIV2QT35sUQ4bW0m7G4uIYfOELN5WMh1WEQ8RWdM+vUTMXjkuKV5yr8oa9Wsy/Ea+lJyHd+55U0q85VMILhIM4OKJ6Bj3JilRADcFFoeikSS46vqpTTS5W3Sab4wg0sApSmLMvx5uxN91Q89gLmU5lGaorTQ2xzf+QqMNCYPbBH5UHjvKbeHTRVgi+FWris8u4vppHH9Tbt86o/R3JBvddTnsBRTbssHLxBuE5aS+soAnDFiPJggrYyzJ8QFpH9DPuXZFJxWgTrHLJLwtVOT6st03exzAWnJSpuaAP7eOLE+BCPbCLkWTIXQxjjVJ94SaWLNZ+cx5C4mlv0qkpYlbP/r4bp+wY8/qTdRfKjqRmhIb5RQtaYNNoWjatC591XdWrtNtek19GVO0hAM9dbaeUx2HoosZjQrighAYpN2+u/S3+Nh1zdfhzV+6QvOFPmMDCSgTtRvHfYxWis94pURm97hk3fOU/s3iwQ/JpbFfiTSb9yw4Z9gCgfiYrRO5eAa+lQRO2zN4gCiiG4cbENv1RpD6LGOjK0s6LGy8ZeMfhdeYOjWvocySCsIHDjTguGaFiOvdQKVihaRo87sVJIfFTmHNnJwlJWQUW5jEZumxxen0uLsR2iMWHW0LJ0Eud8YYPEyiVmM9/agZRI0B1Jyd8YwYH4xV3+whk1QICncOAsvnl8q/9RTjAD5MCISGOtCrQWkvtL68DOHLEtYmwctj6khXQ1DH/R4MDEGfgBjXPMG/+cAXNa7urU+U7NdsXmSMfJjh
 5cCsvlOs
 chrFNkag5P3NE1+3tmYl45OzW9WlyE83XXHX8LTV2X4TZ5jIG7QTZiHgn5QZlnjz9yvDs0bLb/iuQyiXls6eSM4tDql18VZ4HMPyUURROO/PARnC6cYHbwgI6wDTtxjcpjnUSNAC42e/fGLmz87tHEzi39t/pqOxCTF0pgBM/TVCuD2qfIautcC0jaFgpOL3W69Ao42n1Mp1EdQacBOWtDXWgq0Y02GmP+/vj1YIAZw0JbKH0YkjD7uJlE3BgkL+P4fmAK55Ix7qwOMTtnVh0oz8MImom+6u+Gozlki2IR5HWp6lng4lGPVFmPS2te+OW8jujk9oJFJs+jog=
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
> 
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

One small thing, I think we should probably keep the smp_wmb(), and just
move it before the earlier pmd_populate().

IIUC, the ordering we want is still:

   clear old PTEs
   smp_wmb()
   pmd_populate()

so another CPU cannot walk through the re-installed PMD and still observe
the old PTEs, right?

> +               if (pte_ptl != pmd_ptl)
> +                       spin_lock(pte_ptl);
>                  pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> +               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> +               if (pte_ptl != pmd_ptl)
> +                       spin_unlock(pte_ptl);
>          }
>          spin_unlock(pmd_ptl);
>   

Cheers, Lance


