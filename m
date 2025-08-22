Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1CE6CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 14:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95748E00B2; Fri, 22 Aug 2025 10:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3ED78E009D; Fri, 22 Aug 2025 10:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2EA08E00B2; Fri, 22 Aug 2025 10:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7F388E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:51:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5506E1A01F8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:51:16 +0000 (UTC)
X-FDA: 83804681352.06.9A60A0A
Received: from smtp-190a.mail.infomaniak.ch (smtp-190a.mail.infomaniak.ch [185.125.25.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id F36EA2000E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:51:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=digikod.net header.s=20191114 header.b=TvcZ+Kjv;
	spf=pass (imf03.hostedemail.com: domain of mic@digikod.net designates 185.125.25.10 as permitted sender) smtp.mailfrom=mic@digikod.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755874274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTTfmyqDupOjx6oqqavArctJ4iCrnJ+ZVQgZlvGbaKA=;
	b=XXjtW/8hyP76dS6KFVRki7Tam3WtXWLsO1IQPF/J3zD4HR2wRY1SaV9C1a3dEJFVKV5RO7
	E81wzqtybyRJfx/CKZeFCXGaeJZIWchHyBavtiA+YA/KAicDV+/vOvM8t25uVckY/c84s+
	zBIfMesy7NrALkEL/tDvVtJmXOoIbLU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=digikod.net header.s=20191114 header.b=TvcZ+Kjv;
	spf=pass (imf03.hostedemail.com: domain of mic@digikod.net designates 185.125.25.10 as permitted sender) smtp.mailfrom=mic@digikod.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755874274; a=rsa-sha256;
	cv=none;
	b=dB+hYpaEcnzyGXPp9YHeH4ZQRX6gUIOXKCTEwunYkEJhoc1q3yPDvmc3RjHC4dyJee58Y8
	dQqb0z2fa55uIFJVui5vARpjZ0SwcKqvKNfsyig82uptwTXy4G8PsQTZhro6V4jsn7d1cd
	tcgDipGsvriJUrXUJ97N5uHl0InLmvU=
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246c])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4c7jmv6Yzyz997;
	Fri, 22 Aug 2025 16:51:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1755874271;
	bh=zTTfmyqDupOjx6oqqavArctJ4iCrnJ+ZVQgZlvGbaKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TvcZ+Kjv3uiFSzBmD6CV25iFw47KiUlXV6COeYfUKWUrElaR53ZVWrCnbp9ydTekv
	 6UsvJuVk02SEcKusMSylawRGBOCGBi4Qv9BNyoTgDZPnVA7pj2yrujLWENWoohYZv6
	 yCsGRC0FUxE07oBZSN53cZxCMXLrRrgGZYhsCVak=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4c7jmt2VbwzFpN;
	Fri, 22 Aug 2025 16:51:10 +0200 (CEST)
Date: Fri, 22 Aug 2025 16:51:09 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, gnoack@google.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, ming.lei@redhat.com, skhan@linuxfoundation.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] selftests: centralise maybe-unused definition in
 kselftest.h
