Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960C5606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2rOEA41
Received: by kanga.kvack.org (Postfix)
	id 9FFE36B05B1; Tue, 10 Nov 2026 03:47:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7366B05B2; Tue, 10 Nov 2026 03:47:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914546B05B3; Tue, 10 Nov 2026 03:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 692C36B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:47:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E353280706
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:47:51 +0000 (UTC)
X-FDA: 85418581542.07.A219C57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4DF2D140002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:47:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2rOEA41;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794300470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=971CVAco0wRsepZ2O+DuyJQLTFxXmiUWfADT6vKykDg=;
	b=VGY6gTsrHovXziE/mHAm8aXaFwXMSLW1cbVb+NpWJbSDZjeSVI5PShyS0DcJY/ayZ2jjtl
	2mrJLdTgc7oDIXW6B9pbvb1lCjTQqVpBQgF2fB4R80N5vQv7KKAeuvpjXxDc29tMoUYXYm
	Ya25QyWMgjoxE6vQ8pnZLjekvSKH6H8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794300470;
	b=JaszlBhUgjORHOqO9T0zDnX/hiOE0JLgeXrNIOo8pmCr5dOsPslxeTSvc6Tf2QXaOwuO0d
	vlqGPQvC7RUGoRTvsiXEcTOuv7gcSOU+TQQ+/OHYGYjxDeAAkW3Yh4hQG7dJTxTEi0hzcL
	+Ezkw35LG6FR9aBSuJVzw6qhw1Em5Js=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2rOEA41;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C87B631A3;
	Tue, 10 Nov 2026 08:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B911F008A1;
	Tue, 10 Nov 2026 08:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794300468;
	bh=971CVAco0wRsepZ2O+DuyJQLTFxXmiUWfADT6vKykDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E2rOEA417uw2D2zqDfgokpjiUXSld29mrsEuVXHxP9GLTFMBlE9QpzHB6cYJTRj/s
	 bNb9RuSh51wCZosf6cEmHsHb6r69dXLTOsubsj2wByaWqCyXZUHjmBKEw6LaYFbXfo
	 tOTCOlCqR3rDCMMlaykpekQZGQflPc8CBcScbJuftXTOg43KZQzuE6dJ9pYq2BHlsc
	 E13UUPMqzYhMiYC3vMc84UcC6JglBm/DDXTSCvJyPCXIVwgjYBXJuZB+eFqVYzkZk4
	 BmfdxZ6u5kOCqxW439hUAZML7ys1hMaZACoMClSmusSg0Z35PJoD2xdz7m/LBLHBsf
	 L5ZzCcDj9+wBw==
Date: Tue, 10 Nov 2026 10:47:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Wandun <chenwandun1@gmail.com>
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
Subject: Re: [PATCH v9 0/8] kdump: reduce vmcore size and capture time
Message-ID: <avLaJxIrrnMQngO9@kernel.org>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <7773d026-4aef-4169-866a-71ec9a91da21@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7773d026-4aef-4169-866a-71ec9a91da21@gmail.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: z7kdd838ze65cjijn8b9e76js1tbhake
X-Rspamd-Queue-Id: 4DF2D140002
X-Rspam-User: 
X-HE-Tag: 1794300470-268326
X-HE-Meta: U2FsdGVkX1/cccGKTpshqDMO3oukfPTSvolfVlY0QHr6CNyuleTCd89sdTm/slZOIkVkedSnU7lW3qyOYc5EIPFeEY4nYan+JCjdj+rMkDJL4t7B8Mq/MTY5JKUT9wzk9rRHBEUwfLCL5+SJxx2kO2d7Z/P7nhuaurZFiHv1GIAx7h2ijjqB4H/NfrquEpLTP0ehRs4yolTapQqI1cjilcGCoPor12kTJe9EzfIRprtfxEdlFN7eLVEZIuoOlwDVFETVZPtcmfD8e3GY10b0xaaH8JBKEMogqgpaNhs3p7N/JTBcLmnjvv1wJOwLjuSFsTZpfLRtU8uUV2CrPCs/qUeR2lSDNw12MownH0sFaNZDT0sX1BzqDmAQjux8raBdrS4QPcqQVyk702pjUuvjYOEk1Hr9qyMNHwsR/ERxmKEXC+CtH5Upy8wLsyzEduKHV3iO9GPLcW9DT/+kBx1wlubzsymCvL5X+ao6TaQFV3FZq30thgJltjUHEcnnQr4vJwIIjWhaUFabVd8TFi3HVYV9hDpZazwm8b8MCC1WxIUNK6JbevMe+EUIreUmqvjMqZXJsr0es0wiE5Fmfi8irA8RT2zYswH4xjgn3dAm/2cxITjsRxTKGOe8xedrUxpmdsyO4DxoR0rAzCW+OqO04rkLYQS4IAm5gZt48Ou6+VydXQHFLZmMIegQCpHCE37YF/VzLV7YYxi9bxl95nPPFum4aOU4nmijJziOYABwyimoAvS5NqGXLd0XlrzfqWY0aIv4FJrd1jGhY9ysaDd8+sqVfaDev05jKuUDJt89ghaw/80rwbmh8MmuxESs3O/RZJqAsY7RnqfdhK20tdpxVYFbFzS5EDj236rUATR7cD/fEjoT86aAEK8aDg46MUHV0xR1gl/79iVMJ4IOI6mxZFGVbqWGK75QqpaFQl53NQEevE7vfA9B+F/0pdZw9+mt/OBG6hNoh0K31cIE7Y/
 SS69z70H
 DThhJVmvUSV0N2VTgbGO37TOcv98liTqSwgCsC/0/VYRqUyMzf/lYMNk5DIk0m2M5pgkS313i484yyIpX2tUpFl1hFWWpA9L+9ThOSuMdu0eqyXk/ajdV3huLUELAg1igbUDP0CkYRKzQkQzeZee1RLf0aodCA7j+dbPisa25XU1JuTJ2vl3OTu8LyxAtl+5encCplvajp6yIGnbuRn/g6y7J+F9QgDC3QZ4MYbsh43O7HdrxjcRZXMrRIWnCZU3e4F+DMQmkZnsmFqvIwEVaxdRHQ2UtGW8e66vJQBfFvaUwsDqaWHqGXaoKVO9dJQYEWUJUWjeAgaNOd0r4e8zfS3QR+jU2M/2Y8O1SOKxeAjUUFEe5vBfvrzirTbvTYmjAYtlGmfLG3lFh/13abbvR3wnrdpWnOZB0gwG0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Wandun,

