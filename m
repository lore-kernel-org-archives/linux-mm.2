Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46809C79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E816B009D; Sun,  6 Sep 2026 22:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426BF6B009E; Sun,  6 Sep 2026 22:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C826B009F; Sun,  6 Sep 2026 22:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 050B96B009D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:10:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E8A280638
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:10:34 +0000 (UTC)
X-FDA: 85185337188.21.022AF67
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5DB4E1C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:10:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KTOdsk2B;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788747032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITrHZZ8rFti8xjokpB08YgEUYRp03SaerzjjJ5SMLDY=;
	b=dgXx1zLaUTUZBu+FOvJ1PPbC0P2XtMbpFS7041+jslF1sf4MlmW8vLahz1dOtR/wpvuIJD
	LzGsDPBuY3zoKh3t5peSMdd27qhFgtIeoq2IIZyDLl1jDAPIfurPQSJgxrKPxQq0aHyQzd
	P8+qrv8VkjHwVfA8sFia822lIGdJkAo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KTOdsk2B;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788747032;
	b=yAynGVyx2fCTTX3yLhi2Iffy6D3TEoJwCyRyJPgnhrle84Sj9hjBv/67nwkojZCfBespqN
	MC5+DFXPXPSMcYeQHzZB5TGxfpGI+nPpckbyZEyOI41zQ7ky0p2VcQMjHuenOjEymJQA0s
	udhnt8kgZh3RVvwGxqyeyjY8vWyhLuw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EbvF9Cfk/cA1UnK4pJESDFS+FSWdBEe7J8RaYNhSipA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788747030; v=1; x=1789351830;
 b=KTOdsk2BPwPmMkX4vNr9rg9mvTfk+mNhEQ28HiFtEyVa3+JXcHcPDCTAfrjmaaHbfcb8t9H1
 QyZpSiEVUTYJrNffsKQv0HOOPGg3mCdHjk5o1+yIKqlSyYJ/EbQk98t3S19KMRsfoDHRsROW0KD
 g7dH8iKai+qqw/LRFC1nmdZw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 17ffc60dbd957c97;
	Mon, 07 Sep 2026 02:10:30 +0000
X-Mizu-Trace-ID: 17ffc60dbd957c97
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 10:10:22 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
	chenhuacai@kernel.org, ardb@kernel.org, shuah@kernel.org,
	ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
	ruirui.yang@linux.dev, guodongtai@kylinos.cn, kernel@xen0n.name,
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 0/5] LoongArch: add KHO support and selftests
Message-ID: <ap4dDsKBo22t4_Jh@fedora>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
 <ap4XzvnM3WUn5ard@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap4XzvnM3WUn5ard@fedora>
