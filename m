Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31153C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0420D6B009F; Wed,  2 Sep 2026 04:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019506B00A0; Wed,  2 Sep 2026 04:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E986B6B00A3; Wed,  2 Sep 2026 04:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B164C6B009F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:53:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1089212012A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:53:48 +0000 (UTC)
X-FDA: 85168209336.27.54E6A1A
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1141F140008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:53:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jkGgGwDF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=No/gj0mTlHy4OPEirMqFngNNcLyxd3oSOl4Nf/LqO2Q=;
	b=PSQq/xM29+ehfxalI4HPFBvRT9x8jesAHrVh/+SZosLxH2FGQpwFg9zxTRgk1nyBvO/gNj
	/QVQBQ2fpiG/hlzd+Rh3NknoSXgrpBLNxBQwzepG0IWlz2LMmu0fRu34xpFJh9AiLDlYG1
	o2L7+oXglj1cu5MPbCCKt2ajEFyBPA8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jkGgGwDF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788339226;
	b=5cWTFpEppz8Z0qFe0gGtRdTK7Bq6Y+ng6VuYiz+FP7/RuOgLwkvjbEKZkSbeNtBCZgerDZ
	BQbzOiFcEzL+c7LBOc7n9WIUAl+SGc7M+zCxhUeAxxjVUAwN82zEfCIG7ZKDfCsXGODf/S
	Ef3nKUg8s/Ndho2XWC5Bj66JLD8m8G4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9DBxz8SjbKas7ulbguz4S6hfquD61Gb0V+1JSuE4lts=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788339224; v=1; x=1788944024;
 b=jkGgGwDFcsh5IgUuq9lO8368ZNk39TwWdOwICFfJLX+pp1HT+OCk5/n3sQgcn+M6Fhty7N8/
 qWtNEQOBiMF7Sg4928eIFy+WvmfZhTozlFP+VNJCA+UMWx367MsxNW7vFedIBd0CaKQ5c15WD1/
 k6SgTZe4tqOQ2oLUmh3P0Kw8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 67a4514beb846ad3;
	Wed, 02 Sep 2026 08:53:44 +0000
X-Mizu-Trace-ID: 67a4514beb846ad3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 16:53:34 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun Chen <chenwandun1@gmail.com>
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
Message-ID: <apfkDlcMYrgiuGYA@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5c9wi934kr19hed4us75snyy53a3mfc1
X-Rspamd-Queue-Id: 1141F140008
X-HE-Tag: 1788339225-698985
X-HE-Meta: U2FsdGVkX187inwajVJy8JfvROFmxexQ1T0neIM7FA/WtZtJqzQ5TWnvPOCGfUvCR1rSdfpsJfZJt8k+WaGpxodAiNFwkQpvdufBb/JuVmUY80rx8geXwI3Ul+J2fKMzvdYcAkD+yGtq4zMmEynTtDtoKMQE8uIWSlQNkgcORiEkPa4wEuGIeB09loy0cK59hoOLAwQz7NBvuYo1bhsEWYOl0eiPoX4SNKXRW7TNO96HqOqLzLs+9PkD/diH3oi4Drj5yM97LMSAjRNk0Q9ItmD1NIVQpWTtkqMjhxMhj4HC1HzruDgsZAcUBIhT+Oh0aItFAZR6Pz9vR1lTwsONgqg+Y3x1/w3VjpGA6Z9Az8nPU+yLalAvHINxdq9PdoDYjIepENX0zveJTGIy8CvhqrV73KzFkNY5u35inBnbzt6y2RAtV5eeO97HMGFFpqX192pd77np7lzS1dz5l5mb7q91KxQpV3ZPrpb5T9dDUUWLmbsu+6qm6KskkLxZRBOhr2aVNGa1A8ZupWNFRCwU++t81e3YyfQkVYbUCOyIg6ySciPIAyfc+VGTplmQBVn9NAIW/mVzt2yFhetqnBx2qR3O5Un58KD2TckqFEE/Zg35p2FEe51RHg871Ma+0VjTgm6TG29AL0JFU9enEmrMACVIXs5/Lz4MXkgPSPGrjSyoNLhN7WA31gN0i1/D/4vj6yqsHMnIA7SdGo4B0gEYCQ6CtR8mLHx6ds615nb3x9/JZdLRHCpaGGgx7R6vJi9TtuRQoKFAVnLf+ONaKx/t4C386QJpKhFPVntj46OoUnX/2wgTT0dk4czrUo2C27IvW7e3Xe9pPW4/3NibYwbWQBBoIjmaRRumgowe7Kp7aDUBsNVqHK4qVcOgpSNUFoRA+J/mr2k8rpKCgqJ/WJa6BpEE4tED5VsnOEaY4YCrE9oWLzRnRpBj/9olUywaAAbGfLUTL14EWEVz6UOfi8H
 zij82EVm
 35mu4I8BuOm7KrkvIfD2EQ/yfXqe9yEf1jBMqdHEeqmUaspZshpxyRPt5w4UXS2UIeQiq+SS/lMLwj27JkiPgwJOAOIETucnoynTRsI1yumuHAbgLyoBoKw+xl3De+1oxhHgANqbOs+plPqXM7c8ZXMT2fUKF1FSUYK/VtmAeyXKvlEPvoBANqRPft/YmFQrvrvL13IRe4bGoNhZiJ1TOWQLUiGOlRvtawg51D1R7k8WtF6YkMrqHyK0PU4LT3oO0mZ10j/Bb+567dL0Dr5IlTsIK+VacLuV45JjRzCYjZHyYQEeG8sziIeKNlIuVeyR6XQUhFIQtXi009jE6B15FtH62doWril7b1RGoNg6GS8ajT1HrGBRjbL+T5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wandun,

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> On SoCs that carve out large firmware-owned reserved memory (GPU,
> camera ISP, ...), kdump currently dumps those carveouts as part of
> system RAM even though their contents are firmware state that is not
> useful for kernel crash analysis.
> 
> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
> reserved memory on DT-based architectures (arm64, riscv, loongarch).
> Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
> reusable CMA regions are different because their pages are handed back
> to the buddy allocator and may carry crash-relevant data.
> 
> ACPI systems already filter reserved memory out of the vmcore through
> their existing path; only DT-based systems currently fail to filter these
> regions, which is what this series addresses. The flag lives in memblock
> itself rather than in a DT-only structure, so the mechanism is generic and
> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].

