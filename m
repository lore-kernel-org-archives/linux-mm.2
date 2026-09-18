Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F50C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B396B0092; Fri, 18 Sep 2026 03:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BD96B0093; Fri, 18 Sep 2026 03:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322036B0095; Fri, 18 Sep 2026 03:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06FF16B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:30:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 844E01205D6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:30:40 +0000 (UTC)
X-FDA: 85226060640.29.E66E1DA
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	by imf04.hostedemail.com (Postfix) with ESMTP id E49C140003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:30:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ULNtSIa4;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789716638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kM1dRFmDXeAoN/p5ctvzv5ZVRnmxbgQAJ3cL+XZ9LEo=;
	b=EQnqaVINEikKKzWr41dlO6Y4/P+rQI4S7sPGNzlUMMzlO1Tvb53I+DRIrHDUqY1E27cXpZ
	7zzvYSR5BrVPmfR2dDUdcLrCUM9l4315Vtzbp0BmC6ktvN1H+QgmvuTD0SONpjfNhPBAAg
	AWX43pI9+BEP7WQtMaYJEtLMDbPuVls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789716638;
	b=3upt9bsNKqtLGQsYMO+P3/cD/9kGq+YYqvAQeahCdZ/l5iwilq2Ic2dO0/rbQjpZB/N/DO
	aGY76mpXKNHi+U7n7FYaUOyfXeEkLStSOWIpqWymqhX5bmyWdsaM7wmtXwuGDwQBwIEPNy
	i/71Df1DsHA3yz4WgvcBpc4Zf6KWwx0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ULNtSIa4;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UhePvlO6Uju4KMSGgi0DFyyW4sOpnmjHBEaUsD91vSc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789716635; v=1; x=1790321435;
 b=ULNtSIa4m9Ewij1GnUkqGxU9aXQ2oILTA+9T2u7ixLXmqYR0nKCO44mGqYBlywtYYqe+h75F
 cwwwES+57lXO+C/ybgQiFLJQ5sAh/z90HQN0U4gkWvyg/gDIwUz7rPyp+n3UnwLXDcICr4PZZUq
 Gj0ULHhyxmZmM4k7ZqWmX/LQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 37e6b37ee04b46ae;
	Fri, 18 Sep 2026 07:30:35 +0000
X-Mizu-Trace-ID: 37e6b37ee04b46ae
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 15:30:28 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
	alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev,
	robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH v6 03/10] crash_core: fold duplicated memblock arch hooks
 into the weak default
