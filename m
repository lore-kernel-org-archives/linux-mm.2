Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97BB6C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1226B00A1; Tue, 22 Sep 2026 04:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681166B00A2; Tue, 22 Sep 2026 04:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548BA6B00A4; Tue, 22 Sep 2026 04:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1746B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:43:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACC9780401
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:14 +0000 (UTC)
X-FDA: 85240758708.23.F748CC7
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf07.hostedemail.com (Postfix) with ESMTP id 01AD540008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZwMecO/g";
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9UsbLRFUse88WvBnvQ2Q7a6jE7KnWiu4inPojM0/Ln8=;
	b=AaBSDMCGjy33mrWLsdPWcwsb72crElxIYaMoVsswOJPC6GGWB1hvCWmJSgKCRYa2PVLFKi
	qKwjOUadOnjwn7elpe/t/MpCS8520tQnNqsJAFGQxFYMHN/+8FIjyjKkPfUQiLKN1KkjEZ
	3tGsaC83B5HehN7s6PW/ZIHzX8YS80g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066593;
	b=nC1/y6Lr2Jpn43GKvh52nwrO58ctGEfYhemoDFVpQbIMKzayTp1V9vIDUlADv/pf6qcmR6
	v01u/CEsbC73vJlgjoWggJiOiN7eOcUmoBOLi6Foes/vXWoxJEFTeNSe9O+1ztAvDy38/J
	MJygwVtcswpVYx0iSVJewQp/R5qT6IA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZwMecO/g";
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-39e59dca659so2355029a91.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066592; x=1790671392; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9UsbLRFUse88WvBnvQ2Q7a6jE7KnWiu4inPojM0/Ln8=;
        b=ZwMecO/g9vrcS3nvMUUxnvlmAPsOvHzQdnAUVPgRrE+s9qTbcW9SGQyn1jjTjwujsU
         6+6SFfxirHt8NcFnKlnrtjwKTLZnVAA80MK4zgBHYbAZyaGnM2cbXn8OSxrr9xXEue9X
         H6tmO+fAUaNlwnXirU951t4wXPGmLTvEDm54tmWfo7y9CK3QZRPl9JNffyLO1BXH60Kp
         ILKaXjDMSxgo8kCpDA+46pPg+eCnKfZqI82/gdPY8f2AbqTO2WYaGZZWO3NfgZN76/kW
         OV5gx/nlFrtQ5dk160mX01v+0gBxCoekMsjOtClVVL57Rit2YrPYaZtV4Mqw/ndTBvWs
         zIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066592; x=1790671392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9UsbLRFUse88WvBnvQ2Q7a6jE7KnWiu4inPojM0/Ln8=;
        b=eKGL54oVB6zRcgbITuTHNKjgwjgDtUjyCFnSQibrR+xVWhtXl9IjfXe02Lkf4jJAFc
         jGdklQ/ZZO1HCosOq2DcUMOSxsPy996uz6GFs6dqBHOXUpFpasz+SLIqeHHynvkN7CMG
         VOGNw8KrUjgHpQ5qsOhEk4hZCprdSnZeM9jJP5Wkl1TJb3piw4n+Wf4bA3XMmSOjlt7O
         9uCCIpNzcPpDfInrluOzCbxmYY/tp8I9nOSqwpyCyhhHom2GQ30uz25CU6cOhqfwoagp
         +8CU8gQBOoJxvbsArXF2+3EYe/RgXeripG1gNi7mv5mcTgrmNz3IACnH3Tq5nzv5wktv
         wqyw==
X-Forwarded-Encrypted: i=1; AKwUvBzTN4H4dYTOZP7UdwbiSbH0PYD60biH9WBnhrVnwxVGrnbmBh8wybbtftYkzx5m1CfaJwI/sKeNaQ==@kvack.org
X-Gm-Message-State: AFuF++kePPwvUd+5JhU7o+opxnoSKuFFdlJZHzwO4dA4Un8nvgFIhbIo
	xh8mRriMOry9d5RR4DH1c5aQ/9HtvbA2bE5X8jVruq0aTRX8LhlluHvS
