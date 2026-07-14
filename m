Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C87CCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 07:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66656B0005; Tue, 14 Jul 2026 03:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17486B0088; Tue, 14 Jul 2026 03:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06456B008C; Tue, 14 Jul 2026 03:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB0A6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:58:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2AAA402B4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:58:26 +0000 (UTC)
X-FDA: 84986629812.29.4386DEE
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id C4BDD12000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:58:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1FTh+Jp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784015905;
	b=4qdsPczhXiKSNvFrUH05niSy7nZc7o9lRyHPcE9K6se8qvEL7DeejLD6t666rfjAuDYvNp
	7JALgFrZ7IgC+NqPFv3zsog358uwvPqBCr5O44K2FphzWwS1Aav4Z4jIocf5KXn/WKLBGg
	2GILKZKnZxQ5cqHoCQ6LELb04zTlWzc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1FTh+Jp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784015905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkniB9iRE9HjM/WA7MlrZBOT68W89sN6W9xYL05jo1s=;
	b=UCa5W6bTeEyh0IXVPZqugrHMhbe6raStorLXBU3x4RrQHGE/pJk5mdwRqBIVIQnZPYpSEW
	KvDN6UUOF+1gNcupTgEhQGua7s3kVIqrfjr2GGLn0cPRxYVlGNM9sB/LOjR+3pqfOIaOsh
	s7J/lG58QwOqN6qhOy1PO2HKj25UImI=
Message-ID: <0f52a483-27d1-480a-bb0c-99c108e676b5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784015899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkniB9iRE9HjM/WA7MlrZBOT68W89sN6W9xYL05jo1s=;
	b=n1FTh+JpAeQQlCuAEVfL1kEPAaqwHzkFyq0bcYfdQFGZcO0WXrEo1an3hYHF+gNGckdoeW
	5qY5kmuEbYAKtGE7erW9NHPRe87+U8HJgjM72MdPXsD+Yp+HGcq2+bX7BIH3OOEFUQ3DnR
	KqsX1p+oGDyvM7JxdHHUIec785AJgP8=
Date: Tue, 14 Jul 2026 15:58:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>,
 Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-3-ridong.chen@linux.dev>
 <20260713112803.GF276793@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260713112803.GF276793@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C4BDD12000C
X-Rspam-User: 
X-Stat-Signature: 37ocyuummbumox7buot3quuhx1m5eryn
X-Rspamd-Server: rspam03
X-HE-Tag: 1784015904-626312
X-HE-Meta: U2FsdGVkX19hJwIF8jz8FQ6wz8vWGHQW6uTqFmoNLZ06pdlnrBjRNP6EhmuizfJ27vifWEL9qv4j2rjLS29FywIdxv2fPfJe8BTXof06toFmw4VrXTefnIshGg0sseUbyk9YJ44vztY25c+5w1hV3kJ+ezIpGGrkPcW/lovJjw4hLwe/DOYK0OidPhtL7kVc/z8/xR4TLWHYtzQqpMGZgvo88xnoWhJ5yhiWwjPRszDfvUxqWB855Ti0Mmf6eXIqlxXr0L1VahDCwpCI/cP2sWqfsM8hiOlI6MPbrb2HvCwWaZKrhwsZI6pe36MNKvp7VI/CFQZJ1te7VAhAyk8mcboPhl9ivbaPLOlL0EcH2y4nFGGNo52NHtjMh07csZBz7/ErHNYB8IW76BO8zOIi+BXTlt2ldT/yP1+Svh4Qs9NClPB1BhUPN9KgETk0yJWS0P3I/KfA6EJoKtwovTm/KFWMt2Va6VVwoLoX1akwI+UlI52rO6ZKvygR+YCWv4yoLGHapwU260CmNPh5axe551CWr/6Ix4y8MIFioKC+o53LSa/voN3SvrXVBNj7oSh+KlZQUL0jWCmVJfEcCBdQfXF1/BCFcWFXcDj6wqxwB9lSxQKM71CH2emXCEhqLw6dElIF7wbuIbsyinjziJTsvG7f0nSJDx2J2/wCjpWK9+xH2/JJiFALaCNfyaSFotfR1gw8xWRaiETS+fm3vYoZslE+nyJRQmfx/BilrmzgEZZvcFzTHOv1AuZVYkhPZwr6MQOUvV2qbm1pNeAHKKmqaXMBUGzvA1Aau7jqxoo025TbFfo8xiLFQumP/SReI5q/4QTjrr37ycxsyq8j6hn1G3npEzKohRRDP/qJL1Zk644F5D81CTZHp1LCAxGkqfMTTG5QbOxAEmz0J6kWNIuzyVoRHMLYX1u6jtcSfMwgx1MCVlxzx9BejfhNOyrNUhhxCcN3qI1paQ5gsfhcvF1
 ibAOkjNj
 hPMySrFUy2SYOQmHFTUM+RGRXJg1mevZu5/gfrpxQ1nCIqVi4qB3JimfrrO0o4UTruOFhFPHamDH3wl8Qf86RG3xKcygb1gpwzIOVXwf+W3fw3M3ipzyeXrlz1NcFSXPGe4oCSCJlFtW/HLzJkzxaEkcC+4F3oNkaakR7JQ+SayV4005W3pbFsELzpQ2uQLH9TMcI3NcU44II2yQQVLqEOmyUPy4Jh16SBwOjbcXAnJsSl5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

> Probably warrants a stable CC for 6.16 as well since this is pretty
> user-visible breakage.

Thanks for the stable tag suggestion.
I checked the commit baseline:

git name-rev b980077899ea
b980077899ea tags/v6.17-rc1

So this should be tagged for 6.17+ rather than 6.16. I'll add:

Cc: stable@vger.kernel.org # 6.17+

-- 
Best regards
Ridong


