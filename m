Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0970FFA0C2D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F30B6B0092; Wed, 15 Apr 2026 02:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CAF16B0093; Wed, 15 Apr 2026 02:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607E76B0095; Wed, 15 Apr 2026 02:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D60B6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:05:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB83AE3B5A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:05:12 +0000 (UTC)
X-FDA: 84659752464.20.F9C8D53
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCD5DA0002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:05:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Q9DUB2a7;
	spf=pass (imf25.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776233111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3Bvp+KpwAJJ/lnzTS+tDvjyO24nE7JkQWZFHl55Uq4=;
	b=roQAZ4eWZTAJ2IWJdSkC+LRY1T6D9sAbwYHzMxoNaRAiBGjcoNPD59WG4Vm5bICZd60ivX
	T56gBUhHwB2vGWJttiDLkgUVRZ3MG8t4PoqfgHhGyXPu0TWEdu4mM1H9Nh4BbSLRu8i2ms
	F0CLUuYJJEDwGcuy7K7pjjA+927sjwk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Q9DUB2a7;
	spf=pass (imf25.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776233111; a=rsa-sha256;
	cv=none;
	b=7RG2CAxREA8kdUirGtKYLnxwkNuliPV85Sm/31ND3hFLQoqDEzmah21KRlHYmOQFMRJSZY
	45kkvunHcBlKu+QtZc9/fiEkDRm/eauS94fH9CJal3Fu+hX7ELsw7kCtwY2xcaVgBQyERC
	duX72n8CfOgyWlLAJHIxMc2KLZbjSmk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776233105; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Y3Bvp+KpwAJJ/lnzTS+tDvjyO24nE7JkQWZFHl55Uq4=;
	b=Q9DUB2a7UuNlpv/cNBHtuglxexo/I8r4Q1beNTTyJnPqMmK2fmlufkPUAywPj7TicG9FYhJcUAZSALQ6jtNzHMO3w+sECOb+0U55/hN9hTJzbAF/ED+OxikvJgHjJV7ob2uuBk26O07oNFWm4wpH459GMlyEnt9eKL9h6PZ5Tu8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X13erf3_1776233103;
Received: from 30.221.132.134(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X13erf3_1776233103 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:05:04 +0800
Message-ID: <58d1a07d-e266-4d58-9be9-f1445a68599c@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:05:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
 Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Sandeep Dhavale <dhavale@google.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Thomas Gleixner <tglx@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Anuj Gupta <anuj20.g@samsung.com>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread>
 <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
 <20260415055552.GD26893@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260415055552.GD26893@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DCD5DA0002
X-Stat-Signature: iwpsnp659rrh9yqpynpcuzmqmqoupr74
X-HE-Tag: 1776233109-632356
X-HE-Meta: U2FsdGVkX19mHv7t/bX5CiUBK9VKdPpp640K8An8ZBasUpx8o1cYAC5lGDGEcTW2cs2jyfvzl8qQMuc2fnnNTyyXl1sNjTn/GdGTJnqseb9ibapfm0JVxMnPbuLvPRQANIjZsaInrlLBgRBRL8kYwW0mP9s8eB5ZBRJo60YZ6LJXxu8zg4Eu/yAuLKX/LluWbnn+YokNelWXKv5sRJ9wjw4biNjcaMyV7rZrS1k2A0ZktendhHCJSossD6DZDuvGr+UWfb5NIPlDkMZpI64kJVUcjUOG4V/SyU1SASUJYSlJgRhjzcqVX/QZkWKg/nDtKr1/1fS2VfioY/pQyehRzasaKutGl0IBkQ92fvRSlm0GJdvxO8wre/4joxcubnR+Vxc/AJJ9nt2YOIBwlE6cvpF3uGEMjO8Or3tsuvuvUsXpY3pVpBlgv78Qvqs8fpNKmrUE5JFiMXYGTpYlSoccgwuOW1yiDpcDPzqBTiPw/QCLjnPxEWGIJDBPREqU1gTC0mfLFqcnqTQnP/r5QY8jXveuOXQB4YE7s5mdkhCERbB9orGdroMFtHNMKeu7SwP/cCSPYS7Lmrkb36sn83hk2sZqzi6mEnVErCmCTrYOd5BlQykvRHVxzwPWKE2DFpNnPVW0Raq3m4LRmgtf2fmr+JPuCTCK37SDtqo+iLI42CGjc4TuSKzlHkuCu2khT9JBwGZUbU/SQeet3hwYEKgIM1raDq0VgQJZW1D6X2Nckr6oBTUsBPWTgvn1UgxyEWTu2cdcgtitl2zSOpaJuXyy/cqpca/wjFWWxVUHWPcWu4JPvUbgbhUIpRdmq7iXawdoLAcGNpxwBibwJ1yKf7HJomX3rNgAImHEte8PvfXWy6192NHcO0OPfoV+lXd7K6geobPNgI/TtiqJBgTy8cOsEE4Oq94Kllu4vpeJ0q4pMCqcAnS2Qps4pKHmILi2n0D39GRGbXp66Gskvz/kPfx
 r4vtGAJj
 j6Wc1XiCclFIQdhjpxuQZ7aP2otG7/sCPCUhS2RjO1DybwBE1zfMC/hmnQCJP3NU8AnatXfBoAM2p7ixDQztfBHANj/TSxQc7DSsJ1KskU0VL3YrlH1o0dXq7UJvUQmnk20yq7Y4fkFnZaZxiojAB68FfCZIuycRro+4EEjzQCI2SMjchaYJUw3imgFdxiaJ6/xJ/VU5Cgyt5SEyBwmR8GmcqK1NE0htM/07PWYMHnVzJ+MDJ8FEZHVuxObEiEHHbOlfuZtetTdiCCEK/rQM9fy+9h3V0uOmr23qF8YhNPvmnOt57U/iJ8KwPktDdng/xZeVovSqim9OjxfxW5X4AG5X2l7Kpu0rdt5I8dBftAepwfuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/15 13:55, Christoph Hellwig wrote:
> On Tue, Apr 14, 2026 at 10:23:13AM +0800, Gao Xiang wrote:

...

> 
>>> Tejun asked Sandeep if setting the workqueue thread priority to
>>> -19 through sysfs (i.e. making them higher priority than normal
>>> kernel threads) had the same effect on latency as using a dedicated
>>> per-cpu RT task thread. THere was no followup.
>>
>> I think the issue is that people are not already working on the
>> same topic:
>>
>>   - Unlike large subsystems like XFS, people don't already work on
>>     EROFS unless they have new requirements or urgent production
>>     issues;
>>
>>   - The original latency issue was already considered as "done" in
>>     2023, and I'm not sure if Sandeep could have the bandwidth to
>>     pause his current work and test more setups according to this
>>     ongoing discussion in 2026.
> 
> Which unfortunately might explain the sad state of Android.  You
> really need dedicated people around and help to improve core
> infrastructure, instead of adding random Kconfig choices.

Sigh, let's not regard it as a technical problem, and it's more
of a non-technical development resource issue among different
resource groups & vendors.

The detailed background is much much more complex than I could
write all down explicitly here, but at least I will try to
contact with Sandeep and more related people to test again
in 2026 if a cleaner approach can be worked out.

Thanks,
Gao Xiang

