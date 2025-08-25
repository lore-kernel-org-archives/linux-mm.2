Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DBDCA0FE9
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C2E8E0020; Mon, 25 Aug 2025 08:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C4A8E0001; Mon, 25 Aug 2025 08:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04268E0020; Mon, 25 Aug 2025 08:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA0528E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:55:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA425115614
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:55:13 +0000 (UTC)
X-FDA: 83815275306.29.5626674
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C36640005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:55:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=eSYqHQ63;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756126511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyb7W0i1P3IjF0jcI+ICuOqZQ1VFzRLlpkO8ArSEv2U=;
	b=Z4K8S7QuUH0GHSxXZZ+jvP/v/K589Ox+xCZBFosvKBrSajeTgFJYUCFQnZxa45+enfc/Zw
	eZkqk0USs0sBpSxlz2VvKzpddFTHfklcqUETbtHk1vn8uF/PMQr9Bl7guYLdeT28eqLECV
	jc6m+rnkUB0BrXXuVJ28pC1FGZ/3j6o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=eSYqHQ63;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.67 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756126511; a=rsa-sha256;
	cv=none;
	b=LpxGgRACgeCaGe32fBI1ZdZCJqGoxtkHxJw4oak94EgVv+t2TyM2e6Vdi3XX6amC+UeW8C
	TjkDAuBHS0rnBlc5lAKE/LwLhFTuOvhBxboYMeH0VNdZVnRNualoIHXkS2dnlAz9xfF1ej
	p6UBrf0/vf6byeuBSCZbJdq4rxud2jI=
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3c380aa1ad0so2123110f8f.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756126510; x=1756731310; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nyb7W0i1P3IjF0jcI+ICuOqZQ1VFzRLlpkO8ArSEv2U=;
        b=eSYqHQ63pZMDlGk6S7+Iu3gZBylAMuYqbFW12cwxK2kp4krg3mbk2R31zm1joYgg8C
         z+XHRLU2gcdAblDUYbINk6iQkoCDWImLNq7pjK9M0US+/d6//UVuPAO390MgJSrP/e8F
         HNlfGfq6OsB2gggvZ3RM+BFqkz3MaWfEO0mGBk1SnfsZTPp9u5lZ2tFcIdY+Erxw9bbe
         ZIVbtFk8Lvs7OL3UL0+z4JB512G9HYwk3mpNEeVBflmcI2pnWAxS1M3dIJMyOh35Z9ry
         7/iILlUJHo+4ko2xYqBxRuKePsnKjVQB+FF4obElNKFtH5knAIh8UlyYGpf7GHgNq5EQ
         EM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756126510; x=1756731310;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nyb7W0i1P3IjF0jcI+ICuOqZQ1VFzRLlpkO8ArSEv2U=;
        b=qupUziRbgq2IbzrcvqDujqJIwI+iAPq7zc2qP2aHnbfZDpkDvC6atp80fhy/ITTh6F
         Ih1Svw2BULVILhpFrwwAAT0Z3yi0Zbv0GILDNlrXyNEp1XSsxPnJZ4QNUCq3YmhxMVL5
         sHHf17i+qMlJRPFgJ5KQzGWYPPUUxLvFiMqfwfVZ4rSr7iZUjLw9SBylY8s7PizwXg2N
         0U9pTOEy8o50pzCA09ZbGUXFeRMxxJqD9nSirF03htgU1W4DPJTglzrX3iILwvomZHOX
         o+wynHaB/8rok7l+kAM5zGOIakLSoKxv2iig6ZUb6L4E7Bnxdf9NWw9mU7Jhrti6KRZs
         js6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWJ4KnEeysMmjjEcBWO08niokK72NRbUzy0k0pPgih9ml0x/WfUkWZNy7pthOqsssnBKWM3GlmaKA==@kvack.org