X-Stat-Signature: ib9efsgk86czqi8hqwz7ypz79oe3gmbu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DB4E1C0002
X-Rspam-User: 
X-HE-Tag: 1788747032-137199
X-HE-Meta: U2FsdGVkX19RCrqxvM3CM/I+VD9iTxYSc6oQTJVqWQAjokcEFoUph/S374yo9cRHcQy1elvjmjoyy8+tuXpEH/954I/H5nQRblOWTJ3hYZhlBvOC8NSi+b7HHCcoGd4ejg/b9RZH7zSjA230OzWvsUv4sb/I3/Va3C8T7Q7J2lQ68rDWm54w+FzCrhlzPEpLh+PAF7I5I4ruEKTE8NZbTuwU24a4DGFxQadySCohHhGzC0rmtdBCNoxeSG4SPP5MRQ2kxa5EtHnXTNNSBzKc2+qEcSfi/PyimmUlnu62cbVfznKJFYyEM2ZxEdhQgBKBXy366YUD5LcDU549HgM8CqaXFzv2IYVkXOXF9affnqJERrGAwEcrd8CYgZzOVwtHZ6A2wmneXEu6gYFZB6g30actPSCr29kfWXB5D/Cdi23dtXwm8zLPOQI7gfCyG9v4sY9x5hNJhtRKvUzKiOaFZW2OkURvH/QiJGqInmsyhoJ1wyd14UsqqflnPpsKb1ScPgBjJuGQE+foXF+DgwmawNk//Bt0EP9+dcZulZvIdm4Q0SWHrC7PEMZZwmPNgm+Pwnx+LWWW6Mc6O1GgP0mjkA9smbxVm4FDvjgC48EKM/e6sUPLE1a0A0ti4WuX1cwF5ZLmZQ+0DG6aAOjxEm2QRrya3FeitPhpE0zsNoi63UFoT9xVR70rEmz6nfRWGQII/7UzqqBudi5/abw3bMH7OTsZQbLMHLO9mW6H1m0/9OBkchUPf7cRa1rwcvvahUTWO1UFhbkSMjeh4Fg6BBFUgdbfN+tuAlxIFpQZeobYuYvLxhOvagftF4VtPmJAKphHcDmUHOR7RIBdNLuP5yLowYq5bqikqcUVPMRnjxwkHERoqPVudCcOr02+jOXkL+eTxyO8OtGDI08Kg8HQ+9P2gDth5Z9V7QSD+TWsr0v5dZPEMbJQHApV62zF6aEtLWnoiksL1W8BXHWTCA86JIu
 qeeBdCxa
 caqW4F8iINwefbDBT0Qr9hlAcGL6FMCd13flqMzj94hIdLXnL6DiAhrKDE5s/4S9v1BtfzDs+bJueM3Chq1ipHQzia7mF8PMweSvIsEObFYEUVRoc9wJx3rU7vVyQ26ipRntdxW0avISerS4Dd/zWJ4Lln90MWW9IcYKkBlepKneJX7T3SLqeJqgDq20CMb+KMpy9riCBgdcyysr+JxDSon8T241GwhpLrIvQdAEHI1m0mLSuVJABajjiqLzyma3cl/FeHsVOa1O8L7JVpxSWKGND1rKzeC+OYpvxu+3lNNvI+gCZK50qgTx4iEpwvyhCyk6QmjpC/QPx3TNwn63oMa40Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/07/26 at 09:47am, Baoquan He wrote:
> On 09/04/26 at 06:08pm, George Guo wrote:
> > This series enables Kexec HandOver (KHO) on 64-bit LoongArch and adds
> > LoongArch coverage to the KHO QEMU selftest.  KHO is the remaining
> > architecture gate needed by Live Update (LUO) on LoongArch.
> > 
> > The transport is the central problem.  Arm64 and riscv can pass the KHO
> > state FDT and scratch area through properties under /chosen in a boot
> > FDT.  LoongArch boots through EFI without a boot FDT, so that path is not
> > available.
> 
> I didn't look into your patchset very carefully, but I doubt you
> are reinventing the wheel. X86 didn't have FDT, seems it introduces FDT
> for KHO support. LoongArch doesn't have FDT, so you reworks the EFI
> transport. Is there a reason you don't want to follow the standard KHO
> way using FDT too?
> 
> Please correct me if I am wrong.

I was wrong. x86 doesn't introduce FDT, it just adds a SETUP_KEXEC_KHO
entry into setup_data in setup_kho(). Please forgot about it, and sorry
for the noise.

