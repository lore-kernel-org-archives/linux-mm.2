Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD619C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 09:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AFAF6B02FA; Fri, 14 Aug 2026 05:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890186B02FB; Fri, 14 Aug 2026 05:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EE96B02FC; Fri, 14 Aug 2026 05:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5C96B02FA
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:34:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CECD7A0390
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:34:35 +0000 (UTC)
X-FDA: 85099364910.10.4CD4B1B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id A10F9180006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:34:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hhF35gw/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vTQ+Ghzt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kRByEFa+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xeRQuVjC;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786700073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLUyFxQVLdSjfBmCWkDLy4B3Fcl8gZoDogFSRwHO4t4=;
	b=wWSeAaFEOnOZ7XcHRGIhF3lb6H0Gm3eijWFuNvq4gZYfYXHwf4b391O49iOLIJaXm146BN
	EgXK8lmu15GSQuZqgS39e+LoIluSz5m9ucSaQaz7AKD8TPl5+J1k+iqfbrciIChwWzu89I
	Uu/LxmbvVUThTxoAOIzWL5FLaSJp0II=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786700073;
	b=W/vG5gfTwvyguhuI/4XD3i2OMQ040hh5k6hEzEqCglPjsDsvqX9J549bBJP2vNDx/qtKHl
	vtD2S45/xuyDfQBoRjbmUcQxD6f7ygbvKWa4GMtQPTv1t95V/5ikVZ9fCorisyGKInbJif
	KDy5IoxJjiYzkKZ5ACNxtLC9cEY/PTg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hhF35gw/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vTQ+Ghzt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kRByEFa+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xeRQuVjC;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF7DC82E4F;
	Fri, 14 Aug 2026 09:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786700068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLUyFxQVLdSjfBmCWkDLy4B3Fcl8gZoDogFSRwHO4t4=;
	b=hhF35gw/LYvLOC7bzOPZX7IAX7VCpsmamR8rPAxK4T9PEQeKITw8G9Gk/nhimMZKHzB9A/
	YK+VqcA95PYvxi33jvnkplohRdY6j62ZXFmi4eSNC9zzHiLOxeRjinAIhZvySZvk6PzoGx
	U8ckiR6gwAfxvMb8u34EmEtlyUhfSbo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786700068;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLUyFxQVLdSjfBmCWkDLy4B3Fcl8gZoDogFSRwHO4t4=;
	b=vTQ+GhztcQ/SYxO3i4hqHl6/agTaIKB2p264q6D1J8JFym4w7q6xS64wAW1UcG/0akaZ50
	tcYqZh6IgghUoDDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786700063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLUyFxQVLdSjfBmCWkDLy4B3Fcl8gZoDogFSRwHO4t4=;
	b=kRByEFa+u64c03zl4c9aZGcACEi89BLMiT0kj5hSqyelmNEeKzfOrT6xSIJeFiGn7THeHA
	RIiL4BDbwL0X9guSRyLAPzlTNDPCU7++tfZZVetuTTKJVuZGonK8UEJV+udzKIVTQqc/VW
	4kscmoaC3F0F3ZNohYOBVRo6J+ag0YE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786700063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLUyFxQVLdSjfBmCWkDLy4B3Fcl8gZoDogFSRwHO4t4=;
	b=xeRQuVjCrGpluq4gLB1As2xY/vI2RmDCzwDRwZU1ukp3fmj7DP+sKd4qYA7Z6kx6YwV7wW
	bQghStLan0/QwwBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF8D1782EA;
	Fri, 14 Aug 2026 09:34:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Xf7UMh7hfmrabgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 14 Aug 2026 09:34:22 +0000
