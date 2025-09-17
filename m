Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0A3CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1CD8E0073; Wed, 17 Sep 2025 17:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9DB8E006B; Wed, 17 Sep 2025 17:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF6C8E0073; Wed, 17 Sep 2025 17:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F0C9C8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:10:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9232987254
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:10:02 +0000 (UTC)
X-FDA: 83899984644.29.A221AE7
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8E8A7C0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:10:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eHFHrSSv;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758143400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TKnemSHyXhT2vgBMl2/3OYWo/7PODj4kOYVIAoQ2M2M=;
	b=dLIcoUKRE1hq56UJc1rbyhCNLxoGEPOAOksC74lpfKnszIdg7WS6bdl0WSOmMTK7OI1R+B
	UtLptfHX7/iuNFaiKJcBaW/DP26mSyL/Zkf7cXYq2brIrTBqkEQOExYy685Eu9264+UbWD
	qUwigoVQmKHn0ybQ3wAhpXUQ/kZBQ/s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eHFHrSSv;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758143400; a=rsa-sha256;
	cv=none;
	b=L6NiFytCfqcV6KYevTGFW5Y+zc+HEWOCQh/aXdy6jMGOl3ymnujhGVTifnEWSOuD3r8Oq9
	O6VpKIXeXwJ8yJIiu9Na+vcJZr2kXk0Dl1ZJXTgviOPiw9zuEqEupNljqDz+ZC140J+3ck
	bEFUJmk6wX22F/cTTPKT4TW2GgnZEsc=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45f29e5e89bso2002615e9.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758143399; x=1758748199; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TKnemSHyXhT2vgBMl2/3OYWo/7PODj4kOYVIAoQ2M2M=;
        b=eHFHrSSvRhFDhwsaCLRWau0ahK8EQ03O6ENTeXyjb9/6rjk6uirEgceHpE/xO63veb
         bv8hs4M32OdBlmxft/2vNc09WRRA83WBfd2wZYAHV22ri1D1W1IrWnns6M7MWjFq8ImY
         UkazlFE+1lL0ch+05JlFVDuep+ioEOtAugKmcNChsOs62xIj3MqA4PKMH4cjKGPvgShU
         wxgX5IOfFFfeakT4ge0DKmhejaIzbwiZGfYwKX8zyzZ554YtcEdplPeQxLlgCfkYLLgy
         JYPPQLaupCjXHA5IbyYKKEuTOHrZ0u6C5ZKmCliCVuMeijdvt2YllAbbctjm3jLs3nLL
         fheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758143399; x=1758748199;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TKnemSHyXhT2vgBMl2/3OYWo/7PODj4kOYVIAoQ2M2M=;
        b=E2S9wU3SUhwDWHg3r7D0nV4L0r1r6A/i6KM0Li7rgoho+KyA/c7IokZ3FM/IxIZpuD
         RYwjPrKMnOgCIXzjOOn7AdRJ4eRiA8fpAmdZ4688g1cwLxwCUjIgapeILL9kNULO7R+v
         Jd9f+oSYbV0VnilQthbhuPdCGNDvGQQnFcqVgQ4Y4k8UR5n5mAksKsAHPDzn/zzBY5wp
         /S85qNU9hd2+mp7ccALGidX9yJ/GiER3SjP+xIhJfxt8O8f8IPU4q9cOXbCoYAI2rg+J
         7IIgmoZpqzy07ghPILRszaO8J6KcPOV6ywVVPu4XJm9k0GT4CAMeO0Zprt4Q+GbSN6a9
         5FQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTDrmKGtwWRcvU7tBflDwBUqB5RK7nWiFQScum6lsHoPRs0c1yRs/8L2RvHLS9kCZXvFf7UFcKEA==@kvack.org
X-Gm-Message-State: AOJu0Yw07OlwEqQoi19tReVOxSnKTc+YM4r6LqG1b2W1Jv37bnk1jaCQ
	+1o3pTWtljvfPqyPaxsarL6j0zBP0F/bjn9e9jll7Uz6UhH9ATS4qRLh
