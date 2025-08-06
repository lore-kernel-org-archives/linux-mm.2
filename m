Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6405EC87FDA
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 13:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069568E0002; Wed,  6 Aug 2025 09:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040C56B0092; Wed,  6 Aug 2025 09:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFBF8E0002; Wed,  6 Aug 2025 09:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC4A56B008A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:50:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A2971362F6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:50:14 +0000 (UTC)
X-FDA: 83746466748.20.DF14931
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 78D6FA0013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:50:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSaQsTMY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754488212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDOCIZR6gSwH1CTXkpwwYCK6HLPl+F0ICSkVzqPXsh0=;
	b=M90fUoEByDGpDXjsOrX1GwPgOcqSal4E2gA9GW8zh0T6OF/+ybtPd6P0qd5B9qm0Q/htw4
	cRSYpVLQLgNThitnkuT8FkjtrdsEH6R1Yvzpbe8woew/HeQkCLfZ0p92Dmiu6K8D95Uee1
	VfR5XGgN1KKOuee+kswkjVbWBI4sJOw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754488212; a=rsa-sha256;
	cv=none;
	b=d4h+dIhI7brSK1KAFHd6fn5M9lTUxPrNpUP60DCXhFJ1v/OiOueMu5TW+21oPdIPxLIGNM
	XLUt+diWo3tmlePYmT82JOJWCzlXb/5BaVvoXcydCRX2qg9fqukD7BLgL5D0as+xStQ/WE
	muQLkmYvHwdfQokPU86UvVwedJRGwcE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSaQsTMY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-332341d99dbso11550041fa.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 06:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754488210; x=1755093010; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pDOCIZR6gSwH1CTXkpwwYCK6HLPl+F0ICSkVzqPXsh0=;
        b=TSaQsTMYPCLovvhtJ/M8AZ5JhFA1DmpVzgTC4RiOtDvxQTsrC7mkG0omnWG17dZIKE
         E0H78gNTp4vpqs5r4PKReW8JRtAPKQOpU0apcB5zuqhVTa669E6dOayvh9KtM7FpzWsM
         LWTkQDS/oBGoxFYa5k3R6MvCH/YvNR4QYski9/7GOsS+32ivpKSRU8Q5iWEFZ1afsgDA
         Uq5vZdLnAB48Fbq6n5Yr6llM0zhHygvo274aDYy9RuFpjynRYXKj1StFfpCTYsmZilMf
         +K4gVh4qelptToGy8hzzXSIta+tRW+kNMRA8mysiGTgXZ5OXFTYS73nileMn1KivRw35
         XRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754488210; x=1755093010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDOCIZR6gSwH1CTXkpwwYCK6HLPl+F0ICSkVzqPXsh0=;
        b=nOuA91wEhB1enTrnLOlyZCCst8yTpt5HUfBf1wzsRhte2frr1vZikuvhRO4I9lAZpD
         gljqp5dako931xwjcMfXtkC0AcY7QOdSKs9mpyiiX33M3ALvwZtiBVAEsszhIBqIZArx
         1ZnxbDXnkVY9FOYdx654ex2l3Y6BCFPHbFC9f/ZKkGzKRvcIyxTLjjmbS3Uus+9vicWN
         rC1hKtWgwsHfkSdyvXz6tDg0V6ZpypvLmliUwGCe+o4Z27xnyYcjT4vOyu9dGktxPQFp
         9CQYluSprlW9TsY0At7/iRqNyRhX0sVDca+RJUF4E168xYXZ+1k6yxext3+VJ+e26eXc
         ozIw==
X-Forwarded-Encrypted: i=1; AJvYcCV4LAia0IEmZ0u4rj7VHGnhbV2TuGJ4vYuuI0viwGQb4rDJkCz+/Q7cP8DVMjPVkqcH1qMQbwGkXw==@kvack.org
X-Gm-Message-State: AOJu0YzMERM2hNzlanQ77K7F1uekOlEiFh/9GXhEoIVTbKrC1hMJlYZk
	tcxXuduIvjRyat5lPw7mWBP4UXMVoxi97eQ2MctU5bt2WGjQoz9fss8H
