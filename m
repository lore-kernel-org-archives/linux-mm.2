Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B366C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1AE6B009B; Thu,  3 Sep 2026 03:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099096B009D; Thu,  3 Sep 2026 03:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA616B009E; Thu,  3 Sep 2026 03:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C68446B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:31:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4ED30160426
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:31:47 +0000 (UTC)
X-FDA: 85171631454.26.311DFE6
Received: from mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38891100003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:31:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXsH8Q+D;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420705;
	b=j5asV6eOZik5UtSbbxEx4vuYYVyu8q9aUE8ABy3HgWovulaZwLQfL9tUb3nsoD40ruN1eg
	I8TwKU0e23MguSl0d6W/nr/7Rie3pVUu6hj1X2UnFW2aUZJUdDgpQycTGTqdqBP7V/vS5e
	i/TgS2IJSvKMEz/NdBPMMnZoHbYIBZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZsPjDcuWHDiqyFJRnZ38FCfKi+o0wZF0/7VYknh1dg=;
	b=l/y125P7v93O2u9rLoOlaBN4gkzTir0nE2LAKnYZe5nXXcbAlVWC9M/2msXXUc/WJe8qV9
	h0G/xGuFV29WxNdqNrRxmp+oEDkfie/2H+xK7apoWL8Bh7B46sv9pua7ig2Olhui0ieTKS
	wcfoMfUcSQBzLGW1/zqXwC/G6ssWuD0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXsH8Q+D;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NC0fL+3z3CsRseYh+wLnv3kKCfUxQED7UU0UKSGeaAM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788420703; v=1; x=1789025503;
 b=LXsH8Q+D/8BO9v7k3BJJ+jwYjFjDbm7V8y0uYJTM0V60gH2X/r58rvYLdyr2f1Szs87nVh/k
 vIzrB0wBWiWtBxABGi5LJ9inda+bwS50QsqI0bOa7FSgpGCQsUzkNT4Zgf6dUuzSEmVk0E7yiLy
 ZMoMeFwqfpHjeHtDNZfD8GZ0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 75b7dedc017cd645;
	Thu, 03 Sep 2026 07:31:43 +0000
X-Mizu-Trace-ID: 75b7dedc017cd645
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 15:31:39 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
	alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev,
	robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH v6 00/10] kdump: reduce vmcore size and capture time
Message-ID: <apkiW8gn9Z5XaVQh@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <apfkDlcMYrgiuGYA@fedora>
 <6aef2f48-1cc5-408d-a5a2-2b4b4d45ad7b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aef2f48-1cc5-408d-a5a2-2b4b4d45ad7b@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 38891100003
