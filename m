Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22E7CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A156B0290; Mon,  1 Jun 2026 02:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CADF6B0291; Mon,  1 Jun 2026 02:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBF96B0292; Mon,  1 Jun 2026 02:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFD0E6B0290
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:54:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90D2D1C07F0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:54:44 +0000 (UTC)
X-FDA: 84830430888.10.9B48537
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9345140002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:54:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AB1NEZaN;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780296882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucY6l599DjCysA2ISBeExpvkiGVYAbGonke46fcIr0U=;
	b=jKN8XXInxTu2X9R7WqremhOgmKGuC88jF4/3VLXWusSPPmfb7Ks6q8bcJke9qEJmd1ALN+
	1v/kWxZw6tmTkbL0H+Xq1026bvu2Z7aosaktLo50sC254vYZXc/l0A3+fYVFpnS4Xla4Ig
	YGbbJtXbEsMzq9OJuBJRpGZLFgojYzk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AB1NEZaN;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780296882; a=rsa-sha256;
	cv=none;
	b=XklbIZHm1afrhm3VIfdAn3NW8pP/ski1xdjUlF7hoV46+StLjxhKtotqCcCMStbqOFaGBU
	tnCXHKPPxHu/z9XuHqMelwjtR9lcPMk07AzcCW1fzadNqyszYFhHqw8d/acFo7H3m3GF+P
	dNsYVpzOePdyMizuMnyQXx4b0UZpaeA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFF734193A;
	Mon,  1 Jun 2026 06:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCF41F00893;
	Mon,  1 Jun 2026 06:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780296881;
	bh=ucY6l599DjCysA2ISBeExpvkiGVYAbGonke46fcIr0U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AB1NEZaNl3h+2vFIIjBgpeoCNyxtvnMbksagHKvmYm2QJrUND00xTaCMT/F5jSqlI
	 qQg7Kc1/Y2LSegUqfOzUJm70nPvej+AEDd/vCY+waTnC8TecoCe88siupNFr5zskCf
	 rG04LkJJe04XY7A11NLDrvi5I9eKLEqIOmTb5qo/mFoEJCBdP8Da8YC74ooXQIu/3O
	 9Nuo1ha21hOYhlqnxbVyQV1DWDjSB7wcehvBytigshcafItPxsSiEjt+NxHidy2j+h
	 TjmK6uaKFUaZ2cPmuDj/OQTDWnl90wv4EJbmkOXn3waL1AlrU2uZrgnpeT8ueLU1m2
	 aOckX+9Pa8B/A==
Message-ID: <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
Date: Mon, 1 Jun 2026 08:54:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lance Yang <lance.yang@linux.dev>
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260601032804.96122-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kr7kh6wohgs6pg49fcpb77ghyinxjq83
X-Rspam-User: 
X-Rspamd-Queue-Id: C9345140002
X-HE-Tag: 1780296882-225564
X-HE-Meta: U2FsdGVkX18nhnDPHNEtd9ks//6YFnfZ6yKiAcwAXVFbPlPnfIvnunpjqqVqhJrYQD3R66ztPxyp9HHpg9GgnDeijcvadRjxx9rmgq/g7wFw6Qd5eucSl67E/a13x/iEnvykOcLxgC7+gvf3g0/lJq9fNUw/E9rmFbBaTTPYSmBeXt38zr2+7bypHMYhlEdE5IksZzNyzk599EW2x+ZYrgepJKLYM6gQqhol9ypnWIrdXQjoIhBERPrWj45zewgjQkyb8QNi3yyPA/D76nqLQaj5wOp2a9RqZFXw+WXLDM6UO8IHoIz2WOmwoSoSkNhpBthtcjkjI5cmuWfJQT5C4Rur6dGJTkrUwoUzsk/o5sGjR0nOU28WCYt0ioGuQWviTFgLyxlCKYWnrmZfBTpcW6Z1z1WAXlNCFLPtlaPSrUDLz6uqXNdlHoGDpZgoHZ4cRfTnDl7iv1jhkcDB2QHbjo5ibZNQVxyEdDU8R63w+bqo+PdB//MiYNQ+EcKmj4JyOXFhIt/bIXCq04SRP3D5TQ9/xYeE63WcupYOPCrCt0wPLaV/grcKuO+bAIz9mt1dm8H0shnXFzbV8L5SsxldA7VpXDpeAXdcHLK2v3jXatEQOW4vk7SORasdUGsMfy6yFwQTnKKRBFBo4gPytdSGwpc/VbKB71sAqfDd5kbncEb4fFObTceoESoE6GmNOPOscqnv3+rPoddvWjMIBUBEYzFjg6fdVDUS9wjtyc/D1jzNhbuJxRrqeYKAPq1HPVQuyG2RAZzhh+DWUtTP09vbvCjIu9yDVpG+aUZHSThXeo8+bhDVNLan70urgAXff1x3Dg7eT3DZvesSCqpXBQO1E8OsvWeG4IpJL5pSQwvjEV0AQRlt/Gur42e0Gb7qSE8dGiqjkKpi8dbn+TjqKvqEKI2fhRXy7VT8j4gqLjf+cTgrYjVhajC274tG3ymk8l+/hYMOcwcXOKV8XGnZK6b
 9CHuCKK+
 8kcVSBg8rlECt9vP/mPYp/fFdYLula4V/6OHum22e6vuPn/jIRWjwDbnUioFSuCz620XCzmY9rDOzptr1vCb5EzXLWsiuKa24pJYy//pvmXVW+wdkSMatWk7rYdAyGory/4NYiH79nhxKXiU2UMTxKTa88VW0Gxkhmcz5TUJ6gwOaB+cKBbjcCw0WGiEhipZh/sHUVUu9oFMDUw62YtxWcNGV2sQJ8FYmvLB+oMiXUsbIvNrnBuRMyv2V2at5UeznFKG3KhbV69fq5fljS4FVivht3rQw343MZvRkQslSMfXN2PDBglwD2LQN8sIb/ZwuP0QBtP3e9080snDH33/M3mmpJ4BMCc2N7Nx6gJzwqyy1q2tfRJgLVRAyDE8mo/m0mWzVwFEdrDTCQMf998HCUHvcdPZ5YzEyYqn4f1/iXGoBK3b7PdGxds08SYNsFxOoRz16xOytNP1drpR+n/Mv64UtQkeVVFZErIBOYmWou0boRDdtiKeU5OLUMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 05:28, Lance Yang wrote:
> 
> On Sun, May 31, 2026 at 10:00:17PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/31/26 11:39, Lance Yang wrote:
>>>
>>>
>>> Emm ... is it safe to use map_anon_folio_pte_nopf() here?
>>>
>>> At this point pmdp_collapse_flush() has cleared the PMD from the page
>>> tables. The PTE table we are updating is only reachable through the saved
>>> old PMD value, _pmd, until pmd_populate() below.
>>>
>>> map_anon_folio_pte_nopf() does set_ptes() and then calls
>>> update_mmu_cache_range(). Documentation/core-api/cachetlb.rst describes
>>> that hook as:
>>>
>>> "
>>> 	At the end of every page fault, this routine is invoked to tell
>>> 	the architecture specific code that translations now exists
>>> 	in the software page tables for address space "vma->vm_mm"
>>> 	at virtual address "address" for "nr" consecutive pages.
>>> "
>>>
>>> But that does not seem true here yet, since the PTE table is not
>>> reachable from vma->vm_mm when update_mmu_cache_range() is called.
>>>
>>> Should we avoid calling update_mmu_cache_range() until after the PTE
>>> table is reinstalled with pmd_populate()?
>>
>> I recall that update_mmu_cache* users mostly care about updating folios flags,
>> for the folio derived from the PTE ... or flushing caches for the user address.
>>
>> So intuitively I would say "the architecture code doesn't care that the PMD
>> table will only be visible to HW shortly after". The important thing should be
>> that it will definetly happen, and that nothing else is curently there or can be
>> there?
> 
> Ah, fair point.
> 
> I was mostly worried about arch hooks that walk vma->vm_mm again, rather
> than only using the pte pointer passed in. For example, mips does:

Right, a re-walk would be the real problem.

> 
>   update_mmu_cache_range()
>     -> __update_tlb()
>       -> pgd_offset(vma->vm_mm, address)
>       -> pte_offset_map(...)
> 
> and __update_tlb() has this assumption:
> 
> 		/*
> 		 * update_mmu_cache() is called between pte_offset_map_lock()
> 		 * and pte_unmap_unlock(), so we can assume that ptep is not
> 		 * NULL here: and what should be done below if it were NULL?
> 		 */
> 
> So if khugepaged happens to run with current->active_mm == vma->vm_mm
> here, could __update_tlb() hit the none PMD, get NULL from
> pte_offset_map(), and then dereference it?

Likely yes -- that MIPS code is horrible. And the comment in MIPS code
even spells that out. :(

Do you know about other code like that, or is MIPS the only one doing a
re-walk and crossing fingers?

> 
> Just wanted to raise it since some arch code may still have assumptions
> like this, and the always-enable-mTHP work is getting closer ...

Right. I assume set_pte_at() couldn't trigger something similar (re-walk) in arch code,
because we simply provide the ptep. update_mmu_cache_range() only consumes the pte.

> 
> Probably very very very hard to hit, though :)

Delaying update_mmu_cache_range() is nasty, as we'd have to make sure that
nobody can interfere in the meantime ... and the PMD lock will not be sufficient.

Maybe we could reinstall the page table with the cleared (none) entries while
still holding the PTL?

Thinking out loud:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5ba298d420b7..e39b750b1e6f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1413,13 +1413,17 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
                map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
        } else {
                /*
-                * set_ptes is called in map_anon_folio_pte_nopf with the
-                * pmd_ptl lock still held; this is safe as the PMD is expected
-                * to be none. The pmd entry is then repopulated below.
+                * Re-insert the page table with the cleared entries, but
+                * hold the PTL, such that no one can mess with the re-installed
+                * page table until we updated the temporarily-cleared entries
+                * through map_anon_folio_pte_nopf().
                 */
-               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
-               smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
+               if (pte_ptl != pmd_ptl)
+                       spin_lock(pte_ptl);
                pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
+               if (pte_ptl != pmd_ptl)
+                       spin_unlock(pte_ptl);
        }
        spin_unlock(pmd_ptl);
 


-- 
Cheers,

David

