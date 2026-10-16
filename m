Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C090CCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620FF6B0088; Thu, 15 Oct 2026 23:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F89B6B008A; Thu, 15 Oct 2026 23:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DB06B008C; Thu, 15 Oct 2026 23:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20E276B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:09:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF38AA0223
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:15 +0000 (UTC)
X-FDA: 85327008270.23.EA8DE59
Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	by imf19.hostedemail.com (Postfix) with ESMTP id F35F21A0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mh/KNTct";
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120154;
	b=aX1ex0Wf3hrDkJUCzP48VirHogqxMyUjtMzzoKaUqOF4KTdVjbQvYhRJZrKFxLBo0d6kbt
	U/UjzD8q+S+6Cx1UCCxVVtHVR0zhppmZMMtrIrRpbm3qki6heC8kG8kM3Ps8L6PxToQHa8
	MlSFwQ3zNqtnT0cFmtAVDV4TiTr3nMo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mh/KNTct";
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ed5L209SneTzZcWvCiPDVyFxWV1jqEY6cKUsalB6bvY=;
	b=SHy+iK5F/lMDNogm8QJbcC9vjCtLd9XrqyCA/JcLGsL7msqLTj6Fwy+i+s7AWKFBioQb2T
	1nrysJAgfQoHXYnvRVrKgRELf2XedVI3+To26R8z6bT/W08WdFs7fjyxg718jVydTHyc6s
	rIzwi9PG5CF0KejspJ3aqkEja22rwQM=
Received: by mail-pj2-f6.google.com with SMTP id 98e67ed59e1d1-3acc610014eso196355a91.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120153; x=1792724953; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ed5L209SneTzZcWvCiPDVyFxWV1jqEY6cKUsalB6bvY=;
        b=mh/KNTctsemrRTCBfSchr5x0oW+Z+cYrY7TrAUBMHk0yYIlqQFdL1gP5PjMMhMaMN+
         iTD9YiKcKLm+VCO4dEt2VlpcRzZG/nY5Il3nSBTlrDAGNq8/H0gi5bTASo0cKrDrcNn1
         JIaXab69uE3BtwfN5Q3HHynWPGyLLlXSkpXmXMj4E+cST8+763yLI3y2hwxlkdivQo0z
         CUPtf6Jw/YmYlV350a6i3RTPbzeWDdm1iCgs6Ly+QU5J136j8kgilOzY5h6bYNwaLNEN
         q7EbW2NsgxaDgivch1BEr1hMtnsvHfbfV1BG9bpNVZrHT8Vccn5wtH4pIWb9UlOtoU/s
         UUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120153; x=1792724953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ed5L209SneTzZcWvCiPDVyFxWV1jqEY6cKUsalB6bvY=;
        b=GvgAmYWVfBLN2I37I9fX+pZClzyRDz7PUaBuACAoWSdG3wKwEU//u8/13GTjcrSjcd
         RoD0jzA/Ow6pKl7WP08/gJwKROopMYzeyQko/71hr5YOd9132LQJqCwN2xu/hOJ7J6kw
         iprLmYU2MJOQlItdkS0JAluEAQ1XUXJyPt+NSfQ+wgMniE9iM6n5Zf+WJfa0+USnMY7c
         ZPP9LFZnQDowk+9VdFiViQJgnbQHLW3PBjDsTADdcs2f9cWscXbGXFquu2OGc/k+NoYc
         fSIJOS/A1W64jqLVLpWvSIA9iaFj3Pj3up/nQuHFs1VAHHOPJXr2ODcmDHsw8e+zzE5z
         ZJ+w==
X-Forwarded-Encrypted: i=1; AKwUvBxMOc/+H6zYWFVARaNibw0ze2ZQKpDwqRmuiMtNP/uboQTLCkukL0PBcfvYQauKspfIq9tc/OVqiA==@kvack.org
X-Gm-Message-State: AFq9FYJZDXKPOCfYCMnu/hjGV1QbKuweYGDaJarCwN2D0wulGujPBMG9
	cWGW/6MGQbpt08S/pDAC4CcpEfd9g+pMT2BkE3tPrZXCgPGNsf592Zh1
X-Gm-Gg: AYBFou1mRKHiBa9JNC3eREfTSYnt3qDIkBR4WG7sckduXHeLjWpFOLfFhKTBwADekOV
	cK+b1S1L2Z3BGRSVTXayiBuZwXjuXcQnZyuVOZt693xLQsM1LEDE1zm4gzV6/tPvw6PvI9wA7s0
	GpKoXHFelaurxdyDbrmVoWC5rr2oe6zkbGcsCX1GOETFIuvJyP5WC33dnRikzx2QBEoedbcDS0z
	Ok/yYTvKdzW6j4t9+t6japhPTjlFbNbnOk2hU7IWzUBKNE8yDvSSrh4bRfrGhXp18Ha5wzfKX8b
	T8S3v7GP05TefjeHKePb0NGWz+DmHc3inQdXNw9fYQwJsgx/dS8tJrqF+gLWxMJ1TppB0wwRkeu
	DHUQ7hpBlvawhSmAFJICLvqpytuWrCvUAi02kc5Xq/hk1igMeegp4EktpD7TwSuUQlPJvtC4sJV
	CDryzF37xuUHODO600bKEmDCLG1Q8IyhBdstR1sRyZLVMBW5MxeyqVuHA2QtYYc83g+q6go1nhi
	hm2q9JVS18XNMW1iRaxiA==
