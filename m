Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426AEC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A738E0003; Mon,  4 Aug 2025 09:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFAE58E0001; Mon,  4 Aug 2025 09:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C115C8E0003; Mon,  4 Aug 2025 09:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD3FE8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:03:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A83F16033B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:03:17 +0000 (UTC)
X-FDA: 83739090834.19.9E4111D
Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com [209.85.208.65])
	by imf23.hostedemail.com (Postfix) with ESMTP id 723FA140018
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:03:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=msKlxuc6;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.65 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312595; a=rsa-sha256;
	cv=none;
	b=3jU7ILO8UBpdkmX8aose2uDgG7CLvRbZHd+jO0vAGvEbALH76UvkFKy6qgnRaReZj/H6MK
	TNJ0s40jokQIW+1Za7p/tP9l4xKxdAvmEguBP70jtGbJSJ05VyeEQkKUD0o98QWfg0LKtv
	axzoh4vHpO4NqVQE4H2eA2HpfHGfZBM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=msKlxuc6;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.65 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q47hRQ8aof0UlFDXgmcMzO/kJRO5vpkzZCiWS2hBN/U=;
	b=RlDIaFUkMx9jXQEGgVVNaw3f5/2OytzC9gz5CEYbGd5fmmfNAWTbjDZBGMvrFc6K2FUdnw
	VIJdBfFzZlGuBaM36eF46A4uodUI2eKsSq3Fth32/vinhl5xEhCeyKpspv8r3JSH0rvUHD
	0WB497vMH9sReLnJkw3QYW9Qfr+o49Q=
Received: by mail-ed1-f65.google.com with SMTP id 4fb4d7f45d1cf-61580eb7995so9651443a12.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 06:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754312594; x=1754917394; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q47hRQ8aof0UlFDXgmcMzO/kJRO5vpkzZCiWS2hBN/U=;
        b=msKlxuc6dflgZge4lp+WLp1++l7pp4X5Ds4WSi81yoKR+Y3bubh3yTpDA4FuTmWh0i
         pwmfDc/OWtbPURQxzXKlYU8M80o+z1eSzf3/54G6r+r7w0ZZX5viY0Rzen01/jr8yvTr
         InklYP7aNJ+qexsLTd86H89DqqFdp2yIStdWGWx90fPpl0jsvoGSJe1hiTJ0n02ktsfD
         cI8D2EsuNWwsZyMxKjuJS88iDN7XUjKPqRX72Oe6I56aMod8LlYaLQwqYXe+7OXrSFyt
         1bp2l6OtZSOI0YZvKXMcl0EVjpoY5+M+F283n5ju7QFLueQQtzTzGBjP1DUMD+pGNR9f
         RAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754312594; x=1754917394;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q47hRQ8aof0UlFDXgmcMzO/kJRO5vpkzZCiWS2hBN/U=;
        b=C0zbQiYSKj7xjauAcmMpC+23483n0nGMxlxRvKCFJdyxAk+/OkTqzswiYsK7LYECVA
         MjeeAC/5c/cjvjq0amZh/DnopMbiNHQJNCXuSgEpYI1ZFqEhsZecMkzsp34HZdS0rceB
         Kf5lvh2y8GYi9HRPDFVm67dYsqrLO5YOjccM5XHdS3Z6v4K3o9PIieZzDl6hS/wby9OP
         om8uLAmLYkUKKA5kzQAmeU8eRkprwdFs2hU00N/eGRB3GoUqIDlpA4JaDDqV+S1kN5IA
         FCy2EAQZOl/A2b8tuJPo4+uH84I3zgiO7MhDKJM6++kCQ+lg325oUTnU/nGtCDE+ILr3
         7RYg==
X-Forwarded-Encrypted: i=1; AJvYcCXusaQtRHshzt9rcCYuCGACFoNSAzierD3grOeHSpKwFFKfH55infFO8rupMUJAsCpLEpEpg7lp+A==@kvack.org
X-Gm-Message-State: AOJu0YxfPOg2w/ZX9RPjwqdJNVgmD4A4Vgj24pw26m4hsooBnkb6aQ1Z
	PC/q+L+3S8jb8Bx89pQJq3mdlAxZJRRWoqE6IlcLk4L9E6bZW6Go1zfacegBR/L6AIg=