Date: Fri, 14 Aug 2026 10:34:21 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 4/6] selftests: fix build errors on alpine linux
Message-ID: <an7eC0oBvfjB6g54@pedro-suse.lan>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-5-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-5-thehajime@gmail.com>
X-Rspam-User: 
X-Stat-Signature: n4tys7ie7zmrxjc736ug3tnt85uo3cnx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A10F9180006
X-HE-Tag: 1786700073-258539
X-HE-Meta: U2FsdGVkX1/eVK9NYHpnWHCwC6R1UjI0xup3erL2tjzHBtWhqZxjZMizGTanVBbnSznzhWe1oypR5fbfNs7AMERkgSaoHc9DW8UffE6TN4CTsbCbJwILiXLiuvMqZwJ6JBnANvT3F4a9fg2wiSxF+Y8e8/7O4gEQ33DQhhvjxaAJjVX3YDrSOpZux0rKJGcm+G6cGe7MsNJaGhUE6LJupxA/ySgThNz7SXMJYqWGalGAtAxhY3otZvU1YFreaKBiY3gJ4Y67iJFrd1WHQ2Pk2xoQ+ECw2PFWoWfDIvDbYtdM33NBcRXrPYb5UcBW1uhrllh/yIEKqeManuGgl+zxbIvhyyRa9V0gkcxMGLPp/2Fw/h6AFa0Yhdg1+QVhoqd7irznYwB/Gu9dQSnSZaS+Gvf7L/KOik6NjL31EOU8IZvuiJfFeHCNLeHyw9cxq7/OQSP5qhnGbedH7MtwDnkTda9L6QgTqpuW11k8V0TnBR10DjDkT64qpQGqNafSKHPYJLPWBF4ohljEzpJkCdBTJsqpcaeqJ23iIULXArPh0AYU72CxXU8wH9obGC4K1Zpfb5XLq064qCISOFccVNajsCIkOwsRv5oo1owYAt24rFy7aLRdk9HRZFT/vVbAEJT8nRj2LwQ4oLg5n9a/i6FBwSXCmcZbxou0lu4vXY5SH6rs53xAd5H9vimqxPCmbSoBidvBg0bbboE/lK5nOAErRo6D05oo1ZRM6KFtmXtQGfUTCmCdeOt8ji6IL2/BFSosAMu9XPxwmFZKyJsCquiFL/SaFUcQdxx4iUGBDveNBmLxhKDwtwrZR35bQWgZxbSidxcR2GmpeDnlG5hobQajLxbtLbzZVP5c8bWyX2KprfaNTyxLAH9SwSxW/krcKzDEMqNhbuRQJHEgdjt3Miw4eWAD4R/9HWB+GDFL5HJ0PIi8L2QgkCp1s8bYRLta5hC0oyX771ywQc4xucAv1RO
 Dvhzh+2H
 5vzGlcqmOQ0gKsfQSwWeITozk90LnDtoM919VcKT/pEj+Dx3KTAUZaHyM2P0yzmuxRwTUD5Joi2wvULdQVKuuGZ8oBkvH8EYlBmCwGnPveY5U+UXr2bjogqdcsL16v8g8hrqMbr4By8Z2q3XlOIqZqkl/9npbh/tB4s/HIVhYlifmYrB5XPOA7aE/DrI0xEqr+aPDJmHR6BNzP97EpolQ+e50NfRDuRTHccjZ89zBeZnUBzWsTuaqySwf+X1JynqW3bT07vl0hI5wvnDyiPEpsyPCp5R7Z9PzK8T8Uf+NqNAnlHNRLNv8SvXQFQfKr5gnhLgPqeQIXhKru76cAxjjRAXpbrzj15c5zNk6ZEbsAdzz1PqYhsgjeYJWFYP/safb4kq6L2AGOSy5/XCgfgkUp66PQfZXy29M9HuTiL+5E0lDa1h814aM+xqD88U8yaakNmq7G1YgGEdp1uzlQ3Od6Cu1VFQye4JacHIZ0kP+mubIVFOfO6MW1pFh9hP5jjMooHM/qPJZKtRKUSv8s30QTFW/CZbwWMcSfO8qgViDao+gqo7eNv4CDLW7jCTaJV9u+CAi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

/me puts on his libc hat

On Thu, Aug 13, 2026 at 03:33:59PM +0900, Hajime Tazaki wrote:
> Some nommu architectures only work on Alpine Linux, which doesn't use
> glibc for the standard library.  It uses musl-libc and is implemented in
> a different way as glibc, resulting build failures.
> 
> This commit fixes this issue by adding missing definitions. The fixes
> are now only covered to TARGETS=mm which was tested for the moment;
> future contributions are needed to fully build/execute tests on nommu
> platforms.
> 
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-um@lists.infradead.org
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> ---
>  tools/testing/selftests/kselftest.h      | 43 ++++++++++++++++++++++++
>  tools/testing/selftests/lib.mk           |  2 +-
>  tools/testing/selftests/mm/hugetlb_dio.c |  8 ++---
>  tools/testing/selftests/mm/mdwe_test.c   |  4 +--
>  4 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> index ae18c491ae53..ac21bf3d802e 100644
> --- a/tools/testing/selftests/kselftest.h
> +++ b/tools/testing/selftests/kselftest.h
> @@ -58,6 +58,7 @@
>  #include <string.h>
>  #include <stdio.h>
>  #include <sys/utsname.h>
> +#include <stdint.h>
>  #endif
>  
>  #ifndef ARRAY_SIZE
> @@ -81,6 +82,48 @@
>  #endif
>  #endif /* end arch */
>  
> +#if !defined(NOLIBC) && !defined(__GLIBC__)
> +#ifdef __LP64__
> +typedef int64_t __fsword_t;
> +#else
> +typedef int32_t __fsword_t;
> +#endif

