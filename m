Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DEF606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 02:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=5dAoixTz
Received: by kanga.kvack.org (Postfix)
	id BE6826B05B4; Fri, 27 Nov 2026 21:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96426B05B5; Fri, 27 Nov 2026 21:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85DF6B05B6; Fri, 27 Nov 2026 21:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 131356B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:03:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04E2C1205AB
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:03:36 +0000 (UTC)
X-FDA: 85482881274.11.4AA14AB
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36B3C180009
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:03:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5dAoixTz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795831415;
	b=srMUsRAZzPTfyJ1d0Nax6RyaX9DOlKwec9hfY3mFuweKFf7o79Mp9V08/LW0ZMYvZv3LpF
	M4xTxREnozJMET7CWWvEFKjg58VVVcjQbMvSYWLKUoVT6Fpl+uCtjvRxTd2oQtzp00S0DY
	sGRRqMYLVl30ifgitNKKifu0VSGrzDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795831415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bb02QMbPzYGMZl2XBsuZPs04tkTOlgjVE/NIsauxzp4=;
	b=abxkUkZGHaWgBAqz924OFt51ZI0NseKjOnUcIsa45HYg1B8dJeKQLQQMZrvA9byuV0uz2k
	/slPxUkQAwFWbno2IeCUP7cqmdmzuDVGsk3rUWs+GQoOiuRu1M7BFvYL6STrXeQnEHGAm4
	gitc2xyIOvyGSlMYfm1ccpJdZS+9NOI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5dAoixTz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Bb02QMbPzYGMZl2XBsuZPs04tkTOlgjVE/NIsauxzp4=;
	b=5dAoixTzdi5Pva3FlAw+4G4gvuRSbcuNIp9u6jt4z68aplPRUSy8CmEDY1bii9n7+mU75QUxP
	s5A0vr9IzCzDScYnVJHNow//t6iWbrZ46GCsHh9kMtlyDcQkW7OdSxett+AHYn6ZaJFvgQk+BOj
	M3+5IMQ/nsRWxs/EB7JtCUI=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jbtpt197czKm6c;
	Sat, 28 Nov 2026 10:03:02 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 8271540563;
	Sat, 28 Nov 2026 10:03:22 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 28 Nov
 2026 10:03:21 +0800
Message-ID: <6448a512-9c1a-441b-a8b8-7bf654e8b2a5@huawei.com>
Date: Sat, 28 Nov 2026 10:03:20 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/8] crash_core: serialize crash header preparation
 against hotplug
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
 <20261127090723.741253-4-chenwandun1@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20261127090723.741253-4-chenwandun1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36B3C180009
