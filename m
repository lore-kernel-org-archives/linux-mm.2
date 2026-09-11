Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50BC8C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071C96B0093; Fri, 11 Sep 2026 07:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047956B0098; Fri, 11 Sep 2026 07:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1AA6B0099; Fri, 11 Sep 2026 07:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC86D6B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:39:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41345A332D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:39:50 +0000 (UTC)
X-FDA: 85201286940.19.75F0646
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id A298120008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:39:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BN0wtozd;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789126788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oS5pCTFp0KI+iC50w7FkRnX3WOjbdZEE16QE70yFVGs=;
	b=oyTPRtYnP+K4FsVsOISuqCc3QsEdaEQwct3FeQQkjMzg96pdKHO7x/Zhi7lVWEZIP4nhEA
	d/tgoeBOzTTcdk5ryvobkp/JZhgmdUnGXhmIZOnwhe7SfYdcYCUVwZScNXntIsfpztOcIM
	NBTCwHUOdhlJt5ADFubZYD5+wX8IVsc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BN0wtozd;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789126788;
	b=Hi92nSaRuKpayfPqQB1WllrisYnOqK/BUwQPKSmNO4C0P8XxFsdYc3eEr4DhdEzbO418uQ
	iUAy/A94Pe7jPLYChCYvqy4EOXubQSv9SDC1XMqgWf9WNCNs8ACjn4SirfkjqS7ZU1yeVW
	lF2q4T5jNWbzovgb/ih7hSIth/31pWo=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-86959a6f7f6so610252b3a.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789126786; x=1789731586; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oS5pCTFp0KI+iC50w7FkRnX3WOjbdZEE16QE70yFVGs=;
        b=BN0wtozdY0UU4jvAubMfpTWwB4mFCydbpmPV6dvS5N5DFnGVJOAbmxeWAhrxUnmTcu
         MkoEiFEHapm4LgzWU7ICUOfJ+ibhBSqxkrkxtefScHoexFs1rdglwd8exCK2+FDNAXY+
         mhi91P/aEBrgBQpE4nn53DumYZDrZr9V1G14uTzuQ8LW3dxZcIvL+6l7LhEVO+JJeOSX
         UG090omFsBnWzAkcg+G4Jjl/3rTPZJHvgkaQ9YZhb+9HnIM17I9/6834A845l5wZ1F5j
         21kQopIO8SRBHjTf2JFW2aLBh8Tq13xhoVgsYgytQBGTz20+f8JM3pTHWAvmxbDnAQxY
         pmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789126786; x=1789731586;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oS5pCTFp0KI+iC50w7FkRnX3WOjbdZEE16QE70yFVGs=;
        b=Ik6YnGelFciB3bG1KY5/TgQw2oGCanAeBW5ROAJYb9his+gRZPuDtzW6Lf9ZIBw8lC
         P1TibPJ7fnc2Y1l6lZd2GflWHU0MMW5d7ntQxPwksCrO7yXvte49aMV1d5MoZHSAvmjq
         c3Yrh6NYy1EAsRcK0JlL1JxNxCUhDutCS7EWcp9XcS2cUblPPaTwjs9nhzFeYcuI/4fo
         hiEAgptIaBWVVcxTE4KFM1SFLN6AH0RpcRsnqxJqcHTclP90IXZStvCBlpC9FV2OT3do
         tGCfOBQP39cFJbSip8f+W73/1Kh/IyCJeelX+xEFawh4xZWzKe5F7MJTyaaD5ybQ3Zzo
         +17w==
X-Gm-Message-State: AFuF++kBLQkrXQJ0t9vYYJeugD8dd75ASfdFviBLE0+nfpNVD6kJSCj3
	5+OrTex2QAZKyGIaoYJzJGVPvg1PTT7fUHJk0z2VUYZFR8gvNfoynLfgZ5NFmqEgxmY=
