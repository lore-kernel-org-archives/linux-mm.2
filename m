Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED96CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C266B00A0; Wed, 27 May 2026 07:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5CA6B00A2; Wed, 27 May 2026 07:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DB46B00A3; Wed, 27 May 2026 07:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2EF96B00A0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:30:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47B73140556
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:30:35 +0000 (UTC)
X-FDA: 84812982030.01.1216848
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 92E591C0007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:30:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=logbsObH;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779881433; a=rsa-sha256;
	cv=none;
	b=NMTOICRNydVkEFky1VVUeg/20IqZ5d12/Gpspb+1h0BFhOUdr/5vHjZCZvXvIFZgF6bBYp
	g8cashrU/RivTo7wr0N1SZi+fltekCvCsyxDFW3OwCO1SP6xum2e6GCtOGoMYMkgHFAh16
	LQTqYAlrWUADt/ot6ujkyOgtB77ulEg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=logbsObH;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779881433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tcb0qxLA9RNxrwz29kVtvmLZ2aii5ujZuhxC1huYlKk=;
	b=v7rmS/Ecx2NpxwMIijKk/e43ewj5dkYYkqDc6sDEOm1pJz3OknB2cJEginUSh9g+Q10Rzu
	c8IeyD+kF8rngZhl4Wq4rVKdbF8JKc3tUCPaC0TESGpFY1dLH11+tXGWEEvKEyIYpbVTsk
	zJnqGJAq4OxOevNX90PSxjppdXZKkEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07D6F600AB;
	Wed, 27 May 2026 11:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EC31F000E9;
	Wed, 27 May 2026 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779881432;
	bh=Tcb0qxLA9RNxrwz29kVtvmLZ2aii5ujZuhxC1huYlKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=logbsObHFcZ0H5NqgDgc5xjivfG0w1EDTwIm6GsW5wuBoLCHEkfM4GzYOaqttoyhE
	 BKW5l0jY0SY1saWM3DHvASSuljoBGm5yL7ble07ivJM/eZQnHGdt1kt5ANPvWk8pWS
	 PHLng9JaQCN7TYaKtI4sHAcP+P3pSIYQjx7uDFdDdMVijLI+Wh/Loam3FHDuBCZxA5
	 lpGrw3WiuNrxcW7dYJh6Igwvod7xnNcOTMnTj0h9DvPjPzxTJnKFKDd7o10H9isydU
	 B3PV8j+gRwEoRQdGSWdpUu4zhKgURNH4iySWL1Z3fGfwfmV6RJT2rbShNSdEh/ywFQ
	 ca7cIRvpK8l+w==
