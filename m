Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EEBCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763F56B0095; Fri,  2 Oct 2026 04:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C5E6B0096; Fri,  2 Oct 2026 04:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653B36B0098; Fri,  2 Oct 2026 04:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 344C96B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:17:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6FDE1A0661
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:17:18 +0000 (UTC)
X-FDA: 85276981356.28.BA9C9B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00C7DC0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:17:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQXXNjLk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790929037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yx8ebg2bvWYOV3tWECQ37hO2lwB9L2e0febzTmH5JU=;
	b=H/Llcmp6pmB5np0iHksvtsIGIT6+VSJrDr1QidRq4IswlU8f7Ml6UoXqsUyJHCCx2MWcPa
	BzaWBm8CY6k7r7PsCwIji1SI8wKY0HLEwBbvU3Wor/62TJKa2dqyUruczLD6QYXZbMb6ca
	5tSkHNVnCHdfX0KFSOn//g1L+LgfhgM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQXXNjLk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790929037;
	b=kWF20M9Ae8RkgszN9SGd5stpoN7HbUymWPu3M3xKbNnyfJ7Syw6ftmU+EDDyKeH9OZ/P5p
	wFjCgmQvXrlY38gf1gPF2GxWetBtlP0ajTyeTKfcYjf/JepUb8v7uYr5sZ48Le6sFcJYRh
	uOnt0A/2QBrMY8n2abGx4rnF4pFsksw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C41C41E45;
	Fri,  2 Oct 2026 08:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E981F000FF;
	Fri,  2 Oct 2026 08:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790929036;
	bh=9yx8ebg2bvWYOV3tWECQ37hO2lwB9L2e0febzTmH5JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nQXXNjLkwYz58zsrBOiKsev3kSoSv0Qn6uiQT1NeTnbVNcw1p5XvMUficJ1jAi+Ak
	 IrQUl6apYNM0BZb+MwY+skimjk4Gaz+DKfu2Z7rrlWqcHeKazOZ/231skNjWs+VoHH
	 hvldwUO3pE+zFitrOfFP0Nw36i/xpINvewLoPaNmIPApssJKO+twQoB8Do6cTfiqc5
	 iB8xlM34AUVUaxFI7uiDOgQFd78kW0wtR2JuI/FknTclevK64ODgJXoQ+NBv/ZOiVh
	 paTytyIjv85kIpY8OrS5F04vP35/hXTrzck/QL84DN+aQFgoAt0oSjO6j+qJxAzJrr
	 gQoYq19TSfH3Q==
Date: Fri, 2 Oct 2026 10:17:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: robh@kernel.org, baoquan.he@linux.dev, m.szyprowski@samsung.com,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	saravanak@kernel.org, akpm@linux-foundation.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v7 0/9] kdump: reduce vmcore size and capture time
Message-ID: <ar9ogXc12cLjziHS@kernel.org>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
X-Rspamd-Queue-Id: 00C7DC0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: w16gaxwjz6qndre4w9nr5b65cqaehs9n
X-HE-Tag: 1790929036-496798
X-HE-Meta: U2FsdGVkX1+9pPwzz5vWbySP1OqyztL/Sfy4sFwTwSw1mr8fWdmabXMJMlhppUVNuI+eDkmfqJnAlwgSbOzs3/ACIHLoVmB3jfwL8kYmgAaFO45eg9qFlDnLoEFLoer2UdCgBdFgecjH3Ty5fNUbHVzM828C7dBF9aPBbQtuUNRM6/ZQLNg4h4oQ1lWmcdGRp4BNW6dbZNjNMTCDFUA6Co/vRBW7zI7vseIEjJqKGFy4wRm3y7yKKqLm8cGgz2Tf3H94TI43eHWZR+VkooSkEbKl0zaAUvFLMXxMavvbGX1Y4XD3Jvf4pn7jOt3lss+T0tFGWKdFjd5R43A9LyZ6CgMjqEGdXjFRroKGoSdCuM6BhnKiedz3x4o8IzT00bWQ+6n0GGEaNeIqYN90S/5yCvIc1qkQRAk/fe5bSFS7afxW0fEa5sXdoATzMssi5CNbkIR65UisD80GLbpLSQFsEaUnYtu6Op4ZYPkXcuJvP/F0msa7eMUKLL0j73zSUSUpXUMQ7VJnXn3zK5vaBW1CRhcK7ykdlITwXY7rmvDM4fCpja5w+1a4UoOLHECnKFLkmQreL+BzE9x48wu2Ac/JfrEn00Aere3LHmyTEy/FlSZvCdnfJDuzHtPe0IJONYGW7yoQQPvdUKR54T3/xLGsTjxPvVGGYwIUaxzJu5MYdEzDfd7l0f9ksA5JME46+GHiFC7KwsXx5B0t0uZr8UtxPbFRQo4ZD0I42Dsy1dGBlIDNJUwXCqkEA65ZyCBz1pOFXiHIjNTmxfF/qLSl0g9/1KUFpiNyUkbXBCQaTr7vk6ztu+9tMnBZBEmqi9+bQxY0l+cTQNyzbuu4bWpW8Lw2IxDlQTgUhH2yXYeC8ak7eJlEZvTnjI35d6mR3CNIM1uamdEn9EkahFAlStOxoi2uYEEALjgEVPuo2cqSndVdHs1b4/pFqYYsrcl3YZuTxxrMw3K7lDKwADCyxE1JKLT
 9LhH1ZXJ
 L2D2dxEp5O3ZN27qBaDx0dV/o0SV0yBeM6YqPaZj7lh1hBnXxZQg0pAroebSBvHvu46SOfR9pf17wxl2oiqs8+OL4PfwOhG7CWcMgz2oQnJtQpvV3fZ6MLaTym3Is6WuDdi2O7WpHM1cSXTA5NITI2TUiUKyjJ69uxBgBWilg6W53XPDQjduSvGQwtN9WAPRqumks3NyYgBOeps59FO8osLGF7/G5q1deMrmZiwbAnfEcNKDyhTGc5bk1dmkkp4lHJpIhP32o8CYKcC9Xphp+lVDHQ5/ROWiDQAgsoacUMVEajoSlEKuGxu9qn1mUZbQNaCZAo0Y9T8PY7YmYrxkzzSP3ZU7rDhDB8vfPZX+qYdOu36jHHu5BmFoaexNV9g11W7FhyqreeFrknzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wandun,

