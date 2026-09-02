Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAE3C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944EF6B0088; Wed,  2 Sep 2026 03:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7586B008A; Wed,  2 Sep 2026 03:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BED96B008C; Wed,  2 Sep 2026 03:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 500E66B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:31:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 464E112070C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:31:36 +0000 (UTC)
X-FDA: 85168002192.12.E61E233
Received: from mail-pz2-f3.google.com (mail-pz2-f3.google.com [74.125.228.3])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8C1F820004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:31:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uibnc2nP;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.3 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334294;
	b=ujp7R7oiGB3yQjo7oF5NoOeWzVIN6T0eLUUSZJYN75+Wgq95PlAjFeuL8QxPZuIQ+2kMhK
	hl7P5zs1cIGosXVH7EvF12X3N5KBWMDGLuShDcin5L5cWU9BpGDW+zox73jFnh6um3gb5O
	X/kGUtBz4SoAkpQLZesSSh22Z8vyM+E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B5vjeiQCLsTjdZkQJr1qZRy9fU+p/hRxqt/dZCpjN/k=;
	b=QIfz10qiVTLyRGGUyMF6Pm6p37o9f/af4pwIzdtpyAwpewYpG7zicrebVZ8CcQHWM9/dh6
	OqrVW9Gy0cIRjHWl+XtJPDJ63SroRaKCDDWeNlPxNjguVBXbYkFHAXOa/8NoGYhgJPwaur
	xVdcOFZGxWX58JStroVg/nJsqgY1kY0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uibnc2nP;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.3 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f3.google.com with SMTP id 41be03b00d2f7-cc1beca96deso383420a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334293; x=1788939093; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B5vjeiQCLsTjdZkQJr1qZRy9fU+p/hRxqt/dZCpjN/k=;
        b=Uibnc2nPv6ERwu6gaRh1v7C15oT5NskaAO08J6XeJWrhhp+Oazl0sCA/uEWpoAsRAB
         ADzw9AlcvrA7RGbEEPWh2BLt9gxU5q5ei7QlT+O5kStzwEN9yUnAKYhZiIcVj+Iv0Rvx
         ibsFCodGQKjLyi1rJ8vZh5ryPEGtERhtJyKiw0ghKWuFI5UshoVOsmED9aDe3Q2IeAE9
         CArtjcQs/pn92D1Lve47ZnzmvLDPUhMssCqpmbzGAasmSqM1x21zP63UDTHBfgLOQy2o
         fTUsw+gk+AREtPq+EvyKm70BP8JvY7WD8X3q20H4Lhve/nMa9/Vyp/OpTBVWgHKvAYh7
         d9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334293; x=1788939093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B5vjeiQCLsTjdZkQJr1qZRy9fU+p/hRxqt/dZCpjN/k=;
        b=RN99Ex0+YQIDR45aFvf50Aj/Wu5cp6m9oQib3xHnW4NLkesTXQ8Fx9+2qdlO+BAhWp
         wyQ31X3p6DztIpiId/mHF70t0sOmyjYLre4tJhbJc4Qu8ojPgycfVX1m6g8RSvXaGuxU
         2OGm4TYWFgHFKppumDJpCwbcCDt5ymP3+smWSu5LX+M4pf7Vd2VjaSiURWAdOXAM7bIq
         zl2aFlixzosdk2zM7xc09I556PvQHSfgmBzyuW9aNydUCW6kssc7nkcGScoHyPYiAIbR
         ttv07/bJygRUfb9mA67N/M5EtWbkFoIydzXZwlaG1N26T1WUeQlvGFRluUkmeKICDJTY
         chuw==
X-Forwarded-Encrypted: i=1; AKwUvBzFb1jedDSSHIKVrdylY2TigwTWie1etkmugtL0JPatX8CkB2WMNkS4EjZMV0MPlXsGGSOAy80OFw==@kvack.org
X-Gm-Message-State: AFuF++nELII/40c911u6xEgA08n27AE3xPQydbN+CU/8chnAqnkXdPUI
	mveoKvrUu2K0Lgo3JVKClAfKWM/yHX+4kSUDsQucQ/OIJd33BcGmUgA8
