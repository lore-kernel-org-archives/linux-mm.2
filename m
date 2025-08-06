Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B174C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01286B00A3; Wed,  6 Aug 2025 15:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8CD6B00A4; Wed,  6 Aug 2025 15:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEDB6B00A5; Wed,  6 Aug 2025 15:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D03F86B00A3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:52:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EDB2B7A41
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:52:02 +0000 (UTC)
X-FDA: 83747378484.10.C390B24
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7DC28180008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:52:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RGzw6bx8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754509920; a=rsa-sha256;
	cv=none;
	b=CaNWMk++X4CovA9UnwJDJPfXrD9okoBotbmbAP39XxOW/Bh1NHfjpbE00iT7A63shisq+t
	NU4ct8hCsb7saNER7tsTOXm9BjJDNFQeOVWUpexmrYzXTgiM64dVpgFsuUZdTsEB6CaMQI
	NKNXAXyOvnu2u1xPmwoL/Fo0kjPAg8g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RGzw6bx8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754509920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOJUufvksrkNMkhUfUMzFksoWwIudiaNrjydPYTPe/E=;
	b=oWhjJPapzy8gd6L2hd2yTscL2UBO+o9+yUmaXkkOxAIEISZwxeRbR9QY4kiIaaz/DmEGGK
	IfvWPYIrJnH9YanoJa1vWrmuVAQLT/3JTc6FUx5m9XdsEGNyF642yyrZaXhCA5MGeT75CY
	39WSzmZg+5TOG4UHcOwqpuyuqvxUG2U=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7e684d49270so1372585a.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 12:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754509919; x=1755114719; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jOJUufvksrkNMkhUfUMzFksoWwIudiaNrjydPYTPe/E=;
        b=RGzw6bx8O4gGUBn2DiWBBZFGQgiaX1bwjQDx+2bwCtvQHsWZVvc3zyN2ecIGj2sCEc
         LP3xovtkkXRxWe/OHOztUcGKGb2i/YEOKtzPvoaBWexY+TPVpiuXuxBv/natynh/xM8v
         xlH5FXVK8MbqFvlPk/51DCcOG6hHDnRS41uMbi3oRemHqiJU5KNnF5ZmluRvuxsEt3T6
         cH8K4xwxz/eGOG8FDQwVEEdNfDSOoF5S85MWMdIxKgfzX59R41bMGPs4ewFQ3su20Us/
         Kko10/mM+lTPml3YCfbUnibSMDo7xsn8M3s5DXGAUIQceRjKEpBKyT3Qh9rnzUDpIoRo
         glmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754509919; x=1755114719;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jOJUufvksrkNMkhUfUMzFksoWwIudiaNrjydPYTPe/E=;
        b=EWM3kOoFB54egY1cNRmcDH1bM8StrL24weSFyu03vhO4IoYSufkUmp37pnv0gJsIQL
         gvOS+JFNTOhv6Y2jApevE84V0aM1U6IARTcWdm3wSo4R/xMUIur+/MvtZIFISzjujEMd
         XihEtlTtmPsunYo8kgfHQuwGizqSsqa+vMoNEmfSwK3i/GHLT8ZukczR5XgNuw83vuJu
         v3OssQV/Nv5UfoGpnnM5lPTC1FflJCZVaMw02GDD1z5Qe1ZpFFYp0LarVkVs1plH+kvx
         1nXYJUzTJhhGs9tgfAOimpXRjFFReNFYJaTQWdAm40MWIh6ZJMlQ0yiReeQg9EUCVBE3
         YKKg==
X-Forwarded-Encrypted: i=1; AJvYcCWvJ5NzK1Pr8fBpQhsRv2DpYhgWU9gLD7+nmxKJn6nFTviMdpUW9X6KRpO4ThVA02fTo0L+c/q9Tw==@kvack.org
X-Gm-Message-State: AOJu0Yz7wncjlwjMRCO878ru3HBZ/fUlIhoMizLoyKahoqmtF5gTZEx7
	xvn3Tep/mjVNyMbUcUAHV/AMKs/0aV6xP2gx6Lg8ZqtEmP+xg6ieSTGU
