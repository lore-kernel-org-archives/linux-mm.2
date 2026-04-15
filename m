Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84145FA0C39
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D676B0092; Wed, 15 Apr 2026 02:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EAE6B0093; Wed, 15 Apr 2026 02:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC7D6B0098; Wed, 15 Apr 2026 02:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CCA46B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:40:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15D7A1A0326
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:40:47 +0000 (UTC)
X-FDA: 84659842134.20.9EFE924
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 641264000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:40:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DlKjOfJ1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776235245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCGpcULGWTg4Z3psql/95dhCaH0Y1WLGlYqrcO9PqDU=;
	b=L8pW8lK81JyiSBoypPWzyx3MhaZpe0zdF2ql013KdtzFCNX1CFKZbhf5hqtCZcCjyBLDGI
	RWnzZATrkpF0/XuVKugZNnSF/n2PS7SCgxxg+GT/VlX6yau5tl5vsAkTATUtqdy7ZVrQM5
	NyX+GZPj7WaEJaitgSHp9OK1nomOcQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776235245; a=rsa-sha256;
	cv=none;
	b=TPeNorL+YpbwWWUWR9ndDEwxoM/1p2zdyHYbvP0U8Nns7WOm0hxS/YNDqwz2bj9yU/nWyg
	dyZgx4Rgm6tPO9Ib9uzUy8wEG9UZjeS7Mm0j9qNTPGH/f9hK9s3lgZ1dNu+3b6YzqZtAMT
	WwZev7c1w98NGVXlRqUYS+H9kykYSIU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DlKjOfJ1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A30B560130;
	Wed, 15 Apr 2026 06:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE83C19424;
	Wed, 15 Apr 2026 06:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776235244;
	bh=JuAmOkFB1T4BBikf9XJrOpaIxFaqy9eIR0tbD7W+hcw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DlKjOfJ14Zp8pzmzxv2haxtgzYDjsnPs9R8hg2+ycACzTHbr7acuR5kjJvTsifuiB
	 hmrefCsvmiJ8S/ASyRhbrEu0eVEjKJ3qiGiGhV8DLnoIKoNSgDAJBNt6yXX+x/8aFy
	 cbTK+0ijPOgP2gpFlzJ0R/vA3lR/joE90UCrW7sEAhyUfhJKoV4AaCRHEIu2Vh3Hp5
	 aR84FJEpkPgT8eAw/WK6T1w2mBmwVEl1Ig0fRwMwg4Aw9VRf7WIrCoVnB+PZUTjNWh
	 1hjyxTxme+UDITGfxUZ0n5MCjKKM/eoWvChVelii168UjL1u2yP9UhA0p+paS1ha63
	 sy53C3I7gK3Lg==
Message-ID: <fd21186c-a67b-4485-ae0b-1dd62dd484ab@kernel.org>
Date: Wed, 15 Apr 2026 08:40:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 05/38] treewide: Remove CLOCK_TICK_RATE
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
References: <20260410120044.031381086@kernel.org>
 <20260410120317.910770161@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260410120317.910770161@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 641264000B
