Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F8A106B506
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 12:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F6B6B009E; Wed, 25 Mar 2026 08:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499B26B009F; Wed, 25 Mar 2026 08:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361236B00A2; Wed, 25 Mar 2026 08:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0806B009E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:04:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B9258C5E6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:04:57 +0000 (UTC)
X-FDA: 84584454234.10.808B6CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BDA9EA0008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:04:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKN7uXIu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774440295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPc4STJE/x6x8Oul04qpR4/yHv8YWznPcxuIhmSRqjU=;
	b=Kil9mcJWvRYPJPJAI+1HUzbZmLBu2j9v0UaGfRHJFqA7BFL2mGgmL8kuCgorw3JdwirlW3
	N+jKZhxdDRAyYYV0FNR6liZ/fjzp/eLamujmCkTL/LhAYPH5hG5PMVTpbMvHIUFhl48eAu
	/cSZYj66SMxCgcG8MQFFD06yQK/qgJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774440295; a=rsa-sha256;
	cv=none;
	b=O4ptm2j/ukso/56rGn0ViJ7usN4vMSh8VhGTqqKUr8hUX+A8AGyPhIe08XV5oOcprcX3wp
	4GH51iqT/3kiGq2+oVmdszz23MGIYJR5FEaDs2S/LgYL2Bpz8VVSTnxKHQuBw9CFr2Ckq6
	SCnYtNFFb8AiPbJHN9x71vdAFFqbxHw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKN7uXIu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EEB7F60123;
	Wed, 25 Mar 2026 12:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CEDC4CEF7;
	Wed, 25 Mar 2026 12:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774440294;
	bh=0JxGquwGllu59MQoMGnhiUMWHEi9Fyc1zjuGzrsi+B4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aKN7uXIuWvlHJ/5PE2WPFEYpSParsl4Z7AKaTvPjdBvZC7+6cTZrqJmJ8YLHDkODx
	 /O4KXHUR34WALHdQQDAzH1utYjBSUzH2P8NET1PhjNycSpjGovsx8xc1Sy/jd9fxtE
	 7DHupDdP4zWZbgdcoqoshqM4OodcyERX6Z6Wninx9o4kEl7T1il17jXVqps1x4fWbJ
	 1LFZO0DM8DcyW9Y+RkhSaIM2adSCeNhmI47dX00oFVwrqFRVYdusD8hkIOiPhVtO4r
	 dtW4kRwIp8K+84wZpzyAxwr0U3rcuBNeXpuwNDZz+HXQlP+3rzBqmQoffQvVGH4v5B
	 RSsPuuQoyZCuQ==
Date: Wed, 25 Mar 2026 12:04:51 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com, 
	catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, willy@infradead.org, 
	hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Message-ID: <e93fb7ea-b838-4724-959c-212fa3513b20@lucifer.local>
