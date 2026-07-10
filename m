Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2E0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40626B00AF; Fri, 10 Jul 2026 06:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0576B00B0; Fri, 10 Jul 2026 06:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFBD6B00B5; Fri, 10 Jul 2026 06:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 727316B00AF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0062040416
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:04:44 +0000 (UTC)
X-FDA: 84972432930.16.7FD09A3
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CA551C000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:04:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KAOHNKjB;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783677883;
	b=aAEcziMPiWe8wJFQQZ2mhsUAuFtrVS/IDEBgNflHwHkBRIQnTQx885VGEgUD6D9sCteLr7
	tNTA8qYkfck/HJJwClA5//vU6VhQvQ7I16WjZRy30HW8pOxFhofJvnpfHDe56LFhgGebah
	K+D6qysJwqwABjva2rHUDUpdF74jOX0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KAOHNKjB;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783677883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myL3E4LURnOhpDjDCaKjpNj79ZKyqlfQLnc/0/n7x1Q=;
	b=kpsXcWd8cvSOtX+66kiqTcTjiFVzxMhYl4tNUXpkpe3SLbVasmzAlPclFHW9RUQoNbLWf6
	AnlOvjGSrugmgjSkvr2may9baArVnMGSo9CeC3zLJizYvpV2PvOv6C8DcdsT9K80GDntfZ
	ITPT+HlzNEehBgpwrLO25z2I5gzfyBk=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso716339b3a.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783677882; x=1784282682; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=myL3E4LURnOhpDjDCaKjpNj79ZKyqlfQLnc/0/n7x1Q=;
        b=KAOHNKjBtPFYpnYq8563ambztLOAQpceEUifJWT+jh+ir4uODajPDGCUepyaipSN8c
         RdbUjgjujj8ugS7cAFO3JNKJ6a0dBfVzGhx1QERRkbDmouGZ6f/0o0qYvLoMEM/c/Tf9
         7yLo0s6XSfW+66J/iJ/98La7EmkfbgqRtuUb7cFjhxT+YAO3CQplyrar3zR6y2MgkAWi
         EUM+iMB5hv3eUf5hwnbVL2FmWV6E2Fcs9EvkLGasXi0sp4Z0lrEY2dwkSbLRRzfe6hYC
         fp8PHiGUtL59ELi6AET8swfdDQAOH7SMIXEIEdQ+X4WIlpkHAsX5sC+kF9UEqMHte49E
         9zjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783677882; x=1784282682;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=myL3E4LURnOhpDjDCaKjpNj79ZKyqlfQLnc/0/n7x1Q=;
        b=sr3Ggn/AGRUgKD22106Iiijmqaj1H0HBAedAuOew2m18E5bxc/nBjv0Z9ALbzoaFzO
         sEeEeLImJ3rO0SBTwGLu8EDzG28A71tA9+0wmcRS8m3qaurBXJM/oaJ3ycO4fyjWI00a
         GVEkW24OG0ePkx24UoMDbMLzgseq7fuW20kYYYP4xmxFCOlBWqOwFIsn4OcyrNgMNVTc
         5xiWyj+YQ+DMYfQ7k+7Yf05UrtNk4VGvsBqwNUbzaJfNsYVv09JwfHvAhiibohyfgqc0
         TfTIIYnAHbukgaA0hLv34Rw2aKyMax+BwSy/IE+D5QhhRomkOWNcK7n/ESPLakbdF+ME
         C6XA==
X-Forwarded-Encrypted: i=1; AHgh+RoeyYkR5R35soGB/vGBQVguZQRWh40WgG3rGFz6EklWVoUYQ1qBcNv7XOg2GQ4sdW+Gm43M3QjdeQ==@kvack.org
X-Gm-Message-State: AOJu0YyOBg9HBjszEqzW4LVMOBZAcynTqObp9q2cNwOXwforon2D/2GJ
	ZJUkx7ghNIuzAIYAVQJ0hTr8ZoTH1snlWbKjmMDYtxoONC0eQXAkEFTX
