Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED00C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 20:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4714A6B0088; Sun,  6 Sep 2026 16:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC6B6B008A; Sun,  6 Sep 2026 16:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3896B008C; Sun,  6 Sep 2026 16:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFD2A6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 16:17:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66F011C1E2F
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:17:50 +0000 (UTC)
X-FDA: 85184448300.24.2679ECF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF2E740003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:17:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqNJUzP0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788725868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3uA93cxqW2HvNr9qUovcFs04ocnOSCf6zitvtFhj/vc=;
	b=fZQYNQaNvDDRpgnLCcjr+l1i5rbkzD41yLjEt8frJ4cHyfiQ4YHTPDu0UedWLhuJCbQHuo
	SmygKqiTdM60rHIdfW3Uo7HQbKVzkIydmYo4881XOQ+Rg/cZSNaPF0tgq8BcMbYDsXc/GV
	n0OqlyMXJO9l2QO921N8HouCv7kNKgE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqNJUzP0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788725868;
	b=Q9GduIrgZVRnK9UbQbqsOVkECmBFvw2PyuglGeefExbw/2AOLYqS41AqdHsbThDA2lPe0t
	aLq0cXpw6aItg6OgOTc4C3ohzHMut6Sttm4GkBkmu17NtoOFXSo7JZHFTxooVwvvcDcbmI
	Ooqo3865gpRAiUQ8LZMlTHH1WhSDCZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E9BA40C26;
	Sun,  6 Sep 2026 20:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323381F00A3A;
	Sun,  6 Sep 2026 20:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788725867;
	bh=3uA93cxqW2HvNr9qUovcFs04ocnOSCf6zitvtFhj/vc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OqNJUzP0i6ZpwRKqxhufYQAH5I3kHVxdsoCT87l5waW4epTijN0y0zPeWiaXN5JUb
	 23WBzGGChe/MsQNytXS9qXlB+G8Y+nG4g1RIIJSYzv5ZhnU3l6NEbSLgBr0qSJSg14
	 hjWsMrBdN+py/LNBhl+18Vd2NK6kvVdAnYFLK0hTuukpq6uGC99HSh9hiIIwb2OobH
	 MF/FqwTyPgkwa3/oUOIM5Gxt6TJQUqBgU5GtS5LW2mdR8Jduh3KBQ/v21tk1TecpeS
	 mFvEkLidNfvT2xsGG/h7cTnvivMSUiQPEg6G6MRxOaDRL/6ZS0zowMbTWh6om2J3LK
	 nhYJ+2tU29SAA==
Date: Sun, 6 Sep 2026 23:17:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, chenhuacai@kernel.org,
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org, baoquan.he@linux.dev,
	ruirui.yang@linux.dev, guodongtai@kylinos.cn, kernel@xen0n.name,
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 0/5] LoongArch: add KHO support and selftests
Message-ID: <ap3KYSXQJfC0iysw@kernel.org>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
X-Stat-Signature: hqnhdw8eff78stxdp99k9rhw8gahsmo4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF2E740003
X-Rspam-User: 
X-HE-Tag: 1788725868-474827
X-HE-Meta: U2FsdGVkX19lXP/9dTYSN4qQstpuIlHdB+rFUKSpt1n7tGIosT1zFiJjuidwnXg6RHuZY3XZXFBgooYB9f2I4HwIRfoqWd2LUF5Iy3udrDbbhmBHGNgoDQo1oeJlBK2GrD3rk+JEb5m2okgyDgJ2W5lh7XmYLtIrzraFHHYKT437rMQRz+5bbgFFmcFwjd469srISFB8OREmmrhn1cZas0ICYKpwchA/hK4uktZA39oX4z5JumE9mjKzKKCMx8vs3x7UcgPvZ7fvKzFEJ4n9+bpPGWSoNo2lHCmdAxuQv283JyC8zcbeEnNrNcbuJmo1CtVbWSMdMrlZgZDifB/GoyzXTVe/cF/nWJf0nXksPUTmy10Hx2MihSo9eQU+rTaWKhYeCZV9uQLNHJirZ+VKTqWvOFLxeL23NKxDHLTw9e8jwYqXBKdnXWl0MHoj7qr7hEQiFOeI6VNI0zq255EKcUy7HeJHpIMGDJ8pIsc3Qut+gPO/piXItX9qG3Xayr6MZd6+kB2VUEKRH0KZm2B3Ht59E8EvhgOgMapkMY7OgeBbxzeoY+JhJcbQ1uOojh3LsJ3Ewn2NX+jRwfRwZVGuKy/nHzmhOFNMbgqAvNCpS0DxEQADaFTLnmh27iIOj2OMxAECifrLbZv3EbRGQh/NVkjMOfqOKhNnNN7D5t5cd1/+12bBENgloVMOIUPTmDYDsN+9Oz8O1Maq0Ly0OccfIoq19N+DjOWxfzd3+c5jHqbOsdWdkOLxO6CkcUbpbK2qDaj1VzISFspNK02o5pCklFFi9LamHQlyOiy5lDNMbWR8Evd3PYsd6vItHqbs/mHntCFKDSpA3bJNUzYQ2gFqymqdksJBE6xR7pwRHGkc9dgE+BU1QLg/iQdfZeXgM56c5OlsfDCL468//hem/lWUoCgT7Qyn3X92wWK6D3Nw1jahALBPhPSlTUnqa470JzQL6DzCE/iFap7REA8DAnW
 W9TYTN4U
 q0TMCG/wwu4dpZnvxMNDPlSUOVniS+DujDTBLo2CzYezrckT36FIyEh8z9lPbe1wdeZBLEWvVQFF5WgstQ68ZaySCEcdi2cnWlYA9K3+XhVQ91kzhaJTBbucpbihhJS7dXsP/zS6Uw2IeeyGhD3Y2oyQqQTtExbXzEYhVLYCgyehlVTlA/gTBnMC9v8bpPxLkFNx67Q7p/DxG6ZUuung7IYTYJGBw9zvKPP13IFFDsqipGbpvutepPbRWj6fN4JcyO2Hld6tQ41DQ8e2AxgYG10nN1mw+FBD17Z+jzc9uMBmrdEHM3U2s4jid1rHZpRhAWNuODlU8hCIfc7a3dzAabSarJGDAqskwBQ7w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi George,

