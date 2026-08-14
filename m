Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49854C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3416B0309; Fri, 14 Aug 2026 08:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D056B030A; Fri, 14 Aug 2026 08:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B266B030B; Fri, 14 Aug 2026 08:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF0F6B0309
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:39:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AED4EA284B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:39:53 +0000 (UTC)
X-FDA: 85099831866.01.2C7C771
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 21C7F140006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:39:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+kVpgCi;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786711192;
	b=KhuRuepQJoX0oRzxY4bz66I+ktKMsF3VEVe0Dy0ykmhP+ezGLKJZPvjET30AbJb2xCDG8z
	0b4igomfOp2J1kz7WM/zanVjJGIELIFUivppIityefPK81vmM5AtAVhwHudghGYbzTjwNx
	57kSZUQmnpiDUJy3WA+kW76AxIxJe2Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+kVpgCi;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786711192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sg2Fpi/B0x2kWvzgITLa65nTIYhPhK7l7uRWEIj1A8=;
	b=S3ZVnCc3VwMyIxYRPhPfwfz8WBjbGv6K+dmYdCu3x2DWe/MEeTC9//zw3s7GG5dwr5jn28
	1AE8jHbpZ8KHQMPCJRY4ZakbZDGwweIuU23Gsrr8p+JPDGR78h5Ro8sD8Zgc2yXGytrniA
	OTP4tlxpzZJdDAU3vKZ1AmWtOQYgkDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F133600C3;
	Fri, 14 Aug 2026 12:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C5E1F00A3A;
	Fri, 14 Aug 2026 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786711191;
	bh=4sg2Fpi/B0x2kWvzgITLa65nTIYhPhK7l7uRWEIj1A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O+kVpgCiOmkp8MZDf66Mx7mlR3n94nqd1qtfgseHoWHpco+dyzQY2x1b77Q47piJC
	 V0kVXfP06DjTRL4VxW2tlseUWftYTnTBNL/egp79Z6DW1S8rCm3Q8CEOJBm3LKKVun
	 AcpBf8WqTSpncOY0zaZOEbsJV9Fp54WVwBa0q8oZPiwBSEGHq7oBdIl77PhbpqA427
	 50KAv5SH/rqGr8R68XsP71fpTQoKLn/fsoubLPq7CiHz3Bq4IdGQvK6JWOgpcU2Gqy
	 rJLz4cXoVKBFcNa7WlDSjHBM4EV9z+BpkXq+FYeoSzVtP1r6QtvWfEUlrY7ntZMsF2
	 zXnQmTbraQe/w==
Date: Fri, 14 Aug 2026 13:39:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kselftest@vger.kernel.org, 
	linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 4/6] selftests: fix build errors on alpine linux
Message-ID: <an8MHlxZzu6a_1ui@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-5-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-5-thehajime@gmail.com>
X-Rspamd-Queue-Id: 21C7F140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xik865ek9dxne6qj8frpntffug5n8b8p
X-HE-Tag: 1786711191-157287
X-HE-Meta: U2FsdGVkX18Rz+yU5vj7dT/rOLYiWGLwvGMneaX/FDNfdiOIOvwA9+bG4HGJCZsO59zIqKQa5ezSfAU53sLwFjEetRupNIpGZ949770Ue7Ehy+pUOzCi36g6a9XMEThr7elkXoWqIcU9cC4bOGKwvYBR4eTf0d2Ihg6yF8VCR49GG6lG1bLXtRrtkJ2X/ZFBFTrtBYUAoB1hxVQ7HfGSSALiNqntXsKe/7Qj75gzg9vKMnOJlzbsJymfshT0c2DrFYvOThq52Rjsej4RNixiDsdF8Z5XCvWTVSSNc/HEMGbNS/7QEWDgxQ3abgxasfJyMqTEo8Tv3a6RLAsoBnEzDtkrsjad5aQPBJ5PAys4CkPpDb8y5FJzOOaDFaOsEFOL049j+uuWSj1KcjyrQC5qlQHq/xiED0TznbPV++j7gly9heeD3bhgxjkgGUxzxw3GpZWKbFwaHOgPKlUpQ8K0avXV5/ePyFgqGfmX04Ng5EI1bz++RG+bXV1n8tV+IFF6jDm/SWsKF0L21xP4p11DCQCEsXVrL7/eKbTjoT5cGN1gzjLE34YdGU2XLemZWYo/5QxjPxsu7Wl2Khz93QgWo7l+gCvZTCoCsqe3Z8wcxIApp6nXhw2e+DgbC6lgVcyM1nO1tslPX4TAML7ztqXiahQ6+2MKv33uoZN1DKqqbzdxpOGUX5umZSpyt5mgnaFZXEhTSbUgOlMidmQJkF3Ik7k5nwv0gav3EvkNzF8u63VEfU+COJ6IjXd6SIw/gHVTGGSOi+mnQ9BbCeKbmzaPpVyToOkK488yRMqzkrZKtmwBWw5vzhM/U5hejXoNgrzujfabPad3MNhZpLcL5dv/bY5DLMUMXGgaSI+su0gdCN9cdMucZ/RiuZOwq5C+Ql1hHo8+xt5nG1/nC2alDQtttY5XEl+Ul6cuxjsxAjfV/iSQq4xbO4lIq2zyzZf+gwSK9D7EhqVXgvBzHds3NvB
 qr4BeiTM
 wpEQ/VXR980ejjuwSvY4vN7kJAow4NMQ0kBtlkTKnQMNSFuywuLdijWV2DczSsepA6ZcsXs+NnAj546veNYGTiJzd3Cthh7amGXNwcv9sVktRhl9fLPLYz8f8vVJpSrwueouY0dTwoT4IQ2sMNPAhBrfv/rmbohePu6T22jgw/W2Hw2zvSNyv5hvmeWi3AjOUY2tvwZD+egrmOWq0lY1vLCLU3ofNGy/Dy6zHqx1vDS+FPrOW080Iz9fmS4g8TZkx3yPSzBWIZMz/JQc3YhujIwcpLhj91ueoG5CJAVJlM8pzJ3hvB2IohnyZjLu8c028nwohNK8Al6/x80N581eeaX1dmUDPVmgHP9MGkfGduzjWSuFU2O5RqpFzl2noLYTNo4UImRwdjFEe24JyITqGWvnhP8bH2UhIEG1JMqWET8mTwM7fZ68x+xQVc2mZ9D/x2ZSZvlm9ETxDKRWmjwPAOScY4wcAlClac4qjjjjlHuNWm/igGrtTrLiI2NTd84JHK2AVm+Gwtn0K2gbH6lVdblBulmmeui4nuGd5cLPCFJqxkllOWR6aW97kxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

I mean vaguely looks un-invasive which is the test here.

Couple comments below.

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

You probably want to update this comment.

> -CFLAGS += -D_GNU_SOURCE=
> +CFLAGS += -D_GNU_SOURCE= -D_LARGEFILE64_SOURCE
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

Probably better to declare different functions to make this less hideous.

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

--
Cheers, Lorenzo