X-Received: by 2002:a17:90a:d44d:b0:3a4:b0f3:6597 with SMTP id 98e67ed59e1d1-3ab39fea5c6mr19481452a91.0.1792120152572;
        Thu, 15 Oct 2026 20:09:12 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm370085a91.4.2026.10.15.20.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:09:11 -0700 (PDT)
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
Subject: [PATCH v8 0/8] kdump: reduce vmcore size and capture time
Date: Fri, 16 Oct 2026 11:08:47 +0800
Message-ID: <20261016030855.4062882-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nd4m5fjddc485se8msuuc46hcs5ib979
X-Rspamd-Queue-Id: F35F21A0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792120153-378710
X-HE-Meta: U2FsdGVkX18ola0FwZh/h+LzG0g+xP9rkwf3b7op4Aeo5Q+oGqsk5ahswUWZJVJrtaOb9dr0Q+a1BPCZl+gTYYJseI3toL1VKyYoSAxwG1HEVA3QWSSUgrDA+zCIQdPLohF8KG8sW0aYl56b0ZSNixfAtbilePqbsJZ0qUt45RNV9hoQX0z1k+c+cbqSSdNQgRuQ9lBF8I6WWLR+gltz8m7NzuJ/CgGlF4CiaWPbBMF/osKd/Db4vRlt0IM3vnj1HaJtPtzJs1D1B7X8oYXh8v9LsIj/wStnHlPQFe1xhqmAADNKT6zWyyIgjploBTYyzwNwMi5IfYu1VjBHWA6SRLjg7jSPrrtQgbxiP01c2x23iwn1mo+bHaNIUjx2ABxPpMk9L9MLjcpgFEok+VW8agNyjirU/nrqQiIVQ14t7H2cOjaKb/Wo2XThC5GCSxpU6i5e0Q+YfLuPa6bQ2ov+iNJYt7fhbtGJgFbmPH6SR6CWmCKriU9OzPSNTt3pMlMEvwVdTNAUJc1bIZzSrVuYQSYkxqf5tPkexDyBedd5HgyLLDpVxA7wcC0OsqC41PnYpzEFxjkYFVRWQrump0XGpdeK+LowslvI/QDgBuUKAuaeLZl5YPNaGWBYI3WRzvg2CwFakLC2jh06gaJECbzbubM0/QVqcdTPGw1YOiv6EPm2OyjckJ2oURlxT0HTARbt1iCHuCmuxxr1DU9LQ1DGachVM6hfvdxS4KjHLnOUyeTw/jsLjGb4QGwaYoToz4exR4R1nNNkkbaFfebPzaek7NtEE2YZAp44doJhFP2/0oj7CIOlZ0fEMf7EZNhe8CXvhZ7sJGgHMNPHbspnzCSF8XC7GZplOz6kaAEBWEzyWoWeTFkPxo14W6+qN+Cvyswkho+EgSqOj14uuJMgtPWZ5CDGeC0d4HiTvcMoPmlXKawp0AS/f22Wouqu/5QeKD9jG71/HqZhVpKf3HPAdd7
 orYUbhEq
 38RfhDkTZJ/cKztRJjeYrAWU3rgyc4YsG+axDDlb3r/ksUumDq7NCCY48SsJyG3rWAtpaPvqv4ln9LQfLmaxPgyGfSTX/cGAnsa0Qr2ap2sn15hfHE4Jx78nJ1ZHSMRUxi8CjdK1UJNWKLpx0So2ZAutrv1LNvD/+XnRhdKpLqK4fkH/PJ3fhhrUEDOTo0OG3XwCgsyTz8KPnS/MJdcyA3F9KtBb+APJP+xoK8RMZKg7KHCTMWzcwReKlmJoign1md3HUxpztlVrSH5O+nCwnlczuvB193MVOMrnqJ3zlvcqQHZ9RUZRtJeFAhIqsschaesJ+h1UqVDKUVjQagJSyQ4z/AhL7rd7dTdgK2M8SxQG/S6xnFffChbvezltmZI5oIPONNMQl9B++JU6W6bCy+uyxnkP0x/uJCiT4l+eNAT5X42wWzrO8mW429dVc5oYUeCjK9YQAnb073vzqLsKTbzDl4De05lNoFkT0RyCQnu8V+NsxAV/H/KA2+V2gBtVEvz0JXJ4lV4KkVXA=
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
   exist but need extra preparation, so they are left out to keep
   this series simple in v8.

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