X-Stat-Signature: jp5u54anqfcoy5r4uc75stphiojxwbw1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776235245-314815
X-HE-Meta: U2FsdGVkX18JMQGl7dhIDCXSWx9zDILBmCPXxWLHNnceh2r9Jm9232Np/70pJ2tFQGE4iYH+p5m0kVRNGxGJP/QvVILo8n2LPLalmFdyCi8m8dkhvBW9J7GS24YttUTwD3NsF6Tnf8Z3e3WEcyDigjT3wfht1e8nmPkxZiJGRHD2Sg4ut4eD+lqEhcCFvmqeEc1ma/KQZtKtR5sqscqjIKG3kQBbzPfI6IITyXjb/mQMMrGHv6OnD6JNU7D9ojaxtSm8Wy9D5CoLP8p9E74p3Mn1ZTFFsrl4zsZSAbdRjzb/is8EN6iKQmGUQR/cVb5wzX+dYcKhQTc7qn5lb/4C/TQ9U1gJR/STVwQtZqKuGmZJRW+JDKATYMbRFD/qNh/G+ww+ETPSmW33kRsFUAK8eO7/v0tsxp2BdCNyd0/Jwbgytcg2keq1k9T0M4CUVEYnEHUm2rweM/Ig+Pt4lLi42KYmF7G/CwBQYuC+Xvpugi4zBb1SiT7UfJmQYUn9G0WUnfDacMPtW8wAzZggAkLvFVY4H34PTAuRtK7bGf/Mbm2MtZY0pH3ET/j55PAjEgZGwlG21zfU27F87M2jqMQjoUvMuPAOu/PvxHlKxJb2wyHyj9yevLBDbT074ZiL/XCw1K70Zk4qbkRsTOWglt3bBXE7JcXQnbqeWhgke9bq8HwZad/IRk4eIk6lHuvqenjvFSW0zkMe43X+Y4s5+GKzWcXikQ1HAjNgxArhLpE4Z5a1X8/zF2KEReedL96hihUOFfECP6+kF0ZQdC4ptqx6KBmjrio8lUBh9jOljdcwkMEUSiFgyQj+DQhXwyrsc74e5awaiz3x80CRMYHqymizcc64PXhHl/2YyiLa452VD0EqX2Llk68uBkbNDzta6OWcTbxm7tJeH9bw5/wwRUPfURt3llHO7KTxNTrCvQYLwcDVhVJgeX2wsnq0MFxcLdTueCL9Qd9tnjTtS/KtwoL
 u6Ce9Xpo
 pUUWkSJvlLrY5R++DW3hLGtN8ozbGYjUXqyrA+CXe6ZAlv2PQhMBShl1F1boWPMdwOZuX2xdBjbfwoTjbOIN1NTb15ShaofccqlNe06s3AnTt47Bbt9vkDQ1C39SKsdh6M14nz/JQvXMTtXy154AGwuwZe+p4LyT4MdUgOe5tZmsZybtH4uifnGpph94Qp40b5ncmvHzEW7l1JvfXN9wO31KpTJlbKpFSZ0kCWXBqZMatU1gHK7vL1dDdodz8YWRsYdcAvN1IUj2+zCuDNe/Ks+h4EAQDTipx8S8yY7s2QCjHv0YZL1kwVV4ojGR8+BYw3WlKbQs64y3KG/ZChtjGMFhIw1PF4Z6IllxHBLx4pP+MnyC/Cuze1zUyLmFA7XWnCfD7ObWwsS9YqlCY1RR7L3ZaeEsoW6yAW1qII2tcwZHW2sdglWUXnxr+yN72T9Ee+1xm+jXBEQ0y2ZKVrPnAtPuVDkkrSo09/IAV4Y2aHogEGQao81necMPFILX8Xf+LR0pUVN6+U0O6KcqdXxWKoP0b6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 10/04/2026 à 14:18, Thomas Gleixner a écrit :
> This has been scheduled for removal more than a decade ago and the comments
> related to it have been dutifully ignored. The last dependencies are gone.
> 
> Remove it along with various now empty asm/timex.h files.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

