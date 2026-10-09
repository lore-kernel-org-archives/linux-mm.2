Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592DECA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 02:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A12A6B008A; Thu,  8 Oct 2026 22:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CCD6B008C; Thu,  8 Oct 2026 22:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F358B6B0092; Thu,  8 Oct 2026 22:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C11DE6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 22:16:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D82291A01F1
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:16:54 +0000 (UTC)
X-FDA: 85301474748.23.CE786FC
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD4121A0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:16:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpwduiCz;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791512212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HzF21b7wH+OCi6BgDNq8o3oZ/2tI5ENlGWlmHfz0R4=;
	b=wNacKFuwdUsX5+BZBSkQacOnyIw49YWr5nxGMAxXCY0uRwocLXqp/aHYZ9z/Tht4bRjnRV
	o/d6U9uC6fBxvm5QCu4GAnDQOl8k5obBoNUyElaW9CZHiX9drXxgwsB7lVxPeAbacHH73V
	31yLYF8zRxZ9UGpCiSt18lT19kBGH3g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpwduiCz;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791512212;
	b=DQq3egnTz9ZhX0fopjQafpZ3m88oSO0pGldrGyh7j8NoVzAvLMDgpW3MpuCAP/vJtyBOo+
	NwbnAPVyPDRPBWx8/1+RklWzf2l9mKGLpWPnonZYe8hUUtl4XPqWKwdRUdIsTYIZXRpsJL
	5TgEyeQkMomCMtmEE3wH0dNffNDXe10=
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-3a51696a650so3260055a91.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 19:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791512211; x=1792117011; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3HzF21b7wH+OCi6BgDNq8o3oZ/2tI5ENlGWlmHfz0R4=;
        b=YpwduiCzx98ZEFgvf+wKcarAMCzLbpFeAGDJsyvux880lY6c4aCagpiqQqEiGZP6za
         me+BHQlx1hM0Wd25vK9dlcQcFB08TcFyqVOu1HGsEfVugh+UtNkwz2IQ0Ok+DZSWw6o/
         A7cfSM5cf6itkLg/tISFhgTp/QS6tA2hqE8wBRBXjLGzK5LcG8PfXyZBXG9JwiWCCVcV
         YZpSxP6scOXu6sGg16pNHzXRRMNDXW+8bRyqgz9gmrK0xrLepl87bAAgBjfwBODIzb9C
         RkmoCiRm5eqBhE57hrV+thMXqODW8B/9dnshB855VmFvGxCcY0EN1h9UcM8rkHz8dVvL
         3M5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791512211; x=1792117011;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3HzF21b7wH+OCi6BgDNq8o3oZ/2tI5ENlGWlmHfz0R4=;
        b=mQMs5bHuHVDAiQfEBtnl08EkCJKqTlbMJQELEfr6CYvXJx2KkPHVSoTGZ5SbJneenK
         wzAJzK4KjjejO6Golbu60UoOWJ6iFHf3P33IuQXmjlqxO11peHhYu4UjTdTM363lHQdX
         IjQid/v2sT0eyabgoeFHRTr+Kmp5euLrf4e+ejags9DDxkWz6xj2UfwnIQK7Ivf+P9Mf
         6edLj/ZmiJGMQoc1ooCqj91sM3QU8ocQZkRDW/EWMsAdVzGr2qn4gDV1eVme+Ru9aO0E
         1uDbnxbg5/REixW+n/bvmfHVaXXR+2B5n8u6vPi1axVmj0VlKcMjf/Tf5o+lYrawd/ko
         LEWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwS3y4ezwOAFKB3qDghggSWBFg1YdRHots5n0BYY6AT8r19BA1UTYfoD0RVHqk4WB7zWT+jUdR4UA==@kvack.org
X-Gm-Message-State: AFq9FYIfF7dh5EpsDEAy8YwAG6CjlNUeMhxAue245L9Kractbe6gMXi4
	pNCe2c+3X+lMNhxf/zOElIPfPFYL23Q613cRAUFOkT+iAf5GDzIhX/XR
