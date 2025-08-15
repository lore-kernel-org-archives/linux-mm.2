Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50CECA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791566B0453; Fri, 15 Aug 2025 13:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7425B6B0459; Fri, 15 Aug 2025 13:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6811B6B045A; Fri, 15 Aug 2025 13:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 528C26B0453
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:09:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4CCA160215
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:09:55 +0000 (UTC)
X-FDA: 83779629150.03.FA81C0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 37AB040005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:09:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QGxoWr/1";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755277794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2Z85ryQMCiLEZOkWY0WJLIQh91rW8ROkP9Dp99EAEs=;
	b=v+Qdc2yKpdU3fu3Lwo6Cn6KwPvwU/vycWlwKZ2KLZTfNJnIZ8Xho2hKn0Tv8MFYRNHnvJx
	3fGU9P6NdY/Zb9BtVnfxwyUOvT23rlmM4mnRlD04wsdmyny8HNqmUu8bPa4rbDVO+JZlRO
	6eTJY0fhu37/ZxvVjOthKDGl7om8CoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QGxoWr/1";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755277794; a=rsa-sha256;
	cv=none;
	b=Yoz/5RCiBlKfH7AqyESX+ULXPPQNxcSQyV2pK3Th1Th5wXghcvEv+i8msf5HFygaYAMEBO
	4hN9KjJ9tmLY9VKHoGtuBFuM/U6b4mXWTYWjGV5NlxIkgahKoUTETFrM7Tm1mhbYlPZXtS
	59S1cOv5U7IGHdp/lo6SmzJAREl0xJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D44424415F;
	Fri, 15 Aug 2025 17:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E762C4CEEB;
	Fri, 15 Aug 2025 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755277792;
	bh=Qu8pNllR704yd2oGMGGcH3W9TSkSrkz9APPlj1PqlRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGxoWr/1P6Q3mr3Yv+WAyUlf5Ad/x3nmefYVfial3km//O8Xr7zbICawzTyr4VN5U
	 ZEKdXxv3g98hqKsKEzBGmfLdYJx+bpDvIRY3lx6bjX0JMdGHC4B/ug2ITzLncHZM5M
	 8r4u3AVsfLr5+sPt6bNuM8iwImZzM/7xduWMeaqyPxQQ0VATnFd52CK1wS15gCXIwp
	 IsOJbDgT6bEeAxuFUZ0ZJVTPG/VE8CLOU9Mb3uv5nCTRM81emMA2wT0sBVg2hmfj50
	 mMN5ydFRVef+iaQWpcDwsHH/MS3WsvvL+ab97kC3ZQOqmhaTAkpLexwg4L5fhp2FqZ
	 7xLGAy7OfrF6Q==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] selftests/damon: change wrong json.dump usage to json.dumps
Date: Fri, 15 Aug 2025 10:09:48 -0700
Message-Id: <20250815170948.16297-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250815094029.133063-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37AB040005
X-Stat-Signature: eyxm189hhobef7ozeum3grzywcuxgznw
X-Rspam-User: 
X-HE-Tag: 1755277794-19549
X-HE-Meta: U2FsdGVkX18nyPwCfaKP+twC8Gbg8kzmxAZf3a8MzAHowY+t/Et39kjdA6mVz6C4xGWN56vj49jeT77yMMzHou3/XjsBq2aFK1ZmsiQGs2W7ee82WhrvaMxntj60V9vdI4a95cIknWucpA2oDMtdAZrIbLxFQGwXTtMPneLksjmKJH1B48N/X6+MxRTQwyfy6vZJZL4ZDBVOozjX/digU/NNTJ68PMmLtjsIXB1cYoPjAOJlul9iXfnnc+OAC7xmaghIMoqFm9Y9MZHY37CdBPjDu7SxtPB+rDoi34VJ//v05L03HEACSKSRCHuZDNeizeKRheB6KDCN5QA6T668MB7W+SsDF2MPt+/AiFnScZLbth1PCuqKQAVl4Gb8pHqVLQ13e19d8qTQ8MGJNi0yY4sjeuAAu5jT+C1srxJQEOwjANBJ3jSpwBRg3b6K/+hYnfc5YYwbpZMUPB4dH2ZfqwJEFuaN53kd3TpXGmw/NVo883O08ByJMfnaymuRP3BHzQUdc0iUIWeD+gVPObOEx0PZoaB8qfSFn2G5kpzoDlkce4yr4rE5E2DdxDBH9bWvKXp6hoCy6JoImxqfHZgwk20apYvNEfM27itvW7BxE15/O9sndKY7luaZot7NcrNJFckokVYrjnfguIUskrm60V6RYGB8b4wIVK51oz9veEB2BESztnEJBQugeIwVCgEUmLGY0Yo5Shm3qNer+GoQOSHTqBu+JPlNQtjsM6o2d5NYhvyy/PsU4jLcJ6dIaCbTvfuhRUzBzGt3Y6QYE/qGQYIyTqltF+zgqgsLVivPaM0c2PUtqr6tG4+Rx+KKeGhG1ukKagmdyLbWofUTqfi9ssFCmUb1JrDyixI7h+3yt1p9kU7JmeahBmus8JdMZSVt/TMlYwZZW3SmMlN5yN8i+4Y1u6mQa5mAPg2tVXoQfSzo/b/b1mwjWHujvryuHxcPGV1wzEgcuzetikO7OwT
 uxfWvps2
 JGC1dRoxkngdSRN7kkDbkc1TcozyEmNy0+meH0Tfbuq9pRHazA0e6cg5CCfY9xLnb0IGwdcZ4fV0hJG2P4ZstYvLLv8Xgn0UT+WpdWha/sdNRqtMcu8ThQI7kk1X8vqylCEsdtEXNMAT7fWvwqlWXRhGvFw/hRkGa5M/OZz4Pb3InmXqqxgge09fIIZ2h91xEcbmhIQPklbNMWANPujFNwBB8p6XldpjH/QfxPYsqZqWaGW2AaUBIiKM3LdjXbgRFSozv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 18:40:29 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> To print drgn status to stdout json.dumps should be used without
> json.dump. Change incorrect function call by typo.
> 
> Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON status")

Seems the fixee commit is on mm-unstable now.  Since this commit ids on the
tree is unreliable, I usually add a comment, like below.

    Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON status") # mm-unstable

Also, add the destination branch on patch subject prefix, like,

    [PATCH mm-unstable] selftests/damon: change wrong json.dump usage to json.dumps

These are only my personal and undocumented conventions.  I'm not sure if this
helps others, but it would help me.  Please consider using these conventions
for DAMON patches in future.  I'll document this on DAMON maintainer-profile
document.

> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> First I'm sorry that make you guys work twice. This is fix of my last
> patch [1]. I'll be more careful next time.
> 
> [1] https://lore.kernel.org/damon/20250810124354.16456-1-ekffu200098@gmail.com/

Thank you for clarifying the context.


Thanks,
SJ

[...]

