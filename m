Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BA4C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AEB6B0099; Fri, 18 Sep 2026 03:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BF06B009B; Fri, 18 Sep 2026 03:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B416B009D; Fri, 18 Sep 2026 03:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 732926B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:03:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC216C0572
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:03:36 +0000 (UTC)
X-FDA: 85225992432.30.6BB2393
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4B1801C000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:03:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aPqXv2uZ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715014;
	b=MP+FLqDdqZyVQhoSG/tPhAG47DO+DET1+Rd0eU0MvXb8jknZ+uer9YMX70G2A0Zh18zgf/
	vqSYcai6jMnYcQPnDgN+ED6sCUDFuAzTCHpE5bBy2eNIy1DDf0IG4T2e43I8C57erEpIkr
	WghZDARKwCObT7kngOtPXA+PbM4y+l0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aPqXv2uZ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ep+W+Lzk1KLKOXlBALTloOl7Wm88/geYoc+t7Jo7KS4=;
	b=JvWupNky++RytfrI6U1XDor8hlOx0MXUs+mTaR6sqbSdk4jfgrXt0vJ3SmyuJy7k/BLabY
	OiuW+BRWVOBGB9kTOOgFSAZw6r+xDeEe0RpcRS8TUPmSSsX2UvW7rh3jnfxA+lmJkl2OPe
	beXRs3m/TNEBrTYyNKA8tYzGOVGl6mg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0CC160A5A;
	Fri, 18 Sep 2026 07:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4649D1F000FF;
	Fri, 18 Sep 2026 07:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715013;
	bh=Ep+W+Lzk1KLKOXlBALTloOl7Wm88/geYoc+t7Jo7KS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aPqXv2uZx1vrO+PGIvxXetVU48iXAfQOmpEtCVU//nGS7ei6IPcEoDCJgz3uBJ/PI
	 4Ddj/QUegJf2lBmSwpiwGp0foLgSapfWj8m4hF+/C7TOHKXoy5QC/HRyVZE7XtGvDi
	 oIiMOu5mX7bOS9af9DCTeeRRRfgZJHWVSCoGTm7NkbtqJVjEutnRc8rJ79LAAI6xNM
	 LI35wyNgzvc0HS0XFS9SL1xqlGnKNh9JkTPxSK1Fbgm6sfte18euCfzErieKv0gAFR
	 1uDxAjt1ilWU3dgH+v91xGigckxp1MSaaqBJ4RgpW3b9zxO7GZ/pOARkUq7rmhnxBg
	 2S0VaeUw3vPyw==
Date: Fri, 18 Sep 2026 10:03:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wandun <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org,
	baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	pratyush@kernel.org, m.szyprowski@samsung.com, mark.rutland@arm.com,
	kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v6 00/10] kdump: reduce vmcore size and capture time
Message-ID: <aqziOmx1yhy0ozkX@kernel.org>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <13cfcd99-e420-478b-8ce8-06674727977d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13cfcd99-e420-478b-8ce8-06674727977d@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B1801C000B
X-Stat-Signature: qg4m86nufx9owjbzwc1d7unh7n4ww4i6
X-HE-Tag: 1789715014-621905
X-HE-Meta: U2FsdGVkX19Z0GWG9eVexDayM/bvGY5YsUOaZ3RjKo9jA/9rlLuI7lnLcLK+mdXcrhoHkXDagVFGXMVw9bfN05yv1PnCe8DymX9c+dW3YjF4/YiJ0y6K554adcepVZzVlfycOh9Ilg0CK3fvNsFeml2ZUHVo66Ha28J6VVucoHR6rLPRN7/KIYtmLsIPRFjlxK8Xh1/DhIVw4F2X6xo0iBwkgimAR/FNgN7dHfQ9msgeMD2iVqzkRHim+8tQ9o3xC+WAZtgusMTIrj4zg3hCirEvzxHLsOKJB1A9QVrMWZu/O9VWXAupHu+Xn6sIelPKDlSDQ779eI7dJlrPXGgbCF+4Wy2lmcSvTY0mZ3mkPu8fQLh156UkA2g87fgZlVkGd2ZkFyi+Ph1CcESmEaaqyBbfxiP64h4krjsArxXcwwC+QSMuJev4tDUJ7ASInV49qhlug54a82WIYPydKN/aYjWZsDwXEGkBsfXlnSPuQHIdrLUOlpmCZarXj/yUmgTtazoFxp2dFudyhF5D3CCc3P8naDZXYtz5AnJDNdDUEkd+Qa48qplvXBb/Eb5rpPzyKlAEMNZ9xhzqITIL5Li30WnnOKGI8RV0FJXicTGKGF3cH+Lh8zlKklCSEtuguQwnBQxTC/POVABmwd59/lunkIKtCEcUdzn61Oq230FVcDMJltIC+ywLbqgIk/lNLUB0j0DW4bVniuD2n/RqzeIyxJ/QZuKNxWYD3aDwSF79ExXkjzhuuVqZ71q07ufenZhmDoa4h/j1UFZ8E6r9cK6gyzhtcD2F3auMCqwRjMv7MQmjcuCUx0g8NGXI+wZ/IEtGtIE0QSe+8BExW6JxYJqoWZJDYUPAjohYq7t+l9+NUEbU+XAiST/kHYfOXbo++eEWCaUO4Fw92hqy3rIhYVgy2IMenojje+A1nnWn6uyA2lLj7tQ4vGesI2vhKCyH6RzpZNbB+W49DZ8rxxpTdzl
 JGDhskOz
 bbKFgyW/T2vOrjWm/ZjGavnwWINGv84iNO4oyoYx32K2rNRFSEruJjrIS8g4eulpqx+rUl6PXF1bW9Qh27W4z4QklrBbRRaSszj7zIkW5YAhb1Cl4YxpY5XWRJZuxNFRU4qR9Wl+1KnCSRptBHJxzjcmBVcfqWxRmgOa8zF6LL/80qTqoMu4LwEr8V+Y2XHbLWCvmyfqfSIYMWHCHCQnT3mjdu16XdtN6mzHqtF0E9RcxFy5f6F5SMLntDJ/1VVtPSsWyI1YXPwpyKWrytlw/9LRzVh3VyWcr8dKFn3ajyFksrNUITIqAX4IZXTkZWHYgan1ZuKA2zyJax8sB+yVzkSS4uPPWVdNsACYkS0uANdHJSEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Sep 15, 2026 at 09:01:07PM +0800, Wandun wrote:
