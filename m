Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31273CA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 14:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75716B008A; Thu,  8 Oct 2026 10:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27BF6B008C; Thu,  8 Oct 2026 10:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C276B0092; Thu,  8 Oct 2026 10:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF4A6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:05:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D0D0A02FF
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:05:19 +0000 (UTC)
X-FDA: 85299631158.28.CFAA4E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DEFF41A0003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:05:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0vKNlzI;
	spf=pass (imf19.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791468317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M069Iw3bXdsC/3DZgadjO0BbzRw+5tuAHetlY3tELmE=;
	b=0pi6mtz41h4eljMnun6tQkCVfYdc0tXiAvCsIoQNo2CSQ1Xfs/PSzBEDh8LSc1t1xsmuQ7
	y8HEx+RL5+tMkzlzO7raYK/wbCHrCAPy32fRCSDL+S6TygsVVI9SN63qBeOaXdLnxVBc9q
	kyvk1I451IugdGleih3YiHof0+/tGSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791468317;
	b=cMtxCXYLTm+W1VbfHXfEIMsy9pXSjtmrgwaR8coq8BQgSmjFM1bwn6q1Gu3eBlg5fRkjBy
	TtHQnTHk6liKMJiK2+n0GbutXhzw0PyK9d6XcBrqORG+TS5CUPtcX79AH/UxVofubS6yPc
	3naJXDhiJqIpyJItBkbpmJk843/h7mU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0vKNlzI;
	spf=pass (imf19.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84F4A601DB;
	Thu,  8 Oct 2026 14:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A1A1F000FF;
	Thu,  8 Oct 2026 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791468316;
	bh=M069Iw3bXdsC/3DZgadjO0BbzRw+5tuAHetlY3tELmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I0vKNlzIbSpIXeaVg9TodK8mLrShglenOa//I6LaHYDz3kU1ir8IZGKTZZ3+iKdr5
	 uAyilIT2FXIA0A1WLwjQB88BDj4lFlNkw17wf54WrpH/PNvOg1Pjy6gLhxFvnELX9Y
	 RkLJ8m/VF1ZPG7Flv4Zj6aMAG3YsUK0XWtVdelVv02rlfP1IQMnJVoJlmK8+PvPr27
	 24YjJd5gFtcnGCmpiN52eSRDBfwAtXFg2+1opFXOiGwKcC2jAlzKozlJTc2CuiHL8C
	 CJOUZLK2w0dIQoEuPsCUkq3NQUcLNIT9wNFiqdO90vxbTvTihALPhCjdTmw8EW9WjB
	 dOdNWM6O6ZFrg==
Date: Thu, 8 Oct 2026 09:05:15 -0500
From: Rob Herring <robh@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] of: reserved_mem: allocate and map the reserved_mem
 array early
Message-ID: <20261008140515.GB183998-robh@kernel.org>
References: <20261008094125.3197971-1-m.szyprowski@samsung.com>
 <CGME20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea@eucas1p1.samsung.com>
 <20261008094125.3197971-3-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008094125.3197971-3-m.szyprowski@samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DEFF41A0003
X-Stat-Signature: q53jh6zb9hm9c4u4r5yhnnmehktpf1bg
X-HE-Tag: 1791468317-999316
X-HE-Meta: U2FsdGVkX198zt2L9J5b2/O5J9RKpFdURzoYJK8lIZcILGxfCZ3j83Wrm+6IFMIE84EYl2/3E9t0c3dNaWJs8E/VZUisNU/iBED+VzuEhcLlzCXhObz3jl5YcbXuUVZ/XGDM2DEhrVUtnBl/W2Hz/VUKyBBN3n577etNmCrAbeL4vfRJ5oscCI4CQjrBeVpWe+8mUDFrf6rt7KEEfbb4EcJPrY16GOqb4jKJDMzZRUJMCysED/A1e/oEE3FabtCOFHfPPgWcwTDpdsyDdzRyFzdKavY03ZpqsHa2g9cenbdjp3aREnXXYncD5c3emNUMqwaO8XeG8IVKi1X5qdh83FV6fcUFvcG6Lv5kfqoGUWTvXVx+USRiFbYe55f0GVq016oMttzp3C9+88WIQ76pQVkjsX1jzA3X6nl0+PfeKTTK52p3VkWg+WT41WzzqOY1dCxZgjrvCtINeFSG7RvLszGXNG/PdecRjIIZSmUwfziVaqvk4iUavKtEWM9WU9VxAf19A1MNwQ08Sv8LfszidIYOS8UMYFDCeZQTo6xEYQpOq+MFjjhB7y16inJRhRt09I4Ik5AUCgl5kf4YPlLSUod3M5dGoRvnaHDn0NA2kXqHR/8PWQbFv5AiInw/hj6U7Ats+XSuYB1w4imVfTxUTSJS4a1eRvlZHFICM8Z6LfOLJrlypgLs18p2IPHHiZezusCqUluzep6P9zNPY9QUEoJN7seokSZrNaFrvxYmMAvl9jBbaSBCbZe9lCLeCQv/dnTzs3VS/FTBcXWdTAgP3CB76kVMz8/6ri0jskk8udsqgMbwUH6hDZdbSQkxVdse6n8575zh5/1UIyKqWaipCmUOTFU5quYIJPC+8rbUISarrDekjVVLHnLHlhOZeX9TBEWDT3L3FPplTwvXmoZF2A/TMX+eih3OjTCMHsnLgvPVQL1FsGnvAEZqeuVYBmaIZif+xzSd7CZshx5osqa
 Z/VQCzRK
 ACpQQyHQvdMv0c01A08QrDTOKjlKadsfBCWhHeumFpXBRZXljE65ROYSQ7N3BCjxCq/TZQxpDskTdgaqNyN7X67FKNP1hh00JGzZ6hmr3nOrtvllwXD+YLtXeTfcIVCC2iyy91cnTzLQgQzQj30mDrXDgvqMjAYz8fbuRj65S5l3sS2oWfv/uCGLoYZ6jVbyF+2dJrhvNJYp/riCm1WkeHzocp31sLwSl3tgNCTI0ErFWH5Iq12HTTOHuVfNMoRr3GH/lSDsa2KBMWz4A/hggPG6NQEbeYH25YOsqjWC/r9HlZl5eu3yvWjRAJotwkv1kAdx300qiS14W963/tWxwctxSOjFDaM6donJLUd0zlrhsmI/V1hFRkX8hIh5iPptr8V6pu2bEyLWY2LYQWwDlSLProQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 11:41:23AM +0200, Marek Szyprowski wrote:
> Get rid of the static, limited-size reserved_mem array and replace it
> with array allocated by memblock_alloc_raw() and accessed through a
> temporary early_memremap() mapping. Such mapping is needed for some
> architectures (like ARM64), where linear map is not yet available during
> early boot scan. Having a single, writeable array with all reserved
> regions removes the need to perform two step initialization introduced
> by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
> memory regions are processed"), so all regions can be processed
> directly during the early scan again.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
> Assisted-By: Claude Opus 5.5 <noreply@anthropic.com>

Assisted-by: LLM

is the new way...

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/of/fdt.c             |   3 -
>  drivers/of/of_private.h      |   2 -
>  drivers/of/of_reserved_mem.c | 251 ++++++++++++++---------------------
>  3 files changed, 96 insertions(+), 160 deletions(-)
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
> index 300fb236ab59..6a5e53243bb7 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -24,12 +24,14 @@
>  #include <linux/slab.h>
>  #include <linux/memblock.h>
>  #include <linux/kmemleak.h>
> +#ifdef CONFIG_GENERIC_EARLY_IOREMAP
> +#include <asm/early_ioremap.h>
> +#endif

These ifdefs are the only thing I don't like. early_ioremap.h is always 
in asm-generic, so do we need the ifdef here? Or does the arch have to 
do something to pick it up? I don't remember.

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
> @@ -59,56 +61,48 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
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
> + * On some architectures (i.e. arm64) the linear mapping is not yet usable when
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
> +#ifdef CONFIG_GENERIC_EARLY_IOREMAP

This could at least be:

if (IS_ENABLED(CONFIG_GENERIC_EARLY_IOREMAP))
	return early_memremap(__pa(array), size);
else
	return array;

Assuming the header can always be included...

> +	return early_memremap(__pa(array), size);
> +#else
> +	return array;
> +#endif
> +}

