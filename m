Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1EF4CA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 00:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02EA66B030C; Tue, 26 Aug 2025 20:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21F66B030D; Tue, 26 Aug 2025 20:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10546B030E; Tue, 26 Aug 2025 20:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD5926B030C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:46:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89C01B9404
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:46:23 +0000 (UTC)
X-FDA: 83820696246.05.002E04E
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id A9C2E20002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:46:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=YMHByVIj;
	spf=pass (imf13.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756255581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zclw1iBD4zpqjkUTKL/tBf6jKpfLRB4Ld2/pw8/YSMc=;
	b=px8sAv/ssogJMKYgsnl3LpBUm8JsUU7Z/vEfaadk/0ypQ9ji8n2AYbfdjNQOoVcA8pWqKV
	BGG6wDkpgqwOMSwvbg5A2w+Yz2RnOAFl5Og51Yucrc9SYdozqFZIv0M4C0IrSLcSHyG5gd
	ocJjhMaynAtkSCqG5j/zQ94olXGwzPo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=YMHByVIj;
	spf=pass (imf13.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756255581; a=rsa-sha256;
	cv=none;
	b=eqwom1BC3KSaKpL+UBCZbHc4Owo2GOtyOMRX8Xanh8eRfePsS9jh8YRAqhLojAXLvnEZJ5
	6UI7BhiAXl838LO9QDZWs5nQ3WPV1puKczjv0ipSWizJzywyBQmjXP0zrWmPuUf/ulFsKk
	jtNEtonno9Lv31UwBgTiQ9fe35QAqZQ=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3ec3b5f05e8so16058925ab.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1756255581; x=1756860381; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zclw1iBD4zpqjkUTKL/tBf6jKpfLRB4Ld2/pw8/YSMc=;
        b=YMHByVIjPe/mKB6dZPIg4wn8g31IOMCkppJPVxX1Mx48y0ZQ4JquUi1ablR9IGw0wF
         LWJAN275CqXJwDNmBB6ZPmsromaT5KaeURiemM2FltVjUr+wh3tXywartD8LcGHtbZkG
         UggTs/aIGmiITcCSRSzGsAc5qJYRldv4n0851u3XjazXvKKyZp/dcJuNdzOlVYUjRIS2
         pGpeN0QiWybbepGJj4K/sZiblDDJ6tDjuL+onl6BV8ZN66yglaDV1owERE3HbIp5rZGC
         HvpdCS3KRABCrFhPnvUQWUYqX/sg6gV33F5CHD+q6tIhljgxPZffbfVfEHTWNDpMaic3
         BSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756255581; x=1756860381;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zclw1iBD4zpqjkUTKL/tBf6jKpfLRB4Ld2/pw8/YSMc=;
        b=nJk5HjMI4a53gKOvB6C+dica8z3eMpRK4A4EoaJ7VaRquUtYu70/6WopBpkfcghbqq
         IthD/CLxCiFo7MpwV4AYFSaK4Ax3XVmqyJrTAeCm2MXrbRgFXoye91JppZuDTBmFjy69
         llnTIawUKtpvg9BBoT3eCKu7wVLJE0M3opbCcsuaxhyeK0EajI81D+AMdRzvM6HIY7am
         4JMMNDsJyV5j9pzsz9Tq0hg5HQKFAKSdga/HYHWLpBs+VPsHGDb4UP1V/Aa59GPmHsLI
         NYPxCw6Msh/JntyDQtMsDmJHMBH4oBo43C6kXxVainnBO1MtsFEr0dgPhFSiSC3JXRX7
         K8tQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl3+hPDdxHRmdMPPGrI0YO3AEL8XfHzb+JYVKv3/2nulGOuj0fmmRcpfVUQiSutcPCHhN2eiJVNw==@kvack.org
X-Gm-Message-State: AOJu0YwUM5hmNdY/fwDqPxEpz6d3e5FY+JXBUvug6IOmhqdd9hx0nqIh
	MBKZRaWKHn20sWVPWZpnoJnQ/2zxsANLgWVRjEXH/T7Hui80mH/FFGt8obOXvVEqm6Y=
X-Gm-Gg: ASbGnctCWX/nk23sl6fWs6IGN30YoLap4aLePp+byl5EIXyxMseav7KRqOSaN8sDbZR
	vrotg9nChYpBUreMj0rQM6tpEbGUd7AmfvvKdJ1/dppS6bZ2FK6iCYv+BMUShwCG8GO0egLcjAQ
	lJ2KAxNTEN0u2LMirp5Ar9LnwsvBBZSagZ32kpOghwvYA2t0TEI/Yyu8s9B0hrApSBMN3UB8MfG
	3I2DhsIGkE6uaVHgTuKcovvvy7RKQZVsas/9D70VRm+dbR4DMmk2VMB/Dm9pX9406/OUHCAa6NE
	EB5TesmmnYifxouO3VbMIeUfkXLcww19O+6vUizmNKrnhEzZRCLva8XzmUepuuxsskzt43sMN7s
	HKFIZCmHaQ8h9phiLLV3nryuiAIyCkLj9++M8kg==
X-Google-Smtp-Source: AGHT+IGfh2W97xdVpFCgiQyq3Pb9/ifBsTlwqyh1OAHr3R34PnfYQnj+aQ8bMShNsAl8EpMrNrhaMQ==
X-Received: by 2002:a05:6e02:1b0c:b0:3ef:1b56:c8ea with SMTP id e9e14a558f8ab-3ef1b56c9f9mr43866025ab.11.1756255580619;
        Tue, 26 Aug 2025 17:46:20 -0700 (PDT)
Received: from [100.64.0.1] ([170.85.11.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ef2ff2dd60sm14606295ab.9.2025.08.26.17.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 17:46:20 -0700 (PDT)
Message-ID: <2e9ee035-9a1d-4a7b-b380-6ea1985eb7be@sifive.com>
Date: Tue, 26 Aug 2025 19:46:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/19] x86: LAM compatible non-canonical definition
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
 llvm@lists.linux.dev, linux-kbuild@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
 <c68330de-c076-45be-beac-147286f2b628@intel.com>
 <4rkxgsa5zfrvjqtii7cxocdk6g2qel3hif4hcpeboos2exndoe@hp7bok5o2inx>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <4rkxgsa5zfrvjqtii7cxocdk6g2qel3hif4hcpeboos2exndoe@hp7bok5o2inx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9C2E20002
X-Stat-Signature: nebxx3zpbbydt3y3kas8wxwjsd8fsjci
X-Rspam-User: 
X-HE-Tag: 1756255581-599038
X-HE-Meta: U2FsdGVkX1+jk+Pp4EhPX7wHP7BJSyivBezIA/oqzcQJx+sTpWDuazQz3BB9yeEupca2h0hIVBwFzM8yuYbcfzyA/JCiSR77IUZuhl6gJBIGcEnsySxOMeh5XvIYSPhP5xnCZYQRgNnRtQu3GE32heMZCWinbsoGd1H/CZDBgqrUja3awe+lw95kfQYtNWFTPywXy2cBHt6yp5aJnlaxHjhYY9w4JYICY9nZD7lYZQtVsXPs3vCV7lEiDC1dYWwS3MaiKPF9RnqV/For7cnhtU+BJ1q+X32qPCpKLpC2Z6kEKRZTRhkhNrDgFvyzjEdLRPR24MAf/RCtczXnTI6z9WoV3Cyhdn/VRrkbHFWtLL5cO0oo5kXNQbSaTggWgdBB5M1SZhytkSar29zXu06KlzjRjg9EL2a4Jofqu7nPX1HfcJqLyVW2YJG34y2m7Q8Kt5TB+ymy0W42qfOtMi1nlGoJ9qr158cnk+IhtBQtjvAM1sOuyARCthmAep1HjmQnBopMfuPYCeL3LjTtmro8qUXk3s8KenWfTdpdqzv83Go6vJHlTl+DMrEdZ5EoJe6dwyIoCPo2qb4pw/qhhST/h+VXebEzNPurPgNfFTHUXSsgCE1khhCs7yMmLi0F7TQlwv5g92q/BeHKZgWgKdTbBco6ld3kHGrAUQHof0Ji1d7RjNM5OkeKLXLaCTinLiMuI2vtiI/7jnNrtADWO1ZNO1lUbGCvm15pbqPuVYdky+CcfBjw821B0Fx+NjT6/mWSrfhdHBQRswDd6fuNFzVElxXCFhzHcao7SDS69nZvGCsneg6pvZcvq8SCTmFSsLPYsXzUb3tqcTcFVnx6am1pSsxiYtHGjzaAYTCXfMRh3xPyDZAjE+/Au689FCNzeJ23c0whkg5cW9PJs+qaA+TnwNQYyAyVLemjyEXPvN29Sw1o2u6xuRKEyz8LYky8+p5wlxF9OejTrrFoYqnRRRD
 Q70nMbQi
 Hjm41Hd0WM4F2XP/Cvk1PfGSZGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maciej,

On 2025-08-26 3:08 AM, Maciej Wieczor-Retman wrote:
> On 2025-08-25 at 14:36:35 -0700, Dave Hansen wrote:
>> On 8/25/25 13:24, Maciej Wieczor-Retman wrote:
>>> +/*
>>> + * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
>>> + */
>>> +#ifdef CONFIG_KASAN_SW_TAGS
>>> +static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>>> +{
>>> +	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
>>> +}
>>> +#else
>>>  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>>>  {
>>>  	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
>>>  }
>>> +#endif
>>
>> This is the kind of thing that's bound to break. Could we distill it
>> down to something simpler, perhaps?
>>
>> In the end, the canonical enforcement mask is the thing that's changing.
>> So perhaps it should be all common code except for the mask definition:
>>
>> #ifdef CONFIG_KASAN_SW_TAGS
>> #define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL(vaddr_bits-1))
>> #else
>> #define CANONICAL_MASK(vaddr_bits) GENMASK_UL(63, vaddr_bits)
>> #endif
>>
>> (modulo off-by-one bugs ;)
>>
>> Then the canonical check itself becomes something like:
>>
>> 	unsigned long cmask = CANONICAL_MASK(vaddr_bits);
>> 	return (vaddr & mask) == mask;
>>
>> That, to me, is the most straightforward way to do it.
> 
> Thanks, I'll try something like this. I will also have to investigate what
> Samuel brought up that KVM possibly wants to pass user addresses to this
> function as well.
> 
>>
>> I don't see it addressed in the cover letter, but what happens when a
>> CONFIG_KASAN_SW_TAGS=y kernel is booted on non-LAM hardware?
> 
> That's a good point, I need to add it to the cover letter. On non-LAM hardware
> the kernel just doesn't boot. Disabling KASAN in runtime on unsupported hardware
> isn't that difficult in outline mode, but I'm not sure it can work in inline
> mode (where checks into shadow memory are just pasted into code by the
> compiler).

On RISC-V at least, I was able to run inline mode with missing hardware support.
The shadow memory is still allocated, so the inline tag checks do not fault. And
with a patch to make kasan_enabled() return false[1], all pointers remain
canonical (they match the MatchAllTag), so the inline tag checks all succeed.

[1]:
https://lore.kernel.org/linux-riscv/20241022015913.3524425-3-samuel.holland@sifive.com/

Regards,
Samuel

> Since for now there is no compiler support for the inline mode anyway, I'll try to
> disable KASAN on non-LAM hardware in runtime.
> 


