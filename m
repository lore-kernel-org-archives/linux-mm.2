Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14AE606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vlE7YCUk
Received: by kanga.kvack.org (Postfix)
	id EAEFF6B061C; Thu, 29 Oct 2026 13:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F3D6B061D; Thu, 29 Oct 2026 13:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74DD6B061E; Thu, 29 Oct 2026 13:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFD196B061C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:30:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47C3540509
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:11 +0000 (UTC)
X-FDA: 85376352222.08.DC08703
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 979444000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vlE7YCUk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=74gBWRt7WtLpCuOuHi792FTVea5VELP18N+2xYhOiBw=;
	b=ie7IG44/f22UJU9Djqn9tyNOsYFFLDAraKaTL7vRHUCIqe9K6j3zS/hYA6072/IcfXDlWr
	H18hKXl7Nr8W+6NyJrBi2fiU0M2cAyHSK/Ca06dWzwJcVkOhcz3+AnntCGZKPlX+dIK1uJ
	Oq3UfV9/J8qhbm9j7t/Kyz77gYRBh4Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vlE7YCUk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295009;
	b=tboNbBcF4bnTeMowDs1JQtFASrIqtPMneZYhuzYBwBXE4JholYiM8ATwx28vvG5nbP83E5
	xf9jmsK4cltIOsyvuZoyM8yb3CUP0VOX0hPSa0tLup0CfRT0TkfbrA2THh+7q6AvtuipA1
	nR8FVYrGFCzIu61yQfrL5kovvZWN+IU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MYWB4yKYU3wamhVGzDfXOfnneQtLbPsY49kJbIwQCX0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295005; v=1; x=1793899805;
 b=vlE7YCUkXd3612qrpE2Q4jETXeA7ZxK5A/P0k9sfX+Ip5mOP32HD90gE+B2sI/iiFuffNFep
 7+XL2w1wZQ0UmcpXM/ow0Mut/D32YcyiR3advKwEPIiaHTY0yqS7swFS+RkYFW3zmZydxHB/XKw
 V33v16m+l43DjsInf4BZDvKU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cb79ae80c03f3ace;
	Thu, 29 Oct 2026 17:30:03 +0000
X-Mizu-Trace-ID: cb79ae80c03f3ace
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 0/8] LoongArch: Add KHO support and selftests
Date: Fri, 30 Oct 2026 02:29:47 +0900
Message-ID: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 979444000D
X-Stat-Signature: rfjky99r6ey3hfebidj8qqdiu9hfashk
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793295006-752256
X-HE-Meta: U2FsdGVkX18i0hlMQPs9zmlW4TYV/kUp1V0Z8OdTYINbgSH9Y+0yRpiqQKH206ZRPASHHCIDsbnUz/p2L5OOv8nh0vI0OtOBHBHAdaKGYnLaJ8/qeVS1/YgLEP49y94cajgHlqY4qcUkG8sGxybXyGGz03cVfn/x5zB8VwQw8q9LFO+Ap7WrmDqZbIlhYOu8HA4A7FFCCAQ3hbFtHM5287/rGSQjvgrX5ovAWRG9sUgRw683dyUZxWJ0KI9X11A455HeGi+3g+oKSwI8FD/FWlEBxAsm5c2O5Hhz8uHDKEjtEpUUR8cUDAJQz2RacCOQeZi22N498ZhJXC3xnaFcogIjGvV8MRXnfzGx+MkfPfKCJbRgFKW6jmLhwU840LVNVnK0WC61sWzqsR9+cPNwSVtGY/UzfiakgbE9HM8XuP1LiRVSCab11WhSEHgBQWZcIJptUItRyKsqy2EloslnQexTQ91PPU2Lx/LgztTjOgCC8e1HZZxf2LB4ZR4c47d/eG5bgp2ulMo5UXYBMLS8vyX+SffRnyJeIPknqHu8NRbsd1rCgcDNP1VfDiSyBGhG5RaOcR3QFT26JRbShgPtxHdQReQrSdUK7nZgMKxCpEQvTrQDi8lOS4LwqrwKXbd35Q02feY/WB9mvbMG/tqfilur5FGLogzonHHMC/DouIGxKKOb/i/atqX6vtDz2Q68oM7qzuW5InvuoAbcqTbv9GlN0pXuLrPvbGtOaw9OtScPnr+1zs4RVDuIi/u1Q4fgG5K+RQl7L/U/pTNM6TFhZ0jkdD0UG8d7ySYOTpS0nyiI7CqwN7dqN1BSmWDbqgU/Q1rg34D5SO2O1GFfJ++9yubhDrFbPfUfmm4mKg1PqUiDjH0FI20PTchK25/k6Kawea3nTSBItPb02OqBCBVuZZGjxkwbd7PayUxnWB+SsYqJv/QbR8YcxyvlSvBEHuQjKc/yozusQoBx+3fU2b6
 +jeqsbV7
 G5cHXLruOkYyzSSGzFYZ1IrE2QZ3LsCdvUikSk93bh+h3fJj3mP+b9LYEiixA2cK7I74u2adC+ZoQrrvdXqDihOpzSpdsYnPjL/kMya43DoLnOCOmt5VolzRVjJqaTXwQwMGLdml/SY/eTOYTOYxEzAVA3t3AT9x/5UYhsv76fToAlSapTDLeQleKmLrbXfuN4DnRiee7MRW9lbqQvRsG6sPiCfZw4tnDNfUB+4EGu51bFbwwmq2b1UMc+41Sv2aidfah
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

