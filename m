Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 888FCC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269466B00A2; Thu,  6 Aug 2026 05:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FC36B00A3; Thu,  6 Aug 2026 05:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156606B00A5; Thu,  6 Aug 2026 05:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF85E6B00A2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:35:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63D3D40684
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:35:39 +0000 (UTC)
X-FDA: 85070337198.29.45280FE
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id A72B9180008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:35:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mYFI4cZN;
	spf=pass (imf24.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786008937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iAi2qaVA1OaGq4fUWHi+grRNkf4AM4PgvPmY0Rr+XE4=;
	b=gRy6JHrjaJTGCSi6zuzkm0hEKl9Q9wIQ63NmNHvUiKETrYh9YTTZlus3EWbPWLNS21WPR0
	VKF7o7QH7hhaxhtrOUIE9k4vrNYnH0nCOFEg6hKrc4hHX7WaczA+w+t8oQFZTdGcZbo8GO
	/pgc2guKyD5ByPAtOoEvb3Kt7ncDFm0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mYFI4cZN;
	spf=pass (imf24.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786008937;
	b=I39vIvNgTVMw8iEoV1GDl3mOHDW2lB8F385liihpjdkOq5GRjpk+pUyp+XBz0mg1Mvqwb8
	8if99R2AdqwWeoI69cwBmUU1vZGid13xwED3BmzJD4qkhrI9QT9ANb/pXVbOse1/mwGw+1
	zW0rme+5Pxu0HMY6doBTlb6CX6yn1IY=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-caf5fee4196so744127a12.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786008936; x=1786613736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iAi2qaVA1OaGq4fUWHi+grRNkf4AM4PgvPmY0Rr+XE4=;
        b=mYFI4cZN6J8VmSAjR3JRM4rPRPhnGtDiomvBSX674EDxD14CDmsPKyfDOfcpTgd1Lc
         Evn7UKncHD04ssFHK0qUd3MUvltw4xJOdAuWTlVXP6EdDvturxp1Rzbi5mHrG11uVMqk
         FfCGGyV1kNmgTPZsYLxYL7ITMIcBQ38RB2oiLvHxUFGGBSuUdHo5MyeH0i1cpt5cmBv+
         M2ESJ7u1EWRpF9R2rnGdCaaJdg56J5SklPHd+VsKSLXSp1Dld+UtS2AmHDd6Q1ohcq5I
         HdkxMqWOnH/svEnEaW9e/Zhsw8bW9Dp2FYTy7mIu5KbAHY9LBbbup972vmeOPjOSRvMi
         8YaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008936; x=1786613736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iAi2qaVA1OaGq4fUWHi+grRNkf4AM4PgvPmY0Rr+XE4=;
        b=dH69DeJ2VxKBgy8FlOs1/AoL4lEXebvgi5tkVTO/8jO0Oz2H/zAxVZfoLCAJ091ir4
         5s8iAiNc8PmOPPmICMp8/gTSnj82+xDUoKjj0hyFbEqFzpAp1p6+xI+5xJjKXPNWlP0j
         kX/T2rtIZ/zWQym0xOqSGumG3WA0psfh+QNT0wORo4fMN3QfVhzU9571Ql9NGA3YD67g
         gDg6VUalnov/HezsTMK2RpzvtmDZ8nwWnYQsGp0IBcCfAd9A+2sIRnaL/jEAwlEU3h4K
         kmCd0cF9HyhNXfNl7C3DYt8B/fejoBwG1JHwG3QfJbA3+oRktq9Jop+F7acQxB6h/5HI
         ytrw==
X-Forwarded-Encrypted: i=1; AHgh+Ron2DXcHUzvP6rTNWnfElJwU4W0u/HpOo78yh7ov2KBIYAZGmA8/+LOaFGk88LE9mtfnrFKH7f0eg==@kvack.org
X-Gm-Message-State: AOJu0YwZroQJgPyobBtu3M5o83bg6ZywxF3JFZBIg+N/dNFjp1wveQLd
	j355X2gKXmteEKx3WkkyRUo9YCBBQiR7OkL5dtng30H3ZrKQgzlGE9AS
X-Gm-Gg: AR+sD11VmRJhEtBoFV8vWanOTMbOzVXWBKzIi1KVAi23JkvifFfcCvQgfQBod/alMTy
	Vf3ILKwrqcKxJ6yMQ/h/xT/2jHnJEqgHQU9UJv6u0UGYQsDyetgZapIUQXJJjwv+peb5DiKkS7k
	o6BRD7A0Bu4/JFJ9g8TVkcvnedaha7ICFrBlABeaeBbK3ViDugqYkqJ0kainhLEHvP+6B6M9Fql
	jWHUTp69C+yFwP7v4HDme0nD34/rYHk52Pf7BDBl7UELY9VZVlzBpNiB6XuJmh1hdDLaEfrLv0d
	FV+YWphLTsZpmp1XpG2JgfhlZRviIqeS0xS+PRhIY+nizczKNspgELzLYpn4iD8nYmk9DtoQuJA
	1oLHFnU9LpGp1Q9k5Cg9cJAwtpX6G6J7zNEh3ZoiZG9SGZI/5jTHH9t0PvhpKWHQT4ziN3YtD9a
	u7xli0b844dbOv/+K9KQf/CzNQ3/PrzE5aLClPjUxd+m9Zh/dT8mpRrAe+C7oUq75csUK1zw1/B
	Q==
X-Received: by 2002:a05:6a00:9515:b0:84c:1cd2:142e with SMTP id d2e1a72fcca58-84f4fe9e75cmr58122b3a.23.1786008936445;
        Thu, 06 Aug 2026 02:35:36 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:35:35 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 0/8] kdump: reduce vmcore size and capture time
Date: Thu,  6 Aug 2026 17:35:11 +0800
Message-ID: <20260806093519.2907771-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A72B9180008
X-Stat-Signature: 8ifa7mj4br9mjzgfqsr997em57gsrgoq
X-HE-Tag: 1786008937-391523
X-HE-Meta: U2FsdGVkX1+dEVvgr+qilfgclf4jpajanfrbCoA+sLtoImAwOKA7odQpX7O8fVmJs3ZksWwp7ga7/KtwCyKwUsaaZTl2r8PLHcCN7tfC8rtL9CjxbJPlCAk1B72oiriUKeWoG1CTJ8eHfogalu767dfj/IbSW5m56ZZZIyq50MSCdYX+qe63fqPuT4PVVr7pp4iSuGjCNwj8YvryXneEPUIqfM1IlCvKiEG0xJu3Xb9s23gxGpcQX19s8zfwCjIbfSPxwPAHF+84EoRyCD73ERKaW8psjMRg2Jotu3DlZLwpyhpgFyG87L/sApe2VSqIbcFUTwxp+5qjBvllzCPpocvl6v2xzVwdUbkGfpeTE7yyWpZZY7n75SoEgAH0BcdFCjRmBK+U2CtYYVqwHiJ2HLe8ydRVcoghuztrtsCyH+CmqbBeSe1ZkFlC6ONSqdFPDBZJpRhMXqr60Fk/OXYMsUQJ5DvlSXzoHvnKKr8q9kN2ewZg423BKeGD90do2VYi25jZ/2UwhF0oiyCL9dT4pxejuRr3Zp3wm2yF3moHOBiwDZEnwpkYeDVeF7zzpCHKzaySzFoY6bOXE9k5l2tCXcbs23jj6OheVpnm1I79moYV9FPq1FqGY36NTQS8ElsSpsLqBRNijTe9quFuBQJs0IW6gArG+gT8l28Y0+Mgq5WRMv5v2twCKfTpKDM3E9EYb1rKC3uy1bqcj7fZpUlQf9Bs6A/DRjbEki2TBQM27UeOxmjaehoHMaWz0oRcV7EpYWg4xJRo8m1rKMY2AjoN8PKjp9dGO7gDWI9RlLYGZz06rc8xWaXdx60YAc4+cJ21D0+Frfk8lKXdC4DLOm47rIs4g0VHfI6SWK5ZOmUOF0OVtmmt3pO0VemsfLHA/zHrJVgrOUeahM0cN0M8vuAVe7VHyEBUAjyLOazfCdvCntKJnZqcGA2ITTl3djJpHslZ53l6v3feDnfG2oAibya
 mKk8TUeB
 Q/zm8+9U/InRHRY4VWU2+W4B7qauP+K7//U+ddIFfVHa2oyV0P6XIunZ5W/O0DbHbZOykpLyksHihBKLOkgvcNo9/mF94wSzCQeojWtFuEK9fXoz0wu136wGo57AwS97kw1o5XrV6RZhNYxoLzKW015bxBVMrTaPonVVG9vu1E5Ay8z9XNPS0pncv98iMD/f6+c5v4hg+4LMsLXO4OCy3yoHap7cD07kkXXl8ivJ3ofpXkYa7zrcX3zD1R8jhOpmfxcSX2Xt3oRvJ3eIV283XY3CQvwsUD6wCf23g4bb4imxL89nIxZIstriGds7fllXc6BuxrGCne8fVT12OPrJ9lAK/k/DWf+lDBD7Nas+n9u3U6aqjvAagJBuayABCzA779cbYqtnJ+XVRQUcylsBEI5eSAnx9yrI6m2EDZmdVNO/9z0BS8tKala5ncjnnMQmtqA+cu3XTV+EukVwy3wYWBEJRi5biP83l9TgmBf5MZCDLhFb3l1eVpJvk3Fxc0Ex7/k7ACpnMaUmNT2TI0+mD763f5g==
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

This series introduces a 'dumpable' flag on struct reserved_mem and a
MEMBLOCK_NODUMP flag in memblock to filter vmcore ELF header on DT-based
architectures (arm64, riscv, loongarch). Reserved regions default to
non-dumpable and are marked MEMBLOCK_NODUMP so kdump omits them;
reusable CMA regions are explicitly marked dumpable in rmem_cma_setup()
because their pages are handed back to the buddy allocator and may carry
crash-relevant data.

Since the reserved memory regions are filtered out, the vmcore is
smaller in size and faster to produce. ACPI systems already filter
reserved memory out of the vmcore through their existing path; only
DT-based systems currently fail to filter these regions, which is what
this series addresses. The flag lives in memblock itself rather than
in a DT-only structure, so the mechanism is generic and both ACPI and
DT systems can benefit from it (suggested by Rob, thanks).

The series is based on linux-next and is organized as follows:
  Patches 1-2: Introduce MEMBLOCK_NODUMP in memblock and the dumpable
               flag on struct reserved_mem.
  Patches 3-4: Mark non-dumpable /reserved-memory and /memreserve/
               entries with MEMBLOCK_NODUMP.
  Patch 5:     Switch riscv to memblock so the NODUMP flag is visible
               to the vmcore ELF header builder; add (KEXEC_FILE &&
               CRASH_DUMP) to riscv's ARCH_KEEP_MEMBLOCK condition.
  Patches 6-8: Fold the duplicated per-arch memblock walks into the
               weak defaults in crash_core, switch to
               for_each_mem_region(), and exclude MEMBLOCK_NODUMP
               regions from the vmcore ELF header.

v4 --> v5:
1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
   (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
   DT-only struct reserved_mem.

2. Switch the riscv vmcore elf header preparation to use memblock
   instead of the resource tree, aligning it with arm64 and loongarch,
   so riscv also can exclude reserved memory from vmcore.

3. Deduplicate the vmcore elf header preparation: arm64, riscv and
   loongarch open-coded the same logic, so fold it into shared
    __weak defaults in crash_core.

4.  Drop the v4 patch that saved /memreserve/ entries into the
    reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
    directly.

v3 --> v4:
1. Rebase this series on v7.2-rc1.
2. Add two cleanup patches (patch 02/03).
3. Simplify patch 03 to avoid checking whether initial_boot_params is
   NULL multiple times, suggested by Rob.

v2 --> v3:
1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.[2]
2. Fix UAF issue when alloc_reserved_mem_array() fails.
3. Add some prepare patches.

v1 --> v2:
1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
   feedback [1], v2 drop that property and exclude reserve memory
   by default.
2. Split some prepared patches from the original patches.
3. Address coding-style comments on patch 5 from Rob.

[1] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
[2] https://sashiko.dev/#/patchset/20260520091844.592753-1-chenwandun%40lixiang.com?part=4

Wandun Chen (8):
  memblock: introduce MEMBLOCK_NODUMP flag
  of: reserved_mem: add dumpable flag to opt-in vmcore
  of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
  of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
  riscv: build crash_mem ranges from memblock instead of resource tree
  crash_core: fold duplicated memblock arch hooks into the weak default
  crash_core: replace for_each_mem_range() with for_each_mem_region()
  crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
    header

 arch/arm64/kernel/machine_kexec_file.c     | 29 ------------------
 arch/loongarch/kernel/machine_kexec_file.c | 27 -----------------
 arch/riscv/Kconfig                         |  2 +-
 arch/riscv/kernel/machine_kexec_file.c     | 33 --------------------
 drivers/of/fdt.c                           |  2 ++
 drivers/of/of_private.h                    |  1 +
 drivers/of/of_reserved_mem.c               | 35 ++++++++++++++++++++++
 include/linux/memblock.h                   |  9 ++++++
 include/linux/of_reserved_mem.h            |  1 +
 kernel/crash_core.c                        | 34 +++++++++++++++++++--
 kernel/dma/contiguous.c                    |  1 +
 mm/memblock.c                              | 16 ++++++++++
 12 files changed, 98 insertions(+), 92 deletions(-)

-- 
2.43.0


