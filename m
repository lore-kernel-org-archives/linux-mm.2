Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BCB606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LeUcH5/C
Received: by kanga.kvack.org (Postfix)
	id 98E836B008C; Sat, 24 Oct 2026 07:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966496B0092; Sat, 24 Oct 2026 07:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3716B0095; Sat, 24 Oct 2026 07:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62A256B008C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:16:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9651120353
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:16:39 +0000 (UTC)
X-FDA: 85357266918.06.925F9C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2D47C1C0009
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:16:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LeUcH5/C";
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792840598;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Zbp6hwg8Ccxg77Nh+HU8tqPsmnjtWe7rjEvXgWG/LM=;
	b=eNRPFxpOb0LqtyLGGbIvyZyA4O6fi6SJ44G7yaIzzAClJzNuKpIXlDtmpSLJNo9zkxKZCd
	xw2nC1mKNodvb9RNLhu2m7uHXMe5Pj7I5o9zujm75dMsRNgciD9WILTmHfcmiAhkxNx57Z
	AemUe4+i05i2wqX7dO8KNTuIzwquhjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792840598;
	b=gKSVxlkovgmMbQsHHhPXEaggrtelJSCiXN+vcTeQpAB+5C1UdfUT7Jw9f4RkI4o6tEeEE+
	DJk3Ny4nj8A60zptU1WvbNKXna0JjO987WVBNmtd3CFNt5WcCp0jmeGQOD+e8x3kgfCB0S
	0wsBI5yX2sJD/MBW5k8fUoTJxlBpr40=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LeUcH5/C";
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E3B660A52;
	Sat, 24 Oct 2026 11:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9841F01825;
	Sat, 24 Oct 2026 11:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792840597;
	bh=/Zbp6hwg8Ccxg77Nh+HU8tqPsmnjtWe7rjEvXgWG/LM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LeUcH5/CLGo+IP45EjHeSOa7VZVNrX1SXGxpUAEPredzfGIiMjCwjvKPKBSRZUj9/
	 z98zDrgFPA7+kOC6k+qlrMUld3wcbZWs4VaUQ/r+qE1GJ2ZSF3JAHN4VAiGVuWmhmC
	 mCMfRzdUxBsxLZpvvkLxXpEvpwdQNYjhcrPELDlhuRxVvi6mkayL37k0MW4ZBjDM/Q
	 RcfftQuBRLyNw5gj8NXfWnH95oC1rpemluxTgrECQaF7xVabkaIDbRx2V84lMDAzVt
	 HaRHITxX5WS+Ed4ZG3L39CYx4HWk5/wxQ2Q4gk1flUUcpynZoIUMrnL6hHfOpHPii/
	 lW7vrYJHzK5ZQ==
Message-ID: <sashiko-outbox-183678@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] riscv: Add support for kexec handover (KHO)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Pei" <cp0613@linux.alibaba.com>, pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, shuah@kernel.org
Cc: guoren@kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20261023111612.2134-3-cp0613@linux.alibaba.com>
References: <20261023111612.2134-1-cp0613@linux.alibaba.com>
 <20261023111612.2134-3-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 11:16:36 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D47C1C0009