References: <20260217145026.3880286-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260217145026.3880286-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: BDA9EA0008
X-Stat-Signature: nxkx617pjx873bppz3sy4p8xehfi6o9a
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774440295-236902
X-HE-Meta: U2FsdGVkX19yL/YsLg3IN/juXmyyLMPvv/PRRQJ9rm6t58gwGZ4FK3Y1IH9rVFN03jWbfopWc6+YlyaH5g3KZRYw8dPWn3QwoglbJVDaktvhao7I9hoWfrg2GZkCAWI5vO47iHvZ/cLygjeLiirU+L/Lxov88CJFw70/OWHpQM6ZzoDxxQPZtbx1Nyw+5bPMgBgK1EEBA4egk7fYFFo3WULWasKz/0JbbVbzIHhh2EdNnyI5V4x3yMx4qwmrTzrLS+9oVdGYExyF3XsYtYUKRAfoxHXLLuP1nXM7nkJluiJHc/DdUmE3gpDnZrlocXGQrzT5iHBi1dfZ1Ih2SP63hGwvobbpkG459d/c5PktFK0dbZ0JT7IlnSyhMk1CsTC/BJOPeV9sHMzRkLwerb/o9mz0G1CdOvmvNjBxQjv9c+POIR4Hawlzwj78qGE4t9CLkcYcIX7xEQe0uzqiZeXLTjrwSj2iwjdkmqdpzMtkgV4f26F7P+qoSCX3uhvSZLPAvo1Cn35i8MhH54dWxfP8xX3yt414cJOXvD+fVcbrJJSpU7vtiAI5hi06kHWV6VKpECEk8BpXzVp3wOPhEc0RSR3Lv9FOWOFA6bL9KaMTkQ+fBsr51kjfQBhcEQfKaClOV6ONvVPFtrmwPojUCajilFp253pBgo+hsUw6PD2BA1VQPhIQd/2SNB/OmLiNhftGwr3YjipOk/j8N0bOHu8Ghye/NNF8s2/7dV4yLHzMxcoQYt0FFUIqt9JYRBSQNhCWoyagfgbpbyguOvH+13BDJfss2PG1BdRgoJCv9P7L1iEuKvG0pqcNIu1eOe9BjOgObt6aYTo++kUtmBq42w3swoIO2n0/HgmMyckbJLl7RDJg7i8p1yOioMmNPYhrjc+gFQnXmbtTPfKA9sT8GS4j3BuIF2sYgcsa6mdO986nr8ctEy29G+zlq7SYc/PkZSYVbA8J1prTDrNWyBN5dOH
 Q1V4+8Z4
 2vZ0L5PiH6Uj6ZL5QDOXuAZGq2zbdYSRI7qAN7p0OggGAbLtvdYW60Uv7VjX1FoOogqL252rwVfJEflq+bjQaFKGuf/pwK1ooArlvRA8dYxaa1c5arGYNCEke8i5Z1uHwpSI1E5DyCQEZytJ2ABwEFlegedovaquhD7tiHYDVQ+yb05euXPDDoPZ7ah0y4DNHD7cTHVXazQUBPWj21OCe+GaJmT5FkeHtkSGf/H6DU5paoIvLYgWAxCJFGjlmm/e0U0kRySJ+sspejs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry if I repeat points others have raised, but I've just not had the time to
look at LSF/MM topics.

On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
> Hi everyone,
>
> We propose per-process page size on arm64. Although the proposal is for
> arm64, perhaps the concept can be extended to other arches, thus the
> generic topic name.

Well it's inevitably going to interact with core mm right and be super invasive?
So it's not just an arm64-only thing unless you feel you can keep it all in
arch/arm?

So you're asking essentially core mm to be radically altered to support an
arch-dependent feature.

I think we should be clear about that.

>
> -------------
> INTRODUCTION
> -------------
> While mTHP has brought the performance of many workloads running on an arm64 4K

Honestly this whole suggestion to me - instinctively - feels like 'mTHP doesn't
do what we want, so let's work around it'.

Wouldn't it be better to improve mTHP to provide what you are looking for?

> kernel closer to that of the performance on an arm64 64K kernel, a performance
> gap still remains. This is attributed to a combination of greater number of
> pgtable levels, less reach within the walk cache and higher data cache footprint
> for pgtable memory. At the same time, 64K is not suitable for general

This all sounds like things mTHP can address.

> purpose environments due to it's significantly higher memory footprint.
>
> To solve this, we have been experimenting with a concept called "per-process
> page size". This breaks the historic assumption of a single page size for the
> entire system: a process will now operate on a page size ABI that is greater

Fundamentally you'd be adding a great deal more complexity into mm, so the
trade-off has to be really excellent for that to be worthwhile.

It also essentially, to me, spells a giving up on mTHP ever being something that
automatically gives us what we want in these regards.

> than or equal to the kernel's page size. This is enabled by a key architectural
> feature on Arm: the separation of user and kernel page tables.

Isn't that true of every architecture? I mean we map userland and kernel memory
separately everywhere right?

Presumably you mean that arm64 has a feature whereby there are always entirely
separate page table structures for each.

But the kernel _regularly_ manipulates userland memory mappings, directly via
uaccess, via GUP, page table set up and manipulation via rmap etc. etc. etc.

uaccess means the kernel uses the same page tables that userland uses.

So is the proposed mechanism contpte or actually having a base page size at
higher granularity? Presumably the latter.

GUP fast as well is another concern - how can that be kept working with all
this?

And TLB maintenance, now you're dealing with fundamentally different
granularity, the kernel will have to surely become 'enlightened' somehow
(IOW - radically altered adding further complexity and bug risk) to handle
that?

