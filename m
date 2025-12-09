Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0A9D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 06:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C3A6B0005; Tue,  9 Dec 2025 01:23:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA476B0007; Tue,  9 Dec 2025 01:23:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FDC6B0008; Tue,  9 Dec 2025 01:23:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C10F56B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:23:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A9555294F
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 06:23:10 +0000 (UTC)
X-FDA: 84198940140.21.9460D98
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B7B810000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 06:23:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VC4Ypqef;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765261388; a=rsa-sha256;
	cv=none;
	b=KpQmmYvhjuP+FRHvnZLFzJl1nSz2fPbHkqoUK4cF73+HkNsIyXTMXsB/19/n2P+xjhwtvZ
	2RPiSTYxEhds2+qNeMa0Ekd9H2MBWSaQzGGOBeZF+g3hWjy1amw8N0hLgif8G9n/7Rd6Bk
	EeMtuyjWS8MOB3vJBSgSEN9D3uYgwfg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VC4Ypqef;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765261388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CLk45ra1fYgW55XvsXvXAF/BHCLHprBL2qMpGLAoh8=;
	b=qwiuDhJw8QTvXaXv18OCKJu05hA3ZjtcvqJWrVp6CctdiKBoY7WT9XI1R4nRD8ykGJMPGt
	aBo43xfQ6Fdm+idNedn7MoqijUkIxR39zrzEYjyOueli5m3DVtKf6rJ65Y6XTM7/FYQ+H7
	aExzF51V9kYiqmPZEsWeHkPfOqvj91M=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765261386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+CLk45ra1fYgW55XvsXvXAF/BHCLHprBL2qMpGLAoh8=;
	b=VC4YpqefvEcJ6O+lIz39BT2VJbG3iP8kR+GpykLM3b8sfIy5MUjYXdk8kjZtCVXWnBbRCc
	U62fruicHGgyRSiywIAPRAhaCy0D2UbJgFOjXMl/vu362KK5Egk8J8VEz74ORbWXB19jWz
	pfNkHiewwrFs+mYVNGf0wrnZxjQa1kE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
Date: Tue, 9 Dec 2025 14:22:28 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4F9E5F2F-4B4D-4CE2-929D-1D12B1DB44F8@linux.dev>
References: <20251205194351.1646318-1-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5B7B810000C
X-Stat-Signature: dg1tmfcoskhgxqgzh4zqw95uwphw7wqx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765261388-814565
X-HE-Meta: U2FsdGVkX1/fAISknQHE/kOLdEYwpVjfuGKST6vOp4d2eaDRjoFFvDgmH1KdUpNlInl/va3nLqPQvtPO3WjV+36IpeMxhfMEFfo7RIJEeJw+d5WCBca4/2nJh4/j/HIoqNTZyIZmGmE2BxVKKy96x4wnzGI2NaBS0J5Rkez/tNYRw5Dju7NuqzvhfhnrmatFx03aWqkdJXvlgZNtSg3ue3dR4odcIYUJI1RTrYZun8YbrSXpfxZlQxdRo21rNKSdAiWSyeHEnu0JRlV9DPqtENp1Mfvc7U4hoxEbv1ClBpzoI24gW9020h17DDivxxeHK5QUHd0DKOTb5SZVr0sFOJHPwxqvuETdkQ6xPbX+tUZM2b07X37Ur/cMKWhMtJflaIh+USnx8W3AUGozXcyIFkhJBA1mXZqkqID3Ubdp15K+DYmm+ghtS1MIJ4ngBsneEz3RxEjHY6XTZGXOqFowu1S+blOCHZ+FNI8dP0hu3gBJxZLasFYGaAOY1G1bUpVILwVqAQfrUcb0YI0bWCiSiAgmdv84mIxv5Xio0kwcjmIbq6fK6rw25ZnPn8aEpuVy2RrjJbtZtzmwmeOtPRA3Q2pWwUVLGmnfLqsUQyB1in9xVIzeDr0WdSRRwfnEJY2WHpN1XlKH9DK6R8oHhDgi8UTVFb1CajOMQ00EhMzmFMKQz/Huq8B+wOQ6TbbIvd+POxHRmE1KjyoRPdZbevt+ySt++48zaDmIWPuK8h7NLN+jqVYOTLYu6EnCxcojrLVU5gAA+bc0WsVM65avf2qGxrotHqqI5BZk8O4VSF2+9yaU6vplANLVndfpy97W4Hi8H5yNRkphc0Nrc9bJ0heOAdvRz3Jl3j2cUoztDqDXQKL4xvjMh/G0Z/v7KdZKrg7glVR7pA6SwzOZV9n6C5ZZyHiG4HT9AV1L7JW16ru/FXQM7aD2uQHkKnJCLQ0+SpWTssPV2NZpNFAPh7vJT3B
 wr9NNOX4
 IHRfUgNNIO9YrCsbHBq3ZEIMK67ae6R7M2+XwmfmaTHmMXrJuYaWue7YQs7luyuTs//fqhaZdL28DWxFU7oJ3XjNrXDpZyZK/l8ExTtc3nROc9f/rLFxSCtUXIgau+Nhx6PINpQs5pS8emodJdVJ3IVdhV/hoWavDVKi/L8aA1YIBLaI3j4RoSHCD5835ZPSttBFtavBVt9Jzs+naaxr5m+zRimJApowGjSQN5Eck+IINBTkl4brXnZyz8dEEJ7qmLmKj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 6, 2025, at 03:43, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> This series removes "fake head pages" from the HugeTLB vmemmap
