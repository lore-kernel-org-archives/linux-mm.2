Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16DFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 06:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7D96B0088; Tue, 14 Jul 2026 02:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88EE6B008A; Tue, 14 Jul 2026 02:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DF06B008C; Tue, 14 Jul 2026 02:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 756BC6B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:29:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0590D1C0217
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:29:35 +0000 (UTC)
X-FDA: 84986405910.27.0963CC8
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3090F80005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:29:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hx0UY2Yf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784010573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5q6gfBBfOjUS6i3fiduNPrbsndG/x1Ykm2ieMz81Cg=;
	b=TLHPuBb6rWvsmDKiAnaaZwlef72/DBsRJ1WH//w+uP0oDGTDtqGBdFRXmwppeZeJ/XjoqE
	pwWSDd254rpw7UkSgXnryPmS4vE0LL7jsAqNVAZxq+hFcl5OMd4E2koeP7R+mz6uN/lk0E
	o24jzg7Dzk2UqH+lcOw69zHn/TGdoeA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hx0UY2Yf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784010573;
	b=UiNse94XGVPqUzsYOmbB15FTFjOyMxTGV+iiLQagDx1QQCuoEUwsMy+tM6pjApFOjQVkaq
	f++A4KBxBd5dsa/5eCT6NGT4XOZo6chG/WuStf3yn4ylEEsVAU/LOI4Wc60CnO+p0sDHSY
	awhg4UhHAAmzuQKdX16hR2pDtB4/vOQ=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ceae1ed204so7013255ad.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784010572; x=1784615372; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=w5q6gfBBfOjUS6i3fiduNPrbsndG/x1Ykm2ieMz81Cg=;
        b=Hx0UY2Yf7wcNTgKlAa1WLMR/vK47QT3D27IzMAp48PolXzZlaxykO1MWH4/SmK2c2A
         6pFOQ8NqO0Bk8DNfX8AA/ikpOzmn6G4VpUg/6vZxG0k3Wov2tXYi8BaXcqnLmAlX+MdY
         9XeIvOggK1jUDNoTojS7U0TbY4N9fs+cqp/Tcu1+v32p9LvFefjMCRX2O3Eq2zTlJNg9
         qD1NxlzFmKk47q8Hwi1gIHLynnJ2u7Ut3/WNyNe957bid4ZNnFdP2DyWtacf849fIBnP
         3o7JcJio9AXXD6muW3tlZnTm5TREjAQmrtHT7qig6ZQ2ffxR/h0rrhzFWM741Wma11z5
         CczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784010572; x=1784615372;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w5q6gfBBfOjUS6i3fiduNPrbsndG/x1Ykm2ieMz81Cg=;
        b=k/l/OluCWvwYbEoXuC/9fgeaIBW/0WcTQLhLCh1lVP4WTJnRrspTAx05oepcZaDK/O
         hdLMCIPJ2Iskao9F+vJDGLq6Em0ou/VqJKK2XyXH83dhqX01frhszia5XjipJHjvipPq
         nqujdSwUX+Pn4LyIslhmnqqgf75qJWDHDfg5yua5sA9x6cYcJSNxaZsR6h97B/YJjIsB
         nGagriFemQZLEYRmoJ6be5/zjBgymlWX4cR/ntTv7tZRwV9I2ziVXA7mKVVhWgq4fz7u
         37YJUxsax4ncdGQ2IUwLfUC/b4aT9pmO2aMasO1+llSoAisCAamgDrbb/ExFA2q7xTU6
         79FQ==
X-Forwarded-Encrypted: i=1; AHgh+RoWNBD7qF2f/n7m4YPjNa1t3z+PUUoXUCkx/vlfvnuIYqbtGSd2//mSVTBvIBgXOEoLTc7DpCpYsQ==@kvack.org
X-Gm-Message-State: AOJu0YzYJ4bODIBTZo67xQP8Y9a0EeLTQmOHcWbcaUBdObqKQqCrtd+c
	E7FRgx9rG2KtC7XYGZzl4q4O8BjMSp4Vj7DIN1O6l97lhqQLoS4RCHoz