X-Gm-Gg: ASbGncvLNcFbW/lZ5CmDZMS0YLaKObAZrUBRMZJbXu66WMGof17OVr5gnRTvYeY7+g9
	aRa9XnSKHFeN47SAopffhn81zCDDN4/tc6r1w5FI0pI5X/Utwxtxt72Y3syY5qh6HKLTcxhdk3s
	BmVDp2kfghkZvL66TkiMufRX/GJGxJyXCCaeMFxCkkobndi8X5ImMRcvSKEm4i9JrLXrl5LOXbC
	ZI8NyQRKHpngThb78Q2aNV+M3nfoYpjr1nur5IwaD3rWhJYqD7FMssc9bQTscD9jN7Exef6ic92
	U2R0SE6AJBeWgn0vdhfErcjFrh6tE9oUxWuxWuKLsXqFlXLL1HrDxB4Yk2O0CVXmGW5bb7Lh9zn
	XUuuSqwst+yyK3nZmatK2Tnkof0hesZK7f+etHd4/NzF7gwkinLCNhwRMx5H0Nu7rwMDesiAkMb
	fDtlzRMruSerDtQ3f89yE6GeElDDS4+6KUydmfY0HYgn4el4c=
X-Google-Smtp-Source: AGHT+IHlVi0gbe1N0WWmvWmbviaim/Zxtf5abTYTF1UBjO3o2Fe2t3ZAzU7OG9ox7Dk+WqbVrxkwig==
X-Received: by 2002:a05:600c:198c:b0:450:cabd:b4a9 with SMTP id 5b1f17b1804b1-46206b20089mr30116355e9.29.1758143398813;
        Wed, 17 Sep 2025 14:09:58 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7410sm760713f8f.35.2025.09.17.14.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 14:09:58 -0700 (PDT)
Message-ID: <d451dce9-2217-4351-bc53-09967fa86cca@gmail.com>
Date: Wed, 17 Sep 2025 22:09:57 +0100
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
 <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com>
 <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
 <CAJuCfpGgVa9X7nXhqOUZWi+p+JGz1QofiXrTJ+BF=DU3m2-64w@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CAJuCfpGgVa9X7nXhqOUZWi+p+JGz1QofiXrTJ+BF=DU3m2-64w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E8A7C0002