X-Stat-Signature: b3wqdf6x9j5mgob9h8amjeqe195zdbah
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795831413-154884
X-HE-Meta: U2FsdGVkX1/BTt9JkuaBmrToemvvX9eFwU9tyfeg6sFtzDii9gCZgmOI59pi9ycRYaGNH0A4mxZbaqQP2J5Sbo75ePW4vOzxJjhQPt4b5G7VHAUnLsimNPXmJErxtsZoLiDPq/n1naCpXCqDLdhQJZl9s5pdeXbIb3DuU3MyVmHMHWGmk1UcD9gew48/04Vf0DHTpU1MeRZlp8zSRT20WeLyubqHJ20e5tR6LnMduzYvxCxmJ4A83OFP9AKJk2ZzSkCk5VWBybILw5epf9BW4/5Ns94gSu8262B205OCluGEB8Bj271E6Fzu36yqpQlxAcvk8wE3kAlcYpiymHfx61l5D2ckConO2Dxp857Bggf+1sAlAVSMU8QOc3K8SGgxSCZqVO20EKC7oRZ1ZItghT5F6227LPUrYIEXk+B9IYZ7lqLIAJWh47o0l3aXI/lFROVqgYxgmaFMmZ/9Pt0DygYUEBiTiDh47Xtgm+0TaRidOxjgU/vuATXI0HMoWaFVy7RiL/BcYJPFFlQhQFX40E99BO5ErtVstJDEMNaWC6p7P4ZXh6cBRBuANCsOvLnR+Cro4MYPff391rWYAqSTspH825tqwiSI5/63iWouCkIOAextUZ4N605xGv2ZuRR245jcO6KyPEmjkqqZTt5HrcOw+ycyje9NAV0MpxGgC5+42/1xjy8IA/fTAHLEFpRTpqFUik4PZdo7blZjKMlbhju8kTUASuz9tAzOb3zZRhtuO3DoH2420EkYgOJRut9vaTVhxFH7mCg/DHHUHCIvHl6riCs51pxZnMlGCFv5lgMhq7FGw4xVy9+qw+LNMoDWPffh97itIgHKhhHprhqyWx4h+clMdC6eqB/n8BPas046frR/EEaOLShPeFtEUY8ijJkkx/H2oanhi7+8iLfKED6pvdiWrIwxK62YUCHesCkJfJVk3eGEjA82HgCNbBu5GEQcwng6DLEzZPsEaX+
 XLh9wsuq
 lFpD/olCzHJn0EqoUlAu5uigJ4koU5luDHlWkWVu2b9CYwagqVK7mu+FCsUpk8k8GvOiuPgY+7yUo+V9iG7OgySm34MMeEjNbQ8BLkzP6QaT9zxI+k3JyayQuU/UtXB3Sam4jinU+vqDDSIK8/0ymCgNWVpixzgPdhX3XfUBaRHJKMoN9SZrxtl1Cftt1YALYgVg3nWlRhDQrX3KsFIkAbFsrgUyuTO0m92o5SElsTNHtg6Z4nXABTq/o2fiG+jO49IwlCwOganY8vRO/7lizQwRGrM1/DtiuIds+md1JCDjl9E+kLJvM2W7kR3hAWbcB+kjFcIcUAH+ItGyfc+qkEHCcDypKaDWGI1EWs0nDcDHcpl0jnCPzVmIDiJUxjW8YOjH3IXyycajUUK/9ZnmETruQZKkGci4kJapEzHcmaQOLtRrSsIihi5m9xrkP/6gcq8VXBzFBdDl/L6wVlplbKK6u8B/C3W18DXL15oCDWIGE4F2WBdyxILy7lcx0E2pNuUNd5XInqzE6N5XA80UrCWy8+iIuM6bqwJZQ/KPPVeMrw7jQRvtLGflS16UQ12bVb/0jnzXmXxX1Jy0Ka0X3OWv0ylYu0+NPiJgZm/z3NsbGJQgB8h0Wyohm9H/8m0msO1CPjbfTqBS9lwUkDQGn3LnXR9gqJ1DztCg9mspcankccKHrliERb2uPQua9Y7+2VlcrYACjkh2I0pM=
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
> crash_prepare_headers() counts memory ranges before populating the
> allocated crash_mem array. The weak implementation used by ARM64,
> RISC-V and LoongArch walks memblock.memory, while x86 performs the
> same two-pass operation over system RAM resources. Concurrent memory
> hotplug can change range source between the two walks and make the
> populate pass overflow cmem->ranges.
> 
> Take device_hotplug_lock when preparing crash headers during
> kexec_file_load(). The x86/riscv memory hotplug path already takes
> device_hotplug_lock, so call __crash_prepare_headers() directly
> to avoid recursive locking.
> 
> Sashiko reported this issue in [1].
> 
> Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
> Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
> Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
> Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
> Acked-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  arch/riscv/kernel/crash.c  |  2 +-
>  arch/x86/kernel/crash.c    |  2 +-
>  include/linux/crash_core.h |  2 ++
>  kernel/crash_core.c        | 17 +++++++++++++++--
>  4 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
> index fe5a4b306aae..ac8df2edf2a7 100644
> --- a/arch/riscv/kernel/crash.c
> +++ b/arch/riscv/kernel/crash.c
> @@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>  	 * memory resources.
>  	 */
> -	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
> +	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>  		pr_err("unable to create new elfcorehdr");
>  		goto out;
>  	}
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index e6f23933a6df..bef008a0cb22 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>  	 * memory resources.
>  	 */
> -	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
> +	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>  		pr_err("unable to create new elfcorehdr");
>  		goto out;
>  	}
> diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
> index bc087124cd78..28e7a81cf263 100644
> --- a/include/linux/crash_core.h
> +++ b/include/linux/crash_core.h
> @@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
>  				       void **addr, unsigned long *sz);
>  extern int crash_prepare_headers(int need_kernel_map, void **addr,
>  				 unsigned long *sz, unsigned long *nr_mem_ranges);
> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> +			    unsigned long *nr_mem_ranges);
>  extern int crash_exclude_core_ranges(struct crash_mem **cmem);
>  
>  struct kimage;
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index faa0f22dbb41..8a861a946e26 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -16,6 +16,7 @@
>  #include <linux/mm.h>
>  #include <linux/cpuhotplug.h>
>  #include <linux/memblock.h>
> +#include <linux/device.h>
>  #include <linux/kmemleak.h>
>  #include <linux/crash_core.h>
>  #include <linux/reboot.h>

The order of the header files is completely messed up now.

> @@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
>  	return 0;
>  }
>  
> -int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> -			  unsigned long *nr_mem_ranges)
> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> +			    unsigned long *nr_mem_ranges)
>  {
>  	unsigned int max_nr_ranges;
>  	struct crash_mem *cmem;
> @@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>  	return ret;
>  }
>  
> +int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> +			  unsigned long *nr_mem_ranges)
> +{
> +	int ret;
> +
> +	lock_device_hotplug();
> +	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
> +	unlock_device_hotplug();
> +
> +	return ret;

otherwise, LGTM
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

> +}
> +
>  /**
>   * crash_exclude_mem_range - exclude a mem range for existing ranges
>   * @mem: mem->range contains an array of ranges sorted in ascending order


