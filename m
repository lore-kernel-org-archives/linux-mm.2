Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14581D4662F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3ED6B0005; Thu, 15 Jan 2026 17:42:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABCA6B008C; Thu, 15 Jan 2026 17:42:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA4D6B0092; Thu, 15 Jan 2026 17:42:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 569726B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:42:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E405C1F16
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:42:55 +0000 (UTC)
X-FDA: 84335674710.17.D42D153
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A42F120002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:42:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mlJXDlVs;
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768516973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQuagjPxslA3/GbLy8OgugPdFRJI5tMwgAjobUXXgeg=;
	b=iiFPZ4QFXd2hnnXVj/nQSZQx3qTMtJCRYAZAO5S9RMDr+7kngSYHBcxVi5j/RcwjzglKfa
	P2jyy6HEjBsFRUJy/PR18jfFXH4ooMUJqsiQ1QXLZ9mB3cKPZA1Z6bAZyqjNxcdpRVAc8z
	M6R97ig0G9rr/1ZRGWmvc3QqYpuRcLU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mlJXDlVs;
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768516973; a=rsa-sha256;
	cv=none;
	b=1/89qbTXS3fOK9BCckWsjeqq/LCz7Y0kB+RBw9daHZW6wcBdfNeMF4or0Nm72y1okUjQMQ
	fdQceq7JoyOMOre8uf0Eb0uDDV1mPBdgsnhKVlHp+K+x6xKNPKt2BmEOmGd3C8zy1L8D7A
	ulFMHq5lly3Oxr+p87DElsRaTuLje7A=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59b89e1cf34so230940e87.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768516971; x=1769121771; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vQuagjPxslA3/GbLy8OgugPdFRJI5tMwgAjobUXXgeg=;
        b=mlJXDlVsnZSr/UC6ywWlWn4S/9yodO1AodK3vOTCLs6WnajDquXGc3FpEZbQ+aR21r
         M0GHkpe+xiKCbBr9zBIZj9oqN9yjzZh5TXSKNMfOCGkE5BLsSIe0C/JTpBkpeFphM5zB
         ULETjSTYocu4iUPYlYAIA+Wf/dVQsbpwAQOdeJpP8jjxRbvcmIMn+qE7qHTP3/Z91C6Q
         bnpHoewOn9GYhgFg4xx2g7aJ6HIyISC5qa0f0KdajozR06cEbGjq/TLuvdR/B8ixfCDy
         bj0KnSJVT4UCPRzo/XxU7uU03LrekHFRxU49GOl7xSgXbfSvHmFTOprDNk1cjfC/XdLt
         TDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768516971; x=1769121771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vQuagjPxslA3/GbLy8OgugPdFRJI5tMwgAjobUXXgeg=;
        b=QC4yrqHPo+6CJZWisUuBOcbs04pqBHfs1MjFA24G3YlNe5cGBHMbpg+yDDfNoLUebI
         GtRNudSia0lTBlQXthhcVIki0O/oY1kuj2YM/tUfD6ba5iqfV2/oYPYo3wMekNOWKr1f
         4o1KvJCXeBq62Lch0WRkXJ8ouousLF7hh5TE59qj2mj94UGqc3S8nxNP2H+J9gGOXK3s
         uvEITOC2ie92XQwLniWHMC3Kg7MBfZQ768O+Bs4Y1qOBNBpCyq3GQ+mTnleRx9HrbKqN
         NMz/rnFguNuU6d9rkCLOACa+Q99JDf+gz/2DqfhCGw+y4H7CGyyz3HEpgRtM/U97y/uU
         cRHA==
X-Forwarded-Encrypted: i=1; AJvYcCVNm7KaILQED/J4lNJ5M3JR9vOSYwSVYKRPx8hdmCz0cOHDyF0o0o5qRiVbGrgEQsCsZXaSMTLBtg==@kvack.org
X-Gm-Message-State: AOJu0Yy1l7/4omPPvhBqEfuT4WeCacVIxCnUo98CtEz+0lyyGN0bkF7H
	uhMvpYVda9e4CtQs1bVqfQ4Te5xpWLsaoRPdQjO1Z+F5hRraa1bOdYWM
