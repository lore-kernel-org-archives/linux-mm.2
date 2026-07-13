Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76FAC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D088F6B00D1; Mon, 13 Jul 2026 12:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AC16B00D2; Mon, 13 Jul 2026 12:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE7E6B00D3; Mon, 13 Jul 2026 12:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 616FF6B00D1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:21:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27BEE1C0F88
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:53:24 +0000 (UTC)
X-FDA: 84983895528.28.632A8D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 87F372000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:53:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MyCiIiJ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783950802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JZ+jUbgiNbISG81jCDR/cTHkAMPJnKZyn2UCpJwgV4=;
	b=Xc+CoSq7swm1MFJQitHMwZKpBZ+uMMex2ANDA+8t2LtZOohTkj9VaPkRjZi7GfGOWrYQXc
	SOww/E/LRmCBbeTcUV9HtWIJbBEitJXbMlYy4GfD387saS9LsOoDCVKg6fVulsJ7zUddL3
	uN4xSvd94O4CEKKlz8Zma4wMvnlqJB0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MyCiIiJ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783950802;
	b=wD0F2Ppu8MsSVS7EhSdwxmu45Z4EjSOVF0ck79vv2+NcOdT1OvnZoSMHcmJ5pDYkSD5/at
	XMieIQhcdMC4EesMOaP/jDG3firx0AeOw+l/r00B7Rtz0EZXzSiSW01AhXgzq4GqCisB4c
	4rCgy5D2fLAMoM97DZAqK7H/jZJbxW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECFD2600D8;
	Mon, 13 Jul 2026 13:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355461F000E9;
	Mon, 13 Jul 2026 13:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783950801;
	bh=1JZ+jUbgiNbISG81jCDR/cTHkAMPJnKZyn2UCpJwgV4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=MyCiIiJ4Z9PQMTe3vSTzQZjL3wKH3oq36AhbOGoKljo9Op8Y16arXocVLbzr5h8ss
	 u/Mp9/VNgcEY1+mLXvifJSjxQ7PlWOTiqsQaWARzohogCB2BMxl52A4LcnmuRENFy9
	 RnXgdT3fd7JOWjV0MPZI/0g4tCdPS3qaeQ3DuPdcRZIk2nqi6GS0f9GY5Ans2xY/1/
	 lcD5BVKPLq5vMStTF5bcK9GDjT6+XJYclDUKo6FcZpHlNoBOf3+Bzu+gEV0k/08+PV
	 KBDTWYDnUOJF2vfuHAczxsTQNf3Nf7UWXNhNLu7fu5RY+K+kdTNQRs8aUJUkVdzojM
	 7DOEsnr+LAerA==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Shuah Khan <shuah@kernel.org>,  George Guo
 <guodongtai@kylinos.cn>,  WANG Xuerui <kernel@xen0n.name>,  Alexander Graf
 <graf@amazon.com>,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,  Kexin Liu
 <liukexin@kylinos.cn>
Subject: Re: [PATCH v3 1/3] LoongArch: kexec: add KHO support for FDT-based
In-Reply-To: <20260601093930.112758-1-dongtai.guo@linux.dev> (George Guo's
	message of "Mon, 1 Jun 2026 17:39:28 +0800")
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
	<20260601093930.112758-1-dongtai.guo@linux.dev>
