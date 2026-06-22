Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7F0CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 16:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F726B0005; Mon, 22 Jun 2026 12:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77726B008A; Mon, 22 Jun 2026 12:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D5B6B008C; Mon, 22 Jun 2026 12:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9160A6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:38:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1ABB6166435
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:38:40 +0000 (UTC)
X-FDA: 84908107200.23.D461203
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3BB94000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:38:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G0xGUlj5;
	spf=pass (imf11.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782146318;
	b=LaOFRNfP5wQbfIFuZzKpPZB5VM1BkcClqmLukDl8Uq31px8kc9CKgOnq8cOo0tHh3gczP3
	FH3To3J8BOXwhiGA7tkumu/rjJY1A/u4PLjobNEEr7nXfHLv8E+HtF45PaoehEg01t+mGW
	sSyruyZGuUpBeQ0DwQr8WuyxYHMq9ZQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G0xGUlj5;
	spf=pass (imf11.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782146318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2HLTO5tyNJPMYKw3VOzgy0NWTUYIs4xZWvzz0/vGJQ=;
	b=gX2UKoYxqfgPisVDtZtdOYCv2I++NzO0yOICvRRwFQHnNGX0VOCpgZ4ERHzpkq7zMxM04C
	XZ/ktWYcZRrQ3ky8WtK7NfCJKtq99sLn8tpRYH5wplKZuHv8RRjMTBRf4zsIdB7EiyAAfM
	uT/6nAuWmRW0JY2/e0u2ZQlIj42HWN0=
Message-ID: <8407c3ed-cade-4ab5-b6d7-78f83956e013@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782146315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2HLTO5tyNJPMYKw3VOzgy0NWTUYIs4xZWvzz0/vGJQ=;
	b=G0xGUlj58gBLaG3E+cxhFrDel6gO0Ct1/wEVBCM1PEeohMTOXVmjkZVU6yDw+IDnhSqOl3
	k8jghyYemtAWpfUyIbEEiUg2zfNj6jby2ahQqwtCvxiv40eMxEkabjS9l8roppxVVfGUef
	UZ6Ti8kGwwGCf6Zc5oq4/5NVcuZ/Bck=
Date: Mon, 22 Jun 2026 09:38:18 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, usama.arif@linux.dev,
 akpm@linux-foundation.org, mhocko@suse.com, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kasong@tencent.com,
 qi.zheng@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
 <06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
 <ajK1YsIJmD2ImbAk@linux.dev>
 <1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
 <3149bc84-dd3a-43ba-826e-6364965fdafd@kernel.org>
 <bbcb6db5-6a01-46b7-979f-dadd52a5176f@kernel.org>
 <d4b55716-97c7-4e75-8500-6a1171ad7fc6@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <d4b55716-97c7-4e75-8500-6a1171ad7fc6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f3bebkx8axh4qxdnpwgaoxp7k54p41kn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F3BB94000D
X-HE-Tag: 1782146317-677490
X-HE-Meta: U2FsdGVkX1+k+bAqPSVI8CPxvCeVzo4tGO5lWBs8ayg/mCnbbsGHWzemviY0wz9wXn3mXiZMukjuG02xOXyKvnessrFHfQFQxI4SZvLSZ1CMhUbIfoCpR9VAQpSgSDCpPSbRWrTq4a1rRijAM3kFW2LrJTZmHlrLQX71eHRUjFyhS4GVgq1/dXkrDd7FO05rhBzIno5LSxMwy/1+bOtTP+mDJCTwp++djZgFpfNEaieWCL82Hm9wovYJfJVGqBQoF2z+1yZs0fI5sVNhoP4DJ6Uh9XzB/bHCbA42msBK14qSBca/Fr8vm/7bQ7pBQh0ADRw/BfKNYMyUUaeGwMZ5ltstdATwfZuOn349mhEMjK4C5e7GubC4/E7uZua+3Bz4/UnZfF71YRJ6g7cmQ7T8k6L1bo8RJ35V1h9MmUvywhHsOVNHfQ2ShUmC73RxS7ZbM0xe2Z8/nzReru3vQwTXEGGyo0nA+Qoi6CqgdNP8bQWSxd8hwy1UsAOHa5pEBoe2tfPml9FSjxAxyF06wznqzCFPwswH91pIpjop+zJIodU8ptrIRT+TLg3i6M3oXVpSP7Dj2DSG1gZ5hFbnKnzcVhbSOLvl9WAvX/i3PeooX1saxLCGxBpI2lUDYT2TQG3U8WlMr/MNXiT7RsWXe5qS0bbzWx9Zd6V5KFqienY/a0HYVj9Ef+aoBKQ/Ass43xmPE1qeWsXa4U4YpIOp/AM3NRqWCKNSc2vJXQJmkSAACThtC3TEQisiYl2H9rOMaTvB/JwQ9wllt5IKII45T4Ez+DuilWNr9lUJw1l6VNaUlR5Yx2Cpjuof9HWsROrMHEyMNkSafu191XwgAu1dUZSSipvE8N9m2umENm+UWEbjegMi9pEWyuWWtGQm1NbZI5aUVVHujoWIaayO6nL7aJlhaj83rY9wlqEtiUmpesA/AiWWOvH/3qp1JR76ta8aqQlb8Ma0Z5KoYHuNyJMN/mT
 AcyZ3V4S
 EwxE4cD31FbQt+UIIHbTwxCDap8CrY0W6aIH8tjI//i0T8vDTnh0BjbUD4bX4RYjFjrBs/8Mmac8TKM+hivFq4lw2O57ZRUzdH0Wyxk+jhqcL0e1/Jec58Ixkb6uygRDagL8OWGS8ciyuvWs7f55itbRqph2yGZE8673z/rQl2E2lHKKiglYWEL0vMwKFyY56SaYjssb564FkDc1edPEl4FmrOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 5:38 AM, David Hildenbrand (Arm) wrote:
> On 6/18/26 10:30, Vlastimil Babka (SUSE) wrote:
>> On 6/18/26 10:21, David Hildenbrand (Arm) wrote:
>>> On 6/17/26 20:18, Vlastimil Babka (SUSE) wrote:
>>>>
>>>> Yeah and I don't recall ever that a change to a mm tracepoint would ever
>>>> break someone who'd complain and we'd have to revert it.
>>> Really? :)
>>>
>>> Read the context of the link I posted once more.
>>
>> Ah, I see. I've only read the single mail from Steven that referred to the
>> old powertop breakage and didn't notice the context.
>>
>> But I don't think these worries should stop us from adding easily usable
>> tracepoints.
> 
> Steve explained a way how apparently scheduler people are handling it without
> trace events.
> 
> You can always remove/modify tracepoints, but not trace events.
> 
> Anyhow, just wanted to mention it, because so far MM didn't rally know about
> this implication.
> 

Thanks for pointing this out. I'll sent v4 using DECLARE_TRACE() to
avoid creating a new event.


