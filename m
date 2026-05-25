Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05806CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4BA6B0093; Mon, 25 May 2026 02:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C806B0095; Mon, 25 May 2026 02:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9716B0096; Mon, 25 May 2026 02:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F02D46B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DBC1120173
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:21 +0000 (UTC)
X-FDA: 84804962802.22.8F3768A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9E71E4000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IIr3jMS+;
	spf=pass (imf01.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hIRi3HO9e8xA8aknZ+Hmyg9qLaGWZHy9zhx8wJx1Ids=;
	b=dg1f2G6YZ+ykcjiUrCbm39ZISZUo12qnRhYYW8au+jjyAOBCeB3lPScsn6qXDKm9k7MyAP
	yDjIAKOpM8wTD8A8kwyiTAlesfhWRRBsh9FGS+azcnE9pJnHVFuKNuXvT35lgnAAtT5qMB
	jDVlZlm76qmq2lbvyacDDkwnsoIKJUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690500; a=rsa-sha256;
	cv=none;
	b=NrQYVOJSnGBLF35GsxBbigH2NGaKRoDwJgM9+tJl5QtcL2hhYedvyxdxLMG1AzlSqDCXnl
	OTvrq4UYnfBeCJrXeKHlhM0g/1LtKjWdowp8+NFWl4a9L8c7Zp1J1j2CnQQ73bFwe3uTNi
	/Sbt+d67iH7F33tNnLMDfq+uQ/tbWYE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IIr3jMS+;
	spf=pass (imf01.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hIRi3HO9e8xA8aknZ+Hmyg9qLaGWZHy9zhx8wJx1Ids=;
	b=IIr3jMS+wd34Awp2PESkNwbtIVAd+PlWxSlG7OC5DEjyjpcqSEGLbiw8523AvvMPLjdbqo
	CjeS0Nnk6q1Kaqdn0L0rv13USlnXLplGl//9Cqz6+d65uyv5Ei7w9OvQVTRHFhvZmhqxdS
	/ykMAAqLGv18mjCxo0qCjhE5lwvUY4M=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 0/7] LoongArch: add KHO support and selftests
Date: Mon, 25 May 2026 14:28:03 +0800
Message-Id: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E71E4000E
X-Stat-Signature: m44wsuxrf1ipxjeko9615pxu8emfppgm
X-Rspamd-Server: rspam06
X-HE-Tag: 1779690499-795282
X-HE-Meta: U2FsdGVkX1+3OUw5LsboT5aFz2smy5s4UQLYgq8hfDxqkR/o0z55YxeMHmdpsUFo9AYK1UMvFwAajxS1qvLQ08uuwMcJLj/QtJce479G0uUtYVdSOCZciOTGcDtljx9yUCa/I8UVYli+f9Fp9GL0T+ZeAnGgZYyz4qZo7/lyjfzofHx1tfe11+EZnFUjQMPCea8+8oXoBfi2xBrQI6UKy8bJTwMuZ3Fr3oktknObDS0m+qOHuEmd/hEt/vfNTCnlXcCSdvH2LXFlXsG/JKK5A7GGzywVb98aQYGcFYIH7KsKTmaYuYboKdvRlnTa/qrtQU0qosuojnn51SwWXoAN7z2bqSbPAGsjOZAxSZuUSiPNdHTeyBDvHyGx2ZVE0l6VyjCyp+Dze6pXCEVNF0j+HJDvfpSYRjtEhdYnVza1h5a2VO9F/eCHklpONtQ+Bfhrj2iUHEBCEWmTc7hs9ODRRAD2VYp9anqj2p6sGy/+sW9YHm5P5/lShQyrVxTsDP7cY82T/QGPRMmlLgnO71BdlF9v/X+5kbB9au3sK2wqKzPCl3ZUCTJeCuEGV6YkilTffiD0+98oumPOEEo3YvXkvIB2tytEPoE7SCnZFJbaX4V2nCtjy1dsJ0evjI3eKzwhW5i0zVl/xjxcVGBVWlHM82EHzPdiG+h8Mo4/ydRmpl74OElQ+c8Zv0Os5f5cu6KuthMar6RKk2xCjScI4HQeSeL5UoOHIStD/kXO1EDotf6fr/7CzfMyH+D16ywQ0WpCLMc+oMBbwLryeleSQgSL0U8IYtt969EJWGLfIS/2fZOLr9W3GZd1edTQuCxQ0S7teHlzbDB3b0H3Md3LxjtN6blQ5eAlSNlz77LxZYYKHGLClRWynPNp2Gb+QosVujd3hOPAkDqZoKcMs8T9+OWKd0PGVFVv2lGWuTqbU2fTp/HKfv7oD7ES7os7dX2eHB8lP0r9MOigetTFnVB2IPw
 GV3twBvc
 cC521EAq12Htc+v5yCYfoQJjOa/AICpb8gHdzyv0B88Cat8PEg5DU2G/L3Uq190KTSZmp4nM19DcBvauJDqI0czQJJRws9N8t+l1D9IJkzEEQLYkwj0bMlrOU9pBnR95/N/tpHkf+DKXRfnAi6+xS+TYNyBB9dVpMAcxrYsiMbVYY/jxLhc6nMYHpG+/Hp1nOKYwF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>>

This series adds Kexec Handover (KHO) support for LoongArch64 and
extends the KHO selftest infrastructure to run on LoongArch under QEMU.

KHO support (patches 1-2)
--------------------------
Patch 1 wires up the three pieces needed for KHO on LoongArch:
 - Kconfig: select ARCH_SUPPORTS_KEXEC_HANDOVER for 64BIT
 - machine_kexec_file: call cmdline_add_kho() to pass the KHO FDT and
   scratch buffer addresses via "kho_handover=" on the kernel cmdline
 - setup: parse "kho_handover=" early and call kho_populate()

Patch 2 fixes a duplicate-parameter bug when kexec is invoked with
--reuse-cmdline: the running kernel's cmdline already contains a stale
kho_handover= from the previous load.  load_other_segments() prepends a
fresh entry but appends the original cmdline verbatim, so early_param()
calls kho_populate() twice and the second call overwrites the first with
a stale FDT pointer, panicking early in mm_core_init().

Bug fixes (patches 3-4)
------------------------
Patch 3 fixes a build failure with CONFIG_KFENCE=y: virt_to_phys() and
phys_to_virt() in asm/io.h expand to use offset_in_page() and
page_address(), which require <linux/mm.h> that was not included.

Patch 4 moves KEXEC_CONTROL_CODE from 0x100000 to 0x180000.  QEMU
places its machine FDT at 0x100000 when booting with '-kernel'; the
previous placement silently overwrote the FDT with the relocation
trampoline, breaking earlycon in the kexec'd kernel.

Selftest support (patches 5-7)
-------------------------------
Patch 5 adds loongarch.conf and extends vmtest.sh to recognise
loongarch64 as a build target.  QEMU's LoongArch virt machine is
FDT-only (no ACPI), so 'earlycon' must appear on the kernel cmdline or
the console UART is never discovered and the test log stays empty.

Patch 6 disables SERIO_I8042 and its dependents in the QEMU_KCONFIG
fragment.  QEMU's LoongArch virt machine has no i8042 controller; the
fallback port probe hits a page fault on the memory-mapped I/O range and
panics before reaching userspace.

Patch 7 polls the serial output for the test verdict and kills QEMU once
it appears.  QEMU provides no EFI runtime services on LoongArch, so
machine_restart() falls through to an infinite idle loop and QEMU never
exits after kexec.


George Guo (7):
  LoongArch: Add KHO basic support
  LoongArch: kho: strip stale kho_handover= from reused cmdline
  LoongArch: Add missing linux/mm.h include in asm/io.h
  LoongArch: kexec: avoid overwriting QEMU's machine FDT at 0x100000
  selftests/kho: add LoongArch vmtest support
  selftests/kho: LoongArch: disable PS/2 input devices for QEMU virt
  selftests/kho: handle QEMU not exiting after kexec on LoongArch

 arch/loongarch/Kconfig                     |  3 ++
 arch/loongarch/include/asm/io.h            |  1 +
 arch/loongarch/kernel/machine_kexec.c      |  9 +++-
 arch/loongarch/kernel/machine_kexec_file.c | 57 ++++++++++++++++++++++
 arch/loongarch/kernel/setup.c              | 27 ++++++++++
 tools/testing/selftests/kho/loongarch.conf | 10 ++++
 tools/testing/selftests/kho/vmtest.sh      | 38 ++++++++++++---
 7 files changed, 135 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

-- 
2.25.1


