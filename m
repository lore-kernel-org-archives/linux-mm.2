Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8C3CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C92C8E0008; Thu, 11 Sep 2025 12:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779978E0001; Thu, 11 Sep 2025 12:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F778E0008; Thu, 11 Sep 2025 12:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 531598E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:00:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA169160246
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:00:31 +0000 (UTC)
X-FDA: 83877431862.17.781052A
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id C217DC001B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:00:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kMClb9ab;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757606429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2V6Ly8wut6TjSsWUqfM+DfRRL6BttFfoiFg8qrKV2gs=;
	b=s7E0o4CoI135ek+dMOh/E1fLRJcmPubll8gQDRXiaob7nLAPzINM7gDa31yRTP2SLGckRe
	F2kcEJ6hbniZi5lbJNUcNtaj+HdqdG2Bggfty49MabjW4NTs0kbw8WCm3J4QaFHbDrt7d4
	tPxcShPzl7qlt+J675Z1HdcMos9y3XU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757606429; a=rsa-sha256;
	cv=none;
	b=0FftKhN7zHhSwLBKbZJY3uJeRpFh111OgEtjmaz7Khq1cOqGd8txNl5to7PMM2ddZ1BI4R
	NcQB8WWOcaaBDkAYl3n/az0MM9quDC2MyQ+ELHaT0U7Ym0+x3ULFGbFOUfoY+ctRc+NbN1
	Rm0lhL0Wyp7Cy46vDyK1EQAIqn+TV+c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kMClb9ab;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-71b9d805f2fso8338526d6.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757606429; x=1758211229; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2V6Ly8wut6TjSsWUqfM+DfRRL6BttFfoiFg8qrKV2gs=;
        b=kMClb9ab49o17UXt6VSfv60uUd3C5i6rD+vG4c0Zcfn/VebERrd4NLTU5I+Cdzv3hZ
         elUl5hrNVZWdATqoPP5uCxfK+ck1zeTRnX7rfSZYYvt69Ro1KJO86Yhfg1AiE940kDoo
         OQTgX0vUTwL2Ai3S4LJlh3eX8z6yOM6j4dtP2QowbTmGbIzYyJzyxdtpJr1FzhPGhOGF
         6bCXe1Vp+fDvGNZat/hrO2TUCYxqlSATZH3yEDLtelAaA7Ofy9vj9+4iKHGbXfgvv9/U
         aLdtaQcQFJiT/2SYELDe8rLUXxY8vWclENuLm8JpfH/1+9P5tmHDfK3/9nyd5wpCcp+M
         EReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606429; x=1758211229;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2V6Ly8wut6TjSsWUqfM+DfRRL6BttFfoiFg8qrKV2gs=;
        b=n+TgRleiMYn/qR8RDJeO3qn0KUSZ0j2JlRHgBc3HbiGnBekQbW+5TIr53HmO0oBHEi
         R33iZHpGDgMl68E4Qs2/7L0tqml0zbuUdDUHaNAA138/FQpL06Jgq+7cg2jCG22ZLpSH
         xr3za1WIdpbgNQ6Mdv5FGZwcKItRcc1HkXms5S/gZ2ngsDRq3pDeX5hijsL1TZEm7nEj
         wgFW/9Qfh1fdpD1774oCol0hyidDyoLqbkX7sQxHd14HEXRbVMeNOdgbvwvsmvOk3FpV
         8nr4LhxXMD0/gQFk7WFqaIDsE9lCRzPEGy4RoH6EOiiWnMat7If5gWvs66zG9UKCxGHX
         uXgw==
X-Forwarded-Encrypted: i=1; AJvYcCVyYtaXFfCpAVYZuGDqSRsW3Hi5lWBtxCDsDgOK8f+B9eJdiG0G1f9Al+X02u4DnCVZatMzcEmiFg==@kvack.org
X-Gm-Message-State: AOJu0Yyxs63ygBJM2D0RznYa5QjRHqoUsscIrfyWGxrXhOhlejgPlKIe
	6+/zLk39bVItUZ0M/jHBOL3gahAqzUKclTSia7fABvzIh1uZwOBdUAM1