X-Gm-Gg: ASbGnctxUbd0GE/zUpQvkS+dqrVV7qKpuYVdI0auyA3fxbqiyb3US8M3M9t+sA9m0hh
	fD2u2B82mmQ/cu7dQYu+XlyZVU0zKRviVd6s8EZXN4IY008SMKBhD71kMJ/2ORzd3rwSVilIcOq
	JtvWJiMUFgjam6a96Jz6DLApf+FOsPDb6cUk4PWVSlf/56tFwPMGsqO9SlRhAJzpXf+M1PG1mau
	JV4eb4t/Bbqd/Iby9mkpYqTu1vpKDVpSu/mg2LaFSh57B9MWnltID3b66w5c4JMq7cCC/5JBj64
	oRjFSXt3017LrZv7HaecUfU8zazIZbX1l99GCX4eUW9amFUSsuK1jHlaCwRdLHhp249pfhZcHZ6
	fSQ1EK6SjT+ZFBTZXaQHXrxhNlxyaMkeNKJ/0WtSWvzSzeDUKoQ==
X-Google-Smtp-Source: AGHT+IEsyaC4e5C8bAXA34DF26BCI2kUm+pbeFPiYngQRQqOaMh9b3JgYLiHo/Ul9EDDlBD4plM96A==
X-Received: by 2002:a05:6512:3b1f:b0:550:ecdf:a7f9 with SMTP id 2adb3069b0e04-55caf35fc1amr414988e87.10.1754488210277;
        Wed, 06 Aug 2025 06:50:10 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88cabbd8sm2356761e87.149.2025.08.06.06.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 06:50:09 -0700 (PDT)
Message-ID: <ece4aab9-a195-47c9-b370-c84f5dcc0098@gmail.com>
Date: Wed, 6 Aug 2025 15:49:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] kasan/um: select ARCH_DEFER_KASAN and call
 kasan_init_generic
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com,
 agordeev@linux.ibm.com, akpm@linux-foundation.org, zhangqing@loongson.cn,
 chenhuacai@loongson.cn, trishalfonso@google.com, davidgow@google.com,
 glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250805142622.560992-1-snovitoll@gmail.com>
 <20250805142622.560992-7-snovitoll@gmail.com>
 <60895f3d-abe2-4fc3-afc3-176a188f06d4@gmail.com>
 <CACzwLxhs+Rt9-q6tKi3Kvu7HpZ2VgZAc4XEXZ4MEB60UbFjDKg@mail.gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <CACzwLxhs+Rt9-q6tKi3Kvu7HpZ2VgZAc4XEXZ4MEB60UbFjDKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 87fpurj4cw8n658kg5r8a8js48xc4oq4
X-Rspamd-Queue-Id: 78D6FA0013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754488212-368665
X-HE-Meta: U2FsdGVkX1/3fWEXn/ZZdP8icjZNKJY95wQHNqDsvSLiuhu1MzegJApVxgSrnQJgOdHIT+qaFOEGoKW40im0/qUUxRKcmu/ggc2ivT9aAeWrcbP1VZnENxzJf5HlmxA2Aa5kPyhyfIkfkx0+t/g2cWfw3yFhE0e5j/1jkMRoQKNgJgvkd/44euDLlP/iwRigXJLybas7o5fFUQaaJtOaMHUswXVrbgqYGwjEVUzUjWSoh9iJm2Ay36lMNmFn0qosSfdhCdTqZrM5wmcTh3PXlDgIVoukoN5Zh1TLUg6OM0SaC9D3TBtZy0viJoCFS29xZaTVs909qR4HcsGJBTKQwenjBX2+eOwCuCmYQDTJ6PYOxatfULsoQ33eyVuFO/GdH53+rkIeTbxoruqJqTYixNZUny0bfa87xrKG36r+IbQZQWFiX60RhCa6L4YX2sSOYbTO1gWJj8MraDT7lrCRMIOLaBB0CkjSTHFObOLLr7QTCf/ASMsgbgKlTpYeKq7VoIbwJaKYYpGdrnVH+Yu4tZaa4uXGKLfVUC+Ni4GlpcnfnMGWmuq2NLwRhrpaN5PFpYskI/vypvQaq3DrzEk2plVoqN1856Vc8SQJB3fkdgnTwQ0t9+F2wn9+4iS3DRrRKVoczUYa9mg61v4cjZYgecARVcybFTyQet8xOxd4dDBHjuV40pur3ydt9K7MLLmqfU1uBoAGkL7ByB0d7BnIJPODSjbxSMRZFgP+gQjFteRkz/BZkmKD0QH7PRgjYOZGs+csSM6957Kt/jKnVXyoygmCE+xXvE1l9nro1iritZ0CEDppF94S0gZtSVYa/6yC0+XSXwNqLP5YWrAD5gSMTo0a5qfGD7olz4Y9K7x3ippilC6FgFQBBtZ7s+QOWqIj+RE4sxBqBB3MObfi/W3/o+PNqOIhaERJ4jlfdCaI50B6IFbvXxloVJGfXRiLNw4UejrK/nxsrvFnMTQUbpo
 Zs6+uh9B
 ZTfxFSAmhxUYJyCzimTLJgmbMQXSUKQNkj7Bv4DHkHp+CNjALRvvkz+TpdvpRAJ96n2UMejODAArH2noKJ2dxer0LJdn8sJRWs4P7v56yglWwH/7qn9jwjzW0VZaULK7Z2Ew34sctPy+2Zi+rB48eqMUX24h05PrhRNLQMaLQgafzbdlLY1L/EEmhVPwMmVFTU8wWSLsR5xY/eR44WnXdhUfxCmMu7zewPxqVKNuWV/+I/JBIlRCp67X9QHjxCEKB0x64wYV1jyM/xEua6usjxroAgNxrt4ReDUVICfEeilhiu9C0XATIffbXQQBVmT4rO87Pp42+tBY7BuyadW/ff1gJ/FmWbiS9r92qp6EW9/XhqB4aYSlehhaCCaofDDL/yUvmgRw+0rRR3StoKLOhb7hoDlpeQNPMvXXeOqVTcZ94f9FdSDcpSVL/HXosjXBmp3axdwZ+5JV3ODhAlBrvWjGP2sEMl4L1Qau/E21Yyza+2rFWgzxtnKqzlmEvBqa2yBos0BS0KANTFk+xBTMYOz4Bu7ejGnc5OZ5s1oanQ5dQ14iGgcIsxBx/3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/25 6:35 AM, Sabyrzhan Tasbolatov wrote:
> On Tue, Aug 5, 2025 at 10:19 PM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>
>>
>>
>> On 8/5/25 4:26 PM, Sabyrzhan Tasbolatov wrote:
>>>
>>> diff --git a/arch/um/Kconfig b/arch/um/Kconfig
>>> index 9083bfdb773..8d14c8fc2cd 100644
>>> --- a/arch/um/Kconfig
>>> +++ b/arch/um/Kconfig
>>> @@ -5,6 +5,7 @@ menu "UML-specific options"
>>>  config UML
>>>       bool
>>>       default y
>>> +     select ARCH_DEFER_KASAN
>>
>> select ARCH_DEFER_KASAN if STATIC_LINK
> 
> As pointed out in commit 5b301409e8bc("UML: add support for KASAN
> under x86_64"),
> 
> : Also note that, while UML supports both KASAN in inline mode
> (CONFIG_KASAN_INLINE)
> : and static linking (CONFIG_STATIC_LINK), it does not support both at
> the same time.
> 
> I've tested that for UML,
> ARCH_DEFER_KASAN works if STATIC_LINK && KASAN_OUTLINE
> ARCH_DEFER_KASAN works if KASAN_INLINE && !STATIC_LINK
> 
> ARCH_DEFER_KASAN if STATIC_LINK, and KASAN_INLINE=y by default from defconfig
> crashes with SEGFAULT here (I didn't understand what it is, I think
> the main() constructors
> is not prepared in UML):
> 
>  ► 0       0x609d6f87 strlen+43
>    1       0x60a20db0 _dl_new_object+48
>    2       0x60a24627 _dl_non_dynamic_init+103
>    3       0x60a25f9a __libc_init_first+42
>    4       0x609eb6b2 __libc_start_main_impl+2434
>    5       0x6004a025 _start+37
> 

No surprise here, kasan_arch_is_ready() or ARCH_DEFER_KASAN doesn't work with KASAN_INLINE=y
This configuration combination (STATIC_LINK + KASAN_INLINE) wasn't possible before:

#ifndef kasan_arch_is_ready
static inline bool kasan_arch_is_ready(void)   { return true; }
#elif !defined(CONFIG_KASAN_GENERIC) || !defined(CONFIG_KASAN_OUTLINE)
#error kasan_arch_is_ready only works in KASAN generic outline mode!
#endif



> Since this is the case only for UML, AFAIU, I don't think we want to change
> conditions in lib/Kconfig.kasan. Shall I leave UML Kconfig as it is? e.g.
> 
> select ARCH_DEFER_KASAN
> 

No, this should have if STATIC_LINK


