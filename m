Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005CAF531E7
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 02:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAEA6B0088; Mon, 13 Apr 2026 22:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1606B008A; Mon, 13 Apr 2026 22:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8CD6B0092; Mon, 13 Apr 2026 22:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09DEF6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:23:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99264139998
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:23:22 +0000 (UTC)
X-FDA: 84655564644.10.855CE4E
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf22.hostedemail.com (Postfix) with ESMTP id 33A2AC000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:23:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VJwEAPSI;
	spf=pass (imf22.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776133400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5c08oqpW8xInrDeySZRyRa+d0wZsG8dfZpf7bL6oRM=;
	b=G2ZiKUmdWE6jDppEeQ6XdWU6ETUnfAWLD+CPpgPZO5LR5lJeIXMRY7bwbXZtcWr/Xo87U7
	egGuAWKw8pGZxFtA5kVabliJCurSCaqE8KtKtZ95hc7l/X8jnIzy6Xy/D6F1yl+MUQglV9
	WCQOGxLcFjDGT42BsOKmadyjHlmj0bQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776133400; a=rsa-sha256;
	cv=none;
	b=OZyONuctr9QBk8CU45YmJKTAsavcbrIkqwee++geDX7dowNZxmr7j34kts2NbAoQkr+s0n
	+OtzwUchO03rB6WfhhjOD9iEhJiVv6kINnHA3U7zHLDj52qnXYdOEa6bHB/of7t+IkvNh1
	69QnuaTBq4PmhFNdzihTzGOjX1qQQ8s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VJwEAPSI;
	spf=pass (imf22.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776133395; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=N5c08oqpW8xInrDeySZRyRa+d0wZsG8dfZpf7bL6oRM=;
	b=VJwEAPSIUmoAYrOU/jCJpL4PYF5aDRum1kUp5KDluWRM0OFh9AfkjjWrJRa/tSnlQpFsYk8XdG+JDiFrdVAef/UcnOkTRfN802ZH9cdSVFk/OKSa9FNGq9zQrapQhK7drwWxyVvfZlnxXaWAcTp73Uxwum7IotLkrvHUPN9paiE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X1.p49D_1776133393;
Received: from 30.221.131.198(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1.p49D_1776133393 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Apr 2026 10:23:14 +0800
Message-ID: <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
Date: Tue, 14 Apr 2026 10:23:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
 Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Sandeep Dhavale <dhavale@google.com>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ad2RKNo2FGhpzJQp@dread>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: oonruqqtktqyzsk981d9a5675di85jxt
X-Rspamd-Queue-Id: 33A2AC000A
X-Rspam-User: 
X-HE-Tag: 1776133398-84539
X-HE-Meta: U2FsdGVkX180gyazHD9ATGxHCKjg5aD9VVu7TxroWulQSbY4Y3VIjm+mJ2VcxggDccp7ZiN5ON42sOAOG2zYjHQVPMvp35znKFcSna8J6MIPfPgAqUrH9D4h9rAQhlJWXfMUPGHNTvYYBtSTbgGJeGzEEn1jH8LORnk4qnl8YWrBreSaBRKy1EgO+QdXiGsMiDjlWA3PntWRe6jrGinU5jbEVray50QAsX8dgeBwbOqP61ub5GKv9tqMzNcfH8ca1Z4YqwVEW6pnb/6A9HT2k+Q1rtHIgYJ6PqGzM4X3V3tsnwM3012hj65KSyJs+AFIFUK+89B4kLCq3QNsHC6fmAFWTXCEEg5e+rEnrd+++Xs+7Y5zJwdxn5tGPYWZP7s3KkXmiK/RvEw3V7C+5luw7O3AJSpLt3sXoMyi7o/0QLkfkoQXX3gzg3Fml0wMEhlnQNraSzx9anf5xeisupmYsrQuvHGDN4CnIPUcIAExtUfoxjHsOlCY/X6MuMMKGO1Hw3dPp9S/Ihz+r+fjSEpfO85RugzTwqi83UBMmYNOiB6tZo2J6xIutQ/KXEaR4OaAMlxSpDLdtnws0jMhzDxZt8KrFC/mcvp+lq6eoGFWQBRWyerZqtIxuz56U8Orx64E3TKZu0/Tjf3E/XMe+6WhhNMezwHPyRkDn+zUbT1CjH4PJQh0ZWQXDlqccXNRGQeGYVVE8Mlk7/Yw3/GNOKmb6RfFUz/y4EgTFyNImmr3NJL8Dqz8p5fXLO9EwWRw3N6p+dDAuE2wvyk8McXogkmcrXKiJtJhhXUp9sgQfOOJXMH5+05GbltJdcADKFQYFmBFWvbzM+YV3BSfI9rKPJnAZivdK6UY8y0Dt7SDAK7zBsmvSaLrqijwmelJ+5weFIHVx0JL0aRHOHLBsP5DBHkHunRfvp50jwCp4E/vv5c3+zeq7JbPSLjuT/4WQdNWLZ55i4eW/sFCleSEBDQ+4mQ
 /bzJAhDq
 rRW8xqm8dtC3O9ZhCaQERf32J47HiknCCFcFJ5nbDPTJ7Io2Roug0l+890fyYb203/QIF+D9bPQ0WPLJB3XDthtB3EDJR+jxhlJQ75Eq0vd1X14qN/tcej3AjF7xc1deUAi/WthvE+UYhrKAOPxjGOXP4WgnplDQwwX4OoHFcEjsT9itXe7QyB1Rsg7nE2mNvjuK1e/DnqCI6FYxGWeV/tqbrPrqSp3MfO8ttR6p6GPurwl+WSlEFO6vCZ3Wjgt38k5vpov091ocLsK89WKD5GRnXIbUR7jJhQVzCKxZzcvtoOF2g7xl+8dvhGbbnxKP+iiqOa+IboxfRXh57EVXwZ2cmsH1o0eN/k5Q32UGkvMrrWoa4McYjFuK+dUIYAGUQ2eaTsz9K4hU48a7snLvxY3Lop4AG6nj9Pf2l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/14 08:58, Dave Chinner wrote:
> On Sat, Apr 11, 2026 at 07:44:43AM +0800, Gao Xiang wrote:
>>
>>
>> On 2026/4/11 06:11, Dave Chinner wrote:
>>> On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
>>>> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
>>>> option") explains why workqueue aren't great for low-latency completion
>>>> handling.  Switch to a per-cpu kthread to handle it instead.  This code
>>>> is based on the erofs code in the above commit, but further simplified
>>>> by directly using a kthread instead of a kthread_work.
>>>>
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>
>>> Can we please not go back to the (bad) old days of individual
>>> subsystems needing their own set of per-cpu kernel tasks just
>>> sitting around idle most of of the time?  The whole point of the
>>> workqueue infrastructure was to get rid of this widely repeated
>>> anti-pattern.
>>>
>>> If there's a latency problem with workqueue scheduling, then we
>>> should be fixing that problem rather than working around it in every
>>> subsystem that thinkgs it has a workqueue scheduling latency
>>> issue...
>>
>> It has been "fixed" but never actually get fixed:
>> https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com
>>
>> and workqueues don't have any plan to introduce RT threads;
> 
> They don't need to (or should) introduce RT threads. Per-cpu kernel
> threads already get priority over normal user tasks on scheduling
> decisions.  However, they do not pre-empt running kernel tasks of
> the same priority.
> 
> In general, kernel threads should not use RT scheduling at all - if
> the kernel uses RT prioprity tasks then that can interfere with user
> scheduled RT tasks. This is especially true in this case where a
> non-RT tasks issue the IO, and the IO completion is then scheduled
> with RT priority. IOWs, any unprivileged user can now impact the
> processing time available to, and the response latency of, other
> RT scheduled tasks the system is running.

All softirq IO completion already works like this although
softirq tasks are not strictly called "RT tasks" (i.e. a non-RT
task issues the IO, and the softirq IO completion will interrupt
all ongoing tasks).

Basically what we want is to get a non-atomic context instead of
using the current softirq context for read post-processing and
switch to the task context immediately as you said, because:

  - Our post-processing needs to work in task contexts since
    advanced features like compression deduplication need it;

  - Even regardless of our specific requirement needing task
    contexts, using a dedicated task context for read
    post-processing is much better than run in the original
    softirq context:

    - Algorithmic work could take extra time (especially slow
      LZMA algorithm could take milliseconds on low devices
      (however, we need a common workflow for all algorithms,
      including fast algorithms like lz4) and verify work for
      example); and long processing time will interfere with
      other remaining softirq tasks like sound-playback
      / network softirqs;

    - If it is then deferred to softirqd, it just makes this
      latency issue _worse_.


Thus, if there is another dedicated mechanism which can provide
a lightweight task context and is scheduled to run immediately
after the softirq: that would fit our requirement and I believe
it's useful for other various use cases, but currently there is
no such clean infra; RT threads can just fulfill our requirement
in a less elegant way.

> 
> Tejun asked Sandeep if setting the workqueue thread priority to
> -19 through sysfs (i.e. making them higher priority than normal
> kernel threads) had the same effect on latency as using a dedicated
> per-cpu RT task thread. THere was no followup.

I think the issue is that people are not already working on the
same topic:

  - Unlike large subsystems like XFS, people don't already work on
    EROFS unless they have new requirements or urgent production
    issues;

  - The original latency issue was already considered as "done" in
    2023, and I'm not sure if Sandeep could have the bandwidth to
    pause his current work and test more setups according to this
    ongoing discussion in 2026.

> 
> In theory, this should provide the same benefit, because what RT
> scheduling is doing is pre-empting any user and kernel task that was
> running when the interrupt was delivered to execute the completion
> task immediately.

But anyway, I think nice -19 can be evaluated if Sandeep have time,
but such nice value should be set by the filesystem instead of
the userspace since the reason is as above.

Additionally, we also need a way to set nice if we decide to switch
to the new BIO_COMPLETE_IN_TASK approach as well if the nice way
really works.

> 
> Setting the workqueue to use kernel threads of a higher scheduler
> prioirty should do the same thing, without the need to use dedicated
> per-cpu RT threads.
> 
>> If Sandeep has more time, I hope he could have more time to
>> test since I don't work on Android anymore: In principle,
>> I still think RT thread is needed somewhere for such usage
>> since lowest latencies is needed.
> 
> All that is needed is for the kworker thread to be scheduled to run
> immeidately after the interrupt that scheduled the work exits. This
> does not require dedicated per-cpu kernel tasks or RT scheduling....

Right and not sure, it needs some latency evaluation with
heavy background/foreground app pressures.

> 
>> Compared to the scheduling latency issues, interested users
>> don't care "individual subsystems needing their own set of
>> per-cpu kernel tasks just sitting around idle most of of
>> the time". If end users care it more, they can just turn
>> it off by Kconfig.
> 
> Distros enable all these subsystems all the time, so saying
> "turn it off via kconfig" is not a viable mitigation
> strategy. Proliferation of dedicated per-CPU worker task pools is a
> known problem, and we really don't want to regress back to those
> days when a typical system had thousands of dedicated per-cpu work
> queues that largely did nothing most of the time.

That kconfig is off by default, but all Android vendors
turn it on, and that latency issue is particularly vital
for Android ecosystem.

Currently RT threads won't be used for other use cases even
desktop use cases: Android workloads are pretty harsh
even compared to desktops for example.

Thanks,
Gao Xiang

> 
> -Dave.
> 


