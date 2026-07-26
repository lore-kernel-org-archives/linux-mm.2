Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FACBC531FA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 05:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880436B007B; Sun, 26 Jul 2026 01:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830E86B0088; Sun, 26 Jul 2026 01:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746B46B008A; Sun, 26 Jul 2026 01:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 499D06B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:57:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B88DB12031F
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 05:57:53 +0000 (UTC)
X-FDA: 85029871626.08.2D4121A
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id D37FA80002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 05:57:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gu7fnFA/";
	spf=pass (imf02.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785045472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgy7HKoDwUU1q2Cv23+1u+utSeqsqofimkXnRhKfzCc=;
	b=2CEDAOjvUQ5tqXqCeB9YZDB1YsiaV95uOsyYSUm/O2HgAibvxzkuTnsFM+R0zRCZ9zsZx7
	xm7NZMgMMMElExOy28gOpMgGBzrdXJUF5b7qbYaICudQH9AMIza/pixy9YY+9K0S//LX85
	1DOvnZQHcPrOohB2huCcD6DuZ11zK8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785045472;
	b=m9OMgqM+kHy6OWKqKJT4ehRFKehDo5twu8T/geCqfpCgbSMZlMFybTVOcFRIZoHufUSzLX
	OeHbC9JEP6xd1IbDG5MJnzOViY7+GvgPK2BS82heyufjKMiwzyrscCXVSea1rSETvG8fwx
	xrM5hIo1e02RDhxEJQ3RfMJYRgD/Kyc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gu7fnFA/";
	spf=pass (imf02.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d1ad2a71-ae4f-4c2b-a322-0bbcea951287@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785045469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgy7HKoDwUU1q2Cv23+1u+utSeqsqofimkXnRhKfzCc=;
	b=gu7fnFA/IB/GMxZ3sgqLwB1o1wUe1twXi7uByBDbnQAuPZaCqOl1U+zE9dBDSly0rmdqAA
	cpaMmW1Ky1ZaTy9Hm2ZVm5vPZVUFrJTPTO7QIGZ7LIRSKajURoyAF1DOASUA9+vlOLDcjX
	+zLk0RyFgwxBnzwtS8oacP2vq2Gx/LQ=
Date: Sun, 26 Jul 2026 13:57:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <20260725204251.f96eddc5fbc8e965546cc292@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260725204251.f96eddc5fbc8e965546cc292@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D37FA80002
X-Stat-Signature: b7ounsocofr84nb3htmik9o39dqgbiry
X-Rspam-User: 
X-HE-Tag: 1785045471-568056
X-HE-Meta: U2FsdGVkX19s55jZS3T1gah3VXkGbzQFWxr5KXE7Oqdyn57zB8iVmizh0u+uLSR3ho1W9L2Gqic5/kORJRDYaX9EoQrEyu5nPefvIgd8rEcrw2ZiewfW0F2KF7625cS0SrkCr6lVf6LKROUDZAeRxZDvBHohYOFD2bsp6c0SbQraY1Rk+X8iNwstLlaTcybb+N6lPaqvdOzkmVKkZdvPFSg91B1dTffbCqmzZK22IbHTVG2Z+9Efq7VNgzWjWze/GDfrJjlofvIJDIu6a3PRKD+ysK+RLdcUtYCG4eHSiNid8jdKSkaUjLA0gtC1LSCSU0VIcKQyQ068Z5S0hg1pISxyF0XYd/YEr5BcrUsMIUN3VZZUw9ynr+LZQi9BqSmb3uZWK0cShZQrIONACCaSuBDuCmWdMjAJMcG9lfTO2rTsQQQgd20kqEiCjxqDk5gzJhWBwOfN5Hd5WHOhbHZqwQoIQKq9V06BhzOy4p9dnz03+cN3Q8ZuMiWQqRhO81NhorEj1SEw2TGWckHLTHRfaM/SnQP7+MpJ0ktEFMnu4zYesojw9YXs+gDFeF85RkDMHkE1eibf3bFidrDh5e+WC1Z0T4jKdfsidiT3OuxmrODIbtY286N9DibOmm7Yyn3QHB8MQNbtYftsoPyt5oVHBh63cJO0iZa3G5wOyb7MWNDf97rQ6vR1dLoY9sYJHFkFfHHrAyjLYbP7YsR5B0jOE9Z0ArVkTq5vNfMdI1GxtATsmjhxahCWpii/JGHcb1gQntORTPhF7OFE9lLAy2wHuYJQ8EIvTssV9ccAUVa/b7YpR4IMLp7rbghtjC6LHxyz4XKy3yaKSDwyhWCRPcph4XgnNdgNxr1jvohztTGLx9eu//2eaS1bKbFl4qW0z5KGKEzTeHsHk1nds6Nv0kzaD+bApWyQfG1QK0Xr8ZX9ZXZm8Gwkf0jl7SN0Sacts/qJ8mUZcAUnXw1PKQ7Iggq
 u/UM4nJA
 pPbB7VnoIZOh1aOLbdHLHFnrtfW2ze0S/LmXIEASAHURPbXnzuQprK64CzzFBU/7wTRtQbOYJNeGjopMlWKcvySjXSHLs0yGPoKTtb57nsHKedVDcRgtAiRt4JWcGFJk+hnHw4L9kKooT+6qFn4PmrxeqWg9w8z42vLgtMOvvpTxKxWSgn4uXjxvgamhUFcrzEdLr3nWaACyQ+Mzn3EwdcRbilGCSH2FBcS36VjbDtiVxTWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/26 11:42, Andrew Morton 写道:
> On Fri, 24 Jul 2026 10:18:05 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> kernfs serializes file operations only per open file, so separate open
>> files can update the same memory.high or memory.max file concurrently.
>> Both handlers store the new limit before synchronous reclaim, but
>> continue to use the writer's local target in the reclaim loop. If another
>> writer raises or removes the limit, the first writer can continue
>> reclaiming toward a stale target.
>>
>> For memory.max, this can leave the writer looping indefinitely once
>> reclaim retries are exhausted. The OOM path sees sufficient margin under
>> the current limit and returns true without killing, while the writer
>> still compares usage against its stale target and records another OOM
>> event.
>>
>> Check the current limit at the start of each reclaim iteration and stop
>> if it no longer matches the writer's target.
> 
> Thanks.
> 
>> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> 
> Dec 2019
> 
>> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
> 
> Mar 2016
> 
> Having two Fixes: targets is confusing.  The Fixes: identifies which
> kernel versions should be patched, so how is anyone to figure out
> whether their 2018 kernel actually needs the patch?
> 
> I assume one of the two hunks is for 2019 and the other is for 2016, so
> two separate patches each with a single Fixes: would be more useful.
> 

Thanks, that makes sense.

For similar cases where separate code paths were introduced by different
commits and have different affected-version ranges, I will split the
fixes into separate patches, each with its own Fixes tag.

> That being said, both versions are so ancient that it probably doesn't
> matter.  In fact the bug seems so obscure that I'm not planning on
> adding cc:stable to this anyway.  Maintainers, please advise.
> 
>> Reproducer:
>>
>> Populate a cgroup with anonymous memory and disable swapping. Lower
>> memory.max from one open file, then restore it to "max" through another
>> open file after the new limit becomes visible.
>>
>> Without the patch, the first writer remains blocked and repeatedly
>> increments the OOM event counter. With the patch, it returns normally.
> 
> This is nice info - I'll promote it into the permanent changelog.
> 
> 
> I'll queue the patch for 7.3-rc1 and shall await maintainer input,
> please.
> 