> 
> > 
> > EFI KHO channel:
> > 
> > v5 reworks the EFI transport following Pratyush's and Huacai's reviews
> > [1, 2].  Instead of rebuilding the EFI configuration table in
> > LoongArch code and switching st->tables before kexec, the common EFI stub
> > allocates and installs a persistent table under
> > LINUX_EFI_KEXEC_HANDOVER_GUID.  This follows the model used by
> > LINUX_EFI_MEMRESERVE_TABLE_GUID.
> 
> > 
> > The common EFI table parser reserves the stub-allocated table, reads it
> > during early boot, and calls kho_populate().  An early initcall keeps the
> > table persistently mapped so it can also be updated on the crash kexec
> > path.  The implementation is architecture-independent; LoongArch only
> > selects EFI_KHO when KEXEC_HANDOVER is enabled.
> > 
> > The EFI table is global, but kexec can keep separate normal and crash
> > images and can replace a loaded candidate.  Updating the table while a
> > candidate image is being loaded could therefore leave it pointing at a
> > failed candidate while the previously installed image remains the one
> > that will be executed.  v5 records the KHO data in struct kimage and
> > synchronizes the channel from the image selected for execution.  Images
> > without KHO data, including legacy and crash images, clear the channel so
> > the next kernel boots cold rather than reviving stale state.
> > 
> > The GUID name is changed to LINUX_EFI_KEXEC_HANDOVER_GUID as suggested by
> > Huacai and Pratyush [3].  Existing x86 KHO support continues to use its
> > setup_data transport.  Besides supporting non-UEFI boot, that entry is
> > consumed by the x86 decompressor before normal EFI table parsing, so KASLR
> > only uses KHO scratch areas and does not overwrite preserved memory.  The
> > new channel is installed by the generic EFI-stub entry path and relies on
> > EFI_GENERIC_STUB, which x86 does not select.  Moving x86 would therefore
> > require installing the table from the x86-specific EFI stub and scanning it
> > in the decompressor, not just selecting EFI_KHO.
> > 
> > LoongArch enablement and build fix:
> > 
> > The architecture patch now only enables ARCH_SUPPORTS_KEXEC_HANDOVER and
> > selects the generic EFI channel.  No LoongArch setup reader, kexec writer,
> > or EFI system-table replacement remains.
> > 
> > The linux/mm.h build fix is moved from luo_session.c to kho_block.c, where
> > the virt_to_phys() and phys_to_virt() calls reside after the liveupdate
> > refactoring.  This addresses Pratyush's review [4].  Adding linux/mm.h to
> > asm/io.h was previously attempted, but creates an include cycle under
> > CONFIG_KFENCE [5].  The fix precedes LoongArch enablement so every
> > intermediate commit builds with CONFIG_KFENCE=y.
> > 
> > Selftest:
> > 
> > The LoongArch vmtest boots vmlinux.efi through EDK2 because the initial
> > EFI stub invocation installs the channel being tested.  QEMU_EFI can
> > override the firmware filename for distributions that install it under a
> > different name or path.
> > 
> > CONFIG_ACPI_SPCR_TABLE lets the bare earlycon parameter obtain the UART
> > description from EDK2's SPCR table.  CONFIG_PCI_HOST_GENERIC keeps i8042
> > enabled while ensuring that the QEMU virt machine's PCI I/O space is
> > mapped before the legacy fallback probe, addressing Huacai's concern that
> > the same kernel configuration should remain usable for hosts and guests.
> > 
> > With EFI runtime reset services available, panic=-1 and QEMU's existing
> > -no-reboot option terminate the test normally.  The generic QEMU runner
> > therefore remains unchanged and does not mask failures by forcibly
> > terminating QEMU after a timeout.
> > 
> > The LoongArch vmtest uses the default KHO scratch-sizing path.  This
> > series is based on the generic fix that calculates per-node scratch sizes
> > before scratch allocation [6].
> > 
> > The KHO vmtest passes on:
> > 
> >   * LoongArch with KVM using QEMU_EFI.fd from edk2-loongarch64.
> >   * x86_64 with KVM, as regression coverage for the generic kexec/KHO
> >     changes.
> > 
> > Patch layout:
> > 
> >   1. Add the generic EFI KHO channel and its ABI.
> >   2. Synchronize the channel from the selected image at execution.
> >   3. Fix the kho_block.c header dependency exposed by LoongArch/KFENCE.
> >   4. Enable KHO on 64-bit LoongArch through the generic EFI channel.
> >   5. Add LoongArch to the KHO QEMU selftest.
> > 
> > Changes since v4:
> > 
> >   * Allocate and install the KHO table from the common EFI stub, following
> >     the EFI memreserve-table model (Pratyush).
> >   * Parse, reserve, map, and update the channel in generic EFI code; remove
> >     the LoongArch-specific reader, writer, and st->tables replacement
> >     (Pratyush, Huacai).
> >   * Synchronize the global channel at execution rather than image load;
> >     clear it for cold and crash images and use the scratch payload size.
> >   * Rename the GUID to LINUX_EFI_KEXEC_HANDOVER_GUID (Huacai, Pratyush).
> >   * Move the linux/mm.h include from luo_session.c to the actual caller,
> >     kho_block.c, and place the fix before architecture enablement
> >     (Pratyush, Huacai).
> >   * Boot the vmtest through EDK2, allow QEMU_EFI to override the firmware,
> >     and use vmlinux.efi to exercise the EFI stub and channel.
> >   * Keep i8042 enabled and select PCI_HOST_GENERIC instead of disabling
> >     the host configuration in the selftest (Huacai).
> >   * Enable ACPI_SPCR_TABLE and use the SPCR-provided early console.
> >   * Exercise the default KHO scratch-sizing path in the LoongArch vmtest;
> >     depend on the separately posted generic sizing fix [6].
> >   * Drop the generic QEMU timeout now that EFI runtime reset services make
> >     the LoongArch guest terminate normally.
> >   * Rebase onto Linux 7.3-rc1.
> > 
> > [1] Pratyush Yadav:
> >     https://lore.kernel.org/r/2vxzo6f96fmn.fsf@kernel.org/
> > [2] Huacai Chen:
> >     https://lore.kernel.org/r/CAAhV-H4PKRNCa4g=6TGepP+trtM82JiMoWgVr3O7PqbZYP9uGw@mail.gmail.com/
> > [3] https://lore.kernel.org/r/2vxzse4m54nz.fsf@kernel.org/
> > [4] https://lore.kernel.org/r/2vxzfr0l6fam.fsf@kernel.org/
> > [5] https://lore.kernel.org/r/202605211925.DbDvQ6ii-lkp@intel.com/
> > [6] https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@linux.dev/
> > 
> > Previous version:
> > 
> > v4: https://lore.kernel.org/loongarch/20260807103714.33074-1-dongtai.guo@linux.dev/
> > 
> > George Guo (5):
> >   efi: add a KHO configuration table channel
> >   liveupdate: synchronize EFI KHO channel at execution
> >   liveupdate: kho_block: include linux/mm.h for virt/phys translation
> >   LoongArch: enable kexec handover (KHO)
> >   selftests/kho: add LoongArch vmtest support
> > 
> >  arch/loongarch/Kconfig                     |  4 ++
> >  drivers/firmware/efi/Kconfig               | 12 ++++
> >  drivers/firmware/efi/efi.c                 | 78 ++++++++++++++++++++++
> >  drivers/firmware/efi/libstub/efi-stub.c    | 25 +++++++
> >  include/linux/efi.h                        | 36 ++++++++++
> >  kernel/crash_core.c                        |  7 ++
> >  kernel/kexec_core.c                        |  5 ++
> >  kernel/kexec_internal.h                    |  3 +
> >  kernel/liveupdate/kexec_handover.c         | 33 +++++++++
> >  kernel/liveupdate/kho_block.c              |  1 +
> >  tools/testing/selftests/kho/loongarch.conf | 11 +++
> >  tools/testing/selftests/kho/vmtest.sh      |  3 +-
> >  12 files changed, 217 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kho/loongarch.conf
> > 
> > 
> > base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> > prerequisite-patch-id: a2f06addb17cc379b9f98674f087a1642588dc6e
> > -- 
> > 2.53.0

