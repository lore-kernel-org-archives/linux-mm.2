Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD6CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2E36B0005; Thu,  9 Jul 2026 22:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4938B6B0088; Thu,  9 Jul 2026 22:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8C46B008A; Thu,  9 Jul 2026 22:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13B256B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:07:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84113140310
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:07:16 +0000 (UTC)
X-FDA: 84971229672.10.699BFC0
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf14.hostedemail.com (Postfix) with ESMTP id 15ACF100006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:07:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZbLa7H8P;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783649233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qWvmYTTV9g/8HbuZVFImT8qht0TwN0Nod2rNmixTuY=;
	b=7Ctlx58Arx2b9JzEmwaXq5WFp9LCoPubNHIAM9ZAx8EPMWUtZbV7HYJsAiS4ZJ+d8/WOr9
	LbQjSZn1+NgF1/FAM9VyYLSlFzOlAC0ZWmcAsjpk3SXT/4sboLWN4rEKau+hQyLstj0x2d
	oQoyoXvHuXNSFllvmkuWePLXUesxlgU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZbLa7H8P;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783649233;
	b=pRVjdXNqJioSHIvPM1UuZlR1/Nyh3Jg2bDttkfrAkTlY4Mfc3R4wXtYLeom//vswu1cJFP
	AR5vQOjpRhKfnBD6XA0XOusaq/VxI2VPCce3Saen3T/deaXXrkcGRYGcH/SirI39onQH7d
	Z3WsJveU51IY0uvPqdPTTzxKEY4BrfU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783649229; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2qWvmYTTV9g/8HbuZVFImT8qht0TwN0Nod2rNmixTuY=;
	b=ZbLa7H8PAPD2eBf7Ago2ENl00qsj1SJs7xzKldnEoAXIUwz+4YoqeVwhKvXKOAwlCwVSN4PGynC75eFMG+/8ODHJTIRFfU25fbddEuLZqrAFOYTFsmkD3VRrVqnjcynDcHz01o6EdxFtOxc4LOx32dzrcWvJz3oD65ITiIWXjLA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X6m29De_1783649226;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6m29De_1783649226 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 10:07:07 +0800
Message-ID: <d2854680-daf7-4f38-97c4-4de3423e3d49@linux.alibaba.com>
Date: Fri, 10 Jul 2026 10:07:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18.y] mm: shmem: fix potential livelock issue for shmem
 direct swapin
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org,
 hughd@google.com, stable@vger.kernel.org, machao26@xiaomi.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7AQcyypJ-VhJ_CxY6fdEph64fxjOzzYU-=EkMrHemkpzA@mail.gmail.com>
 <8ef0b72e-a0e8-4913-8d30-519335305260@linux.alibaba.com>
 <CAGsJ_4z5N6FSfWt5WUZ5YmqhCzLcd3Cj1sc9B79WYX9ZbDH8Gw@mail.gmail.com>
 <d01bae40-f94d-4e8a-baac-ad6fffa18b64@linux.alibaba.com>
 <CAGsJ_4zbBRe383GQLGuPivUXXnjhs2L9xFyandXkCOUotcb7Vg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4zbBRe383GQLGuPivUXXnjhs2L9xFyandXkCOUotcb7Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nstdwtoyc3164cbxaa3xcn4wtp6ta76g
X-Rspamd-Queue-Id: 15ACF100006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783649231-621012
X-HE-Meta: U2FsdGVkX1+Bh8BiXLBUr7kBdM5SM4+OTpv2pgBfn4+4ZOY37yQ1OZI4KBY+U8CxnXkRTHZeMnKddx9egQ/TnC73yzQdnPDSJJvA2ro6v+SEzrJXeHQ2fpTHfHzxrP9nMrchaSyQDEIw4pCkwepI3pRMhrkUQDAFGPYU9moJrAqEIjTmbYzp1DhB7bN3IVtjapmx3DbUQZgNU2wYME+Dv+jMbMRY+x/JOZmzxG64IIvar2h1CpBCBcQLtF05F6juUw18U2F3Dc0V0mTkFQX533P+9pSbCa+s/tc4huhCCQb9zNYB1vhfiGLYvg70Jp/jIDOSrdLI2ecToMx+AqJi7dzT2+a/oEnJf69/Yv0vTq1CNd8sLorP7cwCaaiuobvHGWI8T1qFYCo6Dsb1prFwgNk0AQZOSooYqJhhsNKU17RwEPN1S5YKHOx3N0YQjDKQBRfJ81lN+ByCwRAR7AaSVzBUTRNGiyJ0ODZb7LnLxOtWAEPHQRhitJWBURUwLP2l96YVVtOrGXXquZPyepoLeGiWXAWXNwbr3sAgDqfANNoXUg4TLzk8mJ4MUTIYbNt/dvOptn7E+jl772Nn2gnLQ0zh7lDyOBK/aSxUzXAWjPKYEjXMVi2ddwqamd6Xf5+u/9AXcMkSMQb/6UVywNrbQK/t9YKEy0dawZrvoWTJjTcJAAERxymSFbY8o63vDRSgsP9LRjUGXhEjZTmqmDw4NkcCmlu/huZKjOS+rrpSSydifxwYq8qEx9vAMmqNM2ojQBfAMMibXGQSAjSWnaixxTqGFNuS6Vn8YRzMA30bYENywGzKjznn32cu8ACRLRFgBSP3KaDIfvnHdGOjFc98T0P5rI2GqCbJPMTzt4Qi6ospHdTRi2hSwAFlEbKQYyaqyiaYYsp+6aZtySd6ADikiLasUFIX4ISLgvM1JcnSvysexWCi5UbaSEKmnAbdS8azCk2TewKPXhczEPqk6Uf
 lrxYPd3L
 tT1+rO88ZFammrJhonZwMfjIIGWjnrppEqecW6gKRdJcQirci1p+I5AZHUunMboCrxqq30REBXpo9u5gg9/qlBL4WwNsxz0t3NSvvsYYzk+aPsoPZQH5oAn4BVEkiWhWM73spZA8Zgrn23oPVbVQKGYvC5mp14qd4ihmBouMgsRuTO+q7mbBnpMc5dXQyABm2j6okzDaCv24zVr8IXymjRcySKPHUjAfnXo+BKPVU9GmjdCBMH//qMeFyirv9Guy6XYFFQAOiV4nHCvz0BqWyTJSvba+5MJv5+yUDvm5sI1m7ADEjJZDfBAHfKAKdUSe2n90HYZCC6jZkQT0RHjVEC8RUmZKk/VmGbQS76lFhkXPwnUIlJL5xYquR3Ire4V8znxe7i/we13qctKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/26 10:34 PM, Barry Song wrote:
> On Tue, Jul 7, 2026 at 9:53 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 7/6/26 9:04 PM, Barry Song wrote:
>>> On Mon, Jul 6, 2026 at 8:08 PM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 7/6/26 1:59 PM, Kairui Song wrote:
>>>>> On Mon, Jul 6, 2026 at 11:25 AM Baolin Wang
>>>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>>>
>>>>>> When skipping swapcache for synchronous IO swap devices, swapcache_prepare()
>>>>>> is used to prevent parallel swapin from proceeding with the swap cache flag.
>>>>>> However, on PREEMPT kernels this can lead to a livelock, as reported by Chao[1]:
>>>>>>
>>>>>> Thread A starts direct swapin of a shmem folio and calls swapcache_prepare()
>>>>>> to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault().
>>>>>> Meanwhile, a higher priority thread B also attempts direct swapin of the same
>>>>>> shmem swap entry. Since swapcache_prepare() already marks the entry, thread B
>>>>>> repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. But as
>>>>>> thread B runs at higher priority, thread A cannot preempt it, resulting in
>>>>>> starvation and a livelock.
>>>>>>
>>>>>> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
>>>>>> swapcache_prepare() fails, following the same approach used in commits
>>>>>> 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
>>>>>> 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
>>>>>>
>>>>>> Note that mainline does not have this potential issue, which has already been
>>>>>> resolved by Kairui's swap refactoring work[2].
>>>>>>
>>>>>> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>>>>>> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
>>>>>> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
>>>>>> Reported-by: Ma Chao <machao26@xiaomi.com>
>>>>>> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> ---
>>>>>> Hi Chao, could you try this patch to check if it fixes your issue? Thanks.
>>>>>> ---
>>>>>>     mm/shmem.c | 2 ++
>>>>>>     1 file changed, 2 insertions(+)
>>>>>>
>>>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>>>> index 94c5b0d78ac3..d4cb57b3b0ef 100644
>>>>>> --- a/mm/shmem.c
>>>>>> +++ b/mm/shmem.c
>>>>>> @@ -2066,6 +2066,8 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>>>>>            if (swapcache_prepare(entry, nr_pages)) {
>>>>>>                    folio_put(new);
>>>>>>                    new = ERR_PTR(-EEXIST);
>>>>>> +               /* Relax a bit to prevent rapid repeated page faults */
>>>>>> +               schedule_timeout_uninterruptible(1);
>>>>>>                    /* Try smaller folio to avoid cache conflict */
>>>>>>                    goto fallback;
>>>>>>            }
>>>>>> --
>>>>>> 2.47.3
>>>>>>
>>>>>
>>>>> Thanks! That's much more simpler than I expected. Do we need a wakeup
>>>>> queue like the one in commit 01626a1823024? Perhaps the reporter can
>>>>> help confirm and test? I personally prefer to keep it simple if shmem
>>>>> users aren't as sensitive as anon users.
>>>>
>>>> I agree. I'd like to keep the bugfix as simple as possible, if the
>>>> reporter's scenario isn't latency-sensitive.
>>>
>>> On Android, we don't see much shmem; it's much less common
>>> than anon. So the chance of this concurrency happening should
>>> be lower than for anon. However, shmem can be shared by
>>> multiple processes, so could this still happen if process A is
>>> blocked by process B?
>>
>> Could you be more specific about how that happens? I think we should fix
>> this starvation/livelock issue if you think it could still happen.
> 
> Hi Baolin,
> 
> I think your change has fixed the livelock issue, but an unconditional
> one-tick sleep could still be problematic, as commit 01626a1823 tried to
> address in do_swap_page():
> 
> "mm: avoid unconditional one-tick sleep when swapcache_prepare fails"
> 
> If possible, I would suggest that your fix also include the change from
> commit 01626a1823 to avoid the issue caused by
> schedule_timeout_uninterruptible(1): an unconditional one-tick sleep
> could cause UI stuttering. At least, this would make the code more
> defensive.

Sounds reasonable to me. Will do in v2. Thanks.

