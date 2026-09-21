Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06328C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243906B00DD; Mon, 21 Sep 2026 06:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4566B00E6; Mon, 21 Sep 2026 06:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AE06B00E7; Mon, 21 Sep 2026 06:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5E206B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:36:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F01840125
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:36:29 +0000 (UTC)
X-FDA: 85237415298.14.7318DD6
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0379F180006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:36:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SnFIJP5M;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986987;
	b=CQz9MsGWmYaf4o5oCEdBeCdncy4FYww/jeq7eMMcvFE5qYGsrK8NfaXMxvr+/9jwHk7cGo
	lmT3TCj7Ts7UBSBMBcQ0ML/LXJNzjjKbw0U9NJ2/Zw2/GVnSkPmpar7xZCVnOXx8BwYF4J
	X6ijQAcs2d8W2LIoQPOM+r2NCO2J22M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SnFIJP5M;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QrYTKyUpu8giQzaUIMx/egOrHZXTn41TZ10JgLirYKg=;
	b=sLmnhxKL82d8GwJIfZx+cgQydhL4t9wvvXGwVCHcXrckVfcEr38+MSFfGRqoMGg3zW8tG8
	lHhnHLwhO8ggounjgtluGnLu7/9sna7FLpHa0ZfvmNolFiWBTunaBWbFzJ1DfAD753v3MI
	E311wuM873w/8EYcByXmL5BNuy0OxzA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+tmcq41FscUEr4r2n07BCtdn1qbwdVSJKS+ZPfTMX8U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789986985; v=1; x=1790591785;
 b=SnFIJP5M5XU2N3+JURQRMWxbDOwGpyD++IS6l974XOzBNZERVX6dd1zuqsA2ZdaFNTrKALQM
 mHWjAynAMzJKDDC3gw1KkZRb3XlQLKomiuYzdTqHUANCo8XZGxR6g0YqgnpUCP8gTzDwJ4ktxBw
 XDznnOqDTKN93cvicaMyURN4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ea87f986f0d8cc08;
	Mon, 21 Sep 2026 10:36:25 +0000
X-Mizu-Trace-ID: ea87f986f0d8cc08
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com
Subject: Re: [PATCH v8 00/14] mm: thp: always enable mTHP support
Date: Mon, 21 Sep 2026 03:36:18 -0700
Message-ID: <20260921103620.3431087-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <970c8f34-3cf4-4c6c-931c-b132e3bc6838@redhat.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0379F180006
X-Rspam-User: 
X-Stat-Signature: kdh7hndeg6wdhmr3q3z3a4brihu9qsd9
X-HE-Tag: 1789986986-798904
X-HE-Meta: U2FsdGVkX1/91yaF3recibmygAEjjVyW/FgQ9AgiPp5I0NI1JBiyJX9rAWRzTsSxak1JW2zi4noZod9AgyV4Up+4zn3G9qHRmOqyCO5sh1d/eDGCjFzO+er2GwI+5SVhrGTW++E9zHHn/jH6A8xWp7E70LyF4UJJjAIeVG4AilDufYM6KP2JU9Y3GJXE7BLk4fa+dfg+yImXFDj/nsXrdSWsx1elL2Ssjwo9bphbjp9WRIBXIh9OfO4X9E9niulpypyWSc4TABwR+e+YI2N4kdW3Pd4G8lkY6WSaDuY1jO5shcybL/juQRsD4WdJV6a0TMaeQVgqjy7VEwqnvfLfBOXA7nO5WapOMRNFNTbY5HuVPmr/o3B16gI/IVfBDQGljvEgkNpxBEGMr7b1jFTqkHHIUpZd4GIp+ZgqRkKX9DMhyXq+WNEUbr5dwZliKj8eQqaNRgFVhJ/Z/EsbQ9FU8+ABJ9Pl8WoORBQZmCDQgEqq0c8aL3+umCziqb2d6i1ROWUS+T3s6a0XvPmKRsN3QG/1SN4JZ1u0kNWynlp7o0x4N17KkCRg4F7TSS2o88XNBnoURMW2Yvrd4He8ay+vtYW70PaffqeNF+Mzhl8LX32+6KCP9yxL6XGh1wnvdiX4PrSxgRYJhi5c/9cYnys+PQH85IbnE3c1xmkBcSFm1zdGFCXwC5gl4RNfHTXchG3gGJmXHBFzuQA96gobYY1doEm8VjfRfeUbbYZu01zSBqvTwF3p6tiBi2DvQ5RC73l/KpAPnaQcIpUrqo6twNV+4I3HGcg4M6IIrggN2T65+wgLmCeqBkAIrfgQptRxP6/5D69UqmVaTDQjwHe9AKZ2OjbJQTaFp9Wwypec9psNC4QfotTmQ2NQfHhP03HiBMRGGgLrmmh3hJ88fDb8XA7Am0vz/3EL673AK/Xjffu1VmicrUy7q7YnRzlX+wA3TghByPX/zzApH7ALUUTa7sV
 rAeFkEND
 vOQAGc2dUNRm6DGxyFyCuoIOyBDv8UKDb/qagmGG3OT2sAnk4uElkCi/T5dkCswfc7kXBdwlmZfkASmNKqkqvk6fmIWV/5SI+qFdVGisHZoTLEx5SHIh3CSGGHMWlpPdnhrbbjvEr7qjJkL86IFZi/I1XLHX/Jt+Sdma9v83fE2XGeLaUrIA+xbLqzjE82mPhyQ/4Y+3V/kV2RPKdBi8MsT27HH8mJbPt98mZd/OwSLkP9MEPrtAWa1yVe4PE8R9r93h6qD/sZexPqpSLdaeZ1TNWPgMlHcVqxhjK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 10:01:35 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> 
