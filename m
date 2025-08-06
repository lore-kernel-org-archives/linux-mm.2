Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1121BC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 13:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660D96B009E; Wed,  6 Aug 2025 09:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638626B009F; Wed,  6 Aug 2025 09:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E846B00A0; Wed,  6 Aug 2025 09:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4466C6B009E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:35:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C98641363C7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:35:08 +0000 (UTC)
X-FDA: 83746428696.04.0D3F867
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F15510000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:35:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DcADHdCL;
	spf=pass (imf05.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754487306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkBywKSK+jarcaDEWkMpZ6690o3qyLvHV2Ljs5N+BnY=;
	b=IHUr9NRCl0HezjuASRaxwAdJmCzYz4dDHBcKYWwpNAXPb55DH+Sji6Doji0wJiw1Kj1Gt0
	4oKpOHp+4NPnEKT581J2nmu+7+/OA6WQ1Zozs05SZ3a99ZLgRnCiHP8IgzwQCFciYPjATC
	DDUWZrTa+eQNmS6lQKbRSN5KEUbCIhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754487306; a=rsa-sha256;
	cv=none;
	b=s2+91AyJ8+aZwMDquPTTOQczQ7QB2ZfMs2mui9i8HosgH52ID2axpqU+xzW+//h7tVQYm+
	SvPdMiKlMGtsmM9tcD+pwHDuCTKZrOS5U3EJfSyj/t++3dq+Ft28pJ/cC2vg92A509nkSV
	udZ/sBk8S3oWUNLMUAs72dVm7lUpTlI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DcADHdCL;
	spf=pass (imf05.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55b9dfd4020so642106e87.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 06:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754487304; x=1755092104; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GkBywKSK+jarcaDEWkMpZ6690o3qyLvHV2Ljs5N+BnY=;
        b=DcADHdCLoVv2J+iYxIRCNYSP/sC/mOvyuJbASq/Gl+4p/iHEZY2gaFzFNzWrBoKeBV
         muRM3eZrHgp10P5ckIG8CUdHEnbg8SfiZjGP6Q79qb/sBbQELlSGdCKEXuI+sCaRapt3
         yHXgRb/z5oFqNIFSshVysl8tCaolQEhNvqJkdX3Qape5R9AOyzJw0xV17Uy8+vHn2McU
         qUObz23nuuYRQAHTZ+cyysRfJCnvCEySxLS91QbemN3yEw7BTei6GAaci5TEBJETigEE
         gj0PhODp0V9jds//xZk0C7QbYSpABzGW85Xor828yxNbIYNaf1BaAwf6fBRvjxLC4Q7j
         Strw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754487304; x=1755092104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GkBywKSK+jarcaDEWkMpZ6690o3qyLvHV2Ljs5N+BnY=;
        b=QhHamfLa9WK3kScce2uSrNN48DpsCyW80buxxljjUbqQIL5lEU9HJ514la/TEt2rsZ
         oW4KkwUlKQWnvyafdAavtA93+MM7X2Bp31KKoHmml5GTvmBiRnob+92mNtIaU6n040cr
         V6suByXEcXm9pnM6SKHHFkd9G87dsQ/oP9qFqocJr6zjnuKyHpdfdUfTBFy081Bl5Asc
         qd+sHzPlqosa829VVRp0lH3diW47F6rTV0+xK4Q7+HfRp7q+7C23/RaKv/QjSZe2JGK8
         VIK2irUc9PCabhwIpdpa0BZZ9qu1UgVTD4ggnK7OlPQtXvEqWfbuSZbQusqPu89frM1H
         SSKw==
X-Forwarded-Encrypted: i=1; AJvYcCXRB5JaPxXUsXI97bHv2EmWYzHgLEP+az+s29qDrXsL0wI26kMvfLrKpGmtrACT36dzb8FdhZLGvw==@kvack.org
X-Gm-Message-State: AOJu0Yx3pFQamMqArMKk2xmGQFrh3XPJTjvFJDysab75ZAgFoHBIOkLN
	FYD+/0vaaQeUlJSEdRzFp3wzd4rwqCqO8NfbngH4oRXunHK7odJne3Im
X-Gm-Gg: ASbGncs4urPaWBTYCaBDazvGqGAABmanDbIKiRsXdNsAGLTgl0aSw/2UaOEozvHgxD3
	cDEDAQv2MhxjN1NDdmcbwgJDsTVJm9SFm98Xn9B1xoshdr1dhGBANVuMjP6+pTAonNp7FX7UeY5
	h85H/S8Rc0nzKZSydz5l/Rfhomh4fSmmt81IHsiGHtY3Rf2oeV/yvbh6z4wz5v7zvKptl64AItx
	up/UDfLhMkWVlYiCA6H7ACOB4jW6+yf8KutfGAomT1MSUQr5Lm8VTpJrhUPFJQNicMa3iXZ9BhN
	YNcb2EWkpn/2mqCIzL09oThBBqd4VlTqmg82A/0sz0hFq5lXQbu3e7rgrB8cSB2z8ZtEnkymf2H
	eEP0PpzFaWaozTPSjJi+ilLnwIi2o
X-Google-Smtp-Source: AGHT+IG/+xV14jPScIlu8zUGGDD+ajQ7/dFSreWgfNZ5pS9U8lvRiqBw989XNjNOSP9y7GWZ8ScIMA==
X-Received: by 2002:a05:6512:ad1:b0:55a:4d9e:6536 with SMTP id 2adb3069b0e04-55caf2f956dmr417291e87.2.1754487304191;
        Wed, 06 Aug 2025 06:35:04 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b8899ebd2sm2302283e87.42.2025.08.06.06.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 06:35:03 -0700 (PDT)
Message-ID: <5a73e633-a374-47f2-a1e1-680e24d9f260@gmail.com>
Date: Wed, 6 Aug 2025 15:34:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, hca@linux.ibm.com,
 christophe.leroy@csgroup.eu, andreyknvl@gmail.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org, zhangqing@loongson.cn, chenhuacai@loongson.cn,
 trishalfonso@google.com, davidgow@google.com
Cc: glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250805142622.560992-1-snovitoll@gmail.com>
 <20250805142622.560992-2-snovitoll@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250805142622.560992-2-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7F15510000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: jmy4djzd9kow737myccyyih8oigkgfna
X-HE-Tag: 1754487306-370194
X-HE-Meta: U2FsdGVkX197aYlkHbJYMyhMAu/yLSpxqLBa55zH6vNppcvkYxIGcj/TJOjPiw7g25qYdfgXCTQaN7q4XXdExmDVC8JwB+2ysOcAdtUADG4lNEKA0E6TSAQIIBqKWbTEXUnW9SGoASf+9Fp+TN6SLp0btACE5ROdPrcZCGA4RqYksh96HmAopq+0yz5BedXVdUv1ceuwM1RBfWWenGYFWNBrGnQPYuZcm8PtzcdTmp+Ai1uNhZCwa21htAF3Io3CqceBDfc4Ro7tELkg6/fPnxoIqouTMcCoG32GWg1lVj7ViieGolBzEuPuOK61ANSayrM9sMkzu6PKCTIT9xmenOxstDYGePsQvlEHFCDamBLu+H8JGNXtRy0p/quTN0VJ4BBkcoA/+BFRFKKfs3z5h4Esz9pMU8vhJ+lvqMNA792aeEiiCjuOfaWWFW29A5Q7n0kEVz0vQwMkcw2U1x+ym+xfes2iJdesl7qASvkQl34Dq0DTOscTIiK47v5ZHBR0vrwZ2u8lvEZsxtGQG7U/YPGc3PGqR4Fphm8wpDLk2lsqLAb8UkJ4JZenAqnjZPadLzRYwISGaWy4y+hVk2cI5JJoPUctc/hT/x4useZCyER+ihIeVSWWQuZqQMZx658NKPpIJFt46tbY18sZXLz7QIEzI/EqN3ASm/sNexOkK9/1YImTq+fDCgRTPqbHIsUFwKraaUUlRVPfpppprSPOqyZMhqv5iRtugN/FF4NtCXzJVbRtDNORFLtyTW6YBn2ruJW3G9Dew/3fnRQMBg2jQ3yz2GKYM43SHmv/nlVH1zYiEFpY5tGFRrt0q2miUyiLyD5Ei84hCg1GxV0BNFnzqeXT4MKqnvEd39glfqDkp7uItIsj14FZnaLt1HDRjxIwww+2fSUA/xGiN/Nc/SznUozWFeCGH4ff4rqh9JxoLWTxMspwYFyKxNCphnE2a/y/NhHXP70Px2sqQzYcPfS
 X3TUoUt0
 vUNs60yzvuwcdmXDM0jx7GjVPe3v3WOVeD0jcFuiv1ieqg8fn/v8Sqc0TKR3OkJ4+Fw6leLvR4SBe8/cAItMY4w38m4/lJZyWenXPqk/APUX0//vWWWH4Sxa14YfSfcMGBbEGf9QDrZuODL4gk/mHV1bPXQT599w55jykIKgk/VL+ybb6xOSjA588uPr1+NyRTgNOhhaFrra0unPeVCWFxWLzrz0e1Xat+FZ2hbXb4TOjxFjp/hE6WwH9UvTF0zCJxcT0SLLZWMNuwvpRNjbIPbB3qo+4q799I/6UDfL1mvs/YxcLggvkzbYy3kbzqVuN15dNci9MLszXiINnUj7osgXnG0kn+wMnRI6KUsIBYAhFkN7MofYg4XVCVsPPuUBybvK43Cj4cMzAulL96Yg21GhT/dqVwmow+NLs0+I8amH/dXr/xWm0qVt63PxsUVckIQJyzTiU8tvJFflA5TFcWbXWgpwXw8qLJKk7/WlnUfHyErTLcnR60m7TNsPZrD9fa8jRCw8kEa9sDGVpUmBZA6hwBYtTQjg1D+J3rqeBGI+X92KNJqOaFPBc9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/25 4:26 PM, Sabyrzhan Tasbolatov wrote:
> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures that need
> to defer KASAN initialization until shadow memory is properly set up,
> and unify the static key infrastructure across all KASAN modes.
> 
> Some architectures (like PowerPC with radix MMU) need to set up their
> shadow memory mappings before KASAN can be safely enabled, while others
> (like s390, x86, arm) can enable KASAN much earlier or even from the
> beginning.
> 
> Historically, the runtime static key kasan_flag_enabled existed only for
> CONFIG_KASAN_HW_TAGS mode. Generic and SW_TAGS modes either relied on
> architecture-specific kasan_arch_is_ready() implementations or evaluated
> KASAN checks unconditionally, leading to code duplication.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
> Changes in v4:
> - Fixed HW_TAGS static key functionality (was broken in v3)

I don't think it fixed. Before you patch kasan_enabled() esentially
worked like this:

 if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))
        return static_branch_likely(&kasan_flag_enabled);
 else
        return IS_ENABLED(CONFIG_KASAN);