X-Gm-Gg: AYBFou1cKoEBivF+Eqr0Z50d18WwSLKn+ss24eNf3o79Gt8MMpoSX4PMmJnSzwP82jO
	QfKntj2VAuxxMfyLVPKUvqicgfhbrFSmyNQtyNr/kW5KGObRHIoHREDaCRoL0bQRvr5b8t0t9PO
	pJ3e2hrHxHWpCLJRTksViqVabfbksUPlcD2p/SsgbLKecMsOrfR8JTNVfTW+1gKSSUHAOdDj9jn
	4GDKATHWnui00grI2D7EF3FSaARm+4tedBRVkkvRQReWTmTvvpp4MHCVNzRL0SGxcUre1Y+MT9T
	NI79pZM1R+qIiEraDR/MUBndVOwI84q020X2O1h2um3EwWmt6XTbZrVBfptdUpEM1TNoqx6aKmW
	mQ7eH94miAHrig+vNCPVJtIuSF6vjCA8tfbyKnTor50HG6slS7PzeUNwyRxCJbM15XLOL+xkUeR
	Ht83oCGC6SCVaN8Pa0YuA93MXoHYHULmPS2zaGSPL31wz19i/rbS2h3ZZjERUU3Pb6gKTp9R3r6
	6dSmIkYutjGxnQpIZt92Q==
X-Received: by 2002:a17:90b:4cca:b0:39e:423:bb8f with SMTP id 98e67ed59e1d1-3a0730988bdmr477897a91.1.1790066591638;
        Tue, 22 Sep 2026 01:43:11 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:43:10 -0700 (PDT)
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
Subject: [PATCH v7 0/9] kdump: reduce vmcore size and capture time
Date: Tue, 22 Sep 2026 16:42:47 +0800
Message-ID: <20260922084256.1515554-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: me9xyo86xg8dcmcyftr3k46bfib7rti9
X-Rspam-User: 
X-Rspamd-Queue-Id: 01AD540008
X-Rspamd-Server: rspam03
X-HE-Tag: 1790066592-713157
X-HE-Meta: U2FsdGVkX1/uO/fbOQqzBA/emPh+3KxETg93hPvAxheZrmy+Rv+oIWKpKISkzUn/c8dwjUn3+jBGY7q6PUsRC2qcWsLPaFTXAwMXBjHxiPRHJwdQxYE6RYdcvP9Z8aFDibPN1lESKRye96kTXYCknYFCIk4DWraHwS3NHSI/MtwH+/4zeJAkcTCamEIobVra6iJyuduf09SBpbROgR+j4rxyU8ERMLk1BcRx3H98ynMdPw8ZDp90AQt+jw0aHsK+vX4v0APO0H3YKsEob70U8PFMRx1HjbI9CKyTZU/VuCHkKbWFUz7D1U+WBJ/hT/M8VVMxO2r+nRlzk3fMcVe6gVnrXwnrbX6qM0oNyFdyF0c0CVthjmg0U4ksOgcKpvENzL0aw59sDke6AYdVGFd6Kgqrvvt1yKkwSvApX6vtG/vCjV7uAB18JYqGtPW1g+cGJ+UiuZdb2eu6OyQlE2AsvnNeNmGGHSWlejqwV0RevWVGBRs7F7ep9LJdGIyqoMuxnETD7sQhwhOSbMELcHkFG/71tcNuDFRaCvUBnK/qX70pA2WSjm97Ce2+oXogYEe4o3haNSI6rMa2F095US9Zoqv9wkoCI4wNH1RGJdmmm1n8/q4QO9eyQVJ3/jSQJgex8KXUcs5ggEt4uJOF/dRv3S5VE4osG6r7NCHJCHXB1AhFHP73sA7BVkkcQMRDEAMguWRemi+8bWbgoG2cYAxk9aYFdgryHhz4/QCYrp4LN/WwcydhonGSyMG0a9wRlkv+vNHoY9jiN1PQ46ewlt1S9kiFq8bIUuuK7UGujqQ+mlBviQk6O2owBEYzlS4hBQHxyzITziGdpv9nuOH8vz1xdr7XijaPPxlQlOpX8+IRdJnIqUq4+zJTzXsXS/oL7xbZ48tMUPTkiB4TIISk/JVBljxATvmvG2frvOJNJNHgj8ssti08PYoB7Wa0vvFj1ccRbW4jhKuqrBQFuzwnoyL
 GDWJpyvr
 WdBsGqI8HZWis4k0be0S/dIFXG0YfRkANlHqHC/gEvwbBDAjAOvoLi/eyy2x9pdNkfWoopeT5XeLxQM4mKUFg637tGDzac7bkm2/CyfdMMN4daIN2IwmU0DFwfzFJeKt1n+igsqxxtKpB3Bzk38scBeIzNwWmV1R1NUy3EUVK5eFo4CLMz+u2r/N2YtnTaw6nZhXMPhbGVJbbFLg8+MwDyOqRTSfn2m2W+Cz304iL9j6jMw6oEfIJnDbRepQXxw6JQhHHFLyRevwg+s0KIENStmM7wyTOvKmcnB/PBIsf4kmCT6ifStWzOxdle8spw39gTKFvDJLAVvxtNIaZzTRhbq5WxYoC+AaNHLiEtflO5/IoRLp0wW5IALv3iEau/FnFQEFUILrtXe6N4NHhZB9UWa4P0ozes/D5ib/izHYvzDhXs8BG+MC1IUiq10VuXp0LnDz5m2tkt2eHw++K3T7kKEoGD07+vU/OrzIp3TTIiCxwMdgjBxbJe97zgg==
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

