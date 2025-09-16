Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5CAECAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92AB8E0003; Tue, 16 Sep 2025 17:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42BE8E0001; Tue, 16 Sep 2025 17:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D317A8E0003; Tue, 16 Sep 2025 17:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0A6C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:11:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 708EB1A032E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:11:33 +0000 (UTC)
X-FDA: 83896359666.25.62A5108
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 60D144000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:11:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YPZYHdHr;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758057091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtDJfjQiYsrnTHsWR0+0nQzBkXZjKOyy+WheYP6UDhg=;
	b=2SRM10liSRsyGlVC6enb9FKte+mK1KH2wxrDzWsDxoV60ciPmvdBGYioF3cn/1YozjMFyC
	wyD8T6FJwTh/tOXDzQGkDJ/BJl0IV31KSMvKuOGE3TNn386FnhWkvIFk0lenTsGVkRAvrz
	ZBygGwrTKpwlLIcaY3vzXNz96SP9WeU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758057091; a=rsa-sha256;
	cv=none;
	b=GaEo+Rw+hgZuTHTPXPQY+q+Q8jG/lG1T+Ja0GW/9+zc+h773dP+ZoQ9g30S9zOJVFVYOTe
	lRhOHxJB51jzhQh4fai/+tzBgonYno9VIzffyrt+hhLamRTxXZX8iSjg1STDci+/8rBnYP
	Xgxk477XqOZEH+THjgIu1/VdZcQ3iFE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YPZYHdHr;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ec4d6ba12eso937338f8f.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758057090; x=1758661890; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZtDJfjQiYsrnTHsWR0+0nQzBkXZjKOyy+WheYP6UDhg=;
        b=YPZYHdHrdQDlVl4DLh8XzyVZGouc0fQNaLcvx/6+UUccRztjij5aAFNWED/WYfGUuG
         Ja8X/lDdgKP3UrmDtoQKc5kYIpNKCiD2YIolxvp4VTuPouGJWbFM6mWPrlpNqkjatp6q
         A/JK8nquF7a7fHysiJxD12JqyUO+ND3FZXe2H53xpIi1Tap2pJp/wxPobeCzpP0Kd3fA
         lK4o1vL5B1jZhDQSiH5CnF/TsLkfLYg+sVtNSLzFR8WTnk4+RAoZSocqW6lVfiXqDMw/
         kLG/5ApnaBHLf3Mo59cXf5Jc5xdpwS9ZgSVgdoXDN7yj5b9pdr2EMpVJ7uawyHV9D9EH
         ocJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758057090; x=1758661890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtDJfjQiYsrnTHsWR0+0nQzBkXZjKOyy+WheYP6UDhg=;
        b=o4eDs/SZcv2uyq3nSXKSOaKxlo7AAzbchHWm1IWRPSAf/c8r8aem3aj9LLZ+ZbweOw
         vjly2bMi/SVmvsukoGB0C2XD5O8tzBF8MFmw+SriFlnVdokJ0e7wAznOVEMzzZMzXrUF
         tGRuUi/Uac1f4bNkzJ8YkWE/iPYbTEikxgKqhyTDHUAkdMEbpbJoRSmw8R5dSDG1mm39
         qcMeXIRKRYbfDTJxF5h5Vsp7pW9dy9vhXQJCJ7YF9Tw2e2Jt7TH3hZgE7J0nko+FfTvb
         YZg93xSDTw0iR3XcnRzCfnOvhSexPEjCj5WkJncroHOqDrrlOikGkPRNBJcERUUvxJAO
         cSfg==
X-Forwarded-Encrypted: i=1; AJvYcCU6ht+BMFgDwFHuB8JQXUODR29dKluagQbSk6i2qiCaM/rg+T/TPY20M9YxwXrV8peBfUACW8F6GQ==@kvack.org
X-Gm-Message-State: AOJu0YzX+MgkZywcr8VBBZL0IHrRxorXPBmboRprTv6zKmeKY21IQ+/0
	oKN5rs0hQQF/D1HjZ57qING4fjSooOprB1Zo10ScsaC4FtVDpVO1QV2t