Message-ID: <20250822.Ahno5pong1Ai@digikod.net>
References: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
X-Infomaniak-Routing: alpha
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F36EA2000E
X-Stat-Signature: 4e5ur8fxu1dntew63dnoigy36n1r8qoc
X-Rspam-User: 
X-HE-Tag: 1755874273-285237
X-HE-Meta: U2FsdGVkX186fKqDiFDoCS/T1kmNa/ogpHFxa7rB0rNOvIUg9t+aSZtQZctbaIK5tQwxcd+RNubv00WOKPEFassHOCGqyVebiXtyNDThHbJQNOlHEaW2CWAgePOLHC3EHO3712mOwE7RQx7dBWvBDEzV0Thbi4opIQuncJZzHM8rf/Kehm1sj6h/1KRZWd17WS0ilcoyZkKldRXiCmd9uBl+AGSO+yoMkx582/PmQmzBKapRcpPkux62LfCJ00vB0zrgSaPRX0ccycj3X37Xef+F5qRQYKt6OJkAs3lwlefsWFfVmK2EugOjfdyA10yIWZin3sULU+qY5Vlmn2zA+hslwpSop2gbYcP6AvwXXrH7isix/y4V9cD5sUmbdon/MFK+7FU+nKmXKGdzIUQV2tCuBkpSOF+Q9AArvWTQ3qSddB9PzJelN6L+wDJlCFgL5/XhQ5qZJiWl6YjLR/j5CcpVpGpTtoMchj2Iiby3Sw10Q8F8Y9sW6uFTm3iA5RZDguXJ1ZBBpt0IKdAtqTYZOJAOXOq/wejmmF8ledk/gS64u5pVQUxMbrkhHgPgf3DmIi3GIOlw0oy2OARvxwnBRNcg9QUORMFIgDQ0qRj1r/iy6Bpeb7oDezmpNji4A+p8fN8F/9PLAemvuq3Tkmjg9L6yYlXARR5irYOXXRE57qqgoX6/JLMXmLYbjdC22bHEoyKOV6QLtQa7u+ZMD+R/l66Se0P5hKdszzACgxPZ5FTuFu/ICSBkf+1fn7LM3Bujbpglkta4foZ+LIl5GlH+8xe4ctsExtHzrWdHc7QczTAe9lGybvjAs0AmTKhLC1jETgVOh8JQ+r+ja7xQT+Bbek+yLMrA/PpHJ8EznMX1nmP1+NcrKEovpITG686l1au9FGQA3zN28LXAgTtS8OLnPokvtfmc+VwEzGEhodfol12k/4KBRCtrpTffC7Qv7xpGtXYQG2jsB+jPItbEFmc
 TbrZvksQ
 pZLmfc/WegWu+9JnfmEvgt9JIG4JR/6DVYGfI1CY6QR+IZowz2ezPRoyIdRf0es9zcCyDQWI+kLKUHApqox4VHGFUTeodBjTzvp6FTk/O8U4s8k5qSTTe1H2RZoZBiLGc1Zeo/P18h+8FIHzuFBSGT6jVVWsACQmDz/3dASgMyN+ZLvnIYe2/fn4D1m7vWaJXdPYp6RRl0mUuFHLnvp92dUVq8uP+YsuCeDoI7P5aS+Tj7bWGH0JKTCCHY5Z8IKMDhf1KSrRFFDQi0jFQSfq5JilMrKSqdSF7xZwR9F6ey9OyLVOmjXFpA1/wFtWLOXEGLHMdzSitT8assMUUvGkAfBsIfr770BmwkZ0aVsRvWishBHkh1XowX/17tiRdCyYb7uPslpkGiLowlDkibCOrgV3EGclBHQ+INHwGrS16iVSL9MYZq2Vblgh7uVGlTN9hJbcqNpirNfxb3mwvf+9U2k7dWX9d3pPCQoSn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 03:41:59PM +0530, Bala-Vignesh-Reddy wrote:
> Several selftests subdirectories duplicated the define __maybe_unused,
> leading to redundant code. Moved to kselftest.h header and removed
> other definition.
> 
> This addresses the duplication noted in the proc-pid-vm warning fix
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Link:https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/
> 
> Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

Looks good for Landlock:

Acked-by: Mickaël Salaün <mic@digikod.net>