X-Stat-Signature: rge3panb3uokioqcb1be8b5wcw8eskbx
X-HE-Tag: 1788420704-684576
X-HE-Meta: U2FsdGVkX1+UXXC5JSIPQ1iFuET6dTniHLMo2/djm0/5u8BlMGKbH/NqVBPE0MxmkYlvrkL9ZEC58MNOH88k2TxqeAA3z7mQFAkT6ZKECzk+2bJfiDHw+WHFkgO+xp1+heqYnjgb1IiRlnHiyf8Xs/GD6qMcf2i9OzkErVv7xghSu95sdpJmmyzrZwjieNuyRtYBYJbWFkBI5nnyIn5yMa2iHO6VfFpILP4OvAYzwP/XTQCTU2giyC393oag5DOkyomf1nYUSS1VtgKBGhv/rTcXFu2DYY8nFiWDknG2wNihYblt25BkKwR2ldyX8cE8VTBEiD2EXloBpl1rknd/V1QDlwh6xoo278MfnNQ2aKd8IV71pB3owGSnDrGK8vgc1M9A0B6najpDkaUOp4uEUwDGbHCEonoponBPIEU0enoa069fSSxgicjSmgjeNhwLyj3+xgQKxhBJwDHG3c51WOh0Ahc/3zwm3IOg+TwF/gfLu6QGJUisydDdDYKRXHRKfesgA03fc2EgqsosaA5BIRQ2rfQNDJMy23oxk1A4b/cldFs7MzYXWmxchtvJSpPHFUVICe1HrPKfvaDMPOCE1AmJ+OL1n3YYxo0VWxN1xsocz4W3L5Lz9IqB9dSLc8HLyRucvSFtWW/ATU7zuwi/tpZJp8IgPhdo0APx+WoUHZ7rfWGkaOcSSbZ1BxDvW6ZiYOEpYI3I/+JI3fXUWwfMMfz1jOGyCwglzG/06H7u7OVdLH6KZ44hyrDQZx0fsSHzVCuJXSEHq3/hD7BuPQAIqr7qDgLciqndFRrjNZB2l2DU0cD53f0vDcg8Q+0vPrZuf+5fD8LQK6/64gOmAkwWlL7tsSXux+I2/reeNCA1aRfwaKzEoOEIM/PvfmZQ/dIYFiNIB5llWCPGSYdbhxHsOaK1uGKCpfvbsHpq/PSaQS4XLvlSPZgerzzXz2GLMJx1LTgSvuFLIeWCkybzu9e
 Lq/rJgvE
 DgGf4WqfsqIw9bJMVdyaU4JhMNKGhGaeLNmliWjPpu308iFMnTIz1Rfin5ekrXfwm5WlvnopVuHUbXLKf0kh5CpefC8nJjnBB+m+5rv4BOkVUtq4TABGhc1ptVKGTDbEOImYVjqX8qNIeleK5C/yxcxnUNCOxlL7yEN72CsurHbJAuR268nwtYvT74ZXb3Bw/C0EA0zPmQUm7V3ehY16EjpFmrCQUTcp1JKokoXh3Yy6TaK+0g5Z5lapkX4x7fNjLCid2Ltg4Jm6l3ARdFrz0VNJJqlmYb/ad8DnjmmQvBEDhEh+AUe15H3tD06XFO3O5JTxyqiLDsuOYgNIAyd0XIZWVH6B1XZJHcJi/dL5EO+76MKTWpTb0vpIuLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/03/26 at 03:05pm, Wandun wrote:
> 
> 
> On 9/2/26 16:53, Baoquan He wrote:
> > Hi Wandun,
> > 
> > On 09/02/26 at 03:31pm, Wandun Chen wrote:
> >> From: Wandun Chen <chenwandun@lixiang.com>
> >>
> >> On SoCs that carve out large firmware-owned reserved memory (GPU,
> >> camera ISP, ...), kdump currently dumps those carveouts as part of
> >> system RAM even though their contents are firmware state that is not
> >> useful for kernel crash analysis.
> >>
> >> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
> >> reserved memory on DT-based architectures (arm64, riscv, loongarch).
> >> Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
> >> reusable CMA regions are different because their pages are handed back
> >> to the buddy allocator and may carry crash-relevant data.
> >>
> >> ACPI systems already filter reserved memory out of the vmcore through
> >> their existing path; only DT-based systems currently fail to filter these
> >> regions, which is what this series addresses. The flag lives in memblock
> >> itself rather than in a DT-only structure, so the mechanism is generic and
> >> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
> > 
> > Thanks for the effort. I am not against this patchset, and I haven't
> > went through it carefully. Just from the cover letter, you mentioned
> > generic, I am wondering if this can be generic for excluding other
> > memory regions. Asking this because I try to find a way to exclude
> > unwanted memory regions too, please check below link where there's
> > the relevant discussion. We definitely don't like inventing wheels
> > time after time. Do you think this memblock region excluding can
> > be used in other places of kernel?
> > 
> > https://lore.kernel.org/all/aoLFai0gzzH2bGgy@MiWiFi-R3L-srv/T/#u
> 
> 
> Thanks for taking a look, and for the pointer to the crash-wipe thread.
> 
> To answer your question directly: the exclusion mechanism in this series
> is already generic, memblock_mark_nodump() is the entry point. Any code
> that wants a region out of the vmcore just marks it MEMBLOCK_NODUMP, when
> preparing vmcore elf header by walking memblock, these regionss are skipped;
> This series is simply one caller, marking the DTS /reserved-memory and
> /memreserve/ regions with MEMBLOCK_NODUMP.

Thanks, for memory not allocated from memblock, e.g buddy, is it still
good?