X-Gm-Message-State: AOJu0YwOBQcdoMtDQ0nis1NIVIc9Ty+PlxGu3Hdg1lNqFsw9a0FnsrsS
	c9H4QhUskBNm8RK7HrGp7xMM0b4+BsuHsmMzqmS3QYrrv94iR9KUbVAtCm8NFl+ou3k=
X-Gm-Gg: ASbGnctHF+E+8Mo3Sj6p0kah/FeNNUq28fHkutYPR8NYF7i/9oZg2SnbffqaWOmynY6
	WVuWW8vvKOTGv26bXkRPikeBLX3PJnsZt4ps3BV1JOPbB9qgf5UaeDXTtmbfnRvc/MtaSe9FaAU
	eAzI24xXZNqFBHvmsRc2TmSwB2+rS6lrWZPC/iejvHeE9tpywVO3qThXVctnaXMBQni1i0cPhlp
	SmLeZYeYoWXO6LkbpwHF/3kCo2k7EmN14H1zG9YVO9aJkOkt4kAWOPzzadC3VZp9lhc0kT7HYmI
	nFZxcif4vTm0PsliLKR+7Ak2AJwGmJXjB+a2qQ1W0VvD0ktu2cW+Ol9op3aOH6oFH1fwT0nUQVD
	qLsNmwbnawPpKNb5BFVdb5tBB516oOw==
X-Google-Smtp-Source: AGHT+IGiatYdBiQIlX08WDb3q8TgWhNu9cU7pZ5BZYgWH52vQcA/WE9cIPHsPYf1nJo7amAILSvRZA==
X-Received: by 2002:a05:6000:40dd:b0:3a4:d6ed:8df8 with SMTP id ffacd0b85a97d-3c5dc734927mr8857444f8f.39.1756126509927;
        Mon, 25 Aug 2025 05:55:09 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57487910sm107774225e9.15.2025.08.25.05.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 05:55:09 -0700 (PDT)
Message-ID: <64a93c4a-5619-4208-9e9f-83848206d42b@linaro.org>
Date: Mon, 25 Aug 2025 15:55:07 +0300
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
 <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
 <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C36640005
X-Stat-Signature: fx9gx3hgzp5ys4ddt5k1nkizamxxqt7g
X-Rspam-User: 
X-HE-Tag: 1756126511-551723
X-HE-Meta: U2FsdGVkX1+Vu2mS27MMGjuro5Qjg06qqXuB+RA8vUCSdC6THedlHo6+94af4euvhfaddYMpO9/TFA0YtMPhCl6fwjVSJhLSq5JHzAcTRflNoYkQy55xAmnN+yONtNgrAINYHuHKAoJXGHJQpP9dpnCkSNfdnC3ygrFwzf4+C4uxD/Tvg/4mzCSVlIY4P/E71/J2O+w+yaYDAAR1sY5A0875slOqzxKqBRGBizliTsga4oUWecQcG49j+AfWwgOw312/knknUykwHDiIEJr6FpoWWoJdfr8snpGBTRUm+gS3Dh7PuFfEBBYDWtbLNjs54UV0mUofjm9WkdYRhkCyvx9bbByyAQpNPoeT8q4zCWSP98gOVXEkAr2QTetPON6bxv2+Lfi+kGR+obOjyURLdqpVhomubCjvGVMATZTyO8iaE6pVgHE3VzZwQpL1rl4Goxst5CV8nDLxSQHrMUoRxyV0VbBtXjCKxfDhGRV1BlTldJXGXgEbrrPOCNuwKJ5pjsQ2E6UwZr8ODOvZ2uhV6uP0RxglOhxrm8365maOhcXQOBo0pEF20WEwULC5obPTt1wg5sAPGjKkPcPgRDn9h59MEL0syNCDn5UbOLCi5pkgXKP9liEveKETUER+4E6JsK2R780f0XZX0NtG6CQBB3v7J+RT4nSt7pwD0BH5Z3+AUW/GRmhnKyJpmNNxbuGWwhEVNPRBnsJ0XA4DVGaa4SY3VruUDuDiwyU5ogvoMFIlP5yis4OjbgCqzV1ey5PWgBjCB7502oa/olKO+4yGE8swCAUn3sqTJkMUncGV43bzpLpz/7e1M7P653JUnnekwY3OoyVuRqUn+UP56Lpy762o2YsRNpB9NhcD2TbfUdDvziHveMX7WmhI/OlgcM/WTULwyhL6gs2VBfLpzq2z+Q/bgvFeiS//G+SjU723gRtxA5sealF142J7S4s5SeM696QQAIxgdey5eMCY5eJ
 jCdarzdx
 3OJknil0zhNxjNr32/x9MQlcSYNf7s9aAECqFd1eiU67DpWgcLgfiqjGCfnvU+7uCAEl7/Hk3wNcCx37Z9RkrvzZa1GU32IPPeQ72+MRMpP1hfiKgEQbIXZvKKOnYwdhqeHWuGtCBOixoE1s0BcJjERMbKeLNVIjGdXwQjiEfPl1YSBIltOpc5ZxKtAdf05moDrlqpbWhP1W1dncGBTnpddzuqeTAGH9v18vhs5a7crgXsBD7FQpU77qykPZHNWMFc0Vjxx/KZq3UqXtkuMhqWCEtTg5jx43SGrZxGu3igT+UF2x2pfYeN970aXzyQrpdTupshJWGyrWNXDqwAv5MUDbrPReyettxS4ozAk8ecwwUQZpHMUH4fex6e7Iz2qhVDeIiPhcBVHz1xLL8mL7D5PxlMw6OiwU2a1028tniDnVsMoMvhP/EHKG7Ojpx0Uw54EtJH7A/EcdTIy0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/25 16:26, David Hildenbrand wrote:
> On 04.08.25 15:03, Eugen Hristev wrote:
>>
>>
>> On 8/4/25 15:49, David Hildenbrand wrote:
>>> On 04.08.25 14:29, Eugen Hristev wrote:
>>>>
>>>>
>>>> On 8/4/25 15:18, David Hildenbrand wrote:
>>>>> On 04.08.25 13:06, Eugen Hristev wrote:
>>>>>>
>>>>>>
>>>>>> On 8/4/25 13:54, Michal Hocko wrote:
>>>>>>> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>>>>>>>> On 30.07.25 15:57, Eugen Hristev wrote:
>>>>>>> [...]
>>>>>>>>> Yes, registering after is also an option. Initially this is how I
>>>>>>>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>>>>>>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>>>>>>>> here:
>>>>>>>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>>>>>>>> Do you think we can continue that discussion , or maybe start it here ?
>>>>>>>>
>>>>>>>> Yeah, I don't like that, but I can see how we ended up here.
>>>>>>>>
>>>>>>>> I also don't quite like the idea that we must encode here what to include in
>>>>>>>> a dump and what not ...
>>>>>>>>
>>>>>>>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>>>>>>>> where we e.g., have
>>>>>>>>
>>>>>>>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>>>>>>>
>>>>>>>> Could we similar have some place where we construct what to dump similarly,
>>>>>>>> just not using the current values, but the memory ranges?
>>>>>>>
>>>>>>> All those symbols are part of kallsyms, right? Can we just use kallsyms
>>>>>>> infrastructure and a list of symbols to get what we need from there?
>>>>>>>
>>>>>>> In other words the list of symbols to be completely external to the code
>>>>>>> that is defining them?
>>>>>>
>>>>>> Some static symbols are indeed part of kallsyms. But some symbols are
>>>>>> not exported, for example patch 20/29, where printk related symbols are
>>>>>> not to be exported. Another example is with static variables, like in
>>>>>> patch 17/29 , not exported as symbols, but required for the dump.
>>>>>> Dynamic memory regions are not have to also be considered, have a look
>>>>>> for example at patch 23/29 , where dynamically allocated memory needs to
>>>>>> be registered.
>>>>>>
>>>>>> Do you think that I should move all kallsyms related symbols annotation
>>>>>> into a separate place and keep it for the static/dynamic regions in place ?
>>>>>
>>>>> If you want to use a symbol from kmemdump, then make that symbol
>>>>> available to kmemdump.
>>>>
>>>> That's what I am doing, registering symbols with kmemdump.
>>>> Maybe I do not understand what you mean, do you have any suggestion for
>>>> the static variables case (symbols not exported) ?
>>>
>>> Let's use patch #20 as example:
>>>
>>> What I am thinking is that you would not include "linux/kmemdump.h" and
>>> not leak all of that KMEMDUMP_ stuff in all these files/subsystems that
>>> couldn't less about kmemdump.
>>>
>>> Instead of doing
>>>
>>> static struct printk_ringbuffer printk_rb_dynamic;
>>>
>>> You'd do
>>>
>>> struct printk_ringbuffer printk_rb_dynamic;
>>>
>>> and have it in some header file, from where kmemdump could lookup the
>>> address.
>>>
>>> So you move the logic of what goes into a dump from the subsystems to
>>> the kmemdump core.
>>>
>>
>> That works if the people maintaining these systems agree with it.
>> Attempts to export symbols from printk e.g. have been nacked :
>>
>>   https://lore.kernel.org/all/20250218-175733-neomutt-senozhatsky@chromium.org/
> 
> Do you really need the EXPORT_SYMBOL?
> 
> Can't you just not export symbols, building the relevant kmemdump part 
> into the core not as a module.
> 
> IIRC, kernel/vmcore_info.c is never built as a module, as it also 
> accesses non-exported symbols.

