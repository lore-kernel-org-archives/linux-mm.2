Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7043CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EAD6B0088; Fri, 29 May 2026 10:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A160A6B0092; Fri, 29 May 2026 10:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954096B0093; Fri, 29 May 2026 10:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85E456B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:33:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47B1EC03EF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:24 +0000 (UTC)
X-FDA: 84820700328.02.D00CA75
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72542140010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZjSulJ9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eyl+ehBlxBHsDx62eFKFPSNCgRZqAc+bGbUbiW2nOz8=;
	b=64fhq8+liz9JiIZ0pW4v+B6b8pC4De20rQiEPIKKKpCvkYLA24Bm82FJ30tcgR5tuXDEoB
	Rur/B0C9Ftudf1U4laCgPI0YpNBSnMjnsdIPsAZQ+cHeC/8nf4nHSk+1Ndck+NUdmXe5fs
	exNQc4vRlYzCbwjYqjxh/RUV30JNkzM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZjSulJ9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065202; a=rsa-sha256;
	cv=none;
	b=uNerJ6cSDOPcBL3jS4kBGspVqGV2R81vCPQXWYG924pYoiTPEM1nEKFMcjlrJu1YQhxsOn
	WAybmtk2CgOoiTha4cVHKzoIayYIce3VAx1usfozlEuefCZvKvAlXuoXGgOdcLja3ZC2z9
	YnR+QnTxSPJ3EO2rc+7ZP9OX5EU/I90=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780065197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eyl+ehBlxBHsDx62eFKFPSNCgRZqAc+bGbUbiW2nOz8=;
	b=DZjSulJ961TsPjzS3b+q4BFKgAd2C05gQOdDZlFa763xRuqKnpXByoSAiGELafch2Gl9Kv
	a95Tb6wB1z6MyzZmazv2suEs0dzCNZXvCgB+d6bqsw3Q1BKGdhe+v4YwAwSUKtgWfvVjVU
	ZohlUO6R3CXU3BR5GBu46ZASDoyT5Zo=
From: George Guo <dongtai.guo@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: 
Date: Fri, 29 May 2026 22:32:34 +0800
Message-Id: <20260529143238.169169-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
ERROR: Invalid commit separator - some tools may have problems applying this
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8z4qmabp814skamz94qb7jo4zop74xmt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72542140010
X-Rspam-User: 
X-HE-Tag: 1780065202-203266
X-HE-Meta: U2FsdGVkX1/b93K2fbnhL8KWFfYLSgRI+JEeAZWaHKFi6VGUoV4ujLoLDDSKBVGSv5rPn/hZTQytwmK+CatoFzsETEGciCI7I0qKrzmrxlgLKhpPbY58tyQ2C4MqDF4eFsMQcFE76hD6PS8qRXSLc8BK2Ru1Mfi3hRJFbH9lPd6i624/mFIUg1JmwESKrMwsIY+gmuNWjzoySHqpSWtKQasFCJFVPq6jFF/8TSKAdY3f4xdWCSKFZoFzUIAznhyDOINwjmsk9SX5U2JVbBWoH+94rHG1XlR4AJi+FyRFzuyNF44h9m0Q3VrI/N15zFyiLrXsVQMbYVcrZyP9TvP4+O7Ae3GxjRdIIWyns2oEc5ag5TK16Mp2hbJLaNtOup2PDBzmCMaHp3PSWLs+ZYhP/GkYKjT9VhQ0kKGckbujbavTeRQ2LZE7b3c0DH1yAJaLodwnHOlKkoxxbt2g9Y4FHGthy+PVZRyjQ6z9xUVhFVkTxOaZ+dxbMYFH8wUijtvxROXEHDZubmSzU5hcZWX9hGf7RQZaGqznWBZQvrL0RNe4NhWmSeFPIesz2EDREvf2REChwGZhMKNjzP1n/86sYfD4iYCLkt/JdxepdrP+IOiIaJ3NRv304mQPIcq0nraYgcsmLLmdVYn+VjtN6rTqseqI+d0vcTkbrrZ00UK9FFrFK8v5IbxjOmWBc/DqT5jx10lXPxU2XXgP0KZb+GzIzeCtwmFz8hiZDeE5KsvfVKvn7XkknAMUq0NOKlUbeMtbiEhjLbuVI57voarzn+cJqSQWZxFRLLp1MMy58Cp1P+kC+f4zNETO8O9ITXUI0v3/addUHe1m7MnDUL9Q1TKJeHG7plBA/8H3tFbBjAI+n7JOIH/D/qCat9EVEl2z5TtgVYVmgcpg5AmfJ8sHyTGhlMjRPyKTJ9zUAW5qVsLN5NSkFEL6kHHGpV4f//Kt1p8SW4R0dP3czWpKbMBopID
 3v/g1zQ8
 +jb/UeFd2W8ckgvW83TKazpsig09FxQkR5aS5KT2aAbKBBE9ARAvvNhl8etqadxIzqdUhKb3fi7g5cYcXzOPJCpCIJgBW52sSDNW++13JI0sTMkoMIl53CIEZlF2YEHw0k3IJA5zE9PiMwevj6vHczvTFe4yH9YI6xkE40oBMgnF+obXz5ZBqhTS8zNxoudzoK01LBSDr59OGMq8EK8L6kXsm+YD5mc3P870fPv7hM6VBe9SRxJwVFAOn+iVHN4+Q5Waf9Qb88JQiVtWHlAhFQvJcSrCIRwfSGTyouRjYKgYWuaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