X-Stat-Signature: qbmyzubmuozhj4aoct1ghxsj6dey8xst
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792840598-954850
X-HE-Meta: U2FsdGVkX19HpOpUH2A2BQXYQvK/vNEeTTspbj3rARu1CjbenuRDfpFWaPIN9Dz8B8UrBRDT3m6FvItS1MT0fSko9N62QApqO2afX3RYbZT12GspnrhPFjbMWxMPK0E1cPjz1ydpGYstQe20XuAYvNlxJx34AGMMz0BvXl8rrjXuQjAIHbhfGvq6AHXTapHunH1XJ9PKoDhZWVzsSAC1GC9CaPHTdUIdPgkQXNaxaJyiOzVtThpUpNuayjCzeDq4XDuYA/lUk4ZXxr1uiR37tSz7kfUSKiWdvF8lEfft+0On4DPqsdwXuD3Ua+btK1jtBbKw7l98qafJ1N78d1nHyv244nY41KNL//FxLyJ77xNCOotWv10ChDYOE42PZr5lJmsY1YESrH2bigl1ZGvPkzj3kD6oqUFRtHeHQQ6lfsZL+dYRKr1y70P1vc/pq/irpB2tVXM26BXsX1EBGRGH6D1Qyq9vu4oFnPAH/x1xIul/Wmq6014KcpoxGCb9EQsdX+7I6rddSr0YoXDQTKmUslUB6LR3sbm8WFnmJTuH0BxediyscG9iQwD1n+gYCwWI5nrzcb7OzYylzWMLnGmwNSOgRXuCQE5PMs1HgIrDdV1UgKLMyl+DYEPZmujJ1X5mfUq6rixl867mR615Gh8AfDkh9uAa8yFTVGKmPcnQbZ10fc+MEHVAy+JQCWuTB6bnDmD0BKRw+cZEAUBeQzwe+w2jOhMhN75Ckibfr+DjNtt13NQ0r8/+NZwA3M1hkypDZWyFf9d8GL0xLuG/acZqNxpagaqhJEQrvJCr8cD+ZnFN587meqsN+bDcuYT1QJAYALT6P9GJSMXZHSZ+nrTHhLxSK/YFpNXTZ/LMJI0cytXUJx/b6Vj3iGBNijjUVXr83U4QTw/M0YFHfYcmnyOMsYpWXFlmgCMZGaZAPr5jl2YH34kbxQrNSpVwVGuWOzGAc6pjWZK8aG7kyVjzy79
 D+S1HQsr
 gy6rVRJ69L5+lykCWaxgXfSH88OZVDXgs+qH7Wfjgpjr8qYywGiJxP3oP8fZ3ot5DanGUPX2BnXtWhB2xNV2WHUB2FF1NkYz63nRqqF0lLEdDYghD9D8KqdBNHNStAvvRSxmPkZbOXHjt0jguImt+CYWArB8xRZpr6mPnYoo27Ts0SGqFztDk1rFBgE3wfeCACO9eZns2gGM2yYMDzAF9J36+mznj2Jn/rz7j95vbnWaWwRjpTzSOY0VFMymSsZsfFT4xTpOB7VJa8XvVtk28E0H8bFzGDrmtLGrPvxqtSepVbe4xv5sUV8F5QS9mDYi80ovTmJ13RcKb+lise+ZGgIb4nY3c5FV70SUeSWDA+j/dG+7F5zqkFkj25yiLPiovnj3/IBUaFDg8iD/2yzRju3VpzZ44e+d1E1gMa8Y8H/7FSAa4UkLEbOrLxJuXI2qZaGZR34l2LMEDKKxYIob8OZSmAiFn11d1mqLwTZCv7MbuAzm1er5X/blbEt92PCrtu7LAAfeJBq2aGrGQ0I/VTKVruzWj544hkN3NyHZ1KPopFDwqYsOwsMZclAUbpApwhdPpM+Ej9UIQYQ/klWRLp6EHfQ==
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
- [High] riscv: kho: BUG_ON() in linear_mapping_pa_to_va() during efi_init()
- [Medium] riscv: kho: bootmem reservation fails when DRAM starts at or abo=
ve 4 GiB
--

commit 82f9788fea5dca057c5c8476c422bb40724521df
Author: Chen Pei <cp0613@linux.alibaba.com>

riscv: Add support for kexec handover (KHO)

This commit enables ARCH_SUPPORTS_KEXEC_HANDOVER on 64-bit RISC-V systems
with MMU support so that kexec handover (KHO) can be used on RISC-V.

> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index e7891a2a89da6..a5c56252ff44a 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
>  config ARCH_SUPPORTS_KEXEC_PURGATORY
>  	def_bool ARCH_SUPPORTS_KEXEC_FILE
> =20
> +config ARCH_SUPPORTS_KEXEC_HANDOVER
> +	def_bool 64BIT && MMU

[Severity: High]
Can enabling ARCH_SUPPORTS_KEXEC_HANDOVER trigger a BUG_ON() in
linear_mapping_pa_to_va() during efi_init() when booting a KHO kexec kernel
on a 64-bit RISC-V UEFI system?