Hello David,

I am looking again into this, and there are some things which in my
opinion would be difficult to achieve.
For example I looked into my patch #11 , which adds the `runqueues` into
kmemdump.

The runqueues is a variable of `struct rq` which is defined in
kernel/sched/sched.h , which is not supposed to be included outside of
sched.
Now moving all the struct definition outside of sched.h into another
public header would be rather painful and I don't think it's a really
good option (The struct would be needed to compute the sizeof inside
vmcoreinfo). Secondly, it would also imply moving all the nested struct
definitions outside as well. I doubt this is something that we want for
the sched subsys. How the subsys is designed, out of my understanding,
is to keep these internal structs opaque outside of it.

From my perspective it's much simpler and cleaner to just add the
kmemdump annotation macro inside the sched/core.c as it's done in my
patch. This macro translates to a noop if kmemdump is not selected.

How do you see this done another way ?

> 
>>
>> So I am unsure whether just removing the static and adding them into
>> header files would be more acceptable.
>>
>> Added in CC Cristoph Hellwig and Sergey Senozhatsky maybe they could
>> tell us directly whether they like or dislike this approach, as kmemdump
>> would be builtin and would not require exports.
>>
>> One other thing to mention is the fact that the printk code dynamically
>> allocates memory that would need to be registered. There is no mechanism
>> for kmemdump to know when this process has been completed (or even if it
>> was at all, because it happens on demand in certain conditions).
> 
> If we are talking about memblock allocations, they sure are finished at 
> the time ... the buddy is up.
> 
> So it's just a matter of placing yourself late in the init stage where 
> the buddy is already up and running.
> 
> I assume dumping any dynamically allocated stuff through the buddy is 
> out of the picture for now.
> 

The dumping mechanism needs to work for dynamically allocated stuff, and
right now, it works for e.g. printk, if the buffer is dynamically
allocated later on in the boot process.

To have this working outside of printk, it would be required to walk
through all the printk structs/allocations and select the required info.
Is this something that we want to do outside of printk ? E.g. for the
printk panic-dump case, the whole dumping is done by registering a
dumper that does the job inside printk. There is no mechanism walking
through printk data in another subsystem (in my example, pstore).
So for me it is logical to register the data inside the printk.

Does this make sense ?


