Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F93C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7218A6B008C; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1E06B008A; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A4E6B0093; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 356346B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A63321205DB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:54:59 +0000 (UTC)
X-FDA: 85226121918.14.1AA6B7C
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 95DC640004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:54:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cQTyQpN7;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvrGzctpGGzu8oxKQw3tKpiz4XHwPltvrD9jJxe8Oa4=;
	b=zlngT9uXIiyA+zL3I582oUB9rEsHf4A+2nVStZOvxWGJyo2WQLh9E55cahvkl5VFWTXnkO
	56fLUZadEXIEbn8AhW6GUDpZAJEMdZNh2fznRBTjIOVBAFXJc9EfcutQNM6hMROKbC+tyI
	k8TpsH5G21HncsslsN46jbDbVze/yYM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cQTyQpN7;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718097;
	b=VN6xbVIqxbugy6zxsqFGtyTXUyTlbAfsgrXZQtfBKRBp8IZY1ba9R48F86v+CuW8Dqo4ko
	x6xVRGpllufhFDVivJwXiFKixb0azrxseHWwzpm0wCJjwv5bIMj+ufGvisy8grG5PgAv3k
	cNolNbwuU4ATs8HFnz0nu+3fPrgJcYo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w1C6Uq5LGLS5v5+hUhhr7wym9SsyY1oKg1mT464GIeo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789718096; v=1; x=1790322896;
 b=cQTyQpN72GWh0vFSP2OSSt6OoeLakd/ZFjqWUqc1nDBXGR9zWWRQY06J5rh0UbilUNacd91L
 F3G0c+rlbShg36Rvo036m6CEVa69aFhh/lsy8ZZlyrfMz+5viDApJz7MxT8J9PiA6S061DCLYQJ
 YoLnqz8tCr2yoVDATrSIr4e0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ea360a8e458d95f5;
	Fri, 18 Sep 2026 07:54:56 +0000
X-Mizu-Trace-ID: ea360a8e458d95f5
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 15:54:48 +0800
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
Subject: Re: [PATCH v6 04/10] crash_core: serialize crash header preparation
 against hotplug
Message-ID: <aqzuSJKR03zEOCan@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-5-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-5-chenwandun1@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 95DC640004
X-Stat-Signature: hyidjwkwbbcftttzj3ey5kytdto56hs1
X-Rspam-User: 
X-HE-Tag: 1789718097-433341
X-HE-Meta: U2FsdGVkX1+BQXtXN23l0IPGYpY3i9/BrkI1s8+MQ4Zh8/92KGmg5FmczAXib/gnrNMRuYF1HyZyKu3IgB5QtkXidG2HYiu0G0RZXR35EhabPOyVWajWlJhkeX/3cjBsVQl6TX6zv6ktS9/YNL+Ssm0c9G4576cKDJtJCW0GQnzrwTP030/b3mjBTakQ8s9ycvurr/dn3jNnSRE8E9wKe0m03drOwFbS9wCgCT+z8k8G162rLQ0FrJaNlx4TsD19oxvhRuNID/sj3grDkYLMpczCR12KOhvw7AfWnPexN2+RAUrJVmMCgmytGpgRSBAY9cU9XciSHlsYBukMl4BwKOovDgUS8lPluk3rJGMeZ9MkSmiaSKHSMuf/ULZvNFpKDFugn59Rae9xCSMWC10FUAOkj+q59nFbX6qW9GXTBlBVfplpOndru5+m+QfjClv2yUTG3xZiBAFOvNVuBGwMTLFQ0n7FxBGodGgof1sNf85GuIoMHPR9+GAS1dQi/WcPD9Rs5y70WyWFmHYtJEBeAm9eK4Nq+044zVvQ7D83HQkAB23budgRkNAUSI1YAme5KFpclHuI0KRnfeQJl6POw9B9gQ0n7nbKIqX/cYXPY/qqRf9lpWK7cJAmDD/xGJChsZ7vSTOLcz4V8/l09tA4vcfiW4JPN63wj02ryei521ATuJjrt1Q/M3tqF0dsGpjr3YX8V6XWGl9qfuLHAwtWCcKQBF//chsAxraQhmSZn1C7J0VmzaNfq/2QgdpjB2W8wSTiAGwZ9JW+u/f7memJUI6BqqcH2sEDEHSYwohmUsKQn33BT+YYvg1NobFAebhUppHLd24LdQNxb+yVbjBWbICbtBjBmko8U5soUQcOAZDOTQx7iuPyLxwQ2KjifdmSF6aTNbZPuU2rGN9weZYgwy50mGRPTisEgFV4RGT7gSkOMUZy7h43fAb5ruCZQkoqD4wj3qdfT6j+yFkVi+o
 BrgxozKk
 A0LU9/4IHLalQTGdoH6bpNcQsf+b7hekmxdHOuwHRHYSGU2OG/dncN0wgokf4fuWDYLAz/ib0G/v90MaW+ZF9qQI0gy5NXHUEk5MqNGtII/uxDHRYrObhb0i/p6ZZX36I9w3Np98Qde28jCz7HtvxiiGTfJrRbrW4nnIX3Nirbl5IYDnXRQsb3mSzCVq2wm14DZX6hzCKtEAb6qkGzk2BmfNiMW67ZLN2PBMYhR7xVYtmL2pRe+ssogWHGDAkdOBUmacOftV64SFyVVsT7hxv41+Vi16QUI8vJugsYktjM+MHlKbPVWvBlGQFwYN9yXCRzwpmSmrRirx1yPtxMAyKiF059xjj6oneJWm3rDe6nE2LIJjTv4bW9KAspS3Ori6qV7mXWzAH70/ReRraD3WnHY9hHJZ0pmLNyo0Wmy+qbrxflZFTjxWqX24JFCv58a/H5oXzr960irSV2aoomz/9BSH2xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> crash_prepare_headers() counts memory ranges before populating the
> allocated crash_mem array. The weak implementation used by ARM64,
> RISC-V and LoongArch walks memblock.memory, while x86 performs the same
> two-pass operation over system RAM resources. Concurrent memory hotplug
> can change range source between the two walks and make the populate
> pass overflow cmem->ranges.
> 
> Take device_hotplug_lock when preparing crash headers during
> kexec_file_load(). The x86 memory hotplug path already takes
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
> ---
>  arch/x86/kernel/crash.c    |  2 +-
>  include/linux/crash_core.h |  2 ++
>  kernel/crash_core.c        | 17 +++++++++++++++--
>  3 files changed, 18 insertions(+), 3 deletions(-)

LGTM,

Acked-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index e681ec9cf1dc..284d78bc3fd0 100644
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
> index 77285ae3ce60..3adee1ae120c 100644
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
> @@ -338,8 +339,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
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
> @@ -376,6 +377,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
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
> +}
> +
>  /**
>   * crash_exclude_mem_range - exclude a mem range for existing ranges
>   * @mem: mem->range contains an array of ranges sorted in ascending order
> -- 
> 2.43.0
> 