X-Gm-Gg: AY/fxX5jt3+WaEjPq11VfXV3ik48zwNQVrENfp2unlGvnbECdbOafPWUL1PxtBS+btX
	Edisq+1jKSZmtmLNsVDfN4UJyzZyOwjLCaBJguhmUHNZbKl28B6jThslwQrN0UI5w7lWtPXdQ5R
	4vQv0nZMuhP+H03sUws03CkQfjPltvNgiOnuUV7oSFf6S1J1EYnyVbWxtlAh1rEp8/BhHlyX3HE
	bpkBRioL/WkvPtRbJI6M0OXfTza5jTqODjEA7U0EuC9eWrLKIy0++B7Oif0XMVS1jC+sEtrlpRy
	IcVy7hLj980fCoww0Gj5KtB5ovbrE25Qs1OJrnznS1ZUik0Q7oIHAGHoHI6kG8bN21LuUPjLWmP
	dLpfrL8f4+Qq4p87BJWz8vqlNJnaFxoIeBArPK7E75rSofmOR5lcaW46qCDPjCMBavzEMH1NsG2
	zN7ijB9N5jJBHxQohBo2Q=
X-Received: by 2002:a05:6512:63d1:20b0:59b:7be4:8c40 with SMTP id 2adb3069b0e04-59baef130e4mr131958e87.8.1768516970797;
        Thu, 15 Jan 2026 14:42:50 -0800 (PST)