Now it's just IS_ENABLED(CONFIG_KASAN);

And there are bunch of kasan_enabled() calls left whose behavior changed for
no reason.


> - Merged configuration and implementation for atomicity
> ---
>  include/linux/kasan-enabled.h | 36 +++++++++++++++++++++++-------
>  include/linux/kasan.h         | 42 +++++++++++++++++++++++++++--------
>  lib/Kconfig.kasan             |  8 +++++++
>  mm/kasan/common.c             | 18 ++++++++++-----
>  mm/kasan/generic.c            | 23 +++++++++++--------
>  mm/kasan/hw_tags.c            |  9 +-------
>  mm/kasan/kasan.h              | 36 +++++++++++++++++++++---------
>  mm/kasan/shadow.c             | 32 ++++++--------------------
>  mm/kasan/sw_tags.c            |  4 +++-
>  mm/kasan/tags.c               |  2 +-
>  10 files changed, 133 insertions(+), 77 deletions(-)
> 
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> index 6f612d69ea0..52a3909f032 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -4,32 +4,52 @@
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
> +#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
> +/*
> + * Global runtime flag for KASAN modes that need runtime control.
> + * Used by ARCH_DEFER_KASAN architectures and HW_TAGS mode.
> + */
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>  
> -static __always_inline bool kasan_enabled(void)
> +/*
> + * Runtime control for shadow memory initialization or HW_TAGS mode.
> + * Uses static key for architectures that need deferred KASAN or HW_TAGS.
> + */
> +static __always_inline bool kasan_shadow_initialized(void)