For powerpc:

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/alpha/include/asm/timex.h      |    4 ----
>   arch/arc/include/asm/timex.h        |   15 ---------------
>   arch/arm/mach-omap1/Kconfig         |    2 +-
>   arch/hexagon/include/asm/timex.h    |    3 ---
>   arch/m68k/include/asm/timex.h       |   15 ---------------
>   arch/microblaze/include/asm/timex.h |   13 -------------
>   arch/mips/include/asm/timex.h       |    8 --------
>   arch/openrisc/include/asm/timex.h   |    3 ---
>   arch/parisc/include/asm/timex.h     |    2 --
>   arch/powerpc/include/asm/timex.h    |    2 --
>   arch/s390/include/asm/timex.h       |    2 --
>   arch/sh/include/asm/timex.h         |   24 ------------------------
>   arch/sparc/include/asm/timex.h      |    2 +-
>   arch/sparc/include/asm/timex_32.h   |   14 --------------
>   arch/sparc/include/asm/timex_64.h   |    2 --
>   arch/um/include/asm/timex.h         |    9 ---------
>   arch/x86/include/asm/timex.h        |    3 ---
>   17 files changed, 2 insertions(+), 121 deletions(-)
> 
> --- a/arch/alpha/include/asm/timex.h
> +++ b/arch/alpha/include/asm/timex.h
> @@ -7,10 +7,6 @@
>   #ifndef _ASMALPHA_TIMEX_H
>   #define _ASMALPHA_TIMEX_H
>   
> -/* With only one or two oddballs, we use the RTC as the ticker, selecting
> -   the 32.768kHz reference clock, which nicely divides down to our HZ.  */
> -#define CLOCK_TICK_RATE	32768
> -
>   /*
>    * Standard way to access the cycle counter.
>    * Currently only used on SMP for scheduling.
> --- a/arch/arc/include/asm/timex.h
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.synopsys.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7Cac13d5b928bc4eabd9b708de96fb5935%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639114203455047148%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=uCL895qVLUoy3Stzhmgph2DiYmjpd4RPdQIW2dZcJ7w%3D&reserved=0)
> - */
> -
> -#ifndef _ASM_ARC_TIMEX_H
> -#define _ASM_ARC_TIMEX_H
> -
> -#define CLOCK_TICK_RATE	80000000 /* slated to be removed */
> -
> -#include <asm-generic/timex.h>
> -
> -/* XXX: get_cycles() to be implemented with RTSC insn */
> -
> -#endif /* _ASM_ARC_TIMEX_H */
> --- a/arch/arm/mach-omap1/Kconfig
> +++ b/arch/arm/mach-omap1/Kconfig
> @@ -74,7 +74,7 @@ config OMAP_32K_TIMER
>   	  currently only available for OMAP16XX, 24XX, 34XX, OMAP4/5 and DRA7XX.
>   
>   	  On OMAP2PLUS this value is only used for CONFIG_HZ and
> -	  CLOCK_TICK_RATE compile time calculation.
> +	  timer frequency compile time calculation.
>   	  The actual timer selection is done in the board file
>   	  through the (DT_)MACHINE_START structure.
>   
> --- a/arch/hexagon/include/asm/timex.h
> +++ b/arch/hexagon/include/asm/timex.h
> @@ -9,9 +9,6 @@
>   #include <asm-generic/timex.h>
>   #include <asm/hexagon_vm.h>
>   
> -/* Using TCX0 as our clock.  CLOCK_TICK_RATE scheduled to be removed. */
> -#define CLOCK_TICK_RATE              19200
> -
>   #define ARCH_HAS_READ_CURRENT_TIMER
>   
>   static inline int read_current_timer(unsigned long *timer_val)
> --- a/arch/m68k/include/asm/timex.h
> +++ b/arch/m68k/include/asm/timex.h
> @@ -7,21 +7,6 @@
>   #ifndef _ASMm68K_TIMEX_H
>   #define _ASMm68K_TIMEX_H
>   
> -#ifdef CONFIG_COLDFIRE
> -/*
> - * CLOCK_TICK_RATE should give the underlying frequency of the tick timer
> - * to make ntp work best.  For Coldfires, that's the main clock.
> - */
> -#include <asm/coldfire.h>
> -#define CLOCK_TICK_RATE	MCF_CLK
> -#else
> -/*
> - * This default CLOCK_TICK_RATE is probably wrong for many 68k boards
> - * Users of those boards will need to check and modify accordingly
> - */
> -#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
> -#endif
> -
>   typedef unsigned long cycles_t;
>   
>   static inline cycles_t get_cycles(void)
> --- a/arch/microblaze/include/asm/timex.h
> +++ /dev/null
> @@ -1,13 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - * Copyright (C) 2006 Atmark Techno, Inc.
> - */
> -
> -#ifndef _ASM_MICROBLAZE_TIMEX_H
> -#define _ASM_MICROBLAZE_TIMEX_H
> -
> -#include <asm-generic/timex.h>
> -
> -#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
> -
> -#endif /* _ASM_TIMEX_H */
> --- a/arch/mips/include/asm/timex.h
> +++ b/arch/mips/include/asm/timex.h
> @@ -19,14 +19,6 @@
>   #include <asm/cpu-type.h>
>   
>   /*
> - * This is the clock rate of the i8253 PIT.  A MIPS system may not have
> - * a PIT by the symbol is used all over the kernel including some APIs.
> - * So keeping it defined to the number for the PIT is the only sane thing
> - * for now.
> - */
> -#define CLOCK_TICK_RATE 1193182
> -
> -/*
>    * Standard way to access the cycle counter.
>    * Currently only used on SMP for scheduling.
>    *
> --- a/arch/openrisc/include/asm/timex.h
> +++ b/arch/openrisc/include/asm/timex.h
> @@ -25,9 +25,6 @@ static inline cycles_t get_cycles(void)
>   }
>   #define get_cycles get_cycles
>   
> -/* This isn't really used any more */
> -#define CLOCK_TICK_RATE 1000
> -
>   #define ARCH_HAS_READ_CURRENT_TIMER
>   
>   #endif
> --- a/arch/parisc/include/asm/timex.h
> +++ b/arch/parisc/include/asm/timex.h
> @@ -9,8 +9,6 @@
>   
>   #include <asm/special_insns.h>
>   
> -#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
> -
>   typedef unsigned long cycles_t;
>   
>   static inline cycles_t get_cycles(void)
> --- a/arch/powerpc/include/asm/timex.h
> +++ b/arch/powerpc/include/asm/timex.h
> @@ -11,8 +11,6 @@
>   #include <asm/cputable.h>
>   #include <asm/vdso/timebase.h>
>   
> -#define CLOCK_TICK_RATE	1024000 /* Underlying HZ */
> -
>   typedef unsigned long cycles_t;
>   
>   static inline cycles_t get_cycles(void)
> --- a/arch/s390/include/asm/timex.h
> +++ b/arch/s390/include/asm/timex.h
> @@ -177,8 +177,6 @@ static inline void local_tick_enable(uns
>   	set_clock_comparator(get_lowcore()->clock_comparator);
>   }
>   
> -#define CLOCK_TICK_RATE		1193180 /* Underlying HZ */
> -
>   typedef unsigned long cycles_t;
>   
>   static __always_inline unsigned long get_tod_clock(void)
> --- a/arch/sh/include/asm/timex.h
> +++ /dev/null
> @@ -1,24 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - * linux/include/asm-sh/timex.h
> - *
> - * sh architecture timex specifications
> - */
> -#ifndef __ASM_SH_TIMEX_H
> -#define __ASM_SH_TIMEX_H
> -
> -/*
> - * Only parts using the legacy CPG code for their clock framework
> - * implementation need to define their own Pclk value. If provided, this
> - * can be used for accurately setting CLOCK_TICK_RATE, otherwise we
> - * simply fall back on the i8253 PIT value.
> - */
> -#ifdef CONFIG_SH_PCLK_FREQ
> -#define CLOCK_TICK_RATE		(CONFIG_SH_PCLK_FREQ / 4) /* Underlying HZ */
> -#else
> -#define CLOCK_TICK_RATE		1193180
> -#endif
> -
> -#include <asm-generic/timex.h>
> -
> -#endif /* __ASM_SH_TIMEX_H */
> --- a/arch/sparc/include/asm/timex.h
> +++ b/arch/sparc/include/asm/timex.h
> @@ -4,6 +4,6 @@
>   #if defined(__sparc__) && defined(__arch64__)
>   #include <asm/timex_64.h>
>   #else
> -#include <asm/timex_32.h>
> +#include <asm-generic/timex.h>
>   #endif
>   #endif
> --- a/arch/sparc/include/asm/timex_32.h
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - * linux/include/asm/timex.h
> - *
> - * sparc architecture timex specifications
> - */
> -#ifndef _ASMsparc_TIMEX_H
> -#define _ASMsparc_TIMEX_H
> -
> -#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
> -
> -#include <asm-generic/timex.h>
> -
> -#endif
> --- a/arch/sparc/include/asm/timex_64.h
> +++ b/arch/sparc/include/asm/timex_64.h
> @@ -9,8 +9,6 @@
>   
>   #include <asm/timer.h>
>   
> -#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
> -
>   /* Getting on the cycle counter on sparc64. */
>   typedef unsigned long cycles_t;
>   #define get_cycles()	tick_ops->get_tick()
> --- a/arch/um/include/asm/timex.h
> +++ /dev/null
> @@ -1,9 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef __UM_TIMEX_H
> -#define __UM_TIMEX_H
> -
> -#define CLOCK_TICK_RATE (HZ)
> -
> -#include <asm-generic/timex.h>
> -
> -#endif
> --- a/arch/x86/include/asm/timex.h
> +++ b/arch/x86/include/asm/timex.h
> @@ -14,9 +14,6 @@ static inline unsigned long random_get_e
>   }
>   #define random_get_entropy random_get_entropy
>   
> -/* Assume we use the PIT time source for the clock tick */
> -#define CLOCK_TICK_RATE		PIT_TICK_RATE
> -
>   #define ARCH_HAS_READ_CURRENT_TIMER
>   
>   #endif /* _ASM_X86_TIMEX_H */
> 
> 


