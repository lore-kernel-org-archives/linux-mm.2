Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A5CE64001
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 08:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319376B0089; Sun, 12 Apr 2026 04:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9236B008A; Sun, 12 Apr 2026 04:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7D86B0092; Sun, 12 Apr 2026 04:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 090836B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 04:56:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 655F4160B31
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 08:56:39 +0000 (UTC)
X-FDA: 84649298118.15.00653F7
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7BC5A120007
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 08:56:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CGAhWdvu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of shorne@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775984197; a=rsa-sha256;
	cv=none;
	b=hUHbqOmZk+eDy5UvPi4Rapz0LsEy8UfLmEaGnZvTMPmyWoRUdRmoH9JJiiZwk0IurXx+Il
	fBluO+rgjyeMz5LXm/xVGwALqPk8HPrlj0XFzzU3tor+92ldMkRXh6PNC6OuZf8G1V9TUf
	dBgMxPovPoEPIXQFPsRqp1opyIBU3Fg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CGAhWdvu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of shorne@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775984197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbDgrbrkQIZIzHMqS4zyFwb8jbE/7QCDRz8zhtNheE4=;
	b=EDy0TgFIgoypQ6fqE+weDGdeYkmmD635pT191f84zg4YbaZH99nO3WNEHILrgvD4PWLy9w
	7HQAxiUv5CkpZYHfX6v65lgw4RtAIRh09YeatPF8vQVaYlFgBdO6L4W8wUpbyl0EXqZIFJ
	21n0kubl7gioXChTj6shR1OfWcHy35M=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso37509555e9.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775984196; x=1776588996; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EbDgrbrkQIZIzHMqS4zyFwb8jbE/7QCDRz8zhtNheE4=;
        b=CGAhWdvuI4TWvUTUqiyw/aCzEXlOP3F8GRgK7lGYOSPsdFqRleStoJ6D+tNH+vcAdB
         76d6ZySaSBLe3vT87Fj2e5v5M4YzTXfM56HZpqqHRHuFqZ9N7gXnpk/OxssUOi/gB7a5
         1XnDDR4s30xQIJ1kr7/ZF5bOy/6w4MGZKYSdzdggZteJnfNxg6Va9VdrTtj9oMFOceUY
         qZwf2340HSsC8+yS0odwlZSJQ1PN+admuClnFZkwMyaoj58prwzxVcmjMMagjQ4uC0p+
         UxXSen0QLuvKH40u2dx4RLU4apYTsCDf6WbmtvAxHa2eZ/cFccdccmSYKVKS8r0lAy52
         uPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775984196; x=1776588996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EbDgrbrkQIZIzHMqS4zyFwb8jbE/7QCDRz8zhtNheE4=;
        b=e7NdmP80m/lACkkRrENPzmyScCfFUrp1eJaup3m1Ud8WxiK06Y4fnpqB+6QAzGpHLJ
         M3UCSvoBGhWgzlwqH+GGgaVki5VmTCw3zoFeZWmloU33NGd5yHewzU3SnIuEOjI0lZvQ
         QCet0x34j+xt/bHMKZXNTI2027AKSbWnXhZi4GSdP1CWIPky+eyZIS7o04oNCWwt9anR
         KT+OiQ4f6F6WhBJ61+TVAVS2+kn/nniS+6H/DC40PWTS/kWpZovj6P5UxK4/fuzOyZcp
         TntQdzAN1hpR3Q+um+80g18ZfbniKjakUhTpwuUR7/m2texhpjz5vkPI0D5ZGqlT4F4g
         f0pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB+MT1FFKsypu6JAOUF94W4gOvDZelE4cSgCE67dnYTJgRtN7yqcWiNyuwFJJz5g4VTnmke2YIQw==@kvack.org
X-Gm-Message-State: AOJu0YyY24gyIqe9pATh7d4vDvPsrqEO9e9V+S/9rAaQ0oyDMIgDgi9L
	scUE3IePq6cOu/ZpJvfzT0AXibYiKw+jIpkKUeiPsjBs7Uf6Is2HPZhf
