Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E5ACCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48D48E0030; Thu, 16 Oct 2025 16:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C203A8E0002; Thu, 16 Oct 2025 16:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36378E0030; Thu, 16 Oct 2025 16:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A01098E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:26:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 383201A0384
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:26:54 +0000 (UTC)
X-FDA: 84005111148.19.77340A3
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2144C1C000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:26:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gy6fehJ4;
	spf=pass (imf18.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760646412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bo5Pb4pEnCN8Qp9wO+FXoUs/VjBU1u60no/MUECaFf8=;
	b=23f+Pie0RmpqugGhwB3rLJnGJtHGfan5F9UOYFEkDF0j4xoCcFGq6YntoB+OoXy9jZ+5Sl
	i4WcN6RoLy2lSlmxw2rh+EezhFNCY39v4pivzXc9kpMETbuM+NYtglnM930VkiIfKsCcwO
	dLimfDAZ1ikQZL4HQu+gwiPJco1fWzA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gy6fehJ4;
	spf=pass (imf18.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760646412; a=rsa-sha256;
	cv=none;
	b=LHxXkzwd2oKdO61B1AzLFdMEs4q+2Db/Sbg6VaAD5PscUOmmH4YkldilRV5LqIpMp+I2vm
	UeuwQU+mRFOWg+h3RHILV1dXOdpSmmRScSY4F7DqYMzDjah7idTK78e33eO/6o2cCrQWio
	+UpTmSMhYiWBNgDdAvBWgut1GqGfCs4=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-339d7c403b6so1197155a91.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760646411; x=1761251211; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bo5Pb4pEnCN8Qp9wO+FXoUs/VjBU1u60no/MUECaFf8=;
        b=gy6fehJ4vc6qp9sQNPSXxtur2XToZBwNpX4AHuetcd/rZAFLnXMcIsnJ1YZlGvPhOy
         3CF2rww+6v7aBzq02FzyLMImbq9B5tX5j8Y9g6jeMkE06pHVkOaHNNNr9ZAPWHHc7WA6
         P7S2f4MPrpjLiDi1CLIWWOToTWH13Sd3b0kpbvPscm5tNhMTgwhpe5FiuNiGN9o3Hs9k
         nE/ABe+bwKjAuEKZmRWpIKgRWBnDNZEQ6DHKWYIumslPHflcdTdy4uOOTy8qon9ZmW/W
         84lj3XvPPe8uAx50aHhCYLFqd8favhZ3oEKVmSxssEjygTKrAPuBROxEoJsbGqeRCx0u
         L5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760646411; x=1761251211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bo5Pb4pEnCN8Qp9wO+FXoUs/VjBU1u60no/MUECaFf8=;
        b=fQcWUgmAf5IpHOCrl9N+rIibhNkhHIxLHxj2q2zCly4QzpB+GzGNoMaqi4flHFd/DQ
         fQelOc0i7FM27JKD262ESEfNnzRJ68Mo+cvgudwQlQc/dbd6yunr0HHFbXELqHstKzCT
         RpLhbsWZOTkK/T4xNijKjGEJXWNp9PDjucMNycqDXl4DDYgOkJaWEtxu2hbo+mD3MNWM
         LVf6iTFUkxwwmAKhwxwYOU84WCfeDpWsNbmEokidkmFc0u93JDFeNLW0llSPrF+G0VSo
         f0WS7DAWKnkVrUH7HeIOjl/NaFx/b7Ubqt9ExdnTCplkBhPfjYR31BcYlMNgbwotgvl4
         mXXw==
X-Forwarded-Encrypted: i=1; AJvYcCXSqsIPetKJnVL7q505gPEweOiL5bSRDYG9u07qgqxacFatOcsLXd/ACMCur4OmHxXVHo+aj1K3rQ==@kvack.org
X-Gm-Message-State: AOJu0YwMeDrCAof65RckKPpu+0S07Cb6li8C4bR2UWWPELMnm5120tm7
	ACN6N21yJOiiur3CkFMlO1ZFn7v1ZnQxF5IP6riRvgyV3mxvArGcuUq5
X-Gm-Gg: ASbGncsIJHb2DiNpOWpSM1wYmredhIS11HnMV571zlG4mPapEcTKzlJ3iPKEhc4cQIX
	e+93sBMfQ5EbELjjsH/6n/l+/oD+JmAuppzwNPtnGVadz+BiSyycxK+mvLBdXRHHY2hjZGqolc+
	6ypCNZOWyVhUB7rHtG0T8qIfTuiMDtOZTY/GZU3Y/thNZahfFtyddQV7pGwBy7dRYZv/YSmDYyq
	6ScWMfs4cc3ePq+ygKXa/K6Km1D5+ymFMCVxD2SHlYXdsCihXodOZGjO4RBIyon0E7WhqNIWqvx
	NfwX8SF/+go+J8T3oMh6qMZV32a9ncNiszZPB0HTPaC2O489HDciNHLH6Jv9YVmPrm9RkNq8bic
	dMaLx/yjrtQGDzO4FF8f3j3GFKEXKsKTkpUQyb4sdCKIDaeeZaI312wn/LovG+ZY75vdogdXvg4
	4ChCce7mMoCN/gyVNy82pDg0HPMc7TzbS0I2+RR44F104CRvvZa0Vs/4A=
X-Google-Smtp-Source: AGHT+IE9B5Vdk4petXHg7AQwUSLZThEnOzKfYaaM8uzg+9wXXauMcXrMjeybYvp0mkVR/VZkAIO0fw==
X-Received: by 2002:a17:90b:28c4:b0:338:2c90:1540 with SMTP id 98e67ed59e1d1-33bcf8e7174mr1148401a91.20.1760646410655;
        Thu, 16 Oct 2025 13:26:50 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1151:15:6028:a61a:a132:9634? ([2620:10d:c090:500::5:e774])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bd7b3da16sm314131a91.18.2025.10.16.13.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 13:26:50 -0700 (PDT)
Message-ID: <2fa573e6-bd9a-46b9-a2a6-bfb233d0389a@gmail.com>
Date: Thu, 16 Oct 2025 13:26:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] memcg: reading memcg stats more efficiently
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, andrii@kernel.org, ast@kernel.org,
 mkoutny@suse.com, yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 kernel-team@meta.com, mhocko@kernel.org, muchun.song@linux.dev
References: <20251015190813.80163-1-inwardvessel@gmail.com>
 <uxpsukgoj5y4ex2sj57ujxxcnu7siez2hslf7ftoy6liifv6v5@jzehpby6h2ps>
 <e102f50a-efa5-49b9-927a-506b7353bac0@gmail.com> <87wm4v7isj.fsf@linux.dev>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <87wm4v7isj.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2144C1C000C
X-Stat-Signature: q5tgxawccqtyqzxytkgecdgen85b18a1
X-Rspam-User: 
X-HE-Tag: 1760646411-380659
X-HE-Meta: U2FsdGVkX185xhQlcxUJyCwdOtUyYiybFtY1DoZrNBQ45zhnYd24DwTuJvOH/WrjNezgXvWNYvObURA98E8R0uhyNOyaLRJWTL5FLpqdgmZclmyb4nkc94UUgbEoEOrhHV80js8yJXA3WiSyEh96VoTUECm2Gdb2vF4tDFrQ0MibFC3R7m2L9uuGQS6PoR/AaykAG3w1TE2UPRxO5cLTuAIL8dTfEuqgZLjxCkL9nr8MRSgjmZ/vCct8kxIXbkbeox6rFx+pupShfRHS+YA3ROJt09xQh0DBj7KOL7V4FxjhjRiB6Y774ajNFoidB+oXxp+69Q44KC47d7NGoLMlbH7igm9nkDFCmKkiV9xA2f/jaiEfBudQKD0Pmse+BTLydsyjVUoFnFv4LGoN6nwziwfOEPIgPhQ0QIutkfI8t77c7XRANYqVv0WqzFXitbMsHxwAjlZ0fX1V8wjmW9bouqw9V1bol0Q+a8yyyovuJKJlw5HwXDpo8ECpqSAHkw4VK75j1CiQKsRSIioupBrghhUJPRYTaWpg6wq7h33bNUT25DasqGIgmqHENmQQKU+arU4VkrqwMaoxc6gj+sDP57sTjUsFds5pVvVDEMpYzTiCbWQXzOVSoDAeXr7n+dhJHRTwKv8Or6kOdLqusVvWk+tNvqcoWs7jvAXqv68R6H4lxUH0TXl3iBC7S1roxDAO5QTmxolq0Fx1ArNJazPx87AeFloarxeadSLbCI4HGai8PAr3BhqcEGVhwkqaqWQQcTz3hM7h6tiRW65etHqczt1S/ufKZyZY02TgyvnQ0HO5dkFOVpnjrCNOKw/fy5hQC5oVY3fYqfgndI13MO3+vOu4xt9rjF19srgz/82YWl3amsd/xwS4ZT1OPSYVQY1HctxiTiPfHtGMHm+nFLSvW8JzCR3DP5gBY7C/T37QXSk8Sa+YjD42ZfQUNo9wWjO3VT32k7WCeWW5AgvYTrl
 tCrhc65Q
 2jBuXGfDnrlBx6/PKlgFQjJAzWbhoci/adZj0Iec43n9xEf7BESi5lwGyuYm3Eg1pBVjVujb1VhPv/DZbb511L412XRMrZlqA4/eQbkHtBg7lmTSmqWicx6YbNmsca0c1PH/rmShxuu9IcMVLpkOmialItc3A9/B77lpLvjAI/fimzsh5OoPeaEaPNRQxSilkTY+CPak0qienTyQL59f4gkOgGHzvqFS890rs/HR+xnAnyc7vmHioCNhn4s6yuQoNUQoR5M7xbLuUJ4SDCgChZ2tsV5cUoJ32E3mVG+Oi8KxS8/S70wQjRsk8DvtVI3gPIchciD7hBMgo3MuRmtybxMXrKEs1BuE69mDt+wW1KkebixyLb3KvfVXotYogHzVMJqBnW4ymo7dpAEeCH2y1E7N5iU43e18hm+JLw/YPfNNdW7VsUZdY1hwHXqJHcbRWIQEr8jd4eoZl0YfHvkYTUEji3HeMZbyRBrFVcOJh6VWrRW5nB/WHXzUbdwlaz24bzh6cl3GlFDCIDP72KT/21QvxXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 6:10 PM, Roman Gushchin wrote:
> JP Kobryn <inwardvessel@gmail.com> writes:
> 
>> On 10/15/25 1:46 PM, Shakeel Butt wrote:
>>> Cc memcg maintainers.
>>> On Wed, Oct 15, 2025 at 12:08:11PM -0700, JP Kobryn wrote:
>>>> When reading cgroup memory.stat files there is significant kernel overhead
>>>> in the formatting and encoding of numeric data into a string buffer. Beyond
>>>> that, the given user mode program must decode this data and possibly
>>>> perform filtering to obtain the desired stats. This process can be
>>>> expensive for programs that periodically sample this data over a large
>>>> enough fleet.
>>>>
>>>> As an alternative to reading memory.stat, introduce new kfuncs that allow
>>>> fetching specific memcg stats from within cgroup iterator based bpf
>>>> programs. This approach allows for numeric values to be transferred
>>>> directly from the kernel to user mode via the mapped memory of the bpf
>>>> program's elf data section. Reading stats this way effectively eliminates
>>>> the numeric conversion work needed to be performed in both kernel and user
>>>> mode. It also eliminates the need for filtering in a user mode program.
>>>> i.e. where reading memory.stat returns all stats, this new approach allows
>>>> returning only select stats.
> 
> It seems like I've most of these functions implemented as part of
> bpfoom: https://lkml.org/lkml/2025/8/18/1403
> 
> So I definitely find them useful. Would be nice to merge our efforts.

Sounds great. I see in your series that you allow the kfuncs to accept
integers as item numbers. Would my approach of using typed enums work
for you? I wanted to take advantage of libbpf core so that the bpf
program could gracefully handle cases where a given enumerator is not
present in a given kernel version. I made use of this in the selftests.

I'm planning on sending out a v3 so let me know if you would like to see
any alterations that would align with bpfoom.