> 
> x86 currently builds the vmcore elf header from iomem_resource, not
> memblock; it could be switched to memblock, but that would bring no
> benefit for the problem this series solves, so this series makes no
> x86 change. I'd personally be in favor of switching to memblock for
> a unified implementation across architectures.
> 
> Best regards
> Wandun
> 
> 
> > 
> >>
> >> Since the reserved memory regions are filtered out, the vmcore is
> >> smaller in size and faster to produce. 
> >>
> >> The series is based on linux-next and is organized as follows:
> >>
> >> Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
> >>              flagname, switch riscv crash_mem to memblock, fold the
> >>              duplicated per-arch memblock walks into the weak
> >>              defaults, and serialize crash header preparation against
> >>              memory hotplug.
> >> Patches 5-9: NODUMP infrastructure: switch crash_core to
> >>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
> >>              flag, add a dumpable flag to struct reserved_mem, and
> >>              mark /reserved-memory and /memreserve/ entries with
> >> 	     MEMBLOCK_NODUMP flag.
> >> Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
> >>              header.
> >>
> >> In v5, Sashiko found some pre-existing issues related to reserved-memory,
> >> and has no dependency on this series, so these issues have been addressed
> >> in a separate series [2].
> >>
> >> v5 --> v6:
> >> 1. Serialize crash header preparation against memory hotplug to avoid
> >>    out-of-bounds or use-after-free issues.
> >>
> >> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
> >>    avoiding a panic from too few regions before resize is permitted.
> >>
> >> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
> >>
> >>
> >> v4 --> v5:
> >> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
> >>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
> >>    DT-only struct reserved_mem.
> >> 2. Switch the riscv vmcore elf header preparation to use memblock
> >>    instead of the resource tree, aligning it with arm64 and loongarch,
> >>    so riscv also can exclude reserved memory from vmcore.
> >> 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
> >>    loongarch open-coded the same logic, so fold it into shared
> >>     __weak defaults in crash_core.
> >> 4.  Drop the v4 patch that saved /memreserve/ entries into the
> >>     reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
> >>     directly.
> >>
> >> v3 --> v4:
> >> 1. Rebase this series on v7.2-rc1.
> >> 2. Add two cleanup patches (patch 02/03).
> >> 3. Simplify patch 03 to avoid checking whether initial_boot_params is
> >>    NULL multiple times, suggested by Rob.
> >>
> >> v2 --> v3:
> >> 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
> >> 2. Fix UAF issue when alloc_reserved_mem_array() fails.
> >> 3. Add some prepare patches.
> >>
> >> v1 --> v2:
> >> 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
> >>    feedback [3], v2 drop that property and exclude reserve memory
> >>    by default.
> >> 2. Split some prepared patches from the original patches.
> >> 3. Address coding-style comments on patch 5 from Rob.
> >>
> >> [1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
> >> [2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
> >> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
> >>
> >> Meijing Zhao (1):
> >>   mm: memblock: add missing HugeTLB flag name
> >>
> >> Wandun Chen (9):
> >>   riscv: build crash_mem ranges from memblock instead of resource tree
> >>   crash_core: fold duplicated memblock arch hooks into the weak default
> >>   crash_core: serialize crash header preparation against hotplug
> >>   crash_core: replace for_each_mem_range() with for_each_mem_region()
> >>   memblock: introduce MEMBLOCK_NODUMP flag
> >>   of: reserved_mem: add dumpable flag to opt-in vmcore
> >>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
> >>   of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
> >>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
> >>     header
> >>
> >>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
> >>  arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
> >>  arch/riscv/Kconfig                         |  2 +-
> >>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
> >>  arch/x86/kernel/crash.c                    |  2 +-
> >>  drivers/of/fdt.c                           |  2 +
> >>  drivers/of/of_private.h                    |  2 +
> >>  drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
> >>  include/linux/crash_core.h                 |  2 +
> >>  include/linux/memblock.h                   |  9 ++++
> >>  include/linux/of_reserved_mem.h            |  1 +
> >>  kernel/crash_core.c                        | 51 ++++++++++++++++++++--
> >>  kernel/dma/contiguous.c                    |  1 +
> >>  mm/memblock.c                              | 17 ++++++++
> >>  14 files changed, 131 insertions(+), 95 deletions(-)
> >>
> >> -- 
> >> 2.43.0
> >>
> 