#26: 
containing only /chosen with the two KHO properties.  Since DEVICE_TREE_GUID

ERROR: Invalid commit separator - some tools may have problems applying this
#34: 
-------------------------------

total: 2 errors, 1 warnings, 0 lines checked
>
Date: Fri, 29 May 2026 21:54:01 +0800
Subject: [PATCH v2 0/4] LoongArch: add KHO support and selftests

This series adds Kexec Handover (KHO) support for LoongArch and extends
the KHO selftest infrastructure to run on LoongArch under QEMU.

KHO passes metadata (the KHO state FDT and scratch area addresses) to the
second kernel via the FDT /chosen node, using the linux,kho-fdt and
linux,kho-scratch properties that drivers/of/kexec.c:kho_add_chosen()
writes and drivers/of/fdt.c:early_init_dt_check_kho() reads.

KHO support (patches 1-2):

Patch 1 adds KHO support for FDT-based systems (initial_boot_params !=
NULL, e.g. QEMU virt without OVMF).  kho_load_fdt() copies the running
kernel's FDT, appends linux,kho-fdt and linux,kho-scratch to /chosen,
and loads the result as a kexec segment.  machine_kexec() updates the
DEVICE_TREE_GUID entry in the EFI config table to point to this segment
so the second kernel's fdt_setup() can find and parse it.

Patch 2 adds KHO support for ACPI-only systems (initial_boot_params ==
NULL, e.g. LoongArch servers with UEFI or QEMU with OVMF).  Because no
system FDT is available, kho_load_fdt() builds a minimal FDT from
scratch containing only /chosen with the two KHO properties.  Since
DEVICE_TREE_GUID is absent from the EFI config table on ACPI-only
systems, a new extended config table is built with the entry appended
and loaded as a kexec segment; machine_kexec() switches st->tables to
point to it before jumping.  The second kernel's fdt_setup() calls
efi_fdt_pointer() to detect the KHO FDT and passes it to
early_init_dt_check_kho().

Selftest support (patches 3-4):

Patch 3 adds loongarch.conf and extends vmtest.sh to recognise loongarch64
as a build target.  The LoongArch virt machine is FDT-only (no ACPI), so
'earlycon' must appear on the kernel cmdline or the console UART is never
discovered.  PS/2 input devices are also disabled since QEMU's LoongArch
virt machine has no i8042 controller; the fallback port probe hits a page
fault and panics before reaching userspace.

Patch 4 handles QEMU not exiting after kexec on LoongArch.  QEMU provides
no EFI runtime services, so machine_restart() falls through to an infinite
idle loop.  QEMU_NEEDS_KILL=1 in loongarch.conf signals vmtest.sh to run
QEMU in the background, poll the serial output for the test verdict, and
kill QEMU once it appears, so the test completes unattended.

George Guo (4):
  LoongArch: kexec: add KHO support for FDT-based systems
  LoongArch: kexec: add KHO support for ACPI-only systems
  selftests/kho: add LoongArch vmtest support
  selftests/kho: handle QEMU not exiting after kexec on LoongArch

 arch/loongarch/Kconfig                     |   3 +
 arch/loongarch/include/asm/kexec.h         |   7 +
 arch/loongarch/kernel/machine_kexec.c      |  38 +++
 arch/loongarch/kernel/machine_kexec_file.c | 256 +++++++++++++++++++++
 arch/loongarch/kernel/setup.c              |  21 +-
 tools/testing/selftests/kho/loongarch.conf |  13 ++
 tools/testing/selftests/kho/vmtest.sh      |  35 ++-
 7 files changed, 365 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

-- 
2.25.1