X-Gm-Gg: ASbGncsF99ygv93a+9e+FE8jWj6dK1G5H8UPq92Y9Mtn9ERRYArK49D8MYd75IcraEo
	d3GVkNKCTEw9QSbwuWoo34G8fC0izkBtBBc1aA7xDWY1tsZ192MyMUU4Rth36mRh1I3IG+w92HW
	b5SwGOHea+JlU+BV1E8DD7fEpKlZM1symKraw7eH8EQ4+Icb4WVjzgXFCFdN+4+eAMYPH/DmPNY
	TI8TyT+M6pDaOzeSJF2EjLAh+/LreH9DeL056aWU4CZBIv6PNIV4xBecqM7iJCJq3Qo5YGb7iiV
	eFyyPknXfW5XL6p6Ae3VTz+7nDXVdZtvijngzGALOmoxNP/ZYitvVwITyfpSGr0ON8uLPcM26+F
	WStBjDLJ21CIZsFSKyux0aigPbJVU0ysROFrMwwnBsitCt1du5ZXIOZMlu+8AZZGr6ZFW
X-Google-Smtp-Source: AGHT+IFmzUMSDyUQoeXjvqgYHBfr+pQThJ0xtd5NGlSxIHAVfwgMAAXU9ZJsjUzM039DpZsjSBydog==
X-Received: by 2002:a05:620a:1a04:b0:7e2:6be2:38eb with SMTP id af79cd13be357-7e814d64573mr316228785a.4.1754509919359;
        Wed, 06 Aug 2025 12:51:59 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-140-132.dynamic.sbb.rs. [94.189.140.132])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5c55a2sm866617085a.36.2025.08.06.12.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 12:51:58 -0700 (PDT)
Message-ID: <dd25cb14-5df1-4b2c-bff7-0ca901dfd824@gmail.com>
Date: Wed, 6 Aug 2025 21:51:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com,
 agordeev@linux.ibm.com, akpm@linux-foundation.org, zhangqing@loongson.cn,
 chenhuacai@loongson.cn, trishalfonso@google.com, davidgow@google.com,
 glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250805142622.560992-1-snovitoll@gmail.com>
 <20250805142622.560992-2-snovitoll@gmail.com>
 <5a73e633-a374-47f2-a1e1-680e24d9f260@gmail.com>
 <CACzwLxg=zC-82sY6f-z0VOnmbpN2E8tQxe7RyOnynpbJEFP+NA@mail.gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <CACzwLxg=zC-82sY6f-z0VOnmbpN2E8tQxe7RyOnynpbJEFP+NA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DC28180008