Message-ID: <aqzolBceoRchBdbx@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-4-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-4-chenwandun1@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qexj8y1by8xyu8snansqxpbrkghywg8j
X-Rspamd-Queue-Id: E49C140003
X-HE-Tag: 1789716636-233743
X-HE-Meta: U2FsdGVkX18wKYnbozdUASk7T9dua+jWgQLHfZr91wRkW2Us6mdW71V1fqW/H9rWC+xd0atxWCOVBPfxQJI2lW01WW1AUzekJYZ5fzlnntpPT3oJChMGUhzkbmuGr2pa36WKdUnrQrMG56jrXvUv1I1q4HI13Eg8GWlVWYuNQBkl0kMZHQOCHez1q84ZlHP/24JOsVSpadciehs+BXeojqIbZJxPShLFnFqBZPneOghFd+4vkbQ1wkoA5BzCwQCXBzPKF45LWgU/i6Dg9yjaonun+9txM398QM4e6w0Ni/NxJqUKQU2rjAddQr02fIHqEcrkGifPcgbRwCOXNU2bchNxpJeL7gFuTyQJBINVHfA9l3klaA1D9as1QUm35QPSGUo2baoB/PyupzPde9io3HH9NT8ISpGjBAaBfdZrsjKJvAg0erahGNLUP1BVx5iDnqZq7ky9taf+NQLFnSYSL2Hkpf40wdF2OEYIGZk5W4yClvLTvOLYbp4UcsKDTKAsP6s/vTb0Q3bNZ0+H3NFTxoAYhLq5vfe8SznGGUUTOCa18LY48IJQPS0rX5GITQGUIDSn7+R7700oDAoimzG1IYUJ2yBFC0Yy1vA1JkUKX/UN86+0v9bjKWwddcRlIVZhIdbzW4KGivfFi5j1XR+2gg5Sd0d1MPv1EyZ+UVn5D8mM9fXlPfBlWuyJ+kxe2Zx4RSPd01PGm4uKa8cPhEK2B1F4N5z2oiR4w55+3kmWc7LV+xY467panclBHPHNI3mXpihVqoFr1vNfaWXqDf5MMP3THuYvCAYXkzfYhiDKDJUnhMCkAZ8MMwFeZ6Lx3rFUv7iZglV+8+qKEX1CeCByMiQbRtUaDBICm6e0MA0BJQEZpzaTG2bSEsCsCva5umO31GyL8IEZEUEsb/R6VmK9daghqafZPMzkrKBYj/2X1RTQb+nDTs0y2VhJYt3Oap17YD1bB0wGrBcMPrSOvLQ
 w4f8yLmv
 OwKzI+ngQsBu79OAVWYcQcKEp6qP+ICDy5mtQGeY2xoPimWacZX9/OV4nBeJPh5bJZVGf/MqQIP1K6TyppYzgAE3lqXVIMeNsWrbAi95XStxnIRVMBLIQhiG17SCuRdzKSFpVzw8mpA1tAJ2+gNUyGfQXLGnQqjdQhyb4k7C65aWZmcjke6pUnIDv2yqY4w9WS9/FFVAdynAc6bBKZDhpSJeRScnh4X640cdDVKRVnD9nKBZzH6yEtpJxEgjLqeY8zoUhawrQ+yyfdzep4p5we/nzKMVwWc5iwDPLWI0XbpacHNQ+320XrGx5mrBTBICxTSuUdnNDE/HIVToJbZ2Cp2Vz5Dwcd+i5yjpxIAo9nyHonGnW8byJ2VjGY2aCvmcyuwKj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> arm64, loongarch and riscv open-code the same memblock walk in
> arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
> the __weak defaults in kernel/crash_core.c and delete the arch copies.
> 
> No functional change.

In one version, you also tried to remove these functions on x86, I could
remember it wrong. 

Anyway, this looks good to me.

Acked-by: Baoquan He <baoquan.he@linux.dev>

> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  arch/arm64/kernel/machine_kexec_file.c     | 29 ----------------------
>  arch/loongarch/kernel/machine_kexec_file.c | 27 --------------------
>  arch/riscv/kernel/machine_kexec_file.c     | 26 -------------------
>  kernel/crash_core.c                        | 25 +++++++++++++++++--
>  4 files changed, 23 insertions(+), 84 deletions(-)
> 
> diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
> index 854d872dfd0f..34d944d3f22f 100644
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
> index 5412aa9f3568..481b8f906a56 100644
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
> index 808e872f4063..fdc6695e8588 100644
> --- a/arch/riscv/kernel/machine_kexec_file.c
> +++ b/arch/riscv/kernel/machine_kexec_file.c
> @@ -37,32 +37,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  }
>  
>  #ifdef CONFIG_CRASH_DUMP
> -unsigned int arch_get_system_nr_ranges(void)
> -{
> -	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
> -	u64 i;
> -	phys_addr_t start, end;
> -
> -	for_each_mem_range(i, &start, &end)
> -		nr_ranges++;
> -
> -	return nr_ranges;
> -}
> -
> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> -{
> -	u64 i;
> -	phys_addr_t start, end;
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
> index 2b36aa9fade0..77285ae3ce60 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -281,8 +281,29 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
>  	return cmem;
>  }
>  
> -unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
> -int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
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
>  int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
>  
>  int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,
> -- 
> 2.43.0
> 

