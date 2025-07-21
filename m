Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E37C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB32A6B009E; Mon, 21 Jul 2025 19:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D639F6B009F; Mon, 21 Jul 2025 19:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52BD6B00A0; Mon, 21 Jul 2025 19:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1A656B009E
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:00:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 787551101A9
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:00:06 +0000 (UTC)
X-FDA: 83689791612.07.4513751
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 68D3D80010
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:00:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+pxWU0v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753138804; a=rsa-sha256;
	cv=none;
	b=USQpmIJ4YAAiDzdXfjZyfbMPGrHR7vB+GvHjJjOfiBMz+A0XQxkSO/oTUDCDXba5Ix4Uoy
	QV6ca+CJ+Dhwsss/DsZRq5Xy/5Xx915vtlaOqPaiNUrMP1EpvFnfmGKHO03SzoAglQHIgP
	B4Kd5j5K2GbfcJMdvcfY5OkDv6tXgOU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+pxWU0v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753138804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/MErh+IJZfEbaFHl36LqhlLVHvlXTKmbu8riveWqw+Q=;
	b=T3Yub1OojPkx1Y3g8IbIFEyOoTkmeqMtmNKnmZMHG7lyFtbofn30vU7LUdyPHqlywlGizE
	CE01jS2fneT8T+OznzWEZPT/h/AO3ITLgtWo4viyqd5NVqPUiVcvKOcDawj5XyiZCh2URD
	/2BBdUZ9rI4TS/nNJkyJ/v3zVlezYq4=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60c733792e9so752291a12.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753138803; x=1753743603; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/MErh+IJZfEbaFHl36LqhlLVHvlXTKmbu8riveWqw+Q=;
        b=L+pxWU0vG946GM9LIXbJb75MwvYyowdCLvm598l5VB9EBCBXDN0N/R8kjfgl6dZMIz
         XwDH4TbWwlHwm+V5tLgY3QcAFKUj/qCIsIph7Gtj2ftE7egKaldbEbF46mS1hTPzOj15
         xFkcy9eQQO+MCSJHHV1ZtozveqtZWVnGNzwcAOnGzPwiRyGZ7suYn9opuYYDQsCeJ04b
         hixdQUNJQRFHLkZ7XZV0oIfxa74qk0dEiFnp2AkLxd/KRWVAL0dFPfJgwhr54bxoMmC2
         34r2oEsw3lDrohGlRzmlTEHyQjtdK1gXhSywGyoZvI65b4GNJy6B1we6m8/v6XyTU0vN
         MYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753138803; x=1753743603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/MErh+IJZfEbaFHl36LqhlLVHvlXTKmbu8riveWqw+Q=;
        b=E3HKM+IQijDcG37h3NMXvE5NvyJRAntMFh8qUcFBGTc83Q2VSmm2h03OSvv+x63yP+
         P6snVbckSSMA7ta2TfsWSI1VC5EEYySy4AAXOWnOywHf89xru9my+6N9ToveXdoBZAzD
         mFEXwmY8CjR7pJo72o/z+tT59oqzDp+qm9HlIglaqomudC5wVtU2hz8LZvM1BXp1B13P
         DDO8ReaRHcWa0U5ZpM/hEjEeo6QwvQ6UOXEYgxa/tItdnjRCk5UKb99g7LuzkES/5Oi0
         hcMe9L70XyXmuf8YNQjRWXM0Ss0u8Sd9dtbGzPPqv9o9YwZQrRtTxcIc/TxUbe32Mlts
         Q4MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtrLSJhGq1JdvK9ZgYLkNdWQNA/FcWbL1BXCIhB+1JJ8FFuCc9K0eyqpeQn6+1SzGTIHzb7IpLdw==@kvack.org
X-Gm-Message-State: AOJu0YzM//iLU4SelZEzIp0CK2qjJnEdNpUaiEeUW5/kIIzt+b3hqe9n
	ffV+UWvEEgkw60O9MEMNZFVBctSH623kU61XP+Rlgv+4rgpCKaj81/iQ