>
> This can also lead to a future of a single kernel image instead of 4K, 16K
> and 64K images.

Except then every bit of kernel memory is at what 4K? Surely there's perf impact
there too..

I wonder about how on earth pageblocks are supposed to work in this
mechanism. Because now the whole heuristic means of avoiding fragmentation for
PMD sized pages won't work anywhere, because any given process might need more.

And pageblocks are currently broken for 64KB page size anyway, as the reserves
required are huge due to 64KB PMD size being gigantic (512GB isn't it?)

And then, there's the page cache :) but I guess we address that below.

I do wonder how this is supposed to interact with THP and mTHP which now
will have to maintain entirely separate PMD sizes depending on process
surely?

I mean correct me if I've misinterpreted and you intend to implement this
using contpte's or something, but if you are I'd ask why don't we just
improve mTHP?

>
> --------------
> CURRENT DESIGN
> --------------
> The design is based on one core idea; most of the kernel continues to believe
> there is only one page size in use across the whole system. That page size is
> the size selected at compile-time, as is done today. But every process (more
> accurately mm_struct) has a page size ABI which is one of the 3 page sizes
> (4K, 16K or 64K) as long as that page size is greater than or equal to the
> kernel page size (kernel page size is the macro PAGE_SIZE).
>
> Pagesize selection
> ------------------
> A process' selected page size ABI comes into force at execve() time and
> remains fixed until the process exits or until the next execve(). Any forked
> processes inherit the page size of their parent.
> The personality() mechanism already exists for similar cases, so we propose
> to extend it to enable specifying the required page size.

Well it's designed for providing basic compatibility layers and address
space limits and so on, this feels like something _hugely_ more impactful.

Doesn't personality() _immediately_ change the current process's state? I
don't think we should implement that that way.

If we were to do this, I'd say something like a clone flag would be better
maybe? or an elf setting.

I also wonder the degree to which kernel mechanisms already assume
PAGE_SIZE == userland PAGE_SIZE.

We'd have to rework all of the page table walkers for one no?

>
> There are 3 layers to the design. The first two are not arch-dependent,
> and makes Linux support a per-process pagesize ABI. The last layer is
> arch-specific.
>
> 1. ABI adapter
> --------------
> A translation layer is added at the syscall boundary to convert between the
> process page size and the kernel page size. This effectively means enforcing
> alignment requirements for addresses passed to syscalls and ensuring that
> quantities passed as “number of pages” are interpreted relative to the process
> page size and not the kernel page size. In this way the process has the illusion
> that it is working in units of its page size, but the kernel is working in
> units of the kernel page size.

I mean I think we'd also need to radically alter a lot of other things. But
this is already adding a bunch of complexity and ways for things to be
buggy and broken.

>
> 2. Generic Linux MM enlightenment
> ---------------------------------
> We enlighten the Linux MM code to always hand out memory in the granularity
> of process pages. Most of this work is greatly simplified because of the
> existing mTHP allocation paths, and the ongoing support for large folios
> across different areas of the kernel. The process order will be used as the
> hard minimum mTHP order to allocate.

I mean, this is again another radical change everywhere. I don't understand
'the process order will be used as the hard minimum mTHP order to
allocate'.

So now we're allocating all physical memory for these processes using mTHP
somehow? How does the mTHP mechanism interact with this?

What will `cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size` show?
And HugePageSize in /proc/meminfo?

Presumably:

sysconf(_SC_PAGESIZE); / getconf PAGE_SIZE/PAGESIZE

Also there's the thorny thing of in /proc/$pid/smaps 'MMUPageSize'
vs. 'KernelPageSize', which was instituted to handle some PPC-specific I
think variation in the two.

This was updated after recent discussions by David at:

https://lore.kernel.org/linux-mm/20260306081916.38872-1-david@kernel.org/

"KernelPageSize" always corresponds to "MMUPageSize", except when a larger
kernel page size is emulated on a system with a smaller page size used by the
MMU, which is the case for some PPC64 setups with hugetlb."

This will be invalidated if we change these, but surely you'd have to?

Also w.r.t. hugetlb how will PMD sharing work across processes with
different page size?

And what about drivers that allocate PAGE_SIZE memory to share with
userland? This does happen, or at the wrong granularity?

How can they be 'educated' to allocate the right amount of memory? I don't
see a way around one that actually.

Also what about bounce buffers for e.g. /proc/kcore?

And talking about proc, what about procfs interfaces that count per-page,
except they won't be counting per-page any more, they'll be counting
per-kernel page...?

What about bpf hooks that rely on page size? Surely we're potentially
breaking things there?

(Sorry just asking questions as they come up in my mind)

THP now surely has multiple different PMD sizes to contend with, but is
also being used to provide the mTHP-sized folios to the process?...

I mean unless you intend that these processes are just implementing page
table size via contpte only, and keep userland page size = kernel page size
except for this, but then the question again becomes 'what in mTHP is not
working such that you feel you need to do this'?

>
> File memory
> -----------
> For a growing list of compliant file systems, large folios can already be
> stored in the page cache. There is even a mechanism, introduced to support
> filesystems with block sizes larger than the system page size, to set a
> hard-minimum size for folios on a per-address-space basis. This mechanism
> will be reused and extended to service the per-process page size requirements.
>
> One key reason that the 64K kernel currently consumes considerably more memory
> than the 4K kernel is that Linux systems often have lots of small
> configuration files which each require a page in the page cache. But these
> small files are (likely) only used by certain processes. So, we prefer to
> continue to cache those using a 4K page.
> Therefore, if a process with a larger page size maps a file whose pagecache
> contains smaller folios, we drop them and re-read the range with a folio
> order at least that of the process order.

Yeah this is surely terrible? One process can cause evictions from the page
cache for others, then when they get scheduled they drop them again and
again over and over and over just because files are being accessed by
different processes no?

I don't think this is at all workable, unless I'm missing something?

This feels like you need a complete rework of the page cache to implement
this really, and I wonder at that being a realistic goal.

>
> 3. Translation from Linux pagetable to native pagetable
> -------------------------------------------------------
> Assume the case of a kernel pagesize of 4K and app pagesize of 64K.
> Now that enlightenment is done, it is guaranteed that every single mapping
> in the 4K pagetable (which we call the Linux pagetable) is of granularity
> at least 64K. In the arm64 MM code, we maintain a "native" pagetable per
> mm_struct, which is based off a 64K geometry. Because of the guarantee

I mean yeah, this 'enlightenment' feels a lot more like - radically
altering a ton of mm code and never quite being sure it will all work :)

