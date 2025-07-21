Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213F4C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B430A6B00A2; Mon, 21 Jul 2025 19:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3876B00A3; Mon, 21 Jul 2025 19:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2536B00A4; Mon, 21 Jul 2025 19:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 898116B00A2
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:00:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AFB15714C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:00:27 +0000 (UTC)
X-FDA: 83689792494.30.AA90579
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id E31B1C0011
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:00:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O7YnXLuC;
	spf=pass (imf22.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753138825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I50g8CBYTAJgx5jeL63ocp0XmC4ojzYZYl9cwyXAxL0=;
	b=x9pjSfVXVw5sNpBWAbRPrf5SehlzLM2jrssb+xQ+b3QUE7VL2X1pQbjtVGuZzUUjXz3bnS
	r9dznN6LdQ5J04iV+TGds7FCU34NtWBN0eTg0jPFYbuilD5A4TfACDgdzMzuqkMmbWyiRC
	rth90yAYJuOASPJFy1fEsgMzBShLMA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753138825; a=rsa-sha256;
	cv=none;
	b=CGATG7rYOca4Jlf7Aqm2N1W6q0+H/gOa3NFLBQDK+5cPmwAEb/Av9r84Qz+YDQqDgU1IT1
	zgLW+BcVkoQ6/YNVwQUqBVgazuUiox1i7LUQGZN0PPJW7bpr/6SXw0IOC7qvD7rqk9MoVd
	+7VtqfU1VmhYEbh2fFwUH3hpJ8+yoMg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O7YnXLuC;
	spf=pass (imf22.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ae3a4a773e1so67162666b.1
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753138823; x=1753743623; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I50g8CBYTAJgx5jeL63ocp0XmC4ojzYZYl9cwyXAxL0=;
        b=O7YnXLuCzi3BzHxHMmRcxWX7eEtTnaeeEIHG9UJXLuzUQc/uYzfFVGEA27vTpMwAaf
         hLpWVqQ9ruBeFYzmfoWtAJKexu087GLlE8tVfJj4Bq3GKZpNqil1euxMd5fyfQCaptDV
         6+ktCX6gUQ5xxIartFA98VMebp23XCNc+22Z2qu/o7fyZGXVILo9S5HzQzSfIXpo/vFS
         wbBU2698uJsTAsSPl7TV4X4+FUCFX+11rZNQQb2I0i+TSLJ2nBCt4PrxDqUSjl1KUOAN
         xgzQ4jV8d78lOPlaxWIwaUtpwQxVI6mpKInz02HiY8YScFXeVPBogu10V1yb2CpKAGNF
         j4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753138823; x=1753743623;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I50g8CBYTAJgx5jeL63ocp0XmC4ojzYZYl9cwyXAxL0=;
        b=vQCsC+OOIQ15MM26tJiQOkG94pFfK3TjyfLnHkpcf1wOC3ezA1+JOAEhMFPijU6NWv
         46w/bNTGWCBUIUnoKGTAPXASTbP4ZLhIxG41EAVuY5lc6pag6XjLS/wejRFwi1jC5bNn
         qIwnZWK+5dkhrDAgT/6xJH58TNqWtzYEDQmU7VkCYLkggJ2VYhwTqJ7L7YgEO/6uI7W6
         6FfS1DOkGk2TFBT+DJVW4xpThrWreOwewR9yO7LlVAMi9CRvUCQfNWQ8P9T0+g1AtFeu
         Bb2CkB0FLcodqx45tQvVl/lV5dynaoXh+x0genRXhHHMMlCnfC1IcEDqaZT0Q69kOyf2
         S2+A==
X-Forwarded-Encrypted: i=1; AJvYcCVcSxUvvjOX6fbQcfdB1vUVtUXU44sq0HqpNiuJFw8WOxqhzpNtW1QZstJBlRkNMJvn3aT8FG4//g==@kvack.org
X-Gm-Message-State: AOJu0Yww7ovr4ARA8iORunnK4/MLsiADgs35rLhU/f4w5tKmFdGyRTVa
	x2nw/sx8l8rHKPWOS82cMCinxwHHnSEWHIBlkP4TyrgpLvdck/ZA379T
X-Gm-Gg: ASbGnctywzYzmrQUqNV8WQxwMiPpdIN73qWGNxSxTI93la7RYp3VPBbZ3GEvd/+6TPh
	bKi8V2rgsLKbPpCSCSyQgT5TeX1soIkb8sNvMAbptTKJEss8rX2Ulxsfax69snJeNA/3x+BmH3o
	ea3lpl3Li8+D6bjOPU2YqOSMKMMXP2paAnNVzfix5aH5KNXLie6RzK//zlRBbJXgcJcqfqmBvnH
	oVVDLN8bpjrFR8373+Px76lFIZjnLcuwdzUvQ3+13JFQHV630BK0txWDbkcYztfN+di2xlTq9JW
	LEPVI33L7D5S8kkV/FOpk16UmVyM/8rkDDoNkqe0hANqdx/cPtrP2tSCsPaGArgHCgJRJsMMQ/y
	WbgeOHobqym/rhQbE0VLph3OkMHEU9D/qyJI3kFdX4URkgOKRy4Afg8sdwhlZn6H7ltrT
X-Google-Smtp-Source: AGHT+IGYzqj0kH8wn480kr3FBbj99pmKP5/Eu4pwQHjyBRT16VOhkTt/2Q3FevKH1201wdR/kcGe2g==
X-Received: by 2002:a17:907:db15:b0:ad8:882e:38a with SMTP id a640c23a62f3a-ae9c9b8e572mr853708966b.14.1753138823178;
        Mon, 21 Jul 2025 16:00:23 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-142-142.dynamic.sbb.rs. [94.189.142.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6c7d8357sm753164466b.52.2025.07.21.16.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 16:00:22 -0700 (PDT)
Message-ID: <85de2e1f-a787-4862-87e4-2681e749cef0@gmail.com>
Date: Tue, 22 Jul 2025 01:00:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/12] kasan/um: select ARCH_DEFER_KASAN and call
 kasan_init_generic
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, hca@linux.ibm.com,
 christophe.leroy@csgroup.eu, andreyknvl@gmail.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org
Cc: glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250717142732.292822-1-snovitoll@gmail.com>
 <20250717142732.292822-9-snovitoll@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250717142732.292822-9-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E31B1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7ooyacps8x6conyyfr8ugwihi5ktse3z
X-HE-Tag: 1753138824-803525
X-HE-Meta: U2FsdGVkX18lB29Ld+NWqkCJu81GSyU5EXhxLXfzbx2hpeJ4T1PfALTI7DBKZftUePoXZzGVL+41T8ws6afrnBk4uN5IMbspPw5iFuTqbJhMZfnGrPRB33ynZFgC+p7T1lBoYfwRbcKKzPDxknVIZ2PIbHKLKj6gKQoUu/TBe9VppPgtVA3ZR1ug54b5CCcU73um2dAlY0n3FrXHNejTaLP3glAjZUj9PIzIW1JepMsc7i0JdxCWwu8RH2X+oBz/Iq+Uz9smXCcLYuqgayInpaW5cVwlm4+liMFED9yOYyyO3MsHaPiOWGoQYu2L187Kimk8H1UR/HiRp1iFtERkJHt9H2J78+npzJzU5zKEiSq1Yno5XSBvLqGIVt0E4hkCxEZ1w8wJNaT8YpCGA8mzW/1j6Pxx88pgNH7dsGvqcMKrw0Glx9HFxFbE+CBfnsA00mAoc7fg1pnxwkh4urSa87YH6AUm1miz6KsifKxXiEBXvk6I0xPzrQzpgYq9OtmawXh73QSOurWdUxqlxVtYyL8zU/2fGYMUWGN2AsCJ3S08a4ujilLPMXil6mRoqkl0nQT64IkiakwVGrUuLFGkl0keVO4UmIpgUDIzo7R5jlkGDsN6vDO26PVNWmzk82KXd0yWN0awK9/Hw/4+0fCm7r3bDj9b5k6/JEkv5r9+dnMocAWP+mo7twoAlp2bt+mnlDPCpxtH5h7T+ifupZz1S8pGY7CqXwBn9W/a5Jcm6up3FisVqfpPelmbOMTE6yAEhXy7rUTXIwVEAIzP0pQFKr3a6JR1N6+flfkG5HHymifZFHOaqwbAH5L4W37wrzdwx/9gA4nYpkRYdKovvZW0Fk8aeGRi8NQZiw7y7mv8UsbSeYrAVxHFxvfCqINTHU2ygloV4HkOyztbFI+5Ykf4RBpXcmJarWLdai2NRWO1JyjqR6LUYeiUER7BrQvEtXVvL6T728vMUyL9tZ9hbmp
 TgvjhC1B
 s89q4bZd/4/7QVC/u6Yj8NR3ZZdfqALhZA4ME+NxKoDzM+uydAQGjNJ9vXB5agfKPV69IC3SIZ16BlWUKeX3UkoW/NBoaKjkQwz+hztFgyC5jKGAH68pUi76/yXF3fX2vmv9rf5/WNG7smnlh7NPL0YwRBR5XC+abB7IOoutn7Pxd6d1KB4K66pXqaRg8DKhAbeBWZQThXNU1uXYHWi/XaNkjr4ve8TOXJV41B3OP5YGgdn5HtI0Br+OMSawqwnuJ+epsd48NDwH5piNh9ghlGQqNRZASW3sxLRGX9E5MXl6AQt/O364jUqc1CShAGdNtRA9jzA1yZFoww8OpTYVVZ4so8qfTLn+uvkT5MsZKzzjfcoIWEBky8C0GlgOs+Ah6wkKRB5rypv7QNFajp664vsjcW27VfIrbvBKe2iuDLrzCbXjm28b6PN/xfvcUoqh3osH3MJabM0g9R1zi8pnL1ejdOUtvFlqIgaRRNE6KTqPdJHxQJWTPnux2x5WT3Y8dX8arqmqHjyh/2XFBmiVRbeRXBj+RoWQBkOQ2JcMll9QRxeZH1fDQabC0qQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:
> UserMode Linux needs deferred KASAN initialization as it has a custom
> kasan_arch_is_ready() implementation that tracks shadow memory readiness
> via the kasan_um_is_ready flag.
> 
> Select ARCH_DEFER_KASAN to enable the unified static key mechanism
> for runtime KASAN control. Call kasan_init_generic() which handles
> Generic KASAN initialization and enables the static key.
> 
> Delete the key kasan_um_is_ready in favor of the unified kasan_enabled()
> interface.
> 
> Note that kasan_init_generic has __init macro, which is called by
> kasan_init() which is not marked with __init in arch/um code.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
> Changes in v3:
> - Added CONFIG_ARCH_DEFER_KASAN selection for proper runtime control
> ---
>  arch/um/Kconfig             | 1 +
>  arch/um/include/asm/kasan.h | 5 -----
>  arch/um/kernel/mem.c        | 4 ++--
>  3 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/um/Kconfig b/arch/um/Kconfig
> index f08e8a7fac9..fd6d78bba52 100644
> --- a/arch/um/Kconfig
> +++ b/arch/um/Kconfig
> @@ -8,6 +8,7 @@ config UML
>  	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
>  	select ARCH_HAS_CPU_FINALIZE_INIT
>  	select ARCH_HAS_FORTIFY_SOURCE
> +	select ARCH_DEFER_KASAN
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_STRNCPY_FROM_USER
> diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
> index f97bb1f7b85..81bcdc0f962 100644
> --- a/arch/um/include/asm/kasan.h
> +++ b/arch/um/include/asm/kasan.h
> @@ -24,11 +24,6 @@
>  
>  #ifdef CONFIG_KASAN
>  void kasan_init(void);
> -extern int kasan_um_is_ready;
> -
> -#ifdef CONFIG_STATIC_LINK
> -#define kasan_arch_is_ready() (kasan_um_is_ready)
> -#endif
>  #else
>  static inline void kasan_init(void) { }
>  #endif /* CONFIG_KASAN */
> diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
> index 76bec7de81b..058cb70e330 100644
> --- a/arch/um/kernel/mem.c
> +++ b/arch/um/kernel/mem.c
> @@ -21,9 +21,9 @@
>  #include <os.h>
>  #include <um_malloc.h>
>  #include <linux/sched/task.h>
> +#include <linux/kasan.h>
>  
>  #ifdef CONFIG_KASAN
> -int kasan_um_is_ready;
>  void kasan_init(void)
>  {
>  	/*
> @@ -32,7 +32,7 @@ void kasan_init(void)
>  	 */
>  	kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
>  	init_task.kasan_depth = 0;
> -	kasan_um_is_ready = true;
> +	kasan_init_generic();

I think this runs before jump_label_init(), and static keys shouldn't be switched before that.>  }
>  
>  static void (*kasan_init_ptr)(void)