> 
> On 9/18/26 6:37 AM, Usama Arif wrote:
> > 
> > 
> > On 18/09/2026 02:45, Luiz Capitulino wrote:
> >> Introduction
> >> ============
> >>
> >> Today, if an architecture implements has_transparent_hugepage() and the CPU
> >> lacks support for PMD-sized pages, the THP code disables all THP, including
> >> mTHP.
> > 
> > 
> > Hi Luiz,
> > 
> > Sorry for asking this so late in the series, but which CPUs lack support for
> > PMD sized pages?
> > 
> > Is this series mainly for PowerPC?
> 
> No :)
> 
> The architectures that have conditional PMD page support (ie. discovered
> at run-time via has_transparent_hugepage()) are x86, s390, powerpc and
> mips.
> 
> For x86 for example, even on 64-bit there are cases where the PSE bit
> may not be present (eg. some errata and by hypervisor CPUID masking).
> 
> That being said, the main goal of the series is that
> has_transparent_hugepage() is overloaded: it has different semantics on
> those architectures and is used to gate all THP support (which is not
> the right thing to do for mTHP).

Thanks for clearing that and the patches.

They all look good to me, apart from the the comment in the last patch.

Feel free to add

Acked-by: Usama Arif <usama.arif@linux.dev>

to all of them apart from last.

One nit: I would put the above goal of clean up at the start of the
coverletter, instead of starting with adding mTHP support for CPUs
that lack PMD.

Thanks,
Usama