> aforementioned, any pagetable operation on the Linux pagetable
> (set_ptes, clear_flush_ptes, modify_prot_start_ptes, etc) is going to happen
> at a granularity of at least 16 PTEs - therefore we can translate this
> operation to modify a single PTE entry in the native pagetable.
> Given that enlightenment may miss corner cases, we insert a warning in the
> architecture code - on being presented with an operation not translatable

Yeah this is already hugely concerning, introducing subtle ways to break
things.

> into a native operation, we fallback to the Linux pagetable, thus losing
> the benefits borne out of the pagetable geometry but keeping
> the emulation intact.

I really dislike the idea of maintaining an 'emulation' between userland
and the kernel on a fundamental basis. The kernel is supposed to deal with
the system 'as it is'.

Adding layers of abstraction just adds ever more possibilities of ever more
subtle and difficult-to-solve bugs.

>
> -----------------------
> What we want to discuss
> -----------------------

I think we also need to discuss whether this is generally viable or a good
idea :)

I suppose that is implicit.

>  - Are there other arches which could benefit from this?
>  - What level of compatibility we can achieve - is it even possible to
>    contain userspace within the emulated ABI?
>  - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
>    example, what happens when a 64K process opens a procfs file of
>    a 4K process?
>  - native pgtable implementation - perhaps inspiration can be taken
>    from other arches with an involved pgtable logic (ppc, s390)?
>
> -------------
> Key Attendees
> -------------
>  - Ryan Roberts (co-presenter)
>  - mm folks (David Hildenbrand, Matthew Wilcox, Liam Howlett, Lorenzo Stoakes,
>              and many others)

Thanks :)

>  - arch folks

Overall this feels like a workaround for mTHP not doing what you want, and
to me that speaks to us needing to improve mTHP rather than add a ton of
complexity.

I fear we are only touching the tip of the iceberg of ways in which this
could break.

Regards, Lorenzo

