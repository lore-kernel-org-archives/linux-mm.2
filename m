Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D63CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730AF8E0003; Tue, 19 Aug 2025 06:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708368E0001; Tue, 19 Aug 2025 06:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DC88E0003; Tue, 19 Aug 2025 06:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC2E8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:44:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8A9E1DBEEF
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:44:58 +0000 (UTC)
X-FDA: 83793174276.02.B2AE0E3
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5F8418000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:44:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XUKjU8Rx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755600296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMaZ3A2hVT9tVgIVgNmHrlX+dceLWmSqJc0nzB1+rP8=;
	b=QpVViLSAKIt7WaEPdQb9UpnDylBi1ovK5jpoxOT/CCbjzKe64o0tATNXdLuLStY28Ko9F6
	QmggZnaoH9tZBMabyVdjJNoJL1ISHPL0+OJ6zXionIwqOqhnanp71YNj4wzJ0Xv9jMyV36
	/twrUqVXNGqyvRzPEakODbhhHHSDn5c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XUKjU8Rx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755600296; a=rsa-sha256;
	cv=none;
	b=oSIo7cfot1w0OTXPx+JRCgBMsjOd1eYbYw1N9c+E/NXv+BzqDGM14QCmHNrIqnqJGyWQ15
	aD8wCtvvalJn2pAQudaEI7XvVnVP5fkfa2yzMjtFm7Sq2WoFtXR4XlILqPcZs+PI7auTah
	FNYacENKELltQBpafT/gx8JAmRuavqo=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b916fda762so2895120f8f.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755600295; x=1756205095; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gMaZ3A2hVT9tVgIVgNmHrlX+dceLWmSqJc0nzB1+rP8=;
        b=XUKjU8Rxu8sz35x7RoIeL9DTrdor0xaY75TZndc/2oO/G0z7JRF6GXV1V1H2Ueb+sx
         VGgul2rV/guNUa/hbMNGWqRigoelEcJOLZsMGVIxMvLVYW6gMhse6HVMi4W4fsRq8dTt
         y3CtnR+3Sx+znJecXhnd9hszdi7pbOBkYBEVD0GyT0LCeaACI7ZAZAS33OSxU6aqBHgW
         vyTND+zI8JOKeScw2us3YsCO8OnhfS8MfQBipLwNv+AViKNKGpCsT/tysdI4vljZig22
         sLwUSUyfVY29HNXQw/bbdR4EpsqUcwJr6nsqkvpNAZuaipvKnlv9IYHGKLfUKeNCBZIV
         pY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755600295; x=1756205095;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gMaZ3A2hVT9tVgIVgNmHrlX+dceLWmSqJc0nzB1+rP8=;
        b=aS8MJyN6Hjk6e8M0VW/lmlE7h/t+vXW6wqfJG3vYoySxJHZSo+8O6S3TaUCwUi8lxd
         +idOhPqidGXuJH3eWZHTxuUvFpdTaK9h9KecYyw2gAUovZ51hQ3rq/ACUgJA9Vw/CAxf
         Q4rTL5IK8zRFU6+l3YZjb0BhbXUAZMoh7v9NHS115g98CdLneuN39uRqp6LMyS2T/GC8
         R77CsySVpSfig6C74x8zzwQor/O4ZFITTeczjKQnzoSpGECOOjMbF2mIslroBYIoVmUz
         K4vfqvDUw41gpS/AgA4JCEijecGWA1ycq4BVtUOXS4kQLgR0SNMdkgQN88P98NTXPQ5L
         8Irg==
X-Forwarded-Encrypted: i=1; AJvYcCVOlqApdQyvSpx7V++ZgC9JqHlmhDcBMw+BCWnl82co89D3aPReZoV2e2YU1ucpyzeYAYmuaAP9cg==@kvack.org
X-Gm-Message-State: AOJu0Yy0UosQwsd3eOpz5zv3s85QhIy2pY5hmNF5QberQwoXmcJZTxOo
	AdSZVIjJN2yLhhGqtWjqlwGZCmmdKuiLOBHq41Lcc9buDW027kb/iQEK
X-Gm-Gg: ASbGncuJwm9XVTlgFEXak/fblgxXXL0EfiXQed0uT+w3zZ+FO3Fjtq5xU63FF5dNs2U
	QlEFAlK4IwvNWP73Lfiy7ND6kPLUWo2zA1BNLgbft6j6gZEFphHEvSVvGNQ+w84FjdDph++Vn4m
	GShNK1g1WeWi2z0jErg1PJmCc1swSPBtcngprbGdY6w8cgw7Pj9C8ApkuYu72J+IByHQ/IBETDo
	1fEkusGm2cv5Rc7gcVeb2sdxOsBS0Vaq8f0eoL+S2L/pjKKuG246bherPeSymFOwOP4n0/Ajx9M
	ChJ4STreHAm7I6eVERgWb22alQnuIombOEVVKJv6pkgPHtTOgfP24qmDpGZXCVAQTdQSXhIwmlO
	3j1jNIEqiN9U+3bpEzLffFF128tZ+EDWDCtXaS+3oYyLPmUp9U2nrQybZcTy4P83DYf+Twfs=
