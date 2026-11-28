Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A624606A688
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 02:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=wl6gPvEb
Received: by kanga.kvack.org (Postfix)
	id 1A99A6B05B0; Fri, 27 Nov 2026 21:19:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159E86B05B1; Fri, 27 Nov 2026 21:19:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048EA6B05B2; Fri, 27 Nov 2026 21:19:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D64FD6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:19:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F6141A050C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:19:12 +0000 (UTC)
X-FDA: 85482920544.06.CC6A7A1
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf20.hostedemail.com (Postfix) with ESMTP id 308811C0008
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:19:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wl6gPvEb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795832350;
	b=vxl9A5vEnRO7P+RAwMoCqzSRHCV/abqPKUFpXEXG3K8SNbTxdia9xhOkVQEsX86EnEysKA
	2wmp3UiMf06EiUm5ilFw464HT8gmalwfllk0DqkzgHCWKMiV8A5B3io56ccxDoCNUFIuRJ
	oM2ftK2vJBFEpBmF1KHi3YisSpAALcA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795832350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZiLbeveVkP0thWq6lXBRnjI4/oS76xhNlaIHRsGwXI=;
	b=axJqibVNTQYn7SeAy1iOaubp/XR1pZv2ESSX5y1dlF32a0iHFxj/1pz6QSzYHNazK3pmTj
	oUWKL0dM20mHy+FjCfBm93rZO88XhM1RoDwDig50bBgoFmQ29v1FI0idPKk0aZXbv5T1cU
	LQRuqUQbRg2MJc6G7M6DSqVMunke6IE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wl6gPvEb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HZiLbeveVkP0thWq6lXBRnjI4/oS76xhNlaIHRsGwXI=;
	b=wl6gPvEb8+GbDNNj0Igr3ynb5fLY54UN8ir/arw4RT8N4XcxGf6b4e2TsKYfaErA97c21omUh
	9NJPI8/bB1k8Quxo1eFSqwsMZDnYh6r8JrXrKbhWN6rmvW/QIPXRnXyaBDOJDioODOuD+MDpA+X
	L8fDffTxns7RVHqRIsC7vF4=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jbv904pYxz1prKm;
	Sat, 28 Nov 2026 10:18:44 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 4879540538;
	Sat, 28 Nov 2026 10:19:03 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 28 Nov
 2026 10:19:01 +0800
Message-ID: <6339810b-1666-441c-a8b8-17bfb885fc8f@huawei.com>
Date: Sat, 28 Nov 2026 10:19:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/8] crash_core: fold duplicated memblock arch hooks
 into the weak default
To: Wandun Chen <chenwandun1@gmail.com>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<robh@kernel.org>, <baoquan.he@linux.dev>, <rppt@kernel.org>,
	<m.szyprowski@samsung.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <saravanak@kernel.org>,
	<akpm@linux-foundation.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <robin.murphy@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-riscv@lists.infradead.org>,
	<devicetree@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <iommu@lists.linux.dev>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
 <20261127090723.741253-3-chenwandun1@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20261127090723.741253-3-chenwandun1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Queue-Id: 308811C0008
