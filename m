Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187A2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CoGZBwQF
Received: by kanga.kvack.org (Postfix)
	id 2A3C76B05B2; Mon, 26 Oct 2026 11:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B0A6B05B4; Mon, 26 Oct 2026 11:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190C66B05B5; Mon, 26 Oct 2026 11:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBF526B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:18:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71DF21607E8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:18:33 +0000 (UTC)
X-FDA: 85365134106.06.8A6CDA5
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FD8514000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:18:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CoGZBwQF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793027911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbjgGd5jyFwi2LB7RiLsRLky9ZNqcQ5Y8I4y05BC+mM=;
	b=DvNpMmfgrtCwBRzI9bS2V9FjltT+HpNLSXySTR/YJVvKK/wsJdlmYM+uymGBpsT2ZUc6LD
	DZ3mwpfhGXIisti08mTvTn2461/BjuhvQ0VPJJRcVxaKbQeMJxcIN+b+Ox29AI3E/8jAFv
	LvsZEegE9RFHcaHTQKqBTwBgn7vYAtY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CoGZBwQF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793027911;
	b=4/WFhlCSWHkKpTcdXwDoSc7JGIgJcpVhXpvowKILN5x5aHGIriMlILuC6g3c/QydpK42Z5
	pzS5NdvafNoeknbkPKMPpYL5Z0EY5xIUuzD0bK9arVSgIRkp2jeRriHYxbY+2rlyP5DxFe
	n2qg8LwnoZPJnOXeigcs+N8JRdRZeCw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QzQ8eUYlWxznuofzwVjz4DcrB+p+nCNY4+cACo4yskI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793027907; v=1; x=1793632707;
 b=CoGZBwQFOKbcoC0o70OXftyAQNiao4IDpUqHGrR0KLRh/MNnbecrsJdVWwlzzE886XfSDe84
 4NUFgIYtXJSf/2wDzjOHvuJpcjYJhMUw4OpliWypq/gMHcNSUNukSAf1QGnFslRwfMtjjK8IWbX
 thnmVuUyaIHcIP/Hijq8GEjs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2204e93b3b20cb80;
	Mon, 26 Oct 2026 15:18:27 +0000
X-Mizu-Trace-ID: 2204e93b3b20cb80
X-Migadu-Flow: FLOW_OUT
Message-ID: <a33247c5-4881-401e-aa1c-0de05820c8d5@linux.dev>
Date: Mon, 26 Oct 2026 23:18:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix userfaultfd protection during merge and
 unmerge
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin@linux.dev,
 chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jglisse@redhat.com,
 aarcange@redhat.com, peterx@redhat.com, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bobbypowers@gmail.com, bgeffon@google.com,
 dplotnikov@virtuozzo.com, dgilbert@redhat.com, hughd@google.com,
 hannes@cmpxchg.org, kirill@shutemov.name, cracauer@cons.org,
 mcfadden8@llnl.gov, gokhale2@llnl.gov, mgorman@suse.de,
 mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@openvz.org,
 riel@redhat.com, shli@fb.com, jthoughton@google.com, corbet@lwn.net,
 pbonzini@redhat.com, seanjc@google.com, sj@kernel.org, ziy@nvidia.com,
 stable@vger.kernel.org, samarth.colleges@gmail.com, med08elkadiri@gmail.com
References: <20261026130054.91461-1-lance.yang@linux.dev>
 <at9d4XJUIM8SgBDs@gremlin>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <at9d4XJUIM8SgBDs@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8FD8514000B
