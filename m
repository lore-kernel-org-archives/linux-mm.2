Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8F2606A325
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SuwAv+fe
Received: by kanga.kvack.org (Postfix)
	id DEE4C6B01F7; Wed, 21 Oct 2026 04:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5C26B01FA; Wed, 21 Oct 2026 04:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB52C6B01FB; Wed, 21 Oct 2026 04:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8A736B01F7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:30:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2178DA7D9B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:30:33 +0000 (UTC)
X-FDA: 85345961946.26.98A0B40
Received: from mail-pz2-f6.google.com (mail-pz2-f6.google.com [74.125.228.6])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68057120008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:30:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SuwAv+fe;
	spf=pass (imf29.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z2i7Do+cloqJgPeb5aYLDs8IqOGcJVVvWxpYdA4Y6+Q=;
	b=tb1jOV5v8PubrEB1jHt975MMlilWVmvM1/ttsQfTddgjEtsrK0h4rbWGdk119UsCureSNR
	JD+3N82adTngTi/g3+YAEm0ZT8taVz0ClF9DMX1IoH0xrg7fPnnhVBg8Uddex2jUj8ZZzQ
	LZIwiuL7kVQl4lMubU3CiPLhIsbZP28=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SuwAv+fe;
	spf=pass (imf29.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571431;
	b=TJJxzLFwSwIlssdHku8tMhiVfVvJOkMmKXtzyB3cCV4B5K0Ena8bEveW5HN5VZa74FQUCE
	7U8QJRWZCOVfBiZ0qMmX3d1VTkO+J/TClwkasBxX67cbPCtOMcbzfVG/YGwNTfZhib3rPi
	9yXUyabXAyL4REpBZrMs40hnWszeh8U=
Received: by mail-pz2-f6.google.com with SMTP id 41be03b00d2f7-cd613507bd1so29356a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571430; x=1793176230; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z2i7Do+cloqJgPeb5aYLDs8IqOGcJVVvWxpYdA4Y6+Q=;
        b=SuwAv+feV1pak3AFe/BtVtiGg9kkJMcTjJTkiEOrDcDqYezac5tIjRtfHrvhwbuBKA
         7yFzU1rOOp52znrasGgeZWhJxFe2WnFcjL8MnD848dMxfli+42d6ziVQ9RV9yafCdVCb
         YGb6P0TEUpI4Bi3U2zTukX+C5WMar9q5/cAeC8291ZPRt2cdnNY4eV2K9zy0QLWCWVzC
         YxCeBVBmebQd/w7kYuBBKHedpgEagxlgDBPS48Z1n6nxV8lBIEGQArQD4tbkWR+/s3nn
         WslZyUfybWqXYebXJiapetI3Iz7hdhSVLpA/Z/FpPvyjoetgqvQxKo65mQu3tbztMUgw
         4elw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571430; x=1793176230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z2i7Do+cloqJgPeb5aYLDs8IqOGcJVVvWxpYdA4Y6+Q=;
        b=nJODECl+eNKM92W4Vn160u39+hnrf/JBrmDBR5mPZEIJgjhOLLboC1wqMSw1gRyKp1
         LzS0MiFwiVb4Enx4IxZ2BXKVeF2G1BvS7qlWYJpGE4W10q4Fh+C1M8BU1JufyJV+lmOd
         ReijoDMfsM/iujBEHJ/h6XJg2VCTXZgYx/QPHtt9qOkKU4RaFX+yU2h5ynx6qPaSWZ9c
         DJAp1VkGcNDCo46c3XRogRkVIKn8OfigQ13ZwLuqOF22V78IOkSObJDVADvHKEeDCe4n
         +evsQODcczpSHKIxHngYmWTTSmRxu23ZCwwJEahWkgqAlHunNnA02eXJDXwINKFXkxvi
         TxUw==
X-Forwarded-Encrypted: i=1; AKwUvBx0YbPLmcwojXOjwTwcyPbw5MRf/aTHxBI8UUuwmil9dAeCk0WZmFPJ1bY5/mlnEXiQOZCX+Q4RtQ==@kvack.org
X-Gm-Message-State: AFq9FYKpyRqnAgrh9kif4s7LPnZOflopMvQ4Ar1dTT2auAVBs5lo552e
	Ygjxq5vKpFjtNn95S9WNM90FobvJgn9Jmi2TDp/ACn1k4fXlH4DXw230
X-Gm-Gg: AYBFou2TX7tIV6OD2A4RghGWtXaiJ2dPXfzVYYSvGrUpGMNfOg5yLn4SyhfnupBWRrg
	WZ8YRsGwwXg/Wo6TSy1gm7WPzO4O4VFh/GA27UWuyCd3lgM5OXjKy43Ilp3iOni+1KboJthHV0m
	qGH+TR+T0pyb1+P0Z3AsB+uqlQ0TzlxKVCsFcGPqa5wgjchWbUrWvMLNup+M9wdYugBaitNzRJ6
	opWiKk6j1Pc1aSO2c7ZZNjhPHIByu8AqhHkH/WXGOH9RN0QKiN4ZF8veQe3XEJe/vzd/c+4DKDX
	0eZUc1woqv1FdTkIzELz+XJWmp1KZ8r+3DxxFaOSrTJNwWpIHn9jzvPoy4vIvegjO2LERNJqlaP
	rMmkTCcc6Byo67CnxAUHsGsj2ioszHqvSGiY8SxPTZCEOyjXhV0yA+im9o6Ih757DMrNjlUGpQ3
	UbOlwCTNzHVTdeB1rhdCR/BAI4luFvDDOqlf9799zeMztd6xEg4RNEwh9kjm7156CCNBre/xJy2
	22/H3VO4jhWOTFOOPPr4IpuZcVwDGnzqPgh0YqSO5NlNmXYSpRWcf/cheBbZq04Vi9L
X-Received: by 2002:a05:6a00:918c:b0:8a0:2344:c44b with SMTP id d2e1a72fcca58-8a089d5de3cmr958437b3a.40.1792571429981;
        Wed, 21 Oct 2026 01:30:29 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:30:28 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v9 0/8] kdump: reduce vmcore size and capture time
Date: Wed, 21 Oct 2026 16:30:03 +0800
Message-ID: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68057120008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: koz7ymjj1bkyyorzr91dntug8fdgsna4
X-HE-Tag: 1792571431-578949
X-HE-Meta: U2FsdGVkX19/c8jbLIVuL1EASRdjMwTgM0wELlmO6T4j/xmG1blT+vZ2mtrde+Qbbsjh5qG+l6Uu1ooFgvRc2gX5Rc3fN9XU/RYJdRH0E+WjyrHX6+RpBrU3AjdfadUrDmXPxd6I4nAlEDdeNjYHz8/H5x2KENgAeEtsp6Pzi4kLRfUZrdikNi3USUW5nWysjxP04MJI+iMdz/LUGpZEfJ99BXNFrliu4XjZZFBSPCGkV6AnvTNYa0OLWC8thLj9oFzWbojjrTwKHXCblAmCd/QzG4OZsYuSf3mFiJQA645MYHSw7hZX5VBB7Yxe26q8TPpY1VzwyYjRcVU3ACn4YW5FVfGAt6CNYbZc7nhv+mhh0Bu3G5sKaDrb10BAXyKy/bNUWXcQMXrQSWZOUZVcYwDdrZxUkPwyuME3BdBApqunj6vk6pXJNZfesn+4Moyk7CVmqGqg9Y7aF5nYW+tbYAINieDjOP6QcdHV6MaT7k3npRXnSKLTudNUW7KB6aSYI5OeB4EowHnWpcDrsKupevx759JFmkQt4pSv8XZ1f7HYMNUKpA+7J8D88liJgU0dMznlas7SaQwoxhht6c/V6JKQcPgWm9U2GGKkN/KCN3TjLjhsU3/avFZOrpKHzU6GP9aqac0lmA2Ud3nwVbyKMyFNTEUKQsM/VlnJbP/U2i1TCYrEZzPWyGOzvmBjCOkNs1PKBOMAhn84tPvSTtYvL4LQlGy5fTDy0pRgZSOYKUC9za2d8j4vYVKLKdX1BZiEDUXoeAf6HNx35UAl42THkd+LOmzNWH5HIabJqfAngHJG9tU3RvL2juDdly424UJjr582xqz7ucN5OnZA1Gl9gubNe9BSMjoKkwGpmHh38urFvL6Uq+lIbdBw1m4Ayks5q5Hj4u/r9frsiOJMXVe9UPbI+aCz1JiTSYrcVaYNJz49UEUVtfa7WFFTm8s/hJrVgyw9xcbrIrdcL9Jf3vQ
 H7EoDd5C
 z2DSHApN6QWNTGFFm3UAq/Imxa48w2dyrSdjRKouMKkoh+DefdVCevrZE1DV5mnw1bvmsSQBesaLMFyCF2XY56wex1+p9Pe2njJex5a4Zc9o0kEF7GG/7Eh8Zy8jY8ro4FSdoVEwM2Es3dkbNXCcnpm/QGEt19dWsDNzQfE6+bmqlwngnpb2OU26RUcWd3GTSa0K7IaRhniOwuoME470NW6iJe09BZTexWTtvMqw8HZhzHuR5JVKku6rk1bYoiL9uNSx1a3Da2N5rTduOSxBM3Ucw7oN8qXwwt44x+P30puyz+cgZ6q/0ksfZfHrofyPiDJfB8/IbsOUcvUa6neICCP1jhEFIuW+MAHSHulBiOGLHuotrfMIINNrKucJO2BIEkIjrxsAQv9gb1vFsu4mmp6IQq6jiQK9rHjB5DENtLhdiPiYa6C2zg+sOoP9FPdbRTdO2og0qIFz2tljmLiIPBucvDRSUu1Ae2Gc+ErBy/8OM6fMYjxVToS2WtIeEtwoHTsrjai7Hgb9ncdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

On SoCs that carve out large firmware-owned reserved memory (GPU,
camera ISP, ...), kdump currently dumps those carveouts as part of
system RAM even though their contents are firmware state that is not
useful for kernel crash analysis.

ACPI systems already filter reserved memory out of the vmcore through
their existing path: firmware reports those carveouts as unusable in
the EFI memory map, they get MEMBLOCK_NOMAP set in memblock.memory
(is_usable_memory(), efi-init.c), and the ELF header builder has
always skipped nomap regions; only DT-based systems currently fail
to filter these regions, which is what this series addresses.

This series introduces a MEMBLOCK_NODUMP flag (suggested by Rob) in
memblock to filter reserved memory on DT-based architectures. A new
flag is needed because MEMBLOCK_NOMAP can only express regions without
a linear mapping, while MEMBLOCK_NODUMP can filter regions that are
linearly mapped. Reserved regions are marked MEMBLOCK_NODUMP by default
so kdump omits them; reusable CMA regions are different because their
pages are handed back to the buddy allocator and may carry crash-relevant
data.

Since the reserved memory regions are filtered out, the vmcore is
smaller in size and faster to produce.

The series is based on linux-next and is organized as follows:

Patches 1-3: Preparation and bugfixes: switch riscv crash_mem to
             memblock, fold the duplicated per-arch memblock walks
             into the weak defaults, and serialize crash header
             preparation against memory hotplug.
Patches 4-7: NODUMP infrastructure: switch crash_core to
             for_each_mem_region(), introduce the MEMBLOCK_NODUMP
             flag, add a dumpable flag to struct reserved_mem, and
             mark /reserved-memory entries with MEMBLOCK_NODUMP.
Patch 8:     Skip MEMBLOCK_NODUMP regions when building the vmcore
             ELF header.

v8 --> v9:
1. Patch 7: Avoid a potential boot panic on SH when NODUMP marking requires
   memblock resizing before it is allowed, found by Sashiko in [1]. SH supports
   neither CONFIG_KEXEC_FILE nor CONFIG_CRASH_HOTPLUG, so skip marking when
   both are disabled.

v6 --> v8 (v7 mainly tried to fix the initrd issue on release in v6,
that approach is superseded here):
1. Stop marking /memreserve/ regions with NODUMP. v6 marked
   /memreserve/ regions with NODUMP. But a bootloader may specify
   a /memreserve/ entry for memory that the kernel later frees
   (e.g. the initrd), and those pages would then be wrongly
   filtered out of the vmcore after being reused as normal memory.
   The v7 fix (clearing the flag in free_reserved_area()) caused
   a lockless runtime mutation of memblock.memory [2]. Better solutions
   exist but need extra preparation, so temporarily dropped the patch
   that introduced the problem to keep this series simple in v8.
2. Fix a build failure in patch 2 with both ARCH_KEEP_MEMBLOCK and
   MEMORY_HOTPLUG are unset. There the memblock arrays live in
   .init.data, and the weak defaults referencing them create section
   mismatches, which turn into build errors when SECTION_MISMATCH_WARN_ONLY
   is also unset.
3. RISCV recently gained crash hotplug support, so adapt its handler
   like x86 in patch 3: use __crash_prepare_headers() instead of
   crash_prepare_headers() to avoid self-deadlock.
4. Update the cover letter per review feedback: describe how ACPI
   systems filter reserved memory and why a new flag is needed
   instead of reusing NOMAP.

v6 --> v7:
1. Fix a stale MEMBLOCK_NODUMP flag issue [3]. Memory reserved and
   marked as NODUMP may later be freed (the initrd, for example),
   so the NODUMP flag must be cleared accordingly. Since the fix is
   part of the NODUMP infrastructure introduced by patch 5, it has
   been folded into that patch.
2. Drop the "generic" related description in the cover letter.
3. Collect the Acked-by and Reviewed-by tags received during the v6
   review (thanks to Baoquan, Mike, Rob and Marek). Patch 5 is the
   only one without a tag, as its Reviewed-by was dropped when the
   fix was folded in.
4. Drop patch 1 of v6, which has been merged separately.


v5 --> v6:
1. Serialize crash header preparation against memory hotplug to avoid
   out-of-bounds or use-after-free issues.
2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
   avoiding a panic from too few regions before resize is permitted.
3. Reordered the patches, put pre-existing bugfixes earlier in the series.

[1] https://sashiko.dev/#/patchset/20261016061549.4181390-1-chenwandun1@gmail.com?part=7
[2] https://lore.kernel.org/lkml/20260922090252.B01541F000FF@smtp.kernel.org/
[3] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org

v5: https://lore.kernel.org/lkml/20260806093519.2907771-1-chenwandun1@gmail.com/
v4: https://lore.kernel.org/lkml/20260630074715.4126796-1-chenwandun1@gmail.com/

Wandun Chen (8):
  riscv: build crash_mem ranges from memblock instead of resource tree
  crash_core: fold duplicated memblock arch hooks into the weak default
  crash_core: serialize crash header preparation against hotplug
  crash_core: replace for_each_mem_range() with for_each_mem_region()
  memblock: introduce MEMBLOCK_NODUMP flag
  of: reserved_mem: add dumpable flag to opt-in vmcore
  of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
  crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
    header

 arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
 arch/loongarch/kernel/machine_kexec_file.c | 27 -----------
 arch/riscv/Kconfig                         |  2 +-
 arch/riscv/kernel/crash.c                  |  2 +-
 arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
 arch/x86/kernel/crash.c                    |  2 +-
 drivers/of/fdt.c                           |  1 +
 drivers/of/of_private.h                    |  1 +
 drivers/of/of_reserved_mem.c               | 18 ++++++++
 include/linux/crash_core.h                 |  2 +
 include/linux/memblock.h                   |  9 ++++
 include/linux/of_reserved_mem.h            |  1 +
 kernel/crash_core.c                        | 53 +++++++++++++++++++++-
 kernel/dma/contiguous.c                    |  1 +
 mm/memblock.c                              | 16 +++++++
 15 files changed, 103 insertions(+), 94 deletions(-)

-- 
2.43.0