> ---
>  tools/testing/selftests/kselftest.h                    | 4 ++++
>  tools/testing/selftests/landlock/audit.h               | 6 ++----
>  tools/testing/selftests/landlock/common.h              | 4 ----
>  tools/testing/selftests/mm/pkey-helpers.h              | 3 ---
>  tools/testing/selftests/net/psock_lib.h                | 4 ----
>  tools/testing/selftests/perf_events/watermark_signal.c | 2 --
>  tools/testing/selftests/proc/proc-pid-vm.c             | 4 ----
>  tools/testing/selftests/ublk/utils.h                   | 2 --
>  8 files changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> index c3b6d2604b1e..661d31c4b558 100644
> --- a/tools/testing/selftests/kselftest.h
> +++ b/tools/testing/selftests/kselftest.h
> @@ -92,6 +92,10 @@
>  #endif
>  #define __printf(a, b)   __attribute__((format(printf, a, b)))
>  
> +#ifndef __maybe_unused
> +#define __maybe_unused __attribute__((__unused__))
> +#endif
> +
>  /* counters */
>  struct ksft_count {
>  	unsigned int ksft_pass;
> diff --git a/tools/testing/selftests/landlock/audit.h b/tools/testing/selftests/landlock/audit.h
> index b16986aa6442..02fd1393947a 100644
> --- a/tools/testing/selftests/landlock/audit.h
> +++ b/tools/testing/selftests/landlock/audit.h
> @@ -20,14 +20,12 @@
>  #include <sys/time.h>
>  #include <unistd.h>
>  
> +#include "../kselftest.h"
> +
>  #ifndef ARRAY_SIZE
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
>  #endif
>  
> -#ifndef __maybe_unused
> -#define __maybe_unused __attribute__((__unused__))
> -#endif
> -
>  #define REGEX_LANDLOCK_PREFIX "^audit([0-9.:]\\+): domain=\\([0-9a-f]\\+\\)"
>  
>  struct audit_filter {
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
> index 88a3c78f5d98..9acecae36f51 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -22,10 +22,6 @@
>  
>  #define TMP_DIR "tmp"
>  
> -#ifndef __maybe_unused
> -#define __maybe_unused __attribute__((__unused__))
> -#endif
> -

We could explicitly include kselftest.h in this file, but it's already
included by kselftest_harness.h, so that's OK.

>  /* TEST_F_FORK() should not be used for new tests. */
>  #define TEST_F_FORK(fixture_name, test_name) TEST_F(fixture_name, test_name)
>  
> diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> index ea404f80e6cb..fa15f006fa68 100644
> --- a/tools/testing/selftests/mm/pkey-helpers.h
> +++ b/tools/testing/selftests/mm/pkey-helpers.h
> @@ -84,9 +84,6 @@ extern void abort_hooks(void);
>  #ifndef noinline
>  # define noinline __attribute__((noinline))
>  #endif
> -#ifndef __maybe_unused
> -# define __maybe_unused __attribute__((__unused__))
> -#endif
>  
>  int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
>  int sys_pkey_free(unsigned long pkey);
> diff --git a/tools/testing/selftests/net/psock_lib.h b/tools/testing/selftests/net/psock_lib.h
> index 6e4fef560873..067265b0a554 100644
> --- a/tools/testing/selftests/net/psock_lib.h
> +++ b/tools/testing/selftests/net/psock_lib.h
> @@ -22,10 +22,6 @@
>  
>  #define PORT_BASE			8000
>  
> -#ifndef __maybe_unused
> -# define __maybe_unused		__attribute__ ((__unused__))
> -#endif
> -
>  static __maybe_unused void pair_udp_setfilter(int fd)
>  {
>  	/* the filter below checks for all of the following conditions that
> diff --git a/tools/testing/selftests/perf_events/watermark_signal.c b/tools/testing/selftests/perf_events/watermark_signal.c
> index e03fe1b9bba2..b3a72f0ac522 100644
> --- a/tools/testing/selftests/perf_events/watermark_signal.c
> +++ b/tools/testing/selftests/perf_events/watermark_signal.c
> @@ -17,8 +17,6 @@
>  
>  #include "../kselftest_harness.h"
>  
> -#define __maybe_unused __attribute__((__unused__))
> -
>  static int sigio_count;
>  
>  static void handle_sigio(int signum __maybe_unused,
> diff --git a/tools/testing/selftests/proc/proc-pid-vm.c b/tools/testing/selftests/proc/proc-pid-vm.c
> index 978cbcb3eb11..2a72d37ad008 100644
> --- a/tools/testing/selftests/proc/proc-pid-vm.c
> +++ b/tools/testing/selftests/proc/proc-pid-vm.c
> @@ -47,10 +47,6 @@
>  #include <sys/resource.h>
>  #include <linux/fs.h>
>  
> -#ifndef __maybe_unused
> -#define __maybe_unused __attribute__((__unused__))
> -#endif
> -
>  #include "../kselftest.h"
>  
>  static inline long sys_execveat(int dirfd, const char *pathname, char **argv, char **envp, int flags)
> diff --git a/tools/testing/selftests/ublk/utils.h b/tools/testing/selftests/ublk/utils.h
> index 36545d1567f1..a852e0b7153e 100644
> --- a/tools/testing/selftests/ublk/utils.h
> +++ b/tools/testing/selftests/ublk/utils.h
> @@ -2,8 +2,6 @@
>  #ifndef KUBLK_UTILS_H
>  #define KUBLK_UTILS_H
>  
> -#define __maybe_unused __attribute__((unused))
> -
>  #ifndef min
>  #define min(a, b) ((a) < (b) ? (a) : (b))
>  #endif
> -- 
> 2.43.0
> 
> 