X-Stat-Signature: fyjbhden3ayd9rmmq4hbzhjzr51fiyr9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754509920-366518
X-HE-Meta: U2FsdGVkX1/H8siN/mACQRwmxvrhEVHi5hDz+NCzGjqGHGLuiLdLWEA1mJefYKxU7JLW/4um+979Tn4e6MwKnLFx0SRw6cc4xKwMs9GgwramZwzSdrOIXXyN4rGie1K0v6v+sGECDl91YL9CCnKkiJbFxX088IFnOFljXIO5IxvuoRLjSV9IDwU/hx+kiqHrdNktZDmCfecFI7CdMnVm24Qv1XMj4uNP6qRFXTIT4FwNHNwv/wqUquIg9Iqkt+WmjQnXBq15ZCFdzJ78i5/F9kxTmjG7gbvugr98VUDO7LEp9gefBBt+fCufQOwKdRmqCRMK1QqEPkyrkMCvg6b7r2nYTtNKDAEV3Nw1V+O4q2bOlEu8F9QTrvLflHi+vvjUez6MwKl+z/Mv/bEGQY8xLAvncoh2mmoQX4HYqJn/MXvGHfWCrKPg7fvj9TAdXiEAxOIAahMMlTM+3anZTGoUOYQR4eXWVce8hzcrX/12gB3zSSJcrfI7X9eBv7tsS4tTDuf5XbPtkIn1ue1N1H2BMC6vLE4HXP/xfUhz3RfIfLsuPEY8B28URBhaEhYVnC4sr6DzsjL9c+PBQ9I8jtsV6HlTn6XokL+zW4l6rIec1fEy8B7gSFVbqxpr3JpY0ew0x/98nAhcQIAjcfYXqIPidvAWyB+/caz9qiV+LT3ZqOJBLSdlI0R8948A0EI16TqaqGzcJ4PS3aqWy8eisGPd+7ThtWoF7evQh5PfZCq1L2nLAqGXo3qHS9aAor5DxGk9pMoIEkeu/13TVhBVuetea7qWg2HVai46cRvbh9Stiu7HobjmIxG+tbZzmf7tFbyMOnRswA8rrBR+ZZVXbKl1dodbxXWoMDkewsfRYj8Pwtqz/PNd/oFw4VQX3qbg9uMRzQEsuLSriZhyY2N78iaXHHB+mP5p5616Wwhf9eADaf3p1kfjUpp9Y2m0+YtgLAndXp2V7r3cBzIIjcJKfIT
 bVfHdm+d
 bAIf7ANfqDBTN2sRHvEQwCWvfIDh3Beds/R5Xhw33nr7Xd72Q19DoCzXOy4mWbWmIuMtfbaua6rvq2zp1m68MU2zh3yuzv5lVVZ2cfp4ssZdprMT/N90pin0PEkEyxqwjF/vyjCtgLybCZzgi3nBX85oVJl3ckcU1mQooCKKXVcUUirZejDdwEs2MTpsIXTQU2K2L3thYG9I3nQLtFpKtc9V37SnE/cPbhHDYlu+E4W9sDhP7/L0vmiy7fYu2M9hmMubW9EtckXQywXp7TMFzzMrS480wOGKwtXbINTGvyxMZ84dVMQhJEaXByvqvpKGp1XkdNQyMaJlnrI3XskQ2VIK7jf2Ka8pylRVY3SGxSJSG6QWQnewxYzR3umuVX2uyePsP7rCWBn8dPomhyrk9T6ScOWYyGI6CcddnBFilSdGNog7cwwhrybKszVfY0Yxns4Djvwp8sBT4HXCNIRp0sRsPUPGpUAoENUIGleYIIT5Xr6Plho0FwvhwTRZRXFQI+8X7SZipJLrymOi73uUjcvLw+bn6MZLxKMm6FQdyNM0ojUw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/25 4:15 PM, Sabyrzhan Tasbolatov wrote:
> On Wed, Aug 6, 2025 at 6:35 PM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>
>>
>>
>> On 8/5/25 4:26 PM, Sabyrzhan Tasbolatov wrote:
>>> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures that need
>>> to defer KASAN initialization until shadow memory is properly set up,
>>> and unify the static key infrastructure across all KASAN modes.
>>>
>>> Some architectures (like PowerPC with radix MMU) need to set up their
>>> shadow memory mappings before KASAN can be safely enabled, while others
>>> (like s390, x86, arm) can enable KASAN much earlier or even from the
>>> beginning.
>>>
>>> Historically, the runtime static key kasan_flag_enabled existed only for
>>> CONFIG_KASAN_HW_TAGS mode. Generic and SW_TAGS modes either relied on
>>> architecture-specific kasan_arch_is_ready() implementations or evaluated
>>> KASAN checks unconditionally, leading to code duplication.
>>>
>>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
>>> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
>>> ---
>>> Changes in v4:
>>> - Fixed HW_TAGS static key functionality (was broken in v3)
>>
>> I don't think it fixed. Before you patch kasan_enabled() esentially
>> worked like this:
>>
>>  if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))
>>         return static_branch_likely(&kasan_flag_enabled);
>>  else
>>         return IS_ENABLED(CONFIG_KASAN);
>>
>> Now it's just IS_ENABLED(CONFIG_KASAN);
> 
> In v4 it is:
> 
>         #if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
>         static __always_inline bool kasan_shadow_initialized(void)
>         {
>                 return static_branch_likely(&kasan_flag_enabled);
>         }
>         #else
>         static __always_inline bool kasan_shadow_initialized(void)
>         {
>                 return kasan_enabled(); // which is IS_ENABLED(CONFIG_KASAN);
>         }
>         #endif
> 
> So for HW_TAGS, KASAN is enabled in kasan_init_hw_tags().