On Tue, Sep 22, 2026 at 04:42:47PM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> On SoCs that carve out large firmware-owned reserved memory (GPU,
> camera ISP, ...), kdump currently dumps those carveouts as part of
> system RAM even though their contents are firmware state that is not
> useful for kernel crash analysis.
> 
> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
> reserved memory on DT-based architectures (arm64, riscv, loongarch).
> Reserved regions are marked MEMBLOCK_NODUMP by default so kdump omits
> them; reusable CMA regions are different because their pages are handed
> back to the buddy allocator and may carry crash-relevant data.
> 
> ACPI systems already filter reserved memory out of the vmcore through
> their existing path; only DT-based systems currently fail to filter these
> regions, which is what this series addresses. The flag lives in memblock
> itself rather than in a DT-only structure, so both ACPI and DT systems
> can benefit from it (suggested by Rob, thanks).

Can you elaborate how ACPI systems filter their reserved memory?
With your patches, the memblock flag becomes a part of DT-only
infrastructure, so that claim that both ACPI and DT benefit from it does
not hold, doesn't it?
 
> Since the reserved memory regions are filtered out, the vmcore is
> smaller in size and faster to produce.
> 
> The series is based on linux-next and is organized as follows:
> 
> Patches 1-3: Preparation and bugfixes: switch riscv crash_mem to memblock,
> 	     fold the duplicated per-arch memblock walks into the weak
>              defaults, and serialize crash header preparation against
>              memory hotplug.
> Patches 4-8: NODUMP infrastructure: switch crash_core to
>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP flag,
> 	     add a dumpable flag to struct reserved_mem, and mark
> 	     /reserved-memory and /memreserve/ entries with MEMBLOCK_NODUMP
> 	     flag.
> Patch 9:     Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
>              header.
> 
> v6 --> v7:
> 1. Fix a stale MEMBLOCK_NODUMP flag issue [1]. Memory reserved and
>    marked as NODUMP may later be freed (the initrd, for example),
>    so the NODUMP flag must be cleared accordingly. Since the fix is
>    part of the NODUMP infrastructure introduced by patch 5, it has
>    been folded into that patch.
> 
> 2. Drop the "generic" related description in the cover letter.
> 
> 3. Collect the Acked-by and Reviewed-by tags received during the v6
>    review (thanks to Baoquan, Mike, Rob and Marek). Patch 5 is the
>    only one without a tag, as its Reviewed-by was dropped when the
>    fix was folded in.
> 
> 4. Drop patch 1 of v6, which has been merged separately.
> 
> 
> v5 --> v6:
> 1. Serialize crash header preparation against memory hotplug to avoid
>    out-of-bounds or use-after-free issues.
> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>    avoiding a panic from too few regions before resize is permitted.
> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
> 
> 
> v4 --> v5:
> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>    DT-only struct reserved_mem [2].
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
> [1] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org
> [2] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
> 
> 
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
>  mm/memblock.c                              | 43 +++++++++++++++++-
>  14 files changed, 155 insertions(+), 97 deletions(-)
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

