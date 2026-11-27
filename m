Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A510606A324
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zNsFX84J
Received: by kanga.kvack.org (Postfix)
	id 887536B05C4; Fri, 27 Nov 2026 04:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F286B05C6; Fri, 27 Nov 2026 04:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D8B6B05C7; Fri, 27 Nov 2026 04:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFCE6B05C4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:07:45 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5B5F80290
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:07:43 +0000 (UTC)
X-FDA: 85480321206.14.5B0CDFF
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D27D4000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:07:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zNsFX84J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770462;
	b=gKWaQtYy/99gbLF63QkLLmjlOT83tbr8LuutqKxNPUX7XTayZW01WTVoTPHJyAJsUu5Q53
	UuJug881VwUJnin3jKUu4/VPedxC+CiukPDBZOrlTwQYEWoGpaFehMRQpr5Shu/yNW5JLU
	8cgcnRv2C0geWiKTzriouI007k5WtFA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y/UMHkeyUCY25NbdTw5rz9oJMH9U+JYd8hruRProdo8=;
	b=VKj7g8I8bRauM6QJ097DH62balHVUKhLrowXejK+qj0E+Z21+9VoTJHc9lKH6Gvk/pTdLR
	gMcVHnU1d1cSAoIVBLP+JAGyMssoE6lNfiRe0kmoo66t2/K0VJJdis2U29zhhHjodEMutK
	SB3543jGGOotmrQMdVmNwQVSAqIstzA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zNsFX84J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-3b3d125637aso1562251a91.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770461; x=1796375261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y/UMHkeyUCY25NbdTw5rz9oJMH9U+JYd8hruRProdo8=;
        b=zNsFX84JmijAlU+w4ctXuW7RA1/F0Pom+VB0TNkQMuYVI4VuLNacy72B9+HabRJyC4
         wRg3fQLygBri+aXM7meBm+JlbUOaYVd/DGOjlhEGmLhr+ykdNtaWfauyiJllQSnTjZQw
         B02oQKXlEVSWlfRmnpazk2j9RipV/whsYscsYwotLNaRUMewa8Th6vnhipjojiOjwKkr
         fItXSr2xNU0MqK2i96GHYZOCeVfRNihP32LPkdWAwhYom1lj19oBm/gSww8dhu0o7D4C
         si4E3jLGFaco9986aa5jQYiZCWvcRvMkp5oULkAyhxpl/nd7kc5anVp6TzhvWRz9wuKT
         kZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770461; x=1796375261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y/UMHkeyUCY25NbdTw5rz9oJMH9U+JYd8hruRProdo8=;
        b=PjG8JvBme2fWMCCLyjhKrvga+q5NTvBVJ/DVQ8ovURZ7kjUdK6/jZL3O51qDwHzeXz
         IPRxjYdR+zhFrHsLeVMn2pb5NCsfIg7Sdk2PxBHFTa3GxKx/cZZNM/0DG6kq1wNG2i5V
         km3ap15Or5MDj9pUlFHNDQBc6vgFHIcgaomxfptcgzZv7xBoXn+Jq+R4OmdRExpnSpeA
         5tPfkx5doyVN317fuby+XIxYoLkQ7pOtS5zIEDZdzLRKPR+N0xJz+0hewuoaMyccNrRl
         +FwTB6SktxgT8tWa3pewoHt0Hy3yikCoYPkgxQjLtWJvxTijSd3YRugrAyEN2jdeEv1V
         b/JA==
X-Forwarded-Encrypted: i=1; AL+hErH8u3uS2qeBec1CR9haplTRvZM38VZvrUgY70OGcDffJ82bN8q+Kv2VJUK/4A4+Dr7uyr/uudoknw==@kvack.org
X-Gm-Message-State: APuU4Z/dcHNnb2Jee7vaWCVpDqMvSBHD7QZmwUgAoaHfxtdYoatD6chW
	0fMWpINFX3K7gZHf/yVDnS5zNtL+DJ/NBgHaSU284JiQCvTowtdRtuD+