X-Gm-Gg: AeBDieuztKJiIlhi6Q6x0LkLhSjZ948g+BqPWHc7u/Wnq2mU35h+F9V7mtO1jeO5px3
	cVycK6OlVzs12btH/hv461q96Iz+M2H/56iba717ecQmwhJV/85FjaqW3JY8K1IazmiYEP5gzIV
	KgqwSXx6LcNw7Itd9OA+mXWQRy7loRrCJyuY8F2p/dNwPMbmU0JdNBTjnuGRpplpBXceTR7bBD9
	gXQldMoOAkMb0mp+Bikd0cW8kUaxI4TyNniPTHkVfx/2/47S7dWnn1cYDHwZHXcoZKHwvNNlRex
	l22UUzSRzihv9fD8c/4/PmiacTaJIc5jSNEfIlGMizvWwCyU5El4XqlXWfIbbp9kcnVRSm1qmWX
	Y+yPzAIQOfi5Edw0jueDLY1tUPLpsFNxDyopw1izl2hWqbQH78FdzQbiWWNsnT9mh8oM4HobBTI
	2w/ffWoLhvnfZ+FiEOnWYc9PAbt8KbzromNdpOMVsyD35uv45Uh6sJ8cZPwwkMAvmcCdf51W3D3
	zzmxA==
X-Received: by 2002:a05:600c:698d:b0:487:22ad:403e with SMTP id 5b1f17b1804b1-488d6ac9ce5mr126951995e9.14.1775984195334;
        Sun, 12 Apr 2026 01:56:35 -0700 (PDT)
Received: from localhost (brnt-04-b2-v4wan-170138-cust2432.vm7.cable.virginm.net. [94.175.9.129])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d532ed4dsm197923925e9.4.2026.04.12.01.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 01:56:34 -0700 (PDT)
Date: Sun, 12 Apr 2026 09:56:33 +0100
From: Stafford Horne <shorne@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jonas Bonn <jonas@southpole.se>,
	linux-openrisc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
	iommu@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
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
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>,
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
	linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	sparclinux@vger.kernel.org
Subject: Re: [patch 30/38] openrisc: Select ARCH_HAS_RANDOM_ENTROPY
Message-ID: <adteQSw8c65MtX5l@antec>
References: <20260410120044.031381086@kernel.org>
 <20260410120319.593798781@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410120319.593798781@kernel.org>
X-Rspamd-Queue-Id: 7BC5A120007
X-Stat-Signature: 69384axr7zgjw4qg53tyhbwf3ua5jg1h
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775984197-613558
X-HE-Meta: U2FsdGVkX18h03r1mCaIu2imfqGLdPDei2zrYzV0VxC2XdXV6oFvtRqf4dP5ACYZhkSyIF4zP5dHevQmLJiXmnbElL6yu37JPpIGnzjtn+0mLhRaA70XAOnwLQgl4Q+RODk5i1KSxTSVPn/clQlDmDeg5fDDenlAGfMEC9hcvmvBVYjDZpu8AgY36psu85jCFBgd01NxshLFZAKD72GLbY8HbQFHGnH4PSpt6TLV8RqbUKW/TqqQT8S4djFKRCTkD44ESjayYB3BgQg88LGyn2HmsmUooLQBF9lUq1zLBk3QfzHlgFGA8HJx9j930GAcwpXj8MwaytesRWcGUrJiDA7hCV0hbc37ExzOcpJjhA5yAPbbcVJCLZ9DzDMMJHPewZ5C9rvVU8s34GVi/VCQAC+4n5zFRQMMpDHvSf4ZgvwO7dxATmBjvzX44D+GQp/67G2VGR3HxqdsBwsUBwZK21wr3OT+9/PcPYzJ8v9jypDLDSI53Rn5xx0wgC4xH+InmUfnOeSNF7tQc+urqJhbFXSbH4Vc02lDnvb7YqtX/mT0cTKNmZfqLKHWlJ9DRlLmXBywo20ZpxDw27APzievmUwngN+Ai26TznZV/CoHTwmgoOWkpY6o0SGrPA3xrxcB/EGv5TEFUb+8u1QMToapvAmGR13BBPNtx5+KsYPP+9oHHJ5E4MIjKKC1PBxqiKOBo6i1g0NOI1a+tRVpD+5YHyPzgy4RrqFbp/AxhFp/fgd9Y9VOVSrl1lZGHW8fP6v3P/FOr/D0LcIRHH6R+gozRu9uoEDgqt2vn0ZlrN7lJ+YeVyUu5ZPrx+NgNUG0uuJ5bWqhZr0nmfhSqETerFNBJjeEgSX1bQWg7EgUyquMWp1vmQGrT7do+VqqN7r+CTFfj00fz3LxR7inoAB4AsOctz7bjGLci2zSPye8txEntof5pwMyl4ssHmA6pJxZSW1DNdWtzNVYzVjWGtpKKOj
 Lv6p0MCY
 SEJH/2mGwqOamsCynTzA0vZKYwzIwT4Eohw8TSSF1M8vxUqGo2fUHBIR4biK2Fy+m/Co69e/UoOeYK+WrEgkwssL37+JcRCgPOgE2o4AUeFBCblqShfTh+8pt0/Yqx79h8WIVVgYixBviXyWa12y4a0floHhcxF6/aV5GogyN/h1ZuWI723nb+gdsUQe5EiU9GvC+niJaKnnwWKF842LIYhc2OhNa0RidFActvKn2rc6T2vaUslYkcZr9Y9777/MO0pKPHB0RMOx+XNqKKwtCAjnlEmkKaX72Vo3d09mGfT11NOI8rIrHCknHMvP1UyZwWZYS5ZYWosNrkI0Wn3BVZiORXWGkyvrG5yeMBc7Vj1jQuPK9ObB+3QMKAsH1k0DyOx8oLZcsFrT0Ttse6aA5s8r0kDjEj8veV+8cVlPGfBA90dUEcz8y5F3XK6DQIAmSSLMGFuaAn24KbQA98rOqW3QVz82b/72vthkehH2yal+KW0Wkpq2mVfObIIENUyf0yPjZSzidGCb2UvqqfujkTDOHSEgRBR39TeNo3zMKoU4r19cNIpCsIX9txXpV8Es2rs9UX/2AbwWfn7rd0czpvm4OQQQPQbPDr+rfYBnmkPXsjeOha/+cSJ1J/EsnHdRM4KukiE+81yOfSgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 02:20:55PM +0200, Thomas Gleixner wrote:
> The only remaining non-architecture usage of get_cycles() is to provide
> random_get_entropy().
> 
> Switch openrisc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
> and providing random_get_entropy() in asm/random.h.
> 
> Add 'asm/timex.h' includes to the relevant files, so the global include can
> be removed once all architectures are converted over.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux-openrisc@vger.kernel.org

This looks good to me.

Acked-by: Stafford Horne <shorne@gmail.com>

> ---
>  arch/openrisc/Kconfig              |    1 +
>  arch/openrisc/include/asm/random.h |   12 ++++++++++++
>  arch/openrisc/include/asm/timex.h  |    5 -----
>  arch/openrisc/lib/delay.c          |    1 +
>  4 files changed, 14 insertions(+), 5 deletions(-)
> 
> --- a/arch/openrisc/Kconfig
> +++ b/arch/openrisc/Kconfig
> @@ -10,6 +10,7 @@ config OPENRISC
>  	select ARCH_HAS_DELAY_TIMER
>  	select ARCH_HAS_DMA_SET_UNCACHED
>  	select ARCH_HAS_DMA_CLEAR_UNCACHED
> +	select ARCH_HAS_RANDOM_ENTROPY
>  	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
>  	select GENERIC_BUILTIN_DTB
>  	select COMMON_CLK
> --- /dev/null
> +++ b/arch/openrisc/include/asm/random.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef __ASM_OPENRISC_RANDOM_H
> +#define __ASM_OPENRISC_RANDOM_H
> +
> +#include <asm/timex.h>
> +
> +static inline unsigned long random_get_entropy(void)
> +{
> +	return get_cycles();
> +}
> +
> +#endif
> --- a/arch/openrisc/include/asm/timex.h
> +++ b/arch/openrisc/include/asm/timex.h
> @@ -9,13 +9,9 @@
>   * OpenRISC implementation:
>   * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
>   */
> -
>  #ifndef __ASM_OPENRISC_TIMEX_H
>  #define __ASM_OPENRISC_TIMEX_H
>  
> -#define get_cycles get_cycles
> -
> -#include <asm-generic/timex.h>
>  #include <asm/spr.h>
>  #include <asm/spr_defs.h>
>  
> @@ -23,6 +19,5 @@ static inline cycles_t get_cycles(void)
>  {
>  	return mfspr(SPR_TTCR);
>  }
> -#define get_cycles get_cycles
>  
>  #endif
> --- a/arch/openrisc/lib/delay.c
> +++ b/arch/openrisc/lib/delay.c
> @@ -18,6 +18,7 @@
>  #include <linux/init.h>
>  
>  #include <asm/param.h>
> +#include <asm/timex.h>
>  #include <asm/processor.h>
>  
>  bool delay_read_timer(unsigned long *timer_value)
> 
> 

