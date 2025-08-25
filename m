Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B39CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 09:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB868E000B; Mon, 25 Aug 2025 05:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A36E8E0001; Mon, 25 Aug 2025 05:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9528E000B; Mon, 25 Aug 2025 05:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 293ED8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:46:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D470914033D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:46:22 +0000 (UTC)
X-FDA: 83814799404.18.E43BEA3
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB64C120006
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:46:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="US/l6LPu";
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756115180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vA6vI044zEdIbfha2CiMeRJA/WTffOEZFr4+NNjxx2k=;
	b=EMPJD7dUYVeollN+uPEAfZqP3YhCoTHkx/YUlOoeckw5fFRUcj6VOQZm5p/RA9NVP8iQ7a
	p3a9bB6mhEAxUnvOg2Eaq71leDrV3SdY7qJqP0AvALHYH5IJo860l4T5v3h6FdUF8QqSJU
	mDwniHWF+cCkXc/BqmgJa/RCCs60Bb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756115180; a=rsa-sha256;
	cv=none;
	b=ck/YQZGq7yUQc3KEVGWbeMvpGZ5NBaguR+DZ2+PZguHxIQxhE/hwmDZRihsyACN4gdoYT0
	bnONWWGbJFCVumCqGfoHrlF1FZ19EhzOCvk/Hw9jIVadbktHRATnrBw25UsRBWkbZKu688
	OK/tSsBf/IFSks/DKXmf9sjymcg0gyE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="US/l6LPu";
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3367cd3b7f3so594761fa.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756115179; x=1756719979; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vA6vI044zEdIbfha2CiMeRJA/WTffOEZFr4+NNjxx2k=;
        b=US/l6LPudBoTtTEyDkHQ9f06ag2hy+HLobrTm2k4JVx18QkWGkGd6SugpNwCYf8P+w
         kUA/e00rNCynLdCTSXdTLIGF9m2FF9SbniaO83WGhlvqSaNT14B4UtlBygDgUttdg3BE
         SU3Dsp7G/H550UN9QRJYlhWHoyWHw0dxaizfxAWfTzJLXEUUptCbygRccI9UDcg1QHkm
         uY+lOHbzwU+9QrftzV2HZP0ZM2wBD6vWerPheEH6tjD0UWWyrR8OWnKIyqHkn+uGzfVK
         L0Dk3O5J7ZlK3FQQKx8NLsNTt4eoW/vruWPmJl9nGlN4I7kyteI4Kc1iFjasCvZtP4cL
         wePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756115179; x=1756719979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vA6vI044zEdIbfha2CiMeRJA/WTffOEZFr4+NNjxx2k=;
        b=FWs5L2MVPmEs0DtTY+vfinkVha3OoTvVFVqCwI93U7B3/ybHrN9S0ZK+JZkT3N2AbC
         cQRCMTRP5Vz+x5AmyAWbXPfxGjzUofNKf0WfoBxvH1q4QTXHpoNxiIbEtPpZK1LHm++F
         cLcPAc+mlb1w4nyHMhAKkAmOIPI7f+ngk5vySmDVxH11iM/kGh482TDf2En0g8iMx0CX
         MLWi7IXjjBAuVMQlMXpSfh0q0BFdPecnPyW1SF4EZbTdVay64q2n4MOkQ5U0SOFUOXCO
         p7B0Vb9fCchN2eeKosUn/16LYaNF6hHFgLoYNLUBaSg5GFxxcMnHImVBALRll691Pdkf
         oQAA==
X-Forwarded-Encrypted: i=1; AJvYcCVWl9AFBwpHm6WqKHLkMXhcVcKaOeC1BFOx0qx31yG0fxBoijJuvTXzJPBB6XbZ2MJNI24i2N/YMw==@kvack.org
X-Gm-Message-State: AOJu0YwLY0apfF0lxL0sQf27JnP6Kg1ybxwJgELu8u8jLN4SZLt0VDlI
	HsvJacJhm+/zqyq5YF90zkUIashgUANE7/DNHlSZmrlK8R3sSwBg/8aL
X-Gm-Gg: ASbGnctSbZjAzf5HQro91zs8A8iCaiQaK/Edm6J0+zih3D0s+Vee/PVJidbsTrX4/ho
	R5Zj2Dk+bxr0iDAdGu6X+0H8jNb7/5n8F0jTguwOmrSv/6GU8nl3hHaQNevr5Nm53uYJI6Ey3lg
	5WWSAZ/HZ8+6DTEKE2NGuXs62LCswsIygYIxYBvzLjpUxTekU/vSMzK6yust7ebzdkpaxQXCAp5
	G89CigEQIoqXq8wPUzu0V+Gigqyt2ZpOKqV4hzqnqjO33+sHp6BhU0/E3rxxeio+zAsYu3tw+Ma
	MaRfQy53uCACkW1jXwhOH3KxcjynCrQbq0StNTqiifMF+0CmmOAI31Uq17ivInliEWi4YCbDYpr
	EPN1BFN3BAgSfN3DzLFS9JW+il1ot
