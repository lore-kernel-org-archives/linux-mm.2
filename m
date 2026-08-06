Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF85C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F3A6B00A2; Thu,  6 Aug 2026 06:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF476B00A4; Thu,  6 Aug 2026 06:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEE26B00A7; Thu,  6 Aug 2026 06:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA8026B00A2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:11:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D20291C1386
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:11:57 +0000 (UTC)
X-FDA: 85070428674.25.841B086
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 35C8640009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:11:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=hvQmoFjh;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786011115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMZ8qkfhOLZiwmIb3BHX25zuCyq2Sc5EP83poQE1J/s=;
	b=G0ohtDbhWvuEh7HCyn7awMrbD3gvmI/L9MGtRzr8BEASpmbfo+U0+jtj3V3CRMpUKqF1jE
	tgJsBgHwsCoHM9SKjbRHUm+nmdUvWH8g+doPN6gHzk3l7bjeFnkfw2jEylWaf1kXUkc9ES
	qmdfRl7W74dN9+qPpbWzu9LLMH+Yj1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786011115;
	b=wfwVLTKMK/y5wpa96wiOd8i/qLL3Bitc6qkMRAv5n0M2BjyC5jgmQE7AH1cF/K0bCxgzb8
	/fFTEa1jRveagp/SifcSJ6sxTcZDLd5SQ9YmyI6nu/AF5maoI2dcfTAd/9uAE8a9oc3dR2
	gn5enMeANDhDcB4jHnrCX8ffQbho748=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=hvQmoFjh;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260806101153euoutp028ddd2d13efe45101d11fdc7752e042f2~JL6UMdNbc1735917359euoutp02b
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:11:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260806101153euoutp028ddd2d13efe45101d11fdc7752e042f2~JL6UMdNbc1735917359euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1786011113;
	bh=IMZ8qkfhOLZiwmIb3BHX25zuCyq2Sc5EP83poQE1J/s=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=hvQmoFjhsU8p1u0MmlmWQL29zelrY+Be3zf5/NM0om2nSLLwwR8OCwjwyRhkzh+89
	 I3vMFQhnKJhD6HIP4oad6vEoWfBmu1Nz/d9n4e3A7pkAPAn110O65kmbZUBmOTYOw2
	 iQHtEA2bshV4VP0X4zV7Rhe85gM+nMNaHDF2ggf4=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260806101152eucas1p213e701b4891db43e93acd1f9d3447abe~JL6T8R35N1126211262eucas1p2s;
	Thu,  6 Aug 2026 10:11:52 +0000 (GMT)
Received: from [106.120.50.46] (unknown [106.120.50.46]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260806101151eusmtip1bacb3c8e11470851538ac16bd48c8b84~JL6Sik-9k2357923579eusmtip1r;
	Thu,  6 Aug 2026 10:11:51 +0000 (GMT)
Message-ID: <ef2c73d6-99ee-47fb-a3bc-620201a9ee83@samsung.com>
Date: Thu, 6 Aug 2026 12:11:50 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v5 0/8] kdump: reduce vmcore size and capture time
To: Wandun Chen <chenwandun1@gmail.com>, catalin.marinas@arm.com,
	will@kernel.org, chenhuacai@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, robh@kernel.org, saravanak@kernel.org,
	rppt@kernel.org, baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	pratyush@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, kexec@lists.infradead.org, iommu@lists.linux.dev
Cc: kernel@xen0n.name, alex@ghiti.fr, akpm@linux-foundation.org,
	ruirui.yang@linux.dev, robin.murphy@arm.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260806101152eucas1p213e701b4891db43e93acd1f9d3447abe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260806093541eucas1p169d6fcb31de09012bdfca326867e86d6
X-EPHeader: CA
X-CMS-RootMailID: 20260806093541eucas1p169d6fcb31de09012bdfca326867e86d6
References: <CGME20260806093541eucas1p169d6fcb31de09012bdfca326867e86d6@eucas1p1.samsung.com>
	<20260806093519.2907771-1-chenwandun1@gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qh1zwth67dfk1p8eguyhtmhwx8nx6xuy