On Fri, Sep 04, 2026 at 06:08:47PM +0800, George Guo wrote:
> This series enables Kexec HandOver (KHO) on 64-bit LoongArch and adds
> LoongArch coverage to the KHO QEMU selftest.  KHO is the remaining
> architecture gate needed by Live Update (LUO) on LoongArch.
> 
> The transport is the central problem.  Arm64 and riscv can pass the KHO
> state FDT and scratch area through properties under /chosen in a boot
> FDT.  LoongArch boots through EFI without a boot FDT, so that path is not
> available.
> 
> EFI KHO channel:

I can't say I like "transport" and "channel" terminology. We don't send
anything anywhere.
 
> v5 reworks the EFI transport following Pratyush's and Huacai's reviews
> [1, 2].  Instead of rebuilding the EFI configuration table in
> LoongArch code and switching st->tables before kexec, the common EFI stub
> allocates and installs a persistent table under
> LINUX_EFI_KEXEC_HANDOVER_GUID.  This follows the model used by
> LINUX_EFI_MEMRESERVE_TABLE_GUID.
> 
> The common EFI table parser reserves the stub-allocated table, reads it
> during early boot, and calls kho_populate().  An early initcall keeps the
> table persistently mapped so it can also be updated on the crash kexec
> path.  The implementation is architecture-independent; LoongArch only
> selects EFI_KHO when KEXEC_HANDOVER is enabled.
> 
> The EFI table is global, but kexec can keep separate normal and crash
> images and can replace a loaded candidate.  Updating the table while a
> candidate image is being loaded could therefore leave it pointing at a
> failed candidate while the previously installed image remains the one
> that will be executed.  v5 records the KHO data in struct kimage and
> synchronizes the channel from the image selected for execution.  Images
> without KHO data, including legacy and crash images, clear the channel so
> the next kernel boots cold rather than reviving stale state.
> 
> The GUID name is changed to LINUX_EFI_KEXEC_HANDOVER_GUID as suggested by
> Huacai and Pratyush [3].  Existing x86 KHO support continues to use its
> setup_data transport.  Besides supporting non-UEFI boot, that entry is
> consumed by the x86 decompressor before normal EFI table parsing, so KASLR
> only uses KHO scratch areas and does not overwrite preserved memory.  The
> new channel is installed by the generic EFI-stub entry path and relies on
> EFI_GENERIC_STUB, which x86 does not select.  Moving x86 would therefore
> require installing the table from the x86-specific EFI stub and scanning it
> in the decompressor, not just selecting EFI_KHO.
> 
> LoongArch enablement and build fix:
> 
> The architecture patch now only enables ARCH_SUPPORTS_KEXEC_HANDOVER and
> selects the generic EFI channel.  No LoongArch setup reader, kexec writer,
> or EFI system-table replacement remains.
> 
> The linux/mm.h build fix is moved from luo_session.c to kho_block.c, where
> the virt_to_phys() and phys_to_virt() calls reside after the liveupdate
> refactoring.  This addresses Pratyush's review [4].  Adding linux/mm.h to
> asm/io.h was previously attempted, but creates an include cycle under
> CONFIG_KFENCE [5].  The fix precedes LoongArch enablement so every
> intermediate commit builds with CONFIG_KFENCE=y.
> 
> Selftest:
> 
> The LoongArch vmtest boots vmlinux.efi through EDK2 because the initial
> EFI stub invocation installs the channel being tested.  QEMU_EFI can
> override the firmware filename for distributions that install it under a
> different name or path.
> 
> CONFIG_ACPI_SPCR_TABLE lets the bare earlycon parameter obtain the UART
> description from EDK2's SPCR table.  CONFIG_PCI_HOST_GENERIC keeps i8042
> enabled while ensuring that the QEMU virt machine's PCI I/O space is
> mapped before the legacy fallback probe, addressing Huacai's concern that
> the same kernel configuration should remain usable for hosts and guests.
> 
> With EFI runtime reset services available, panic=-1 and QEMU's existing
> -no-reboot option terminate the test normally.  The generic QEMU runner
> therefore remains unchanged and does not mask failures by forcibly
> terminating QEMU after a timeout.
> 
> The LoongArch vmtest uses the default KHO scratch-sizing path.  This
> series is based on the generic fix that calculates per-node scratch sizes
> before scratch allocation [6].