On Mon, Nov 09, 2026 at 08:23:16PM +0800, Wandun wrote:
> 
> On 10/21/26 16:30, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> > 
> > On SoCs that carve out large firmware-owned reserved memory (GPU,
> > camera ISP, ...), kdump currently dumps those carveouts as part of
> > system RAM even though their contents are firmware state that is not
> > useful for kernel crash analysis.
> > 
> > ACPI systems already filter reserved memory out of the vmcore through
> > their existing path: firmware reports those carveouts as unusable in
> > the EFI memory map, they get MEMBLOCK_NOMAP set in memblock.memory
> > (is_usable_memory(), efi-init.c), and the ELF header builder has
> > always skipped nomap regions; only DT-based systems currently fail
> > to filter these regions, which is what this series addresses.
> > 
> > This series introduces a MEMBLOCK_NODUMP flag (suggested by Rob) in
> > memblock to filter reserved memory on DT-based architectures. A new
> > flag is needed because MEMBLOCK_NOMAP can only express regions without
> > a linear mapping, while MEMBLOCK_NODUMP can filter regions that are
> > linearly mapped. Reserved regions are marked MEMBLOCK_NODUMP by default
> > so kdump omits them; reusable CMA regions are different because their
> > pages are handed back to the buddy allocator and may carry crash-relevant
> > data.
> > 
> > Since the reserved memory regions are filtered out, the vmcore is
> > smaller in size and faster to produce.
> > 
> > The series is based on linux-next and is organized as follows:
> > 
> > Patches 1-3: Preparation and bugfixes: switch riscv crash_mem to
> >              memblock, fold the duplicated per-arch memblock walks
> >              into the weak defaults, and serialize crash header
> >              preparation against memory hotplug.
> > Patches 4-7: NODUMP infrastructure: switch crash_core to
> >              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
> >              flag, add a dumpable flag to struct reserved_mem, and
> >              mark /reserved-memory entries with MEMBLOCK_NODUMP.
> > Patch 8:     Skip MEMBLOCK_NODUMP regions when building the vmcore
> >              ELF header.
> 
> Hi all,
> 
> A gentle ping on this series.
> 
> I'd appreciate any further feedback, particularly on the
> MEMBLOCK_NODUMP discussion and the issues raised in the Sashiko
> review.

I'm fine with MEMBLOCK_NODUMP.
The issue Sashiko raised about bound check against cmem->max_nr_ranges
seems valid. 

I didn't check the reserved mem one.
 
> Please let me know if there are any other concerns or suggestions
> before I prepare the next revision.

I believe that should be rebased to account for reserved memory changes.
The riscv change from resources to memblock needs an Ack from riscv
maintainers.

And with all that I can take the next version via kexec tree.
 