X-Stat-Signature: 8o337qugt4np43guxegtfagrjnq4aua1
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795832349-203832
X-HE-Meta: U2FsdGVkX1/fmn98fZG2OUEziGflgMj1mXOIKvn2rr8GobVtNQvXtYQGlw7hsN6VXydlijI7K0MA9+HUTCYPliBAM+sKqCKk3O0pSqUbDJz6EBNxqGaJNWraAUatG8Vy7HLLEOIApv1JJLvPoHccbmWDjudcBxcqTvabKAYMYmWwlDf4q9n/QBLqIjxtNaY4O4uoBRc932bK/Ow5Oh2EuyI11XYJNwtHutwxxarSs6MMJlOzEdX08Gjt9+4zD7FUma9itHyaRCRbowTJ9aYYPaakxzN3M6z97KZHQKOpPEG+zBjTIYAHn/nCV54l3s1UPO+8siuhs8BgBKwS9yKyJdST72tRn9I+tUenO+Og9B52pQFfN7V6sNyfQOwgy8Geyjrb/ADNDIXOXE6rXG0roSTrXvW6c/k/Wg634ivAQeZuRpIKmykDzJS30HtjTCDEKzVY4i4PH6EW79zoO2q6x0qIbkHcREDrSgvOmOoqF1ilEMVpxyUEMVQzjxSTLzE6BH90VJYJqU5afArVynGJR6EskML1g1XR0uGofCiOfy9XpZZhFESlesZSjfY66vD6cq6IlUeu8solQptOrVtPr2AacC8ZqUEVo/VWrS3BAJUcw6RPleuM0e/NfclOcx90gGeRZ4uCOlov3L2l9FCO5kvSlreMnp/+t6AQ/hmIDBC1LuhLFQLMy58Nf/sd4INtSIUwsvGrKc9ieJDmXxV3NGDLy9Jhxf0cn+fvIl/YMueXl3N2urTf30I0154eJEPoJmFG1jzcYBLOmd6n5zZkRWD4HwFZ/+de49JqHN7yTedznlfoU5EqJ/kuL/m3J5GzhTgdMU5HSP8Ky+fnXbXrujAeozM14leEYDuX78GixX/c4DDJLanSyEUHxTsJExAIa7hs6rVhH+biPph/zvQIlW0FgxlhPc2flcUJYZ8sT6pn82nYxBS0cOXXoL1sb+PLw2dKLC0V7kkS8x8PboP
 W/YxeUFR
 UWKRszluN6RuFpHovgyCC/1UBFlmWKmFjCzG/+fhG0es1aROs/MMrvEcmRNgn5bmfQ1A1ygUUtGKX6Y/bNisskEyTcvnSg1bWGxswMXNgBOOHWVjz+NJW0g0alXCmQBVz6Vt76B7Nstt/YtIDGBZ8DWFcZJvnRRGDTeWlGpH1DwKZH5XY7GigAEXj0v6baJEh97ITxu2gGZShP3U8p7cvfmf7O+HVcEiDpQVTL2xml4rjsbaCmtGjLTKVvtKyeE5zsxvjqYjTTqSp7qSBCfRQ0o37TBwJafHcaqZCyqN8FFb74MOm7CNbjjCo0pViR3Npwm5iTwSULgdOXbcCoTq48pl0k6c6rAf4YrrJsBkn1DFTbmOgzyZJliaurz/P/bhckiq/8z24UAt3izYv0ZPfgSsYLYP1V53LX5dn8KQuXf3UZ28dVn2AVQDHDjxepAfBWN15WdeLvuk91aRlNWEHHlsi0R9LqJI9MnmD7FLMTIGXAXGseJqZTEkK9T++SduaDBA33PrN978BC27IsD9Dwe+c/u3xCJsUgSNk4LlzIMovaqhjP0/4K44tV841QO6oSEpApb3zrdQHLmszKHCHSG0RIcH9mAs1imDuqeOfljjRPqsGx5sxFGf2vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/27 17:07, Wandun Chen 写道:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> arm64, loongarch and riscv open-code the same memblock walk in
> arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
> the __weak defaults in kernel/crash_core.c and delete the arch copies.

The code looks good, but shouldn't the commit message also mention x86
and loongarch? Loongarch does not implement crash CMA reservation, so
crashk_cma_cnt is 0. x86 has its own arch hook implementation, so the
__weak implementation will be overridden by the arch implementation.

otherwise, LGTM
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

Best regards,
Jinjie