X-Gm-Gg: AYBFou2gqeBEeYgA63bxeuiUkvRTXVsRe/9kXQOPp/gcJwWSh209m/GyqkyXUKTJ/Z7
	XekcqicJmLRqR43XoeklxXWuLJmhayZ/7UrbhQoHNOL9bfpwSRs28NrIyVzbNWH1vOiVOrAk0xF
	J7zkTxdVB/YYbze3ZVNKvlMrNywHhavxYkY1Z/27ke/jk85DaZLvgOlEaCOxRy+mBJxz8mI99bm
	emPfRNt5cyYvu+wU/klMOVpB6ZQSL9e26GrZxlP3gEXZwaBgA6EF/O52IcZkhHZutVgQvGREYWm
	9Z0qqS8mzfeK9uCKlZJqbRcAV6fbs1bVtJarMAqrUx7e4Ri38usr13nNWwbjbsyzCyggMFzc/xJ
	4uhpXoOjaWkrlQ7ftlNU8btXe6AL+jxoxdZrV3kosZkGIW4x0e0wOC0dZQ9uJyNVVi2Ux2LtCM0
	2vGs2SGO9IY4cIOaAKXh1CB3IbAYmfCg/TaOk1aaSCKGiU0aLPHQDFSX0s6JaO2uv2lh0W+dYzO
	wSwrw==
X-Received: by 2002:a17:90b:1d4f:b0:3aa:6b5d:a00a with SMTP id 98e67ed59e1d1-3ab3ac7912fmr583653a91.53.1791512211401;
        Thu, 08 Oct 2026 19:16:51 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36ed040dsm1605868a91.6.2026.10.08.19.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 19:16:50 -0700 (PDT)
Message-ID: <a8ac6daa-e721-4cba-bef3-3333643db23d@gmail.com>
Date: Fri, 9 Oct 2026 10:16:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Rob Herring <robh@kernel.org>,
 Saravana Kannan <saravanak@kernel.org>,
 Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20261008152403.766439-1-m.szyprowski@samsung.com>
 <CGME20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331@eucas1p1.samsung.com>
 <20261008152403.766439-3-m.szyprowski@samsung.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <20261008152403.766439-3-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD4121A0002
