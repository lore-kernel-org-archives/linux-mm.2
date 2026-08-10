Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2585C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C10A6B0092; Mon, 10 Aug 2026 13:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8989E6B0093; Mon, 10 Aug 2026 13:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D64C6B0095; Mon, 10 Aug 2026 13:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9B16B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:37:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C60BF40158
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:37:43 +0000 (UTC)
X-FDA: 85086067206.06.BDE2614
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B3ACC000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:37:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9zHXe+a;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786383462;
	b=tm1bgv8nfXGO8mBZlAixHGFW/qKct4f8Yrq/x8WlKbZXV1CA+u0PMTAqGVsgfkmeMk8bg2
	Cu+Y0f7bxSYwm3BoIxCv4+bNpfEYRZdimI/sPm4aaqcuI+Lj5mrcDWZ/2YXxZG61RJkgHx
	sNDEONnB0Dhwla5epp5CRhnUVisroFQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9zHXe+a;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786383462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCkjfXypJR2v+/AHSNaCI4DX4ZfH0QJoQz2XhQgPjXU=;
	b=McQozK0vFVEyXcO4uF9uMuwLlwDoQQPOXBYjVxZGDP4Li/hvAjw1TTEIGBgkfVt/rxGEJB
	veVtJFfsDtAnlcullPM1fzO6UC84gaw/nqJUBgBRCw6nmDpjOViI0uPKoHsgRgSbczavNj
	s9hvg+7zqua332kowo8CLIcivkC5QKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AC16419AC;
	Mon, 10 Aug 2026 17:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCF11F000E9;
	Mon, 10 Aug 2026 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383460;
	bh=cCkjfXypJR2v+/AHSNaCI4DX4ZfH0QJoQz2XhQgPjXU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O9zHXe+aARtSwL33CnDRJn0/woco1aLTR1Z2ZIE4QuWj35vrgiuJJdBGrLFraulje
	 Pj0zjNswaahLPJ8+fcpuSwf1M7QXI+6WN1T/AULK0vSdpkRFHOJ6q94FFTW//sAs2g
	 KqgGx3OiiQACXiIIWuRqW1g1m5zIplFu1l3shpgA0BfF85h303+OJicPsB6Uch9i5d
	 W0rdsZf0K8N+CzKUixzQ55JBeoZde4YUOL7zlG+Oh0BbWSFvJqVM7j68dBxuXPZi5V
	 RlPLho30bUzMWJU0F30JghzGH91ALkZkSmbg/2d380nZnV/b9sA9uJx1PEvpS5n7P7
	 bqfmsi1LgKrrQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  shuah@kernel.org,  ardb@kernel.org,
  guodongtai@kylinos.cn,  kernel@xen0n.name,  graf@amazon.com,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-efi@vger.kernel.org,  Kexin Liu
 <liukexin@kylinos.cn>
Subject: Re: [PATCH v4 2/4] LoongArch: kexec: add KHO support
In-Reply-To: <20260807103714.33074-3-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 7 Aug 2026 18:37:12 +0800")
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
	<20260807103714.33074-3-dongtai.guo@linux.dev>
Date: Mon, 10 Aug 2026 19:37:36 +0200
Message-ID: <2vxzo6f96fmn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 2B3ACC000C
X-Stat-Signature: tc15w1bpseowtwnemhxkh9orcfqnup15
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786383462-174323
X-HE-Meta: U2FsdGVkX18+QlSc1N3HQghy2Y+kpsQJpQeLQV/MqfoLTYkRONU1xAGEDrbs6wqroyOD5KjTOdO80wU6SZgnJs6k4aVw+/DRWpMcmDQccsU8zca2sXD1H5qSeO7KcZKxtTJrXtM7mowLS1C9bSoo06R3mtun6nxOn7TDZ65GK65zQPW6NBcWaBc9gTvBRpbLSsLpaLqRDmaWgf/7r5DXxefFK3X8SPnE7W5a10IU7Wl5K6iowKSHlgKkihDpkGTAecHkgySK4wP02XJDS7C47Tik2T5NdgCzjmkt8nbfmLqR+WR9BTgnUxXyStW2kgiriKUOb29+y8tXth5yz4yDSOQ335sc3I4nTvFRvqb3GTBkQFpeHB4NE/ux0WV/Vh2uKdIaJjnkJo3N5eRLiqHGj/joWxffF4GSv3zxPCu1BTdQgO8AFCkaDiBLgATZirDSOj5rRSabm8485jMREMcvmIiba1LxxQlQakgkqS1EgTyr00a9CzQjR0/vxGkOZgOGA8Ax3NS+JDO4FH8aJce5ebLT6ulG7kiTFV8rSD1Zada4tw5elw5uVtbnuZxKzYmM8XPFozUr+jfylCuEdZoOxj4e4W8ZQVlSFQZlBGm4nZ5U6Q9wwI+9hpJIy77IzcaxDpNTyva34PIN7Otxf27vgsoVqSaoDETLMyLEWtyBhu+0WnrWjW6Y62qhkGtVeTMx+9l/NzqUNYz6+K0tKdubO3qsp9VpbXiTLI298r6vjBEJMl7GJFhBA16DLrTZxZMoCpRHRjaD1xfSxd1gX9DtKdnGsZVq59swstu9H6fFbhc/mQP0NC+hhGu1zQhuUOXUpoOh9Y8e7HWuJkgNewdUSv2ytPpvaHDTEv+apy0extNZmlL9+aovQ1rb9CfR0hMmUGCuRPtdRevrTQTM1a2I/g4rs7eH5qKN+07IuIBpRrLYXkVMXAio/1aIBw42H8ayhVjS/+PVsTvm3gOAsf8
 raaLX6GV
 1FAFLd4DUBbkmmXWC/nJsAZDDtZlETeJCpHS9FRA4m0Er69AHQkmsYbNBRHArdhQ9jmB4OE1NUDOLyi05pfoQ0EI/CKWvhgG+c+DrxgyGZKqd3HuoWoZu5zIJTCeQSPC3lVOO3lfuQg8l7XjNgphoXwxUS1NwKn9Sfa7qlPVnX4unE/qLYg8+lzeGd1XPbztui03tT52kTerihIxKaoFsy27IR+8QPZ9e2CeruhYaErjgaZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> Enable Kexec Handover (KHO) on LoongArch64.