> Thanks,
> Wandun
> 
> > 
> > v8 --> v9:
> > 1. Patch 7: Avoid a potential boot panic on SH when NODUMP marking requires
> >    memblock resizing before it is allowed, found by Sashiko in [1]. SH supports
> >    neither CONFIG_KEXEC_FILE nor CONFIG_CRASH_HOTPLUG, so skip marking when
> >    both are disabled.
> > 
> > v6 --> v8 (v7 mainly tried to fix the initrd issue on release in v6,
> > that approach is superseded here):
> > 1. Stop marking /memreserve/ regions with NODUMP. v6 marked
> >    /memreserve/ regions with NODUMP. But a bootloader may specify
> >    a /memreserve/ entry for memory that the kernel later frees
> >    (e.g. the initrd), and those pages would then be wrongly
> >    filtered out of the vmcore after being reused as normal memory.
> >    The v7 fix (clearing the flag in free_reserved_area()) caused
> >    a lockless runtime mutation of memblock.memory [2]. Better solutions
> >    exist but need extra preparation, so temporarily dropped the patch
> >    that introduced the problem to keep this series simple in v8.
> > 2. Fix a build failure in patch 2 with both ARCH_KEEP_MEMBLOCK and
> >    MEMORY_HOTPLUG are unset. There the memblock arrays live in
> >    .init.data, and the weak defaults referencing them create section
> >    mismatches, which turn into build errors when SECTION_MISMATCH_WARN_ONLY
> >    is also unset.
> > 3. RISCV recently gained crash hotplug support, so adapt its handler
> >    like x86 in patch 3: use __crash_prepare_headers() instead of
> >    crash_prepare_headers() to avoid self-deadlock.
> > 4. Update the cover letter per review feedback: describe how ACPI
> >    systems filter reserved memory and why a new flag is needed
> >    instead of reusing NOMAP.
> > 
> > v6 --> v7:
> > 1. Fix a stale MEMBLOCK_NODUMP flag issue [3]. Memory reserved and
> >    marked as NODUMP may later be freed (the initrd, for example),
> >    so the NODUMP flag must be cleared accordingly. Since the fix is
> >    part of the NODUMP infrastructure introduced by patch 5, it has
> >    been folded into that patch.
> > 2. Drop the "generic" related description in the cover letter.
> > 3. Collect the Acked-by and Reviewed-by tags received during the v6
> >    review (thanks to Baoquan, Mike, Rob and Marek). Patch 5 is the
> >    only one without a tag, as its Reviewed-by was dropped when the
> >    fix was folded in.
> > 4. Drop patch 1 of v6, which has been merged separately.
> > 
> > 
> > v5 --> v6:
> > 1. Serialize crash header preparation against memory hotplug to avoid
> >    out-of-bounds or use-after-free issues.
> > 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
> >    avoiding a panic from too few regions before resize is permitted.
> > 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
> > 
> > [1] https://sashiko.dev/#/patchset/20261016061549.4181390-1-chenwandun1@gmail.com?part=7
> > [2] https://lore.kernel.org/lkml/20260922090252.B01541F000FF@smtp.kernel.org/
> > [3] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org
> > 
> > v5: https://lore.kernel.org/lkml/20260806093519.2907771-1-chenwandun1@gmail.com/
> > v4: https://lore.kernel.org/lkml/20260630074715.4126796-1-chenwandun1@gmail.com/
> > 
> > Wandun Chen (8):
> >   riscv: build crash_mem ranges from memblock instead of resource tree
> >   crash_core: fold duplicated memblock arch hooks into the weak default
> >   crash_core: serialize crash header preparation against hotplug
> >   crash_core: replace for_each_mem_range() with for_each_mem_region()
> >   memblock: introduce MEMBLOCK_NODUMP flag
> >   of: reserved_mem: add dumpable flag to opt-in vmcore
> >   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
> >   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
> >     header
> > 
> >  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
> >  arch/loongarch/kernel/machine_kexec_file.c | 27 -----------
> >  arch/riscv/Kconfig                         |  2 +-
> >  arch/riscv/kernel/crash.c                  |  2 +-
> >  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
> >  arch/x86/kernel/crash.c                    |  2 +-
> >  drivers/of/fdt.c                           |  1 +
> >  drivers/of/of_private.h                    |  1 +
> >  drivers/of/of_reserved_mem.c               | 18 ++++++++
> >  include/linux/crash_core.h                 |  2 +
> >  include/linux/memblock.h                   |  9 ++++
> >  include/linux/of_reserved_mem.h            |  1 +
> >  kernel/crash_core.c                        | 53 +++++++++++++++++++++-
> >  kernel/dma/contiguous.c                    |  1 +
> >  mm/memblock.c                              | 16 +++++++
> >  15 files changed, 103 insertions(+), 94 deletions(-)
> > 
> 

-- 
Sincerely yours,
Mike.