Date: Wed, 27 May 2026 12:30:28 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: tao <tao.wangtao@honor.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	riel@surriel.com, harry@kernel.org, jannh@google.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 
	21cnbao@gmail.com, jparsana@google.com, dvander@google.com, zhangji1@honor.com, 
	wangzicheng@honor.com
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahbSrt0B1aQTwrk4@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 92E591C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: ibax8x5rstuz88g7a5wzatr45iqsji45
X-HE-Tag: 1779881433-752782
X-HE-Meta: U2FsdGVkX1/CVMuw7junvL4p/ZpHGdpC9XQG0S1eNnalt2MGoHPzEAaboDTz1XCa1PWSlsChU7XKaIZTZVcLDvreCOFP4gLqI+7KjPLGwG1Zl1fyYfmLLo/O13pSaEbtly3jowXiWjijR4eLNXJjti6P0ZqDO+axgEQbNAKrQfDAg3+kCGXLhELf2QT94Oa5xlQRmVijdYMCFN10gLTXoUfYtbAqHRfYYsDmUlp23in0+kyErd7Z+OlZjXFVU1vB84dIHnMxmlJ++ljobkC+Yhb07Jh4AVG8XeDBTb5tooeNag6vbO/wYgp5S/Bl2J/PYkMlqbHeuuZ2kdHtZk06GUPBj2TY746kkE17NOhQdUpBWbS43EsyFq0NRhQRbwwjcmzindVDT9GujV1YBClu1ZchNlmOyZPZJ/X9J8xuQCXq9lMaeoHBvBoDdUJQsbJy9MB51vja8wdw9CdKBk7gE9jzR1vRRsjZiTDJadAMLgL7/JDgwX55j4BKMgYVfWf+kW97Og14mvutuNp5xv2auM3/D0DDtCAfcUKxlgpjfn+EZ7cnaz853yWQ15M07ELX1mQ0IRNDrQpxJ4grM7bPi2yUpvP0tIKUkoiqv2GXDIY6ECFQ5Wdz38MaszyhXzOl8f8v3Mouie/CzuNC3p6Xxy+tYQTMXsjp6GXurAejh98je3yPQcSYAhnpc67/AQHjBVbe/RjCRaF3M6O1iV+eVx2G0rAzV4a6BgGwDsiSFQpVkY8V9DfF0gZ+VSOW5ndSC7H3NJLWd0PnKxJMCKl4lw9YK696JAqhsxIJT4JBzj8oNMRNvCEfkzRAb2FbwW2TLf7tO7JYpj2DvzP81Lf8YJq3YuPK84HDIXjNlFThi8i5xjWHoxGjPynHMKiHLrb2hgEjaPCy6clzt/9g8dHpEVBlY26qMqTEs+/3seqCSETH7Fv8c3t0xG2AEK/V9+UFpJUTpx/OiD81HdD8NbJ
 sFel2J/R
 eEpeGt3zOh3dBWdIZxukDRAVQrlomP9HXmiAackEDF6ABUQubjk0FZdqKG6O5yB3xufS/cGeDLCVIi4yTr89IqUffJ3Q2DjGbpQqTU+wF98djOqBGX8zoWyVAbFxTt+crSdVbDVrjQj1gI/0DDzXnN6YMf+AzimBOWNw5abzYBSjuQytFCE4sKoVKm3ln8v0GROeIIPvLrNQbO2MDvFIXhj/CcK2gicIz/kYbDvXFjRg3I3uXyniHl+wF3SDncZAOoR2C9lKvrYwy9ojYqGgk+JanA6BTYwxYLxZYy+UpLS2xGid8c38Jdxa0NoNy07Aa9ldgtwPzxRLhYJZdL06lJQwryNPsTxcjLhOw/fNKj4L5Y2LPiMsZjG/cqQexZ2eb3bxrxJxzLLT7FYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm sorry but this is not how kernel development is done.

You're sending a series that's very invasive, that you've not coordinated
with anybody else, nor have you mentioned it at a conference, nor engaged
with in discussion with anybody else in the community in any way.

And you've sent it without an RFC, at -rc5 is... quite something.

We do NOT want to extend or expand or hack in anything like this on top of
the existing anon_vma machinery. It's a mess that requires replacement, not
more hacks or expansion.

I've been working on a replacement for the anonymous rmap, recently
presenting at LSF/MM, and all of that has been very public.

In fact I have engaged in recent work which reduced lock contention in
anon_vma, it's really quite discourteous for you not to have contacted me
or the community in addition to the above.

On Wed, May 27, 2026 at 07:01:32PM +0800, tao wrote:
> TL;DR
> -----
>
> This series introduces ANON_VMA_LAZY, which defers anon_vma creation
> until it is actually required.
>
> - anon_vma memory reduced by ~92-97%, anon_vma_chain reduced by ~50-57%
> - rmap operations on ANON_VMA_LAZY VMAs do not require anon_vma locking
>
> Background
> ----------
>
> Currently anon_vma structures are created eagerly when anonymous VMAs
> are initialized. However, many VMAs never participate in fork or rmap

What are you talking about? 'Initialized'? They are created when memory is
faulted in, and we explicity need to know that that's the case.

Also the folio->mapping is required to point to something to allow for anon
rmap...

> operations that require anon_vma chains, so the allocated anon_vma and
> anon_vma_chain objects are often unnecessary.

Right, because we never split or merge VMAs nor require anon rmap?

>
> Design overview
> ---------------
>
> ANON_VMA_LAZY defers anon_vma allocation until it is actually needed
> (for example during fork). VMAs that never participate in sharing can
> avoid creating anon_vma structures entirely.

Well, it's needed the second something's faulted in so you can perform anon
rmap.

>
> Before an anon_vma exists, rmap operations rely directly on VMA
> information, so no anon_vma locking is required. An anon_vma is created
> and linked only when sharing semantics are required.

Err 'directly on VMA information'... a VMA pointer? That can change at any
point? What about remaps?...

I guess I'll see in the code.