> On 9/2/26 15:31, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> > 
> > On SoCs that carve out large firmware-owned reserved memory (GPU,
> > camera ISP, ...), kdump currently dumps those carveouts as part of
> > system RAM even though their contents are firmware state that is not
> > useful for kernel crash analysis.
> > 
> > This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
> > reserved memory on DT-based architectures (arm64, riscv, loongarch).
> > Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
> > reusable CMA regions are different because their pages are handed back
> > to the buddy allocator and may carry crash-relevant data.
> > 
> > ACPI systems already filter reserved memory out of the vmcore through
> > their existing path; only DT-based systems currently fail to filter these
> > regions, which is what this series addresses. The flag lives in memblock
> > itself rather than in a DT-only structure, so the mechanism is generic and
> > both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
> > 
> > Since the reserved memory regions are filtered out, the vmcore is
> > smaller in size and faster to produce. 
> > 
> > The series is based on linux-next and is organized as follows:
> > 
> > Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
> >              flagname, switch riscv crash_mem to memblock, fold the
> >              duplicated per-arch memblock walks into the weak
> >              defaults, and serialize crash header preparation against
> >              memory hotplug.
> > Patches 5-9: NODUMP infrastructure: switch crash_core to
> >              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
> >              flag, add a dumpable flag to struct reserved_mem, and
> >              mark /reserved-memory and /memreserve/ entries with
> > 	     MEMBLOCK_NODUMP flag.
> > Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
> >              header.
> 
> Hi,
> 
> Gentle ping on the remaining patches of this series.
> Patches 1, 7, 8 and 9 have been reviewed (thanks Mike and Marek);
> Still looking for review on patches 2-6 and 10.

I'm waiting for reviews from Baoquan and Dave for crash core patches before
applying this series.
 
> Would appreciate a look when you have a moment, happy to rework
> anything based on feedback.
> 
> Best regards,
> Wanun
> 
> > 
> > In v5, Sashiko found some pre-existing issues related to reserved-memory,
> > and has no dependency on this series, so these issues have been addressed
> > in a separate series [2].
> > 
> > v5 --> v6:
> > 1. Serialize crash header preparation against memory hotplug to avoid
> >    out-of-bounds or use-after-free issues.
> > 
> > 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
> >    avoiding a panic from too few regions before resize is permitted.
> > 
> > 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
> > 
> > 
> > v4 --> v5:
> > 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
> >    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
> >    DT-only struct reserved_mem.
> > 2. Switch the riscv vmcore elf header preparation to use memblock
> >    instead of the resource tree, aligning it with arm64 and loongarch,
> >    so riscv also can exclude reserved memory from vmcore.
> > 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
> >    loongarch open-coded the same logic, so fold it into shared
> >     __weak defaults in crash_core.
> > 4.  Drop the v4 patch that saved /memreserve/ entries into the
> >     reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
> >     directly.
> > 
> > v3 --> v4:
> > 1. Rebase this series on v7.2-rc1.
> > 2. Add two cleanup patches (patch 02/03).
> > 3. Simplify patch 03 to avoid checking whether initial_boot_params is
> >    NULL multiple times, suggested by Rob.
> > 
> > v2 --> v3:
> > 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
> > 2. Fix UAF issue when alloc_reserved_mem_array() fails.
> > 3. Add some prepare patches.
> > 
> > v1 --> v2:
> > 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
> >    feedback [3], v2 drop that property and exclude reserve memory
> >    by default.
> > 2. Split some prepared patches from the original patches.
> > 3. Address coding-style comments on patch 5 from Rob.
> > 
> > [1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
> > [2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
> > [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
> > 
> > Meijing Zhao (1):
> >   mm: memblock: add missing HugeTLB flag name
> > 
> > Wandun Chen (9):
> >   riscv: build crash_mem ranges from memblock instead of resource tree
> >   crash_core: fold duplicated memblock arch hooks into the weak default
> >   crash_core: serialize crash header preparation against hotplug
> >   crash_core: replace for_each_mem_range() with for_each_mem_region()
> >   memblock: introduce MEMBLOCK_NODUMP flag
> >   of: reserved_mem: add dumpable flag to opt-in vmcore
> >   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
> >   of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
> >   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
> >     header
> > 
> >  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
> >  arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
> >  arch/riscv/Kconfig                         |  2 +-
> >  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
> >  arch/x86/kernel/crash.c                    |  2 +-
> >  drivers/of/fdt.c                           |  2 +
> >  drivers/of/of_private.h                    |  2 +
> >  drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
> >  include/linux/crash_core.h                 |  2 +
> >  include/linux/memblock.h                   |  9 ++++
> >  include/linux/of_reserved_mem.h            |  1 +
> >  kernel/crash_core.c                        | 51 ++++++++++++++++++++--
> >  kernel/dma/contiguous.c                    |  1 +
> >  mm/memblock.c                              | 17 ++++++++
> >  14 files changed, 131 insertions(+), 95 deletions(-)
> > 
> 
> 

-- 
Sincerely yours,
Mike.

