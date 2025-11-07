Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5141BCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 08:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9988E000A; Fri,  7 Nov 2025 03:59:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC15C8E0002; Fri,  7 Nov 2025 03:59:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FEAD8E000A; Fri,  7 Nov 2025 03:59:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90B9C8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:59:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36D0FB8E4F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:59:44 +0000 (UTC)
X-FDA: 84083213088.07.5A908EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8627F4000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:59:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YWCKRYcH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762505982; a=rsa-sha256;
	cv=none;
	b=av2KdLQhvJysNFE7G9JbEWLbfkbXvEyQ4f8whE+Od+Bko0/P2rdn5f1A6fOK0l3VuPhjaV
	BUC8kSa1IWtMGLVzxh1pQuIKxSgRAC8vsoOud6VA5Y7j0kOnAtbDWi2hYi/dfePo6Lo61o
	FFgocPwX6PKd4RvWMaWvHZp9Pt0ZMJc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YWCKRYcH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762505982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcQmnaYHQ5HYoPTVc1bAsUaRVYW31APmu4WDLHIO37A=;
	b=M336FEKsSYVuo6p3OFRVCA+dx/UWTIpR/+66ni4rOtttDPf9PPuQOQqCVTU56VEQNcgZba
	BXLUUwCjLwDZXfTTorELhviaN8fitSqq4xiVwvvFyWn8kQF3eUUznAwmWRPSXMIARSMcON
	JYGUHbKExkfFCIc4gKyEQYYc5STOHE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 133B46013B;
	Fri,  7 Nov 2025 08:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709B4C4CEF5;
	Fri,  7 Nov 2025 08:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762505981;
	bh=1cEOC2jcm0VXC7GcvRmuZj9kiS1YKJGfs50Jfr0agNU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YWCKRYcHldP2qaFfyuTLw7bLSDGTzaIYmWgsCX1WKZBbq4oynkcSk0qmrMgRe2dnM
	 bOIf3Du/lRLpehU0JZUcoDnXOkgGNgjaPIjrGNkMTe/Jalnj5PkECR1tF58ytoZ7u+
	 n8EQGZ0SHqONXVMb5kIPmX4xqoarJufqR2/D1TyeJTKey6o4tlFhug7gExBl/AyD82
	 m+dyE5PLWi7SNJjQGIS2Dwja5MgypbZqQ21mjwJzS04R3lEZ/HhbcRYtVpEvJPopTb
	 CzO5IcXOktCnKeRxabcda9ieIVN54RS3C+h7UJC52vML+lDPVdy6cJPr4dAjKbOqPS
	 p97gG2jYnBdVA==
Message-ID: <52f67ca1-24c6-4081-99e6-0a1d30da1bd6@kernel.org>
Date: Fri, 7 Nov 2025 09:59:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/7] mm: folio_zero_user: clear contiguous pages
To: Ankur Arora <ankur.a.arora@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org, acme@kernel.org,
 namhyung@kernel.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027143309.4331a65f38f05ea95d9e46ad@linux-foundation.org>
 <87qzunq6v4.fsf@oracle.com> <87h5v676f4.fsf@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87h5v676f4.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8627F4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: dnysoeozehxgh85u6r14pn1o4cjenimh