Date: Mon, 13 Jul 2026 15:53:17 +0200
Message-ID: <2vxzjyqzj8s2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: byuqq37pddb91atu3f5fjt3i7yjjg973
X-Rspamd-Queue-Id: 87F372000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783950802-704618
X-HE-Meta: U2FsdGVkX19pX1R3PVg8RTs8xshJbB3DEon7+ocAAQsrGWvv8R965CFGDWM+VkvT9LG5aeNBDlXvE9yggB+lKj6ppQ1oEV4Ov1gW9NpSaaf+t1hiBwNuQpmwbjKW8urXTRW26UbhG3n+4IUW4F52xggTTgbcwoLT3elVhnfm+ld7jP+b9lTpNEQGLfxqWn2itBscoD587i9LNf8q54ZpZchNTXi96ppzAl6PL6LwAk86DSbte4uxZYygQ1HQdkricydjXfhBcatvJG6Mg+FuhRRQrrl85+myTc4OJMoHM7j8ic7CSAGLvnTs4YGjy3/FmX/Z+XY03qZtx2sCdZcht2agIeNN6ssso3uzyAdDlOcNNXH9yXWhI3KExeX4Ps9F88Bo8m/LIkAi/nnq7A+ZO8RI+j3J3Bqe7nwqrLHaDaQSv0O5H2Be7HHxQZfKbjImBgxqagmPl6eAlegj4tTpV8ZgjQ1jOk4RoMH/lhL1mLbkhtCdX6+KengGiqRgdB2cH1zKEBFR8vf1f7njGfGXW1VvhSrk39siSRGmEyF5VQwor0tz20gHzxSu+1wTMjPEgN2hJTyGrxfFBcQaC+0Y6Uej9XKuTQyPeTsM50BX1k+gOnvj1c7lAx7g0j6arfTRfQTD8FhrUezPpcxIMn8X0POqgxM8mGQ2IS/2YuGDMm1RrraMmPDHDBp+9tzZHDtamU8PHdDqplVbofElO3qFlrePaNuTdP/eGoOKbt40XTfVkSeJ9nMJuVEsOEm7FG0LGnELUoQ0antpdEMJ1myKi96wN1Sw3T6rVs2kVIPio8CFbqrjX6kgiehaqcLKayy6eSsKtvEsl9Q2uWzwedGIDLgxueyQXtGlYFCPVZ5EwYssQyuxDHyaGBTLuXPa5ydxBdAVzeZ3CWxf1dCXztSKXUhJX0GTKFFtY71O1hQxyLUNE9mQSovnBbvJwX1r0L/BDrTjhXU0y6x5geXEoPI
 kZQo6JVu
 L0rK3jfJ90kJVMe/lnwJeSFJGUMn43bftzdcZE/XQuh18tpvwjcOQVy5jWTfrA/mnPfpA5fdPzmwbcOy6MyH9fQqDfHOI/5rVo8BhmaMB0JubWq5dSXDW2gUW6PIxfDV1lnli3zU95B+vfK+G74n1HFsfF2qGqWLD/tct5o4Wfmnlof866W3s9N+ofUOtAc0pRJ1z08orChPIzoVPuALJ6XsuJ5R0goZLaI5VDQzlmwkiGWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> Enable Kexec Handover (KHO) on LoongArch64 for FDT-based systems.
