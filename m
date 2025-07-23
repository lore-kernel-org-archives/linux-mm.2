Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDE0C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 17:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70EDA6B0150; Wed, 23 Jul 2025 13:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFC16B0151; Wed, 23 Jul 2025 13:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5BA6B0152; Wed, 23 Jul 2025 13:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECE96B0150
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:11:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0365DB5A3F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:11:28 +0000 (UTC)
X-FDA: 83696170698.03.B0F75AE
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id D998D1C0017
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:11:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UHYpJlv4;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753290687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0LUnIOIz73OOlhKmDgw5NN8XNp7rSGUS+XkRlIQ8F4=;
	b=Ah5XSCqRHbwz8Xtz81yXZTTpmv6Gn/hvGbrUaCpwjnNoT8TB7/hY4LNKymYAFrY8P5BgCH
	3DtN4t88BtCpBhcJYkJ1TPcG4K5luahsSXn2Y3J2DiS6gKTQbj9CccUCKiBTcwqfIGfcIz
	lLDIldNjI+Ac6cpSUBYC06BQtSypKi4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753290687; a=rsa-sha256;
	cv=none;
	b=4aBsVMHI7j/HNYx1RwTYBJK9hDmsZly3ps5OknJhq0evjP0860efyhq0PCW/OAQNaJS1x9
	vNhxEZf4FZc81CZ0OocP7mNqGz7Q/gTDf1rvSGLbLPuveknndUXdT1TiIPZJoGvDKqhsJX
	Bft4OhRtMWkhggl+Q3jlwkp1YlloIA0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UHYpJlv4;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-32b4eb13e8cso51311fa.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753290685; x=1753895485; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h0LUnIOIz73OOlhKmDgw5NN8XNp7rSGUS+XkRlIQ8F4=;
        b=UHYpJlv4llSG7E3rbtcqdbeOHlNs1oBphYNuc5I3LVRWr2DLAGLQO0Wa7jXLSbsMKB
         YCPkIAckbm59mULF6z2QU9mAOh2XbYimlCIb2AihgGbCN2FvrfTgEpxvOkj5VaEWCRWy
         fIHiDdXd/BPVmRvuQPaoGs54sCNHfXGtqTQBu/zKwlxG+1Rso2g13kW/1J1M8nnXaSZR
         aSJMa4q4IV4qClDocZBtCsk9JyewPx69HzgnonAegf2HZ8YTong1rxeyMC6d93DDJpxf
         GD9lqhMVantXcdKe6wjvovfLvVc3TmqCrKe6x1SclK5sJy0BCVx9Mr5mIdckcMMvgyTP
         Rg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753290685; x=1753895485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0LUnIOIz73OOlhKmDgw5NN8XNp7rSGUS+XkRlIQ8F4=;
        b=qhLmfyMwyA/SVxWQ6QZ6yRp/T4CzXyZa3NNaIrDW16MtgPFbeFbOyJ7XuIVPFv57Tk
         RtO9XGjTM3jLXOpbktkqaFvZcsdEIUpJaksuofKZSkOgmJXPDeN0sKzIVUKrPfqywNuW
         52N0OR82rzfrfsSTfxuKVBv0y34/AeAIORhq7Lm+qZvH5uEtvsrLWLutKyrsmk9rqikH
         g15a4gp5yfsEq1R+U4frh3BRNi8hqGGtijAoJ0TzwsvBeo4K7s5x34YlWSLf+gz/WIqM
         oCZ1ybq401q2x4Rpf+Vwh8zWFB6VCr6X5AKGCUqdp3MTllh0ClQHdT4bEMMR2Nr5gyXr
         IkPA==
X-Forwarded-Encrypted: i=1; AJvYcCViYivK7g3dRAURr0hMnyW+I+/gpFZ6zIgKchlkWY9o4rAEl/v3FNwYQkf/469NBUrIg3wqgi+pCg==@kvack.org
X-Gm-Message-State: AOJu0YymmLMROJtGZ9ew6I3vQRdlgYih1TskA8ZX79I35arxb1mIHB4x
	gOwNtIBesTz6pQHUXooobZFvsxoTKXL5bkFr23ygTyit/ttBAzAoTPM7
X-Gm-Gg: ASbGncvZ38vXdrqjhVG6iUHw14laf0rsIb4X+HydD2SPRyktex8AFyU56L61CBw7MHB
	Lsk5D8EP4slfOHI39Vgn/NMp7WKop0ceUvv75eDfwF1NHgl6cx9HDLYGKsVw/HL1ZgWiD6rupd+
	AGGeXugnx023Mx7JlcC6+P/Akskli8zcL8nZBKPzr2ZCuz0aJMdQwhDZeUM9VNGuBtqQZB5zf8P
	5grYPP1D7Jo2TKv81uGoJxlC4mGxiwuG0SkO+yQqU5htsAI2Yw5LiJFsxmIiF8q21dhhVZ9Eblf
	AeYJdKS/kULWl6M/wScMKvxuARfO+Z4BMsGyBubXeChS0O3McWwKLcTdT7ZC8yC2CzBDZTdlTQ9
	SSqKMI4QvI7kTuHqSx/oFor1ZlTML