Thanks for the effort. I am not against this patchset, and I haven't
went through it carefully. Just from the cover letter, you mentioned
generic, I am wondering if this can be generic for excluding other
memory regions. Asking this because I try to find a way to exclude
unwanted memory regions too, please check below link where there's
the relevant discussion. We definitely don't like inventing wheels
time after time. Do you think this memblock region excluding can
be used in other places of kernel?

https://lore.kernel.org/all/aoLFai0gzzH2bGgy@MiWiFi-R3L-srv/T/#u

> 
> Since the reserved memory regions are filtered out, the vmcore is
> smaller in size and faster to produce. 
> 
> The series is based on linux-next and is organized as follows:
> 
> Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
>              flagname, switch riscv crash_mem to memblock, fold the
>              duplicated per-arch memblock walks into the weak
>              defaults, and serialize crash header preparation against
>              memory hotplug.
> Patches 5-9: NODUMP infrastructure: switch crash_core to
>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
>              flag, add a dumpable flag to struct reserved_mem, and
>              mark /reserved-memory and /memreserve/ entries with
> 	     MEMBLOCK_NODUMP flag.
> Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
>              header.
> 
> In v5, Sashiko found some pre-existing issues related to reserved-memory,
> and has no dependency on this series, so these issues have been addressed
> in a separate series [2].
> 
> v5 --> v6:
> 1. Serialize crash header preparation against memory hotplug to avoid
>    out-of-bounds or use-after-free issues.
> 
> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>    avoiding a panic from too few regions before resize is permitted.
> 
> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
> 
> 
> v4 --> v5:
> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>    DT-only struct reserved_mem.
> 2. Switch the riscv vmcore elf header preparation to use memblock
>    instead of the resource tree, aligning it with arm64 and loongarch,
>    so riscv also can exclude reserved memory from vmcore.
> 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
>    loongarch open-coded the same logic, so fold it into shared
>     __weak defaults in crash_core.
> 4.  Drop the v4 patch that saved /memreserve/ entries into the
>     reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
>     directly.
> 
> v3 --> v4:
> 1. Rebase this series on v7.2-rc1.
> 2. Add two cleanup patches (patch 02/03).
> 3. Simplify patch 03 to avoid checking whether initial_boot_params is
>    NULL multiple times, suggested by Rob.
> 
> v2 --> v3:
> 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
> 2. Fix UAF issue when alloc_reserved_mem_array() fails.
> 3. Add some prepare patches.
> 
> v1 --> v2:
> 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
>    feedback [3], v2 drop that property and exclude reserve memory
>    by default.
> 2. Split some prepared patches from the original patches.
> 3. Address coding-style comments on patch 5 from Rob.
> 
> [1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
> [2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
> 
> Meijing Zhao (1):
>   mm: memblock: add missing HugeTLB flag name
> 
> Wandun Chen (9):
>   riscv: build crash_mem ranges from memblock instead of resource tree
>   crash_core: fold duplicated memblock arch hooks into the weak default
>   crash_core: serialize crash header preparation against hotplug
>   crash_core: replace for_each_mem_range() with for_each_mem_region()
>   memblock: introduce MEMBLOCK_NODUMP flag
>   of: reserved_mem: add dumpable flag to opt-in vmcore
>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>   of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>     header
> 
>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
>  arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
>  arch/riscv/Kconfig                         |  2 +-
>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
>  arch/x86/kernel/crash.c                    |  2 +-
>  drivers/of/fdt.c                           |  2 +
>  drivers/of/of_private.h                    |  2 +
>  drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
>  include/linux/crash_core.h                 |  2 +
>  include/linux/memblock.h                   |  9 ++++
>  include/linux/of_reserved_mem.h            |  1 +
>  kernel/crash_core.c                        | 51 ++++++++++++++++++++--
>  kernel/dma/contiguous.c                    |  1 +
>  mm/memblock.c                              | 17 ++++++++
>  14 files changed, 131 insertions(+), 95 deletions(-)
> 
> -- 
> 2.43.0
> 

