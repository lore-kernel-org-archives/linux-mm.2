Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A395ACDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496546B00EC; Fri, 26 Jun 2026 06:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420F66B00EE; Fri, 26 Jun 2026 06:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9256B00EF; Fri, 26 Jun 2026 06:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02BB46B00EC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:13:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73CA41C6247
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:13:04 +0000 (UTC)
X-FDA: 84921650688.18.56B5384
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD67E180015
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:13:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkUmBur+;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468782;
	b=0BCUEVTtj1f3n/LXiS58O/rrhmShU8koIjIqfRPVngr/O/gQp7cwqbLE6lS5qrbt/2DJgC
	Te8qMm0dQIuLGo2fNz9IFihChVwQhFdHp/xPOY3U6PwBKe8RbrvJQgm8EEH1petjA87wlX
	eS9/7l3Mj3yWh6tcOiJ6tEpjM6KXxyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLiF915NfwLlVsSq/4aXT/wvHW5AzhlVslUyqSeMDmY=;
	b=ULN7oIb+LAEt4GB/GrzuaynQaXPXQid3hd5mqRYiS8znxbBuMBxqwQHX6W0LosIQ0TC1Mk
	kBYZnH1a9/2gIEyyKZ7m5lpC0oW/w9Ajymja40S8941tH5o31qvy9NdpH6WPBNRtvQsJap
	WGCqLiPrPj71t1ihT012rpsy2FCz08I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkUmBur+;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 601F260098;
	Fri, 26 Jun 2026 10:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452731F000E9;
	Fri, 26 Jun 2026 10:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782468782;
	bh=TLiF915NfwLlVsSq/4aXT/wvHW5AzhlVslUyqSeMDmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IkUmBur+hR2C7H5r5OY8FChnTsJXdoIDefxQHV1RUUXO5CD358HNgpdA3jZOhIf+M
	 h93FSBaZ0HcQjofz07UgDyXxGhvrwXxNxgVeIGA5GGbMEc/AHwhRliI23hrzzWlU9m
	 fGGQ/1UqVLk4j0a2A75w5Wt5JOogseZcJe5EEVVVUwGGGrgdpghvh0dVJG0GXgmEoU
	 fQEGz39TXu8huP1maFinuCvz4dfLfGgmDcmb+yLMrv4OxMAqgygFEha8Juz9CEK/fa
	 ynr26K/mv+ZKn8IaaJceAyduIRqlRP+5bRU7cTU4CHsAC09EenWR+8ksHDNNXn7cYf
	 ZZU0XF01VKxaA==
Date: Fri, 26 Jun 2026 11:12:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
Message-ID: <aj5QBtJcphPElczI@lucifer>
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DD67E180015
X-Stat-Signature: j3fnmanr8mximnrh11sjyz17mc5j1ihr
X-HE-Tag: 1782468782-564680
X-HE-Meta: U2FsdGVkX18yt3FPOEJvJFLYStioQ1fSYt8oyGofvwAod0s8w2i9ObBqv4ef6HNthX/T9/quH0X69QYlGsFpL2fkVsoP4G+Q0EMj3eg0GnW0Bb1abZ9cfZLvjoFBjO2kvHAEB1ICYNasaDvb4S6wmrkelEdtYGJzWPm+asu5C8MWc4kO5yffwWssKc9xFGI8zvh3Zh8GDvp2VAN7unv1lqk2QsHXkzjdWgY0XocStHxNRHzG69j98OWs6FQDE12K5VWNaw0T2WPvGeoXSfL4jGNzmZ4jV7t1AT2uvZiCW/Xgu483Qmyn3tahJ0z1xVGUmTQ20zVKYj3qqAaaF+axYUtr8hEFAOQ5xFSAyd0r9rzhL782ig3vpmdbDLrLBrcO3Kq02/u3oh4T3dGSKZbkqeNgIZ1psTg/NSy/vsYgYOXEMfgApAWpESIkk9euI+Ivb2I78SEOSPKDeur0LWJgLG66ZPr+O3Sok3621UGBcGGfDPJM+Mcbu5ihq6p33tcwyc2uxJPrH7oQTl8y1ZjI/ILmxbzp1OeNiaCXetZ0q/1v8dtZ53rKi9XChOGV3Z5L97E+kmHTSXwThlUz292Pv6T/Rj/ExdnLLtaIeyaCzKg8CRjiYlcrTxbEO2ORW2P+shh4QPi7BonLAStZyMkl9HZXEdyPA13qu117pgib458kZtL/zdQVNGXXOaeDBEkSwo4Fp8qqzhkY4biKOEHgT9xkPoQm5yqIMIZqKbV+Zx1ToUppO3jnTfayLpglr400NtsdRkQx3Y5lgNHpRXn8ruKE+ZYHiqzZXbUJKYgSY9sJk1v+l6VfEzI+l/AymQGxy7jXklG8iwDpZ61GI0UOiKsxk0nmqG2QiryOOtOqG1v6kkrofZEHHvoSqT0aZH164pyWlhnHVUrrf7H5mP2hz8GvdKJ2rSBeLY2cKpDUpHgQcdX8Xs0+BulG0FGVO4hQVqbOakSuCruwKhSXiby
 GyYhrQ6s
 QvNy9QegWM4wtfWz7tG85Z+o+HkptM41eCrI17p/PiFBsxzuMjBxGO6nBaF0q3GNpNAK5yoKqrQSok5UFsYg21r0FkGbFW6JqPS810RmATncnXlMP8tWipZiXNkfZHho058VP4H0anuqn+ircBUswTXVZ2UHTIHaNMICM/sUgi4yhQCetBTLTJOeYanCGeNLwskWxuRSh7eQwAajiw+J9/Kx5TrlMmfJ3KtpIGrXgkELL9bHnkYE8iNvhDk019WdjQO+yVny46xPAOm2EKPHmk82FcdrP2knFNueWrBKbpBEIEr6TRmeTELTn5Uqj2Q/IKTbn0EGSBgK5OwE++jMC2wTVPOxkBEmqJdoqoffQEyrE2C3TxH0lmvB9I2vynRZcDh7NHzKgTjvMdWpoL7Di/emE5+Ux7q2Ck7hC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:48:57AM -0700, Suren Baghdasaryan wrote:
> From: Lorenzo Stoakes <ljs@kernel.org>
>
> The alloc tagging work is really mm-specific, so move alloc_tag.c to mm/
> and additionally update the MAINTAINERS entry to place it within memory
> management and port over the Kconfig and Makefile code to mm.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM (obviously :P) so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

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
> --
> 2.55.0.rc0.799.gd6f94ed593-goog
>

Thanks, Lorenzo