X-Gm-Gg: AfdE7cnyOPJ74adRQYv20asr25HCXMI4cD2IoT0Trr3zja9F/mQr7MggudcY0mZXtcb
	iSjg/jwiNelz7tbMJX/rcQWYI0WvxYpaLd4b+nYabWNv4A9mkzmTvcYmoUi18kHIUjU0aLLxrgD
	BN2k1JiPBTU/bI1o760xGT10X5+7vEcPCXMhyQm8IpuyNzxBqVO/uzZDVEoEJ4zHFDNbU6DyO1+
	hDYvbq72s6OMQT+C4+QGn0xT7tQBAiX/kpOWgr02oxb9PPgzvWDHX7cmQF42ARnuzjZ8FQnz+Ur
	FZYRnxzIYiI/H6nVWx8NfXmbuDbXeNO1dBylrdZGVT883Cya6z/c6VnqCZiaCJMiGDhzPI+FTVK
	3v+FWclgIBvsP/lgjnSv+uFrkFl9GKZvnC9tOkaT5Nl2F3GvoOfvIYjY9IE5trLdQ/7ZCVFnwfz
	9M2Kc5hJce5HAtlBt272HNGAB0VHf6w7hCXg==
X-Received: by 2002:a05:6a20:12d0:b0:3b4:6f7e:d0f4 with SMTP id adf61e73a8af0-3c0bce18a95mr13340629637.15.1783677881818;
        Fri, 10 Jul 2026 03:04:41 -0700 (PDT)
Received: from [10.125.192.148] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca75ef0c30dsm3257653a12.17.2026.07.10.03.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2026 03:04:41 -0700 (PDT)
Message-ID: <30c8df43-9464-8fa0-3614-0ca06b97862e@gmail.com>
Date: Fri, 10 Jul 2026 18:04:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com>
 <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com>
 <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
 <4ec2bd64-af40-8ebf-b8a8-2dd7421a1100@gmail.com>
 <5ce4035b-7f56-d1d2-2d2a-668446d870e8@gmail.com>
 <CAO9r8zOLe5eJfNmoszCX3rtD=6YEa_7xrvDV1acVDOtZg4vWYA@mail.gmail.com>
 <bf14cfe5-e98e-c20a-231e-37b3a2489040@gmail.com>
 <CAO9r8zNzRWxCvUok7FJTZZOp6pS9D-Qdrsbi10rLBn4QRhw81A@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zNzRWxCvUok7FJTZZOp6pS9D-Qdrsbi10rLBn4QRhw81A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1CA551C000A
X-Stat-Signature: h6jy6rc45g9gdrcwadpnzty6b9yeg8cj
X-HE-Tag: 1783677882-547177
X-HE-Meta: U2FsdGVkX18XnTaINs0CdtnSHo02PNGlF3MAtmkRLpJiY/69NyueQAGv1/K3Xwyiet9luBbJOcBAq2RtkSDeBVZHPN9vZo11mII8jJ4kugfXV/lHEZkPSdczZZvz8VqI7B/TSolOTvmJUaucfsAd4wpzPm0wgf3m/xdw/Ie7ipZvLZdi/RCxIZ328MpAs8YnUyEqe4GMn2HlNMkODH5pJl0th+jltFxtMmTD0GJYcnY/X3Gp2FJxO5uNHsfDU4pDv9s72F9GkApNTJliUYGG0fx6qdY8azggKZgOB1atkp2xLq8pNQyFp8TTiSwtQfDg0vygMt8Rd2QqZsg5m7FN3MMFfw/wUUo4hRG3iEL3AgGW2Ih+LX36GKQRGbHTv5d23cENJyqFGkp6tH2wRDgqBs08wxSIvnTg0X2E1iakEouu/xiALzJwnHLOCT7epB86jnKm6yuoqrMse5bmJntTl19ZGKwhgJCSx5CT9DHFjo5W3NuuuBXHeVaErLhUcj9+uW667H40/1f/ZZr8BoGlpw1H4ahssErOBPL+hRvmZ+oMAkQkURdtI4zmzuFlxmxiNdM5VpUo93tnGnzkStTW0G5c+gtqkdls21rxeieUyH55XyT/c0c+XyOQ6bagEXX5drjCQCQ3qKbWPif2m4mRg/64VPfT89t9QADEt9yvToH7wgN888AAp4K96wVBVx1U5bHdHNpYaJ68DAMSQ3Ua/x8BeQCTkiwie2MP/aU9a0NFq5Jw4Ph24svZj+qeq62B4vBuywKaQQiRNoeI4fSwoWquBYXqGaU0xlAM7jgN6325xLsPsJG5HaAtd7S5rDlj9Hae5fpSxlIslUeph5i2hbcgvs+gSdw0807yIlgRh/5fD5G6HeC/CyVmJVLkAbiWaW1SK5p1kZlxMa3U0LXWAnCHXs+ErOB2O1UMldGeoww1NOb1gTOlwIaenaPEfN0QdD+RzuXjJty1poM78OA
 D+t6s0ZB
 9QBkW9+BNZx6+9uHTSfYr0AA4Zn3Ar0zTZzY6MtFsOz5oEIVO/Fb+4Da64WoY6YtTIE7B+fYtDIqsvltBsHOp4h0UivAbTsHWqIeFbVQJWP/QkTr409nIws1eZoJ+tH1CKBiXGGXQPuyXflgTzLVtgjn1MKpktpPsIOa36Y/Xx9ozYEDNUtuap4yxcGL0jbCw5O+4g4c4bsmnTyxvxlIbG0C0DPefnRN5TphoJ6CIPuuxwbF5vXuTChZEcd7LUIwgWXJTrP0C//r+1DLQx2pi3t/epxGxI1MPDv5tmchAaDGJ0U4cfO9hRkZSEG7TChcYo7oCHEKAtljGrHx4YEqhlIezpGwSL1/qKz2I3x1IrvRQ6sTCgQfuze/CyG+bC4HIfsB41bYOdEVnOXeSoSYtRGxagqBQbbxnfWVEi8ykFKOzmrwq4mS8dwr9FoyW71K5HMDZFWBmAtwfokDt/5rHck5AjQY4PYMVWnmNem57UAvLCe4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/10 04:44, Yosry Ahmed wrote:
> On Wed, Jul 8, 2026 at 7:15 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/7/7 03:33, Yosry Ahmed wrote:
>>> On Thu, Jul 2, 2026 at 5:32 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/7/1 19:45, Hao Jia wrote:
>>>>>
>>>>>
>>>>> On 2026/7/1 00:10, Yosry Ahmed wrote:
>>>>>>>> Before going through more versions we need to figure out if this will
>>>>>>>> pivot to be a proactive demotion interfcae for swap tiering.
>>>>>>>>
>>>>>>>
>>>>>>> Yes. Should I drop patches 4-6 in the next version and wait for swap
>>>>>>> tiering to be finalized?
>>>>>>> We can try to get the non-memcg parts (patches 1-3) merged upstream
>>>>>>> first. This would also give them plenty of time to bake and catch any
>>>>>>> potential regressions. Thoughts?
>>>>>>
>>>>>> Patches 1-2 can be sent and merged separately, yes. For patch 2,
>>>>>> please include some numbers for the writeback performance before and
>>>>>> after batching.
>>>>>
>>>>> I'd love to collect some performance data. Do you have any recommended
>>>>> benchmarks for this?
>>>>>
>>>>
>>>> Perhaps the following test case could work?
>>>>
>>>> Test Setup:
>>>> - Total memory: 32 GB
>>>> - zswap settings: max_pool_percent=1, accept_threshold_percent=50,
>>>> shrinker_enabled=N
>>>> - cgroup constraint: memory.max=1G
>>>> - Workload: Run the following stress-ng command inside the cgroup for
>>>> 120s to
>>>>      continuously force zswap store failures and trigger shrink_worker():
>>>>
>>>>      bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>>>>      exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t
>>>> 120s -q'
>>>>
>>>> The following comparison results were collected over multiple runs via
>>>> bpftrace
>>>> and the 'written_back_pages' sysfs interface:
>>>>
>>>>                             Baseline         Patched
>>>> ---------------------------------------------------
>>>> shrink_worker wakeups       5,587             878
>>>> shrink_memcg calls      7,823,853       2,347,320
>>>> written_back                  257         781,214
>>>>
>>>> Conclusion:
>>>> Under the same workload and duration, the patched kernel shows a
>>>> significant reduction
>>>> in both shrink_worker wakeups and shrink_memcg calls, while successfully
>>>> executing a
>>>> much higher volume of page writebacks.
>>>
>>> Hmm this is actually a bit concerning. Yes, we are invoking the
>>> shrinker less, but we're writing back *a lot* more memory, orders of
>>> magnitude more. We are using a batch size of 64, and making ~1/3 of
>>> the calls to shrink_memcg(), so the number of written back pages
>>> should be ~20x more, not 3000x more? I think I am missing something.
>>>
>>> Also, ideally, the batching wouldn't result in significantly more
>>> writeback, but a similar amount of writeback over less shrinker
>>> invocations. If we are writing back significantly more pages then the
>>> batching logic is probably too aggressive?
>>
>> Apologies, I think the test I constructed has a bit of a problem. This
>> test has very, very heavy memory pressure and is already a very abnormal
>> case.
>>
>> The zswap entry returns the first time because of "second chance" after
>> setting referenced to false. For the baseline, it scans 1 page per node
>> each time for 16 loops. During the test, shrink_worker() basically exits
>> at about 16 pages each time.
>>
>> Since stress-ng periodically and randomly writes to this 4G memory, it
>> keeps triggering zswapin and then waiting to zswapout new zswap entries
>> after falling below the pool threshold. When the speed of zswapin/out is
>> far greater than the scanning speed of shrink_worker(), a large number
>> of zswap entries cannot wait until the second scan for writeback. New
>> entries are stored on the zswap LRU list again, and the referenced of
>> the new zswap entries is set to true again. During the test, it was
>> found that 99.21% of the return values of shrink_memcg_cb() in the
>> baseline kernel were LRU_ROTATE.
> 
> Hmm if I understand correctly, you are saying that the current
> upstream code is actually failing to writeback when it should in the
> previous test case with very high memory pressure, but it is with
> batching? If that's the case, I think it's actually really good data
> to include. However, we should make sure that's what's actually
> happening. If the current shrinker is not keeping up and failing to
> writeback, we should observe:
> 1. shrink_worker() hitting MAX_RECLAIM_RETRIES continuously and bailing.
> 2. zswap usage consistently remains at/near the limit, and not going
> down to the acceptance threshold.
> 3. zswap_store() failing to accept pages and the pages going directly
> to disk, causing an LRU inversion (hotter pages on disk, colder pages
> in zswap).
> 
> Can you confirm that this is what's observed with the high pressure test case?
> 