X-Google-Smtp-Source: AGHT+IH2g67FKl5Ss4FX0QBC4tL2LXDPhFaEQPcQJWbHc0FwMHy9whqZBWSEtQi4JTvV5r53QIeSPA==
X-Received: by 2002:a05:651c:f19:b0:32d:fd8c:7e76 with SMTP id 38308e7fff4ca-330dfd2d969mr3521411fa.7.1753290684563;
        Wed, 23 Jul 2025 10:11:24 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-330a91d9eaasm19869811fa.85.2025.07.23.10.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 10:11:23 -0700 (PDT)
Message-ID: <4dd38293-4307-474f-8eb7-0e83f5d3b996@gmail.com>
Date: Wed, 23 Jul 2025 19:10:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/12] kasan/um: select ARCH_DEFER_KASAN and call
 kasan_init_generic
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com,
 agordeev@linux.ibm.com, akpm@linux-foundation.org, glider@google.com,
 dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250717142732.292822-1-snovitoll@gmail.com>
 <20250717142732.292822-9-snovitoll@gmail.com>
 <85de2e1f-a787-4862-87e4-2681e749cef0@gmail.com>
 <CACzwLxiD98BLmEmPhkJQgv297bP_7qw+Vm_icFhTiDYN7WvLjw@mail.gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <CACzwLxiD98BLmEmPhkJQgv297bP_7qw+Vm_icFhTiDYN7WvLjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D998D1C0017
X-Stat-Signature: 99rwd4mfdign3ph7nhwifho5r8x81mbc
X-Rspam-User: 
X-HE-Tag: 1753290686-750116
X-HE-Meta: U2FsdGVkX19RGtpH3u2fIPBBPUbZdG84NnZarDBTUkQO7BbbjnRaKTPiBtGvZugaH0xr3jZFFcvw5e3a6ez+dsyMMuOk/f0VL2ydIwJ1G0+QTEaxQ9m6apLYPfpsfLr36DcUSTacKEX6LXJMp5b/MivwcnX9n2lZMzuOXrB0qM6zZ3eLnVedkExaNcI8uKBh+LB7YCV4FLLebEfpqXSA28ph+L9k1glwtw2dUSxNe19ptzdn12/9XtE4gdPt1ZuJuOJ3U1mXTNRwUpmDepSH3sjrBigVozkvA2+KGphDCnx8dUnLk+UBHeik3lJRozAyoI0VJ5ZxoiIe1RxVz4Z6u26mC6g9U77o5LnmT2CBBO32YqgBUZUUdoVn9tWu1gmPrbO9h9eRhdetnsHBOvYfTlRiMzSBzVyspTN4WXDRp6JoGhjc0BO8wg1tfJyCNEE70h7Gn2fAaSLhgqxr6edsv+o/etPjSC265OPYc+U/jj5qTEadV+vdu7psgm+BReNax7A0t/EEHM/HkVKU+SlwBQEP7xsC3nk8i9sJxFDMoNf6CUCk8hxpDaMYUDL3bs7z/IWLHjQwU9B7ssQvS7ehKVpSKaCaOC1zpxL27tTzl84XVQWEdkG9GaZghmZafMw4c3jYQq1GAh0YJlcOCWHv9OC6rsUQtMCMEiPsz5SVC0YnYFPOqVQEZ4sKUf646hNJe3ssnRBGP0fGRA3eFqh22v8CM9TaB/Vc4WZAf9BBlsdBekacwyOOAsHMO8+1qPN4LoWJ/a7i+2NJxrdIad+f7HXIHye9MrLs5iHt/SP9ISa6s1rlqSdS5OXI0FiIyrsVluLXTYwCI5z82gaN5OP+/SyBxZiKTyTnyUvhmItuG3lDBiaB5+c62jAKog0KJNBtD5Ha7qH/CenD4JQXOcDMitrW/OcZbOlX4cG5RA1Wx4xQxeAK6/dH88ChHkraHg4GkIR03OPrAjXk6lw66rx
 cI/2mfGs
 PPG+rbR2iN5hMppaS9Xx+9luOGJ97H6OC1+lOhc2prSWHi4OMg4HeOqr7YlUAmlNiQpX8LQdU2hvP7pveFg0ukPRgLiG7y+GWYv24HFNMeaeHjfPQ4AtJxX9PolyABKnEUwZ7pl6NiBcaLzn3csy+TRcgCMvZI0HmCiQDm52p405pxI02SkIUJOsQMUMyZymGO2i3iOcHBDR1HBZaLKGPjW0Vq6gdfpqbMucUSKSzx+TixAWxHHHWvtNUDL8kRY1eWAB54k8ZiCrBzI/oIJj66+kr2JzYB7w3y0spIgoqVum7QnnueBFacNWZj2225z4WpAUlenId29zGeo6MUjOs7Qaat9jhNN34NJO0Hqu9GRadnZwccoIa/TpoMPszE/ZB2eO8Azt0gSUCZCJKvUoZ6JTo1mHh3tR3tK2DcqI3JV5YiSF35bYdltk8z+watNlKgyPXo9Bu8KXcfVnd20uMbHlUL+0gTC+utoJiFDPbgRF5Lnc2b0SE/Jrdl7m93HU5QztypYYcLE8p7/h5FrZy7jLfWBxmO3n0WrNGADXCkYPeklaFOvTUf8oVtnFsSQyFoeWVbrnUkl0Lg6Q6D0W7+43N9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/22/25 4:17 PM, Sabyrzhan Tasbolatov wrote:
> On Tue, Jul 22, 2025 at 4:00 AM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>
>>
>>
>> On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:
>>> UserMode Linux needs deferred KASAN initialization as it has a custom
>>> kasan_arch_is_ready() implementation that tracks shadow memory readiness
>>> via the kasan_um_is_ready flag.
>>>
>>> Select ARCH_DEFER_KASAN to enable the unified static key mechanism
>>> for runtime KASAN control. Call kasan_init_generic() which handles
>>> Generic KASAN initialization and enables the static key.
>>>
>>> Delete the key kasan_um_is_ready in favor of the unified kasan_enabled()
>>> interface.
>>>
>>> Note that kasan_init_generic has __init macro, which is called by
>>> kasan_init() which is not marked with __init in arch/um code.
>>>
>>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
>>> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
>>> ---
>>> Changes in v3:
>>> - Added CONFIG_ARCH_DEFER_KASAN selection for proper runtime control
>>> ---
>>>  arch/um/Kconfig             | 1 +
>>>  arch/um/include/asm/kasan.h | 5 -----
>>>  arch/um/kernel/mem.c        | 4 ++--
>>>  3 files changed, 3 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/um/Kconfig b/arch/um/Kconfig
>>> index f08e8a7fac9..fd6d78bba52 100644
>>> --- a/arch/um/Kconfig
>>> +++ b/arch/um/Kconfig
>>> @@ -8,6 +8,7 @@ config UML
>>>       select ARCH_WANTS_DYNAMIC_TASK_STRUCT
>>>       select ARCH_HAS_CPU_FINALIZE_INIT
>>>       select ARCH_HAS_FORTIFY_SOURCE
>>> +     select ARCH_DEFER_KASAN
>>>       select ARCH_HAS_GCOV_PROFILE_ALL
>>>       select ARCH_HAS_KCOV
>>>       select ARCH_HAS_STRNCPY_FROM_USER
>>> diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
>>> index f97bb1f7b85..81bcdc0f962 100644
>>> --- a/arch/um/include/asm/kasan.h
>>> +++ b/arch/um/include/asm/kasan.h
>>> @@ -24,11 +24,6 @@
>>>
>>>  #ifdef CONFIG_KASAN
>>>  void kasan_init(void);
>>> -extern int kasan_um_is_ready;
>>> -
>>> -#ifdef CONFIG_STATIC_LINK
>>> -#define kasan_arch_is_ready() (kasan_um_is_ready)
>>> -#endif
>>>  #else
>>>  static inline void kasan_init(void) { }
>>>  #endif /* CONFIG_KASAN */
>>> diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
>>> index 76bec7de81b..058cb70e330 100644
>>> --- a/arch/um/kernel/mem.c
>>> +++ b/arch/um/kernel/mem.c
>>> @@ -21,9 +21,9 @@
>>>  #include <os.h>
>>>  #include <um_malloc.h>
>>>  #include <linux/sched/task.h>
>>> +#include <linux/kasan.h>
>>>
>>>  #ifdef CONFIG_KASAN
>>> -int kasan_um_is_ready;
>>>  void kasan_init(void)
>>>  {
>>>       /*
>>> @@ -32,7 +32,7 @@ void kasan_init(void)
>>>        */
>>>       kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
>>>       init_task.kasan_depth = 0;
>>> -     kasan_um_is_ready = true;
>>> +     kasan_init_generic();
>>
>> I think this runs before jump_label_init(), and static keys shouldn't be switched before that.>  }
> 
> I got the warning in my local compilation and from kernel CI [1].
> 
> arch/um places kasan_init() in own `.kasan_init` section, while
> kasan_init_generic() is called from __init.

No, kasan_init() is in text section as the warning says. It's kasan_init_ptr in .kasan_init.
Adding __init to kasan_init() should fix the warning.


> Could you suggest a way how I can verify the functions call order?
> 

By code inspection? or run uder gdb.

kasan_init() is initialization routine called before main().
jump_label_init() called from start_kernel()<-start_kernel_proc()<-... main()

> I need to familiarize myself with how to run arch/um locally 

It's as simple as:
ARCH=um  make 
./linux rootfstype=hostfs ro init=/bin/bash