X-Gm-Gg: ASbGncu4tJvsTdJ6ST2dqGksZiI3rrvB7rK35n6aZD84Magc8gImmn4qMuBFtLM7OzM
	0IOtCa3mU4VqZTlHCWmbP4VdDApcI05413PbgCzZTITXPrduGyW0c+JnHN7WhTqfaloDXpnux0T
	rGSx5MADyZLAdlvLpgPRhlNU3rGJP5rxeyn+4xp/arTB1fJu5ycEf3/Bcs+6h0DfAkG+R4hMycs
	Mw30OqQ2EQy4qHiE5qOv50WgBvmr7ujkJa4tbiNDWU+62o2PpX2ykm5QpLhdj9AN5IjVHi8KtCL
	dtH4Dfsk69YtIQoo8GLpynvTkXvQz1Un2/Z22BgvzoCyw2li9Uc8aPEKgDuOTAkOCkzRlxGemAC
	xXWOje/5SzAX/rvTb8g37I0RTTT0FYvJr/Dbu6IZkNOUYMrR7/URMSt3xrG9x0Q9DPFEh57ZVl6
	GOpWDBRcIO5tFvrEoDNQ==
X-Google-Smtp-Source: AGHT+IGWzzxWWQNqBAnxTryYw1NnlFT90s6alDAM47xpOX2EwWsri1rCI5Ayd3E8HPgQkVOwyM3zng==
X-Received: by 2002:a05:6000:24c7:b0:3e0:c28a:abbb with SMTP id ffacd0b85a97d-3e765594a59mr17596887f8f.13.1758057089497;
        Tue, 16 Sep 2025 14:11:29 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e900d8f0e9sm14410982f8f.35.2025.09.16.14.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 14:11:27 -0700 (PDT)
Message-ID: <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com>
Date: Tue, 16 Sep 2025 22:11:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, hannes@cmpxchg.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 shakeel.butt@linux.dev, 00107082@163.com, pyyjason@gmail.com,
 pasha.tatashin@soleen.com, souravpanda@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250915230224.4115531-1-surenb@google.com>
 <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qgjobby65ahe1obpufs3b34fj6rab1uq
X-Rspam-User: 
X-Rspamd-Queue-Id: 60D144000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1758057091-846020
X-HE-Meta: U2FsdGVkX1/Llbn3rvItbXI6zALbSlwpxLbK312lruBscTc9mblynmjhiE852xL95Lo+T0BEjNwGRwqwebRl/iozkqXM+B0tBifGuiSynxr+gN0d6YIbf8z7doWtoHq0oSXTpsSEBaIlZXSyUq23wk+/TOs1m5P9DveLoraJ3ue0DIsUU73lky948ceO16mRL4ygc83c3oiAsK2SgVtC3Ct26sRT37qzLgR9PMlgUgPM3bl/G7N8+mHW94s1UilfBdnguzIw/0RAMd+o1m6CCHhAf31szKHENaWiXhEZKvMmbDY15lt78E/kgyHe4TC/Yy34bw5c5D4b6M+w6cBSoJwbWeYFDSZ7c7Hlrg0PbJgTJQn2VGx+++qZ/hjtdKjKwPL3uTA+xTdIhzEcHqESxjPyowComatKp28PEoW1fq82A5CeUxbPj1G0V78666YWA24ntkFfT6XvdlR7n+7pH+fajmea9398mfWdcZo1SSGzwXZx+SynEprUN2o6Dy1jnMrVirgufOE0xin+tlsKd0zY7ZCH/r8+TtI8NKQTeHJzq1q+VhNmIAvYCoRY/9PVYRt4lUqyMxlpDqwQGy2gCmxeQMi+gsnPt2mVWYefe2qIAre62Z5gNAYK/6hXBifnDkIyWAWu1ek6vsLQxqLOEw1qwQuBVam9b5ib6ki593CF9Yc475TklbiR5YtmyI5nOD3gsAjgfmBfON70JbF7VsrXL1fuzaO9AoTvMT+gZ4tRNmQtVIBXVJZQGPq28dJq4MPIyrPZyWaFJjp6cujfx3IcoLr4K0Di6s2nEQTb+F+WjpcBgdNyw4SYXE9sgcZn3hnRObFBt6x4WrYr4dn0uJKJlZwhU0W4AHyk0uIOotybhm0zMjQ7hW9SUUN6HlF6NH/K2nvpWGBa+wWzv9QMuR8IOpLrQOEPpSEEs8LHLOP9XVAo+1T4xs0xIMPtIWgFyu044vXo64WKmz8xJjh
 VeSVMcs5
 uaxxEdUaBrhsMuFDGJBxl8iaZdOicRYBGsvcAiJjBIODExY/opgT3UtZLGdStxG7OphgSlF5oDiHkH23IKCY/pyWB+aU3Rtbakxtanvn8/zbA1Zmmr4ULdZjZ8reBOcuebIYWu82WWr0NSPBJBY97Q2ScJccwP9bO0q9AwgdbxZmlo7yN8cVia/TtrQkAcy+/Y+Zl9wDu2M/zEV69urFpZ6itDX/DWE9MAnE9JH2cn+Kb12cogwG7X9rg+WJpy0fNRRE3Ish/gNivfBR8Bn2/B8GLc8vfi58OAD1ED35gBqIHDZndGhZu4pRYTF6A2Pg4CDFAOj6GkjSnqDMU8FlH3PX1TbCSp16jWTnsF+opIaiD4ZROnnhV91p7TwgBO4ddSdlyQiLxY2DUeGNzNnWQCbbMqgyhMmW2YTC86T25cDSZsvirqUHryd6ysl3xvgIrXmfa2iAHA/6sr8fOpzJPthkds91xOCM1ruixyiR07zQ6/SbLH5icS5RIDpa0juvipe/a6F/bnrUQM47NW6yGnbbmvq2BQs+cFg2eLTD9Dx6QEg//7x8bTD7ycGJTR+rSBJHdkZXYCR+G9KYdo4H2JH8P1SMUDF6KB+k7Mr8RvxXfqQv+BdHf4ro+bwrPs6Cl/8nD2l57OjA5zk8RFhVLjJXnc7Ie+FhGt3kXIie01za6xnY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/09/2025 16:51, Suren Baghdasaryan wrote:
> On Tue, Sep 16, 2025 at 5:57 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 9/16/25 01:02, Suren Baghdasaryan wrote:
>>> While rare, memory allocation profiling can contain inaccurate counters
>>> if slab object extension vector allocation fails. That allocation might
>>> succeed later but prior to that, slab allocations that would have used
>>> that object extension vector will not be accounted for. To indicate
>>> incorrect counters, "accurate:no" marker is appended to the call site
>>> line in the /proc/allocinfo output.
>>> Bump up /proc/allocinfo version to reflect the change in the file format
>>> and update documentation.
>>>
>>> Example output with invalid counters:
>>> allocinfo - version: 2.0
>>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>>>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>>>            0        0 arch/x86/kernel/alternative.c:127 func:__its_alloc accurate:no
>>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>>>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create accurate:no
>>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
>>>
>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> With this format you could instead print the accumulated size of allocations
>> that could not allocate their objext (for the given tag). It should be then
>> an upper bound of the actual error, because obviously we cannot recognize
>> moments where these allocations are freed - so we don't know for which tag
>> to decrement. Maybe it could be more useful output than the yes/no
>> information, although of course require more storage in struct codetag, so I
>> don't know if it's worth it.
> 
> Yeah, I'm reluctant to add more fields to the codetag and increase the
> overhead until we have a usecases. If that happens and with the new
> format we can add something like error_size:<value> to indicate the
> amount of the error.
> 
>>
>> Maybe a global counter of sum size for all these missed objexts could be
>> also maintained, and that wouldn't be an upper bound but an actual current
>> error, that is if we can precisely determine that when freeing an object, we
>> don't have a tag to decrement because objext allocation had failed on it and
>> thus that allocation had incremented this global error counter and it's
>> correct to decrement it.
> 
> That's a good idea and should be doable without too much overhead. Thanks!
> For the UAPI... I think for this case IOCTL would work and the use
> scenario would be that the user sees the "accurate:no" mark and issues
> ioctl command to retrieve this global counter value.
> Usama, since you initiated this feature request, do you think such a
> counter would be useful?
> 


hmm, I really dont like suggesting changing /proc/allocinfo as it will break parsers,
but it might be better to put it there?
If the value is in the file, I imagine people will be more prone to looking at it?
I am not completely sure if everyone will do an ioctl to try and find this out?
Especially if you just have infra that is just automatically collecting info from
this file.

