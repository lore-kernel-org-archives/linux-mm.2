Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2774606A814
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8Ga2Jwn
Received: by kanga.kvack.org (Postfix)
	id 0B8E36B05B1; Tue,  3 Nov 2026 06:31:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F5C6B05B6; Tue,  3 Nov 2026 06:31:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E706B05B7; Tue,  3 Nov 2026 06:31:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9A796B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:31:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C8F91C3A86
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:31:47 +0000 (UTC)
X-FDA: 85393593054.26.4E19FE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D99D51C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:31:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8Ga2Jwn;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705505;
	b=67eIOiirGP1tjDm1yxQk2Owtu3rtXTLnh33u+EjtLSBxbfRKZdcxaexEmoy9nj1U9NmDFM
	dHJLj90jS/4uXAmf3Pp5lE4p+gcZq9lYwP0Bpp81XIzAVQ7JR6hKHKvXZDwEiMXcXxygoV
	pQvqnaIf0UBKZpdT07D1B3/0kzXpFk0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8Ga2Jwn;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68BubDKR1zxeKwhG2T21e3gaZzNp49Xmz5XiY4miqic=;
	b=7rO4sF9FvIN1zKsi5NIFm1rcVcc8XKZsapMD6MtGu0yqI4PHBjWaipaJFZAw9KB987PtAA
	TdCmaiuXQ4A/8HqQe46bbFwy4jjCDGY/BRDNcl/TyzXIz9YO3srZK8yFM4flf5NpU9j0eA
	LcmPxJrfyvJHO4iMRLyFV+1mqEH5hxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78B7C601EF;
	Tue,  3 Nov 2026 11:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17261F000C1;
	Tue,  3 Nov 2026 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705505;
	bh=68BubDKR1zxeKwhG2T21e3gaZzNp49Xmz5XiY4miqic=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m8Ga2Jwny1uhDUEZgw49tDrhqZSoWm2vovoo5CHk3r8paJlMIfDL5zjS8XmLwibbT
	 EZvPNwdyo2Elaz878TzCfi0joN+KUEhCrvcjOFp/ya0IZrPUMe5IxXZ5HS7cf9SDLh
	 UVvAC1DxKxHb3FCShkYoqH1gY8T1BHi1NaLoR1ZF0Pert5sK+Df0gZIfASIFhNyYu5
	 CeDDSdC+sKn6l0HVY+yT0uerZCZWy7h+lEcbqAL7h5PCf8BDvnMlNjgdoVKuPTS08Z
	 KWw7IONt7GehdF4pI41yCQVGJpbHLn69A9l78P8sxdxZ75k/fJFiIyviam/TWowCI0
	 YqzixrdPNQmTg==
Message-ID: <sashiko-outbox-195153@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] x86/unaccepted_memory: Do not accept ranges that are no
 longer E820 RAM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pankaj Gupta" <pankaj.gupta@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Kiryl Shutsemau" <kas@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261102113127.161823-1-pankaj.gupta@amd.com>