X-Gm-Gg: AfdE7clKGlI/Hop1AXK05xRj1Gyq6Nq3My6mKJ12RaNX7tiXn649Pzya0KwE49x4PrF
	Apkho9CHVQqlISYX0aZDN5ZDMGQ7JrcWEvVNJlHu17EbgjY5uRz8H5iaXz+2KMSlR1Q9oJTyk8M
	oCSBkW0byGAjgeM+pw+n6IbJcLXNCfmymz1M/rzNxpFoVOOXiWmDO3Htz7di5Fa7EFf1jX3Unhu
	Qqg/10lgsdZLsXK4/QUNJPYWM2MB4vp04/qX8HKiOV3AevJlSfdK8u51QPCC5LjdZTN6Svevnc3
	yEJgOCW/eqMb/TEgCQvasTU2IrnDPvIlDVyBiXSuODxIGYS+YQORYpdU/fQYzprmUvS9XvW+nEV
	tN7P3MsMxagHqxYRHoPWX4MQu/pqDCxN2411Wh43R7Xg6t0at1qNx59utcXjjB9LT7Cpq8kxhIQ
	k7Jpzc9xCuVhahiVYpyupI0AWziq+eVGDfag==
X-Received: by 2002:a17:902:f683:b0:2c9:97a7:f543 with SMTP id d9443c01a7336-2ce9f1789d4mr105975955ad.41.1784010571982;
        Mon, 13 Jul 2026 23:29:31 -0700 (PDT)
Received: from [10.125.192.114] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccdf808379sm98300195ad.48.2026.07.13.23.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 23:29:31 -0700 (PDT)
Message-ID: <4b85fb73-73fb-d08d-e218-0eb34c6f90e9@gmail.com>
Date: Tue, 14 Jul 2026 14:29:06 +0800
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
 <30c8df43-9464-8fa0-3614-0ca06b97862e@gmail.com>
 <CAO9r8zNu=JPZG4be9beJUdBEGRgX6YaD_cpZw2P8WieDY=c06g@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zNu=JPZG4be9beJUdBEGRgX6YaD_cpZw2P8WieDY=c06g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3090F80005
X-Stat-Signature: iaszuwm9b1kcexgfwbdoopjzs8x1rzrg
X-Rspam-User: 
X-HE-Tag: 1784010573-713484
X-HE-Meta: U2FsdGVkX18T52WWP+Ail7Mjpn6Kb6WKa3PIVtcD2J8TsuPU3/1/CIrA1j1463QT50rKrb828UtAmEevoOppPvHWsNP3NTIGgOiUvDyC1xYkoEB8ixALB/HfCEGgtqTDu5GTPXSxNTJO7KAAdlOYlT70gpitIJ89nRF8XD1PgBBIjzooVV1F3mpxC6zUj2KShWC0VusjhCxOGJJzfSwy8FxjL42BzGe2rsv4z7VDxhBKcpFfAvGNLt09yVIKWYBAy1c5en0Os8agRGKr1SBF+bHmsg3qfpjNDgAwV0tL1OCAz9pYtjfUTjLzxyk8oIEnKnCnD20K4D1XnlIBVAWoW/RDuzcHiuca7SgPd6vxWjvxc/t2PtPGyAViwHMO3dA8fuukIhcHfUIyNYJI0/ST0IeJ4VIdHNZs7WsC84NAXKeb/6yo04WTiXmJrnxPAzel9RJ9Ktc/SEsiqsK9wsoTf7KsUK2ERRJYWXSAwvz17jeE03xWIhOCMqJLbYWNI7SsznBG4O7qmjrQBdvcBRG4ZMaPC+TCqsqjQIli7ffPw1UIUxlSLlcqSEBnExTR9JU8SuGhrhVX0QXdm3B85RV4hYMAIDmnVN4SFbysvZUVliGEJsVV5YQtGDF5/gJO8CcQz+WzZxytvImExfsJbYTmGl/pl6+nsp/I/FbfY07+7ZwvtIs8sLMzCgyDW3o1QVm/Wo4A38EThEfWIJwsD9oO7A6H6GhAyvTz2xOvX0UYnPXXDJqnc5+lu64qWCFJCy1VI09z5ULd36/5XB/1nc17WggmftAt3ZzxEGZ8HHgIq1AKSaCA2RjAlRoaWdIqzQrc2hZ59X0UxbHQEVr692qwyHL9T2f+OCeViA4eQJnojfHS+0QdrP00V6+JvMz5iq8cPP7YUMnECxXddJtodkzg0G6wVpmCfqpb4zP1WRWqGVlDpyO8TMXwcIO63UQ2pT2wI+WcmxqYlFb02lUsciN
 dgs/jWj/
 TLqKI0E8vd0X9GMfU3Qdfq4gnqgqmshRIovhnS20VEtS+K2cQrpzxlnwI2N5BhimpTCJLrBlOPDelT2CeiDF3nykEmOKdWkxS3Dii4XzP2gpOfSjJ4Ze8ffL5XgOvnqXqvkpcpxT/LoZtflccLiwE+WuiCcBg/sBt/4lhqjdG8JQJH958zsjNRPAQSIthgyqVEDfX2fYWH3Oa09FCxKWwqb0QFjGf3L+pb3hrJvdJwEwXDfA/e30MdOBuqED/IsSPSxM+iF+D2e/fl05vBds+Nq2WO5xZDcrgVbr5bUzrtA+CoVsOmdzZQhoTAq7UFt7gXMdGIpatHwCa5/qyET+T1N6xWTz+Bkpg93K9V7VJD6d/c5s/XsXvzu1Dv/7KSW1LOHSFJLKPfLXWr4PCK5hxNW/Hp/Coh24jT8fprL+ORkYWmhmTXMdSCjjpI5NbGxdSj5KGrcXjHpoU6fwTkbE4yTdZ0cbl5OniNGj56aXN94eVLi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/13 23:53, Yosry Ahmed wrote:
> On Fri, Jul 10, 2026 at 3:04 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/7/10 04:44, Yosry Ahmed wrote:
>>> On Wed, Jul 8, 2026 at 7:15 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/7/7 03:33, Yosry Ahmed wrote:
>>>>> On Thu, Jul 2, 2026 at 5:32 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2026/7/1 19:45, Hao Jia wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 2026/7/1 00:10, Yosry Ahmed wrote:
>>>>>>>>>> Before going through more versions we need to figure out if this will
>>>>>>>>>> pivot to be a proactive demotion interfcae for swap tiering.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Yes. Should I drop patches 4-6 in the next version and wait for swap
>>>>>>>>> tiering to be finalized?
>>>>>>>>> We can try to get the non-memcg parts (patches 1-3) merged upstream
>>>>>>>>> first. This would also give them plenty of time to bake and catch any
>>>>>>>>> potential regressions. Thoughts?
>>>>>>>>
>>>>>>>> Patches 1-2 can be sent and merged separately, yes. For patch 2,
>>>>>>>> please include some numbers for the writeback performance before and
>>>>>>>> after batching.
>>>>>>>
>>>>>>> I'd love to collect some performance data. Do you have any recommended
>>>>>>> benchmarks for this?
>>>>>>>
>>>>>>
>>>>>> Perhaps the following test case could work?
>>>>>>
>>>>>> Test Setup:
>>>>>> - Total memory: 32 GB
>>>>>> - zswap settings: max_pool_percent=1, accept_threshold_percent=50,
>>>>>> shrinker_enabled=N
>>>>>> - cgroup constraint: memory.max=1G
>>>>>> - Workload: Run the following stress-ng command inside the cgroup for
>>>>>> 120s to
>>>>>>       continuously force zswap store failures and trigger shrink_worker():
>>>>>>
>>>>>>       bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>>>>>>       exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t
>>>>>> 120s -q'
>>>>>>
>>>>>> The following comparison results were collected over multiple runs via
>>>>>> bpftrace
>>>>>> and the 'written_back_pages' sysfs interface:
>>>>>>
>>>>>>                              Baseline         Patched
>>>>>> ---------------------------------------------------
>>>>>> shrink_worker wakeups       5,587             878
>>>>>> shrink_memcg calls      7,823,853       2,347,320
>>>>>> written_back                  257         781,214
>>>>>>
>>>>>> Conclusion:
>>>>>> Under the same workload and duration, the patched kernel shows a
>>>>>> significant reduction
>>>>>> in both shrink_worker wakeups and shrink_memcg calls, while successfully
>>>>>> executing a
>>>>>> much higher volume of page writebacks.
>>>>>
>>>>> Hmm this is actually a bit concerning. Yes, we are invoking the
>>>>> shrinker less, but we're writing back *a lot* more memory, orders of
>>>>> magnitude more. We are using a batch size of 64, and making ~1/3 of
>>>>> the calls to shrink_memcg(), so the number of written back pages
>>>>> should be ~20x more, not 3000x more? I think I am missing something.
>>>>>
>>>>> Also, ideally, the batching wouldn't result in significantly more
>>>>> writeback, but a similar amount of writeback over less shrinker
>>>>> invocations. If we are writing back significantly more pages then the
>>>>> batching logic is probably too aggressive?
>>>>
>>>> Apologies, I think the test I constructed has a bit of a problem. This
>>>> test has very, very heavy memory pressure and is already a very abnormal
>>>> case.
>>>>
>>>> The zswap entry returns the first time because of "second chance" after
>>>> setting referenced to false. For the baseline, it scans 1 page per node
>>>> each time for 16 loops. During the test, shrink_worker() basically exits
>>>> at about 16 pages each time.
>>>>
>>>> Since stress-ng periodically and randomly writes to this 4G memory, it
>>>> keeps triggering zswapin and then waiting to zswapout new zswap entries
>>>> after falling below the pool threshold. When the speed of zswapin/out is
>>>> far greater than the scanning speed of shrink_worker(), a large number
>>>> of zswap entries cannot wait until the second scan for writeback. New
>>>> entries are stored on the zswap LRU list again, and the referenced of
>>>> the new zswap entries is set to true again. During the test, it was
>>>> found that 99.21% of the return values of shrink_memcg_cb() in the
>>>> baseline kernel were LRU_ROTATE.
>>>
>>> Hmm if I understand correctly, you are saying that the current
>>> upstream code is actually failing to writeback when it should in the
>>> previous test case with very high memory pressure, but it is with
>>> batching? If that's the case, I think it's actually really good data
>>> to include. However, we should make sure that's what's actually
>>> happening. If the current shrinker is not keeping up and failing to
>>> writeback, we should observe:
>>> 1. shrink_worker() hitting MAX_RECLAIM_RETRIES continuously and bailing.
>>> 2. zswap usage consistently remains at/near the limit, and not going
>>> down to the acceptance threshold.
>>> 3. zswap_store() failing to accept pages and the pages going directly
>>> to disk, causing an LRU inversion (hotter pages on disk, colder pages
>>> in zswap).
>>>
>>> Can you confirm that this is what's observed with the high pressure test case?
>>>
>>
>> Apologies, my previous explanation might not have been very clear.
>>
>> For an entry to be written back, the shrinker must scan the *same* entry
>> twice: the first scan sets referenced to false and returns ROTATE, and
>> only during the second scan can it be written back.
>>
>> If a swap entry is zswapin'd between the first and second scan (meaning
>> the entry is no longer on the zswap LRU), then this swap entry will not
>> be written back by the shrinker. Therefore, the second scan must occur
>> before this entry is zswapin'd for it to be possible to be written back.
>> So, if the baseline scanning speed is far slower than the lifecycle
>> speed of the swap entries, it results in only scanning once. In the
>> baseline kernel, 99.21% of the return values of shrink_memcg_cb() are
>> LRU_ROTATE, while the patched kernel's shrink_worker() scans at least 64
>> * 16 entries in a single pass, resulting in only 58.7% of the return
>> values of shrink_memcg_cb() being LRU_ROTATE.
> 
> Right, my question is, is the high rate of LRU_ROTATE leading to
> failure to writeback in a way that causes zswap store failures (and
> pages skipping zswap and going directly to swap)?

Yes, I observed that the number of zswap_store() failures (returning 
false) is very high.

Thanks，
Hao