You are referring to  kasan_shadow_initialized(), but I was talking about kasan_enabled() specifically.
E.g. your patch changes behavior for kasan_init_slab_obj() which doesn't use kasan_shadow_initialized()
 (in the case of HW_TAGS=y && kasan_flag_enabled = false) :

static __always_inline void * __must_check kasan_init_slab_obj(
                                struct kmem_cache *cache, const void *object)
{
        if (kasan_enabled())
                return __kasan_init_slab_obj(cache, object);
        return (void *)object;
}



>>> +#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
>>> +/*
>>> + * Global runtime flag for KASAN modes that need runtime control.
>>> + * Used by ARCH_DEFER_KASAN architectures and HW_TAGS mode.
>>> + */
>>>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>>>
>>> -static __always_inline bool kasan_enabled(void)
>>> +/*
>>> + * Runtime control for shadow memory initialization or HW_TAGS mode.
>>> + * Uses static key for architectures that need deferred KASAN or HW_TAGS.
>>> + */
>>> +static __always_inline bool kasan_shadow_initialized(void)
>>
>> Don't rename it, just leave as is - kasan_enabled().
>> It's better name, shorter and you don't need to convert call sites, so
>> there is less chance of mistakes due to unchanged kasan_enabled() -> kasan_shadow_initialized().
> 
> I actually had the only check "kasan_enabled()" in v2, but went to
> double check approach in v3
> after this comment:
> https://lore.kernel.org/all/CA+fCnZcGyTECP15VMSPh+duLmxNe=ApHfOnbAY3NqtFHZvceZw@mail.gmail.com/

AFAIU the comment suggest that we need two checks/flags, one in kasan_enabled() which checks
whether kasan was enabled via cmdline (currently only for HW_TAGS)
 and one in kasan_arch_is_ready()(or kasan_shadow_initialized()) which checks if arch initialized KASAN.
And this not what v3/v4 does. v4 basically  have one check, just under different name. 

Separate checks might be needed if we have code paths that need 'kasan_arch_is_ready() && !kasan_enabled()'
and vise versa '!kasan_arch_is_ready() && kasan_enabled()'.

From the top of my head, I can't say if we have such cases.

> 
> Ok, we will have the **only** check kasan_enabled() then in
> kasan-enabled.h which
> 
>         #if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
>         static __always_inline bool kasan_enabled(void)
>         {
>                 return static_branch_likely(&kasan_flag_enabled);
>         }
>         #else
>         static inline bool kasan_enabled(void)
>         {
>                 return IS_ENABLED(CONFIG_KASAN);
>         }
> 
> And will remove kasan_arch_is_ready (current kasan_shadow_initialized in v4).
> 
> So it is the single place to check if KASAN is enabled for all arch
> and internal KASAN code.
> Same behavior is in the current mainline code but only for HW_TAGS.
> 
> Is this correct?
> 

Yep, that's what I meant.