X-Gm-Gg: ASbGnctguilFajVaVCoS4kDyzAmualYFaxVN46gqwdL9pA3cjr2oOr5bXNv/U6rI/JD
	A9VsAchj4NW8U2rgEIbHsl11JK3VGkLm82qFKcQuLIq4MwMFl5OIpw/rkqoMTPtv7pqAESGNGVt
	WDOEfmRXG36uAAfEn4dVHU7EqSg6XlLXO8Ye6KleuPG5I4lYDc5zMxfbOTTnZwH/nJo0Oalpg6F
	GHEF8zB7jj8xt6wdTdrcfgEgWBH2vJMG4Qq8emV3PsxXmdu5lQg/hmDgE/5E+5AuWzAczdZdMre
	f8TiDoYezcIEOP9Khn0a2KAX2nff9EJsJUbKeLbsCFM9lM9EIFBi0D+Bj8y7pWgm5tm2ZdTAe+U
	1CzJcyQZsVijaP61UB/HU4f87PhzjF4lftFliCee6gugnZWYzJHrb729/+WeWtudYJ5Mm
X-Google-Smtp-Source: AGHT+IFhWRkAjq0kp3rYVJajv166B7T+5igJwYiG9mr5QC8ggMyhPPllogHKb3eusDQL2P7c9HNNmg==
X-Received: by 2002:a05:6402:3582:b0:612:b0d9:3969 with SMTP id 4fb4d7f45d1cf-612b0d93f03mr5896945a12.8.1753138802656;
        Mon, 21 Jul 2025 16:00:02 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-142-142.dynamic.sbb.rs. [94.189.142.142])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-612c8f543ddsm5962670a12.30.2025.07.21.16.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 16:00:01 -0700 (PDT)
Message-ID: <8f93322a-84c1-402b-b8d4-9c66a2b07b0b@gmail.com>
Date: Tue, 22 Jul 2025 00:59:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/12] kasan: unify static kasan_flag_enabled across
 modes
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, hca@linux.ibm.com,
 christophe.leroy@csgroup.eu, andreyknvl@gmail.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org
Cc: glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250717142732.292822-1-snovitoll@gmail.com>
 <20250717142732.292822-3-snovitoll@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250717142732.292822-3-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qb1hqpux9c67wp5mdyjr1xpryr6rg8p5
X-Rspam-User: 
X-Rspamd-Queue-Id: 68D3D80010
X-Rspamd-Server: rspam02
X-HE-Tag: 1753138804-142103
X-HE-Meta: U2FsdGVkX1+y05jmEKpXQSltzwIK7NAaiGVQ0eZHGpKKelbtbAGlQaX5d+z1C9WzMAEd8pXgBiOdeii3XsFCesbVkHi5Yikx6cgLxtbJhu1+MqHYplH+2oL/huT6p3xYqpa4WL1Q9OWvaDTnnn+CgBcBzV3UoCEFb33sr+BsI7RZzPHPQtgnFHsymxByVddeE69WpaREIEZBU1JRxQpAuMSgfLsOrwo3kc0NA8pdGJqB49cTXZ6EUMZsxsTlvGRUNy60ZVVFcYSbw8MFGEI5YapqS3jh6KYLndiIv4VoeuEZLj8EYxNnrixDWpLX8d24ChmUNbGg9yi2QxlFhQ3VmT0+3wm9dpOamOYDvn9i5ZmH9dOdkDJpSmnoSI4GgkaZiD0zBxctwWasnZTKdDuseLM+pygXhNpbFKnAIoIW3rCev2zI2KYck89pvM9W4sg/eEsPC+tKD5xzoOTBg9HUm4tt0+MiREGxpjSrGg8i275EiBBuGSqhsHKjitSm2bghUYykkOoyh9RlSRdmqSw5ijkCZ53NIOh7KLR4XJjGl0eOATC6yhz+8mJrvC5FOcfHNDOCUQH/gwaHJJgJvlgqg1i5Xf7C5fCcQi0lU9iQNJmQCIK2Dc6H9gW5N6QeGtp+WeJHSjFxyuFmZZtISNbyWYEsBHAXzpz69KMAP0KicToSjlIxqsinvR532laCY0SFFLUZ3+YHh9XDET0NaquDcx7GbtHMPO+WCQWjoUYAcBCIr8djw7Yicw7XeFoaYugQetXPCqbS/2bhQ9bk4XH3nEvmwmfeBs1Bs1qzyGE8nyaEX3c7hh0E0SCyoOYbWJMWSyfQhoRgRA2TQ7LiPBQ8vMZYnmjjohn3GthV6Pm4xLd2z6udeH488xZ+2P521eTze49qQOtyz6D1rnI+4Z7divGpw8iT8A/JxwM4NM/qfntaEbIA8rm6RReXwGRdlqHFeDMun3Iy7rH6djHBdOi
 pF4dn4dy
 UIHaaX4yjaGn3OoW4F7BT+tDDd0X36FUXQyc0063H2I8GcQ3K5/7xKetWG4PCWqBkk29GFcs0DK0g7tHRnKFp24Fdnr9LIIX+EZtQWuzeCtNd4BYMsHargJQD0KZeiCPr6BSJgWWUDlrmkIOSiXciaLvUg9bq9mNdNWnvEWN2jVpXAHxGuayNAKdknZZ4jutVJgmLjRK17vhpEbBo5tSDoyiM5Xa8t7mDdkxWmbxxUFdA0XzVztKDFMDH5iKezCpMQNqBe8a2TMaK7/gKUGy5eY7jwIuOPuMz8rAd2WE4Z0aRycbiHt12R7OrQj87vT3JSJNXm35lP7bNuUrXypIS2Of5KgNmXg1Td5HN8DoDT7TNmIVqXaBe+MisCcPmqX2p3JJjLbxnOTyy90MmJ9UU3ExMM4LCVEkzGOEGKc/c35usbcyo176l1Tdrgigyju+Lk4GZxBznF0ummRj+JATCePlg9jsHCr80z+Q0DdIlachU/zMjqjAtDzUFS3z3JI4Egzf7Hv28l/gOSTjPDnVVCTSoFs5oePVSX8Ic1KQcr32xNS3Zio1WFgspA0ApZhTJ/gy4qB/8g+1VZnEDHiVRmN8WpF4HJgEBypiN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:
> Historically, the runtime static key kasan_flag_enabled existed only for
> CONFIG_KASAN_HW_TAGS mode. Generic and SW_TAGS modes either relied on
> architecture-specific kasan_arch_is_ready() implementations or evaluated
> KASAN checks unconditionally, leading to code duplication.
> 
> This patch implements two-level approach:
> 
> 1. kasan_enabled() - controls if KASAN is enabled at all (compile-time)
> 2. kasan_shadow_initialized() - tracks shadow memory
>    initialization (runtime)
> 
> For architectures that select ARCH_DEFER_KASAN: kasan_shadow_initialized()
> uses a static key that gets enabled when shadow memory is ready.
> 
> For architectures that don't: kasan_shadow_initialized() returns
> IS_ENABLED(CONFIG_KASAN) since shadow is ready from the start.
> 
> This provides:
> - Consistent interface across all KASAN modes
> - Runtime control only where actually needed
> - Compile-time constants for optimal performance where possible
> - Clear separation between "KASAN configured" vs "shadow ready"
> 
> Also adds kasan_init_generic() function that enables the shadow flag and
> handles initialization for Generic mode, and updates SW_TAGS and HW_TAGS
> to use the unified kasan_shadow_enable() function.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
> Changes in v3:
> - Only architectures that need deferred KASAN get runtime overhead
> - Added kasan_shadow_initialized() for shadow memory readiness tracking
> - kasan_enabled() now provides compile-time check for KASAN configuration
> ---
>  include/linux/kasan-enabled.h | 34 ++++++++++++++++++++++++++--------
>  include/linux/kasan.h         |  6 ++++++
>  mm/kasan/common.c             |  9 +++++++++
>  mm/kasan/generic.c            | 11 +++++++++++
>  mm/kasan/hw_tags.c            |  9 +--------
>  mm/kasan/sw_tags.c            |  2 ++
>  6 files changed, 55 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> index 6f612d69ea0..fa99dc58f95 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -4,32 +4,50 @@
>  
>  #include <linux/static_key.h>
>  
> -#ifdef CONFIG_KASAN_HW_TAGS
> +/* Controls whether KASAN is enabled at all (compile-time check). */
> +static __always_inline bool kasan_enabled(void)
> +{
> +	return IS_ENABLED(CONFIG_KASAN);
> +}
>  
> +#ifdef CONFIG_ARCH_DEFER_KASAN
> +/*
> + * Global runtime flag for architectures that need deferred KASAN.
> + * Switched to 'true' by the appropriate kasan_init_*()
> + * once KASAN is fully initialized.
> + */
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>  
> -static __always_inline bool kasan_enabled(void)
> +static __always_inline bool kasan_shadow_initialized(void)
>  {
>  	return static_branch_likely(&kasan_flag_enabled);
>  }
>  
> -static inline bool kasan_hw_tags_enabled(void)
> +static inline void kasan_enable(void)
> +{
> +	static_branch_enable(&kasan_flag_enabled);
> +}
> +#else
> +/* For architectures that can enable KASAN early, use compile-time check. */
> +static __always_inline bool kasan_shadow_initialized(void)
>  {
>  	return kasan_enabled();
>  }
>  
> -#else /* CONFIG_KASAN_HW_TAGS */
> +/* No-op for architectures that don't need deferred KASAN. */
> +static inline void kasan_enable(void) {}
> +#endif /* CONFIG_ARCH_DEFER_KASAN */
>  
> -static inline bool kasan_enabled(void)
> +#ifdef CONFIG_KASAN_HW_TAGS
> +static inline bool kasan_hw_tags_enabled(void)
>  {
> -	return IS_ENABLED(CONFIG_KASAN);
> +	return kasan_enabled();
>  }
> -
> +#else
>  static inline bool kasan_hw_tags_enabled(void)
>  {
>  	return false;
>  }
> -
>  #endif /* CONFIG_KASAN_HW_TAGS */
>  
>  #endif /* LINUX_KASAN_ENABLED_H */
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2..51a8293d1af 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -543,6 +543,12 @@ void kasan_report_async(void);
>  
>  #endif /* CONFIG_KASAN_HW_TAGS */
>  
> +#ifdef CONFIG_KASAN_GENERIC
> +void __init kasan_init_generic(void);
> +#else
> +static inline void kasan_init_generic(void) { }
> +#endif
> +
>  #ifdef CONFIG_KASAN_SW_TAGS
>  void __init kasan_init_sw_tags(void);
>  #else
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index ed4873e18c7..c3a6446404d 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -32,6 +32,15 @@
>  #include "kasan.h"
>  #include "../slab.h"
>  
> +#ifdef CONFIG_ARCH_DEFER_KASAN
> +/*
> + * Definition of the unified static key declared in kasan-enabled.h.
> + * This provides consistent runtime enable/disable across KASAN modes.
> + */
> +DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
> +EXPORT_SYMBOL(kasan_flag_enabled);
> +#endif
> +
>  struct slab *kasan_addr_to_slab(const void *addr)
>  {
>  	if (virt_addr_valid(addr))
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index d54e89f8c3e..03b6d322ff6 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -36,6 +36,17 @@
>  #include "kasan.h"
>  #include "../slab.h"
>  
> +/*
> + * Initialize Generic KASAN and enable runtime checks.
> + * This should be called from arch kasan_init() once shadow memory is ready.
> + */
> +void __init kasan_init_generic(void)
> +{
> +	kasan_enable();
> +
> +	pr_info("KernelAddressSanitizer initialized (generic)\n");
> +}
> +
>  /*
>   * All functions below always inlined so compiler could
>   * perform better optimizations in each of __asan_loadX/__assn_storeX
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b5..c8289a3feab 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -45,13 +45,6 @@ static enum kasan_arg kasan_arg __ro_after_init;
>  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
>  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
>  
> -/*
> - * Whether KASAN is enabled at all.
> - * The value remains false until KASAN is initialized by kasan_init_hw_tags().
> - */
> -DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
> -EXPORT_SYMBOL(kasan_flag_enabled);
> -
>  /*
>   * Whether the selected mode is synchronous, asynchronous, or asymmetric.
>   * Defaults to KASAN_MODE_SYNC.
> @@ -260,7 +253,7 @@ void __init kasan_init_hw_tags(void)
>  	kasan_init_tags();
>  
>  	/* KASAN is now initialized, enable it. */
> -	static_branch_enable(&kasan_flag_enabled);
> +	kasan_enable();
>  

This is obviously broken for the HW_TAGS case. kasan_enable() does nothing,
and kasan_hw_tags_enabled() now always return true.