Don't rename it, just leave as is - kasan_enabled().
It's better name, shorter and you don't need to convert call sites, so
there is less chance of mistakes due to unchanged kasan_enabled() -> kasan_shadow_initialized().


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

...

>  
>  void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
> -int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
> -void kasan_release_vmalloc(unsigned long start, unsigned long end,
> +
> +int __kasan_populate_vmalloc(unsigned long addr, unsigned long size);
> +static inline int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
> +{
> +	if (!kasan_shadow_initialized())
> +		return 0;


What's the point of moving these checks to header?
Leave it in C, it's easier to grep and navigate code this way.


> +	return __kasan_populate_vmalloc(addr, size);
> +}
> +
> +void __kasan_release_vmalloc(unsigned long start, unsigned long end,
>  			   unsigned long free_region_start,
>  			   unsigned long free_region_end,
>  			   unsigned long flags);
> +static inline void kasan_release_vmalloc(unsigned long start,
> +			   unsigned long end,
> +			   unsigned long free_region_start,
> +			   unsigned long free_region_end,
> +			   unsigned long flags)
> +{
> +	if (kasan_shadow_initialized())
> +		__kasan_release_vmalloc(start, end, free_region_start,
> +			   free_region_end, flags);
> +}
>  

...> @@ -250,7 +259,7 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
>  bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
>  				unsigned long ip)
>  {
> -	if (!kasan_arch_is_ready() || is_kfence_address(object))
> +	if (is_kfence_address(object))
>  		return false;
>  	return check_slab_allocation(cache, object, ip);
>  }
> @@ -258,7 +267,7 @@ bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
>  bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
>  		       bool still_accessible)
>  {
> -	if (!kasan_arch_is_ready() || is_kfence_address(object))
> +	if (is_kfence_address(object))
>  		return false;
>  
>  	poison_slab_object(cache, object, init, still_accessible);
> @@ -282,9 +291,6 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
>  
>  static inline bool check_page_allocation(void *ptr, unsigned long ip)
>  {
> -	if (!kasan_arch_is_ready())
> -		return false;
> -


Well, you can't do this yet, because no arch using ARCH_DEFER_KASAN yet, so this breaks
bisectability.
Leave it, and remove with separate patch only when there are no users left.

>  	if (ptr != page_address(virt_to_head_page(ptr))) {
>  		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
>  		return true;
> @@ -511,7 +517,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
>  		return true;
>  	}
>  
> -	if (is_kfence_address(ptr) || !kasan_arch_is_ready())
> +	if (is_kfence_address(ptr))
>  		return true;
>  
>  	slab = folio_slab(folio);



