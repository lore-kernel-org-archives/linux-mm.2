Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D64CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88FF6B00C5; Fri, 26 Jun 2026 05:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B610B6B00C6; Fri, 26 Jun 2026 05:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50A26B00C7; Fri, 26 Jun 2026 05:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77E936B00C5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:12:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC7921403AE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:12:24 +0000 (UTC)
X-FDA: 84921497808.03.246361E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 11B451C0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:12:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMC3jSZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782465143;
	b=H+qwUjFt/hrP9Nu3dHKeTt3HZgXnYCkMDzXlOgHtimQFADP5uqbGlMCz4jpHK6jSXff4Bs
	rPAHjKI7ArUEPMWHQct+NKjNnjGqCDMafHjrmhRlqOPC9g4RY/yAf5WaBJ+APp46cEp4hr
	cV+JhlR3xPDSaV7B4nldNVB/hKzHlyo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782465143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkICobQxMdgEf0TF97vW9OrdNU0DfI1oQRf12CGk4fI=;
	b=3rOM5SEC3xp8snpAEQrN+aahpiTXQbshs2TiURbgN7S4TwHfs2iUs3v04ih14Z5xyOMZ6L
	5NrjfowVQfPPEKwS/lnNLpCIepe0eofw7G7sDgz/035eHQX8pcZrftJ9I4GmeApflN61rA
	71/0uX/aRnRrKPSMTXVS+dP0erFNX0c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMC3jSZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15F2443B3A;
	Fri, 26 Jun 2026 09:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9581F000E9;
	Fri, 26 Jun 2026 09:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465142;
	bh=dkICobQxMdgEf0TF97vW9OrdNU0DfI1oQRf12CGk4fI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EMC3jSZ2v3yLuAz5qdUWJ9WSCFp23pbz41AAqZbsl4riIibxTsPWZ2n3Fjv/L7RAm
	 VSMLj3twJA3gbgtK0tAUbAx17ezPWOxrY5Mh+FMYIDVGLiXWUyPfvyeNW7HQBJc8NA
	 TZc4LFsDWpRyP1bL04DzB8Z2Y+sv9J6jfciF4iZ+QqFH2YSPj51pG6N8LndFzQkg+X
	 RUGRacusYefvNKT+ftI7ycfZxI99VcJD8EydP1f7vg7Q3pSKWQsK+b1csurbJteSah
	 n1XIkY8nK63SL9pmAQiDRLsFxFHFK4NC+MuA0PPO1mZPt/955DRiKubBCaH0GGBRrv
	 buclfOnIscuIg==