X-Stat-Signature: nbm6pza5g1t3z45phybnqx15qz7o5xu5
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793027909-559003
X-HE-Meta: U2FsdGVkX1+4C6rEpMi+6Kwwsh1pGT++q5a6EwLRCHfVD3fpyQ3eP2AlrQEOcvUH274xcqWlpubmyeji7GVMZxlAYOFsWsnVo5vOUcY6ajWDPr+T3a3i/YVDVmSAdz4daj4kQIrQ3ySVOLhape6CEepT+GmOKz9Lb3UMXZP6DF3u2SaffU48su17aVHv7xmIT08tX1KdH9BYB0tLYaEDB9h2fnZAB0E3dCMRpbRi6jb/uSblT7A0Y6Dl6jfWGUMAHYEt2CAPcHyPOsZIv4PF339AHF32fdGMr50ibSfqFPT+zhmDF1luDdwAKfgLfUVhoq4Fbb3DHZIDhTmWCiRA9wsvC/ndozTfi2fjRrLJRoCN+tUhTecVSMmgWX2uvLay8enkr88bcCkF7eA3iGHOq4yphOvDLh908ILFSKJCIQVCTbm/np0suIOVrilmqSqnQhzuQSorGQRA8tetXGzWeSobWxvgslXeA01GA7tQx8McZtMxKQzQA9Q34ge2BrX6L4x+XwREn2ydB7XvLKBztzF6eyDos5/7Sq1B++C5i1ScYHTLBRxFeQSmUcQKte/GPtYWo8O17twCkOOswWknXtEZlPxbC5A+1R7k0s+usF7i39zKnbo//T78pcuREFMJdAV9kN0gKvH7fmll6sbrO6L3S6YxtoKVMVZ0m2cKpRx6wLWeDO/4o9aG8k2UuebKqHN3Aas8kKnQFfffQwUL/FgMsj88uZie0rq0zOVUJMB8jtiIuthWGUoUtccNvZgIC3roJmRaFxLyswmlnSujgb1nFz4081EymFKI+/Feoy03xu21fUW7TZuSgTZVmSDFDXsV4vOO9++tFGSD3yY+vUz34nFvC8x+CG2MNqW702eMj6tt5yTqlW50oasXiqfpWnvdyn2JUBx5p/KLry5cAMBYp/eDedUupNOI0RZgspZA6KjVIP5Jfrq7+BWp74Uex77q2CG/W2AbkFI83kq
 MgblkH5r
 9Rj9kSbFYcKfr07hpqvSwgfbJ2AVNMECXRuhbT+/j7uX31/VljVC7v+5OxSUVFaGQ7fPYpcewmOJA8S6WgnSUrNoEn7JdZcs83m4RNaXp45c5dwLyRMNEbJxi4kr/1xoBNU71hrhNa7AqLs/4jVBL9iFHZe6rzTFVO75sDoS4cC2G5mtp9xuOi0PLmwwQWMPWKok/WrXAsRpHrnkigERg8zrvruBjyps883ETq2KiMXCkPhSmFMKhqTaO9mI/f2TH70phAFP2jJAcTqAw7P9RcYS6d3kYPGLZcJt33g2U4dGFqI4/Q6FxP58S+X7Iy1prw/kOBhVfB4CazbxrEJ4PfNMvTQ7IlLfPlSt3iVHmHnrON77CEHexKuATIQFrSEH6J0NurmUHpCm8z7m+U3aZ7vHGhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/26 22:27, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 26, 2026 at 09:00:54PM +0800, Lance Yang wrote:
>> KSM loses userfaultfd protection when replace_page() builds a new PTE
>> from vma->vm_page_prot. Dropping its uffd bit lets a subsequent write go
>> through ordinary COW instead of userfaultfd write protection handling. For
>> RWP, a merged page also becomes readable without faulting.
> 
> I feel we probably shouldn't have allowed an extension to UFFD while it's still
> fundamentally a broken feature :))
> 
> Which is evidenced by the SLEW of AI bug reports, and human-reported bug
> reports, and endless history of bug reports and it infecting the rest of mm,
> etc. etc. /rant

Heh, UFFD isn't winning you over today :D