X-Google-Smtp-Source: AGHT+IH1efX+K+mAJdmcOpmqJG6368qZBIn8i/p3/9xVotsBIWed+ijE4z8OQ+KPmvT3ummuxgSxVg==
X-Received: by 2002:a05:6512:2527:b0:553:ad91:d400 with SMTP id 2adb3069b0e04-55f0cce52f4mr1975986e87.6.1756115178725;
        Mon, 25 Aug 2025 02:46:18 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f35c12072sm1557498e87.44.2025.08.25.02.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 02:46:17 -0700 (PDT)
Message-ID: <8077d344-580b-431b-b7dc-a84dc4ba6b44@gmail.com>
Date: Mon, 25 Aug 2025 11:46:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix KASAN build error due to p*d_populate_kernel()
To: Dave Hansen <dave.hansen@intel.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, andreyknvl@gmail.com,
 aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 ardb@kernel.org, arnd@arndb.de, bp@alien8.de, cl@gentwo.org,
 dave.hansen@linux.intel.com, david@redhat.com, dennis@kernel.org,
 dev.jain@arm.com, dvyukov@google.com, glider@google.com,
 gwan-gyeong.mun@intel.com, hpa@zyccr.com, jane.chu@oracle.com,
 jgross@suse.de, jhubbard@nvidia.com, joao.m.martins@oracle.com,
 joro@8bytes.org, kas@kernel.org, kevin.brodsky@arm.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 maobibo@loongson.cn, mhocko@suse.com, mingo@redhat.com, osalvador@suse.de,
 peterx@redhat.com, peterz@infradead.org, rppt@kernel.org,
 ryan.roberts@arm.com, stable@vger.kernel.org, surenb@google.com,
 tglx@linutronix.de, thuth@redhat.com, tj@kernel.org, urezki@gmail.com,
 vbabka@suse.cz, vincenzo.frascino@arm.com, x86@kernel.org,
 zhengqi.arch@bytedance.com
References: <20250821093542.37844-1-harry.yoo@oracle.com>
 <20250821115731.137284-1-harry.yoo@oracle.com>
 <3976ef5d-a959-408a-b538-7feba1f0ab7a@intel.com> <aKfDrKBaMc24cNgC@hyeyoo>
 <79027c6f-f2f3-41b2-9ff3-c5576fc06c5c@intel.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <79027c6f-f2f3-41b2-9ff3-c5576fc06c5c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB64C120006
