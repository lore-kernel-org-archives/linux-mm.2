Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FC4CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC138E0007; Wed,  3 Sep 2025 20:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CC28E0003; Wed,  3 Sep 2025 20:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54F58E0007; Wed,  3 Sep 2025 20:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7D78E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:38:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D7F813B969
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:38:56 +0000 (UTC)
X-FDA: 83849707872.11.63D6644
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6FFE4160007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:38:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDsE2q1q;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756946334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=M9wjahpjajRVdLTvLPg2jmwGdR+YAWepelf042yY0AY=;
	b=BIdtO09u5rRp5G0fx20aSEJ27wa8ow/PN+wumYJrxyLjZheOyO7KIohtdM+WsIsXse8o9s
	mlJvENhuM+lYrQDBeoPCWmvQvmBAsvlWtJ9TZ3TN5CxNz6HX3JbfTQvlYjGpIQS4Zq4T00
	WNPJPzlMPcIzTTezStxBnDtSNyybbGM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDsE2q1q;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756946334; a=rsa-sha256;
	cv=none;
	b=Bxw5XUyBS4rXN3Qhza71CBYRx5yCkXGAYEnu1FvBQfd38I4MYIHXhZWbNmYc5vpD7iRKWa
	i3x5FS/dQVPMHx/Bj8g3gl84XZmvahgyyuE349OSYdRJZkM30Phi2JcK1UesO3IrHRdj/q
	iXTh75cokeXag4pW1yhOsw//eUo6ReI=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b47173749dbso269333a12.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756946333; x=1757551133; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M9wjahpjajRVdLTvLPg2jmwGdR+YAWepelf042yY0AY=;
        b=MDsE2q1qEhdz408gwchrU/FSHC8EM21DwD9vLXdnILnZK/sm9mQf6x4h4N0tBp+u3N
         A8w3Gd4/umHa4qOxlfSqFAlNDa6/tNNUzhWi3EGa0hfV/J9dsa5XEwqe15bxIgOXPYCb
         aZ+wRuNaT+yH8H+sjnZcJF/VwtkRkqvzA9dn+9VZ1GjxCeAC50RzEVFOXGseeUGgUHIe
         fN4el1+sMHrs7+B00w9gG/Wz6mjLuthdOGyum3yyIA1DClSUppzmuhncn3QaP2t6xkWq
         8ghIdo+O5jdypTbJxsvd6YZzfaUNmzW4Np2GNwMq64fcdPOkZCEBuR7ETrhliQEwoZRx
         Ngfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756946333; x=1757551133;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9wjahpjajRVdLTvLPg2jmwGdR+YAWepelf042yY0AY=;
        b=WCN442BAEu6Nsq09uZ8DoGmIs87HIfQvk4vOAsUeQb51dgQAvmHI4epMYP+eii4xTY
         wsOk52V9L+VXjr5V7hazhHO0sXTDcPKlWhiKowiv4QoabEEUeHJ7+MERZHqrp3R+5r3f
         3FK8AOghNDy94+GnKtYRkny/l+LieBLAFIr9dRMTuA9f0E695iIiD0s1QhweXXPZas9E
         ImIZZvXd49xYkt5mHNkxq7BCHAeq5dK1rXOSDT8zbXX9DJw5+hkGBDC0Nzv17L72wj/P
         iU6NIZfM+H9xafyhpxB5h89AyC5M8eYa0n9eYTSWhWV3R8wGp+4iyki9e8T90UVinucj
         cm8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRXXde+cHEka9fjlps0iphwwJksiob4MUK/V48Bd/5TsYG043Mg43P6UU+06YA6p0ShFJKx9HiKg==@kvack.org
X-Gm-Message-State: AOJu0Yxr/e/ezyEI3AFEGXmAY8caqzVjTSn5oFaHr3CwIWUEExlKV+c+
	gK5AddIfwBYobphebWi1hQCFz2njJX8scM3qUDuw5MGBoeNhG59v6F7h