>
> - Kconfig: select ARCH_SUPPORTS_KEXEC_HANDOVER for CONFIG_64BIT
> - kexec.h: add fdt/fdt_mem fields to kimage_arch to hold the KHO FDT
>   kexec segment virtual and physical addresses
> - machine_kexec_file.c: add kho_load_fdt() which copies the running
>   kernel's FDT (initial_boot_params), appends linux,kho-fdt and
>   linux,kho-scratch properties to /chosen, and loads the result as a
>   kexec segment; called from load_other_segments().  Returns -EINVAL
>   when initial_boot_params is NULL (ACPI-only boot) since that path
>   requires separate handling.
> - machine_kexec.c: before jumping to the new kernel, update the
>   DEVICE_TREE_GUID entry in the EFI config table to point to the KHO
>   FDT segment so the second kernel finds it via efi_fdt_pointer() and
>   early_init_dt_check_kho() calls kho_populate()
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  arch/loongarch/Kconfig                     |   3 +
>  arch/loongarch/include/asm/kexec.h         |   4 +
>  arch/loongarch/kernel/machine_kexec.c      |  27 +++++
>  arch/loongarch/kernel/machine_kexec_file.c | 118 +++++++++++++++++++++
>  4 files changed, 152 insertions(+)
>
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index 606597da46b8..d494418545f5 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -684,6 +684,9 @@ config ARCH_SUPPORTS_KEXEC
>  config ARCH_SUPPORTS_KEXEC_FILE
>  	def_bool 64BIT
>  
> +config ARCH_SUPPORTS_KEXEC_HANDOVER
> +	def_bool 64BIT
> +
>  config ARCH_SELECTS_KEXEC_FILE
>  	def_bool 64BIT
>  	depends on KEXEC_FILE
> diff --git a/arch/loongarch/include/asm/kexec.h b/arch/loongarch/include/asm/kexec.h
> index 209fa43222e1..adf54bfcdd49 100644
> --- a/arch/loongarch/include/asm/kexec.h
> +++ b/arch/loongarch/include/asm/kexec.h
> @@ -39,6 +39,10 @@ struct kimage_arch {
>  	unsigned long efi_boot;
>  	unsigned long cmdline_ptr;
>  	unsigned long systable_ptr;
> +#ifdef CONFIG_KEXEC_HANDOVER
> +	void *fdt;		/* virtual address of KHO FDT segment buffer */
> +	unsigned long fdt_mem;	/* physical address of KHO FDT segment */
> +#endif
>  };
>  
>  #ifdef CONFIG_KEXEC_FILE
> diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
> index ad27fef098f1..98529c71d001 100644
> --- a/arch/loongarch/kernel/machine_kexec.c
> +++ b/arch/loongarch/kernel/machine_kexec.c
> @@ -6,6 +6,7 @@
>   */
>  #include <linux/compiler.h>
>  #include <linux/cpu.h>
> +#include <linux/efi.h>
>  #include <linux/kexec.h>
>  #include <linux/crash_dump.h>
>  #include <linux/delay.h>
> @@ -289,6 +290,32 @@ void machine_kexec(struct kimage *image)
>  	pr_notice("We will call new kernel at 0x%lx\n", start_addr);
>  	pr_notice("Bye ...\n");
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +	/*
> +	 * Point the EFI FDTPTR config table entry at the modified FDT so the
> +	 * second kernel picks up the linux,kho-fdt and linux,kho-scratch
> +	 * properties via early_init_dt_check_kho().
> +	 */
> +	if (internal->fdt_mem) {
> +		/*
> +		 * FDT-based system: DEVICE_TREE_GUID already exists in the EFI
> +		 * config table; just update its pointer to our KHO FDT.
> +		 */
> +		efi_system_table_t *st =
> +			(efi_system_table_t *)TO_CACHE(systable_ptr);
> +		efi_config_table_t *ct =
> +			(efi_config_table_t *)TO_CACHE((unsigned long)st->tables);
> +		unsigned long i;
> +
> +		for (i = 0; i < st->nr_tables; i++) {
> +			if (!efi_guidcmp(ct[i].guid, DEVICE_TREE_GUID)) {
> +				ct[i].table = (void *)internal->fdt_mem;
> +				break;
> +			}
> +		}
> +	}
> +#endif

Honestly this and the ACPI stuff looks worse to me than what your
previous version did. Now I am not an expert on EFI and architecture
stuff, and know nothing about Loongarch, but to me this looks hacky and
I am not sure if it is doing the right thing.

I think you should get some alignment with Loongarch maintainers on what
the kexec boot protocol looks like. It looked odd to me, but if the
Loongarch maintainers are fine with using the kernel cmdline for
bootloader to pass data to the kernel, then I think we should go back to
that.

Huacai, do you have any thoughts? For KHO we essentially need a way for
the pre-kexec kernel to tell the post-kexec kernel about a blob of
memory that has some information it can use. For x86, we do that via
setup data. See arch/x86/include/uapi/asm/setup_data.h and struct
kho_data for example. On arm64, we use the boot FDT's /chosen node. See
kho_add_chosen() in drivers/of/kexec.c.

Ideally, all device tree platforms should use the FDT path. But
Loongarch also has ACPI only and I don't know what a good idea for that
is.

So, do you have any suggestions on where to best place a pointer to this
blob of data on Loongarch? v1 of this series put it in the kernel
commandline, but I found that odd and asked if it can be done via DT
instead. But to me, this code looks even more hacky.

> +
>  	/* Make reboot code buffer available to the boot CPU. */
>  	flush_cache_all();
>  
[...]

-- 
Regards,
Pratyush Yadav