X-Gm-Gg: ASbGncsMuzhHG2EfSTuSu7si+7rzX1/fO3Cl1yfH3BqcJDjsmc/za+DBMI/zzJu5KAp
	tYz1+Psk7vwnaPaFXa8qAozXVsv8h6Oi1CzwF4y7qr2jEhUYoiMEnKdsErCaV1NjRQpg0/6+wy9
	3xaIJoo7W63jyBgA3J4Et9EDcfabYOeeHp/0AU6qVhNLfJVroHJB4ZdZwlw/M04i3vi4Lk3f2JV
	GEogNTb12vAEAmXvPwFA3os5fkB++ZE5xtUsE3aOMbCsG1ydWRh43QBv/s65CAOVboCAHk0Hzh2
	HGSAYGYd7cwsV/BAGKZna/R+E8QDSQHon669O1D2MIsX6UsakLT2i4RlOLjbZtOeVhUEi3b5++h
	ZT72z/2Su/NQ1VCAP/hhJMa8OGbFEew==
X-Google-Smtp-Source: AGHT+IGvSWWoom5PCcQotC2cJOEy0b1eBZ0+mNZIcNqIApwylioSaULTySuV/h+PeeW7g5S3kYnbAQ==
X-Received: by 2002:a05:6402:27cc:b0:607:35d:9fb4 with SMTP id 4fb4d7f45d1cf-615e5e52361mr8637535a12.15.1754312593561;
        Mon, 04 Aug 2025 06:03:13 -0700 (PDT)
Received: from [192.168.0.33] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8effda1sm6755395a12.1.2025.08.04.06.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 06:03:13 -0700 (PDT)
Message-ID: <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
Date: Mon, 4 Aug 2025 16:03:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org,
 Christoph Hellwig <hch@infradead.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
 <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 723FA140018
X-Stat-Signature: o1d5185h3orwt9xpyxumigg6xezki88c
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754312595-10853
X-HE-Meta: U2FsdGVkX1/n/Nmrqz2Qll9Od7EITYUQn8Bu8Y9WkiaX7yq9i42cKIUt/laDlC1rPSRr5AJWi7XgJ/2LQCV40OT9N2+hDepsuuGGe1gj3E+Q/JD7HhmrC6lCdNEijmmf8X7fvTS8SbnbAIpG9zJLuqRFOR1pYcD1vFdnBFq7jdvGKPLLeDeKvm2xLDZiqnkBr4BFXXrpgB3JY7HVC+/017EhRGBLtC97MwEJ0Uu7XISPQJRlhdEPdl4eD/MUzQhxlQ+iwCuU9XgBFADQWCAkE3SnXpGPlOsc2mLDttrSOolFQQKdVU+1EN508pskJJhhQlz6wovS/smklPaqwzTKv0fe0VPu+xfBoHNaGnxHYk7bT02fulf/heZgpwOdBEABGFht0KZSk8lma7lkTuaXDSyuXb7wrl9+LKx2HvA/LcyzLI1M5SD/blzjM4a4ugU2VZPbgaQzzZpKjZb9RH+uWwHh8FqX/X7HHgvQB3H+hZHVGMvTVOUHIF+Ud5+9EJXzM3EoerAD4LOIQrfYhBprbyMiH4z7QoMfYe1p7WjyfwO5MNavAwpe3FFLPK8uKsNAZuMgFV6SPYKYk1lFy3yIDHF2sfHOQqySUZ80csujy3m9UWz5zJvZ6s7ViklW+UwBn/BR8UiGd20qFKbi2AE3zF2zjvjJ5hdUQAslfZ7K4Uaed47BPW9mqV0Hg3mPd7OhGTrRDWgdJOEB7kH9L1Iz6jFe/rTEJLpPZOR2AFvphGhZIHSx+8pCM2tLnOrwEhdMbSOXyU7P/fXmkzS6M1ku+ilolsjPLaJrpdV159NunZUdUOgPEgnC4fb10y688YWIjcS/kM6KU+gFRXpC0ANmY8A6PC8Yqv536t0qR84JNv4MN6+FmAuSsiG7wuIMckk92zqAGXZohwW7WWS3KDqD3EsuVd5o70UCHEbhODuPjfXTHsqmIB+KnkCJf16iAMMSQKO62rEdyx7yk0SNlWj
 UTx/IPSM
 gfXPiBcZv55SWTUV/O9MvKQfgKYWBm0HZyWsKEA0nj3ydFzj41G0MkqPmnwPjdnyyduBGPq449qpghBjSCy+askfpcJj9ugS5ymbnmsQNHOnlZDTmCj21ftMr1BDkm4MCyTrk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/25 15:49, David Hildenbrand wrote:
> On 04.08.25 14:29, Eugen Hristev wrote:
>>
>>
>> On 8/4/25 15:18, David Hildenbrand wrote:
>>> On 04.08.25 13:06, Eugen Hristev wrote:
>>>>
>>>>
>>>> On 8/4/25 13:54, Michal Hocko wrote:
>>>>> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>>>>>> On 30.07.25 15:57, Eugen Hristev wrote:
>>>>> [...]
>>>>>>> Yes, registering after is also an option. Initially this is how I
>>>>>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>>>>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>>>>>> here:
>>>>>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>>>>>> Do you think we can continue that discussion , or maybe start it here ?
>>>>>>
>>>>>> Yeah, I don't like that, but I can see how we ended up here.
>>>>>>
>>>>>> I also don't quite like the idea that we must encode here what to include in
>>>>>> a dump and what not ...
>>>>>>
>>>>>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>>>>>> where we e.g., have
>>>>>>
>>>>>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>>>>>
>>>>>> Could we similar have some place where we construct what to dump similarly,
>>>>>> just not using the current values, but the memory ranges?
>>>>>
>>>>> All those symbols are part of kallsyms, right? Can we just use kallsyms
>>>>> infrastructure and a list of symbols to get what we need from there?
>>>>>
>>>>> In other words the list of symbols to be completely external to the code
>>>>> that is defining them?
>>>>
>>>> Some static symbols are indeed part of kallsyms. But some symbols are
>>>> not exported, for example patch 20/29, where printk related symbols are
>>>> not to be exported. Another example is with static variables, like in
>>>> patch 17/29 , not exported as symbols, but required for the dump.
>>>> Dynamic memory regions are not have to also be considered, have a look
>>>> for example at patch 23/29 , where dynamically allocated memory needs to
>>>> be registered.
>>>>
>>>> Do you think that I should move all kallsyms related symbols annotation
>>>> into a separate place and keep it for the static/dynamic regions in place ?
>>>
>>> If you want to use a symbol from kmemdump, then make that symbol
>>> available to kmemdump.
>>
>> That's what I am doing, registering symbols with kmemdump.
>> Maybe I do not understand what you mean, do you have any suggestion for
>> the static variables case (symbols not exported) ?
> 
> Let's use patch #20 as example:
> 
> What I am thinking is that you would not include "linux/kmemdump.h" and 
> not leak all of that KMEMDUMP_ stuff in all these files/subsystems that 
> couldn't less about kmemdump.
> 
> Instead of doing
> 
> static struct printk_ringbuffer printk_rb_dynamic;
> 
> You'd do
> 
> struct printk_ringbuffer printk_rb_dynamic;
> 
> and have it in some header file, from where kmemdump could lookup the 
> address.
> 
> So you move the logic of what goes into a dump from the subsystems to
> the kmemdump core.
> 

That works if the people maintaining these systems agree with it.
Attempts to export symbols from printk e.g. have been nacked :

 https://lore.kernel.org/all/20250218-175733-neomutt-senozhatsky@chromium.org/

So I am unsure whether just removing the static and adding them into
header files would be more acceptable.

Added in CC Cristoph Hellwig and Sergey Senozhatsky maybe they could
tell us directly whether they like or dislike this approach, as kmemdump
would be builtin and would not require exports.

One other thing to mention is the fact that the printk code dynamically
allocates memory that would need to be registered. There is no mechanism
for kmemdump to know when this process has been completed (or even if it
was at all, because it happens on demand in certain conditions).

Thanks !