Apologies, my previous explanation might not have been very clear.

For an entry to be written back, the shrinker must scan the *same* entry 
twice: the first scan sets referenced to false and returns ROTATE, and 
only during the second scan can it be written back.

If a swap entry is zswapin'd between the first and second scan (meaning 
the entry is no longer on the zswap LRU), then this swap entry will not 
be written back by the shrinker. Therefore, the second scan must occur 
before this entry is zswapin'd for it to be possible to be written back.
So, if the baseline scanning speed is far slower than the lifecycle 
speed of the swap entries, it results in only scanning once. In the 
baseline kernel, 99.21% of the return values of shrink_memcg_cb() are 
LRU_ROTATE, while the patched kernel's shrink_worker() scans at least 64 
* 16 entries in a single pass, resulting in only 58.7% of the return 
values of shrink_memcg_cb() being LRU_ROTATE.

              Baseline         Patched
---------------------------------------------------
zswapin       929,096          281,196   <----
zswapout      982,731        1,058,746

After modifying the kernel to remove the "second chance" algorithm, the 
test data of the baseline kernel roughly conforms to our expectations.

Therefore, the constructed test has a bit of a problem. The second test 
case in my previous email can ensure that the entries on the zswap LRU 
are relatively stable.



It is worth noting that the capacity of the zswap pool will not remain 
constant all the time. Since stress-ng periodically writes to and reads 
from this 4G memory, accessing the pages in the zswap pool will trigger 
zswapin, causing the zswap pool size to decrease. Other pages attempting 
to zswapout into zswap via zswap_store() will fail (until the zswap pool 
size becomes 160M (accept_threshold_percent=50)), but the zswap_store() 
path will wake up shrink_worker() to try to perform scanning and 
writeback. Then stress-ng will continue to read and write memory, 
continuously triggering zswapin to further reduce the zswap pool size 
until the threshold, at which point shrink_memcg() will also stop. Then, 
new zswap entries (with referenced as true) are added to the zswap LRU 
again via zswap_store(), until the zswap pool size reaches 320MB (32 GB 
(Total memory) * 1%). This process repeats continuously during the test.

Thanks,
Hao