>
> LoongArch has no boot FDT: the efistub passes the EFI system table and
> the command line to the core kernel directly, so the arm64 /chosen path
> (append linux,kho-fdt / linux,kho-scratch and let
> early_init_dt_check_kho() read them) does not apply.  Follow the x86
> model instead, which has no boot FDT either: carry the KHO pointer out of
> band and call kho_populate() directly.  The channel is the EFI
> configuration table entry added by the previous patch.
>
> - Kconfig: ARCH_SUPPORTS_KEXEC_HANDOVER is def_bool 64BIT.
> - machine_kexec_file.c: kho_load_data() builds a small handover blob
>   (struct linux_efi_kho_data) holding the KHO state FDT and scratch
>   addresses, and a new EFI configuration table with a
>   LINUX_EFI_KHO_TABLE_GUID entry pointing to it; both are loaded as kexec
>   segments.
> - machine_kexec.c: before jumping to the next kernel, switch the EFI
>   system table to the extended configuration table.
> - setup.c: kho_populate_from_efi() scans the configuration table for
>   LINUX_EFI_KHO_TABLE_GUID and calls kho_populate() from setup_arch(),
>   after efi_init() and before memblock_init().
>
> Handover is set up by the kexec_file_load() syscall only.  kho_load_data()
> runs from load_other_segments(), which the older kexec_load() syscall does
> not reach.  This matches x86, where KHO lives in the bzImage64 loader.
>
> Tested on a LoongArch machine booting through ACPI/UEFI.  After the kexec,
> the second kernel reports
>
>   KHO: found kexec handover data.
>
> and the two-stage test passes: luo_kexec_simple --stage 1, kexec into the
> second kernel, then luo_kexec_simple --stage 2.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
[...]
> @@ -55,6 +64,121 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
>  	*cmdline_tmplen += initrd_strlen;
>  }
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +/*
> + * Hand the KHO state to the next kernel through a dedicated EFI configuration
> + * table entry.
> + *
> + * LoongArch has no boot FDT: the efistub passes the EFI system table and the
> + * command line to the core kernel directly.  So instead of the arm64 /chosen
> + * FDT path, build a small handover blob (struct linux_efi_kho_data) holding the
> + * KHO state FDT and scratch addresses, register it in the EFI configuration
> + * table under LINUX_EFI_KHO_TABLE_GUID, and let the next kernel read it and
> + * call kho_populate() directly.
> + *
> + * Both the blob and the extended configuration table are loaded as kexec
> + * segments; machine_kexec() switches st->tables to the new table before jumping.
> + *
> + * image->kho.fdt and image->kho.scratch are filled in by kho_fill_kimage()
> + * before the arch loader runs, so they are valid here.
> + */
> +static int kho_load_data(struct kimage *image)
> +{
> +	struct linux_efi_kho_data *kho;
> +	efi_system_table_t *st;
> +	efi_config_table_t *ct, *new_ct;
> +	size_t old_sz, new_sz;
> +	struct kexec_buf kbuf = {
> +		.image		= image,
> +		.buf_min	= 0,
> +		.buf_max	= ULONG_MAX,
> +		.top_down	= true,
> +	};
> +	int ret;
> +
> +	if (!image->kho.fdt || !image->kho.scratch)
> +		return 0;
> +
> +	if (!fw_arg2) {
> +		pr_err("KHO requires an EFI boot, no EFI system table found\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Build the handover blob and load it as a kexec segment. */
> +	kho = kzalloc(sizeof(*kho), GFP_KERNEL);
> +	if (!kho)
> +		return -ENOMEM;
> +
> +	kho->fdt_addr     = image->kho.fdt;
> +	kho->fdt_size     = PAGE_SIZE;
> +	kho->scratch_addr = image->kho.scratch->mem;
> +	kho->scratch_size = image->kho.scratch->memsz;
> +
> +	kbuf.buffer	= kho;
> +	kbuf.bufsz	= sizeof(*kho);
> +	kbuf.memsz	= sizeof(*kho);
> +	kbuf.buf_align	= sizeof(u64);
> +	kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
> +
> +	ret = kexec_add_buffer(&kbuf);
> +	if (ret) {
> +		kfree(kho);
> +		return ret;
> +	}
> +	image->arch.kho_data	 = kho;
> +	image->arch.kho_data_mem = kbuf.mem;
> +
> +	kexec_dprintk("Loaded KHO handover blob at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> +		      image->arch.kho_data_mem, kbuf.bufsz, kbuf.memsz);
> +	kexec_dprintk("KHO fdt at 0x%llx, scratch at 0x%llx size 0x%llx\n",
> +		      kho->fdt_addr, kho->scratch_addr, kho->scratch_size);
> +
> +	/*
> +	 * Build a new EFI configuration table with a LINUX_EFI_KHO_TABLE_GUID
> +	 * entry appended, pointing at the handover blob, and load it as a kexec
> +	 * segment.  machine_kexec() updates st->tables / st->nr_tables to point
> +	 * to it before jumping.
> +	 *
> +	 * fw_arg2 is the EFI system table physical address passed by the
> +	 * firmware/bootloader.  Use it directly because image->arch.systable_ptr
> +	 * is set later in machine_kexec_prepare(), which runs after this.
> +	 */

This looks wrong. I don't think you should be modifying the EFI
configuration table in this way. You also should have this in
architecture-agnostic code.

I'm not an EFI expert, but I took a look at how the other Linux-specific
tables work. I picked LINUX_EFI_MEMRESERVE_TABLE_GUID as my example. The
table is allocated and installed from the EFI stub (see
install_memreserve_table()). Then efi_memreserve_map_root() maps the
table and it is used by efi_mem_reserve_persistent().

You should do something similar. Allocate and install the table from the
stub, and then just update it on kexec. This would also let other
architectures use this GUID without having to reinvent this again.

> +	st = (efi_system_table_t *)TO_CACHE(fw_arg2);
> +	ct = (efi_config_table_t *)TO_CACHE((unsigned long)st->tables);
> +	old_sz = st->nr_tables * sizeof(efi_config_table_t);
> +	new_sz = old_sz + sizeof(efi_config_table_t);
> +
> +	new_ct = kvmalloc(new_sz, GFP_KERNEL);
> +	if (!new_ct)
> +		return -ENOMEM;
> +
> +	memcpy(new_ct, ct, old_sz);
> +	new_ct[st->nr_tables].guid  = LINUX_EFI_KHO_TABLE_GUID;
> +	new_ct[st->nr_tables].table = (void *)image->arch.kho_data_mem;
> +
> +	kbuf.buffer	= new_ct;
> +	kbuf.bufsz	= new_sz;
> +	kbuf.memsz	= new_sz;
> +	kbuf.buf_align	= sizeof(void *);
> +	kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
> +
> +	ret = kexec_add_buffer(&kbuf);
> +	if (ret) {
> +		kvfree(new_ct);
> +		return ret;
> +	}
> +	image->arch.efi_tables	   = new_ct;
> +	image->arch.efi_tables_mem = kbuf.mem;
> +	image->arch.efi_tables_cnt = st->nr_tables + 1;
> +
> +	kexec_dprintk("Loaded EFI config table at 0x%lx bufsz=0x%lx memsz=0x%lx nr_tables=%lu\n",
> +		      image->arch.efi_tables_mem, kbuf.bufsz, kbuf.memsz,
> +		      image->arch.efi_tables_cnt);
> +
> +	return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_CRASH_DUMP
>  
>  static int prepare_elf_headers(void **addr, unsigned long *sz)
> @@ -220,6 +344,13 @@ int load_other_segments(struct kimage *image,
>  		cmdline_add_initrd(image, &cmdline_tmplen, modified_cmdline, initrd_load_addr);
>  	}
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +	/* Load the KHO handover blob and the extended EFI configuration table */
> +	ret = kho_load_data(image);
> +	if (ret)
> +		goto out_err;
> +#endif
> +
>  	if (cmdline_len + cmdline_tmplen > COMMAND_LINE_SIZE) {
>  		pr_err("Appending command line exceeds COMMAND_LINE_SIZE\n");
>  		ret = -EINVAL;
[...]

-- 
Regards,
Pratyush Yadav