X-Rspam-User: 
X-HE-Tag: 1762505982-220439
X-HE-Meta: U2FsdGVkX19tVHqfFKm9UeVuom6PZf49BhEux/ko9U5aBkFEo4ELSO3HrPpYF0/Pjk+g2w1mCVYOlw4Qf052HLaysAR0BiRRS6mLI0dFjbL3chikv9GyBYLtPtjjdLUpMdV6EhfULuooO7OR+eulVrw6vhfXKtmYUO8DJoCV+hd/LEK9moJuOH/oGtNDsxSAG1fuvEgJDZa/QJgMvywS9bNC0W//MMcRSsWtoiOgufQjDyJlnb6Z7RmvDha/9iXPWFcEyLf59sOPHy8gitlw//0Bimtsluwc6aNmnSyhsuv9WDRLWuXrsq/wRJNuLsE0cr0N4iTG+hBBraDIJvmJYMDXs7tk59tvM/DJsy1fho5TE3b+Aez0bpJYZXZSvgfiQJVhJZ4c9D+L6Hm8a/3ae5sXLCFFnu815vYSabsT6linMOdN/zLrUTwfVdGazbrXcuBuVsn54wTnliudc32dwEkOC0opQsUHc+80Ef1KfBV6vwe03kPGzK1v4zNBslFAnDFP0Yxz6XQYNvu1BG9l1b2PZ5FQ3AsVz3nRqRDyZnJ6EPKMwRQaDAe0K+icmpaTkCBIo6jYmYvJykSF10vtzJ6jkXGQJeb7PYfIkNIoPuSRMz6AzqIe1dLM6pnGQhkiOkuj1fz7hPx1OijBtGZv809UufHKS2Ds7O6NYJiPEmGOqzoqEJCbWbdsnt/NQhPUZFcqhVZnY3QKA74mKfzjmVmIvGCl+FDNdBROo56CQfNcXe0+/c2jUf/kZcCga0K4IhBWRoniYNjeLN//eGRlIpXDWlBk7r49tpdIhxBtSGuBvKnhRzo8t92XZ8RytUoxYW3ZAnUwhQiPdgpb6xcBXH/r7k0iXB5VNQ8+LGS00NqU21nRA2yYp7uwcba/UN8zueR4Z0Gdefvlutd6VtMdvlr5lgOpwpO82RlRK7oZfRo/epBf0eVHh93IrkayxZR/ebM2RP6QzNkh1zNx7sj
 YH0R8ilM
 AkSN04Xw4KJXFfFpjwxLluYQJszn0gH9b0zpshsxkFb9bz+T3xPNa7l6iKAZv0id9b4U+HLYz5YXRz5cU2iaU4vrLuTUTSo+Enba5eutk+eBDXvRRS8E4NGEdzEXWKH46umYDIiHSPh8COKEj2KqsahYx1e+zhC7DmtNMWeQLt6ibv8kYfd0sHPvZ/VlzLA5skZiZqYhxv5nrgwCBO2C5PLdq3RsshYDGD/ksHAMpYuojWQf2t9LydN6vompoF8BZ9ZDqc0IUhnkxsEaxIZpQY10dZfTARZhdAsAce+lG+AlmunRithLZfO0Za2G4erewmAzbOonADWz0CFFWZw3qwGuF+ODlVdyCPrAZPABV2OehFAW38a4khdx15eR1zEI9Yy33ujUNnRDoIAdWjPCBvDBBnbAyoH5DdL8f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.11.25 06:33, Ankur Arora wrote:
> 
> Ankur Arora <ankur.a.arora@oracle.com> writes:
> 
>> [ My earlier reply to this ate up some of the headers and broke out of
>> the thread. Resending. ]
>>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>>
>>> On Mon, 27 Oct 2025 13:21:02 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>>
> 
> [ ... ]
> 
>>
>>> It's possible that we're being excessively aggressive with those
>>> cond_resched()s.  Have you investigating tuning their frequency so we
>>> can use larger extent sizes with these preemption models?
>>
>>
>> folio_zero_user() does a small part of that: for 2MB pages the clearing
>> is split in three parts with an intervening cond_resched() for each.
>>
>> This is of course much simpler than the process_huge_page() approach where
>> we do a left right dance around the faulting page.
>>
>> I had implemented a version of process_huge_page() with larger extent
>> sizes that narrowed as we got closer to the faulting page in [a] (x86
>> performance was similar to the current series. See [b]).
>>
>> In hindsight however, that felt too elaborate and probably unnecessary
>> on most modern systems where you have reasonably large caches.
>> Where it might help, however, is on more cache constrained systems where
>> the spatial locality really does matter.
>>
>> So, my idea was to start with a simple version, get some testing and
>> then fill in the gaps instead of starting with something like [a].
>>
>>
>> [a] https://lore.kernel.org/lkml/20220606203725.1313715-1-ankur.a.arora@oracle.com/#r
>> [b] https://lore.kernel.org/lkml/20220606202109.1306034-1-ankur.a.arora@oracle.com/
>>
>>>> The anon-w-seq test in the vm-scalability benchmark, however, does show
>>>> worse performance with utime increasing by ~9%:
>>>>
>>>>                           stime                  utime
>>>>
>>>>    baseline         1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>>>>    +series          1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
>>>>
>>>> In part this is because anon-w-seq runs with 384 processes zeroing
>>>> anonymously mapped memory which they then access sequentially. As
>>>> such this is a likely uncommon pattern where the memory bandwidth
>>>> is saturated while also being cache limited because we access the
>>>> entire region.
>>>>
>>>> Raghavendra also tested previous version of the series on AMD Genoa [1].
>>>
>>> I suggest you paste Raghavendra's results into this [0/N] - it's
>>> important material.
>>
>> Thanks. Will do.
>>
>>>>
>>>> ...
>>>>
>>>>   arch/alpha/include/asm/page.h      |  1 -
>>>>   arch/arc/include/asm/page.h        |  2 +
>>>>   arch/arm/include/asm/page-nommu.h  |  1 -
>>>>   arch/arm64/include/asm/page.h      |  1 -
>>>>   arch/csky/abiv1/inc/abi/page.h     |  1 +
>>>>   arch/csky/abiv2/inc/abi/page.h     |  7 ---
>>>>   arch/hexagon/include/asm/page.h    |  1 -
>>>>   arch/loongarch/include/asm/page.h  |  1 -
>>>>   arch/m68k/include/asm/page_mm.h    |  1 +
>>>>   arch/m68k/include/asm/page_no.h    |  1 -
>>>>   arch/microblaze/include/asm/page.h |  1 -
>>>>   arch/mips/include/asm/page.h       |  1 +
>>>>   arch/nios2/include/asm/page.h      |  1 +
>>>>   arch/openrisc/include/asm/page.h   |  1 -
>>>>   arch/parisc/include/asm/page.h     |  1 -
>>>>   arch/powerpc/include/asm/page.h    |  1 +
>>>>   arch/riscv/include/asm/page.h      |  1 -
>>>>   arch/s390/include/asm/page.h       |  1 -
>>>>   arch/sparc/include/asm/page_32.h   |  2 +
>>>>   arch/sparc/include/asm/page_64.h   |  1 +
>>>>   arch/um/include/asm/page.h         |  1 -
>>>>   arch/x86/include/asm/page.h        |  6 ---
>>>>   arch/x86/include/asm/page_32.h     |  6 +++
>>>>   arch/x86/include/asm/page_64.h     | 64 ++++++++++++++++++-----
>>>>   arch/x86/lib/clear_page_64.S       | 39 +++-----------
>>>>   arch/xtensa/include/asm/page.h     |  1 -
>>>>   include/linux/highmem.h            | 29 +++++++++++
>>>>   include/linux/mm.h                 | 69 +++++++++++++++++++++++++
>>>>   mm/memory.c                        | 82 ++++++++++++++++++++++--------
>>>>   mm/util.c                          | 13 +++++
>>>>   30 files changed, 247 insertions(+), 91 deletions(-)
>>>
>>> I guess this is an mm.git thing, with x86 acks (please).
>>
>> Ack that.
>>
>>> The documented review activity is rather thin at this time so I'll sit
>>> this out for a while.  Please ping me next week and we can reassess,
>>
>> Will do. And, thanks for the quick look!
> 
> Hi Andrew
> 
> So, the comments I have so far are mostly about clarity around the
> connection with preempt model and some cleanups on the x86 patches.
> 
> Other than that, my major concern is wider testing (platforms and
> workloads) than mine has been.
> 
> Could you take another look at the series and see what else you think
> it needs.

Sorry for the delay from my side, I took another look at patches and had 
some smaller comments.

-- 
Cheers

David

