Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D64CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91596B0005; Mon, 25 May 2026 13:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68BE6B0088; Mon, 25 May 2026 13:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6C36B008A; Mon, 25 May 2026 13:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9AF6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:34:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CC3D140171
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:34:19 +0000 (UTC)
X-FDA: 84806641038.12.833D3DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C06D9C000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:34:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLRQc51x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779730457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+TFxqIXPU3VCPLnw7RW5OtUkFdNMFAF+NsqUfzupL4=;
	b=ohMMCif+0EhLVEaaM4Ye4fi/yzlLLVGl9ACNLEPy5/6oq66RhsCqfifC1ZGa114dcKgUA4
	3g0ZxCgHjReBtt1MuWKNSm90ioxtq8oJJiLp029s5mvalNxgHHrnjgYcS4rwMV8woLiTlK
	2xv7ciSG10D0eJR/yeLb9E9UfMCLPRk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLRQc51x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779730457; a=rsa-sha256;
	cv=none;
	b=XbgLr+Vrn9K19zNiEomfXifjKwJszHVb+5EACByx+droLR+NiywDn7wCWpHrB0wp9HUtVp
	vInRZ7EgutiCPtyT/tYTnQTbDjNSUow514W0acAnZHKp8adZxr4tAwzwrpeuqob0r5lACi
	CBDlzi4/bLy2P/cSBhSlWvBzUAQVCUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 333DE60008;
	Mon, 25 May 2026 17:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A91F000E9;
	Mon, 25 May 2026 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779730456;
	bh=C+TFxqIXPU3VCPLnw7RW5OtUkFdNMFAF+NsqUfzupL4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BLRQc51xnmjpgz7uLm3xMNEwcc1GYJVNNP7dDwDxorp/cxpwTcS5L9pSBA/55VMS2
	 n7FFwqL0UekJmAS3JpvGt7HRhu0m1d/50P0JAx5ozgQx5rgfmmsAuQPHAlr20cQEee
	 umscdxKjF/t31OQDGxK+wHqCFnZwvRueEx2gU01rnZo2wIgo+KqiVA7Vm4ywE+6yOy
	 QhpULFvc7mtx7R/IOyoYCej9/9eZRaJVrRPB1KOZ/XBbpwuOCbbToRWNWR7DWhqaWc
	 TGv6trHHWpX3PrJHUhdg+ObhA8ZLpHkZbwzc0quM8Mbb41lRlRhXX+iGNAGDathkVt
	 Dww60ge05YMjw==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  kernel@xen0n.name,  graf@amazon.com,
  shuah@kernel.org,  loongarch@lists.linux.dev,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-kernel@vger.kernel.org,  George Guo <guodongtai@kylinos.cn>,  Kexin
 Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH 1/7] LoongArch: Add KHO basic support
In-Reply-To: <20260525062810.103367-2-dongtai.guo@linux.dev> (George Guo's
	message of "Mon, 25 May 2026 14:28:04 +0800")
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
	<20260525062810.103367-2-dongtai.guo@linux.dev>
Date: Mon, 25 May 2026 19:34:13 +0200
Message-ID: <2vxztsrv5r6y.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ean7huam3njbuk3n8ao6zspy7aqcdhiz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C06D9C000D
X-Rspam-User: 
X-HE-Tag: 1779730457-748838
X-HE-Meta: U2FsdGVkX1+n5s66SDMydkgzi+GahrzuiV9HlC30BjmAVFD6+uG5jTwNDbIc6Rrz6qCE1nfI0RwtK0i9mP/x52vbhnpG/CTbj5aaIh9LlPJeTsPgu3I14BsinxQmVbgFVb1d5bZekFM2xolPtH31286YlMFPNIDASYvBKJOtLMtGqxeQX67hZLrEMi0Wps0jbXkdhty5UjCwBaAuOcgcuJGeKI+7d5WlQcbydnvVRu7ZWnBV6zIDr/PpCpDy4vzayBMiSOeFsqmNhGUu/GuTK1Igc0j2wbw27qiGiQYbqbK/HPuuMi3dGMluGuI26+U9JfX+zkVp2R76QuZLwMazVFN9jt5Q3si0cq6uS/Kju67EF1i6TprQeUMNXUdasVSO+hYH0I/vLgzLdY6Mi2TNldVaBmEMM/yrIqAxckdPbUoZeTChaB3/WNQt3cGDX1EpXWDVD7Qbim0BRI1+aL5ND1qA0/ax0Yy/IkC+halofelAYAy/z7+L65GQr2LwZ1c5ENGcpwO1tYRPDRqHNLlbavAPL20+NlwGSsy5l1BnYElqt0KPS8pcEg7FGtm8rN5Tq9DaALdeVH1VXBWyFQxFPMe5pUz+4OzAuULzjALb4eK7vHrYsCk0K0bxdoYKYeMX3BIFo3Cc3kvc2j4aoflxUmHfguDrOouANoxIZVsmQl7RxsXT89v7VuDAxUZcixsZfbu3t/hmm5pBJO6F8QiHbSkoDwmp+44XxFzDdEkcZSQY+54DDZ01/5vktOLSOFNAxmUD2cEmpTAeZgPX6ZwlQq4pLiyaTkO0FeSIdTdMuXHNsFd+CMEl2T1jyZ0Zk/NYogoQgLCEKi4S6wSkdc6OEcjTtP1iauN0eowL/2oUmotAZfOikyrydhwFP4DKHURq/fS0sNyvLHeDsYQYbgrZyWuAhJazPxRgaC6ztz/f1mNUnIw1PxZqXWFROLP6dHqbpeYf+52JewdPJkY4BQ6
 wN+FLwzP
 Icn31IWzkETnVAls2BgWcUbfHAvdbz84atZ3mNpHcotoObEAWOYxHuEA8y8SS9Uo+7M/2djw2Hf6LTodcF+egir7hb9sBWwGPYGasvWs7lSI8N0/8QGi1lR38bWhZGd+S1gKjSnnaJNpOkmC0f0BFScAgWdqhTfg20zGmurjPoSLGXaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> Enable Kexec Handover on LoongArch64:
>
> - Kconfig: select ARCH_SUPPORTS_KEXEC_HANDOVER for 64BIT
> - machine_kexec_file: add cmdline_add_kho() to pass the KHO FDT and
>   scratch buffer addresses to the next kernel via the "kho_handover="
>   command-line parameter
> - setup: parse "kho_handover=" early and call kho_populate() to hand
>   memory regions to the KHO core
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  arch/loongarch/Kconfig                     |  3 +++
>  arch/loongarch/kernel/machine_kexec_file.c | 22 ++++++++++++++++++
>  arch/loongarch/kernel/setup.c              | 27 ++++++++++++++++++++++
>  3 files changed, 52 insertions(+)
>
[...]
> diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
> index 5584b798ba46..ddf4d0e0e7fd 100644
> --- a/arch/loongarch/kernel/machine_kexec_file.c
> +++ b/arch/loongarch/kernel/machine_kexec_file.c
> @@ -55,6 +55,24 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
>  	*cmdline_tmplen += initrd_strlen;
>  }
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +/* Add "kho_handover=<fdt_size>@<fdt_addr>,<scratch_size>@<scratch_addr>" to cmdline. */
> +static void cmdline_add_kho(struct kimage *image, unsigned long *cmdline_tmplen,
> +			    char *modified_cmdline)
> +{
> +	int n;
> +
> +	if (!image->kho.fdt || !image->kho.scratch)
> +		return;
> +
> +	n = sprintf(modified_cmdline + *cmdline_tmplen,
> +	    "kho_handover=0x%llx@0x%llx,0x%lx@0x%llx ",
> +	    (u64)PAGE_SIZE,               image->kho.fdt,
> +	    image->kho.scratch->bufsz,    (u64)image->kho.scratch->mem);
> +	*cmdline_tmplen += n;

Do you have nothing else for a bootloader to pass data to the kernel?
Passing this via the command line seems crazy... All these addresses are
now available directly to unprivileged userspace. Can't you use the
device tree like we do on ARM64?

Also, this commandline parameter isn't documented anywhere.

> +}
> +#endif
> +
>  #ifdef CONFIG_CRASH_DUMP
>  
>  static int prepare_elf_headers(void **addr, unsigned long *sz)
> @@ -220,6 +238,10 @@ int load_other_segments(struct kimage *image,
>  		cmdline_add_initrd(image, &cmdline_tmplen, modified_cmdline, initrd_load_addr);
>  	}
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +	cmdline_add_kho(image, &cmdline_tmplen, modified_cmdline);
> +#endif
> +
>  	if (cmdline_len + cmdline_tmplen > COMMAND_LINE_SIZE) {
>  		pr_err("Appending command line exceeds COMMAND_LINE_SIZE\n");
>  		ret = -EINVAL;
> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
> index 839b23edee87..5934ba6f13e3 100644
> --- a/arch/loongarch/kernel/setup.c
> +++ b/arch/loongarch/kernel/setup.c
> @@ -48,6 +48,7 @@
>  #include <asm/setup.h>
>  #include <asm/time.h>
>  #include <asm/unwind.h>
> +#include <linux/kexec_handover.h>
>  
>  #define SMBIOS_BIOSSIZE_OFFSET		0x09
>  #define SMBIOS_BIOSEXTERN_OFFSET	0x13
> @@ -227,6 +228,32 @@ static int __init early_parse_mem(char *p)
>  }
>  early_param("mem", early_parse_mem);
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +static int __init early_parse_kho(char *p)
> +{
> +	phys_addr_t fdt_addr, scratch_addr;
> +	u64 fdt_size, scratch_size;
> +
> +	if (!p)
> +		return -EINVAL;
> +
> +	fdt_size = memparse(p, &p);
> +	if (*p++ != '@')

Can you please wrap these in parenthesis? I am too dumb to remember all
the precedence rules and this immediately makes me question whether we
are doing (*p)++ or *(p++).

> +		return -EINVAL;
> +	fdt_addr = memparse(p, &p);
> +	if (*p++ != ',')
> +		return -EINVAL;
> +	scratch_size = memparse(p, &p);
> +	if (*p++ != '@')
> +		return -EINVAL;
> +	scratch_addr = memparse(p, &p);
> +
> +	kho_populate(fdt_addr, fdt_size, scratch_addr, scratch_size);
> +	return 0;
> +}
> +early_param("kho_handover", early_parse_kho);
> +#endif
> +
>  static void __init arch_reserve_vmcore(void)
>  {
>  #ifdef CONFIG_PROC_VMCORE

-- 
Regards,
Pratyush Yadav

