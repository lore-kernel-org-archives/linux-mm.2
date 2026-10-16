Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2314BCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753856B0088; Fri, 16 Oct 2026 02:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704316B008A; Fri, 16 Oct 2026 02:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3A66B008C; Fri, 16 Oct 2026 02:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 327536B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:16:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27B05402A0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:09 +0000 (UTC)
X-FDA: 85327479258.02.D5AF6C2
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7276440005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kto9ols0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131367;
	b=JlyEB8UJvjaji0ziO2/0RxJNxsLcyIXFnQpYpiMv0DrmRU18GLZi6LjqsGOTn6aXPE5s9C
	2My7MtINKWS8Djfu9KhLn16CArgrGFyOMGyt7UKz1mFXdSNNUVQgd+Ohs0TAxhL/qKixLH
	G4FHPfXzIY1fk7FjEU3GRFn6wJWE9WQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kto9ols0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X/NJsqoDw9kAgUv61Xlf8FJQUfxWPDelOgkY9LP+DeM=;
	b=4FYGHtK51Cycos6BMwwz/Y+HmjV7E0IEIEHZDAkqPn2BLj4oEYeYdo+j38FTfWVtUIq2/o
	lZKEGV4st7eNm5z6FyN1gU/UXMa/NuzwMsT5644sGFPbEFSmgALJziUiDPqJBCEozEgOgx
	x2KMEVFXI48/inX2zOdKVPCTKfEfRbU=
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-cd5cd8e8104so622658a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131366; x=1792736166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=X/NJsqoDw9kAgUv61Xlf8FJQUfxWPDelOgkY9LP+DeM=;
        b=Kto9ols0rFGp8riamxYdY09AwSQDg7kMG2iM1RNzi+5Y9yWpKi+lAdQJv2Dm/HO1IN
         M4foZj22O/iyuYq+BC9AKlUWEsPOGfM1K70oNc6uuGnWQNtn7u4XHJT1Y0QBkvZh1L4i
         hXyt3w5qIeCe3jT7h1eFpXs0efs8TwTXUfs+QGN4MYW79JiLJcQA9xWvbK8PAN+LSkwm
         LWw2cB07veSnzcDovXzclXwSfaRqR1131HnpHLYFiV7XHeXIzkwDwY6ZHvf+gmY4KIif
         A0LxNjWjKeBygTBGS7MbYxZx3y5VWAgGC++79xcTlCgo2anA8MY+rmIeIRVjq6pBUNFJ
         8IFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131366; x=1792736166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X/NJsqoDw9kAgUv61Xlf8FJQUfxWPDelOgkY9LP+DeM=;
        b=oWCbcTjndVSdO+ijSkn7AVwW178stPkX+h0BHTv+XmNRLmUmFrGi8C41IBGV7k+oeb
         ZpFSIDQQGn9tOs4sqZBUmLWfM4jMlwfG+47cuWiomXz+Ygx2Ph0EQOP0GRLSg8weFq0V
         qFKrgnXbU1SIZjX8TKP8seUtrr7nj+rsBnDLZS538HUgDTt1RsUJR2kIjECzAct87BOi
         BFn5Knm0F36Qb2TE7yU1//NksqsE7mIsWrtYes/aaRfLAEvcfF2anUaN+VokHvmhfXjj
         uYqiBR06/rsgBoTD12i/HIbDW88Go7W/7WyYR29IKXvFahZsZTjCxFNv4UTigRzz7zdw
         ruNw==
X-Forwarded-Encrypted: i=1; AKwUvBwAw/Fq7z2hj/qSszGWTHOjS/VeRHKxsZ+j5JGZOHFBbj/S67NF3jB5qhHIpaJOaZ4jd7QA8wr0wg==@kvack.org
X-Gm-Message-State: AFq9FYL7osgERRcSdJYH+7g6YM/MGYsda+pnUctjFRdae29Nzw6aClZy
	Uu6Tgeh4ILygy2d7h1cyVSXnZT+RtiseKVTEHqegn7vq6bza5SaGWhKo
X-Gm-Gg: AYBFou06CbxnDy4/ETCFYVrLb+Bn7Spc1KmAy1k+3x4Dse5chlYEhzULJb3qFXMu1Np
	zgO7/3HwVx+Qqwy6cfDi/kqCZLSZTgO9sifz/h/+JvEmM1LPT0nagiPbZpPlJCUbcSU0/4Y1ZqB
	y4KGiSa2ONMlbPum5OayAydlNALjk+8B59QhF8jzjd4vao0Xk+W9G2bjp7mZmH2AuTq9DYA/f9L
	4z6XeDfMnKgMkasO2RFsbLxS749xRuCAbbIYko6LfCyoDFsuz3pecvKTg3MoaVNsX9RclAuThl6
	VbUg2z7PkgYRxb7i7dBDYVG/G8Zi02xG6j0tyXtfDYsqREgxtrjezraNCT27kvdpb0gBAjvT3A3
	ecpNVA3CENHoKM6YtPU2yZLcGn9o9lexHsLlETzQhNEQGK+oxyLBbBC6P1XgAB2aaMCp4NypDG5
	Vh5k2NCXMYuO2+QwNEXzSsnBHu2TE0zB25J1+s35hVBIZ57ASo5j811a5Nu3aTwJYWIHxWMs6T5
	RDYdvydybM=