The text here and in the patches changelog reads reads as LLM-generated
text. First, it's quite blind and unreadable with wall-to-wall text.
Second, LLMs tend to describe what they did in the context of a session,
but since we apply the cover letter to the liveupdate tree, the description
here should *only* describe why the changes are required and how they are
implemented. The history belongs to changes since vN-1 section.

And last, but not least, please add LLM attribution as per 

https://docs.kernel.org/process/coding-assistants.html#attribution
 
> The KHO vmtest passes on:
> 
>   * LoongArch with KVM using QEMU_EFI.fd from edk2-loongarch64.
>   * x86_64 with KVM, as regression coverage for the generic kexec/KHO
>     changes.
> 
> Patch layout:
> 
>   1. Add the generic EFI KHO channel and its ABI.
>   2. Synchronize the channel from the selected image at execution.
>   3. Fix the kho_block.c header dependency exposed by LoongArch/KFENCE.
>   4. Enable KHO on 64-bit LoongArch through the generic EFI channel.
>   5. Add LoongArch to the KHO QEMU selftest.
> 
> Changes since v4:
> 
>   * Allocate and install the KHO table from the common EFI stub, following
>     the EFI memreserve-table model (Pratyush).
>   * Parse, reserve, map, and update the channel in generic EFI code; remove
>     the LoongArch-specific reader, writer, and st->tables replacement
>     (Pratyush, Huacai).
>   * Synchronize the global channel at execution rather than image load;
>     clear it for cold and crash images and use the scratch payload size.
>   * Rename the GUID to LINUX_EFI_KEXEC_HANDOVER_GUID (Huacai, Pratyush).
>   * Move the linux/mm.h include from luo_session.c to the actual caller,
>     kho_block.c, and place the fix before architecture enablement
>     (Pratyush, Huacai).
>   * Boot the vmtest through EDK2, allow QEMU_EFI to override the firmware,
>     and use vmlinux.efi to exercise the EFI stub and channel.
>   * Keep i8042 enabled and select PCI_HOST_GENERIC instead of disabling
>     the host configuration in the selftest (Huacai).
>   * Enable ACPI_SPCR_TABLE and use the SPCR-provided early console.
>   * Exercise the default KHO scratch-sizing path in the LoongArch vmtest;
>     depend on the separately posted generic sizing fix [6].
>   * Drop the generic QEMU timeout now that EFI runtime reset services make
>     the LoongArch guest terminate normally.
>   * Rebase onto Linux 7.3-rc1.
> 
> [1] Pratyush Yadav:
>     https://lore.kernel.org/r/2vxzo6f96fmn.fsf@kernel.org/
> [2] Huacai Chen:
>     https://lore.kernel.org/r/CAAhV-H4PKRNCa4g=6TGepP+trtM82JiMoWgVr3O7PqbZYP9uGw@mail.gmail.com/
> [3] https://lore.kernel.org/r/2vxzse4m54nz.fsf@kernel.org/
> [4] https://lore.kernel.org/r/2vxzfr0l6fam.fsf@kernel.org/
> [5] https://lore.kernel.org/r/202605211925.DbDvQ6ii-lkp@intel.com/
> [6] https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@linux.dev/
> 
> Previous version:
> 
> v4: https://lore.kernel.org/loongarch/20260807103714.33074-1-dongtai.guo@linux.dev/
> 
> George Guo (5):
>   efi: add a KHO configuration table channel
>   liveupdate: synchronize EFI KHO channel at execution
>   liveupdate: kho_block: include linux/mm.h for virt/phys translation
>   LoongArch: enable kexec handover (KHO)
>   selftests/kho: add LoongArch vmtest support
> 
>  arch/loongarch/Kconfig                     |  4 ++
>  drivers/firmware/efi/Kconfig               | 12 ++++
>  drivers/firmware/efi/efi.c                 | 78 ++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efi-stub.c    | 25 +++++++
>  include/linux/efi.h                        | 36 ++++++++++
>  kernel/crash_core.c                        |  7 ++
>  kernel/kexec_core.c                        |  5 ++
>  kernel/kexec_internal.h                    |  3 +
>  kernel/liveupdate/kexec_handover.c         | 33 +++++++++
>  kernel/liveupdate/kho_block.c              |  1 +
>  tools/testing/selftests/kho/loongarch.conf | 11 +++
>  tools/testing/selftests/kho/vmtest.sh      |  3 +-
>  12 files changed, 217 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kho/loongarch.conf
> 
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> prerequisite-patch-id: a2f06addb17cc379b9f98674f087a1642588dc6e
> -- 
> 2.53.0

-- 
Sincerely yours,
Mike.