In arch/riscv/kernel/setup.c:setup_arch(), parse_dtb() runs before
efi_init(), and efi_init() runs before paging_init():

    parse_dtb();
    setup_initial_init_mm(_stext, _etext, _edata, _end);

    *cmdline_p =3D boot_command_line;

    early_ioremap_setup();
    sbi_init();
    jump_label_init();
     parse_early_param();

    efi_init();
    paging_init();

During parse_dtb(), early_init_dt_scan() -> early_init_dt_check_kho() ->
kho_populate() sets kho_in.fdt_phys to the physical address of the handover
FDT.

Next, efi_init() -> reserve_regions() in drivers/firmware/efi/efi-init.c
checks is_kho_boot(), which calls kho_get_fdt() in
kernel/liveupdate/kexec_handover.c:

    static const void *kho_get_fdt(void)
    {
            return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
    }

However, on 64-bit RISC-V, kernel_map.va_pa_offset is initialized to 0UL in
setup_vm() and is not populated until paging_init() -> setup_bootmem() in
arch/riscv/mm/init.c:

    /*
     * In 64-bit, any use of __va/__pa before this point is wrong as we
     * did not know the start of DRAM before.
     */
    if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_MMU))
            kernel_map.va_pa_offset =3D PAGE_OFFSET - phys_ram_base;

When CONFIG_DEBUG_VIRTUAL=3Dy is enabled, calling phys_to_virt(kho_in.fdt_p=
hys)
before setup_bootmem() reaches linear_mapping_pa_to_va() in
arch/riscv/mm/physaddr.c:

    void *linear_mapping_pa_to_va(unsigned long x)
    {
            BUG_ON(!kernel_map.va_pa_offset);

            return ((void *)((unsigned long)(x) + kernel_map.va_pa_offset));
    }

Would this panic the incoming kernel during efi_init() (or compute an
untranslated address in kho_get_fdt() when CONFIG_DEBUG_VIRTUAL=3Dn)?

[Severity: Medium]
Also, will kho_reserve_bootmem() fail on 64-bit RISC-V platforms where DRAM
starts at or above 4 GiB, or record a 0-byte region when all DRAM lies below
4 GiB?

Unlike arm64 (which defines ARCH_LOW_ADDRESS_LIMIT via arm64_dma_phys_limit=
),
RISC-V uses the default ARCH_LOW_ADDRESS_LIMIT of 0xffffffffUL from
include/linux/memblock.h, while arch_mm_preinit() in arch/riscv/mm/init.c
supports systems where memblock_start_of_DRAM() >=3D dma32_phys_limit (4 Gi=
B)
or max_pfn <=3D PFN_DOWN(dma32_phys_limit).

In kernel/liveupdate/kexec_handover.c:kho_reserve_bootmem(), both the lowmem
and global allocations are performed unconditionally without checking wheth=
er
bootmem_size_lowmem or bootmem_size_global is 0:

    size =3D bootmem_size_lowmem;
    addr =3D memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
                                     ARCH_LOW_ADDRESS_LIMIT);
    if (!addr) {
            pr_err("Failed to reserve lowmem bootmem\n");
            goto err_free_bootmem_desc;
    }

    kho_bootmem[i].addr =3D addr;
    kho_bootmem[i].size =3D size;
    i++;

    /* reserve large contiguous area for allocations without nid */
    size =3D bootmem_size_global;
    addr =3D memblock_phys_alloc(size, BOOTMEM_ALIGNMENT_BYTES);
    if (!addr) {
            pr_err("Failed to reserve global bootmem\n");
            goto err_free_bootmem_areas;
    }

On systems where all DRAM starts at or above 4 GiB, bootmem_size_lowmem is 0
and memblock_phys_alloc_range(0, BOOTMEM_ALIGNMENT_BYTES, 0,
ARCH_LOW_ADDRESS_LIMIT) finds no memory below 0xffffffffUL, returning 0 and
disabling KHO. Conversely, on systems where all DRAM is below 4 GiB,
bootmem_size_global is 0 and memblock_phys_alloc(0, BOOTMEM_ALIGNMENT_BYTES)
records a 0-byte entry in kho_bootmem[].

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023111612.2134=
-1-cp0613@linux.alibaba.com?part=3D2