X-Gm-Gg: AYBFou2pgNY4+NqfgJS85j77z9lozipzDHDEgxYchaKdjrSgp0YHt9pplkcYi+PwJT2
	5whp0o4OsnXTXrnqWhwErtJmG6Tl7JnEHeydLjqxNUtjElGBkoTVqxpVxT1wiOJpLp33p/2aD9u
	/IcNEiRAnCCd8GUCSOQUp2ty9Dbt5lz+XcFadD58b1S24IWAO+56/DEIzU30IA8YKW5AEaLO0em
	UgX9s9QO5O0PUXpN+qhu8tQ+3TmPAFRj6lis++nKZcr5chl2fULumL1xDAiO3D5f6QofVyjH1O7
	ITBM23AyAYl7FaPu5abCkwFPMtrkBcocYMopcyVhvZ1DUeC2h4je7xI3X/Opvr1nG+0guZNKmYB
	wnTpPKELodZnf8Q8ET/yYtxrgNd3kYLzQ9rHmZq8DCq8mqRIy9/cQlDHkdAn4A4ytgWgKfJgEV3
	FfKaiLm1sL/Ue4LJ7uDXpxaGRXlOrHQJt3/HzDiIRHomw/TTkW+JAmsPqudBtMvbwmgbM1sCvS
X-Received: by 2002:a05:6a00:148e:b0:847:893f:2d0c with SMTP id d2e1a72fcca58-85ed1d0414dmr5028771b3a.5.1788334293213;
        Wed, 02 Sep 2026 00:31:33 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:31:32 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
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
Subject: [PATCH v6 00/10] kdump: reduce vmcore size and capture time
Date: Wed,  2 Sep 2026 15:31:06 +0800
Message-ID: <20260902073116.802752-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C1F820004
X-Stat-Signature: fc691xithnphpr7bq1bs6p15nu1im6jr
X-HE-Tag: 1788334294-38365
X-HE-Meta: U2FsdGVkX1+Ne7FjK/EfQ9ymCjcdggfSHDntj1H20aT/u11eQZ8jMiq7w+mCtXJ02lyAraAJoZiXwTw4WdUSUzNjG1r0j+EtdAND7niVDVMlnM0Qu+/687KWgKXEQGyv2ce/UhXFTnrmwUMfBNNHTaeXRciyZyVYfsPtj+BfmO+CtZXTMqPZsblt9e3Q7RG1EX92HSbliQRbQCBDNHioLZKjQhBMA6c/67lIqCvdwTi90kN7zKK6o8iPvKXraSm+jBm8oz4Rydm/cMXCwGE1xKeTF0KJi8sHw/szCWezi36qDSW8H9mLmL0NSYvxK7Sb6SPwl8+WUrh9VN9kSf1muL5bhH6vKgzBo24PDnBiRcVWLYyjTHJ7rlDaM9nlJedKRpA222FJ3yzA9sxLCDcLdpzb3yPruCagC2jn9iXy/zingfpn1XDsEZOn45/1zNbsjBCNXcmXtGEE9RF/4OsE7ADLwV8C//Tj22XPGJSLc3KKVoFm2j5gmc/84DWMbOBb02CnHdKvXd8yUYIXM9xF9GTV1BQ+zy1XYvxAVMfoBI7uh2sdTTy/u4LlQo/Ltg3pqSnHYfLzpP+omfRE41e6WTKFxzf+MPxgdykEzKyffYWogcSfImd9CDwCuNIfg18i8DlUK9CwjqeMxd/ByjPVU/uZewfzbZIoU2RzCfZ+gbigmAAa5jckRnZFB+eHZ2PIntr1ClxKkV1Dw+JJJdFqvyYa5KOBKB2m2yguzIEAeCVREL0Cs83PAhcu/l+ygySBP8vZ9d+LQ72RPfV1yAf9dxMyZwEp+MZpddrCkutW1HE8pYcuqOsQxf8s9loMUjZvpQ+BiUOGOBVL/el2AgIyCWvJfEyP+1qlgt7M2k8uX+hem8XX4zPsvxJGGRNwP0nmju0PACaA/30JOW1PviUzW0ssxQXeUErWmDzJwLeDDJGAtQ7wMFD+vC2KrcvSJ2Q+fy2fGK74x82VSBV7zTX
 jOzJISXH
 z1YFcDyQvtIvx/Vua/CeWooPLRjgJk2Dnlff/ljDfNMhYtCZ7HQamFnPgTbJufsjVurQdwQIqJ9rPxq3QC6hLEiQnr4+7n2gyYqRxQzO/mf/KC/OkKEuhPL0EKSDPzB6UHWKdy9+7Fi1X2Yt9sqRd12igoJWurpxBzX9wnRVo8ae+x21hj1ks7eQJYTaSFHnggwnkXIJmP18VdPZweSh+YqRv+33w1fthPNIZMdxPyFb44rCleiLs7ppLolvog6mW+hi5tovqVximCz58DgIpdjFFwCjRfs1eitYYQ2/w97o5s48DhLtHLxNCowOxNsIpa3PVjKvxi2AoaK1D7pKB1Rc27kbIN7jgf/o9r6fVsZwNlWlDAJUIuytDqO/5q4L3CC/1EVOphPV0HRmqtMiNItBOb4c68SZSMH79pLd4ZIO6yyZ6VOz5sBnrcCSV9vtkE/kf3c7mSHLzhzl9Hr92HNNdP914JohEDoNG3H8V6iPOduP1QfCqFfFZVA==
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
Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
reusable CMA regions are different because their pages are handed back
to the buddy allocator and may carry crash-relevant data.