References: <20261102113127.161823-1-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:31:44 +0000
X-Stat-Signature: 9z9cx1kx7nkuard9cot7d3qjyuzxopi3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D99D51C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793705505-482525
X-HE-Meta: U2FsdGVkX1+GIF1o18MX5FnjRzdDYRJwTWqciwT5+nuJHwz/Ml99GwbSNbnESBIhc+J3aco5ru/INOMiwLgnIzgkqCXLQcZnsoXvtc7rHNnq12oH7nIVvU9i7ju/duqqc6EBz7pxl739vzNFxhxB1ZyXM6aSAkB5L7WqZSVatQdsvvSxaznrNM0N6oBYigj/vb+nPfRkiN1dqeeMWDRsZ/RT6u0+ss5X1odsLAPu7p7Dc659jsUOmWJtzBH3l4eqWFpqb1djoJZtQqsOuzxbXDS/N0mCXJz0lPyp4UJqXMBjS4VT/3em3PiOZ0jB/DLgeNSRKzWTvmc5xIeRR+vXRV+Vq/yVsP5otrkFcIeUipZYOiQu9u5wx7940WxJ1MjixjjWE0wMPp/0epL5v1xXnPtu/L/bFyugDpwGPHNmDioTcOk9r7coGj0LrJkt5D85zVu8HB5s1Pr9Jj/zN0pAGCPmpUl7LCkEMsnW+5cY9ggC9q6dSW66sQxkvJ++5/vzNp9dh52Fd8q+HmpA07vumrfv7IeP604qQ+N5SjpxAOysBlnnuQT0b1wAnb+r4mkucj5a4ZQANsUDRzZ6cq9wja9TcsP4/NuzPuV3RImOOx6web6DpK35Owu/J11VI2dNuJtviVUdlAwfibZIoQ3dWzifCAQYNg3ofJg2lePKYZhdfX1OMZ42EimMldYv13bMdbKGwj07JrGYltefFplDsdgc1X05jay2HDeeNVpAzLNfye0wWxeXchsId58AlLJzRNmviaRiLmzV8S9Hzy6eMuzb7Cjsp1RkTZB4zDjg6+q2rIaCnhFX9GKkN4CsmX2r+dCsGqw/EvJfFzGnEJfaAZqWNEWhXbt+/UR+NK1A9BD3vz5CEIg8c7ZNMfZ9H+oSOasbEoGuD3Th1wG+w4nhjx0IVMhOTIK8TE38blBXIEWgOPfBOU4nOwIfatXAEEfdO9RKcbKyoWGn7y1nM8P
 foq64wOI
 c1hc/cJH5DDBUZsgkIKSX0YVa01ROaBQhLECdKTbDJJpbGIYpe+Iack4ngnf6L1MvIUSmcQzGtWMQEhcxhrtROA4pnie8KqBdD5Gj1k+PzI5/bMkpry7fmfNn01JbefbDbmQc3oGdG600FfGVk2tKR4kdPfS8fmbAVgLY8RngQtINP024V9Fl8DPyDB9CEmypVneRYaPzXI0p9NvsFrxFgRgVJjeuX5fucWlOc1gHMNqT0UvCNEZN+sth+d2bJOhS3mQHB9xmnng1DzC730oGWcEOvLdhIl77ekXHfGyYdgfWU2mHehnSUvXvwA1qOUGxlhkX6JTocTzR4Cxuww49ea9sdiGEn8GFRCAfkyOKdofLRjDrOv/t5AA5rIXmgTZofWIDqOuw3iJL4ll461IQRgQR608dgH7b9BkHMI/xQgX7/8gsrCnOQKgAzJCbGjIezT41BitQzGU8vVmO4846IEvXhAga3NzxPnt5PlmJzmX45IyFBodP7BghEmLH43ayJskLM864B4D8xVl5roOiRD1Vt50ZgNcjIqQ0s3Xr0QbT0ZhsXxAntOLJgpUbigNjS7MlN9d4fiJ9Y4kT5hZLlwk7Lw0m6h4/eXbAfCx+LfQza4d0Crhmc0jtR7Q5mHbSRficvOLrRIlmYkSwiCkcNgAGUQaod64Fnsr+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] x86/unaccepted_memory: arch_accept_memory() desynchronizes unaccep=
ted bitmap
- [High] x86/unaccepted_memory: unaligned E820 bounds passed to __arch_acce=
pt_memory()
--

commit f56630bdf157fa53e09d29e75f1fc454adb6cd1e
Author: Pankaj Gupta <pankaj.gupta@amd.com>

x86/unaccepted_memory: Do not accept ranges that are no longer E820 RAM

This commit updates arch_accept_memory() on x86 to iterate over e820_table
and only accept subranges that are marked as E820_TYPE_RAM. This avoids
attempting to accept memory holes removed via the memmap=3D command-line
parameter.

> diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/=
asm/unaccepted_memory.h
> index f5937e9866ac1..744f1a993352c 100644
> --- a/arch/x86/include/asm/unaccepted_memory.h
> +++ b/arch/x86/include/asm/unaccepted_memory.h
> @@ -2,10 +2,11 @@
>  #define _ASM_X86_UNACCEPTED_MEMORY_H
> =20
>  #include <linux/efi.h>
> +#include <asm/e820/api.h>
>  #include <asm/tdx.h>
>  #include <asm/sev.h>
> =20
> -static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
> +static inline void __arch_accept_memory(phys_addr_t start, phys_addr_t e=
nd)
>  {
>  	/* Platform-specific memory-acceptance call goes here */
>  	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
> @@ -18,6 +19,26 @@ static inline void arch_accept_memory(phys_addr_t star=
t, phys_addr_t end)
>  	}
>  }
> =20
> +static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
> +{
> +	u32 i;
> +
> +	for (i =3D 0; i < e820_table->nr_entries; i++) {
> +		struct e820_entry *entry =3D &e820_table->entries[i];
> +		phys_addr_t s, e;
> +
> +		if (entry->type !=3D E820_TYPE_RAM)
> +			continue;

[Severity: High]
Does skipping non-E820_TYPE_RAM ranges here desynchronize unaccepted->bitmap
from the actual hardware page acceptance state across kdump and kexec?

In drivers/firmware/efi/unaccepted_memory.c:accept_memory(), unit_size-alig=
ned
range ends are extended by an extra unit_size to act as a guard page for
load_unaligned_zeropad(), and the bits in unaccepted->bitmap are cleared
unconditionally after arch_accept_memory() returns:

drivers/firmware/efi/unaccepted_memory.c:accept_memory() {
	...
	/*
	 * load_unaligned_zeropad() can lead to unwanted loads across page
	 * boundaries. The unwanted loads are typically harmless. Map an
	 * extra unit if the end of the requested range is aligned to
	 * unit_size to avoid page faults on unaccepted memory.
	 */
	if (!(end % unit_size))
		end +=3D unit_size;
	...
		arch_accept_memory(phys_start, phys_end);

		spin_lock(&unaccepted_memory_lock);
		bitmap_clear(unaccepted->bitmap, range_start, len);
	...
}

When arch_accept_memory() skips a range that is not E820_TYPE_RAM in
e820_table, accept_memory() still clears its bit in unaccepted->bitmap even
though the pages were never accepted in hardware.

In a kdump kernel, e820_table only contains the crashkernel reservation as
E820_TYPE_RAM while the panicked kernel's remaining RAM is omitted from
e820_table. When the crash kernel accepts memory up to the 2 MiB-aligned end
of crashk_res, accept_memory() extends end by unit_size into the panicked
kernel's adjacent unaccepted RAM. arch_accept_memory() skips that range, but
accept_memory() clears its bit in unaccepted->bitmap. Later, when /proc/vmc=
ore
is read, unaccepted_memory_vmcore_pfn_is_ram() checks
!pfn_is_unaccepted_memory(pfn), sees the cleared bit, and reads the
unaccepted page via read_from_oldmem(), crashing the kdump kernel.

A similar mismatch occurs with kexec: e820__memory_setup() populates
e820_table_kexec before parse_early_param() applies memmap=3D or mem=3D opt=
ions
to e820_table, andarch/x86/kernel/kexec-bzimage64.c:setup_e820_entries()
passes e820_table_kexec to the next kernel while sharing the physical
efi.unaccepted table. Both kernel/kexec_core.c:sanity_check_segment_list()
(which calls accept_memory() on kexec segment destinations placed in
e820_table_kexec RAM) and the unit_size extension at the boundary before a
memmap=3D hole will clear bits in unaccepted->bitmap without accepting the
memory in hardware, causing the kexec load or the next kernel to fault on
those pages.

> +
> +		s =3D max_t(phys_addr_t, start, entry->addr);
> +		e =3D min_t(phys_addr_t, end, entry->addr + entry->size);
> +		if (s >=3D e)
> +			continue;
> +
> +		__arch_accept_memory(s, e);

[Severity: High]
What happens if entry->addr or entry->addr + entry->size is not aligned to
PAGE_SIZE?

Entries in e820_table can have byte-granular boundaries from firmware or
command-line options such as memmap=3D and mem=3D. When memblock is set up =
in
arch/x86/kernel/e820.c:e820__memblock_setup(), partial pages are trimmed via
memblock_trim_memory(PAGE_SIZE) and left unmapped in the direct map, whereas
e820_table retains the unaligned addresses.

Clamping s and e directly to entry->addr and entry->addr + entry->size can
therefore pass non-page-aligned boundaries to __arch_accept_memory(s, e):

1. On TDX, tdx_accept_memory() -> try_accept_one() requires start to be
   aligned to at least PG_LEVEL_4K and len to be at least PAGE_SIZE:

   arch/x86/coco/tdx/tdx-shared.c:try_accept_one() {
   	...
   	if (!IS_ALIGNED(start, accept_size))
   		return 0;

   	if (len < accept_size)
   		return 0;
   	...
   }

   An unaligned s or a trailing sub-page remainder causes tdx_accept_memory=
()
   to return false and __arch_accept_memory() to call
   panic("TDX: Failed to accept memory\n").

2. On SEV-SNP, snp_accept_memory() passes vaddr =3D (unsigned long)__va(sta=
rt)
   and npages =3D (end - start) >> PAGE_SHIFT to set_pages_state(), which
   masks vaddr with PAGE_MASK. If s is not page-aligned, vaddr & PAGE_MASK
   rounds down into the unmapped partial page trimmed by
   memblock_trim_memory(PAGE_SIZE) and faults in pvalidate_pages(), while
   (e - s) >> PAGE_SHIFT can truncate npages and leave the last full page
   unaccepted.

Should s be rounded up with PAGE_ALIGN(s) and e rounded down with
PAGE_ALIGN_DOWN(e) before checking s >=3D e?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102113127.1618=
23-1-pankaj.gupta@amd.com?part=3D1