>>
>>> ---
>>> Changes since v1[1]:
>>> - Changed the marker from asterisk to accurate:no pair, per Andrew Morton
>>> - Documented /proc/allocinfo v2 format
>>> - Update the changelog
>>> - Added Acked-by from v2 since the functionality is the same,
>>> per Shakeel Butt, Usama Arif and Johannes Weiner
>>>
>>> [1] https://lore.kernel.org/all/20250909234942.1104356-1-surenb@google.com/
>>>
>>>  Documentation/filesystems/proc.rst |  4 ++++
>>>  include/linux/alloc_tag.h          | 12 ++++++++++++
>>>  include/linux/codetag.h            |  5 ++++-
>>>  lib/alloc_tag.c                    |  4 +++-
>>>  mm/slub.c                          |  2 ++
>>>  5 files changed, 25 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>>> index 915a3e44bc12..1776a06571c2 100644
>>> --- a/Documentation/filesystems/proc.rst
>>> +++ b/Documentation/filesystems/proc.rst
>>> @@ -1009,6 +1009,10 @@ number, module (if originates from a loadable module) and the function calling
>>>  the allocation. The number of bytes allocated and number of calls at each
>>>  location are reported. The first line indicates the version of the file, the
>>>  second line is the header listing fields in the file.
>>> +If file version is 2.0 or higher then each line may contain additional
>>> +<key>:<value> pairs representing extra information about the call site.
>>> +For example if the counters are not accurate, the line will be appended with
>>> +"accurate:no" pair.
>>>
>>>  Example output.
>>>
>>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>>> index 9ef2633e2c08..d40ac39bfbe8 100644
>>> --- a/include/linux/alloc_tag.h
>>> +++ b/include/linux/alloc_tag.h
>>> @@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
>>>       ref->ct = NULL;
>>>  }
>>>
>>> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
>>> +{
>>> +     tag->ct.flags |= CODETAG_FLAG_INACCURATE;
>>> +}
>>> +
>>> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
>>> +{
>>> +     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
>>> +}
>>> +
>>>  #define alloc_tag_record(p)  ((p) = current->alloc_tag)
>>>
>>>  #else /* CONFIG_MEM_ALLOC_PROFILING */
>>> @@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(void) { return false; }
>>>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
>>>                                size_t bytes) {}
>>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
>>> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
>>> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
>>>  #define alloc_tag_record(p)  do {} while (0)
>>>
>>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
>>> index 457ed8fd3214..8ea2a5f7c98a 100644
>>> --- a/include/linux/codetag.h
>>> +++ b/include/linux/codetag.h
>>> @@ -16,13 +16,16 @@ struct module;
>>>  #define CODETAG_SECTION_START_PREFIX "__start_"
>>>  #define CODETAG_SECTION_STOP_PREFIX  "__stop_"
>>>
>>> +/* codetag flags */
>>> +#define CODETAG_FLAG_INACCURATE      (1 << 0)
>>> +
>>>  /*
>>>   * An instance of this structure is created in a special ELF section at every
>>>   * code location being tagged.  At runtime, the special section is treated as
>>>   * an array of these.
>>>   */
>>>  struct codetag {
>>> -     unsigned int flags; /* used in later patches */
>>> +     unsigned int flags;
>>>       unsigned int lineno;
>>>       const char *modname;
>>>       const char *function;
>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>> index 79891528e7b6..12ff80bbbd22 100644
>>> --- a/lib/alloc_tag.c
>>> +++ b/lib/alloc_tag.c
>>> @@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void *arg)
>>>  static void print_allocinfo_header(struct seq_buf *buf)
>>>  {
>>>       /* Output format version, so we can change it. */
>>> -     seq_buf_printf(buf, "allocinfo - version: 1.0\n");
>>> +     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
>>>       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
>>>  }
>>>
>>> @@ -92,6 +92,8 @@ static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
>>>
>>>       seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
>>>       codetag_to_text(out, ct);
>>> +     if (unlikely(alloc_tag_is_inaccurate(tag)))
>>> +             seq_buf_printf(out, " accurate:no");
>>>       seq_buf_putc(out, ' ');
>>>       seq_buf_putc(out, '\n');
>>>  }
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index af343ca570b5..9c04f29ee8de 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
>>>        */
>>>       if (likely(obj_exts))
>>>               alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
>>> +     else
>>> +             alloc_tag_set_inaccurate(current->alloc_tag);
>>>  }
>>>
>>>  static inline void
>>


