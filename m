Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0CACDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBC96B00A9; Thu, 25 Jun 2026 22:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69CC56B00AA; Thu, 25 Jun 2026 22:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC1C6B00AB; Thu, 25 Jun 2026 22:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 260706B00A9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:26:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 850EFC1A97
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:26:20 +0000 (UTC)
X-FDA: 84920474520.30.8276488
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85DC3160003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:26:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IJGmabAB;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782440778;
	b=OMGSHq4oLzLbsiTp8UdpF8MbJlaTtgTpyvez5S5l4Nq89q4ATgZIuOTdOLUdSSwiKmKyEl
	6poSKVAFlYcy/sTzZqNEa5ukyexQC2VIIKeevr9fS8X7w4BR/h8ZAZJvWZ8xNBqWb1HBTv
	nK+ZUqRTII9AiZk5dvr4icsp3AjoklY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782440778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxVxgroX3On6H8SMBZy+I5j57FDfvO4So/Vpazbn4F4=;
	b=M4ZZZTXNfpCjPz4Y31MCCSYfiRgHn5jvXNcVPLGaebOwXommnrEgtrukIKvwF2QcP6a/F7
	FLS7xp1Eb/1n3eRhJ79oWP2gLhFzAWF40BTPsaILc4X3wwUBxnzdWkBFlxTbXCo9mSK+NZ
	xUvYB9j14aF9HyAf5AZF014sgqaGL1M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IJGmabAB;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <41d69217-1263-49bf-906a-8ec84e6ec3b9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782440776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RxVxgroX3On6H8SMBZy+I5j57FDfvO4So/Vpazbn4F4=;
	b=IJGmabABduP4sFsdxgWiagDoZGsN1Gty6KLeqBQz5lJcnyJTy7PxrtT48EICTwOOeQ1fOB
	EeIrRiGIw+idFkVTtAqevOW/vztrwyxhh5v4cqGELP1O0ZwG4vRqIYBHfE+X05uaKETI9A
	eogTHajJcWAaD3WUIo7Dsc31Y3n5fDo=
Date: Fri, 26 Jun 2026 10:24:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, jackmanb@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-3-surenb@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dtt5npqtae4nqujrkfyfbufgxgj3rtk1
X-Rspamd-Queue-Id: 85DC3160003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782440778-417327
X-HE-Meta: U2FsdGVkX18lzeJ8IPLfnZY4SUhKmw735HUyyhX2POCeIO0uGKw6YbGN8klp8K6yxCu/ucsXWZ1srN61vFg5RVYgSz2ey+BIpTNJoszlYYBMTcyps56cPebcTpXkQv8GMhHOxg8oGGHf/ntsJ12sBNkkbThSqkbfKCYHUbnpOEvRxQfcgjmI/2b1JuwK6paBc7bWKdzK4mqcIjUhfsug9KPvLIMWMtrwGvthuEtonHLn9lMOlP77HGGC1oif901CjajNmnUPi/XlmIhG3FxEYRSRbdKlHmBVt5j29iEG7TwIoO1hlgfcCBO+1VrTC44HIe+LAY0HwpEo8c0YSEi5zFYM4whAIi82t7iLDiWxUhuOjUy1qEacrSt8yCHSIdNyRsDA/rpzCptYHIalZe+m5x7ArP0trQADGNs0LjYKrUANCXPFcrHktOn7vKJuo0Vhl/Pg00JbvVE7OHI/xq++R48TwI5ITjbAC2RFonDv1pB8kaA908kO5TuP09RRE4CALfwT4ceHVmfSnyEHLCDESQ4wUqTaDe9HwI1yvDX7rwgw++xwtyn+2L/tbB40quHsd0Jx68K/z6TdIKi/4lZ3PfrLNIfqsWTJTp5KswpPsLhonxLekt9dLwAZKfmDVhlsbIx4VCRHdxnUHYnOt/qXY5bjUcnfn/Lin4nNHz8N+hW5EjvTf/CYYjvvlzy3Kex47Ya9kCrPCvVLjndHoZp/H2tiCX0Biy12rRG7pBX3vyBiHsR0n8NIfnoTz5mmb7HhT+0eHaOyNmc0tyzTmgQVFymLp8Olp2/7YaNpccfZjRscWTZriUSQmTmP7R31DLuTKZkKPzFQhXDs1ZkT4D1trqvyzzhBM9NHvKoN3q/+pF/gNCIIJPM8d8fiBpDl/XM7WL6JzLfSJ07spxfhY0RJRmmQrsgTwPC1SeptEzlWSLkxoug7T/FpkG0qA71Lkht2jOhm5NlOMOO05sH2yFp
 0gkZAR+B
 THoqV7FydYJAn6OfrFoYW9GMRq5yTPWg3g5acfLeQILoWMKAPZ5KAPn+PNZunIIlMsrqDgtR5teDgqfH9IRYkymFIgyh6lZzCS5wIRbS+elQbLSi05DWf3VViOFsN13Ttso+GEO5t2/bRPCVxSIALlqTm4kL6LUIEaSNAXFybIuMWbezSp1bz1VwRi2EbwEr8wz7SWhBpdT7tveJaqgAIDFB9P1Z24UsI/YMmnnnhQkX5ySVuY0juA5ypne5HpuUSyHuooXgSHpvq25VLITWNp7PywZK2+roF7qkeAkIzDIYSntJ/QhNgJ9rOYAOVROIPsTOcZSDCYXLpzK2u6t3Z0PTlEfBVDNYwcO1XrqwZU1yI21MJepwiDpa3DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/26 02:48, Suren Baghdasaryan wrote:
> From: Lorenzo Stoakes <ljs@kernel.org>
>
> The alloc tagging work is really mm-specific, so move alloc_tag.c to mm/
> and additionally update the MAINTAINERS entry to place it within memory
> management and port over the Kconfig and Makefile code to mm.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>


I've applied this to my local tree and everything looks good.

LGTM.


Tested-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Hao Ge <hao.ge@linux.dev>


Thanks

Best Regards

Hao


> ---
>   MAINTAINERS             | 20 ++++++++++----------
>   lib/Kconfig.debug       | 28 ----------------------------
>   lib/Makefile            |  1 -
>   mm/Kconfig.debug        | 28 ++++++++++++++++++++++++++++
>   mm/Makefile             |  1 +
>   {lib => mm}/alloc_tag.c |  0
>   6 files changed, 39 insertions(+), 39 deletions(-)
>   rename {lib => mm}/alloc_tag.c (100%)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0948dc573744..3cf3cf2311e2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16704,16 +16704,6 @@ F:	mm/mm_init.c
>   F:	mm/rodata_test.c
>   F:	tools/testing/memblock/
>   
> -MEMORY ALLOCATION PROFILING
> -M:	Suren Baghdasaryan <surenb@google.com>
> -R:	Hao Ge <hao.ge@linux.dev>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -F:	Documentation/mm/allocation-profiling.rst
> -F:	include/linux/alloc_tag.h
> -F:	include/linux/pgalloc_tag.h
> -F:	lib/alloc_tag.c
> -
>   MEMORY CONTROLLER DRIVERS
>   M:	Krzysztof Kozlowski <krzk@kernel.org>
>   L:	linux-kernel@vger.kernel.org
> @@ -16758,6 +16748,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
>   F:	mm/
>   F:	tools/mm/
>   
> +MEMORY MANAGEMENT - ALLOCATION PROFILING (ALLOC TAG)
> +M:	Suren Baghdasaryan <surenb@google.com>
> +R:	Hao Ge <hao.ge@linux.dev>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +F:	Documentation/mm/allocation-profiling.rst
> +F:	include/linux/alloc_tag.h
> +F:	include/linux/pgalloc_tag.h
> +F:	mm/alloc_tag.c
> +
>   MEMORY MANAGEMENT - BALLOON
>   M:	Andrew Morton <akpm@linux-foundation.org>
>   M:	David Hildenbrand <david@kernel.org>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8ff5adcfe1e0..3762015522c3 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1048,34 +1048,6 @@ config CODE_TAGGING
>   	bool
>   	select KALLSYMS
>   
> -config MEM_ALLOC_PROFILING
> -	bool "Enable memory allocation profiling"
> -	default n
> -	depends on MMU
> -	depends on PROC_FS
> -	depends on !DEBUG_FORCE_WEAK_PER_CPU
> -	select CODE_TAGGING
> -	select PAGE_EXTENSION
> -	select SLAB_OBJ_EXT
> -	help
> -	  Track allocation source code and record total allocation size
> -	  initiated at that code location. The mechanism can be used to track
> -	  memory leaks with a low performance and memory impact.
> -
> -config MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
> -	bool "Enable memory allocation profiling by default"
> -	default y
> -	depends on MEM_ALLOC_PROFILING
> -
> -config MEM_ALLOC_PROFILING_DEBUG
> -	bool "Memory allocation profiler debugging"
> -	default n
> -	depends on MEM_ALLOC_PROFILING
> -	select MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
> -	help
> -	  Adds warnings with helpful error messages for memory allocation
> -	  profiling.
> -
>   source "lib/Kconfig.kasan"
>   source "lib/Kconfig.kfence"
>   source "lib/Kconfig.kmsan"
> diff --git a/lib/Makefile b/lib/Makefile
> index f33a24bf1c19..44f6538533a9 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -197,7 +197,6 @@ obj-$(CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT) += \
>   obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
>   
>   obj-$(CONFIG_CODE_TAGGING) += codetag.o
> -obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
>   
>   lib-$(CONFIG_GENERIC_BUG) += bug.o
>   
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 91b3e027b753..5737a504efbb 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -320,3 +320,31 @@ config PER_VMA_LOCK_STATS
>   	  overhead in the page fault path.
>   
>   	  If in doubt, say N.
> +
> +config MEM_ALLOC_PROFILING
> +	bool "Enable memory allocation profiling"
> +	default n
> +	depends on MMU
> +	depends on PROC_FS
> +	depends on !DEBUG_FORCE_WEAK_PER_CPU
> +	select CODE_TAGGING
> +	select PAGE_EXTENSION
> +	select SLAB_OBJ_EXT
> +	help
> +	  Track allocation source code and record total allocation size
> +	  initiated at that code location. The mechanism can be used to track
> +	  memory leaks with a low performance and memory impact.
> +
> +config MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
> +	bool "Enable memory allocation profiling by default"
> +	default y
> +	depends on MEM_ALLOC_PROFILING
> +
> +config MEM_ALLOC_PROFILING_DEBUG
> +	bool "Memory allocation profiler debugging"
> +	default n
> +	depends on MEM_ALLOC_PROFILING
> +	select MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
> +	help
> +	  Adds warnings with helpful error messages for memory allocation
> +	  profiling.
> diff --git a/mm/Makefile b/mm/Makefile
> index eff9f9e7e061..4fc713867b9b 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>   obj-$(CONFIG_EXECMEM) += execmem.o
>   obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>   obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> +obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
> diff --git a/lib/alloc_tag.c b/mm/alloc_tag.c
> similarity index 100%
> rename from lib/alloc_tag.c
> rename to mm/alloc_tag.c