>>
>>
>>>  {
>>>       return static_branch_likely(&kasan_flag_enabled);
>>>  }
>>>
>>> -static inline bool kasan_hw_tags_enabled(void)
>>> +static inline void kasan_enable(void)
>>> +{
>>> +     static_branch_enable(&kasan_flag_enabled);
>>> +}
>>> +#else
>>> +/* For architectures that can enable KASAN early, use compile-time check. */
>>> +static __always_inline bool kasan_shadow_initialized(void)
>>>  {
>>>       return kasan_enabled();
>>>  }
>>>
>>
>> ...
>>
>>>
>>>  void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
>>> -int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
>>> -void kasan_release_vmalloc(unsigned long start, unsigned long end,
>>> +
>>> +int __kasan_populate_vmalloc(unsigned long addr, unsigned long size);
>>> +static inline int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
>>> +{
>>> +     if (!kasan_shadow_initialized())
>>> +             return 0;
>>
>>
>> What's the point of moving these checks to header?
>> Leave it in C, it's easier to grep and navigate code this way.
> 
> Andrey Konovalov had comments [1] to avoid checks in C
> by moving them to headers under __wrappers.
> 
> : 1. Avoid spraying kasan_arch_is_ready() throughout the KASAN
> : implementation and move these checks into include/linux/kasan.h (and
> : add __wrappers when required).
> 
> [1] https://lore.kernel.org/all/CA+fCnZcGyTECP15VMSPh+duLmxNe=ApHfOnbAY3NqtFHZvceZw@mail.gmail.com/
> 

I think Andrey K. meant cases when we have multiple implementations of one function for each mode.
In such case it makes sense to merge multiple kasan_arch_is_ready() checks into one in the header.
But in case like with kasan_populate_vmalloc() we have only one implementation so I don't see any
value in adding wrapper/moving to header. 

>>
>>
>>> +     return __kasan_populate_vmalloc(addr, size);
>>> +}
>>> +
>>> +void __kasan_release_vmalloc(unsigned long start, unsigned long end,
>>>                          unsigned long free_region_start,
>>>                          unsigned long free_region_end,
>>>                          unsigned long flags);
>>> +static inline void kasan_release_vmalloc(unsigned long start,
>>> +                        unsigned long end,
>>> +                        unsigned long free_region_start,
>>> +                        unsigned long free_region_end,
>>> +                        unsigned long flags)
>>> +{
>>> +     if (kasan_shadow_initialized())
>>> +             __kasan_release_vmalloc(start, end, free_region_start,
>>> +                        free_region_end, flags);
>>> +}
>>>
>>
>> ...> @@ -250,7 +259,7 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
>>>  bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
>>>                               unsigned long ip)
>>>  {
>>> -     if (!kasan_arch_is_ready() || is_kfence_address(object))
>>> +     if (is_kfence_address(object))
>>>               return false;
>>>       return check_slab_allocation(cache, object, ip);
>>>  }
>>> @@ -258,7 +267,7 @@ bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
>>>  bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
>>>                      bool still_accessible)
>>>  {
>>> -     if (!kasan_arch_is_ready() || is_kfence_address(object))
>>> +     if (is_kfence_address(object))
>>>               return false;
>>>
>>>       poison_slab_object(cache, object, init, still_accessible);
>>> @@ -282,9 +291,6 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
>>>
>>>  static inline bool check_page_allocation(void *ptr, unsigned long ip)
>>>  {
>>> -     if (!kasan_arch_is_ready())
>>> -             return false;
>>> -
>>
>>
>> Well, you can't do this yet, because no arch using ARCH_DEFER_KASAN yet, so this breaks
>> bisectability.
>> Leave it, and remove with separate patch only when there are no users left.
> 
> Will do in v5 at the end of patch series.
> 
>>
>>>       if (ptr != page_address(virt_to_head_page(ptr))) {
>>>               kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
>>>               return true;
>>> @@ -511,7 +517,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
>>>               return true;
>>>       }
>>>
>>> -     if (is_kfence_address(ptr) || !kasan_arch_is_ready())
>>> +     if (is_kfence_address(ptr))
>>>               return true;
>>>
>>>       slab = folio_slab(folio);
>>
>>


