Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BAA5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433DD6B00D8; Fri,  3 Jul 2026 08:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B686B00DA; Fri,  3 Jul 2026 08:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321486B00DB; Fri,  3 Jul 2026 08:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB5DD6B00D8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:47:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6424AC0110
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:47:51 +0000 (UTC)
X-FDA: 84947442342.13.8CBB288
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 782A220007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:47:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=apno0fpW;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783082869;
	b=tGDN6j4H4BXmuRbfTxDcRjrVwt1lofQvFgXWP4N6PE41OdmOuBJkt0UV9XFw2nHv4EzqoH
	4bM2C8Akad2uskX+jvVk1B8xKs/aKl/DP6OB9TmIu6Srk4kXFCrXG06Rthxr8znaTpOTbl
	jys8ZoITsk3MAAPYfSZahIk6Nm9Datg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783082869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPYOzd2RjFg1ddO/ZLQh27mhHcI8iJ031pBNVEV3ouY=;
	b=xdxf36cmer19ULrwmZMlpZD2kphgXHDDTgcjtvbVI8SnObV2JGliM25EUvFPkoekJRriYu
	CaTjlFnLpUhiPUQgf81RDrb3RX4djl5YLpKdWtxu0tCdYoa8aorJ8ykr0wTZmKTcBGZYQg
	ortuz2U20kTmT38VF3B2P2vB2BrWhFg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=apno0fpW;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 734BE40606;
	Fri,  3 Jul 2026 12:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842E11F000E9;
	Fri,  3 Jul 2026 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783082868;
	bh=NPYOzd2RjFg1ddO/ZLQh27mhHcI8iJ031pBNVEV3ouY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=apno0fpWqD4HAfuc6YJmV2FSvla0WDZdWmjkMYLOExNvhMWLblylwUrBaWPl+Y5Lr
	 vVPu9XkgOxIw0MTVsuw5+DVKZC0dSrPeeC6RuiA5dpyzCCwzsXjBCt7dvQPaP3upDF
	 UoOQS7pIlBb/lzqdAGul1gwrToCtjFKmgxBz7SIClX0i1cAc11z7E0BdTwYPnCBl/L
	 WsqiCuPbM+rXit3Wd9ri2eZps2cuhVzIcraC6ZmeRWB0YpVEo7r6NnXTZwc3P9bw5h
	 w/SXZ2mFLUM0B6FeZybDNRlTX75MnL6BGPc28ROvk0jrqPfpOVBW6CHnxz4ZNq+eRI
	 djOJZ+YWKunJA==
Message-ID: <997c1a4d-ee99-4214-be58-7ceb3b9b9a36@kernel.org>
Date: Fri, 3 Jul 2026 14:47:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] mm: Some cleanups for page allocator APIs
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>,
 Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dimitris Michailidis <dmichail@fungible.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zkrmccbzd4wmqtufqthdkszc5xom84cj
X-Rspam-User: 
X-Rspamd-Queue-Id: 782A220007
X-Rspamd-Server: rspam05
X-HE-Tag: 1783082869-573358
X-HE-Meta: U2FsdGVkX1/2QV/VjExz836jhgr1aedwYG+nmibfABgh5DODCRHX5lsSXbBgdWdkWXF181wyx+G5ddC4YGLWKMEU2v6bxdo1muf8xvalyOBgG9/8Auco1BhWIGfVVbMEwyW/oHlUOtmrwDHE8lX0RZ2IIBunFzT2lHTZAwwLntCSw2xdrYURDkMpLCUuw2HN+WuB97YsYrki1W9I1X4mV0lil6JSyNQCSBPR/MD9YqnaTQ9Zr/DoA6KQFD0co3tvRH9omnOYBbjxHqJqtzfnxtbYwf8hQo51cpYV+2vME0xwpklj3DDO4CtBqfXWCVrfVAVXoo6KK4sC6PO4I7S0+rE5D3/KXzfOlSqbE/eF9QBGtK68xptpY/Xph7HJIB/eX7YsNnhjxyDLKT9qYodIQ8S06SaR2CZYSnfWOtVxsosI56AK9/8a9rrf6vd+OgU42sqjiCipmbLw46YX6AbtVHoRwBmiqU0esaAXFHQuAtFb32E+iWiUFo9QNx29yt3WYoFhrBieQD8mR+AQkC+3+NmOBB96GXi+FhdiIR4pz3skmRBEgHPb0iXusZ49nGrO5DVqP3vaM5Mc9Fp02TYK7QCC/6H/fYVRR08Wz+JWt+08yhCZ8lziGdwXXJ3FWquuUhhYgFOftaapKAq6hepjtlOE2yI/eNA2l2QLxIulb1yZpLeFgbUy0i1o8m3DUgX58bNW6BZZG2Wj7hgOA3tDe+d4bZNFiYJ/2QO4xTlBHGJmGQTN8bZczPjslE5JSvusf/nE6E0T6Lze9ZcqYL6EBfZBh1lFNqabFsk0jk0lHWYqyEqkWzWD91LnjKs140TOgI6zxOnPmpKAj1kmahzy9nAG4+r8Hp5G2fwGm8tmJeP++332Z7QK73hbSjNTt1mtDZQl0cWFZTigyz2aYJ2q9/Vie4D/UfzzEO+xx/X/lxHzv/Ab+oxGv2SVyWtr+EAJ1monUktE8+1ed2xoNHW
 tlEV68lb
 g79HIK+9xZ0dtexNRY6F7xLNxXgZgsnhb6Yt/RQ6tXbVvTi5fVRPbKbYAVRKBTmZ9X0ztdkaieLygdHZrzFchYuMO7cGU/a9RRH7JIjsP6Y/nobZFPavYlVlXHa2eh/GDtIjQBV9YbtUbbc6hQrtizCKHacOfY+qYQIjtPRfSIbhf83KQsfYv0MuP4CVuH8hf94ScMWLKGN+OQgU5y0cD9ql3+ZrQ06aAcCkbO2ivtE89psJXTMvR3B4tCfjqEd3LgoqUJsfLLedZculGY1BN7t87kJhMKJf1YQ8oiE4LSBX5smvkK8hnhrOrPUigDkdgtX/hwExOVQxBCj3JFYpAVMqtPZEKKmSRI1lYF7lj5v7bkF0IfeavXU6mnHUZTqwMxbD5PLqn8IsyGLOc31372ARMlghdpDl6ZDGJuuZFrUQAkEuTBg368xSggtUFZX8+bD2wszcWNsIOpV71z8jgwCmllS17y2zp9iP+CL/pdtxRPXooNhvtZIdkDfqBoOHE2R4mevpc9LHsXW5GKIJymjG11pHOOrzSXD2sa6qDv2JQA1OtyJ/F7E6/eGLhimtGe8Lg+l6Sqq2aSsElgVVYhq/6D93lfkorOsmi8W4lQFOh821U2vHzv3ojWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 14:31, Brendan Jackman wrote:
> Based on mm-new.

Seems ready for mm-new to me. I suspect most further non-trivial page
allocator work will conflict, so better have it in mm to be based upon.

I was worried about Johannes' defrag fixes [1] that were supposed to be
stable bacported and thus would be better to add (the next revision) to
mm-new first. But seems like if I apply this series on mm-new, and then [1]
on top, nothing conflicts, so the ordering shouldn't matter.

[1] https://lore.kernel.org/all/20260626182215.1107966-1-hannes@cmpxchg.org/

> This depends on moving alloc_tag to mm/:
> https://lore.kernel.org/all/aj5QBtJcphPElczI@lucifer/
> 
> Some tweaks and cleanups for page allocator entrypoint and flags. This
> is motivated by preparation for __GFP_UNMAPPED [1] (which will probably
> become ALLOC_UNMAPPED in its next iteration), but all this is supposed
> to be an improvement to the codebase in its own right: unifying code
> paths, reducing API surface, and removing GFP flags.
> 
> [1] https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/
> 
> This started with unifying  __alloc_frozen_pages[_nolock]_noprof() and
> expanded from there.
> 
> Unifying the nolock allocator entrypoint with the normal allocator
> entrypoint means adding an alloc_flags argument to the later (only
> exposed within mm/). This presents an opportunity to take advantage of
> that arg to remove some GFP flags, if we add that alloc_flags arg a bit
> more broadly to allocator entrypoints.
> 
> To distinguish between mm-internal and "public" allocator entrypoints,
> it makes sense to use the __ prefix. There are already some public APIs
> with that prefix. For *alloc_pages*, just removing those variants seems
> like a nice cleanup anyway, so do that. For get_free_pages, the "__"
> variant is the _only_ variant and it's very widely used, so it doesn't
> seem worthwhile to modify that. Therefore, scope this "__" change
> specifically to the *alloc_pages* API, which means we leave the
> *folio_alloc* API untouched too, even though that could probably be
> cleaned up if so desired.
> 
> Tested:
> 
> - KVM, mm, and BPF selftests in a QEMU VM
> 
> - kunit.py on x86_64
> 
> - For the ALLOC_NO_CODETAG bits I just booted a VM and read
>   /proc/allocinfo. I confirmed that if I remove ALLOC_NO_CODETAG, the
>   kernel crashes in early boot, so I was at least booting code that
>   depends on this logic.
> 
> I used Google's internal version of Antigravity (AI coding harness) to
> do the repetitive bits, those commits are marked with Assisted-by, the
> rest is manual.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
> Changes in v5:
> - Just trivial non-functional fixes.
> - Link to v4: https://patch.msgid.link/20260702-alloc-trylock-v4-0-0af8ff387e80@google.com
> 
> Changes in v4:
> - Fixed some (harmless) missing applications of ac->alloc_flags (local
>   Sashiko)
> - Fixed various build issues.
>    - Note that Sashiko pointed out a KMSAN build issue [0], I have
>      fixed it but KMSAN builds are currently broken by objtool [1]. At least
>      mm/kmsan/init.c compiles.
>      [2] https://lore.kernel.org/all/20260629141642.628271F00A3D@smtp.kernel.org/
>      [3] https://lore.kernel.org/all/20260630104434.GC751831@noisy.programming.kicks-ass.net/t/#u
> - Avoided setting ALLOC_NOFRAGMENT under ALLOC_NOLOCK (Sashiko, Harry)
> - Added patch to tweak alloc_flags_cma() interface (Vlastimil)
> - More commit messages fixups (various)
> - Added patch to create can_spin_trylock() (Harry)
> - Link to v3: https://patch.msgid.link/20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com
> 
> Changes in v3:
> - Created mm/page_alloc.h
> - Fixed EXPORT_SYMBOL() issues
> - Reworded commit messages per Sashiko's pointers
> - Dropped rename of alloc_flags arg in prepare_alloc_pages() (Suren)
> - Renamed gfp_to_alloc_flags_nonblocking() too after rebasing onto:
>   https://lore.kernel.org/all/20260623004600.113347-1-jp.kobryn@linux.dev/
> - Link to v2: https://patch.msgid.link/20260622-alloc-trylock-v2-0-31f31367d420@google.com
> 
> Changes in v2:
> - Fixed up whitespace in nolock unification patch
> - Introduced ALLOC_DEFAULT to replace literal 0 for alloc_flags
> - All other patches are new
> - Link to v1: https://patch.msgid.link/20260617-alloc-trylock-v1-1-83fd7858832e@google.com
> 
> ---
> Brendan Jackman (17):
>       mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
>       mm/page_alloc: some renames to clarify alloc_flags scopes
>       mm: name some args in a function declaration
>       mm: Split out internal page_alloc.h
>       mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
>       mm/page_alloc: relax GFP WARN in nolock allocs
>       mm: move some stuff to mm/page_alloc.h
>       perf/x86/intel: Use higher-level allocator API
>       KVM: VMX: Use higher-level allocator API
>       x86/virt: Use higher-level allocator API
>       sgi-xp: Use higher-level allocator API
>       net/funeth: Switch to higher-level allocator API
>       mm: Remove __alloc_pages_node()
>       mm: Move __alloc_pages() to mm/page_alloc.h
>       mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG
>       mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
>       mm: factor out can_spin_trylock()
> 
> Vlastimil Babka (SUSE) (1):
>       mm: remove the __GFP_NO_OBJ_EXT flag
> 
>  Documentation/admin-guide/cgroup-v1/cpusets.rst  |   2 +-
>  Documentation/admin-guide/mm/transhuge.rst       |   2 +-
>  MAINTAINERS                                      |   1 +
>  arch/x86/events/intel/ds.c                       |   6 +-
>  arch/x86/kvm/vmx/vmx.c                           |   2 +-
>  arch/x86/virt/hw.c                               |   2 +-
>  drivers/misc/sgi-xp/xpc_uv.c                     |   5 +-
>  drivers/net/ethernet/fungible/funeth/funeth_rx.c |   2 +-
>  include/linux/alloc_tag.h                        |   4 +-
>  include/linux/gfp.h                              |  54 +---
>  include/linux/gfp_types.h                        |   7 -
>  include/linux/skbuff.h                           |   2 +-
>  include/trace/events/mmflags.h                   |  10 +-
>  mm/alloc_tag.c                                   |  23 +-
>  mm/compaction.c                                  |   5 +-
>  mm/hugetlb.c                                     |   4 +-
>  mm/internal.h                                    | 275 ++------------------
>  mm/khugepaged.c                                  |   1 +
>  mm/kmsan/init.c                                  |   2 +-
>  mm/memory-failure.c                              |   1 +
>  mm/memory_hotplug.c                              |   1 +
>  mm/mempolicy.c                                   |  11 +-
>  mm/migrate.c                                     |   1 +
>  mm/mm_init.c                                     |   1 +
>  mm/page_alloc.c                                  | 269 ++++++++++---------
>  mm/page_alloc.h                                  | 312 +++++++++++++++++++++++
>  mm/page_frag_cache.c                             |   6 +-
>  mm/page_isolation.c                              |   1 +
>  mm/page_owner.c                                  |   2 +-
>  mm/page_reporting.c                              |   1 +
>  mm/show_mem.c                                    |   1 +
>  mm/shuffle.c                                     |   1 +
>  mm/slub.c                                        |  17 +-
>  mm/swap.c                                        |   1 +
>  mm/vmscan.c                                      |   1 +
>  mm/vmstat.c                                      |   1 +
>  tools/include/linux/gfp_types.h                  |   7 -
>  37 files changed, 536 insertions(+), 508 deletions(-)
> ---
> base-commit: 32af3ff0925368eff29b2fed62f154150eb5dc10
> change-id: 20260617-alloc-trylock-14ad37dab337
> 
> Best regards,
> --  
> Brendan Jackman <jackmanb@google.com>
> 