This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
reserved memory on DT-based architectures (arm64, riscv, loongarch).
Reserved regions are marked MEMBLOCK_NODUMP by default so kdump omits
them; reusable CMA regions are different because their pages are handed
back to the buddy allocator and may carry crash-relevant data.

ACPI systems already filter reserved memory out of the vmcore through
their existing path; only DT-based systems currently fail to filter these
regions, which is what this series addresses. The flag lives in memblock
itself rather than in a DT-only structure, so both ACPI and DT systems
can benefit from it (suggested by Rob, thanks).

Since the reserved memory regions are filtered out, the vmcore is
smaller in size and faster to produce.

The series is based on linux-next and is organized as follows:

Patches 1-3: Preparation and bugfixes: switch riscv crash_mem to memblock,
	     fold the duplicated per-arch memblock walks into the weak
             defaults, and serialize crash header preparation against
             memory hotplug.
Patches 4-8: NODUMP infrastructure: switch crash_core to
             for_each_mem_region(), introduce the MEMBLOCK_NODUMP flag,
	     add a dumpable flag to struct reserved_mem, and mark
	     /reserved-memory and /memreserve/ entries with MEMBLOCK_NODUMP
	     flag.
Patch 9:     Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
             header.

v6 --> v7:
1. Fix a stale MEMBLOCK_NODUMP flag issue [1]. Memory reserved and
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


v4 --> v5:
1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
   (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
   DT-only struct reserved_mem [2].
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
1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
2. Fix UAF issue when alloc_reserved_mem_array() fails.
3. Add some prepare patches.

v1 --> v2:
1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
   feedback [3], v2 drop that property and exclude reserve memory
   by default.
2. Split some prepared patches from the original patches.
3. Address coding-style comments on patch 5 from Rob.

[1] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org
[2] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
[3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/



Wandun Chen (9):
  riscv: build crash_mem ranges from memblock instead of resource tree
  crash_core: fold duplicated memblock arch hooks into the weak default
  crash_core: serialize crash header preparation against hotplug
  crash_core: replace for_each_mem_range() with for_each_mem_region()
  memblock: introduce MEMBLOCK_NODUMP flag
  of: reserved_mem: add dumpable flag to opt-in vmcore
  of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
  of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
  crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
    header

 arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
 arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
 arch/riscv/Kconfig                         |  2 +-
 arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
 arch/x86/kernel/crash.c                    |  2 +-
 drivers/of/fdt.c                           |  2 +
 drivers/of/of_private.h                    |  2 +
 drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
 include/linux/crash_core.h                 |  2 +
 include/linux/memblock.h                   |  9 ++++
 include/linux/of_reserved_mem.h            |  1 +
 kernel/crash_core.c                        | 51 ++++++++++++++++++++--
 kernel/dma/contiguous.c                    |  1 +
 mm/memblock.c                              | 43 +++++++++++++++++-
 14 files changed, 155 insertions(+), 97 deletions(-)

-- 
2.43.0