X-Gm-Gg: AYBFou2CMEwSE8WQ2YNIToKhg/lG+ys2KRmoUz2HbMOn8BQ02sSTxuAX1t0pRv36GWa
	rO7+l4SeRx/AXXH6aChoWTxg/XXJ/P7E7tXzawkijIKmZyY1GA9Ce1eMDY1KU0riywLoQfbNhlg
	aaf845YosqJCzpkqImaDwda4p/4NC6DNyoIm5JAGQWIsS4Mes/x08i0QxfwmBTgVBhnnFY3yq8k
	F8T1WRlVmOkH7FVqRwVjbeapgOudCykeZAJNpikiAUIB+5ztroaNOVQ7HFc1gv73O4kkTFpX0F7
	k70kcj8lUc35MyNgfy2TWx5/2l1JP88fgPgqmQSNXzcz3otq/cwMgh42gO6/ZbrPztxURId97W3
	MMdTG6WTKpli7E6K6IY0L/T1io/fgfXzFvVCDM0b4BwGZEVOAYImEp7xfrTjsmM/JWtnUj6o2gl
	TJ3NvxyP38MLlHPXxxd5pSRo5EM5liwYuSp6heC7yhfSJuglqAHwQYQc76Y65m2LGJLBu3VD0/I
	qX/Y0/Cajrzb46DJq2m4r+T6BmYD+uByk3OTLO5WIE8
X-Received: by 2002:a05:6a00:4fcd:b0:864:cbc5:b8dc with SMTP id d2e1a72fcca58-86b2ecef9e2mr5888381b3a.10.1789126786110;
        Fri, 11 Sep 2026 04:39:46 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b286c4e5esm1038881b3a.19.2026.09.11.04.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 04:39:45 -0700 (PDT)
Message-ID: <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
Date: Fri, 11 Sep 2026 19:39:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 tj@kernel.org
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
 <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
 <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A298120008
X-Stat-Signature: 5ibdzcjcyy1b5d3pttdppto4e8i143ts
X-Rspam-User: 
X-HE-Tag: 1789126787-412518
X-HE-Meta: U2FsdGVkX1+CZZcsYmtquzF7jSXZDvrhQc1WLxAapvNcmQ3pANI2AfInyk2Uzemaqd2AWOVUueqVcRvWjWWSQiu4vrO+Vgo5xWaa1BwMptWHd3wiVhexsdSlnGvg+lEQd7L5D8mTaziHYMDpzHeHlGqvpEaWY0ewXlQLNgltgmxOxd1RFmh39ohw6IyTz02qC+ONIrSeyQVYn0voWdgXvRGqMaE15Jq2Ew+tx+BKo2E4rTqiiO6lQRDryi586BPkbD4vQSO2FFDTGI+pmUnk/zfs0pPiqTcQ7CPUct9p5iagJiogLgXeaw9D1T3ylNorE6qNT9esKJtUo8ZYaBIjgOOK7IM/VTsG5EN6WMZezI2EywGvRMJ6VQH/NZB0OUIrZd04F2M0c99AITPRzrskd3l1CFOElh0gpi7HEsKQTikqBZZ+I4QpFwtYc8QOAUXBJOtg8OUht2tlpAi2uhjabRp1KPQaKnJPczz1cnXWR4Ir3MABvzygF2rsXI6o83d7YGH5sr146yhjLperuDEDfYA9OR7ankD6alJC/VFH8EiMvWP6LDxAem8RIMlrny1FLq5RvpbzGVWNBhg13CB+dj9Z71i8oueysavGBCUUkRl94nkLAtJBQPSya91Qger8Z0ybRhShDQnqJ/rePPyY3W1vyCjsEKKdDqdcoRDg5NiRCtaqEnsIT0VlRiX1aSAMGXvkI0J8VBOYMEPGhjF/JVI1jGigflH91LcFNWvWLc6sGCLf6xLLvM5iOx48wz26MO5d2Ou1/L7ZKnLOsaFBLe2gz6ZmncWNN0c/PPZ5AnzQaMaLde3i1xko9YXdHOuYDwj9xDaxu/9FnIoxSlQXCpS4fEAx8vGGB+kdtkqwBlUmWoytYetcIoinLWrUuEFglzFG866NwJg/w9ixCqkzD2iQlheYKh1qHhUb2KHBc7qKyklcfZw8DyANOohc+LxFybEXDjtncbjPDHXDIet
 P2/ClL2h
 o1wioLocuOUUCU5smR6aVa0dbpTJnp9YVWYb1RaRpNs+msRqSD/gnoKMnoRu68Moah4V5JtpXwR2W2eTMbP8qqATqM26OAKjYWTBPnLrD17Ya/fx9tPXT/SxUTALXIvEJcHNUpLFZbqriEmhcYXx7GeOOW/kwa5yLk7s4BCdSjvFKxKwJrvHPccFw3447BuUdm4wuwW8pzf9PcPoh16WnkA4tj9n7najv0p+pfOXIq42tJkjyn3u4kkWlSCI/xAZsmDl3xKA9C4/QBA8nrGcRv8ZCpd+b+9M5Tr4jTebAGfx7Cgp6fqCdprb03zpdwipzG5hOj2uk/BXdXJ4XdFC2zXAEd/k275bO4NTyuiWUS0VYek5ihiCia3+idPZfFXYqZyhs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 7:20 PM, Jan Kara wrote:
> On Wed 09-09-26 21:18:11, Julian Sun wrote:
>> On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
>>>
>>> On Wed 09-09-26 11:43:43, Julian Sun wrote:
>>>> The expectation in wbc_detach_inode() that "concurrent write sharing of an
>>>> inode is expected to be very rare" does not hold for bdev inodes. On ext4,
>>>> metadata from many memcgs shares the same bdev inode, so dirty throttling
>>>> in those memcgs can repeatedly trigger foreign flushes of the owner wb.
>>>> These flushes can also write ordinary file data, reducing overwrite
>>>> coalescing under continuous buffered overwrites. The resulting extra I/O
>>>> leaves less device bandwidth for other workloads.
>>>
>>> Hum. Are you aware of [1]? The guy is from the same company so I was
>>> assuming you two are working together on the problem :).
>>
>> Yes, Xin and I are on the same team, and we are looking at different
>> ways to mitigate this issue.
> 
> OK :).
> 
>> We will continue trying to gather more evidence from production to
>> better understand its actual impact. The number of calls to
>> `balance_dirty_pages()` and the time spent in it might be useful
>> metrics for this purpose.
>>
>> Jan, if we can show that this patch provides a measurable improvement
>> in production, would you consider accepting it? Or do you think we
>> should still look for a better approach? If you think there is a
>> better way to address this, we'd be very interested in your
>> suggestion.
> 
> I definitely acknowledge that there's a problem with foreign flushing due
> to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
> break the fundamental assumptions of foreign flushes. But so far I haven't
> seen a solution which I'd definitely support.
> 
> Having data from production to understand what exactly is the practical
> problem will hopefully help us understand how the solution should look
> like. Is it just that we trigger too many flushes and that slows down
> things? Or is even one foreign flush of the whole wb due to bdev inode
> making performance bad? Is it that we have many foreign pages and foreign
> flushes fail to properly write them?  These are questions we need to answer
> to decide how the solution should look like. And the solution could be
> anything from just limiting number of foreign flushes for a wb to 1
> (because there really isn't big point in more of them being queued) to more
> involved foreign page tracking for bdev inodes so that flushes can be more
> targetted.

Hi Jan,

Thanks for your feedback.

All the foreign flushes we've observed were triggered by bdev inodes.
What we've observed is that the bdev inode has only around 10 MB of
dirty pages, but it triggers writeback of around 40 GB of dirty pages
across the entire wb. The actual foreign pages account for less than
10 MB, yet flushing them triggers writeback of the whole wb, and this
happens repeatedly.

This appears to cause significant write amplification.

Limiting foreign flushes to one may not be sufficient in this case,
since even a single flush can trigger a large amount of unnecessary
writeback. I'm currently working on tracking foreign inodes so that
foreign flushes can target those inodes specifically.

The impact on production workloads is not easy to measure directly,
which is another challenge we're facing. We've had reports of slow
dirty page writeback from production workloads. Although we haven't
established the full causal chain yet, we suspect foreign flushes may
be contributing to the problem.
> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