X-Google-Smtp-Source: AGHT+IHdKswvM0sTBgUmTLXm9h0m3Bc+fhe+XtbKt+QKbkIQIKsCxnlYFb6o6RmzK4zKcJOPeYGaGw==
X-Received: by 2002:a05:6000:2dc3:b0:3a5:8991:64b7 with SMTP id ffacd0b85a97d-3c133c6de96mr1675962f8f.26.1755600294982;
        Tue, 19 Aug 2025 03:44:54 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:ba2b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c6cd044sm220915995e9.9.2025.08.19.03.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 03:44:54 -0700 (PDT)
Message-ID: <a24d632d-4b11-4c88-9ed0-26fa12a0fce4@gmail.com>
Date: Tue, 19 Aug 2025 11:44:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 mm-new 0/5] mm, bpf: BPF based THP order selection
Content-Language: en-GB
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com,
 willy@infradead.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, ameryhung@gmail.com, rientjes@google.com,
 bpf@vger.kernel.org, linux-mm@kvack.org
References: <20250818055510.968-1-laoar.shao@gmail.com>
 <36c97fc6-eaa9-44dd-a52f-0b6bf5a001d9@gmail.com>
 <CALOAHbAQ=51mfszBN+Bvb9z+ZDyTBuCW_s0EKi+5rDghFvRZzg@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CALOAHbAQ=51mfszBN+Bvb9z+ZDyTBuCW_s0EKi+5rDghFvRZzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5F8418000D
X-Stat-Signature: 1yw6aszj8f73nqzuqih1ig4ktahp3fxf
X-Rspam-User: 
X-HE-Tag: 1755600296-953726
X-HE-Meta: U2FsdGVkX18mhyRh6+An5lN1DKuk4ocbVGg7bQ5fPL8NPRoQVdQs4cgirdjWbZ1GjZiuh6fsj6I0RjN2Xlmfbn9FgOEOg1EiXkek8SpGUPNuJAXm26F6RDg9pQ2maOIMuWHsqi37+qMw8Wzpwv43u3UgWD0qf9AJOVJDCGNngKg+6KKJ2gDW5SXpd/qFjwco/pejZEDhlR96LzRwvm0W4gjh+PLrqVL2pAOjZLyJuXfIORqlIJQdxA+w8SRAyqjZy/aii+0iKHitmBTRczIPW/ZbAlUe/P00PVy3ZF3fWUoS6joYPNSK7H8V9goX7MVnK+3DC24HKmWqc96eunRq35B09iBL+IWdxjjyCzjRjIROsRbj7I7jrs+AQZSiSjvD6QsbrgtThPOgLEb0EjOqUhjBn2LdQ03DGgTpDdqKvasMRcPBgQjTm6WCGORO1Ikrf3IgQdPJ1vnAm14CQ8/M/QPW160xoIlvxNR0Nrk4vI7qarj4bIF01xoV3j+M1L6quMZWcsr/fbSIkgvAnSuSWm6z1pD720bMd+scBSmMqr/ID1Dq49ZITNGCIGstugZSeXRGs0leBKPptlJLqpbZ7Pbq5o5huAptjDi4Iq8+KaOBasTvts1yMrINinjvhrgqhfX6vu940CJRAkCdKBcC0bODndiDVLHU712LGT7wW6PT7QNpGvCt6xzfMree5lDMKuao0oxOJF8awHbHsuuwCnHaFdDH3WWG4TIEwSBQ8i2i+BRONUNmKHrSsllbcGK5twEFapVyRRujpEJUdZ7Bdk5CYOElPXnHcnrdS3ZwcofwNa7Cyhr20CYP+K4zONCcO1agf+LHKk1Oj2df0kjmrhcJjXrQaaWbSjzr0XAagu0FOXu2kUrirnsUOi/aNJOLDEvktAiaQptgtWJfq0YpSJkJLUFlw1HdigE7iwFmybMSqDWJkNvHYYypTpKuN8sTOBFz+U5DzRnNOmvbkcb
 hLRCzSq+
 FvoVLLr2wx2+q/RjWB7KyVped7vLgLz1qQLjtLyX2Gv0pm3oLey92Lt40FoWbm8datSw3VDGx0m02wL29h5x9DxgbCWqV3n5gLEkTympowTezk1O0h+3uuVg+cH0i6zYL89UWujRL0MhzKZmdhyBYni5xaUDE4zm3oNHF/7MRxyzDQrfb+vz3EmMPyAbvDrO8XwZ7HBrdJZiBPvjoj7xH+LO9maQ0k7N2yzvaQ433g9C9Eu4Q1Af+9jQwNewjbSk7g3sQAS9lnaieB8KpCDLoJXF+c8OwsiO9bxzIGlYPLThR3DaHYGtfNGJouUDITAaecK3+MHRkNgLEO3nlg7EnpaLTTun2JMiepKacwIi75hUPtvOONpddFkWjROZ2Y53LiVZOo0STRatWxRr9eyDMfbD/vQ7groQ1nfMJ6w90/y2XPcuZLJucMtWCcvS9p91vooCGdSAdljcAOZzykqw9wcCcIGn2/YwAwFH2VOUOlPK7kzUrKR+JPN8C+pKSGaUJSFVwISpswYRfDMuxgZlo8qy5+u+4+ctNFCRmwLshIL+2hppbLD3knc+3UjXLoxP4DEzi36Fwbeu8Z5MfPP+Up0SD5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/08/2025 03:41, Yafang Shao wrote:
> On Mon, Aug 18, 2025 at 10:35 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>
>>
>>
>> On 18/08/2025 06:55, Yafang Shao wrote:
>>> Background
>>> ----------
>>>
>>> Our production servers consistently configure THP to "never" due to
>>> historical incidents caused by its behavior. Key issues include:
>>> - Increased Memory Consumption
>>>   THP significantly raises overall memory usage, reducing available memory
>>>   for workloads.
>>>
>>> - Latency Spikes
>>>   Random latency spikes occur due to frequent memory compaction triggered
>>>   by THP.
>>>
>>> - Lack of Fine-Grained Control
>>>   THP tuning is globally configured, making it unsuitable for containerized
>>>   environments. When multiple workloads share a host, enabling THP without
>>>   per-workload control leads to unpredictable behavior.
>>>
>>> Due to these issues, administrators avoid switching to madvise or always
>>> modes—unless per-workload THP control is implemented.
>>>
>>> To address this, we propose BPF-based THP policy for flexible adjustment.
>>> Additionally, as David mentioned [0], this mechanism can also serve as a
>>> policy prototyping tool (test policies via BPF before upstreaming them).
>>
>> Hi Yafang,
>>
>> A few points:
>>
>> The link [0] is mentioned a couple of times in the coverletter, but it doesnt seem
>> to be anywhere in the coverletter.
> 
> Oops, my bad.
> 
>>
>> I am probably missing something over here, but the current version won't accomplish
>> the usecase you have described at the start of the coverletter and are aiming for, right?
>> i.e. THP global policy "never", but get hugepages on an madvise or always basis.
> 
> In "never" mode, THP allocation is entirely disabled (except via
> MADV_COLLAPSE). However, we can achieve the same behavior—and
> more—using a BPF program, even in "madvise" or "always" mode. Instead
> of introducing a new THP mode, we dynamically enforce policy via BPF.
> 
> Deployment Steps in our production servers:
> 
> 1. Initial Setup:
> - Set THP mode to "never" (disabling THP by default).
> - Attach the BPF program and pin the BPF maps and links.
> - Pinning ensures persistence (like a kernel module), preventing
> disruption under system pressure.
> - A THP whitelist map tracks allowed cgroups (initially empty → no THP
> allocations).
> 
> 2. Enable THP Control:
> - Switch THP mode to "always" or "madvise" (BPF now governs actual allocations).


Ah ok, so I was missing this part. With this solution you will still have to change
the system policy to madvise or always, and then basically disable THP for everyone apart
from the cgroups that want it?

> 
> 3. Dynamic Management:
> - To permit THP for a cgroup, add its ID to the whitelist map.
> - To revoke permission, remove the cgroup ID from the map.
> - The BPF program can be updated live (policy adjustments require no
> task interruption).
> 
>> I think there was a new THP mode introduced in some earlier revision where you can switch to it
>> from "never" and then you can use bpf programs with it, but its not in this revision?
>> It might be useful to add your specific usecase as a selftest.
>>
>> Do we have some numbers on what the overhead of calling the bpf program is in the
>> pagefault path as its a critical path?
> 
> In our current implementation, THP allocation occurs during the page
> fault path. As such, I have not yet evaluated performance for this
> specific case.
> The overhead is expected to be workload-dependent, primarily influenced by:
> - Memory availability: The presence (or absence) of higher-order free pages
> - System pressure: Contention for memory compaction, NUMA balancing,
> or direct reclaim
> 

Yes, I think might be worth seeing if perf indicates that you are spending more time
in __handle_mm_fault with this series + bpf program attached compared to without?

>>
>> I remember there was a discussion on this in the earlier revisions, and I have mentioned this in patch 1
>> as well, but I think making this feature experimental with warnings might not be a great idea.
> 
> The experimental status of this feature was requested by David and
> Lorenzo, who likely have specific technical considerations behind this
> requirement.
> 
>> It could lead to 2 paths:
>> - people don't deploy this in their fleet because its marked as experimental and they dont want
>> their machines to break once they upgrade the kernel and this is changed. We will have a difficult
>> time improving upon this as this is just going to be used for prototyping and won't be driven by
>> production data.
>> - people are careless and deploy it in on their production machines, and you get reports that this
>> has broken after kernel upgrades (despite being marked as experimental :)).
>> This is just my opinion (which can be wrong :)), but I think we should try and have this merged
>> as a stable interface that won't change. There might be bugs reported down the line, but I am hoping
>> we can get the interface of get_suggested_order right in the first implementation that gets merged?
> 
> We may eventually remove the experimental status or deprecate this
> feature entirely, depending on its adoption. However, the first
> critical step is to make it available for broader usage and
> evaluation.
> 