X-Gm-Gg: AZFdTZeS7+7KegOKL1uGR5TM36mFJjYmCAHgFiMHOAatl/JW1tMp1j3VKbvK3ynyv8d
	VuIS1HtGMhYQxrA3pjba9mhrJT6G5a+3xmUYqxbgOwzwou0DGhMRxHL0AkBTGoki390X4azuFs0
	XYs9osSIQqJ6RnBS3aM035vsO4pDSO+XRIrr1OQe6WVzB6rAIHRklge2qBE3emmoiNfVG2g6aBg
	kXQOuI9MaA2oyAxD43JdfzjXPwHstir9yLX2tFj+Lbw5dK4bKMq5r123J/kIrq/0yPEIdRcxa7J
	j139yRD02RffobXaLjT8GrnjaoLk2hgG84CfcTrJbV/KPVzCIYq0+ENEbT1sj6bvNentedSQ+1e
	9uPU/DUmcRNeJko9M06bh/t/vpNsRzdIhVBlWOdt7IiGabrK3XZDzNwz+29Ze6E4/Xs8Ag6aszF
	7FJzmwrMZYmEN8mmU5LdqkTGK6nluyFSiz0GLftlS/t52xDvyzJFF1B3glF4iqGpyPBhOBAkcmO
	slgPZtFRsZPr4BdKxTWKrrx/a62d3oATQFByJW+SPHP5yJJZZtYxdTnu2rjjyqWEkl1NfRoBiK8
	sfKBLrGsy7cAlxQpDTPXfxhTwqVH1v4DPtMlRjgEPw==
X-Received: by 2002:a17:90b:5287:b0:3b0:d35d:bb86 with SMTP id 98e67ed59e1d1-3b41c8fe261mr23255612a91.15.1795770460754;
        Fri, 27 Nov 2026 01:07:40 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:07:39 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
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
	ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v10 0/8] kdump: reduce vmcore size and capture time
Date: Fri, 27 Nov 2026 17:07:15 +0800
Message-ID: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: y97htxb4zwhwpmzg3hx7z5x8riyhesux
X-Rspamd-Queue-Id: 1D27D4000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795770461-508868
X-HE-Meta: U2FsdGVkX1/39K2Ke5jCWLdKnuJU2UuL1I0X8/gcsVgsPdNfYOPKtQzQJQw4FOpX2ekNDvmysROd9LrLSDouc/zsstHx6UClhhE+YSE8+8WRU/hheChK+wqjPhgSFX25bKehMZPkd9pzS4XLujfElA/Fva8DXoLC8hf14PRcSqbARazW3jtkSubW1mNvYIwqadWsHFpPdzS+CkYxqU3k+GPfnbo83eruYlTDZw7TVB+EkuHv1eEngyVE144F5s9nXFyLRoDDzD03maYyq5IqX7LVcFl80puwAW6FJxZ4AdMwuyPKPxTxYTgLALblWxoLki4eMYtYOovQBlwUvFZ/RvGFd57faNQiEBzXyqDJwKMWT0xUVgvR2uQZniRn0dWJrGdPLuxlq49j69DiIZErko89ydb/WGuTagR6dzHS6gDz6xSb2ZuhNFoYTM/21t5gcna8vLxe/tHuTz8UJPnP1Ngf5gc3En45xjGejwu1GvNHOSOdggJlGELW2QyxF+qjF7FYFCHOHWtPo6kdZxLvDmAJxxTwRAxuJKTkqfxsk3EVQE7120yJjfHBbsA9qtJ3SNfFZqPWi4Kde4okMJhAUsFpJZmXL6JTXGilMa1vFWS0JzxxTFz0iiQsmi8ir4zxNzQOVcy2czzqIh1s/zV/UJgCAc4vpzeBcmMr60/KFu+wTJNLKmXvt39rKtV8NRng1zUQTHsFX2sbiWVIiy06OK7crmqpGZ1r8rKNSz9T8bsMXp+BtA2O30hI7mxbe3lWxcrOF5FIZ2M5GeeaikY1h8kZVKJn45Ctcz4kQMDoBt3zUCvxGJWJH0vWNVRA9UHBC8Y7w2/QIavPPzZAq29XXyqymi1jReDLX9FFVf3wvZcE+9r3F4J/qDVPJmk7+Nq/pSFwAWHb71Kfg44muNjAzEaeMhtMbYwRaLUT6TNwPjzN4Zc1q4FUoW6egGsp67Bg7WHtnEf2n2Da13zcLV5
 m/ugv2rA
 2MNkqWzLfmeF6daVKi0K9q8ZqehCxFBmrZLAzSqKiYpGRvsPUvggtjFLQuF+ZDOaToZBRhEqgQH2FyUGt9ggM+LquD4d+5306+fpuDTzfyJqMsRQcokZhr7+qC3d2doch4V1H/G6eSNvOo7fP2S9CalLEOrIoqhcETGdzzefZfOoZmavK2AkJpXaE9VENFsFJ69t7N5I/7l0TRCXtwD0HRj4Ax3XlXijAx1YWDi+pAPom3j7bk+5/CWFuiYhHzol2zct86AGRzy5zkqzjR2i2/hsIX0blcEvEIDRlXKrl+pRpy/mSlvGeK1DXF2gZl2MM7YPY7dLEQwzKhxul/mptxMtWlG9UcfVwWrWMu3+IW6ASC3ob9Gd6VQItYCJ6a6bK3RfxdKvxm+MR6P2r+rpWakG2gJVUbG3OlmkdMAd4J75fDNUzfPV4rQB05k3R1cPj0l+XhlU4iYSd8lwnkUTIDd6ylgxtuR7TmYp/zLH03H+gC9k+poDrwx1KivCVAYtCPmsBVvyMSbJBLImIXOken8fC+/l78f9RoeOoopiFE5Sb5gItb9ORQ4/6u2rJBTtEpVj0mWIyvu1EeykSn4s/5S8YynyozJQJ+UuzrHZrqdXFBE/ZsldGoQM7yJYbgbmRvfWNHZiR0NKT1ptQH3+F/sVrcu8Ki7T1a+yObOtwuOeLyQ7QvPixkwocpiySO1V/K0TmfzJ6mFqcQPC0FTwUcNGIoxn6VxyLcHD1z5mplQaWY2A=
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


