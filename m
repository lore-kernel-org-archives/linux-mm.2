Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76332C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EC16B008C; Fri,  4 Sep 2026 06:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2816B0092; Fri,  4 Sep 2026 06:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794B36B0095; Fri,  4 Sep 2026 06:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4327B6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:10:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F4BBA049A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:26 +0000 (UTC)
X-FDA: 85175660052.15.BCAB833
Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77999160002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mdl6C3gW;
	spf=pass (imf08.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.72 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788516624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o3wkuTeSXY6ZguztNITu+uR9AE+arZh/2zJ/JhX9Oew=;
	b=sdE2AFAuqJHBAsSO5naHpTY26KcpxUAS+VDXaMYtPNvGLdUX4SERgbNBA//aYLD4lhNPkm
	X9Cucl2WAr/gpKFCtGnx51f2eH16yfQp4hYjg3evB0psZoQiFG4WUkZtXuC4AaQhdpBu7h
	xPC+bftp0Wfb3CEtN+Oax8kTQ6KjDNU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788516624;
	b=7OkWNx+uFzBdUjH09Iqjyispx51GzGOh1xDJbKTXI4UunbvdBsJFa2W/G2UFOAPjMzRFJd
	yxTr8AYMJ+ehFsT8SK1lJEP5NK74TIOxQfSYnWVE7C66OxdmjcvPYeWLdlVNCjNR83euOy
	+2cS8H0rLn2GgxeQ65NDS58JxfWH2No=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mdl6C3gW;
	spf=pass (imf08.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.72 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3i8Bvzh7qkOslCU/FvOhfyi9i8JlWiGHdZetbC/2/1E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516623; v=1; x=1789121423;
 b=Mdl6C3gWkeRVQGtfrYp+sYhl5B9ZDcyJkTQC8BlAzaOvrjgtHTaF36bOpCWd0rCtUaUtdSGU
 +yD6/dRShGierBbIkPZBE5+FK0riK1IqOdGlRlET62nE5xEwiTDfK+SmJ7FLZF8YTkWr8fKYfyV
 /bFrjxsZYzzUebrsAPVJJIiw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e95a607b71039ff5;
	Fri, 04 Sep 2026 10:10:22 +0000
X-Mizu-Trace-ID: e95a607b71039ff5
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
Subject: [PATCH v5 0/5] LoongArch: add KHO support and selftests
Date: Fri,  4 Sep 2026 18:08:47 +0800
Message-ID: <20260904100852.26006-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77999160002
X-Stat-Signature: 8spbffe1696qfmnwhu4ujku7n3kmfz9a
X-HE-Tag: 1788516624-884035
X-HE-Meta: U2FsdGVkX19JNlAMJklvf7J+ERwjZ3dHxV5/I1DKc6PHZJF+trgKW6mAfG0FW8SxMp/O74B6IWgQtHzvOpc5E3fXY5lFbJ1P5P1NS/5pQGoMiAKRF7niQXOCGD2pwApQn0uSboJTE6YXSDwJs3t2njXCKZNYPEdWh/y+Ag+3r6baR0T6W8kBTXcYB504SPvJqiNzftQHBuZWqO6x4h++95QyjIy1Ot0iMfu7FgluNjHJayyKajuHP7Daoi12xpJKvABKwqEa7gELcenjbqmuAJbqvywaFdDvtrS22vITUNN7l6FOFJY6j5M6y15LB3DjkWFnr8SrHLZrSBYVyn5V73RNMwlU58IrNWlLn3NS3eYe/hwzg+JxXzlS3fpymTlfRlAvfRlyeYj8n7wTZzT9a415vfEZzDUHeXyeSVH+bQAwoj8034WehZHeImwghi5DR1iI5i1MS4V90ToB1+sf4pPk8Z0NKm+miTOFbltteMPFq0CRF7QWG+s1pYYGzzdV9MFViV7a5KKwgmj8jwo7w3JExo60w0iw6UkIblOg7ucl+QUd8Ay9na2KHKurBYIzmU0UfOa6fdi69jpuctBCNtwBFGXGx/fefLuAaYOWBA7jvYUEtsC6AaM2dZkru9NwM1G6A3b2fhnB7SjgTMmsTyyILMR0sGTByY5VKgk9amtuB7Mm3ySWLbk+p1XjniYvnMMmp2u4XLMz6hpgRbW4OOwG7aOBSrG2Gi45rkR81Jr33YguPpyNghRSGwwBn46s1+dySIhVEf/JORl0lM88EBY09xXVqlqLsq2WOtf/tABmxH1CNaaSEnvL6+L+8hVmW9WlqzfWzKXVnakKW1xyN+zTWGg7b9Y3u1M/D2IvokVZ26XbZsDWsrUlZuI2NUFhKVtyfyVN7gXN+cX5Ujc4a3hkenIXrjdjOCV7hRTyEhZcL4hcbHgPlmA0JTeMwM+yBSl1Zy+7oj4v1KFvXGs
 +LIpl7xB
 kYohOHNEbnGvW+xAseINITiMxNRtytwRMp511XOZaCuRiJJeeFbvB5hW0a13owmo7duFpy5/rfXYnsHZLSCpr/q41+CxeG1xCd7holYWWuE1CXB/4E48e6UXhsj0mqlZf8e+QttL35B7zgArvlNZGUIlK3HyRubHNFuqJpDyKSIWOcwQCrjpjctVeCWBTQeFYBBIRZJMX4oQKYx7n6z035PA9X7PorVk2C0KmPG0ep3OkXDJsivmgl1Hmm5FiZhv0HDtEDbOsWxU5bdSFjYf4MNUihIQ9+BubDOFWQrpo15GA4vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series enables Kexec HandOver (KHO) on 64-bit LoongArch and adds
LoongArch coverage to the KHO QEMU selftest.  KHO is the remaining
architecture gate needed by Live Update (LUO) on LoongArch.

The transport is the central problem.  Arm64 and riscv can pass the KHO
state FDT and scratch area through properties under /chosen in a boot
FDT.  LoongArch boots through EFI without a boot FDT, so that path is not
available.

EFI KHO channel:

v5 reworks the EFI transport following Pratyush's and Huacai's reviews
[1, 2].  Instead of rebuilding the EFI configuration table in
LoongArch code and switching st->tables before kexec, the common EFI stub
allocates and installs a persistent table under
LINUX_EFI_KEXEC_HANDOVER_GUID.  This follows the model used by
LINUX_EFI_MEMRESERVE_TABLE_GUID.

The common EFI table parser reserves the stub-allocated table, reads it
during early boot, and calls kho_populate().  An early initcall keeps the
table persistently mapped so it can also be updated on the crash kexec
path.  The implementation is architecture-independent; LoongArch only
selects EFI_KHO when KEXEC_HANDOVER is enabled.

The EFI table is global, but kexec can keep separate normal and crash
images and can replace a loaded candidate.  Updating the table while a
candidate image is being loaded could therefore leave it pointing at a
failed candidate while the previously installed image remains the one
that will be executed.  v5 records the KHO data in struct kimage and
synchronizes the channel from the image selected for execution.  Images
without KHO data, including legacy and crash images, clear the channel so
the next kernel boots cold rather than reviving stale state.

The GUID name is changed to LINUX_EFI_KEXEC_HANDOVER_GUID as suggested by
Huacai and Pratyush [3].  Existing x86 KHO support continues to use its
setup_data transport.  Besides supporting non-UEFI boot, that entry is
consumed by the x86 decompressor before normal EFI table parsing, so KASLR
only uses KHO scratch areas and does not overwrite preserved memory.  The
new channel is installed by the generic EFI-stub entry path and relies on
EFI_GENERIC_STUB, which x86 does not select.  Moving x86 would therefore
require installing the table from the x86-specific EFI stub and scanning it
in the decompressor, not just selecting EFI_KHO.

LoongArch enablement and build fix:

The architecture patch now only enables ARCH_SUPPORTS_KEXEC_HANDOVER and
selects the generic EFI channel.  No LoongArch setup reader, kexec writer,
or EFI system-table replacement remains.

The linux/mm.h build fix is moved from luo_session.c to kho_block.c, where
the virt_to_phys() and phys_to_virt() calls reside after the liveupdate
refactoring.  This addresses Pratyush's review [4].  Adding linux/mm.h to
asm/io.h was previously attempted, but creates an include cycle under
CONFIG_KFENCE [5].  The fix precedes LoongArch enablement so every
intermediate commit builds with CONFIG_KFENCE=y.

Selftest:

The LoongArch vmtest boots vmlinux.efi through EDK2 because the initial
EFI stub invocation installs the channel being tested.  QEMU_EFI can
override the firmware filename for distributions that install it under a
different name or path.

CONFIG_ACPI_SPCR_TABLE lets the bare earlycon parameter obtain the UART
description from EDK2's SPCR table.  CONFIG_PCI_HOST_GENERIC keeps i8042
enabled while ensuring that the QEMU virt machine's PCI I/O space is
mapped before the legacy fallback probe, addressing Huacai's concern that
the same kernel configuration should remain usable for hosts and guests.

With EFI runtime reset services available, panic=-1 and QEMU's existing
-no-reboot option terminate the test normally.  The generic QEMU runner
therefore remains unchanged and does not mask failures by forcibly
terminating QEMU after a timeout.

The LoongArch vmtest uses the default KHO scratch-sizing path.  This
series is based on the generic fix that calculates per-node scratch sizes
before scratch allocation [6].

The KHO vmtest passes on:

  * LoongArch with KVM using QEMU_EFI.fd from edk2-loongarch64.
  * x86_64 with KVM, as regression coverage for the generic kexec/KHO
    changes.

Patch layout:

  1. Add the generic EFI KHO channel and its ABI.
  2. Synchronize the channel from the selected image at execution.
  3. Fix the kho_block.c header dependency exposed by LoongArch/KFENCE.
  4. Enable KHO on 64-bit LoongArch through the generic EFI channel.
  5. Add LoongArch to the KHO QEMU selftest.

Changes since v4:

  * Allocate and install the KHO table from the common EFI stub, following
    the EFI memreserve-table model (Pratyush).
  * Parse, reserve, map, and update the channel in generic EFI code; remove
    the LoongArch-specific reader, writer, and st->tables replacement
    (Pratyush, Huacai).
  * Synchronize the global channel at execution rather than image load;
    clear it for cold and crash images and use the scratch payload size.
  * Rename the GUID to LINUX_EFI_KEXEC_HANDOVER_GUID (Huacai, Pratyush).
  * Move the linux/mm.h include from luo_session.c to the actual caller,
    kho_block.c, and place the fix before architecture enablement
    (Pratyush, Huacai).
  * Boot the vmtest through EDK2, allow QEMU_EFI to override the firmware,
    and use vmlinux.efi to exercise the EFI stub and channel.
  * Keep i8042 enabled and select PCI_HOST_GENERIC instead of disabling
    the host configuration in the selftest (Huacai).
  * Enable ACPI_SPCR_TABLE and use the SPCR-provided early console.
  * Exercise the default KHO scratch-sizing path in the LoongArch vmtest;
    depend on the separately posted generic sizing fix [6].
  * Drop the generic QEMU timeout now that EFI runtime reset services make
    the LoongArch guest terminate normally.
  * Rebase onto Linux 7.3-rc1.

[1] Pratyush Yadav:
    https://lore.kernel.org/r/2vxzo6f96fmn.fsf@kernel.org/
[2] Huacai Chen:
    https://lore.kernel.org/r/CAAhV-H4PKRNCa4g=6TGepP+trtM82JiMoWgVr3O7PqbZYP9uGw@mail.gmail.com/
[3] https://lore.kernel.org/r/2vxzse4m54nz.fsf@kernel.org/
[4] https://lore.kernel.org/r/2vxzfr0l6fam.fsf@kernel.org/
[5] https://lore.kernel.org/r/202605211925.DbDvQ6ii-lkp@intel.com/
[6] https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@linux.dev/

Previous version:

v4: https://lore.kernel.org/loongarch/20260807103714.33074-1-dongtai.guo@linux.dev/

George Guo (5):
  efi: add a KHO configuration table channel
  liveupdate: synchronize EFI KHO channel at execution
  liveupdate: kho_block: include linux/mm.h for virt/phys translation
  LoongArch: enable kexec handover (KHO)
  selftests/kho: add LoongArch vmtest support

 arch/loongarch/Kconfig                     |  4 ++
 drivers/firmware/efi/Kconfig               | 12 ++++
 drivers/firmware/efi/efi.c                 | 78 ++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c    | 25 +++++++
 include/linux/efi.h                        | 36 ++++++++++
 kernel/crash_core.c                        |  7 ++
 kernel/kexec_core.c                        |  5 ++
 kernel/kexec_internal.h                    |  3 +
 kernel/liveupdate/kexec_handover.c         | 33 +++++++++
 kernel/liveupdate/kho_block.c              |  1 +
 tools/testing/selftests/kho/loongarch.conf | 11 +++
 tools/testing/selftests/kho/vmtest.sh      |  3 +-
 12 files changed, 217 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
prerequisite-patch-id: a2f06addb17cc379b9f98674f087a1642588dc6e
-- 
2.53.0