>>
>> Keeping the uffd bit and restoring PAGE_NONE fixes merging, but we also
>> have to handle unmerging. An existing KSM page can be protected with RWP
>> before MADV_UNMERGEABLE, so unmerging already needs fixing independently
>> of preserving RWP during merging.
>>
>> Unsharing replaces a shared page with a private one and should leave
>> userfaultfd protection in place, as do_wp_page() already does for write
>> protection. Currently, an unshare fault reaches do_uffd_rwp() before it
>> can proceed to do_wp_page().
>>
>> - With synchronous RWP, handle_userfault() returns VM_FAULT_SIGBUS.
>>    break_ksm() then reports success with a KSM page still merged.
>>
>> - With asynchronous RWP, protection is cleared before unsharing.
>>
>> Preserve the uffd bit when merging, and restore PAGE_NONE for RWP. Let
>> FAULT_FLAG_UNSHARE skip RWP fault handling and keep PAGE_NONE on each
>> private copy as well. Unsharing can then complete with RWP still armed
>> for a subsequent access.
>>
>> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
>> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
>> Link: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
>> Link: https://lore.kernel.org/all/20261020055518.36087-1-lance.yang@linux.dev/
>> Cc: stable@vger.kernel.org
>> Co-developed-by: Samarth Narang <samarth.colleges@gmail.com>
>> Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> 
> Looks sensible to me so:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Really appreciated!

>> ---
>>   mm/ksm.c    |  8 +++++++-
>>   mm/memory.c | 14 ++++++++++----
>>   2 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 910a1307ac9f..d6f736a1aa2f 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -34,6 +34,7 @@
>>   #include <linux/memory.h>
>>   #include <linux/mmu_notifier.h>
>>   #include <linux/swap.h>
>> +#include <linux/userfaultfd_k.h>
>>   #include <linux/ksm.h>
>>   #include <linux/hashtable.h>
>>   #include <linux/freezer.h>
>> @@ -1463,9 +1464,14 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
>>   		dec_mm_counter(mm, MM_ANONPAGES);
>>   	}
>>
>> -	/* Preserve soft-dirty when replacing the page. */
>> +	/* Preserve soft-dirty and uffd protection when replacing the page. */
>>   	if (pte_soft_dirty(orig_pte))
>>   		newpte = pte_mksoft_dirty(newpte);
>> +	if (pte_uffd(orig_pte)) {
>> +		newpte = pte_mkuffd(newpte);
>> +		if (userfaultfd_rwp(vma))
>> +			newpte = pte_modify(newpte, PAGE_NONE);
> 
> OK, so by definition, RWP pages are protnone, and this resets it correctly.

Right, we need PAGE_NONE back as well as the uffd bit :)

>> +	}
>>
>>   	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
>>   	/*
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 6a93b7fa48b2..99439a7afa63 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4122,8 +4122,11 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
>>   		if (unlikely(unshare)) {
>>   			if (pte_soft_dirty(vmf->orig_pte))
>>   				entry = pte_mksoft_dirty(entry);
>> -			if (pte_uffd(vmf->orig_pte))
>> +			if (pte_uffd(vmf->orig_pte)) {
>>   				entry = pte_mkuffd(entry);
>> +				if (userfaultfd_rwp(vma))
>> +					entry = pte_modify(entry, PAGE_NONE);
>> +			}
> 
> Could this be abstracted? You're doing the same pattern here, which also exists
> in copy_present_page() and presumably many other places.
> 
> But maybe that's one for a follow up?

Yeah, a helper would be nice here. I'd keep this fix small and do that
as a follow-up :D

Cheers, Lance

>>   		} else {
>>   			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>>   		}
>> @@ -6659,9 +6662,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>>   		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
>>   		 * NUMA hinting and must still fall through to do_numa_page().
>>   		 */
>> -		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
>> -			return do_uffd_rwp(vmf);
>> -		return do_numa_page(vmf);
>> +		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte)) {
>> +			if (!(vmf->flags & FAULT_FLAG_UNSHARE))
>> +				return do_uffd_rwp(vmf);
>> +		} else {
>> +			return do_numa_page(vmf);
>> +		}
>>   	}
>>
>>   	spin_lock(vmf->ptl);
>> --
>> 2.49.0
>>
> 
> --
> Cheers, Lorenzo