v9 --> v10:
1. Rebased on the latest linux-next, which includes the
   reserved-memory rework.

2. Patch 7: fix two issues found by Sashiko [1], by skipping
   the NODUMP marking entirely when early reservation fail
   and clamping the marked range to page boundaries.

   The changes only tighten the conditions for marking NODUMP
   and the overall logic is unchanged, so the Acked-by and
   Reviewed-by tags are kept -- Marek, Rob, please let me know
   if you disagree and I will drop them.

3. The remaining x86-specific race in patch 3 found by Sashiko [2]
   (Xen balloon inserting a System RAM resource outside
   device_hotplug_lock) is pre-existing, and fixing it depends on
   resolving other pre-existing issues first, so it will be sent
   separately.

[1] https://sashiko.dev/#/message/sashiko-outbox-181183@kernel.org
[2] https://sashiko.dev/#/message/sashiko-outbox-181179@kernel.org

An Ack for patch 1 from the riscv maintainers is still pending:
I have pinged them, but no response yet. The Ack will be added
once received.

v8 --> v9:
1. Patch 7: Avoid a potential boot panic on SH when NODUMP marking requires
   memblock resizing before it is allowed. SH supports neither
   CONFIG_KEXEC_FILE nor CONFIG_CRASH_HOTPLUG, so skip marking when both
   are disabled.

v7: https://lore.kernel.org/lkml/20260922084256.1515554-1-chenwandun1@gmail.com/
v6: https://lore.kernel.org/lkml/20260902073116.802752-1-chenwandun1@gmail.com/
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
 drivers/of/fdt.c                           |  2 +
 drivers/of/of_private.h                    |  1 +
 drivers/of/of_reserved_mem.c               | 30 ++++++++++++
 include/linux/crash_core.h                 |  2 +
 include/linux/memblock.h                   |  9 ++++
 include/linux/of_reserved_mem.h            |  1 +
 kernel/crash_core.c                        | 53 +++++++++++++++++++++-
 kernel/dma/contiguous.c                    |  1 +
 mm/memblock.c                              | 16 +++++++
 15 files changed, 116 insertions(+), 94 deletions(-)

-- 
2.43.0