X-Stat-Signature: jx17o5xuh1pjiisp1cxtensrers4y3xp
X-HE-Tag: 1791512212-123680
X-HE-Meta: U2FsdGVkX1+Mm1Cp90UgpV4hgCyW/toNZCw8RRMc+7uklIwphEMxYlHJz/Ca/YF5f8nzP6+A7PN0GiNYheDM3YDm8DhJ8qqCgI5LJJ8VRzN0AU9C10EiKuTgXWb9KHuYb+bBVNnrRsM0L0nMI1f5J7oYNzCzexQODs3KxA03Sgfg8rk+yTj43SUMNtQL+RkgFXsX9Dd1X5qPNoWDRz1QzDG9jhty+eWxqvkAdxGsdPuOsHpNICunuyaJBry2/Eu5/H93y0KTkkOpjXQQL3T8lhbEG97LZdCPNCdIqfZRWedRCkgQbPQ/WQbcn1u69R5MMoGtPUdgHiYVDPnCSqbQ0ykdmylk6hah0Q9Hue2m47Qnee6obx1W7P8VsKWPfupVk83KY5j9nnMEDXhRgFQw2Zf/IE8JCnHetgnlKBoNZ6NSUxLFTeTxHctDptSSL4g7t6BLnak+SK0G8LMxSf+f0gVzePteLZGwoPTPHL81MyishIwS2oHrpMh/qjIBckxRAcMjNYw8Y8gPjVsqFSsXGFRTIZWr3xhToBFkFcD7LEX/BkObAg7ewP/ZUjWK7WiXm2nJSW91sDnI8c0I5auff+MKqAYOwXyiLmECTXQaGkOZ+TugOov48xQwH0V3QvoVloiU03DeBbIrONZHZh4Qe4j/T4i7i9MH+1SDabbm4of/fq2hJU8yXOEuLMg2OxooP8VDBmR0HUcL5cwMTKIUArUpDHSObB3pvPDw7qtWBauC7kva4Pp9VquG7r654F35QXNk+QQ8tMbm/ticaJU33D5z0WkHEfL9yS0sMpqc90z9y0WnKO8IzMUjYgM/JRUi5TfybbpuyVIHNbqeSQPG5XE+e05Us8QGFxsIcjAn9akm3EjrWisrhM/1JgEYtiYD099dehYxiYXE3MPboYi7HxYi61bXox8tK3xkyinDpf2A2HcKjv6yJYnPc45lM6UOp8BgQkZvaib2FfdHiYo
 WIXrRaMz
 UMzjH+jqyMkHuICouBOEleadf/7NG3uX5akyUTNf3Ch4YY9B03CkZ3oLORvWaDLgti1W8VAf102uSuR2QQHA1xthJloeMFk2t73X2/n+t9S1O024qGAPV8LB5dJU1HmoHTkDWjJs8pGyMtkqLUJ8yncFNPN4WHCUF/HqmOJj0R0K9tvkpBQtLjPCVwTke1BGwSABfY5mBYep0HnZv2zocMzDo4/rV5yHc5qkap9uKeVkr/O8VirOuF146nEP13/jauLa7m7UtEwZGXdsKa+3e1FapuRLxvLlNJ5PbMSG5GDtMoseNID7Griv4AKEkgyaSP+2iUk5F9ZuP2aYZ/7KTvwYxraoKA9xFET3t/JOyvKvfO8wEvxkKZypiM/CkLN60DIY3Po+AZstGpLXdKsedXHZuyhxc1REDpRy2CeCeleK7ewRnGIeGrsZfFq5SzgkPfigKvSlUr/6a6ruyD7LZhG2TRQyt3oneHWN0RxFvrhVBO5Dq4wz4zcUMOB0uvsNzxBA8AEBeXdTDfLaWamsl/BxX0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/8/26 23:24, Marek Szyprowski wrote:
> Get rid of the static, limited-size reserved_mem array and replace it
> with array allocated by memblock_alloc_raw() and accessed through a
> temporary early_memremap() mapping. Such mapping is needed for some
> architectures (like ARM64), where linear map is not yet available during
> early boot scan. Having a single, writeable array with all reserved
> regions removes the need to perform two step initialization introduced
> by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
> memory regions are processed"), so all regions can be processed
> directly during the early scan again.

One concern about the ordering here: the new memblock_alloc_raw() for the
reserved_mem array runs *before* the static ("reg") regions are reserved,
so the array can be allocated from inside one of them which makes the
subsequent static region reservation fail.


Best regards,
Wandun

> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
> Assisted-By: LLM
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/fdt.c             |   3 -
>  drivers/of/of_private.h      |   2 -
>  drivers/of/of_reserved_mem.c | 247 +++++++++++++----------------------
>  3 files changed, 92 insertions(+), 160 deletions(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index ecc923102622..a58efdcbac7f 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -1283,9 +1283,6 @@ void __init unflatten_device_tree(void)
>  {
>  	void *fdt = initial_boot_params;
>  
> -	/* Save the statically-placed regions in the reserved_mem array */
> -	fdt_scan_reserved_mem_late();
> -
>  	/* Populate an empty root node when bootloader doesn't provide one */
>  	if (!fdt) {
>  		fdt = (void *) __dtb_empty_root_begin;
> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
> index 0ae16da066e2..895f868b4cfa 100644
> --- a/drivers/of/of_private.h
> +++ b/drivers/of/of_private.h
> @@ -9,7 +9,6 @@
>   */
>  
>  #define FDT_ALIGN_SIZE 8
> -#define MAX_RESERVED_REGIONS    64
>  
>  /**
>   * struct alias_prop - Alias property in 'aliases' node
> @@ -186,7 +185,6 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
>  #endif
>  
>  int fdt_scan_reserved_mem(void);
> -void __init fdt_scan_reserved_mem_late(void);
>  
>  bool of_fdt_device_is_available(const void *blob, unsigned long node);
>  
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 300fb236ab59..8d8fa7242d4a 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -24,12 +24,12 @@
>  #include <linux/slab.h>
>  #include <linux/memblock.h>
>  #include <linux/kmemleak.h>
> +#include <asm/early_ioremap.h>
>  
>  #include "of_private.h"
>  
> -static struct reserved_mem reserved_mem_array[MAX_RESERVED_REGIONS] __initdata;
> -static struct reserved_mem *reserved_mem __refdata = reserved_mem_array;
> -static int total_reserved_mem_cnt = MAX_RESERVED_REGIONS;
> +static struct reserved_mem *reserved_mem __refdata;
> +static int total_reserved_mem_cnt;
>  static int reserved_mem_count;
>  
>  static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
> @@ -59,56 +59,46 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
>  }
>  
>  /*
> - * alloc_reserved_mem_array() - allocate memory for the reserved_mem
> - * array using memblock
> + * reserved_mem_array_map() - make the freshly allocated reserved_mem array
> + * accessible during early boot
>   *
> - * This function is used to allocate memory for the reserved_mem
> - * array according to the total number of reserved memory regions
> - * defined in the DT.
> - * After the new array is allocated, the information stored in
> - * the initial static array is copied over to this new array and
> - * the new array is used from this point on.
> + * On some architectures (i.e. ARM64) the linear mapping is not yet usable when
> + * the reserved memory regions are scanned, so the array has to be accessed
> + * through a temporary early mapping.
>   */
> -static int __init alloc_reserved_mem_array(void)
> +static struct reserved_mem * __init reserved_mem_array_map(struct reserved_mem *array,
> +							   size_t size)
>  {
> -	struct reserved_mem *new_array;
> -	size_t alloc_size, copy_size, memset_size;
> -	int ret;
> +	if (IS_ENABLED(CONFIG_GENERIC_EARLY_IOREMAP))
> +		return early_memremap(__pa(array), size);
> +	else
> +		return array;
> +}
>  
> -	if (!total_reserved_mem_cnt)
> -		return 0;
> +static void __init reserved_mem_array_unmap(struct reserved_mem *map, size_t size)
> +{
> +	if (IS_ENABLED(CONFIG_GENERIC_EARLY_IOREMAP))
> +		early_memunmap(map, size);
> +}
>  
> -	alloc_size = array_size(total_reserved_mem_cnt, sizeof(*new_array));
> -	if (alloc_size == SIZE_MAX) {
> -		ret = -EOVERFLOW;
> -		goto fail;
> -	}
> +/*
> + * count_reserved_mem_nodes() - count the nodes that might need an entry in the
> + * reserved_mem array
> + */
> +static int __init count_reserved_mem_nodes(const void *fdt, int node)
> +{
> +	int child, len, count = 0;
>  
> -	new_array = memblock_alloc(alloc_size, SMP_CACHE_BYTES);
> -	if (!new_array) {
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> +	fdt_for_each_subnode(child, fdt, node) {
> +		if (!of_fdt_device_is_available(fdt, child))
> +			continue;
>  
> -	copy_size = array_size(reserved_mem_count, sizeof(*new_array));
> -	if (copy_size == SIZE_MAX) {
> -		memblock_free(new_array, alloc_size);
> -		ret = -EOVERFLOW;
> -		goto fail;
> +		/* static regions use 'reg', dynamic ones use 'size' */
> +		if ((of_flat_dt_get_addr_size_prop(child, "reg", &len) && len) ||
> +		    (of_get_flat_dt_prop(child, "size", &len) && len))
> +			count++;
>  	}
> -
> -	memset_size = alloc_size - copy_size;
> -
> -	memcpy(new_array, reserved_mem, copy_size);
> -	memset(new_array + reserved_mem_count, 0, memset_size);
> -
> -	reserved_mem = new_array;
> -	return 0;
> -
> -fail:
> -	pr_err("Failed to allocate memory for reserved_mem array with err: %d", ret);
> -	reserved_mem_count = 0;
> -	return ret;
> +	return count;
>  }
>  
>  static void fdt_init_reserved_mem_node(unsigned long node, const char *uname,
> @@ -169,6 +159,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
>  
>  	if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
>  		fdt_fixup_reserved_mem_node(node, base, size);
> +		fdt_init_reserved_mem_node(node, uname, base, size);
>  		pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
>  			 uname, &base, (unsigned long)(size / SZ_1M));
>  	} else {
> @@ -381,143 +372,89 @@ static void __init __rmem_check_for_overlap(void)
>  	}
>  }
>  
> -/**
> - * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
> - * memory regions.
> - *
> - * This function is used to scan again through the DT and initialize the
> - * "static" reserved memory regions, that are defined using the "reg"
> - * property. Each such region is then initialized with its specific init
> - * function and stored in the global reserved_mem array.
> - */
> -void __init fdt_scan_reserved_mem_late(void)
> -{
> -	const void *fdt = initial_boot_params;
> -	phys_addr_t base, size;
> -	int node, child;
> -
> -	if (!fdt)
> -		return;
> -
> -	node = fdt_path_offset(fdt, "/reserved-memory");
> -	if (node < 0) {
> -		pr_info("Reserved memory: No reserved-memory node in the DT\n");
> -		return;
> -	}
> -
> -	/* Attempt dynamic allocation of a new reserved_mem array */
> -	if (alloc_reserved_mem_array())
> -		return;
> -
> -	if (__reserved_mem_check_root(node)) {
> -		pr_err("Reserved memory: unsupported node format, ignoring\n");
> -		return;
> -	}
> -
> -	fdt_for_each_subnode(child, fdt, node) {
> -		const __be32 *prop;
> -		const char *uname;
> -		u64 b, s;
> -		int ret;
> -		int len;
> -
> -		if (!of_fdt_device_is_available(fdt, child))
> -			continue;
> -
> -		prop = of_flat_dt_get_addr_size_prop(child, "reg", &len);
> -		if (!prop || !len)
> -			continue;
> -
> -		ret = fdt_validate_reserved_mem_node(child, NULL);
> -		if (ret && ret != -ENODEV)
> -			continue;
> -
> -		of_flat_dt_read_addr_size(prop, 0, &b, &s);
> -		base = b;
> -		size = s;
> -
> -		if (size) {
> -			uname = fdt_get_name(fdt, child, NULL);
> -			fdt_init_reserved_mem_node(child, uname, base, size);
> -		}
> -	}
> -
> -	/* check for overlapping reserved regions */
> -	__rmem_check_for_overlap();
> -}
>  
>  /*
>   * fdt_scan_reserved_mem() - reserve and allocate memory occupied by
>   * reserved memory regions.
>   *
> - * This function is used to scan through the FDT and mark memory occupied
> - * by all static (defined by the "reg" property) reserved memory regions.
> - * Then memory for all dynamic regions (defined by size & alignment) is
> - * allocated, a region specific init function is called and region information
> - * is stored in the reserved_mem array.
> + * This function is used to scan through the FDT and count the number of
> + * reserved memory regions, so the reserved_mem array can be allocated with
> + * the exact size. Then all static (defined by the "reg" property) reserved
> + * memory regions are marked as reserved, memory for all dynamic regions
> + * (defined by size & alignment) is allocated, a region specific init function
> + * is called and region information is stored in the reserved_mem array.
>   */
>  int __init fdt_scan_reserved_mem(void)
>  {
> -	int node, child;
> -	int dynamic_nodes_cnt = 0, count = 0;
> -	int dynamic_nodes[MAX_RESERVED_REGIONS];
> +	struct reserved_mem *array, *map;
> +	size_t array_bytes;
> +	int node, child, cnt;
>  	const void *fdt = initial_boot_params;
>  
>  	node = fdt_path_offset(fdt, "/reserved-memory");
> -	if (node < 0) {
> -		total_reserved_mem_cnt = 0;
> +	if (node < 0)
>  		return -ENODEV;
> -	}
>  
>  	if (__reserved_mem_check_root(node) != 0) {
>  		pr_err("Reserved memory: unsupported node format, ignoring\n");
> -		total_reserved_mem_cnt = 0;
>  		return -EINVAL;
>  	}
>  
> -	fdt_for_each_subnode(child, fdt, node) {
> -		const char *uname;
> -		int err;
> +	/* First pass: count the entries needed for the reserved_mem array */
> +	cnt = count_reserved_mem_nodes(fdt, node);
> +	if (!cnt)
> +		return 0;
>  
> -		if (!of_fdt_device_is_available(fdt, child))
> -			continue;
> +	array_bytes = array_size(cnt, sizeof(*array));
> +	array = memblock_alloc_raw(array_bytes, SMP_CACHE_BYTES);
> +	if (!array) {
> +		pr_err("Failed to allocate memory for reserved_mem array\n");
> +		return -ENOMEM;
> +	}
>  
> -		uname = fdt_get_name(fdt, child, NULL);
> +	map = reserved_mem_array_map(array, array_bytes);
> +	if (!map) {
> +		pr_err("Failed to map memory for reserved_mem array\n");
> +		memblock_free(array, array_bytes);
> +		return -ENOMEM;
> +	}
> +	memset(map, 0, array_bytes);
>  
> -		err = __reserved_mem_reserve_reg(child, uname);
> -		if (!err)
> -			count++;
> +	reserved_mem = map;
> +	total_reserved_mem_cnt = cnt;
>  
> -		/*
> -		 * Save the nodes for the dynamically-placed regions
> -		 * into an array which will be used for allocation right
> -		 * after all the statically-placed regions are reserved
> -		 * or marked as no-map. This is done to avoid dynamically
> -		 * allocating from one of the statically-placed regions.
> -		 */
> -		if (err != -ENOENT || !of_get_flat_dt_prop(child, "size", NULL))
> +	/* Second pass: reserve and initialize the static regions */
> +	fdt_for_each_subnode(child, fdt, node) {
> +		if (!of_fdt_device_is_available(fdt, child))
>  			continue;
>  
> -		if (dynamic_nodes_cnt == MAX_RESERVED_REGIONS) {
> -			pr_err("too many defined dynamic regions, skip '%s'\n",
> -			       uname);
> +		__reserved_mem_reserve_reg(child,
> +					   fdt_get_name(fdt, child, NULL));
> +	}
> +
> +	/*
> +	 * Allocate the dynamically-placed regions only after all the
> +	 * statically-placed regions are reserved or marked as no-map. This
> +	 * is done to avoid dynamically allocating from one of the
> +	 * statically-placed regions.
> +	 */
> +	fdt_for_each_subnode(child, fdt, node) {
> +		int len;
> +
> +		if (!of_fdt_device_is_available(fdt, child) ||
> +		    (of_flat_dt_get_addr_size_prop(child, "reg", &len) && len))
>  			continue;
> -		}
>  
> -		dynamic_nodes[dynamic_nodes_cnt] = child;
> -		dynamic_nodes_cnt++;
> -	}
> -	for (int i = 0; i < dynamic_nodes_cnt; i++) {
> -		const char *uname;
> -		int err;
> -
> -		child = dynamic_nodes[i];
> -		uname = fdt_get_name(fdt, child, NULL);
> -		err = __reserved_mem_alloc_size(child, uname);
> -		if (!err)
> -			count++;
> +		__reserved_mem_alloc_size(child,
> +					  fdt_get_name(fdt, child, NULL));
>  	}
> -	total_reserved_mem_cnt = count;
> +
> +	/* check for overlapping reserved regions */
> +	__rmem_check_for_overlap();
> +
> +	/* Switch to the permanent address of the array */
> +	reserved_mem_array_unmap(map, array_bytes);
> +	reserved_mem = array;
>  	return 0;
>  }
>  