X-Stat-Signature: tjumccc55kcrqw3s86znjkbc61d8q1bz
X-HE-Tag: 1756115180-203586
X-HE-Meta: U2FsdGVkX1/EDW7HnFwZMOdFcRqf29y1ZHRixuVlWjPlHd7XZvNP+9NTGCcqEETCEFInqYtYDhbqT8Iod1MBMqFzA2n162iMExntjnxaJolIgIG1ciINivT/pPnCIRavaWMRo4IJw+FxIM9wzHB4w6lk4z7BOAE07WLh1O5tHbIMQOQkcELnShlY5tgZiEfs4BJfLWDZMmnIAH392JQyBvwrtTIJWgaUF8ZcXnqb+za6c8MFarNkQIDEIPPQi8UCw988/4AxXdnz9puC47Gx1b8XEM2TGSrIxyDic+AhwbRzbse5t4BEK/z/NXVdcoS0zXT/A2Jw5Vbx47jySjQCGMrg9mZeJVc6TdZBSM6sgzZS2TE5U3N/iV/z95/96omeAU110WXzmPG/sQ4GDDOJTbu5iW1rIejPokDpVrnVnkg1zHL3nn06xJgtjmbpLks71Mnkev+TvzIV27UJ3KosbYZ2b6NKgULWNdLpOi6y5GJxkir4xSq2QQ2X4vJsR7j7E8jlIvxsYmbnD5TknpUdm8Ls/x73I26njegTLYq6sD4IBMfEivQ7a7j34n2v+IrHByf/JfGJ6LUb1ErIlfIJJdogsPHDjRD4pAkRYvhG1NwNjuV7wWyDASsPkQmtAAsCyXP0oC8aSasR+pHgKJtENIdX83xMV8FWnAvQZqSRPhPp2tqtcbHz+Ygd4TDO4kyb2rjm/2LKN8YM+IyGFcf+EyYCd+ctFemqTpYse7LuMX6DkEMyVeGNag+TYvIEKri8/WlPonmFrCD0zucec9+KNjcUz06CPYoyKad4nGmNbCCPIWCO7WqVMdThRU1zie3sdJQwHEyFbLznIw9iVSe5HfcPUPpkNlhq5+PUoAoqopyaSqj8RgK/z98/0zJIgJ2tHh9pl8rnEeNdVQmd1N0SYeuB+1gdR29BG2H+bODhYLlxmp42pYXvUyOKXsdDHvGcW4MPrrC5HJy+8i2bIoH
 e2ruK35U
 d+oRf8zn+yi2knFWhh9JI3TqlG6F9cKYjSGc2Rtk3ZnYsaeqjSkhz2B49C6cbeDvTW9ZYZ6PDZLkNTZVZhXFXL/WubQJ3RUoeZw7WV0SkXZj/R+S766WVFjt6Zcxv6VBS5l3T6OLCoDHuivJIBJROLFdKlHCo/mVAFDzHLS7Bo1sfj7eUj3CIXuQN+hpEBLBboNTfBHv0ZVfFdRJjsFnz6NxLLjHzz1HJQP2g7ht+VsMWoZRkzdhA8aQd4Blo1pULq3OTBOWH9ms/XbvteECZiTmH5W0xswyAh1c6CChsPb4G5fzHwcF1eUb9QDuwv5kSQ0MYuzeipbniq0YL1p5U/Xf6HfT3sv6RxLo0X4DE6IooYB28E5nYyRu2SE1ZnkfEMX+bLsjbBSLy1lTqLUbKLN4EKMO28cmsxcsggY0V9k7Xcd8/j2zvmtwnd27lXgQGGAtyJCCYFpZH39DM+ZOby14FNGJ+ZGoGNGosCQ1Yp48kxpT+oH6VBYGAEySqSbzaC54X/9iCnKcEDSx4z/ksus5Uunco0b6J7ysRicM21sr1lE80PPst3oA6EA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/22/25 7:08 PM, Dave Hansen wrote:
> On 8/21/25 18:11, Harry Yoo wrote:
>> On Thu, Aug 21, 2025 at 10:36:12AM -0700, Dave Hansen wrote:
>>> On 8/21/25 04:57, Harry Yoo wrote:
>>>> However, {pgd,p4d}_populate_kernel() is defined as a function regardless
>>>> of the number of page table levels, so the compiler may not optimize
>>>> them away. In this case, the following linker error occurs:
>>
>> Hi, thanks for taking a look, Dave!
>>
>> First of all, this is a fix-up patch of a mm-hotfixes patch series that
>> fixes a bug (I should have explained that in the changelog) [1].
>>
>> [1] https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@oracle.com
>>
>> I think we can continue discussing it and perhaps do that as part of
>> a follow-up series, because the current patch series need to be backported
>> to -stable and your suggestion to improve existing code doesn't require
>> -stable backports.
>>
>> Does that sound fine?
>>
>>> This part of the changelog confused me. I think it's focusing on the
>>> wrong thing.
>>>
>>> The code that's triggering this is literally:
>>>
>>>>                         pgd_populate(&init_mm, pgd,
>>>>                                         lm_alias(kasan_early_shadow_p4d));
>>>
>>> It sure _looks_ like it's unconditionally referencing the
>>> 'kasan_early_shadow_p4d' symbol. I think it's wrong to hide that with
>>> macro magic and just assume that the macros won't reference it.
>>>
>>> If a symbol isn't being defined, it shouldn't be referenced in C code.:q
>>
>> A fair point, and that's what KASAN code has been doing for years.
>>
>>> The right way to do it is to have an #ifdef in a header that avoids
>>> compiling in the reference to the symbol.
>>
>> You mean defining some wrapper functions for p*d_populate_kernel() in
>> KASAN with different implementations based on ifdeffery?
> 
> That would work.
> 
> So would something like:
> 
> #if CONFIG_PGTABLE_LEVELS >= 4
> extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
> #else
> #define kasan_early_shadow_p4d NULL
> #endif
> 

This won't work. It will fix the linker error, but will introduce runtime bug instead:

lm_alias(kasan_early_shadow_p4d) -> __va(__phys_addr_symbol(NULL))

On arm64:

phys_addr_t __phys_addr_symbol(unsigned long x)
	VIRTUAL_BUG_ON(x < (unsigned long) KERNEL_START ||
		       x > (unsigned long) KERNEL_END);

And NULL is < KERNEL_START.

Since __phys_addr_symbol() isn't pure or const,  compiler has no right to eliminate such
call even though the return value is unused.