X-Stat-Signature: 8hhq18oaf7g7r867qky3n9ui1gy9su6f
X-HE-Tag: 1758143400-44519
X-HE-Meta: U2FsdGVkX1+L8ERlwmtwLMVOA2Fe1NG4VCW9+wNH/yfh/FrosyZY8/5z9g/KWDwe8Wjj8SB+FWrUmBBwxQy/MQ8yTQCaDguuD3Ebg5yPLD4bD1UAAg7Q1NQX8KVA73HehDR1wG6j69Eodd8vDjL7CplE7liZPeWxC0YVFklQ7TiZ0pXl/6b+Q3QlZ+zQsuKT0fOjllVeQ44g8fOtHJ7Hv5nsS7bv/yOnBbwN8VoDFAUpWdldn6bfsCwef91HUxPzRHH3Br8u0rFKEhWVz2VeLkeSAPhK5Hsvs+Ri5xQggca1dwXdErpuYADNplVhA8IVsbATR9M/IgUjgorCVJ1qa2Z4SD/ua09Ida+Vq1acMIpbptjh2EfWc72iCfLea3YJDqjB7WXu4ayuYD3mTLtKq2DVQ/hpmIZSikfyzSczuW2eBi60vcSAI1nCvWL641cnbZJ+Qd9d5tWtfGmjEdZXP2Bk0NEes93/qFzsDF/oJQyOENiSDkmz7tnzjZmdwuzU7BUD1QFhI6i6d5UpUOS3LzYl09+04o1rXI8Me0UDlUb5edvdT/FoH4wDcxnsEs3RWzo529AHxWC+G9NpVVI8wmJZT0KF8Q1SCbk7gN6hrIf/jNU19PQ1yVd4Sb/WZyGw14n4CuLNbfJRK4hYdHd6D2nVQMpmmWu/QhuOVFH2CFHECg7Ync6a/lE2nfZ3UEIlneHWV9sX5t24CjOInp7m0V1UeXbo310a0X7GAwNvncPlrZU1fFXCRhwRW+Rl5vLACmp532pbQuNkmeyewn5ZPE3IP5GIZZs6NkUNDcTNlcTwQy2VsehXiTDIWlYrAQ4vTwogr+n7TP0jzN8lSTQ9n8ayL5LzsrlNuW/7ER8lOLQayexqJxZGk+2Snfff1Isg5QRb3vc3Uu2t/bNMPFTZxokAKKWAHRoH7M+6qr76Gr+lgDdJcMHwpMLvcJnTwc71sqTkNx6nT61175nwLHq
 pUdaO7fu
 bZrq5usYgIUKhKyQ6WLwiLgjAnH83BElU6vFW8jLYQ0SqD6OUbCD+zMZEcgM7nVLeLro0sO2z5H/7JZrWk6hw6PL0JvLSplAxnkLQ8+j+lKzA7G+XBZU7+ufrxtbgbUNOiLA4hxBGDAkcVZeHSWX83lGw1E7n4W8SBI8xfxpbBwP3OyE6aImpE6m1FUUSxqInAMZKAhiiL3VEbMyI4hVqpMIzh9P0nBwrs0VG137WHLsH618EDUitX86rkiy/SNH6WbEWD/qZZF6FiEqJu6tc9DozpeD1qCcce6hmGCkN6nIJt77EvvKtq2xbOPasgxe4IgD1RW3+fWe2i/Pw9inJLmtjauocnUIIka5Rm3wRYuUizuMG1VjNApbLwESR+3vl56R19/W5nWiPAlJXn6I+EeKbiSTRea7ObznhR6uwCi/ZDmQHP5Swl4SXBV8DzVa+dbxeHKhhX2vpeGG2nRdM3hrQOdDgE84Kx90hhLBsFoOqd3WdHYlYOElEU/SigZJzvr6F8ak+VL9bd7pvI7qb/FFwjps3RaOPRBu8v9hsZJeyhbyHnnISsPOXwVUnMl6Y97l8TvNj3T/v5xvjpGxDhoPGBJGskmowcEEjrVLhmFffu7WJCHwcZTYtZeBwXq785Nz3YcZc/PHJJ8FRF0YQwpr+/KiYY2wrS2gcTn8Ol+K7lzZ/8j3byLcGLOEVixUoKVcIztL4o4sm9Xc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/09/2025 23:27, Suren Baghdasaryan wrote:
> On Tue, Sep 16, 2025 at 10:26 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Tue, Sep 16, 2025 at 9:52 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>>
>>>
>>>
>>> On 16/09/2025 22:46, Suren Baghdasaryan wrote:
>>>> On Tue, Sep 16, 2025 at 2:11 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 16/09/2025 16:51, Suren Baghdasaryan wrote:
>>>>>> On Tue, Sep 16, 2025 at 5:57 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>>>>>>
>>>>>>> On 9/16/25 01:02, Suren Baghdasaryan wrote:
>>>>>>>> While rare, memory allocation profiling can contain inaccurate counters
>>>>>>>> if slab object extension vector allocation fails. That allocation might
>>>>>>>> succeed later but prior to that, slab allocations that would have used
>>>>>>>> that object extension vector will not be accounted for. To indicate
>>>>>>>> incorrect counters, "accurate:no" marker is appended to the call site
>>>>>>>> line in the /proc/allocinfo output.
>>>>>>>> Bump up /proc/allocinfo version to reflect the change in the file format
>>>>>>>> and update documentation.
>>>>>>>>
>>>>>>>> Example output with invalid counters:
>>>>>>>> allocinfo - version: 2.0
>>>>>>>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>>>>>>>>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>>>>>>>>            0        0 arch/x86/kernel/alternative.c:127 func:__its_alloc accurate:no
>>>>>>>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>>>>>>>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>>>>>>>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>>>>>>>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>>>>>>>>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create accurate:no
>>>>>>>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>>>>>>>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
>>>>>>>>
>>>>>>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>>>>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>>>>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>>>>>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>>>>
>>>>>>> With this format you could instead print the accumulated size of allocations
>>>>>>> that could not allocate their objext (for the given tag). It should be then
>>>>>>> an upper bound of the actual error, because obviously we cannot recognize
>>>>>>> moments where these allocations are freed - so we don't know for which tag
>>>>>>> to decrement. Maybe it could be more useful output than the yes/no
>>>>>>> information, although of course require more storage in struct codetag, so I
>>>>>>> don't know if it's worth it.
>>>>>>
>>>>>> Yeah, I'm reluctant to add more fields to the codetag and increase the
>>>>>> overhead until we have a usecases. If that happens and with the new
>>>>>> format we can add something like error_size:<value> to indicate the
>>>>>> amount of the error.
>>>>>>
>>>>>>>
>>>>>>> Maybe a global counter of sum size for all these missed objexts could be
>>>>>>> also maintained, and that wouldn't be an upper bound but an actual current
>>>>>>> error, that is if we can precisely determine that when freeing an object, we
>>>>>>> don't have a tag to decrement because objext allocation had failed on it and
>>>>>>> thus that allocation had incremented this global error counter and it's
>>>>>>> correct to decrement it.
>>>>>>
>>>>>> That's a good idea and should be doable without too much overhead. Thanks!
>>>>>> For the UAPI... I think for this case IOCTL would work and the use
>>>>>> scenario would be that the user sees the "accurate:no" mark and issues
>>>>>> ioctl command to retrieve this global counter value.
>>>>>> Usama, since you initiated this feature request, do you think such a
>>>>>> counter would be useful?
>>>>>>
>>>>>
>>>>>
>>>>> hmm, I really dont like suggesting changing /proc/allocinfo as it will break parsers,
>>>>> but it might be better to put it there?
>>>>> If the value is in the file, I imagine people will be more prone to looking at it?
>>>>> I am not completely sure if everyone will do an ioctl to try and find this out?
>>>>> Especially if you just have infra that is just automatically collecting info from
>>>>> this file.
>>>>
>>>> The current file reports per-codetag data and not global counters. We
>>>> could report it somewhere in the header but the first question to
>>>> answer is: would this be really useful (not in a way of  "nice to
>>>> have" but for a concrete usecase)? If not then I would suggest keeping
>>>> things simple until there is a need for it.
>>>>
>>>
>>> I think its a nice to have. I can't think of a concrete usecase at present.
>>>
>>> I guess a potential usecase is if you are trying to use memory allocation
>>> profiling to debug OOMs and the missed objects size is very large. I guess we
>>> wont know until this happens, but I would hope this number is usually small.
>>
>> Hmm. Missing a large allocation and not knowing about it can be a problem...
>> I'll start sketching a patch to see if tracking such a global counter
>> has any drawbacks and in the meantime I'm open to suggestions on how
>> to expose it to the userspace.
>>
>> About concerns on the IOCTL interface, would it be more usable if we
>> get the alloctop [1] or a similar tool which can be used to easily
>> issue such commands into kernel/tools?
>>
>> [1] https://android-review.git.corp.google.com/c/platform/system/memory/libmeminfo/+/3431860
> 
> Ugh, sorry. Externally accesible link would be
> https://android-review.googlesource.com/c/platform/system/memory/libmeminfo/+/3431860
> 

Yeah this would be nice to have. We do have something very similar in our infra, to basically
sort by size and store only top x entries.

When doing manually, I just do sort -g /proc/allocinfo|tail -n 30|numfmt --to=iec which is copied from
the kernel doc.