X-Rspamd-Queue-Id: 35C8640009
X-HE-Tag: 1786011115-757913
X-HE-Meta: U2FsdGVkX1/S5ImPIkNhuSN7/aa1UK7fNth84enl65ohX4sSAVPwIxO/MIMxaX8gCcfUdHkujjDRG8mW1CP96lgmqm+CVVhPkzwew5/40bcrA3yHOt3U4MEuUqhj25AIATe3k02xkshWEqWZRUJNTOlSYNxLaJ9xYfdp+LR8lSR3kbWusU89jZUmQ2EZ61I6OnhzmyJgCy4Y1KIzigSU+bCA++as6hDiiJXwM0tE7bksEr4nQBCmEzIdGhBk353XKGK0E2TlzohMts9Yu5+MKMO93CvSfho5csybz3yBD4z52ShZvYJy+1aEcGHpSDv8dw69fLxDD5OEIwS51E1IgvMLSsLS6QIJcM0FEIyXFy0vCHWgAToJjxjiThIliGrN5FfqIENy8uQP/UJCqjVTtWb9aJ01N13V19dEG/X28RJSC+2f/3ymUa7fXsTDQIPIRuCaAcyNZWQ0BRA7d0S69PjrwfWi0b6Lsaci8zRO+iDNzR9jJAbbLe3FyK29GhtvJ30A5P/z6h9yBO63VLz06FItpK5eC1owlYJg/Wf1TnfqnkoBgAsByyBPbADwpDEAlqIMStex3pmdtdnx74OFySgfyli3oqO/RCIOlGMrgRU+Q4V2bv3wHhvt8ZfK7ayzzfedxaQn7G0emEkkbtQ0chXX4mbRTxADXnCYSVGEYXaJXR7TuGBHBXz10i6h3341zWYqabKeRDDmCDrjPxx1CWUZZH/RzbVuXBqvE+4EHLVKhi++F4q7UDHRjsm2HHmfut4/rQ5CHAyPGfqSlcN3pFDL3fHFB7585wA6JOmc/CWCp+DqB8xCqQKXGIvGearxJkacWyviqAfV0FjIsSaxt5M6hH2ZooYEm4wtDNgH0gEvgqMkDmics3uZ29G34OoW2q+uDYgoeQYVSWjqY0yWOGym3xAudRAVLSS200RE3vMuUkMPycjjDsGIqyTsCpXCd9CFB//HKj1B/Oa+4/W
 HLDjJey8
 CPFzztd7IjTDQ/0GB3UIECki46tGGA+7V0KN9/mu4rR9zgdRbtWiraZIoJ6944pIU3uUPCwRqrHfqmnOzFgVkLHZwD8qhJQ+wA+Zaxm+Gl4pyjFCh139sxWmiiERFjrNbfTJw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.2026 11:35, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> On SoCs that carve out large firmware-owned reserved memory (GPU,
> camera ISP, ...), kdump currently dumps those carveouts as part of
> system RAM even though their contents are firmware state that is not
> useful for kernel crash analysis.
>
> This series introduces a 'dumpable' flag on struct reserved_mem and a
> MEMBLOCK_NODUMP flag in memblock to filter vmcore ELF header on DT-based
> architectures (arm64, riscv, loongarch). Reserved regions default to
> non-dumpable and are marked MEMBLOCK_NODUMP so kdump omits them;
> reusable CMA regions are explicitly marked dumpable in rmem_cma_setup()
> because their pages are handed back to the buddy allocator and may carry
> crash-relevant data.
>
> Since the reserved memory regions are filtered out, the vmcore is
> smaller in size and faster to produce. ACPI systems already filter
> reserved memory out of the vmcore through their existing path; only
> DT-based systems currently fail to filter these regions, which is what
> this series addresses. The flag lives in memblock itself rather than
> in a DT-only structure, so the mechanism is generic and both ACPI and
> DT systems can benefit from it (suggested by Rob, thanks).
>
> The series is based on linux-next and is organized as follows:
>   Patches 1-2: Introduce MEMBLOCK_NODUMP in memblock and the dumpable
>                flag on struct reserved_mem.
>   Patches 3-4: Mark non-dumpable /reserved-memory and /memreserve/
>                entries with MEMBLOCK_NODUMP.
>   Patch 5:     Switch riscv to memblock so the NODUMP flag is visible
>                to the vmcore ELF header builder; add (KEXEC_FILE &&
>                CRASH_DUMP) to riscv's ARCH_KEEP_MEMBLOCK condition.
>   Patches 6-8: Fold the duplicated per-arch memblock walks into the
>                weak defaults in crash_core, switch to
>                for_each_mem_region(), and exclude MEMBLOCK_NODUMP
>                regions from the vmcore ELF header.
>
> v4 --> v5:
> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>    DT-only struct reserved_mem.
>
> 2. Switch the riscv vmcore elf header preparation to use memblock
>    instead of the resource tree, aligning it with arm64 and loongarch,
>    so riscv also can exclude reserved memory from vmcore.
>
> 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
>    loongarch open-coded the same logic, so fold it into shared
>     __weak defaults in crash_core.
>
> 4.  Drop the v4 patch that saved /memreserve/ entries into the
>     reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
>     directly.

v5 looks much better, at least from the reserved memory regions perspective.


> v3 --> v4:
> 1. Rebase this series on v7.2-rc1.
> 2. Add two cleanup patches (patch 02/03).
> 3. Simplify patch 03 to avoid checking whether initial_boot_params is
>    NULL multiple times, suggested by Rob.
>
> v2 --> v3:
> 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.[2]
> 2. Fix UAF issue when alloc_reserved_mem_array() fails.
> 3. Add some prepare patches.
>
> v1 --> v2:
> 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
>    feedback [1], v2 drop that property and exclude reserve memory
>    by default.
> 2. Split some prepared patches from the original patches.
> 3. Address coding-style comments on patch 5 from Rob.
>
> [1] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
> [2] https://protect2.fireeye.com/v1/url?k=05b72ed7-643c3bed-05b6a598-74fe4860008a-295907342918bd15&q=1&e=c408484d-fdd8-4fe4-8eee-690e883afb73&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fpatchset%2F20260520091844.592753-1-chenwandun%2540lixiang.com%3Fpart%3D4
>
> Wandun Chen (8):
>   memblock: introduce MEMBLOCK_NODUMP flag
>   of: reserved_mem: add dumpable flag to opt-in vmcore
>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>   of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
>   riscv: build crash_mem ranges from memblock instead of resource tree
>   crash_core: fold duplicated memblock arch hooks into the weak default
>   crash_core: replace for_each_mem_range() with for_each_mem_region()
>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>     header
>
>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------------
>  arch/loongarch/kernel/machine_kexec_file.c | 27 -----------------
>  arch/riscv/Kconfig                         |  2 +-
>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------------
>  drivers/of/fdt.c                           |  2 ++
>  drivers/of/of_private.h                    |  1 +
>  drivers/of/of_reserved_mem.c               | 35 ++++++++++++++++++++++
>  include/linux/memblock.h                   |  9 ++++++
>  include/linux/of_reserved_mem.h            |  1 +
>  kernel/crash_core.c                        | 34 +++++++++++++++++++--
>  kernel/dma/contiguous.c                    |  1 +
>  mm/memblock.c                              | 16 ++++++++++
>  12 files changed, 98 insertions(+), 92 deletions(-)
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