> 
> > 
> > Thanks,
> > Usama
> > 
> >>
> >> This happens because the has_transparent_hugepage() helper is overloaded:
> >> its name implies it checks whether THP is enabled, but on some architectures
> >> it actually checks whether the CPU supports PMD-sized pages. In addition,
> >> the THP and shmem code have a big switch on has_transparent_hugepage().
> >>
> >> This series solves this by decoupling THP availability checking from
> >> querying CPU support for PMD-sized pages. THP availability can be checked
> >> with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE). For querying PMD-sized page
> >> support, this series introduces a new helper called pgtable_has_pmd_leaves(),
> >> which is independent of THP, has well defined semantics and can be used
> >> in fast paths.
> >>
> >> Core THP code and shmem can use pgtable_has_pmd_leaves() to determine
> >> PMD-sized THP support at page fault time (or folio allocation time for
> >> shmem), leaving THP and shmem always enabled for other THP sizes. For
> >> architectures and CPUs that do support PMD-sized pages there's no
> >> intended change in behavior.
> >>
> >> We also convert each user of has_transparent_hugepage(), and the related
> >> helper thp_disabled_by_hw(), to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
> >> and/or pgtable_has_pmd_leaves() according to the call site's check semantics.
> >> On s390, powerpc, mips and x86 the arch has_transparent_hugepage()
> >> implementation is moved out of the CONFIG_TRANSPARENT_HUGEPAGE guard and
> >> renamed to arch_has_pmd_leaves().
> >>
> >> Thanks to David Hildenbrand for suggesting this improvement and for
> >> providing initial guidance (all bugs and misconceptions are mine).
> >>
> >> This applies to mm-new 93f615a22169 ("mm/swap, PM: hibernate: atomically
> >> replace hibernation pin").
> >>
> >> Reporting availability of PMD-sized pages to user-space
> >> =======================================================
> >>
> >> Before this series, not having PMD pages available would shut down THP support
> >> meaning that /sys/kernel/mm/transparent_hugepage would not be available.
> >> After this series, /sys/kernel/mm/transparent_hugepage and hpage_pmd_size are
> >> always available but hugepages-<PMD-size>kB is only available if PMD-sized
> >> pages are supported.
> >>
> >> To me this seems logical, as hugepages-<size>kB is only available if <size>
> >> is supported. If this is correct, then MM kselftests that depend on PMD-sized
> >> pages will need to be updated to check for it as they fail with this series
> >> applied when PMD-sized pages are not available.
> >>
> >> The alternative is changing hpage_pmd_size: either don't create the file
> >> when PMD-sized pages are not available or set hpage_pmd_size=0. My concern
> >> is that this could be considered an ABI breakage as this file was never
> >> reported to be optional or report a zero value.
> >>
> >> Testing
> >> =======
> >>
> >> - Ran MM kselftests on x86_64 and s390
> >> - Tested all mTHP sizes allocation on x86_64 (with and without PMD-sized
> >>    pages available)
> >> - Tested shmem with within_size w/ mTHP on x86_64 (with and without
> >>    PMD-sized pages available)
> >> - Performed defconfig build on x86_64, s390, arm64, powerpc, and mips
> >>
> >> NOTES:
> >>    * I'm forcing arch_has_pmd_leaves() off on x86 to simulate not having
> >>      PMD-sized pages available
> >>
> >>    * Running the MM kselftests when PMD pages are not available causes some
> >>      tests that depend on PMD-sized THP pages to fail as noted earlier
> >>
> >> Changelog
> >> =========
> >>
> >> v8
> >> --
> >> - Fixed build breakage on MIPS (Lance)
> >> - Rebased on top of mm-new (fixed conflicts in include/linux/pgtable.h and
> >>    mm/shmem.c - dropped a Reviewed-by as a result)
> >>
> >> v7
> >> --
> >> - Applied on top of latest mm-new
> >> - Improved various changelogs including cover-letter
> >> - Changed arch_has_pmd_leaves() default implementation to use IS_ENABLED()
> >>    instead of IS_BUILTIN()
> >>
> >> v6
> >> --
> >> - Rebased on top of mm-unstable (required a minor conflict resolution)
> >> - Added more Reviewed-by and Acked-by tags
> >>
> >> v5
> >> --
> >> - Moved init_arch_has_pmd_leaves() to mm_core_init() (David)
> >> - Renamed init_arch_has_pmd_leaves() to pgtable_leaf_support_init() (Lance)
> >> - Added new patch changing shmem_getattr() to set blksize according to
> >>    highest supported THP order (Baolin)
> >> - Added new patches to move has_transparent_hugepage() out of
> >>    CONFIG_TRANSPARENT_HUGEPAGE guards
> >> - shmem_allowable_huge_orders(): rename variable and only disable
> >>    PMD_ORDER (David)
> >> - Added <linux/jmp_label.h> to include/linux/pgtable.h
> >> - Added new tags and removed Reviewed-by from changed patches
> >>
> >> v4
> >> --
> >> - Used static key for pgtable_has_pmd_leaves() API (Lance)
> >> - Moved shmem pgtable_has_pmd_leaves() check to
> >>    shmem_allowable_huge_orders() (Baolin)
> >> - Default pgtable_has_pmd_leaves() implementation to
> >>    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
> >> - Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)
> >>
> >> v3
> >> --
> >> - Rebased on top of latest Linus tree
> >> - Removed i915 patch as driver dropped has_transparent_hugepage() usage
> >> - Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
> >>    with early_param handlers clearing CPU feature flags
> >> - Fixed build error with CONFIG_MMU=n (kernel test robot)
> >> - Fixed huge_anon_orders_inherit default setting when !pgtable_has_pmd_leaves() (Baolin)
> >> - Small commit changelog improvements
> >>
> >> v2
> >> --
> >> - Added support for always enabling mTHPs for shmem (Baolin)
> >> - Improved commits changelog & added reviewed-by
> >>
> >> v1
> >> --
> >> - Call init_arch_has_pmd_leaves() from start_kernel()
> >> - Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
> >> - Clear PUD_ORDER when clearing PMD_ORDER (David)
> >> - Small changelog improvements (David)
> >> - Rebased on top of latest mm-new
> >>
> >> Luiz Capitulino (14):
> >>    docs: tmpfs: remove implementation detail reference
> >>    mm: shmem: shmem_getattr(): set blksize to highest supported THP order
> >>    mm: introduce pgtable_has_pmd_leaves()
> >>    drivers: dax: use pgtable_has_pmd_leaves()
> >>    drivers: nvdimm: use pgtable_has_pmd_leaves()
> >>    mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
> >>    mm: shmem: allow THP support determination at folio allocation time
> >>    s390: move has_transparent_hugepage() out of THP guard
> >>    powerpc: move has_transparent_hugepage() out of THP guard
> >>    mips: move has_transparent_hugepage() out of THP guard
> >>    x86: move has_transparent_hugepage() out of THP guard
> >>    treewide: introduce arch_has_pmd_leaves()
> >>    mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
> >>    mm: thp: always enable mTHP support
> >>
> >>   Documentation/filesystems/tmpfs.rst           |  5 ++--
> >>   arch/mips/include/asm/pgtable.h               |  6 ++--
> >>   arch/mips/mm/pgtable.c                        | 25 ++++++++++++++++
> >>   arch/mips/mm/tlb-r4k.c                        | 22 --------------
> >>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
> >>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
> >>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 ++++++------
> >>   arch/powerpc/include/asm/book3s/64/radix.h    | 14 ++++-----
> >>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  8 ++---
> >>   arch/s390/include/asm/pgtable.h               |  6 ++--
> >>   arch/x86/include/asm/pgtable.h                | 12 ++++----
> >>   drivers/dax/dax-private.h                     |  2 +-
> >>   drivers/nvdimm/pfn_devs.c                     |  6 ++--
> >>   include/linux/huge_mm.h                       |  7 -----
> >>   include/linux/pgtable.h                       | 21 ++++++++++++--
> >>   mm/debug_vm_pgtable.c                         | 20 ++++++-------
> >>   mm/huge_memory.c                              | 27 ++++++++++++-----
> >>   mm/memory.c                                   | 11 ++++++-
> >>   mm/mm_init.c                                  |  1 +
> >>   mm/shmem.c                                    | 29 ++++++++++++-------
> >>   20 files changed, 144 insertions(+), 100 deletions(-)
> >>
> > 
> 
> 