Received: from [192.168.0.18] ([87.116.178.235])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf35434bsm209044e87.45.2026.01.15.14.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 14:42:50 -0800 (PST)
Message-ID: <2592f303-05f5-4646-b59f-38cb7549834e@gmail.com>
Date: Thu, 15 Jan 2026 23:42:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 01/14] kasan: sw_tags: Use arithmetic shift for shadow
 computation
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, llvm@lists.linux.dev
References: <cover.1768233085.git.m.wieczorretman@pm.me>
 <4f31939d55d886f21c91272398fe43a32ea36b3f.1768233085.git.m.wieczorretman@pm.me>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <4f31939d55d886f21c91272398fe43a32ea36b3f.1768233085.git.m.wieczorretman@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w17udziwyo6e9fn3ts8r5oyp7i9acf1q
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A42F120002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768516972-968829
X-HE-Meta: U2FsdGVkX19EeJIlQR4jqUF1k0eY0JLqiCVv9OpalNHJ/XRLQQcEzOzd9Gz9nnut/FsVV+vnCbXtLa0vDq/Dt65nBkQ7SKQp/6T1xrholJwiTfuoy2ynRQvOgceTka6LvM80/5ZRw0+HUQssgYPuRfrMXqlfyI2q4Wf9nk/GdNQmw9wphOkmspJXdETY6Fn1sPAiPdnRE/4ZmQSDKwJwh1iI2juThcPG+c4V4++Dt8fJ62d6DMf29GZsjpmilWKJO0fWj1+Ao6HiU6Wwli3XGGU3iEaGHEIm2vYMJao9/royFl4GJQ5Hn/2CeL3FcQzzZTT4+NSxXleugKOjZe47JcZ3X/s5qVz6nzVfFW8rx9UaOlI2GC21/AozDkEsn7pU2K+ZkrO9OQue5av+dKDfbL6NzxIRa1OlcjWv7j9Ng44vqUAke463JXCI7Uo992d8HyG1neYuP7eJQKnI2olgICYC0l6XcFarDOkEyHJV37+mW/PusBcBFSKdTueWZwGAmzOJn6kFziuD+Pf/Ase+kxh81Hvht6CRDIk9VAoap2hqfazAAfFbGM8V4caxQyhPrGmPxGjFmJKpRM0yZ6VkeAA8fT2fO5FLYrXf3UxWWffP0qE1Unn2pnYb+8HLjUgmh+6te0GKQaAtZmxKVBmw//YrY30daBID6EwLyn0UpVVOAiijfJpzVD1TUpQAGmQLKdz02BI0UpyHQ/69A0TNVcFgpfWBw9qI0BpUzm418HAIiTdTRmFiR91yRtOy4bwihUZfiSp7jaSc26hg4HlqSo0Xl4VpgIVm7i6A5+Jfefh8psDANMvPpvvaXiavDf9czDTXMiqnHTD/2K2w94Coh5jFx2UDZKyPaP51mskX6o02gauB8pT5qKn5R7zDaun63CaWh9c1FC7QpQcvJHTMiQ02FXRxO3dyfGR2na7N1lYvaa/lUZL1YZZdJOrZMQzuIBi1nwv3lO3W4SdkKxO
 Pum75IU3
 PbqCbWTif0nUhBYVE2YYdZMN41JUjo+mPNokI/SawZPAin2/ddq2dC/FzpRVJsOmV+gvnBuw7rL5um4lh1/uwAYFkNfn1wjqvLIt+oH9K3LIZNbxXMuP5a3tKov540f4Vz6rAgBKCvBiU2bceXqrFZNX4vHj8Zuqe5yWk6yZA1KuJGqoiCBgBy14OceZjauTs3Flsn2bSIwofrZKs8T3uE50uxq5/USjWhwayHfkQfDead78tvy+G0beHvtFRM8fbKiZKvd3s/Y5FOVP+tcq4wrrvwrQ5Z+F8Q9Apv9KNXLPn5ttsiArkPtVtq/10832w1Z6HhrGfhS/Ow4uIADdJzY9fr//53t+IrkR6KHJtFFVDqRUzLI9pN53LO4tEr12RMBx+F5+UNPzX1mVViHrPn9YBTw6/pleWNnWtuDhOzEdIauii3rE6kLq/OwcBWgDjawu/jRMhKbCcdp7nASH/LSuSdZhUVV8AnYrgr6kQkmCNBJLAytyGRjkyfyFFHoUI6auwsTztTqbtJMZvJTmOFqZ92NMDK60KhMLzeQNZWxFJjuwb/LCJ6Z858wJVAyAbt0MmqkJfBylFypnRXJJwtWoESw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/12/26 6:27 PM, Maciej Wieczor-Retman wrote:
  
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 62c01b4527eb..b5beb1b10bd2 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -642,11 +642,39 @@ void kasan_non_canonical_hook(unsigned long addr)
>  	const char *bug_type;
>  
>  	/*
> -	 * All addresses that came as a result of the memory-to-shadow mapping
> -	 * (even for bogus pointers) must be >= KASAN_SHADOW_OFFSET.
> +	 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shift
> +	 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (on
> +	 * both x86 and arm64). Thus, the possible shadow addresses (even for
> +	 * bogus pointers) belong to a single contiguous region that is the
> +	 * result of kasan_mem_to_shadow() applied to the whole address space.
>  	 */
> -	if (addr < KASAN_SHADOW_OFFSET)
> -		return;
> +	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
> +		if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
> +		    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
> +			return;
> +	}
> +
> +	/*
> +	 * For Software Tag-Based KASAN, kasan_mem_to_shadow() uses the
> +	 * arithmetic shift. Normally, this would make checking for a possible
> +	 * shadow address complicated, as the shadow address computation
> +	 * operation would overflow only for some memory addresses. However, due
> +	 * to the chosen KASAN_SHADOW_OFFSET values and the fact the
> +	 * kasan_mem_to_shadow() only operates on pointers with the tag reset,
> +	 * the overflow always happens.
> +	 *
> +	 * For arm64, the top byte of the pointer gets reset to 0xFF. Thus, the
> +	 * possible shadow addresses belong to a region that is the result of
> +	 * kasan_mem_to_shadow() applied to the memory range
> +	 * [0xFF000000000000, 0xFFFFFFFFFFFFFFFF]. Despite the overflow, the
                  ^ Missing couple 00 here

> +	 * resulting possible shadow region is contiguous, as the overflow
> +	 * happens for both 0xFF000000000000 and 0xFFFFFFFFFFFFFFFF.
                                  ^ same as above

> +	 */
> +	if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) && IS_ENABLED(CONFIG_ARM64)) {
> +		if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0xFFULL << 56)) ||

This will not work for inline mode because compiler uses logical shift.
Consider NULL-ptr derefernce. Compiler will calculate shadow address for 0 as:
      (((0x0 | 0xffULL) << 56) >> 4)+0xffff800000000000ULL = 0x0fef8000....0
Which is less than ((0xFF00...00LL) >> 4) +  0xffff800000000000ULL = 0xffff800...0
So we will bail out here.
Perhaps we could do addr |= 0xFFLL to fix this

> +		    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
> +			return;
> +	}
>  
>  	orig_addr = (unsigned long)kasan_shadow_to_mem((void *)addr);
>  