Message-ID: <5090425b-093e-4e42-83e9-c7efe119e38e@kernel.org>
Date: Fri, 26 Jun 2026 11:12:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, hao.ge@linux.dev, jackmanb@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-3-surenb@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11B451C0003
X-Stat-Signature: xqasy3xp1jtp6jyd6388qjgqedznsdc5
X-HE-Tag: 1782465142-195012
X-HE-Meta: U2FsdGVkX1/SXGMBecPc+Sjfjir9TsdvP/xiZ06GKxnBJd/ggsqgZPMAqywex2j2UlxBYzXbD0s9GzluROyGqI/wujg3J+TTxpJwxjWBHs3kFjGhTRD3a8YvKxWIsw3qoVKuvoFAiwhg45HVFxFWDoxJnuHnYOE2R2HJKh+1Cowz71uFLiZmqzsdW3dxw/xsaIfdPloNxlUgBkOU95vQsKBP7Wk5IJIn3wlmDNx8cf2b2pJFXn0xP4PZgebfUfQ7+QDfMrWTgqljLXV3riljzn+hdYtwB37W1kKoKzQ8ksv5yUfilD0kA2MpBovpK7v7DAOxyO7XVOTGnCmDIa6ThiCtJf8OQfgKMImCy/6D/LjdiZkQ8cnrKHkIwGhg8qas+xKNXSBNPluKkpMDZikO8QjA4/PynK02qRe5erT7RNbMGp1YPb+0ge0FROqBVGqKX2o8Mbf9gN8aC4PjiNl4RrYzqS5voUUVX0mtn7yRbCwaLgHJlaHTsMYm54DzVvU13DWbaCi/oS7J0xjPGtmoTZmsLQmgDnUKHunYlpGq2Kuf5ZGnJ2u91o05KZfgknZhR7+jAaBPZVJpuuOjy7kRjFztG73xAw+cnbGR4jqRBGNoE/+PLK9HCaM30uj9f6Hssx4DDIRtIH6DPioL2ZRNcfFbq5NrdHHWVprrWok2UBNaW8H5x9wBr2lCBQDlmD4pATZmYBgqGcDPYAdjeF+kWGw2Td8OrS5vtAkz3LafYHyKWTOnqsd+bZzVSXaPPh5NY6FhFEXTDT1n0/1Dv4eCAJUG5lVtODsoxfQ6RjDYWv6oUXuI3fFfT8F8DW1KLe93abhWWvhBZ8NfiGc7FcxgZcqZSGCaM29tgo2mycB5wE0pT3oAr2HeVAezYHRV1nLdokfIvR+/MoS0aJogu4JovR8e8/WAKRdrbg0XMCmIMV1ngcu0nuZgzgnTAYljBNKs5TZoMsfAp/F7aPcImH4
 zzIBVrI4
 Ub+JwPK3u62SZrLdOjT7dvSClUOvaEmEM+HPxla0qbpQPuRtstlczaIW7EZFi+m+2EqjiI2Gl4S+mo3ewJ8l2KzxDNQZfk9+dB+KO/wkKuLBhNuA+/dRPFt4B9gRhOhb/y5Try2ZSYdRM4bLZ73RXqlqozb2CMlJCidM94uP4k1FPJIoT/eWg66nao9JtfW7vq/f+hNdUruPHkcXOOxoNRv1NnnPj6Q4Ajvdbog9l3vbcwsypp+jJCkYxyckHh9U9cxospSfTNd+dkg/T4p91UgqlgVwkzXJsS062TncURjLRi657XsqROiG+11c+fOfpIHP4k7QDzIsiaYtouhAj0OAKFAU1fXcTcRswVrvYfPKGksmFMxRHW3vkxln65GBVbyDBwwcJjBdm9BCvij0zfHzW98Fttz6hjX2PtxhcIhGzP74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 20:48, Suren Baghdasaryan wrote:
> From: Lorenzo Stoakes <ljs@kernel.org>
> 
> The alloc tagging work is really mm-specific, so move alloc_tag.c to mm/
> and additionally update the MAINTAINERS entry to place it within memory
> management and port over the Kconfig and Makefile code to mm.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  MAINTAINERS             | 20 ++++++++++----------
>  lib/Kconfig.debug       | 28 ----------------------------
>  lib/Makefile            |  1 -
>  mm/Kconfig.debug        | 28 ++++++++++++++++++++++++++++
>  mm/Makefile             |  1 +
>  {lib => mm}/alloc_tag.c |  0
>  6 files changed, 39 insertions(+), 39 deletions(-)
>  rename {lib => mm}/alloc_tag.c (100%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0948dc573744..3cf3cf2311e2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16704,16 +16704,6 @@ F:	mm/mm_init.c
>  F:	mm/rodata_test.c
>  F:	tools/testing/memblock/
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
>  MEMORY CONTROLLER DRIVERS
>  M:	Krzysztof Kozlowski <krzk@kernel.org>
>  L:	linux-kernel@vger.kernel.org
> @@ -16758,6 +16748,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
>  F:	mm/
>  F:	tools/mm/
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
>  MEMORY MANAGEMENT - BALLOON
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8ff5adcfe1e0..3762015522c3 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1048,34 +1048,6 @@ config CODE_TAGGING
>  	bool
>  	select KALLSYMS
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
>  source "lib/Kconfig.kasan"
>  source "lib/Kconfig.kfence"
>  source "lib/Kconfig.kmsan"
> diff --git a/lib/Makefile b/lib/Makefile
> index f33a24bf1c19..44f6538533a9 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -197,7 +197,6 @@ obj-$(CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT) += \
>  obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
>  
>  obj-$(CONFIG_CODE_TAGGING) += codetag.o
> -obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
>  
>  lib-$(CONFIG_GENERIC_BUG) += bug.o
>  
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 91b3e027b753..5737a504efbb 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -320,3 +320,31 @@ config PER_VMA_LOCK_STATS
>  	  overhead in the page fault path.
>  
>  	  If in doubt, say N.
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
>  obj-$(CONFIG_EXECMEM) += execmem.o
>  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> +obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
> diff --git a/lib/alloc_tag.c b/mm/alloc_tag.c
> similarity index 100%
> rename from lib/alloc_tag.c
> rename to mm/alloc_tag.c


