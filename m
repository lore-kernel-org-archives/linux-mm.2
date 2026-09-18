Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E841DC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8F06B008C; Fri, 18 Sep 2026 04:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059B76B0093; Fri, 18 Sep 2026 04:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B766B0095; Fri, 18 Sep 2026 04:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFF396B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:48:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3390B40606
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:48:55 +0000 (UTC)
X-FDA: 85226257830.13.09F0558
Received: from mta0.migadu.com (out-130.mta0.migadu.com [91.218.175.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id B7784180006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:48:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N+eIauUv;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721333;
	b=5DzjCWlXJLoK1mqQBpc7TtAE01FTQZk1V0/6fGokYr4N7uYQvP4R85KadzA/jRNQPrEKIJ
	u3rwDPCn4bUi3nu2CRkFjSf+eSIwK4MKYd+WvnIvq2UvFE9e82c5tcRDi2bakoDSyOsC4K
	66NL3e5D/55ICa7ujxzuIDi9xbW0JQk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N+eIauUv;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DvEnw35d1ba7KZ6gzUFK49m3bk1SuHHDCRwMvJGgSg=;
	b=XCyd/+E0mKzapKQyAH3JKcAk2XzsCGRlBQTlPHSfoSPgoOabRCLuk9og73qIMQJOBQ1FqX
	HZK5HtsXELCo1FaFoxtcEaV9c6RAn6VGafTYgH0qzgW4LytuUUq3S/haJfC9c5AG2Ix7hg
	XpHL8DGcNSa09BQJpGwyCDLgxT73ZfM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BGRV/j7qC/zFRryyQ69/Qz6UrrritH2vK+O2tUc3+pA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789721328; v=1; x=1790326128;
 b=N+eIauUvk9q0yZwY04e7hswM20JaJhHMg1rsm5Pxz8h9GmWgeU/13NnFpzrfk/AH2+YXEgIk
 d3p51EiZ3CrKDfboFo/JBI9HuHIizs67n7gGPFEhJikQH8YQ8rYal/OzX4pV1O/sDf8J0JYoltL
 0NwFltHidckM8QCMAq/h/144=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 308a52a5f758be34;
	Fri, 18 Sep 2026 08:48:48 +0000
X-Mizu-Trace-ID: 308a52a5f758be34
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 16:48:41 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun <chenwandun1@gmail.com>
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
Message-ID: <aqz66dMlp3NiMifc@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-4-chenwandun1@gmail.com>
 <aqzolBceoRchBdbx@fedora>
 <c58e9b6a-e421-4265-aa77-48c07a4fb8e4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c58e9b6a-e421-4265-aa77-48c07a4fb8e4@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7784180006
X-Stat-Signature: dhf5oajwbk4kkggua7wz654z5oj58czz
X-HE-Tag: 1789721331-7919
X-HE-Meta: U2FsdGVkX1/abSR/7hVp4UfXwezWEYpqBpD4YXx3naFEZJ75Ja7cPnBBqiGzBCrb7yWzyDp7tTkD/3/zqbySHwWz5PGcdcRTtFue5CKlKm1YeZBBBn5arkQXNDdfzOKcQIguRJzK/Ar9biVulXTMHWvNSiTb8GmDXtck9Lsqs37EJv85N3dhaH4HmxtBC00T59JFg0G+mJvnOpOQqF6LC0aRywg0PpMpgvxHgplswUD9CRxtDdCjMlR7bMlvUm3BB1Fz2jfy/zifKJDvz6FkhOthG/oC1q/+XDtuXVcRfcj3PzC3hay161u3amxbDmzab7HVVHYo+CDMqMyf5CcIv5RoJ7hd7LUxAU3lYPfYNQryh6IgHrQQpC/HZ7z9uH8ZdZ1juQb3VGCIGwmoWnvZVfgMo/kfWHa07a/qi9QrreaJ0wkRXTO3Ys+Yc9NaSHFN+nNY+GzTWjHQammplEj3bBz/DSzJQuOcU+rwKk+KZP9o24bwrMGshLB96MCpoVetDCt3IJmbjYWVNIt6VixdjluLaw6T+qDqAYC3447fkssvqL5luDp6UKiORosPVdd9B3BTY4drB0z7OOkpFIn1p4rWNRE9//KrF+Ivo/mnY9hpQBEgRjXVbG3rCEl3YLj+w7XTtlgJTmJqWc6VZhpE9RoBUDRFc+lhPssw9bUx7M8L9cyVbbNkCoEk38lZyKjuTjDT7QxTs3Rgv3+n0r5JjuqrnNFPEqQG8mcoOV5Wq2dGff6/TT6FSV8iHn7BaSLu1WGNXzRUY37+cXHnCVdKSz4+iEznfQhiTkRLgxVJ+3C5YStnQP8I0C2rdWfCUQFY4IV/pS00+lFJlV8kkGIY6BfxpfOtg2JRiUhvFJ5QkAsv4vxEC2VUjK8RcKHx2ph+AhERWEuQHd+a5Jmw0CEATWLEl1v6WMFN/tPS1NP5yd1W6CaHSWTg22i5FS3Deus0+uw9Y2TMz2as6aAfd+O
 SFi1Sa6X
 MMz2zYMm1dH8+5+EaTOFT/1hyYdIdPNy+Q4EHuw7WrU3DVEilhRjWM8xdxlNVTj4bf3H8rM8W4O1Wjw8Pc+0ojb2AiC5oxURKN8NnXp/qT0ObyUeEbzEp41xRCFdZ+V267Y5OHC6WG/IAi/tp7Y/emZnOZL6lhdiJHFO9VijE/5c+0BC/clxd/lpyxF5lV1kmWIyW4T8VD+Po36knuzJax9BgDHgrttv3kVL1nFgLWARqwhhe7bTsLKx5U9kTbES7fSaOipQhXIFLqW9256MDIdywzVRtQqx3VRtpnTefTyVCnHYE6NHzJoBmHLVc+JiRscTr/WWHrglMxRzivqFMUABRWoFJuURqhkj7G/WhhjXy/G6BIwRwJHRVaNk8i96DFt7A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/18/26 at 04:45pm, Wandun wrote:
> 
> 
> On 9/18/26 15:30, Baoquan He wrote:
> > On 09/02/26 at 03:31pm, Wandun Chen wrote:
> >> From: Wandun Chen <chenwandun@lixiang.com>
> >>
> >> arm64, loongarch and riscv open-code the same memblock walk in
> >> arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
> >> the __weak defaults in kernel/crash_core.c and delete the arch copies.
> >>
> >> No functional change.
> > 
> > In one version, you also tried to remove these functions on x86, I could
> > remember it wrong. 
> 
> Yes, the x86 implementation can also remove these functions and use the same
> approach as arm64, RISC-V, and LoongArch. However since this change would not
> reduce the vmcore size on x86 at all, I did not include it in the current series.
> 
> I plan to refactor this part on x86 after this series.

OK, that's fine. I remember I saw the code, but couldn't find it in this
patch. Thanks for telling.

> 
> 
> 
> > 
> > Anyway, this looks good to me.
> > 
> > Acked-by: Baoquan He <baoquan.he@linux.dev>
> > 
> >>
> >> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> >> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> >> ---
> >>  arch/arm64/kernel/machine_kexec_file.c     | 29 ----------------------
> >>  arch/loongarch/kernel/machine_kexec_file.c | 27 --------------------
> >>  arch/riscv/kernel/machine_kexec_file.c     | 26 -------------------
> >>  kernel/crash_core.c                        | 25 +++++++++++++++++--
> >>  4 files changed, 23 insertions(+), 84 deletions(-)
> >>
> >> diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
> >> index 854d872dfd0f..34d944d3f22f 100644
> >> --- a/arch/arm64/kernel/machine_kexec_file.c
> >> +++ b/arch/arm64/kernel/machine_kexec_file.c
> >> @@ -14,7 +14,6 @@
> >>  #include <linux/kernel.h>
> >>  #include <linux/kexec.h>
> >>  #include <linux/libfdt.h>
> >> -#include <linux/memblock.h>
> >>  #include <linux/of.h>
> >>  #include <linux/of_fdt.h>
> >>  #include <linux/slab.h>
> >> @@ -39,34 +38,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
> >>  	return kexec_image_post_load_cleanup_default(image);
> >>  }
> >>  
> >> -#ifdef CONFIG_CRASH_DUMP
> >> -unsigned int arch_get_system_nr_ranges(void)
> >> -{
> >> -	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* for exclusion of crashkernel region */
> >> -	phys_addr_t start, end;
> >> -	u64 i;
> >> -
> >> -	for_each_mem_range(i, &start, &end)
> >> -		nr_ranges++;
> >> -
> >> -	return nr_ranges;
> >> -}
> >> -
> >> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> >> -{
> >> -	phys_addr_t start, end;
> >> -	u64 i;
> >> -
> >> -	for_each_mem_range(i, &start, &end) {
> >> -		cmem->ranges[cmem->nr_ranges].start = start;
> >> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> >> -		cmem->nr_ranges++;
> >> -	}
> >> -
> >> -	return 0;
> >> -}
> >> -#endif
> >> -
> >>  /*
> >>   * Tries to add the initrd and DTB to the image. If it is not possible to find
> >>   * valid locations, this function will undo changes to the image and return non
> >> diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
> >> index 5412aa9f3568..481b8f906a56 100644
> >> --- a/arch/loongarch/kernel/machine_kexec_file.c
> >> +++ b/arch/loongarch/kernel/machine_kexec_file.c
> >> @@ -13,7 +13,6 @@
> >>  #include <linux/ioport.h>
> >>  #include <linux/kernel.h>
> >>  #include <linux/kexec.h>
> >> -#include <linux/memblock.h>
> >>  #include <linux/slab.h>
> >>  #include <linux/string.h>
> >>  #include <linux/types.h>
> >> @@ -56,32 +55,6 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
> >>  }
> >>  
> >>  #ifdef CONFIG_CRASH_DUMP
> >> -unsigned int arch_get_system_nr_ranges(void)
> >> -{
> >> -	int nr_ranges = 2; /* for exclusion of crashkernel region */
> >> -	phys_addr_t start, end;
> >> -	uint64_t i;
> >> -
> >> -	for_each_mem_range(i, &start, &end)
> >> -		nr_ranges++;
> >> -
> >> -	return nr_ranges;
> >> -}
> >> -
> >> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> >> -{
> >> -	phys_addr_t start, end;
> >> -	uint64_t i;
> >> -
> >> -	for_each_mem_range(i, &start, &end) {
> >> -		cmem->ranges[cmem->nr_ranges].start = start;
> >> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> >> -		cmem->nr_ranges++;
> >> -	}
> >> -
> >> -	return 0;
> >> -}
> >> -
> >>  /*
> >>   * Add the "mem=size@start" command line parameter to command line, indicating the
> >>   * memory region the new kernel can use to boot into.
> >> diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
> >> index 808e872f4063..fdc6695e8588 100644
> >> --- a/arch/riscv/kernel/machine_kexec_file.c
> >> +++ b/arch/riscv/kernel/machine_kexec_file.c
> >> @@ -37,32 +37,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
> >>  }
> >>  
> >>  #ifdef CONFIG_CRASH_DUMP
> >> -unsigned int arch_get_system_nr_ranges(void)
> >> -{
> >> -	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
> >> -	u64 i;
> >> -	phys_addr_t start, end;
> >> -
> >> -	for_each_mem_range(i, &start, &end)
> >> -		nr_ranges++;
> >> -
> >> -	return nr_ranges;
> >> -}
> >> -
> >> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> >> -{
> >> -	u64 i;
> >> -	phys_addr_t start, end;
> >> -
> >> -	for_each_mem_range(i, &start, &end) {
> >> -		cmem->ranges[cmem->nr_ranges].start = start;
> >> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> >> -		cmem->nr_ranges++;
> >> -	}
> >> -
> >> -	return 0;
> >> -}
> >> -
> >>  static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
> >>  				 unsigned long cmdline_len)
> >>  {
> >> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> >> index 2b36aa9fade0..77285ae3ce60 100644
> >> --- a/kernel/crash_core.c
> >> +++ b/kernel/crash_core.c
> >> @@ -281,8 +281,29 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
> >>  	return cmem;
> >>  }
> >>  
> >> -unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
> >> -int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
> >> +unsigned int __weak arch_get_system_nr_ranges(void)
> >> +{
> >> +	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
> >> +	phys_addr_t start, end;
> >> +	u64 i;
> >> +
> >> +	for_each_mem_range(i, &start, &end)
> >> +		nr_ranges++;
> >> +	return nr_ranges;
> >> +}
> >> +
> >> +int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
> >> +{
> >> +	phys_addr_t start, end;
> >> +	u64 i;
> >> +
> >> +	for_each_mem_range(i, &start, &end) {
> >> +		cmem->ranges[cmem->nr_ranges].start = start;
> >> +		cmem->ranges[cmem->nr_ranges].end = end - 1;
> >> +		cmem->nr_ranges++;
> >> +	}
> >> +	return 0;
> >> +}
> >>  int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
> >>  
> >>  int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,
> >> -- 
> >> 2.43.0
> >>
> 

