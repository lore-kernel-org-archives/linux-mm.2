Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BABE9A04A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 16:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4086B0005; Thu, 19 Feb 2026 11:09:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91806B0089; Thu, 19 Feb 2026 11:09:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93EB6B008A; Thu, 19 Feb 2026 11:09:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A55486B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:09:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE70FC218C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:09:28 +0000 (UTC)
X-FDA: 84461691216.03.044D004
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E34FA1C0018
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:09:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGbCRqRF;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771517367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdS0JhSAb7Qs9kly0xpc1v3K5l9Memkp8n9wmnYnU3M=;
	b=Hv72REITzU+9jx7LMEdSid9LtVrPkL3LDcJTaYELyYJxwM+V+brcYkzA+pAMHhij82BCN6
	b074/iIffm+8EAS2B7DGtVW88HmrauY5QH667Rcci3q8JIc6nprRctOTAsUArKt0ugEt4M
	Yzr3LzGwLUE1bpWTsO8po5r/qdS1qug=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGbCRqRF;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771517367; a=rsa-sha256;
	cv=none;
	b=yLvaIZUGawP/FlR1a6yE2JgLB/X992RQ2W9L2V4q2pc7PwuKJ0VPSQwAJtu00py2VGLnq3
	Qvp2+w23aSxr+2bKPYMc4m6hwM2wHtUe+qLO1JnhGolVvKH4V/VsTjqPXU+PXs3r0Kt7Wy
	0OLPCQxvggIVaHUEdbB3mnNl0+gUiXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D67D843F33;
	Thu, 19 Feb 2026 16:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD21C4CEF7;
	Thu, 19 Feb 2026 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771517365;
	bh=boOUalCJC3hYBCLJXs/ukOFBzgUXboyd5OOqwGud8VY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BGbCRqRF62S/hWsLFPP/eH9S7oEhgQkI6F31fs3obJTkY/3yxuBycefLwWlIsjUQv
	 cWSbHuaEl2rod179UchNchRwkh24IZfoAd1Urqj/krGOA31btg3mrVvN/3gEIr1uGe
	 JsOCDqubRBzpUuPr8FQk8x7LmiHUYDekHomTxuqznXCe/bc1Ak5B46p7A0S8JXk9Vf
	 u4yG2DDkAn9nGWdLuazBRyyPRnnesFGhIQHda+Ha2FyH1ZrJ1dsfTI+QUY0ZnOp47d
	 URrGlWdL4Kn+AlAqOxUYv9XLhgTbhiBmGMCE5YXjWZUjrv43QNJMYto85dG5vRp3fn
	 OSi6eAx/udhjg==