X-Received: by 2002:a05:6a00:c494:b0:89c:d875:602a with SMTP id d2e1a72fcca58-89cd8756af1mr6506797b3a.11.1792131366058;
        Thu, 15 Oct 2026 23:16:06 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:16:05 -0700 (PDT)
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
Subject: [RESEND PATCH v8 0/8] kdump: reduce vmcore size and capture time
Date: Fri, 16 Oct 2026 14:15:41 +0800
Message-ID: <20261016061549.4181390-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7cef165nazm4qxzi598g3few6hs7b3mb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7276440005
X-HE-Tag: 1792131367-212719
X-HE-Meta: U2FsdGVkX1+0T9oR7mA5nX0VQv13+muJverEQNdWkmTOzs5u7umbMLXXLLtDNIkDI1Yelfor0h9IrHPtTp7a+4oKAcielE56Tx6uBn2z0GQv1T3iS3l6PDpGF/qE2taH5NCctcbWdnhLn4Op3V3WtHcELQK1DM259NKXrwyLSRu7z5AwSAhGDT726MTd+nca99vz4Y7jrodGRKZd5V0UBrX+Hef4D2RgEgr9EQPnr+OvwWoWTdfkhEIodUe8Zykvv5oZwK7xHZ+xVnpYHd+JR7lpeRZ0zw9gSvehX/epeXLFr+Gqf/ff0KLsz606VSXm8Qyi7ysG5PU2bLxTVAikZfWRfwIQzW1a+FLe2oewRcmc2Oe1DBcyOQNHHJR+W9IScBTrH2/e7gvoaa8L7Fmnpb/dE4jzzvijr/EOqthXUs3aMPSOb6Xd//0QRRK5lknsWErcm6uYZ6euEXszQm5y0amPSU6RW+zQ3GR6uG7iyBzV/geQL5Qz+TGZsGhHGugcIzZME/EO1tcdvOFmixXbPlAQV/n6RjHF1SsclLNJZ1CRSEM76LirI8iWCeGfrVNYHSvkuPhH2zJ1PuQFMTcWgBSg2Coz/xPTsG2OGA5dB/LZ6pe9c8ZWfCzdJxsJYGEag7SciFeYbmGmxVspxOw8Evz7seE665SrUcnJFSvWaj9yAJhfBkofPhdQE/LKKpaZ+2VjcMklt1oa299o18FQcUSflnqgsWq8zrjlTWrRnU4X/rEJ8yCVpb5i9Gk9uySNE/eN2Q1R8Vmrm47tZz22yi4ik3C6BS5EsKs6H5g3M0Jj/IWN8HoAkGYiR5T1w/RAHislFaYfr3kiu+V1L6KMonwBXK36MHvjq0b212Xvj2P/cITcG3VAC4m01bj1A5qOb2Y9inEAOd0VxJvYivY36dpZza9lvNYjEaVPBqX4pZQRmOpvIPA9pd++fpW8LYPy52s/nT73DpZ54KHMt6P
 dZoOmIak
 MeaFfeMOZU/Sqhoec6vBmua/ou0jlz2vuRXBPFj3p3ZIiR6CJA3vFs5y22R867KLG3LZYJEo/NxiTsuR0QwX/W5NT2XyFKBnniCJTBxOuvET/c/4kxO2erppsxW5C9XuQLJEVpHRrXIEtDo5O8uuNU4RJeyhbUVtAJzXTRVni5HfKcSJDDn9tWl+NMsyBSbwi2XbnZXLkSXyl7uWIOiEPkPvGpWd8F6CvpZwpNzKggW+hAbV7GQFQY/t9E1jzsgikwfqIWDe0xZ3aCDwlSbmOTGkoca5MojG/gU8GpB+wUh4ubu36YF1eJEeue4zibShxPFAxIZEkNuaDxwQml+xUaTBzuxQasZCzoo88hcyO4Ksb1xGnU5kNwsIi0FEiSpa1tbbrcn2bNNVouli0bB5SYpr+uMsVIZ//aVwMztZzxkkJHwlxPXjtjkbN/jZkGuARpbQ1kyBZwwJWUdGYttyOnROQaxxc44OJhduUpGxuWoRQ9DeNNtSX2+R8EAnwAtRxvh4OBDkWGut1Eeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

v6 --> v8 (v7 mainly tried to fix the initrd issue on release in v6,
that approach is superseded here):

1. Stop marking /memreserve/ regions with NODUMP. v6 marked
   /memreserve/ regions with NODUMP. But a bootloader may specify
   a /memreserve/ entry for memory that the kernel later frees
   (e.g. the initrd), and those pages would then be wrongly
   filtered out of the vmcore after being reused as normal memory.
   The v7 fix (clearing the flag in free_reserved_area()) caused
   a lockless runtime mutation of memblock.memory [1]. Better solutions
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

Every patch in this series now carries an Acked-by or Reviewed-by tag.
Patches 2 and 3 have changed since v6, but the changes (a build fix and
a riscv hotplug adaptation) do not alter the logic the tags were given
for, so their tags are kept. If any tag should not be carried, please
let me know and I will drop it.


v6 --> v7:
1. Fix a stale MEMBLOCK_NODUMP flag issue [2]. Memory reserved and
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

[1] https://lore.kernel.org/lkml/20260922090252.B01541F000FF@smtp.kernel.org/
[2] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org

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
 drivers/of/of_reserved_mem.c               | 15 ++++++
 include/linux/crash_core.h                 |  2 +
 include/linux/memblock.h                   |  9 ++++
 include/linux/of_reserved_mem.h            |  1 +
 kernel/crash_core.c                        | 53 +++++++++++++++++++++-
 kernel/dma/contiguous.c                    |  1 +
 mm/memblock.c                              | 16 +++++++
 15 files changed, 100 insertions(+), 94 deletions(-)

-- 
2.43.0