>
> This series introduces anon_rmap helpers to make rmap less dependent on
> direct anon_vma access. It also introduces anon_vma_tree_t as a container
> to support both the lazy and the existing anon_vma layouts.

Super invasive, extending the already broken abstraction further. We don't
want this.

>
> Once a VMA becomes associated with an anon_vma, the normal behavior
> remains unchanged.



>
> Memory impact
> -------------
>
> Preliminary measurements show significant reductions in anon_vma-related
> slab allocations.
>
> After boot:
>
> Object            | Before (active KB) | After (active KB) | Change
> vm_area_struct    | 117035             | 118176            | +1.0%
> anon_vma_chain    | 18865.8            | 8112.06           | -57.0%
> anon_vma          | 20426.4            | 613.75            | -97.0%
>
> After launching 24 apps:
>
> Object            | Before (active KB) | After (active KB) | Change
> vm_area_struct    | 196873             | 197345            | +0.2%
> anon_vma_chain    | 31477.1            | 15576.8           | -50.5%
> anon_vma          | 33280              | 2648.12           | -92.0%
>
> Simple fork microbenchmarks also show a slight improvement in fork
> performance, since child VMAs do not need to allocate anon_vma
> structures during fork.

This seems completely broken too re: anon_vma propagation on fork?

The above is only meaningful if you're not fundamentally breaking anon rmap
which is very easily done, but in addition, I'm not interested in seeing
the anon_vma machinery extended further.

>
> Feedback and suggestions are welcome.

This is what you should have sought AHEAD of sending this.

I'll look at the code, but in general you've gone about this in a really
unfortuate way with respect to the community. This is not to collaborate.

>
>
> tao (15):
>   mm/rmap: introduce anon_rmap APIs for anonymous folios
>   mm: convert anon_vma rmap APIs to anon_rmap
>   mm: introduce anon_vma_tree_t for multiple anon_vma topologies
>   mm: switch to anon_vma_tree_t APIs in preparation for ANON_VMA_LAZY
>   mm: add CONFIG_ANON_VMA_LAZY and folio helpers
>   mm: add CONFIG_VMA_REF and VMA helpers
>   mm: replace direct FOLIO_MAPPING_ANON usage with helpers
>   mm: prepare rmap infrastructure for ANON_VMA_LAZY
>   mm: implement ANON_VMA_LAZY rmap semantics
>   mm: defer anon_vma creation with ANON_VMA_LAZY
>   mm: handle ANON_VMA_LAZY in huge page operations
>   mm: handle ANON_VMA_LAZY during migration
>   mm: support setup and upgrade of ANON_VMA_LAZY folios
>   mm: support merging of ANON_VMA_LAZY VMAs
>   mm: enable CONFIG_ANON_VMA_LAZY on arm64 and x86_64
>
>  arch/arm64/Kconfig         |   1 +
>  arch/x86/Kconfig           |   1 +
>  fs/proc/page.c             |   6 +-
>  include/linux/mm.h         |  38 ++
>  include/linux/mm_types.h   |   9 +-
>  include/linux/page-flags.h |  34 +-
>  include/linux/pagemap.h    |   2 +-
>  include/linux/rmap.h       | 165 ++++++++-
>  mm/Kconfig                 |  22 ++
>  mm/damon/ops-common.c      |   4 +-
>  mm/debug.c                 |   2 +-
>  mm/debug_vm_pgtable.c      |   2 +-
>  mm/gup.c                   |   6 +-
>  mm/huge_memory.c           |  16 +-
>  mm/internal.h              | 171 +++++++++
>  mm/khugepaged.c            |  13 +-
>  mm/ksm.c                   |  43 ++-
>  mm/memory-failure.c        |  11 +-
>  mm/memory.c                |  19 +-
>  mm/migrate.c               | 126 ++++---
>  mm/mmap.c                  |  15 +-
>  mm/mremap.c                |   4 +-
>  mm/page_idle.c             |   2 +-
>  mm/rmap.c                  | 690 ++++++++++++++++++++++++++++++++++---
>  mm/vma.c                   |  76 ++--
>  mm/vma.h                   |   4 +-
>  mm/vma_exec.c              |   2 +-
>  mm/vma_init.c              |   1 +
>  28 files changed, 1279 insertions(+), 206 deletions(-)
>
> --
> 2.17.1
>
>

Lorenzo