ACPI systems already filter reserved memory out of the vmcore through
their existing path; only DT-based systems currently fail to filter these
regions, which is what this series addresses. The flag lives in memblock
itself rather than in a DT-only structure, so the mechanism is generic and
both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].

Since the reserved memory regions are filtered out, the vmcore is
smaller in size and faster to produce. 

The series is based on linux-next and is organized as follows:

Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
             flagname, switch riscv crash_mem to memblock, fold the
             duplicated per-arch memblock walks into the weak
             defaults, and serialize crash header preparation against
             memory hotplug.
Patches 5-9: NODUMP infrastructure: switch crash_core to
             for_each_mem_region(), introduce the MEMBLOCK_NODUMP
             flag, add a dumpable flag to struct reserved_mem, and
             mark /reserved-memory and /memreserve/ entries with
	     MEMBLOCK_NODUMP flag.
Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
             header.

In v5, Sashiko found some pre-existing issues related to reserved-memory,
and has no dependency on this series, so these issues have been addressed
in a separate series [2].

v5 --> v6:
1. Serialize crash header preparation against memory hotplug to avoid
   out-of-bounds or use-after-free issues.

2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
   avoiding a panic from too few regions before resize is permitted.

3. Reordered the patches, put pre-existing bugfixes earlier in the series.


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
1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
2. Fix UAF issue when alloc_reserved_mem_array() fails.
3. Add some prepare patches.

v1 --> v2:
1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
   feedback [3], v2 drop that property and exclude reserve memory
   by default.
2. Split some prepared patches from the original patches.
3. Address coding-style comments on patch 5 from Rob.

[1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
[2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
[3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/

Meijing Zhao (1):
  mm: memblock: add missing HugeTLB flag name

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
 mm/memblock.c                              | 17 ++++++++
 14 files changed, 131 insertions(+), 95 deletions(-)

-- 
2.43.0


