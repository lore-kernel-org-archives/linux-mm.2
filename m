Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C881F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E7C6B0089; Fri, 10 Apr 2026 19:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CEEC6B008A; Fri, 10 Apr 2026 19:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4CD6B0092; Fri, 10 Apr 2026 19:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5D66B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:53:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D09A8C2204
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:53:57 +0000 (UTC)
X-FDA: 84644301714.11.E34FC51
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1BC5440003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:53:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nAdQFYZW;
	spf=pass (imf11.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775865236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNH7yjOrTqdECFy4P+AAkfpojvo5A1fv4ak4vr+ZOKE=;
	b=Ap3bbjzeER4n5gAGmI1SFaTvkP7NRu1m5BLph7WJjGWbfyAj2EElqC7rL/5J/cRIcVJJPN
	+0AwghtCCbvEJPocQlXfdUjiRmtqljEA0wC5G33P8auTdqXThWvMGB2kGUKxKrkp5TSXP7
	SPUJIS/Sc1b8v3L1Rvg4RBqfT5/RZTY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nAdQFYZW;
	spf=pass (imf11.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775865236; a=rsa-sha256;
	cv=none;
	b=JXVHjfv3BQ8BW4tbwHTLQ6vPfb93Qn7oxZFMOpMl+8omgyPEtfE7kY2AEGDwfAkvvLcF+Y
	SXJUYoM6vaQEwUQDokAzbrW0DpPoX7MfHBQyVM9/xCyXDeem6byUsOSWlSo6sXBU2IZV5r
	MMPnpb8n7bfS/gMHE/xqnfL553EWrRU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775865231; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=RNH7yjOrTqdECFy4P+AAkfpojvo5A1fv4ak4vr+ZOKE=;
	b=nAdQFYZWDhEu6sYJDxqkp+pTnZvcvMVNPBACwN5HY+4PwRm/lWQJka6Ro2qmW/MilbeP0NG1bYTfBa7DJrl8UwEDo8L0C67pPaw0rlLDbk4WVlk/SjFfOuVVhO/0MrWs4PR5etzhU5v9gwQmx5JvO3KwsoI0mEXGyY0wx8VHfGw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X0mPuB0_1775865229;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0mPuB0_1775865229 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 07:53:50 +0800
Message-ID: <136497e1-ba93-465f-84cd-e07eba110978@linux.alibaba.com>
Date: Sat, 11 Apr 2026 07:53:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Sandeep Dhavale <dhavale@google.com>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
In-Reply-To: <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1BC5440003
X-Stat-Signature: 1nepgimizkfa7mwst1phdjkuzrbotjxx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775865234-257232
X-HE-Meta: U2FsdGVkX1++0gHe69tZ83+Z214h6gkewrTwAf359n86On10/wFJqqWmmL3nX5N/XD9tCx/2Vd4ApKI6Tl37vNy+I0mGWF3cB9saQJZE3+ndKcZEKKgI7Y8+OtZaupM561+npYIrKG/UqHOBfeWUePh3yBY5D/1Y1biM6gnj08V5DMsPj8UbOQci2/GbvTYiT16PWZ7eWcugiLGk145MbWPAoLh7m3ruKtTCWo7iDTr3baSobhKmNjoLgyQh97cJ31UFe2vq9XWUg10wsVos3vLbePyHkg2GsQnZISOW3Yl4TbdfQBNYtPiGJ+no7JfnH7E5u4AgCAg4xAY2u6tApOuYcYgrobYUdBlXZ1y8h0HVghfz0Bf3sL7hMs0ZBrzDNeefJVP8CQSTi8tkJd6WA5kx1/yyuAUHrLZp0vgII6Ce3OmBS4sbwQIUGuIWdKzDwCuUUhk108lMjVD/gikxXOiNYRt4v25G8ITU9BrWeRL385xWdGbYSfUkSJQD5e/4s/07DZwPbIbLloHI+wZzCieZN7g7PV8OYPhuCC6pB0PSUON3DE3gzYLNutmKyQ/j7Bumj5P2rDUMiMQ8ZZQYdmYTWxwHB6yPfea//ezJYqSoHirm7seDbgZ+ufQ/CsUJ2ObJX0+wenrx1q/EhhZDLzTkznJjs2sblgX522i8RnYJUAqJBWUY61e/1l4l0EYXcdqw8mVzgrBTyb03ekP/0uVziUbB+Ts0PjWyEaXLMwUEQ3DhU9/83j2mlHmqFQu7G1ZmR+u5hj5lXvJU5b7gSUdtt/i/OZreL7Hd2AXJTNXq7hdWXhCghEsoLc98KqT+sXYFkmkvujj9ThHfZSWmg8MXcuDIrnWvJj8ZFcA1ggpMymycBJW4hsIrEpum3PNQAlTVb0knwBiFfYEe/jZsxXUPtVsuY28UlYrDuAu5gRYtZAWaIpTegKInxmdlLmZrkJLiWKHpR3eKQpif0GP
 uJodPO9W
 lXhqshVTDacuIlbMsn4WJgLFAULxKrzO+SPt71tPNY7qvARi64cdNOXfCs0XK0XM/IOq9CIvKBiM3Y2CRBjSZAH4gPiS+LZr8qd9i9slLb4Ai/Aev8kJGAyhYzsg9s0KFB/LLwIf3Kz6nee3xzyL+7CfbFsI7S86YqE2YxXUIrN2NWTNjSxILXDVAu4ud7cBRvySnF1aehEpSHG4n+vv/xoC62GDBb0BVdCypQkl3Xtwhbf83fYeTvSkbEBLlc3/DTsSSNq+o7bvtllLwtLGbPmVjD91IFh6AomjTZOE8bpB6frSeZBpJCsuwMoSsLwJvGacIf1ttzvXLB5frWlPzJDP6xts8XwMOJR9zGRu8/e4lKgD+bxxHpi7D8hGPbbx3uCNj80MeZAuegrPnzQYZDjovbN6Jfg9/T7TsCQL1bmVU0ttxItC8GPNTAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/11 07:44, Gao Xiang wrote:
> 
> 
> On 2026/4/11 06:11, Dave Chinner wrote:
>> On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
>>> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
>>> option") explains why workqueue aren't great for low-latency completion
>>> handling.  Switch to a per-cpu kthread to handle it instead.  This code
>>> is based on the erofs code in the above commit, but further simplified
>>> by directly using a kthread instead of a kthread_work.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Can we please not go back to the (bad) old days of individual
>> subsystems needing their own set of per-cpu kernel tasks just
>> sitting around idle most of of the time?  The whole point of the
>> workqueue infrastructure was to get rid of this widely repeated
>> anti-pattern.
>>
>> If there's a latency problem with workqueue scheduling, then we
>> should be fixing that problem rather than working around it in every
>> subsystem that thinkgs it has a workqueue scheduling latency
>> issue...
> 
> It has been "fixed" but never actually get fixed:
> https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com
> 
> and workqueues don't have any plan to introduce RT threads;
> 
> If Sandeep has more time, I hope he could have more time to
> test since I don't work on Android anymore: In principle,
> I still think RT thread is needed somewhere for such usage
> since lowest latencies is needed.
> 
> Compared to the scheduling latency issues, interested users
> don't care "individual subsystems needing their own set of
> per-cpu kernel tasks just sitting around idle most of of
> the time". If end users care it more, they can just turn
> it off by Kconfig.
> 
> If you think it's unclean to block subsystems, I'm fine to
> leave it as-is.  I'm not sure how it impacts to others:
> either some subsystems implement RT threads (workqueue or
> block), or leave it as-is; Otherwise there is always such

^ Implement dedicated queues somewhere using
sched_set_fifo_low() for such latency-sensitive work.

> latency issues and unacceptable for end users.
> 
> Thanks,
> Gao Xiang
> 
> 
>>
>> -Dave.
>>
> 


