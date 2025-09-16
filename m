Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E10CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663EF8E0005; Tue, 16 Sep 2025 17:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B798E0001; Tue, 16 Sep 2025 17:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551078E0005; Tue, 16 Sep 2025 17:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43ABE8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:52:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC1B885F6D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:52:54 +0000 (UTC)
X-FDA: 83896463868.19.A7C51ED
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id D82621C0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:52:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AXrVAK9w;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758059573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiQ3OJfilcOmX87aswW76EUtbko6LYz1SDf94Zf2TEo=;
	b=cwskybcEyBMfY8Y/rYoisraD2L5wVkimGHsw16SN5khVk6e4jqGEq8w9Rsl8maSoH8mdPu
	CNu1q8uhFoAM7j+rWV6EL+Hv5LO01fujG7MTTJFAPxLtD5rzOtz0y+5a157/Ty7WtP0UON
	GuSZpL5ynbgn0joL+mYlXsQt7D8KwSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758059573; a=rsa-sha256;
	cv=none;
	b=uMSUWZIMoyjTUBtU8FRWkPDOpZwWOc80sQrgmSDs6VzXeNkUqpYPSCsrrQQdPch9vndfDu
	Bb1busomNC1VnETsqU9BSetbtoXgIGN/XC6QYDvEMpJxnJT7q1SxRxPqs2BB3uo/1HERzJ
	IBTzQzintiQsTmepeMlfs7zBu7wOrII=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AXrVAK9w;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45f29d2357aso23591925e9.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758059571; x=1758664371; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UiQ3OJfilcOmX87aswW76EUtbko6LYz1SDf94Zf2TEo=;
        b=AXrVAK9w8kJI/k7H17wqMG28jFwCsmB3pwFOQIww7T2BKHL8q6wOILcvwAf9VXFXby
         XTyWXy1QLBk+PWIA6fR879wDiyZ2b+KLVs6RzuxSW+/rM/WjNrvUWDZ27AVOuLKVbT8n
         cPsL8E5fL8nj1F+ShBWqItlo9BZ1TILxEGzbgyXL4Xty+kvCcf12MAcFy2Si7u1In/mD
         pWa5xSMlV2ptXaUX3dL6tfb2JPfLDMyHbGB5bwanr4tFvwyhxKfs6k7nhVQ5qL8pVKwT
         0/Lf/Oi3gbTcQnWDMpg1BTnzV3a2LRg4c+QDcjb9HNtxbvS52pQEka8MgdPOTMTTzVUw
         I57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758059571; x=1758664371;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UiQ3OJfilcOmX87aswW76EUtbko6LYz1SDf94Zf2TEo=;
        b=ale/LIhPSxd6YF7PIOMXob1r75+kRi+zfnigI2CPZQ02Bb0+/zZYQoeSkLpajUWwzL
         ZcfBAXjg4Ca7HY8GXRaVRGFmYK7hCfvWgmNR313Neze4GQ7NwLDi2YhZKq9a6KrZ+bxs
         ZECSWMzSY6xLVckmcU0uBXyk/TRiKmhCxauLQrhYm8QEMzmlf0lUm9w309NykiUk1toO
         5tZiJu1S2+A531FgVdNLgXnYBbpArANXkyW1dgg42/eNvGiAb4/0mBLjEZraHVj8q/nl
         579c6HPnDVJAZX5N89vuO9FcpGdXKlrZFRAyGXDb1fMGMT1jckJuOPLRQXHzsbfOCM6H
         CfYA==
X-Forwarded-Encrypted: i=1; AJvYcCWbYYamRuNMrBauh0ldjSnvOLmaOal7qvki1Gpo3mucWeJmlTWozbfHFaYMSb0j0f4n+MPngRvP9w==@kvack.org
X-Gm-Message-State: AOJu0Yy7D+CWjlyWjmOxLGB22/wfgZbQKaXlY9o78PX7xqqDGvFMVfG1
	tzyG7xedmIgmsg+PGMM22M2/0kkvY/K0htS300KhXylZrrZBUdg44JYA