X-Gm-Gg: ASbGncuU6vJdKoY3ksj5kwMq8n05lL2OETd+OmNGrKgNFEXVY8qoh+jvMZZbV7uKGOL
	u2iPq2PxPanB+tt1LjV75iaLaGZ7L++4hQyyXEQFMNWUt+/UNdFig7USatEho9xkIW0vW0rlxpQ
	4AfFrsuo8R292iq7/A1L+vSRZJ0/DiBIbtddw7+T9tmVJIMDP3NLyP+ctmE0uvwvOBnMilxhxWH
	SWMSYMBh5CaxKbCsD07GqEgZYWLd7XfFrnToYJ+O0I/DTDbcpRNyOANen0Q6eUwov/XaxbRgoBZ
	VxwOdD2PIE3i+NSse4XoGFA88NnImbmPHPA9gDQJxE6zNmuw4o3agXTOojt+q2sQHrhvP2zBE3e
	6JKs41ITfP1xA71daU0/Rd04=
X-Google-Smtp-Source: AGHT+IF8fWb/70JgPLh7N7Xn466vomeY7twFDDtFD6ID6JfG4YJmNgXkQZrYmfFbnlzFyM4OYAuWoQ==
X-Received: by 2002:a17:90b:3811:b0:32b:6145:fa63 with SMTP id 98e67ed59e1d1-32b614601acmr4849866a91.4.1756946333006;
        Wed, 03 Sep 2025 17:38:53 -0700 (PDT)