Message-ID: <f261995f-a45a-448d-b72d-18d476697d88@kernel.org>
Date: Thu, 19 Feb 2026 17:09:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZcxWsWO7AxQW6JC@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZcxWsWO7AxQW6JC@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fbh5znks9t7b46wig3yjb7t3cc8b8w48
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E34FA1C0018
X-HE-Tag: 1771517366-6467
X-HE-Meta: U2FsdGVkX18jaLYhQx5+Ej61pO0LYHje7aW1MYoUXrLT2pMuBvaAJVozJYGkHS3EtkKbnEPWuqwEjbG5hdn4v9vy/j+S47u9JR/UV5dRKPQ6f12KEZf3d0zPy9adPmr/JAel/AXbHwp/5mAohE+SV1cp3Nmt+8XksmdsC9GccgRUj974t2cGH1O1Y7nfqk4OJ80mr36LRFUJeMhwTPIs2mMJ+Dh3YDV2qqYwVau27MVIoZtZFiJMJkWXoJEjvsMlZv9xjLPJCd431k1Fvs50H3MG0aV1+TpGgal9UY9AzEBNf0JS+vIpNo1o1IL/a4OcT7uTMlib/9Fv2jaz6mEge7Pg75k5e84ap/OqGo7EImVlMUWYHXPACDlG8waEqxA5mcR445yWC+FKu2v6m0gmK7vMKRaHEqjs+peMZ6AwrGX1XDkGXeq7wyQRkgkv81gHFu5yrAuk8mwqBPZTPEVwaWwRYmZEfKD8D4Hb46iuwfcTgqMgB9h219beFUKcBisx4WW9FkQVL28wTtPU1s+e1+jvTfUT2G+tfvpNGshbFq1V5chhUMbeqGZdnmonCYgie778xCa2jF305miJ6a3C5UZDddWfJIBPJCDLqnNH00rMhmw7t3nPbYZTpiGe3QxbVyjoUa6BLGh6vicGOoKmr5scg22Vgd13hf9arIhW/bJEgMPfKGLLb3J6XNfqBHu11BqP3T/43QyMQwuEvJfGZdSUcr7RRgDflmmb4yvqYY0ZcAUN/TclTB/y6/+Rlcp9l5NeBD6pPj3mKEqKzr6A6QYyq8Rz519FFm9aeBZpcrwqm3ex21LaLjQW1myCAYtJIt5t0akeQxDcSUxfWBFhbxJcMhwSzZuJUFIlpL1gfe7v0Zs5p6FUjBIoCo01gIswSvzMw7f1jRldqLu9fNU8lzNh30WPihfEv2wnhdGc+79ZRYfApecNE5vziP3QEuJVfaM2fgDWxd65D9Z4GKN
 T9EbLO5z
 DSZfNL/f+2VnDmlni6VsYbWzwLQQrp9VrAGMKnb3BCdDMnQLHgTbYTDBxnoUW5p+F7BaxIyKpIIeYRc9CXoU8stSt5u7W/pHWxbevHaug13c+BmXppkw/TX7t5hR3UoKrh9gkPW2Gz5DJmijiS5fcI3PHB6B1njdDaVGuaTintRrrRGW4L5CjmySpAiAuyrPITd1s4EiMo/1gm68B2tzJdeHPbCgCpIm0ZCyvVG2pB4U+woQZOeeD9qY6s7B6Z9et0YxpvN2GeVVt8gY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 16:54, Kiryl Shutsemau wrote:
> On Thu, Feb 19, 2026 at 04:39:34PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/19/26 16:08, Kiryl Shutsemau wrote:
>>> No, there's no new hardware (that I know of). I want to explore what page size
>>> means.
>>>
>>> The kernel uses the same value - PAGE_SIZE - for two things:
>>>
>>>     - the order-0 buddy allocation size;
>>>
>>>     - the granularity of virtual address space mapping;
>>>
>>> I think we can benefit from separating these two meanings and allowing
>>> order-0 allocations to be larger than the virtual address space covered by a
>>> PTE entry.
>>>
>>> The main motivation is scalability. Managing memory on multi-terabyte
>>> machines in 4k is suboptimal, to say the least.
>>>
>>> Potential benefits of the approach (assuming 64k pages):
>>>
>>>     - The order-0 page size cuts struct page overhead by a factor of 16. From
>>>       ~1.6% of RAM to ~0.1%;
>>>
>>>     - TLB wins on machines with TLB coalescing as long as mapping is naturally
>>>       aligned;
>>>
>>>     - Order-5 allocation is 2M, resulting in less pressure on the zone lock;
>>>
>>>     - 1G pages are within possibility for the buddy allocator - order-14
>>>       allocation. It can open the road to 1G THPs.
>>>
>>>     - As with THP, fewer pages - less pressure on the LRU lock;
>>>
>>>     - ...
>>>
>>> The trade-off is memory waste (similar to what we have on architectures with
>>> native 64k pages today) and complexity, mostly in the core-MM code.
>>>
>>> == Design considerations ==
>>>
>>> I want to split PAGE_SIZE into two distinct values:
>>>
>>>     - PTE_SIZE defines the virtual address space granularity;
>>>
>>>     - PG_SIZE defines the size of the order-0 buddy allocation;
>>>
>>> PAGE_SIZE is only defined if PTE_SIZE == PG_SIZE. It will flag which code
>>> requires conversion, and keep existing code working while conversion is in
>>> progress.
>>>
>>> The same split happens for other page-related macros: mask, shift,
>>> alignment helpers, etc.
>>>
>>> PFNs are in PTE_SIZE units.
>>>
>>> The buddy allocator and page cache (as well as all I/O) operate in PG_SIZE
>>> units.
>>>
>>> Userspace mappings are maintained with PTE_SIZE granularity. No ABI changes
>>> for userspace. But we might want to communicate PG_SIZE to userspace to
>>> get the optimal results for userspace that cares.
>>>
>>> PTE_SIZE granularity requires a substantial rework of page fault and VMA
>>> handling:
>>>
>>>     - A struct page pointer and pgprot_t are not enough to create a PTE entry.
>>>       We also need the offset within the page we are creating the PTE for.
>>>
>>>     - Since the VMA start can be aligned arbitrarily with respect to the
>>>       underlying page, vma->vm_pgoff has to be changed to vma->vm_pteoff,
>>>       which is in PTE_SIZE units.
>>>
>>>     - The page fault handler needs to handle PTE_SIZE < PG_SIZE, including
>>>       misaligned cases;
>>>
>>> Page faults into file mappings are relatively simple to handle as we
>>> always have the page cache to refer to. So you can map only the part of the
>>> page that fits in the page table, similarly to fault-around.
>>>
>>> Anonymous and file-CoW faults should also be simple as long as the VMA is
>>> aligned to PG_SIZE in both the virtual address space and with respect to
>>> vm_pgoff. We might waste some memory on the ends of the VMA, but it is
>>> tolerable.
>>>
>>> Misaligned anonymous and file-CoW faults are a pain. Specifically, mapping
>>> pages across a page table boundary. In the worst case, a page is mapped across
>>> a PGD entry boundary and PTEs for the page have to be put in two separate
>>> subtrees of page tables.
>>>
>>> A naive implementation would map different pages on different sides of a
>>> page table boundary and accept the waste of one page per page table crossing.
>>> The hope is that misaligned mappings are rare, but this is suboptimal.
>>>
>>> mremap(2) is the ultimate stress test for the design.
>>>
>>> On x86, page tables are allocated from the buddy allocator and if PG_SIZE
>>> is greater than 4 KB, we need a way to pack multiple page tables into a
>>> single page. We could use the slab allocator for this, but it would
>>> require relocating the page-table metadata out of struct page.
>>
>> When discussing per-process page sizes with Ryan and Dev, I mentioned that
>> having a larger emulated page size could be interesting for other
>> architectures as well.
>>
>> That is, we would emulate a 64K page size on Intel for user space as well,
>> but let the OS work with 4K pages.
>>
>> We'd only allocate+map large folios into user space + pagecache, but still
>> allow for page tables etc. to not waste memory.
>>
>> So "most" of your allocations in the system would actually be at least 64k,
>> reducing zone lock contention etc.
> 
> I am not convinced emulation would help zone lock contention. I expect
> contention to be higher if page allocator would see a mix of 4k and 64k
> requests. It sounds like constant split/merge under the lock.

If most your allocations are larger, then there isn't that much 
splitting/merging.

There will be some for the < 64k allocations of course, but when all 
user space+page cache is >= 64 then the split/merge + zone lock should 
be heavily reduced.

> 
>> It doesn't solve all the problems you wanted to tackle on your list (e.g.,
>> "struct page" overhead, which will be sorted out by memdescs).
> 
> I don't think we can serve 1G pages out of buddy allocator with 4k
> order-0. And without it, I don't see how to get to a viable 1G THPs.

Zi Yan was one working on this, and I think we had ideas on how to make 
that work in the long run.

-- 
Cheers,

David