> optimization (HVO) by changing how tail pages encode their relationship
> to the head page.
> 
> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> hot path.

Besides, the code simplification also looks good.

> 
> Background
> ==========
> 
> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> and remapping the freed virtual addresses to a single physical page.
> Previously, all tail page vmemmap entries were remapped to the first
> vmemmap page (containing the head struct page), creating "fake heads" -
> tail pages that appear to have PG_head set when accessed through the
> deduplicated vmemmap.
> 
> This required special handling in compound_head() to detect and work
> around fake heads, adding complexity and overhead to a very hot path.
> 
> New Approach
> ============
> 
> For architectures/configs where sizeof(struct page) is a power of 2 (the
> common case), this series changes how position of the head page is encoded
> in the tail pages.
> 
> Instead of storing a pointer to the head page, the ->compound_info
> (renamed from ->compound_head) now stores a mask.
> 
> The mask can be applied to any tail page's virtual address to compute
> the head page address. Critically, all tail pages of the same order now
> have identical compound_info values, regardless of which compound page
> they belong to.
> 
> This enables a key optimization: instead of remapping tail vmemmap
> entries to the head page (creating fake heads), we remap them to a
> shared, pre-initialized vmemmap_tail page per hstate. The head page
> gets its own dedicated vmemmap page, eliminating fake heads entirely.

A very interesting approach.

The prerequisite is that the starting address of vmemmap must be aligned to
16MB boundaries (for 1GB huge pages). Right? We should add some checks
somewhere to guarantee this (not compile time but at runtime like for KASLR).

> 
> Benefits
> ========
> 
> 1. Smaller generated code. On defconfig, I see ~15K reduction of text
>   in vmlinux:
> 
>   add/remove: 6/33 grow/shrink: 54/262 up/down: 6130/-21922 (-15792)
> 
> 2. Simplified compound_head(): No fake head detection needed. The
>   function is now branchless for power-of-2 struct page sizes.

And it is also a common approach as well for DAX to eliminate an
additional tail page.

> 
> 3. Eliminated race condition: The old scheme required synchronize_rcu()
>   to coordinate between HVO remapping and speculative PFN walkers that
>   might write to fake heads. With the head page always in writable
>   memory, this synchronization is unnecessary.
> 
> 4. Removed static key: hugetlb_optimize_vmemmap_key is no longer needed
>   since compound_head() no longer has HVO-specific branches.
> 
> 5. Cleaner architecture: The vmemmap layout is now straightforward -
>   head page has its own vmemmap, tails share a read-only template.

I have no idea about the feature of memdesc, but regarding HVO, it is
a nice improvement. I'll look into the details later.

Muchun,
Thanks.
> 
> I had hoped to see performance improvement, but my testing thus far has
> shown either no change or only a slight improvement within the noise.
> 
> Series Organization
> ===================
> 
> Patches 1-3: Preparatory refactoring
>  - Change prep_compound_tail() interface to take order
>  - Rename compound_head field to compound_info
>  - Move set/clear_compound_head() near compound_head()
> 
> Patch 4: Core encoding change
>  - Implement mask-based encoding for power-of-2 struct page
> 
> Patches 5-6: HVO restructuring
>  - Refactor vmemmap_walk to support separate head/tail pages
>  - Introduce per-hstate vmemmap_tail, eliminate fake heads
> 
> Patches 7-9: Cleanup
>  - Remove fake head checks from compound_head(), PageTail(), etc.
>  - Remove VMEMMAP_SYNCHRONIZE_RCU and synchronize_rcu() calls
>  - Remove hugetlb_optimize_vmemmap_key static key
> 
> Patch 10: Optimization
>  - Implement branchless compound_head() for power-of-2 case
> 
> Patch 11: Documentation
>  - Update vmemmap_dedup.rst to reflect new architecture
> 
> Kiryl Shutsemau (11):
>  mm: Change the interface of prep_compound_tail()
>  mm: Rename the 'compound_head' field in the 'struct page' to
>    'compound_info'
>  mm: Move set/clear_compound_head() to compound_head()
>  mm: Rework compound_head() for power-of-2 sizeof(struct page)
>  mm/hugetlb: Refactor code around vmemmap_walk
>  mm/hugetlb: Remove fake head pages
>  mm: Drop fake head checks and fix a race condition
>  hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
>  mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
>  mm: Remove the branch from compound_head()
>  hugetlb: Update vmemmap_dedup.rst
> 
> .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
> Documentation/mm/vmemmap_dedup.rst            |  62 ++---
> include/linux/hugetlb.h                       |   3 +
> include/linux/mm_types.h                      |  20 +-
> include/linux/page-flags.h                    | 163 +++++-------
> include/linux/page_ref.h                      |   8 +-
> include/linux/types.h                         |   2 +-
> kernel/vmcore_info.c                          |   2 +-
> mm/hugetlb.c                                  |   8 +-
> mm/hugetlb_vmemmap.c                          | 245 ++++++++----------
> mm/hugetlb_vmemmap.h                          |   4 +-
> mm/internal.h                                 |  11 +-
> mm/mm_init.c                                  |   2 +-
> mm/page_alloc.c                               |   4 +-
> mm/slab.h                                     |   2 +-
> mm/util.c                                     |  15 +-
> 16 files changed, 242 insertions(+), 311 deletions(-)
> 
> -- 
> 2.51.2
> 