X-Gm-Gg: ASbGncvI+EDnTugQsgkl1yx0wqpk2BC4T+9K5RXucza16+lM1ZZ8jVwN0AzULfjWFba
	20fhtUxgsIncjpgQk9iYaDoQhz6P+hA0A037dbYjfDEK3XAwWxeYXtxPw2GcJnXkHwtRwjhFK9p
	FZMMQfuFi3XyRo18pcd0ea9Ir2e8UJT7kBCJDKEUpyruLnsb3RJrPbgVRpcV5KZ+7HJlWGR1zno
	euCD1wOawlGDA0jlezG/qcOwIZc5mhWxm5k4wac7kstGBqSG2uwmBWEQYbvZfvXkj+hjDJfNuD1
	xyUeuc9lZAFOHinMEU5AtXrjrgUW+rYpcewvTRbBKz1ph4fe773+f9LPEztmm4O3CFXpjVXCKu8
	tMmWC7VA2uk5JwkqthABR9263O7nkWxon9BtcAQT0ws76YyhRMCYcHlPoIKBY0Q7jrdGAAer1zu
	Qu/w==
X-Google-Smtp-Source: AGHT+IH92AYdKJB1ynLJH9ZT+vCjzmP7qU2FX7m29cFy2od6zEeX0Ch7ZKM8aLmHgcXgjZIwQiQSxQ==
X-Received: by 2002:ad4:5b8d:0:b0:70f:a42b:1b65 with SMTP id 6a1803df08f44-73943d7d1dfmr226888706d6.66.1757606426756;
        Thu, 11 Sep 2025 09:00:26 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1145:4:1456:e851:ddd5:be9f? ([2620:10d:c091:500::1:8948])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-763be01498csm12891126d6.48.2025.09.11.09.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 09:00:26 -0700 (PDT)
Message-ID: <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
Date: Thu, 11 Sep 2025 12:00:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Content-Language: en-GB
To: Yueyang Pan <pyyjason@gmail.com>, David Wang <00107082@163.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz,
 hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909234942.1104356-1-surenb@google.com>
 <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C217DC001B
X-Stat-Signature: snsotphorkrz7j7t9dh68yah1xoioadr
X-Rspam-User: 
X-HE-Tag: 1757606429-317308
X-HE-Meta: U2FsdGVkX19+3ogfD1FKtUITGc2MFpl9qwuAjiA1GinoY5+4b6VhItDmPXFr0hPFMOM+dGRYa8pi9c1TP6Tb4+D3Hvw6ySDDUknw5vbBMnOmdKO23T/sKqNKlcva9PmO96jB+j91H/m3R7o6IAUBFi6iqzpA9PU4PqcVcXL3PKjXYQOb38BV9ampB1Sh3awI7Yy0wWLGWZbAMR9SzGnzMQH3w9NO0CUiZ4RbSv3SgSMjmhS1AAF171IJI5zs+jlvc2FRa968byOpem+ym6dGhrqc7CbaXJv1h9KKHe+vxU88OQLmokELlyMmtXYLlEEwuKwszr8NdwMQlCizbSqFN0EmNgTcwXhT4XF2BlJY9fNY36XFwCQXhEEkEVGXsviuivIlrIZ/kN5I/ycVWv4BvVoc8l6JRyZRX29+y+RE2WYO5aS7VdG83Qg8IB4UXBW5sehnM6S/CdcRMZgYB59ZigFzG5MV7U94bs8rDVBtu3uICQ8loggg88k2fBx4jND9Uo9MZneb6ILcIi3MqsbcLwHYjXHINzsriqC1HYveNZ0P0UyhXSoP0gZbKEtEWYyXnSxB9wkxoY3l5ZjMJiy+N0eJixFDu6QboD2a3g4iSC3Zj9Xnz5BTenx9kk63g3CsBNCJ/Wz6QHCTkv029LsOWOnmlfR1mO3AbNRk94VsVP7HmKuBX5lLMtzWQptvFdBuIb614WHYKtoKFudcxjJMXFnou8jwHTNPN8RPLy924U0gJYx6gWRJHTXOAZ2CWkhFmDOy2A+zW4qotLwsUIhyvEvzS6Qeu2/1hZjWQLipK380Iu6tf+fhe/9gG5KJab9/gpwNxqfgjISY/LCoSHUwWvGwkYUI5hLiBBO5Hd+X2ECsDcnXGR4zRVnStIJqCC7Qu1dNhzw5pbEm/prz8rUppGlsKQCrUUL4eEQLSzM+bo6XbXiPkljXIwscacstQv8+B2SkuHxB0KPFaa//BIb
 hpmOKsph
 Rr3IzpeK/JlvYhtFCvowWvODrzaZbVyj+58qB6+mJOo2iMrlERY1IUWrW2rC9oEYTimD5iMhFt0VlbWc5Qcu8eNsBFEw/XClXkI8R2Y4x9ETqeM376B2HGLePOj9i2vh016ueLZY69qA3+qHWROUq6Km2QTicg6Lj8DAZAyh4TMBZ6Kq1zg/0/c2XB128AWDxtuCUNNGnRkjhmsoJG/7KCfwOmyDej9VIthu9jVWJpX29wl+8SMVXIaPZz0xGyJls2A/HxP8iw9at5Bh0oLfgV4hRU/0jO8r1Unn5jg3rrGD1fZS8g34CcNX6gWbYT6+v+5vzpMJcETlRTqPaMx9jLuT+cdAu0qbWxKl5pmYfQXDgYq7qjDURot9a5kycH1P7Wl6BM9nRkce37vOskfy/msUUzNw6nbjN0QSrGNN5xb5ZeMkydTpkp3TJTgflrTRWOJo6fge/x4wgl9ZPx5ONVVsO2hz30kAA8u6xB++MdZibCe1NEijFM8PHMiJhWZLKWXES3B5G5XNV3UnIJcvNuT1XnnYUC4rRupMU5n7Sd+Xc7wSRdhjxn8PFpNySgtFh3si58A9Cay4cB/HTBDZaGPzDxWM8SVmK8J1eg5rKT0aooP1avGG6eAglzyIDw5Lg4Agg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/09/2025 16:47, Yueyang Pan wrote:
> On Thu, Sep 11, 2025 at 11:03:50PM +0800, David Wang wrote:
>>
>> At 2025-09-10 07:49:42, "Suren Baghdasaryan" <surenb@google.com> wrote:
>>> While rare, memory allocation profiling can contain inaccurate counters
>>> if slab object extension vector allocation fails. That allocation might
>>> succeed later but prior to that, slab allocations that would have used
>>> that object extension vector will not be accounted for. To indicate
>>> incorrect counters, mark them with an asterisk in the /proc/allocinfo
>>> output.
>>> Bump up /proc/allocinfo version to reflect change in the file format.
>>>
>>> Example output with invalid counters:
>>> allocinfo - version: 2.0
>>>           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>>>           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>>>          0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
>>>           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>>>           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>>>           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>>>           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>>>      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
>>>       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>>>           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
>>>
>>
>> Hi, 
>> The changes may  break some client tools, mine included.... 
>> I don't mind adjusting my tools, but still
>> Is it acceptable  to change 
>>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
>> to
>>       +49152      +48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create*
>>
>> The '+' sign make it still standout when view from a terminal, and client tools, not all of them though, might not need any changes. 
>> And when client want to filter out inaccurate data items, it could be done by checking the tailing '*" of func name.
> 
> I agree with David on this point. We already have monitoring tool built on top 
> of this output across meta fleet. Ideally we would like to keep the format of 
> of size and calls the same, even for future version, because adding a * will 
> change the format from int to str, which leads to change over the regex parser 
> many places.
> 
> I think simply adding * to the end of function name or filename is sufficient 
> as they are already str.
> 

Instead of:

49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create

Could we do something like:

49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create(inaccurate)

This should hopefully not require any changes to the tools that are consuming this file.
I think it might be better to use "(inaccurate)" (without any space after function name) or
some other text instead of "+" or "*" to prevent breaking such tools. I dont think we need
to even increment allocinfo version number as well then?

>>
>> (There would be some corner cases, for example, the '+' sign may not needed when the value reach a negative value if some underflow bug happened)
>>
>>
>> Thanks
>> David.
>>
>>
>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> ---
>>
> 
> Thanks
> Pan