This series enables Kexec HandOver (KHO) on 64-bit LoongArch and adds
LoongArch to the KHO and liveupdate QEMU selftests.

KHO has to give the next kernel two addresses: the KHO FDT and the
bootmem area list. arm64 and riscv put them under /chosen in the boot
FDT, and x86 puts them in setup_data. LoongArch systems that boot with
EFI and ACPI have no boot FDT, so this series passes the addresses in a
Linux EFI configuration table:

  - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
    Kernels started by kexec are given the same EFI system table, so
    they find the same table.
  - In early boot, the kernel reserves the table and calls
    kho_populate() if the table holds KHO state.
  - Just before kexec, the kernel writes the KHO state of the image it
    is about to run, or zeroes the table if that image has none, for
    example a crash kernel.

A kernel started by kexec from a kernel that did not install the table
has no table and cannot pass KHO state on, so LoongArch turns KHO off at
boot in that case.

Patch 1 adds the table, and patch 2 writes it at kexec time. Patch 3
fixes a kho_block.c build failure with CONFIG_KFENCE=y on LoongArch.
Patch 4 adds kho_disable(). Patch 5 lets the LoongArch memblock
arrays grow, which restoring many preserved regions needs, and patch 6
enables KHO on LoongArch. Patches 7 and 8 add LoongArch to the KHO and
liveupdate vmtests.

The series is based on liveupdate-7.4 and depends on "liveupdate: kho:
calculate per-node bootmem sizes before allocating any" [1]. Without
it, the KHO vmtest fails on a 1 GiB LoongArch guest because KHO cannot
reserve its bootmem areas.

Tested in QEMU: the KHO vmtest passes on LoongArch with both
CONFIG_NUMA=n and CONFIG_NUMA=y, and run-vmtests.sh passes all four
liveupdate tests on x86_64, aarch64 and loongarch64.

Changes since v5:
  - Drop CONFIG_EFI_KHO. Only the LoongArch stub installs the table,
    from efi_boot_kernel(). The other code is built with CONFIG_EFI and
    does nothing when there is no table (Pratyush).
  - efi_kho_update() returns 0 when there is no table, so kexec on other
    architectures is not affected.
  - Warn if the table cannot be mapped in early boot (Pratyush).
  - Document each member of struct linux_efi_kho_data and drop __packed
    (Pratyush).
  - Rename efi_kho_table_phys to efi_kho, mark it __initdata, and join
    wrapped lines (Huacai).
  - Rename kho_sync_channel() to kho_update_efi_table(), and stop
    calling the table a "channel" or "transport" (Mike, Pratyush).
  - New patch 4: turn KHO off at boot on LoongArch when the table is
    missing.
  - New patch 5: allow the memblock arrays to resize on LoongArch. The
    liveupdate luo_stress_files test overflowed the reserved array in
    the next kernel when CONFIG_SMP was not set.
  - New patch 8: add LoongArch to the liveupdate vmtest.
  - Rename scratch to bootmem, following Pratyush's rename series.
  - Drop the luo_session history from patch 3's commit message
    (Pratyush).
  - Capitalize the subjects and use the kho: prefix (Huacai).
  - Rewrite the cover letter and commit messages (Mike, Pratyush).
  - Rebase onto liveupdate-7.4.
  - No Assisted-by tags, although my v5 reply said patches written with
    LLM help would carry one: the Assisted-by references have since been
    removed from the documentation in mainline.

[1] https://lore.kernel.org/all/20261029103425.14689-1-dongtai.guo@linux.dev/

v5: https://lore.kernel.org/loongarch/20260904100852.26006-1-dongtai.guo@linux.dev/
v4: https://lore.kernel.org/loongarch/20260807103714.33074-1-dongtai.guo@linux.dev/

George Guo (8):
  efi: Pass KHO state to the next kernel in a configuration table
  kho: Write KHO state to the EFI table at kexec time
  kho: Include linux/mm.h in kho_block.c
  kho: Add kho_disable()
  LoongArch: Allow memblock arrays to resize
  LoongArch: Enable kexec handover (KHO)
  selftests/kho: Add LoongArch vmtest support
  selftests/liveupdate: Add LoongArch vmtest support

 arch/loongarch/Kconfig                        |  3 +
 arch/loongarch/kernel/setup.c                 | 19 ++++++
 drivers/firmware/efi/efi.c                    | 68 +++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c       | 22 ++++++
 drivers/firmware/efi/libstub/efistub.h        |  2 +
 drivers/firmware/efi/libstub/loongarch.c      |  2 +
 include/linux/efi.h                           | 40 +++++++++++
 include/linux/kexec_handover.h                |  3 +
 kernel/crash_core.c                           |  6 ++
 kernel/kexec_core.c                           |  5 ++
 kernel/kexec_internal.h                       |  8 +++
 kernel/liveupdate/kexec_handover.c            | 35 ++++++++++
 kernel/liveupdate/kho_block.c                 |  1 +
 tools/testing/selftests/kho/loongarch.conf    | 11 +++
 tools/testing/selftests/kho/vmtest.sh         |  3 +-
 .../selftests/liveupdate/config.loongarch64   |  5 ++
 .../selftests/liveupdate/run-vmtests.sh       |  4 +-
 tools/testing/selftests/liveupdate/vmtest.sh  | 14 +++-
 18 files changed, 247 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf
 create mode 100644 tools/testing/selftests/liveupdate/config.loongarch64


base-commit: 9a6a70aefe77f6fb9ff2b3037dcf87f6dff65c8c
prerequisite-patch-id: 433e6f8fdec5151f12221a0a34f8fb111b95bb46
-- 
2.53.0