Received: from dw-tp ([171.76.85.3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4fb98f9f6asm1185841a12.8.2025.09.03.17.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:38:52 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, ryabinin.a.a@gmail.com, christophe.leroy@csgroup.eu, bhe@redhat.com, hca@linux.ibm.com, andreyknvl@gmail.com, akpm@linux-foundation.org, zhangqing@loongson.cn, chenhuacai@loongson.cn, davidgow@google.com, glider@google.com, dvyukov@google.com, alexghiti@rivosinc.com
Cc: alex@ghiti.fr, agordeev@linux.ibm.com, vincenzo.frascino@arm.com, elver@google.com, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org, snovitoll@gmail.com
Subject: Re: [PATCH v6 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
In-Reply-To: <20250810125746.1105476-2-snovitoll@gmail.com>
Date: Thu, 04 Sep 2025 05:54:04 +0530
Message-ID: <87ldmv6p5n.ritesh.list@gmail.com>
References: <20250810125746.1105476-1-snovitoll@gmail.com> <20250810125746.1105476-2-snovitoll@gmail.com>
X-Stat-Signature: idajifscj3bybdrm646up6j8rjqwwih8
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FFE4160007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756946334-341497
X-HE-Meta: U2FsdGVkX1+FI7bCVLVFUaP7AMcABeJjAX+x7L7afnq79iYr5xV7nDeOIvLOWS0qYNmL2TOJMfbu6PS1L/nzG6KBDxFP04U+L7EthXKDpuPAaAQZkpXTtocxyQSF9+nalTYrA0xQrNXL0R9cKkY8LkOwtRNx1JL69kGEZC1xE42JKaZblx4aS3WHTWarHiFh4CPqTXBZPk0cXcC2Ehvf7jHbmA5VHpwkQTcCeckkwwYmxXZmDNZpI8ID+M4im43eYJvR4cIoWe9cAFf6V3AsmkVN4Yrp7SWQfGceA/bu3Z796mQg3M2g5KmcadhE+Wr3H58Ws4xqHazput9z3xYmwNqzH/RctwHRDTzfavLfxZGw0uaD/XQXiwlr80RUSxVaEADhMBm5GHq3Zo4fVdudfUKlysq/wqKceZVZAF0KnMfBP5G3FMTmyXxqFD2s1rIU0CNIlBaB1j3hLclHytCepIRWoD6CQR4A2o4hxRzorwQ28GEWxd8PjhGXicOcvKVyB0VhOYjRaoqkryjlcrGqzEeCfTEWu5LqwwouhL9UwdJRBw0w3uPq/+2wyJZe65BMX4uKvXe6XleKyAyOB1emjV1qQnLp/ieZkmhQxybEsTsRewkmHHm6WSf/91CBHTNPgxKBmdH1FjSSk+o3iWMbanUwCVvPT276Hwq3fLdup+yW3bRkwoqPoYIiX9WlZ+xIUgy3ELqeSDO+aRcuMQCKzziPeFEQ/k7HSbeTlL+onUmS37lzKtp/HWbpg+KjrA+LV+T12Vr7gQ6SC82qCFZhWRPEF+zuBhBTxZb/24gKepJI8EYe1H0YEztl9dV+zPWbLnG8QgVJBnHxDQN7Kkn68v3A8RGrs9KMu63LnnEkHcQNysWiug2UExj5+JPfK/ZbNNO7SDJa7MuTY9Gayp4MOZTA1ViI3slNzarDlg7O20Ts/mtyfsCOkwrEC/4/qdvpkFJx5xnaqLxpB5XjOJ5
 xEyNEKIu
 LuE9e0TF6U8BJF+9B0zqwLSuuc3V+aohL6OOW2dgYCgZhyfT4Jn5dJbdMgnPqUg0GwTkvgnHcUKzWw2sEnQCCJI7KafUk98wPanhkzQ1Q+RNuS2LvZhrr2an/HGCEqEZe67Yp1R20Jh9sNId4zV12Zf8LSxRVKC8cst8TolEOkVmm9RkwrETl0sDd5qyASK6JqB501fiBoZCHzDWqj3Pvltd4aBZEVM4xmzXfd71S99O0G3hvwp1oIgXjfhbfDHIWP6MRnwMy26BdUyNfEb+ryzuriQ7A+Lh7k4OkFACn9+KckNghSiUAj/MnPu/M5KAAg0cP3mtkQib3Mp4DcRFSy6sSb9zYy/Df4wj2ECjDyCPVgxYvi0tTZbvnwz4IcDMe16Y9dgfbXVb654tx4u8a2ElVYXs8HP0woV2vAyo7sK90h63S3iKrYgOjwggMAJ7RoB5wlx1LPK5ReCvEjD2EcWaWHI3FhMRo1mhbH+nGZylEMA/EYpId53poP9xyQdxUnrCgZnnH2HwBn12iM40kxllZD/0oZMY9x12ZlKk55yBNfG2eNRG9wCabdGu4Fjvch28gJoRgKrmA0ngSxhJVliVXNJPD/kZbGXf2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sabyrzhan Tasbolatov <snovitoll@gmail.com> writes:

> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures [1] that need
> to defer KASAN initialization until shadow memory is properly set up,
> and unify the static key infrastructure across all KASAN modes.
>
> [1] PowerPC, UML, LoongArch selects ARCH_DEFER_KASAN.
>
> The core issue is that different architectures haveinconsistent approaches
> to KASAN readiness tracking:
> - PowerPC, LoongArch, and UML arch, each implement own
>   kasan_arch_is_ready()
> - Only HW_TAGS mode had a unified static key (kasan_flag_enabled)
> - Generic and SW_TAGS modes relied on arch-specific solutions or always-on
>     behavior
>
> This patch addresses the fragmentation in KASAN initialization
> across architectures by introducing a unified approach that eliminates
> duplicate static keys and arch-specific kasan_arch_is_ready()
> implementations.
>
> Let's replace kasan_arch_is_ready() with existing kasan_enabled() check,
> which examines the static key being enabled if arch selects
> ARCH_DEFER_KASAN or has HW_TAGS mode support.
> For other arch, kasan_enabled() checks the enablement during compile time.
>
> Now KASAN users can use a single kasan_enabled() check everywhere.
>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
> Changes in v6:
> - Added more details in git commit message
> - Fixed commenting format per coding style in UML (Christophe Leroy)
> - Changed exporting to GPL for kasan_flag_enabled (Christophe Leroy)
> - Converted ARCH_DEFER_KASAN to def_bool depending on KASAN to avoid
>         arch users to have `if KASAN` condition (Christophe Leroy)
> - Forgot to add __init for kasan_init in UML
>
> Changes in v5:
> - Unified patches where arch (powerpc, UML, loongarch) selects
>     ARCH_DEFER_KASAN in the first patch not to break
>     bisectability
> - Removed kasan_arch_is_ready completely as there is no user
> - Removed __wrappers in v4, left only those where it's necessary
>     due to different implementations
>
> Changes in v4:
> - Fixed HW_TAGS static key functionality (was broken in v3)
> - Merged configuration and implementation for atomicity
> ---
>  arch/loongarch/Kconfig                 |  1 +
>  arch/loongarch/include/asm/kasan.h     |  7 ------
>  arch/loongarch/mm/kasan_init.c         |  8 +++----
>  arch/powerpc/Kconfig                   |  1 +
>  arch/powerpc/include/asm/kasan.h       | 12 ----------
>  arch/powerpc/mm/kasan/init_32.c        |  2 +-
>  arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
>  arch/powerpc/mm/kasan/init_book3s_64.c |  6 +----
>  arch/um/Kconfig                        |  1 +
>  arch/um/include/asm/kasan.h            |  5 ++--
>  arch/um/kernel/mem.c                   | 13 ++++++++---
>  include/linux/kasan-enabled.h          | 32 ++++++++++++++++++--------
>  include/linux/kasan.h                  |  6 +++++
>  lib/Kconfig.kasan                      | 12 ++++++++++
>  mm/kasan/common.c                      | 17 ++++++++++----
>  mm/kasan/generic.c                     | 19 +++++++++++----
>  mm/kasan/hw_tags.c                     |  9 +-------
>  mm/kasan/kasan.h                       |  8 ++++++-
>  mm/kasan/shadow.c                      | 12 +++++-----
>  mm/kasan/sw_tags.c                     |  1 +
>  mm/kasan/tags.c                        |  2 +-
>  21 files changed, 106 insertions(+), 70 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 93402a1d9c9f..4730c676b6bf 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -122,6 +122,7 @@ config PPC
>  	# Please keep this list sorted alphabetically.
>  	#
>  	select ARCH_32BIT_OFF_T if PPC32
> +	select ARCH_NEEDS_DEFER_KASAN		if PPC_RADIX_MMU
>  	select ARCH_DISABLE_KASAN_INLINE	if PPC_RADIX_MMU
>  	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
>  	select ARCH_ENABLE_MEMORY_HOTPLUG
> diff --git a/arch/powerpc/include/asm/kasan.h b/arch/powerpc/include/asm/kasan.h
> index b5bbb94c51f6..957a57c1db58 100644
> --- a/arch/powerpc/include/asm/kasan.h
> +++ b/arch/powerpc/include/asm/kasan.h
> @@ -53,18 +53,6 @@
>  #endif
>  
>  #ifdef CONFIG_KASAN
> -#ifdef CONFIG_PPC_BOOK3S_64
> -DECLARE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
> -
> -static __always_inline bool kasan_arch_is_ready(void)
> -{
> -	if (static_branch_likely(&powerpc_kasan_enabled_key))
> -		return true;
> -	return false;
> -}
> -
> -#define kasan_arch_is_ready kasan_arch_is_ready
> -#endif
>  
>  void kasan_early_init(void);
>  void kasan_mmu_init(void);
> diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
> index 03666d790a53..1d083597464f 100644
> --- a/arch/powerpc/mm/kasan/init_32.c
> +++ b/arch/powerpc/mm/kasan/init_32.c
> @@ -165,7 +165,7 @@ void __init kasan_init(void)
>  
>  	/* At this point kasan is fully initialized. Enable error messages */
>  	init_task.kasan_depth = 0;
> -	pr_info("KASAN init done\n");
> +	kasan_init_generic();
>  }
>  
>  void __init kasan_late_init(void)
> diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
> index 60c78aac0f63..0d3a73d6d4b0 100644
> --- a/arch/powerpc/mm/kasan/init_book3e_64.c
> +++ b/arch/powerpc/mm/kasan/init_book3e_64.c
> @@ -127,7 +127,7 @@ void __init kasan_init(void)
>  
>  	/* Enable error messages */
>  	init_task.kasan_depth = 0;
> -	pr_info("KASAN init done\n");
> +	kasan_init_generic();
>  }
>  
>  void __init kasan_late_init(void) { }
> diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
> index 7d959544c077..dcafa641804c 100644
> --- a/arch/powerpc/mm/kasan/init_book3s_64.c
> +++ b/arch/powerpc/mm/kasan/init_book3s_64.c
> @@ -19,8 +19,6 @@
>  #include <linux/memblock.h>
>  #include <asm/pgalloc.h>
>  
> -DEFINE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
> -
>  static void __init kasan_init_phys_region(void *start, void *end)
>  {
>  	unsigned long k_start, k_end, k_cur;
> @@ -92,11 +90,9 @@ void __init kasan_init(void)
>  	 */
>  	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
>  
> -	static_branch_inc(&powerpc_kasan_enabled_key);
> -
>  	/* Enable error messages */
>  	init_task.kasan_depth = 0;
> -	pr_info("KASAN init done\n");
> +	kasan_init_generic();
>  }
>  

Only book3s64 needs static keys here because of radix v/s hash mode
selection during runtime. The changes in above for powerpc looks good to
me. It's a nice cleanup too.

So feel free to take:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> #powerpc

However I have few comments below...

...
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 9142964ab9c9..e3765931a31f 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -32,6 +32,15 @@
>  #include "kasan.h"
>  #include "../slab.h"
>  
> +#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
> +/*
> + * Definition of the unified static key declared in kasan-enabled.h.
> + * This provides consistent runtime enable/disable across KASAN modes.
> + */
> +DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
> +EXPORT_SYMBOL_GPL(kasan_flag_enabled);
> +#endif
> +
>  struct slab *kasan_addr_to_slab(const void *addr)
>  {
>  	if (virt_addr_valid(addr))
> @@ -246,7 +255,7 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
>  bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
>  				unsigned long ip)
>  {
> -	if (!kasan_arch_is_ready() || is_kfence_address(object))
> +	if (is_kfence_address(object))

For changes in mm/kasan/common.c.. you have removed !kasan_enabled()
check at few places. This seems to be partial revert of commit [1]:
  
  b3c34245756ada "kasan: catch invalid free before SLUB reinitializes the object" 

Can you please explain why this needs to be removed? 
Also the explaination of the same should be added in the commit msg too.

[1]: https://lore.kernel.org/all/20240809-kasan-tsbrcu-v8-1-aef4593f9532@google.com/

>  		return false;
>  	return check_slab_allocation(cache, object, ip);
>  }
> @@ -254,7 +263,7 @@ bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
>  bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
>  		       bool still_accessible)
>  {
> -	if (!kasan_arch_is_ready() || is_kfence_address(object))
> +	if (is_kfence_address(object))
>  		return false;
>  
>  	/*
> @@ -293,7 +302,7 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
>  
>  static inline bool check_page_allocation(void *ptr, unsigned long ip)
>  {
> -	if (!kasan_arch_is_ready())
> +	if (!kasan_enabled())
>  		return false;
>  
>  	if (ptr != page_address(virt_to_head_page(ptr))) {
> @@ -522,7 +531,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
>  		return true;
>  	}
>  
> -	if (is_kfence_address(ptr) || !kasan_arch_is_ready())
> +	if (is_kfence_address(ptr))
>  		return true;
>  
>  	slab = folio_slab(folio);

-ritesh

