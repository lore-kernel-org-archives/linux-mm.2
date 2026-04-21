Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D4FF8925F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 11:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA186B0088; Tue, 21 Apr 2026 07:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981C96B0089; Tue, 21 Apr 2026 07:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897736B008A; Tue, 21 Apr 2026 07:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2226B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:22:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14761140D8D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:22:57 +0000 (UTC)
X-FDA: 84682325994.02.47789AB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2D7AB4000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:22:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jr6Qy8xY;
	spf=pass (imf11.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776770575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbepvZoiaQHnY8ojgGndHUN0tqRJnJo2KRx8HLgDgUI=;
	b=zBEOSWAN4p5SlfoVF6A9Ff+hw8eg3e2wt7GrdTSvQQWlzwZo6b55B7L9UHW8qybV7P5K6Q
	+COmpvl6jzoclagr0nyYALBSs0fcDNyKlwUdasOaeMIOmql+3wFobuWyuVIacd8TglhmYx
	nnuG4kWBpKr2EU4y+Wj6SQsq2HWie70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776770575; a=rsa-sha256;
	cv=none;
	b=Ca6aB0jmFd9CkcPmtuZDhc2R4be6mYtWs6Q2JUeQr6I5OoDRz4X0JP/N4EVrrLjuny5nB+
	wk3pxXe8eK0u099CSXnNThVXSFNum7DwCZd7nvIkZoYuUNKK4OBpMW2DxhW4ifAuEqAlo1
	MYQETYACackKTbtbfGbSOidjauZvey8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jr6Qy8xY;
	spf=pass (imf11.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82f8893bff3so1911046b3a.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776770574; x=1777375374; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pbepvZoiaQHnY8ojgGndHUN0tqRJnJo2KRx8HLgDgUI=;
        b=jr6Qy8xY4bbIkOaWepOrt6t//Ii24ff2BJjPLlhWG488DMxiQBStef2aYQlC4CsV8q
         mHryemkb+QAnu52mE++J2qT1+y7acvaSWZXf3kRQxwxQ7tgHHaNsTugDQiMGNMRgz168
         201dfdTvcgqRuYWL88vv+GtDQHhG2CtNXkVU3mG1w9mXvXIeIR6juW1MazJN9lomAMYh
         6fm9wN4hdXyDZJJU2tmo8T9GgQ7ZuLVcH/O8WS+z34YiYOlnoNGUDsdD+B/1hNfB86yZ
         zR/2i/yMdBUVsRvesPBJBrrCfgoSihJ7fRu2MfAPic2ndDfofxXcaq2X5tpudjsXMNzb
         bzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776770574; x=1777375374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbepvZoiaQHnY8ojgGndHUN0tqRJnJo2KRx8HLgDgUI=;
        b=lstWFLcpZfK8bu1dox4G6DDsv/C/iwg7G9/2uhEwqD2/xjXsnwKMWzbBDWqVrL1Uxl
         o9dE+Ig9Fj8Oolj1M2zhos1ijMTfJ+QAijBUvOLVFlYua4ppPungqUKx1pe7NiK3bTOJ
         SeFooSu1ZPH23tR3dpJ+fJ3jJDgGSy2JwkbSFdtMjH1yUpjwxc4JYakms0sBSzMchH5U
         pQeMts6yzWQkQ7vK9TSxFCM11C/9Gvu1Fx3/LO8c8NuSPGPnpxFXB8RF6+9qVSdT+oQT
         kmprWCwIixCVn6GdZkRq4m/eDMmtPR/zbFI1RcnaX8DgURT8Zfj0Xc6kj1DPnfYqTFSR
         NUFw==
X-Forwarded-Encrypted: i=1; AFNElJ9/TxvK4L/4XqFRfuCw01HoLCSLReLqgmaZgKgJaHjD5peBZYvo7l7lfK+uuPzFzJ1RinxMzr81pA==@kvack.org
X-Gm-Message-State: AOJu0Yy5A3ab5M3FvLGFx5FV3rt1ZYtTeTOhlGZpXjrMrSkBZ8t7nGqI
	PhWTwonM4Uq7/7qbKyVd6AAcu4vwnGiy91XmDDeyZLr++y+67aKh0U3b
X-Gm-Gg: AeBDiesoi7D2sBZUmYefz+lMEurTs0E5JlEHZ/sevKJ/vuwzsSjVLQp+dJCWL1CVakm
	drGgdr3hSuBR9GTDvZP1ZVTqvUgOWSCF0iHc1KoVWt2fXDI0UFg05oIHkqKxcnESnGzmi7+UXbR
	NTQSDRYL13pN+EsUTiTtQINYXNKfbuQJDMX92Ll9Xb/Enknx2IhboN30o/c97wS8VXlWFqyl2kx
	CCy6TbNrZatyk8mvwkjgUPMnix+ou5gMPOJ3q+UfXoaXMAo5g5rgiScWhZS+P1oEVmd1QErqD9n
	1XBJNbPtu1+jWLdSWHc0XcBYLidpb6mVxbSvjQC/mzn8Hvg7OVuWyBL9nugpzLYLXd6MgvVW8eG
	qRLbpNwNzJ/sRHX/yswxgLEE07bo03AtQAc7LZiY/QYIuSxO0FK4tfKqvfUnDs2GAIXbAUzwHro
	8bp4TSfEj+QziNAaHM4BMiBREWRQkbqy8pStLhJJ0rTJum/b1Lhy18Lm/JuAGQ/tS9cHYNFZPuk
	m+3Ng==
X-Received: by 2002:a05:6a00:6988:b0:82f:aae5:c7a9 with SMTP id d2e1a72fcca58-82faae5d438mr7228492b3a.27.1776770573719;
        Tue, 21 Apr 2026 04:22:53 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e981a0asm14155014b3a.3.2026.04.21.04.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 04:22:53 -0700 (PDT)
Date: Tue, 21 Apr 2026 16:52:37 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>, 
	x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, 
	Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, Paul Walmsley <pjw@kernel.org>, 
	linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 33/38] powerpc: Select ARCH_HAS_RANDOM_ENTROPY
Message-ID: <aedc9UddBSYXzrAj@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260410120044.031381086@kernel.org>
 <20260410120319.789114053@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410120319.789114053@kernel.org>
X-Stat-Signature: 1iesmdhh4agc7ipugga6qtcc6s98jxnw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D7AB4000E
X-Rspam-User: 
X-HE-Tag: 1776770574-222168
X-HE-Meta: U2FsdGVkX1+cAi4km8QsG+p3UNB16XT+1riSrH5rFHsJ2PqqoO+9JQDGnMDxlL/bQy9pYFED0iM1uIJyhTpeYNTPqUOyHXSqmGgCg6DR4EEcA/tuxa5go0JrIwFkNCkLicV1UBNJaqAYiNHvlKKjRtz4fM5hEQkBuQEiV+/Y1oKOlk9zva1wzQuFR/oDI06dfs8YWl1fqS8wX5EVw9UOz02kO8z4i1NbaEoLjcZaFBz6puZEDBwTSJnfAs1kAV59kOFB58bPD9BbiNDoTK5yCdU1VfLF0DbgDjxMmriIOMeBDWZ2/fw8JcoEn71Bm3a6i0qRwYNR+Gax/FNvSv3KrXQ5S2APim9+97iA6ekvrVtfmnFlSPm/ympB+ArkHNyuoIDMXtmZIbiNj1Lgx6bA/210g3s/Hwo8SrpeeXat+pHGO14a1bcn+OdWfX5qwsg5YkhaNjYrZCR1s0XbWlF5dHOSDiFaeGnY52VV+r71f4nK3a87QdOGQXcNSuq9kWANJwWqRiisYaWf8yXh+pazpQYG8b3Xk5Tcfs/ttVoZ1O9GlY4MAu8yHDH4aCoHu4obEwvak8sFjCwOcTUBu3Dx504gmgc2gWkyx1gJC8f+HdaxJz98BddBz7Ln5esJ/DbFUABB5vqZ5fYW3z0JrKRrTsoHMXDukxVDocmgC4mHRix381sYtlYhapNfYLToKHnlvEHNW89E2oxug1XBMoMwQw3rNWnU93rLR2DstKzHI3iSmGBXtmRT+GcC6OmYRh4up2i3aufg7LVXoGAujKJYHSUNnWxv1aBfab6LzNi8fqQpshM9GjJu4DrYsPPoteobUrntpYxve4pCqw6PZkX2xmfc8gjiPsV/LJYYJW65kWmWBiMocAlPe9Kh4Ux1wAl+KSoa7nq+fHS139ccfanHuj14l7lsVWFjk7hCHeep9YBwEbldgvFw+xBqumDtaQ3p0pyGU+q1OGSOV0UQcZG
 ZEPs3g7A
 sl1gCerGXa7UQq6aDwqu+v9WvCaN8M8JozE89ObYIm+tQeC7GSW9qLJleoyt5H1FHO9B7VKToe7bFvlM+Au6eWgVSZ4Hd8oEYlG5QDy8y32gzX+asyQ3JgOYCt+ZVhLrNGMxJZqEAYSnGHeasFEYQsKRvgMgVqlGnEPIyqUiF6eAlrNcnx6n6ebBpP/jED3RZE1Wle15gfbv9umfaHYLSlNe+FMfHokbCX2kygr5FmBFnZ7jTJGgchcSVU5IA3dl8c+hvvYdmvjXSg9lsZMNx0pNHe/pkRBtJRGAU9MZIIUOB1VUs5z0ZCckx81coaqmWMUEy+8MZYAMNhmk2vqRubAhtCfrNkEQY+BJkpSfKkVDNJNrZdwh8cZVFercbQqoTxwBH3g1rwXwitiXuRKQ6NGBbmix/HfKLPmxICzTIuZtf56ILmqxyL2eYeMYxx2qqzg383f0UJNLggVDB8hUALGBiNpgXTRqdaPnyox9bFgE0sdGkGTkd6Wte6lvBhb1edFO0GDg23WYeI4iAXqIUc81V8tkhOPqdPw4aksIs2EpUdZQt4QjHR1rgTsUt7KImXBJI0H8gL/XM0qXyWgn2mgmn6WR2i8g0LQ5HcLNAMx8yKdmtJB3A0mQeHoSPv56k9ufol7GB2Wc0hH3FYfGpwnrySUk+N23bVe8c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 02:21:09PM +0200, Thomas Gleixner wrote:
> The only remaining usage of get_cycles() is to provide random_get_entropy().
> 
> Switch powerpc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
> and providing random_get_entropy() in asm/random.h.
> 
> Remove asm/timex.h as it has no functionality anymore.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/Kconfig              |    1 +
>  arch/powerpc/include/asm/random.h |   13 +++++++++++++
>  arch/powerpc/include/asm/timex.h  |   21 ---------------------
>  3 files changed, 14 insertions(+), 21 deletions(-)
> 
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -150,6 +150,7 @@ config PPC
>  	select ARCH_HAS_PREEMPT_LAZY
>  	select ARCH_HAS_PTDUMP
>  	select ARCH_HAS_PTE_SPECIAL
> +	select ARCH_HAS_RANDOM_ENTROPY
>  	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
>  	select ARCH_HAS_SET_MEMORY
>  	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC_BOOK3S || PPC_8xx) && !HIBERNATION
> --- /dev/null
> +++ b/arch/powerpc/include/asm/random.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_RANDOM_H
> +#define _ASM_POWERPC_RANDOM_H
> +
> +#include <asm/cputable.h>
> +#include <asm/vdso/timebase.h>
> +
> +static inline unsigned long random_get_entropy(void)
> +{
> +	return mftb();
> +}
> +
> +#endif	/* _ASM_POWERPC_RANDOM_H */
> --- a/arch/powerpc/include/asm/timex.h
> +++ b/arch/powerpc/include/asm/timex.h
> @@ -1,21 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef _ASM_POWERPC_TIMEX_H
> -#define _ASM_POWERPC_TIMEX_H
> -
> -#ifdef __KERNEL__
> -
> -/*
> - * PowerPC architecture timex specifications
> - */
> -
> -#include <asm/cputable.h>
> -#include <asm/vdso/timebase.h>
> -
> -ostatic inline cycles_t get_cycles(void)
> -{
R> -	return mftb();
> -}
> -#define get_cycles get_cycles
> -
> -#endif	/* __KERNEL__ */
> -#endif	/* _ASM_POWERPC_TIMEX_H */
> 
Build tested for this series with allmodconfig and allyesconfig on ppc64le
machine for ppc64le.
tree: git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git getcycles-v1

Boot tested for this series on powernv9 qemu, powernv10 qemu and pSeries
power11 hardware.

Tested-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>