The code should not be using __fsword_t. Per statfs(2):

       The __fsword_t type used for various fields in the statfs
       structure definition is a glibc internal type, not intended for
       public use.  This leaves the programmer in a bit of a conundrum
       when trying to copy or compare these fields to local variables in
       a program.  Using unsigned int for such variables suffices on most
       systems.

and indeed if you look at musl's statvfs definition:
struct statvfs {
	/* ... */
	unsigned int f_type;
	/* ... */
};

so it should be perfectly cromulent to use unsigned int here. Or use an
actual usable interface :)

> +
> +/*
> + * for a workaround to avoid struct conflict under
> + * musl-libc (<sys/prctl.h> v.s. <linux/prctl.h>)
> + */
> +#include <sys/prctl.h>
> +#ifndef _LINUX_PRCTL_H
> +#define _LINUX_PRCTL_H
> +#endif
> +
> +#ifndef PR_SET_MDWE
> +#define PR_SET_MDWE 65
> +#endif
> +
> +#ifndef PR_MDWE_REFUSE_EXEC_GAIN
> +#define PR_MDWE_REFUSE_EXEC_GAIN (1UL << 0)
> +#endif
> +
> +#ifndef PR_MDWE_NO_INHERIT
> +#define PR_MDWE_NO_INHERIT (1UL << 1)
> +#endif
> +
> +#ifndef PR_GET_MDWE
> +#define PR_GET_MDWE 66
> +#endif
> +
> +#ifndef PR_SET_MEMORY_MERGE
> +#define PR_SET_MEMORY_MERGE 67
> +#endif
> +
> +#ifndef PR_GET_MEMORY_MERGE
> +#define PR_GET_MEMORY_MERGE 68
> +#endif
> +
> +#endif

This looks fine. It's the same old problem with musl and kernel headers.

> +
>  /* define kselftest exit codes */
>  #define KSFT_PASS  0
>  #define KSFT_FAIL  1
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index f02cc8a2e4ae..2cc819006424 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -197,7 +197,7 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
>  	$(CLEAN)
>  
>  # Build with _GNU_SOURCE by default
> -CFLAGS += -D_GNU_SOURCE=
> +CFLAGS += -D_GNU_SOURCE= -D_LARGEFILE64_SOURCE

What needs this?

>  
>  # Additional include paths needed by kselftest.h and local headers
>  CFLAGS += -I${top_srcdir}/tools/testing/selftests
> diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
> index fb4600570e13..aee6be530ccb 100644
> --- a/tools/testing/selftests/mm/hugetlb_dio.c
> +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> @@ -22,12 +22,9 @@
>  #include "kselftest.h"
>  #include "hugepage_settings.h"
>  
> -#ifndef STATX_DIOALIGN
> -#define STATX_DIOALIGN		0x00002000U
> -#endif

Why doesn't this fallback work?

> -
>  static int get_dio_alignment(int fd)
>  {
> +#ifdef STATX_DIOALIGN
>  	struct statx stx;
>  	int ret;
>  
> @@ -43,6 +40,9 @@ static int get_dio_alignment(int fd)
>  		return 1;
>  
>  	return stx.stx_dio_offset_align;
> +#else
> +	return -1;
> +#endif
>  }
>  
>  static bool check_dio_alignment(unsigned int start_off,
> diff --git a/tools/testing/selftests/mm/mdwe_test.c b/tools/testing/selftests/mm/mdwe_test.c
> index 647779653da0..031c79ed067e 100644
> --- a/tools/testing/selftests/mm/mdwe_test.c
> +++ b/tools/testing/selftests/mm/mdwe_test.c
> @@ -1,5 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> +#include "kselftest_harness.h"
> +
>  #ifdef __aarch64__
>  #include <asm/hwcap.h>
>  #endif
> @@ -14,8 +16,6 @@
>  #include <sys/wait.h>
>  #include <unistd.h>
>  
> -#include "kselftest_harness.h"
> -
>  #ifndef __aarch64__
>  # define PROT_BTI	0
>  #endif
> -- 
> 2.43.0
> 
> 

Honestly, I'm surprised you needed so few hacks for this! But if I am to
guess, there are certainly much more problematic selftests out there.

-- 
Pedro