X-Gm-Gg: ASbGnctzung5uukl9Ley5M4iM8yAQ4lXaLzA2CWsdTCqoGADrGx2qt/UNkoWmXt6Z9j
	0AXOeMVSWQNsfs9cuUU3RCwO/Vx5kvgaz6J4DUB32iz8AQX629tL8q24B/VgPul8we750mxR+hA
	JEd7NBhTdTfY4B6gVwk4ZuRuyUdmAtW6Ch+Qo2Uo3Uui5UIXZdxogZf1Y/NZvQO1BWldhuRnq/h
	gjR0LuflgvVLv8MuUiL4PXPq6p5fsXV5VXi6mCvX0ib+A3WiRIcZZkbNr7484yq4MzQA21kLhTw
	DQEIq7uiqYkF7m/l4eTjLH1DAzUSXCmuFpZ3h9PXxznJ8x1x6Qfk9TLIQg7wZ6voo9j9+ogwI88
	KFzyuc7XdMw3YotZNpGrr+K7aCYjAcsPDt0VLbXS2S1WsnYH4kAO83QwXAFzARQYN5RKyNf01Tw
	BkK5tGdCj/2ZKude74cA==
X-Google-Smtp-Source: AGHT+IGhJXnMcHzLmeBfVYy84asxwzry7go5nv0En7vIcIJAS7k4xugn3PkxnQbwxosW/2KARZKAag==
X-Received: by 2002:a05:6000:4021:b0:3ce:f0a5:d594 with SMTP id ffacd0b85a97d-3e76578f304mr18235883f8f.13.1758059571129;
        Tue, 16 Sep 2025 14:52:51 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f321032a1sm27412195e9.2.2025.09.16.14.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 14:52:50 -0700 (PDT)
Message-ID: <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com>
Date: Tue, 16 Sep 2025 22:52:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
 kent.overstreet@linux.dev, hannes@cmpxchg.org, rientjes@google.com,
 roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev,
 00107082@163.com, pyyjason@gmail.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250915230224.4115531-1-surenb@google.com>
 <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
 <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com>
 <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q16fudb55grzpmewn9q56ogxoee6me8r
X-Rspam-User: 
X-Rspamd-Queue-Id: D82621C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758059572-325789
X-HE-Meta: U2FsdGVkX18rlJnx4YtWr8ofEcY3Gjnu1uALSOZ1H5DAUSnUmJeTh6L/O54lnSmXf94If4x2s6y/rGtUISYFDqiVsit81eFGnd+fHdt2P97vh6twz6WY3UGhchxEnpttJiFDMrE5CHba+Hps6vhp5tjRtka9Shcq7vUXTsr6wddRCEemIbTc/+/qyxDVCFy1To9OQgOhpNqJoZI1BP32/Ay95jYHZvRz+io0DKAguhZc76wpEmn2szyAygL4P9f/oIfOqu9dUDcSC4b/dplrjMBPIIwifjM8mV7aaafTFYixWJJ82GOHmPo+dHe77Ak5NTv61to6Q2hf9yGyDQ+kqfoXucmL6bxuW/aBrkQq3n7Q0VZ3KsDa3+cwm++i4uTbCi+G4FF3l7+IhF3IXkSrKEA+hdijGRHSoAqoiA/aC9zumJ24hGWoYlowgCOVTKqdrSMCpo5JMTXwZET7oTQyzjOJYH90ALcyGW1eShIzJzvYG66F2azN51Ggdy0k0cx6cTKznxy9M3Xa4Py8O68cNJ2YglgML+nxTQYw6mKV47VEMwqbuYFurOly7GGvj71SBwBxwsU2fVyyeJd02Fc5UNVq4rY7/Zi+zGH8tgU5zmlmyl6URQu8LPSJzZh6OhYNG09qDTrmbBe9UuEfdDVoC6DzkyQESyopGAKeBxqoVmnP/uBTedK+Vkx7lE14xoZsybmT6Lw5hotxGRiNECT3OBRsqJ53wcIJWbh4Mq49imG7Z9e0G4Hzc+2dO5NZVpjUW1XpQ7MZQWsILcVCB56B2cXi9yhz4qRaE+xow7ISu6kurX1Rs3QixKHNTZfLVdu7CMVz9giJkH50qtuOAC3eaxI1NyEHZ7qoXU/cRRK+2qHFYq2SWBTEDRw8oyQp1ip8/5Lwl6jwy1QCzlPlpn3ZcCAmWaoTJ8tWYBfFEPyTMl7rXeh+w7qv3TyMwPA1CZ/o2a3HE3zsjbUXVItI/zd
 1wwCLhQj
 ui/j3AAAeSs5D2aGGXNz+qdYRNhTkubrQSMzEQnbCgGnU5hs2pbV/MyL43e2rcjcGFfYvxPBkrLDL4AAjsf163HIN8Hynhm0AXE0fvZPCgvxjOaaoSEvRwiIhHbgpGTli1yip0gig5a8Egp6wQlX+wXED1nfry4SULawHsarG9RF1IQ3JWN0Y6u0iM6RWB+zrd5EoFnzuBfvvgPtP1961Qi8qmYIMz4bnFsoTDIY0vb+MSmn+8oLiketNpcxBLRHASTisg0Pxin1wnARWD6KtWvyT1ZnR2Uxn0flDaEDEC7E7Bx9uJiqANVCYiWE5ggIVzHatQ2OQKikF0eJ1R2xMTFfw5nuaY8Aaq+KfLefW+WKdJh4Re+DplB90N15tP+yo6B2oi2AU30A2wu3HJTZcg5guQOIreah9Co/DjrADHOUb3YErpGZUQwAjkr/hwfVMOJWASVj4mtqV4Qg5NPK6e9nE4hZ32hYvTBT4FWY13DqtznwC428hXixkk0Grjq60qi9GZ0RS90bFSkN9yc3tyAv+11m2gJDXKqchKZEFP3ZqkPHgoQpvM64KuP34MUoyCKCQ6pK/sC/blxQd/Mil66Kt4Ok5GEn81ThfpnRWnehxXe8I1VN/KT40iRzj9+HEWg/iGvfEf2J6rOc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/09/2025 22:46, Suren Baghdasaryan wrote:
> On Tue, Sep 16, 2025 at 2:11 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>
>>
>>
>> On 16/09/2025 16:51, Suren Baghdasaryan wrote:
>>> On Tue, Sep 16, 2025 at 5:57 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>>>
>>>> On 9/16/25 01:02, Suren Baghdasaryan wrote:
>>>>> While rare, memory allocation profiling can contain inaccurate counters
>>>>> if slab object extension vector allocation fails. That allocation might
>>>>> succeed later but prior to that, slab allocations that would have used
>>>>> that object extension vector will not be accounted for. To indicate
>>>>> incorrect counters, "accurate:no" marker is appended to the call site
>>>>> line in the /proc/allocinfo output.
>>>>> Bump up /proc/allocinfo version to reflect the change in the file format
>>>>> and update documentation.
>>>>>
>>>>> Example output with invalid counters:
>>>>> allocinfo - version: 2.0
>>>>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>>>>>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>>>>>            0        0 arch/x86/kernel/alternative.c:127 func:__its_alloc accurate:no
>>>>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>>>>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>>>>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>>>>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>>>>>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create accurate:no
>>>>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>>>>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
>>>>>
>>>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>
>>>> With this format you could instead print the accumulated size of allocations
>>>> that could not allocate their objext (for the given tag). It should be then
>>>> an upper bound of the actual error, because obviously we cannot recognize
>>>> moments where these allocations are freed - so we don't know for which tag
>>>> to decrement. Maybe it could be more useful output than the yes/no
>>>> information, although of course require more storage in struct codetag, so I
>>>> don't know if it's worth it.
>>>
>>> Yeah, I'm reluctant to add more fields to the codetag and increase the
>>> overhead until we have a usecases. If that happens and with the new
>>> format we can add something like error_size:<value> to indicate the
>>> amount of the error.
>>>
>>>>
>>>> Maybe a global counter of sum size for all these missed objexts could be
>>>> also maintained, and that wouldn't be an upper bound but an actual current
>>>> error, that is if we can precisely determine that when freeing an object, we
>>>> don't have a tag to decrement because objext allocation had failed on it and
>>>> thus that allocation had incremented this global error counter and it's
>>>> correct to decrement it.
>>>
>>> That's a good idea and should be doable without too much overhead. Thanks!
>>> For the UAPI... I think for this case IOCTL would work and the use
>>> scenario would be that the user sees the "accurate:no" mark and issues
>>> ioctl command to retrieve this global counter value.
>>> Usama, since you initiated this feature request, do you think such a
>>> counter would be useful?
>>>
>>
>>
>> hmm, I really dont like suggesting changing /proc/allocinfo as it will break parsers,
>> but it might be better to put it there?
>> If the value is in the file, I imagine people will be more prone to looking at it?
>> I am not completely sure if everyone will do an ioctl to try and find this out?
>> Especially if you just have infra that is just automatically collecting info from
>> this file.
> 
> The current file reports per-codetag data and not global counters. We
> could report it somewhere in the header but the first question to
> answer is: would this be really useful (not in a way of  "nice to
> have" but for a concrete usecase)? If not then I would suggest keeping
> things simple until there is a need for it.
> 

I think its a nice to have. I can't think of a concrete usecase at present.

I guess a potential usecase is if you are trying to use memory allocation
profiling to debug OOMs and the missed objects size is very large. I guess we
wont know until this happens, but I would hope this number is usually small. 


