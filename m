Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6109CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB548E005A; Wed, 17 Sep 2025 12:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2D08E0002; Wed, 17 Sep 2025 12:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFB88E005A; Wed, 17 Sep 2025 12:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1D518E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:29:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B35B1DF522
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:29:23 +0000 (UTC)
X-FDA: 83899277406.26.8C798BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFDBE4000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:29:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Efgoo/3O";
	spf=pass (imf07.hostedemail.com: domain of acme@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=acme@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758126562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zIZpqfsiZ4CVgJARmyKbDE6sDykkMIKdlIbnxDb4+Q=;
	b=C4tYM7/dOLfM7NkYRrE9OtaNa5duni+P4lSxXp2xnfavAGWI5/DdVQ7taxXZG7kvT2jvaC
	fP004psR3BzfQNkSMilWBKwZeeI7mKf7n0ROuBYmymXMtzoxJPSbOzrtznmsSMuEuAZ6UA
	eNz++Q5fp/LP/UIxUTmenX2lO/tWmnU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Efgoo/3O";
	spf=pass (imf07.hostedemail.com: domain of acme@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=acme@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758126562; a=rsa-sha256;
	cv=none;
	b=a4LXMYmTgF71dQxnzZc4bOtdf3N0sFFAp0EBtEPKJqjfxH/kqKQY0I3oKcFyFPJS4NmjoS
	5z7a2Tqbjka2Df2xbXXsQ/w+dgFw4H/5Ii/yxDXC7c73cC8+hndbVmApJAUW/ylSPCwxZ2
	Y9szVP0gHqS4CsVmEaCwpifPM9xyLwA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7B6641821;
	Wed, 17 Sep 2025 16:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591F7C4CEE7;
	Wed, 17 Sep 2025 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758126560;
	bh=2OcN4+QE4vB9KSX+x87Cdk3l913EKng1ECYM1XJ4iNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Efgoo/3O0LeCmXH1rE1DrgEshaiVcNwoiGdG8gPR/qVy13CnvZhy67MLqQDbd1Nwu
	 enTVAYHlzhaquq3xtN8aHEQJ43+ZMLVMdsXkEZIa+HcUfpRIV1k0dv2gdUGFQ4LcPp
	 MLXKrgn89SIv2BNKLnINxK6b+AQdHaO1/9YvsrzW1bPzB0zZ+PH9NwTAvEnOWPivsk
	 e1H/U0OCmG9hQDwRJ7dblDd0FZeTJpXJgS/cWqhzztqV2KHa56zWXi5lbfUt7zGwOX
	 qsfIETUK9/JSo5CI5A/DO3GDqdyjekXMCAuVzOxn4Llo0FK3St0PJRf7PEYyzQJCps
	 sptrXw5WzO+QA==
Date: Wed, 17 Sep 2025 13:29:18 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	namhyung@kernel.org, tglx@linutronix.de, willy@infradead.org,
	raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH v7 00/16] mm: folio_zero_user: clear contiguous pages
Message-ID: <aMrh3h1gCIyYz873@x1>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
X-Stat-Signature: h6ix6z6n3wccwwkymbqphqyu5y36tx5e
X-Rspam-User: 
X-Rspamd-Queue-Id: CFDBE4000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758126561-725569
X-HE-Meta: U2FsdGVkX1+NRmmkqzcyT7hi0SrpitlYqLqku93+p/UJioxu09UgIopS/EtFXm9CGwt1Yr+HpN7ZboXjMvwzy3BZU05cy9svValul1/vZAqK3V4b8YbvJQjGMp1+c/m/95HagE71zbYyNYHqu/RmMtPJLRiAvnxe/xys06e13Kx5Z0qy1uQcZ8qdKcDhFo0oNgcsR9jH51PCKg58S7e1hcVAWb4LrlLbZ7wU/qx39vlBORMEh6MYgtN+qzipF4Yq+X0LyrHLguZ/DzAU6oZif/fsxJyi1ujujRrKXbbMqJ5iJw2958W1CgXDn50mFhjQQ0G8/OBym8FL/X4A1pgJs6dB5UtHbAiMUXanNNx5KOHLJbmHvuWRfNw8FYoTmnkieGBaa67iQU/96oN6LYW2aArZPEgJdJ8wuYv54rPiHsR+gFrNMiuz77WVWyzZqeUHx3j06MCWhH9Kr18F+pt1y2ENHcq3qJ0BH8PfjniM3+F0ab4EtR8E+tbauq+LasRLoReDni2Lfyvn20fbbvIPzfKyjBSjs1TT1hWMilo2f5WZw89wOcUiNz84Bincby0SgwRU5wcDXBqWErkZEFaj4uPpdh5qkRqzFJlQNpBd0b6Rwiejdeb9KmDB+lXUm1WBmf6787yZr8I9wiUoWhCL0u5QQa9q0KFxekd9SS3BPIIErIa9rFjDP9RKzGLEdANqNg1erMR9VsdkrZ/h7/8nCuoKP0q6q8WLODU4bN3c3JxdWFmdESDVRHZmyoP2KphNrn1pQm4dTvtUBJsEa/3jVbepev+gG9yzvYFBkhSKKStNwuuXznRvTxQ1n6iS9W7R0nyOUpuuGTNyT6gork5JR3gAxaOelfaqyN6cFYQ4Gj+rb180g19TdFmFhcH7vruR8UPFFiXKE2Qn5fp/BehfoKkEmLt6CwqrDkzrFQKW+Lt0VsyVwiLxL6DqjGl3g6cKpI+BiosC9Vnrt6mJqAW
 EhxNYRBr
 EepWSMce7lzV9W624fPhQKSLoAVc1wQdGaIqggWx/lw8S+fSyovWZVkCnygiff4SOWYxLBy6H6Is7lb3Lex1kNuefRLGkM2Bb9N1no3JcQsExTgAo9WRaX7BY5PpVRZYijuoJ0agzLRoC7tIjvNW6Wdy+1MK/pZIZU6cAcXNIAHZ428qKyPvB+UWB7Gq9eRuskLyvO/qKpX2wA0RY6OQD7NgLCpYlLX3dBx6sxCQkDzRHJb07cAdudOTCsQdMQwIPjET138EW3v9rMtV141Lz26eNzWs+9911xpG3NGWDUNaUc8q1iM44it7F5z4N+WDEzoYmj4vD5JaZH1i9UFvKHuwWFupktyiV/jmxqbDaKm+G+SREVUimprYCYJlMEPIkvMEvr/Aj6Pxq4+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 08:24:02AM -0700, Ankur Arora wrote:
> This series adds clearing of contiguous page ranges for hugepages,
> improving on the current page-at-a-time approach in two ways:
> 
>  - amortizes the per-page setup cost over a larger extent
> 
>  - when using string instructions, exposes the real region size
>    to the processor.
> 
> A processor could use a knowledge of the extent to optimize the
> clearing. AMD Zen uarchs, as an example, elide allocation of
> cachelines for regions larger than L3-size.
> 
> Demand faulting a 64GB region shows performance improvements:
> 
>  $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5
> 
>                  mm/folio_zero_user    x86/folio_zero_user       change
>                   (GB/s  +- %stdev)     (GB/s  +- %stdev)
> 
>    pg-sz=2MB       11.82  +- 0.67%        16.48  +-  0.30%       + 39.4%	preempt=*
> 
>    pg-sz=1GB       17.14  +- 1.39%        17.42  +-  0.98% [#]   +  1.6%	preempt=none|voluntary
>    pg-sz=1GB       17.51  +- 1.19%        43.23  +-  5.22%       +146.8%	preempt=full|lazy
> 
> [#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
> allocation, which is higher than the maximum extent used on x86
> (ARCH_CONTIG_PAGE_NR=8MB), so preempt=none|voluntary sees no improvement
> with pg-sz=1GB.

I'm picking up the tools/perf part for perf-tools-next (v6.18), already
almost 100% reviewed by Namhyung.

Thanks,

- Arnaldo
 
> Raghavendra also tested v3/v4 on AMD Genoa and sees similar improvements [1].
> 
> Changelog:
> 
> v7:
>  - interface cleanups, comments for clear_user_highpages(), clear_user_pages(),
>    clear_pages().
>  - fixed build errors flagged by kernel test robot
>  - move all x86 patches to the tail end
> 
> v6:
>  - perf bench mem: update man pages and other cleanups (Namhyung Kim)
>  - unify folio_zero_user() for HIGHMEM, !HIGHMEM options instead of
>    working through a new config option (David Hildenbrand).
>    - cleanups and simlification around that.
>  (https://lore.kernel.org/lkml/20250902080816.3715913-1-ankur.a.arora@oracle.com/)
> 
> v5:
>  - move the non HIGHMEM implementation of folio_zero_user() from x86
>    to common code (Dave Hansen)
>  - Minor naming cleanups, commit messages etc
>  (https://lore.kernel.org/lkml/20250710005926.1159009-1-ankur.a.arora@oracle.com/)
> 
> v4:
>  - adds perf bench workloads to exercise mmap() populate/demand-fault (Ingo)
>  - inline stosb etc (PeterZ)
>  - handle cooperative preemption models (Ingo)
>  - interface and other cleanups all over (Ingo)
>  (https://lore.kernel.org/lkml/20250616052223.723982-1-ankur.a.arora@oracle.com/)
> 
> v3:
>  - get rid of preemption dependency (TIF_ALLOW_RESCHED); this version
>    was limited to preempt=full|lazy.
>  - override folio_zero_user() (Linus)
>  (https://lore.kernel.org/lkml/20250414034607.762653-1-ankur.a.arora@oracle.com/)
> 
> v2:
>  - addressed review comments from peterz, tglx.
>  - Removed clear_user_pages(), and CONFIG_X86_32:clear_pages()
>  - General code cleanup
>  (https://lore.kernel.org/lkml/20230830184958.2333078-1-ankur.a.arora@oracle.com/)
> 
> Comments appreciated!
> 
> Also at:
>   github.com/terminus/linux clear-pages.v7
> 
> [1] https://lore.kernel.org/lkml/fffd4dad-2cb9-4bc9-8a80-a70be687fd54@amd.com/
> 
> Ankur Arora (16):
>   perf bench mem: Remove repetition around time measurement
>   perf bench mem: Defer type munging of size to float
>   perf bench mem: Move mem op parameters into a structure
>   perf bench mem: Pull out init/fini logic
>   perf bench mem: Switch from zalloc() to mmap()
>   perf bench mem: Allow mapping of hugepages
>   perf bench mem: Allow chunking on a memory region
>   perf bench mem: Refactor mem_options
>   perf bench mem: Add mmap() workloads
>   mm: define clear_pages(), clear_user_pages()
>   mm/highmem: introduce clear_user_highpages()
>   arm: mm: define clear_user_highpages()
>   mm: memory: support clearing page ranges
>   x86/mm: Simplify clear_page_*
>   x86/clear_page: Introduce clear_pages()
>   x86/clear_pages: Support clearing of page-extents
> 
>  arch/arm/include/asm/page.h                  |   7 +
>  arch/x86/include/asm/page_32.h               |   6 +
>  arch/x86/include/asm/page_64.h               |  72 +++-
>  arch/x86/lib/clear_page_64.S                 |  39 +-
>  include/linux/highmem.h                      |  18 +
>  include/linux/mm.h                           |  44 +++
>  mm/memory.c                                  |  82 +++-
>  tools/perf/Documentation/perf-bench.txt      |  58 ++-
>  tools/perf/bench/bench.h                     |   1 +
>  tools/perf/bench/mem-functions.c             | 390 ++++++++++++++-----
>  tools/perf/bench/mem-memcpy-arch.h           |   2 +-
>  tools/perf/bench/mem-memcpy-x86-64-asm-def.h |   4 +
>  tools/perf/bench/mem-memset-arch.h           |   2 +-
>  tools/perf/bench/mem-memset-x86-64-asm-def.h |   4 +
>  tools/perf/builtin-bench.c                   |   1 +
>  15 files changed, 560 insertions(+), 170 deletions(-)
> 
> -- 
> 2.43.5