> 
> No functional change.
> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> Acked-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  arch/arm64/kernel/machine_kexec_file.c     | 29 ----------------------
>  arch/loongarch/kernel/machine_kexec_file.c | 27 --------------------
>  arch/riscv/kernel/machine_kexec_file.c     | 26 -------------------
>  kernel/crash_core.c                        | 27 ++++++++++++++++++++
>  4 files changed, 27 insertions(+), 82 deletions(-)
> 
> diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
> index 14f453dd0946..18695f01043c 100644
> --- a/arch/arm64/kernel/machine_kexec_file.c
> +++ b/arch/arm64/kernel/machine_kexec_file.c
> @@ -14,7 +14,6 @@
>  #include <linux/kernel.h>
>  #include <linux/kexec.h>
>  #include <linux/libfdt.h>
> -#include <linux/memblock.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
>  #include <linux/slab.h>
> @@ -39,34 +38,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  	return kexec_image_post_load_cleanup_default(image);
>  }
>  
> -#ifdef CONFIG_CRASH_DUMP
> -unsigned int arch_get_system_nr_ranges(void)
> -{
> -	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* for exclusion of crashkernel region */
> -	phys_addr_t start, end;
> -	u64 i;
> -
> -	for_each_mem_range(i, &start, &end)
> -		nr_ranges++;
> -
> -	return nr_ranges;
> -}
> -
> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> -{
> -	phys_addr_t start, end;
> -	u64 i;
> -
> -	for_each_mem_range(i, &start, &end) {
> -		cmem->ranges[cmem->nr_ranges].start = start;
> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> -		cmem->nr_ranges++;
> -	}
> -
> -	return 0;
> -}
> -#endif
> -
>  /*
>   * Tries to add the initrd and DTB to the image. If it is not possible to find
>   * valid locations, this function will undo changes to the image and return non
> diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
> index 0fe60907b97f..bef459287683 100644
> --- a/arch/loongarch/kernel/machine_kexec_file.c
> +++ b/arch/loongarch/kernel/machine_kexec_file.c
> @@ -13,7 +13,6 @@
>  #include <linux/ioport.h>
>  #include <linux/kernel.h>
>  #include <linux/kexec.h>
> -#include <linux/memblock.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
> @@ -56,32 +55,6 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
>  }
>  
>  #ifdef CONFIG_CRASH_DUMP
> -unsigned int arch_get_system_nr_ranges(void)
> -{
> -	int nr_ranges = 2; /* for exclusion of crashkernel region */
> -	phys_addr_t start, end;
> -	uint64_t i;
> -
> -	for_each_mem_range(i, &start, &end)
> -		nr_ranges++;
> -
> -	return nr_ranges;
> -}
> -
> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> -{
> -	phys_addr_t start, end;
> -	uint64_t i;
> -
> -	for_each_mem_range(i, &start, &end) {
> -		cmem->ranges[cmem->nr_ranges].start = start;
> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> -		cmem->nr_ranges++;
> -	}
> -
> -	return 0;
> -}
> -
>  /*
>   * Add the "mem=size@start" command line parameter to command line, indicating the
>   * memory region the new kernel can use to boot into.
> diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
> index dad7f02365d3..fdc6695e8588 100644
> --- a/arch/riscv/kernel/machine_kexec_file.c
> +++ b/arch/riscv/kernel/machine_kexec_file.c
> @@ -37,32 +37,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  }
>  
>  #ifdef CONFIG_CRASH_DUMP
> -unsigned int arch_get_system_nr_ranges(void)
> -{
> -	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
> -	phys_addr_t start, end;
> -	u64 i;
> -
> -	for_each_mem_range(i, &start, &end)
> -		nr_ranges++;
> -
> -	return nr_ranges;
> -}
> -
> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> -{
> -	phys_addr_t start, end;
> -	u64 i;
> -
> -	for_each_mem_range(i, &start, &end) {
> -		cmem->ranges[cmem->nr_ranges].start = start;
> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> -		cmem->nr_ranges++;
> -	}
> -
> -	return 0;
> -}
> -
>  static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
>  				 unsigned long cmdline_len)
>  {
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index d0bd2d0cf899..faa0f22dbb41 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -281,8 +281,35 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
>  	return cmem;
>  }
>  
> +#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
> +unsigned int __weak arch_get_system_nr_ranges(void)
> +{
> +	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
> +	phys_addr_t start, end;
> +	u64 i;
> +
> +	for_each_mem_range(i, &start, &end)
> +		nr_ranges++;
> +	return nr_ranges;
> +}
> +
> +int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
> +{
> +	phys_addr_t start, end;
> +	u64 i;
> +
> +	for_each_mem_range(i, &start, &end) {
> +		cmem->ranges[cmem->nr_ranges].start = start;
> +		cmem->ranges[cmem->nr_ranges].end = end - 1;
> +		cmem->nr_ranges++;
> +	}
> +	return 0;
> +}
> +#else
>  unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
>  int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
> +#endif
> +
>  int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
>  
>  int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,


