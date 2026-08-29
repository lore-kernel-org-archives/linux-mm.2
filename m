Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C51BC61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 02:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D026B0088; Fri, 28 Aug 2026 22:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405FE6B008A; Fri, 28 Aug 2026 22:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5B36B008C; Fri, 28 Aug 2026 22:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0D06B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:23:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 856FE140611
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:23:35 +0000 (UTC)
X-FDA: 85152710790.08.720FC42
Received: from mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 645681C0003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:23:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LphodUxq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787970213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVQSx10JSsuNekdLQ5SfTTAo7yFc50nA5E1OrvPW0kk=;
	b=2DpEFiNkTaqwWryGZFRZfSLAH5/8VWXxdnUsMkfpFE1uEB6OwZlUdGJUxFA/EgH1VbcSse
	xamIn6VZwzAXRTwcIoeDU0xX8MmEt6tmhcD5oHu4hthq6a/FmpaP0PESxQeW/TgXId/U7Z
	d3SLdnuew3ZjSgoTby/UDY36d0j54J0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787970213;
	b=D3MH7v8wkLuSbWWlpOuvcqV+eSi5iu8IKUtwkAw4qWYT98Ugl2qbmf0nbFlUHOyIzU92l7
	NaKTwJJdrmqA/5TSiciYsBHNnr1rUtAO6DUV/vaUxSw+C6k38cHz3csVj9abgNslQAQdCl
	AMl53iNWZJKl1zibDoUF1jHC/+dwVgs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LphodUxq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9dpmGVCTK6YIdLHcSKf21OYzQ3WaSDmWbAA1Hj8B9Aw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787970211; v=1; x=1788575011;
 b=LphodUxqIwLjzXmbYSyecuzHAK3nEZfEyuCVbt3lT/QWRtQkeXy2tooU1oGia7tb2a3ewg9r
 VF1G90pSwum1eVmbLoM1qlW0cUM3Owe7DFseTqvubD1zROZsFyyT4zJRy4ym7su0aSswi6qyCwy
 jLCthg6wbShYkzQBRBVWuft4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 167889d1c3b5653f;
	Sat, 29 Aug 2026 02:23:21 +0000
X-Mizu-Trace-ID: 167889d1c3b5653f
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 19:23:19 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-ID: <apJCb-8RK0azF8_h@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 645681C0003
X-Stat-Signature: p5psm5ge9o1pwhs97hakuekc99ged4yu
X-Rspam-User: 
X-HE-Tag: 1787970213-1049
X-HE-Meta: U2FsdGVkX1/qrdFpsYEcKb+mSxqBT1/kFdQUeM1FbA6k4i415y33TKw6N5wP3M9rtCbAXf8YrSafaRYfJt8lcX7b0uDLrnHhuE6YkcFvycqUIf9iMzZqNiqq+MAEz3nfnz7/Sq+DccGxQAzbkLImd0kGVj+wNVlLM8XRaoltp5cLTNRjEmApTWwtjJv6X8fGJdckn8GWcoTZD6swc8P7FjHQ+rD1t1zLq3riKsUYBqkE6TSEalDNil8e8ada+yBPimra3mZY4qZBo36ER/UYrytBA1hfuD51dveLMP6+rXybYu8+/GaV53zBMY+KicWdEDtsrHZRCprEqq0UnWf4SSybvscVUonZRjcWpEqVOoddGKfxRYY/GsgpZGVoyLzMBbD/N80KACGNIAF6T7cIQ0YB6iVUPM3n/Q4NQTiG+JtN7f24QHo+NSzbNrv7rAc4wpmK6liwOEWV86uTbhx42ufAyzk/izHeYx+pykjnAK6dU08KevUG/C1FCdldmtf5iYw5O59ZHPh2uL13OMvJ7LiPVUapUu97v6sMltqYs5qtWFeZARmBmZta/sCmzklqb5cqFku+fv5ofQpxjsW7XUDn/J/bx9qi1bXmSUJAZnQVqBPun1sy8GPRjeegSqIM6ZnPNQFxyAOmHyOXgdqc4lV/MnOE8EvdcIFK5ZyIHLDBeuSN4noKvfkNEW5pmCGVxmoaPi1URNFjHNOmcXCU6E52+7lNwJaUefQHdLxxjpHfav9BDkZ2GxVdOPVd1gM2rv/sOWHMWUXET4RpwAErMIQRUUvEk2WtStYENlEsT5B7NffIvqcVOed+yYU8NZ+u8B1vJQAuU8dc/jyJyv6L9Ykyv2XwO2wKcop7FBzST0sTaoNIMF562o4R5++O35jqwJg6bk2q/0dGNAHhV+sGVxUNlA0MQUgfzlCI8mHzQ/s6kP1oPrQp0WWAHnQ7Pz5tA9bAbYlNXqBe1qCFtEd
 ZHf3MYRl
 o4ryeGDeLvwF2YVnCD+c9Iw9gCC/Nk6Iz8XUbTLK0BU414On2xgMDiJ3Y2aRkOa0xSll79jeHcESJK9pBMNLsLyd2/8MDZuQYOQ6maThBwrs+med4B05R/h3S3tQN17SblCohD0RJEzWtmMassOMsDaKZemnXUsbKWDJ2GmEAAYsLAaWxUQVX/QU1X8Xy9ZgzuT6pwSkq5zsVmnAcy7mziERjzC2+ZIdLEb1c7NAk+1I4i4lvypbDyeRpetk7ft6V9MjiIvyg10uDS6/bFlt2/aNlGDeGAqGN66YYlU48ZBa7kmLcuWFNV9WzSSK+85FM7ynN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> target memcg set, and thus the only way kswapd can reach
> lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> reclaim. Do not reuse for anything else." comment and a priority hack,
> and it simply never got taught about MGLRU.
> 
> Rather than teach it, let's delete it. The v1 soft limit was deprecated
> in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> soft limit"). Nobody has reported depending on it in the ~21 months
> since, and v2 has covered the same ground for a long time with
> memory.low and memory.min.
> 
> Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]

Andrew, should I resend this series (without the first patch) or will you pick
it up?

> 
> Shakeel Butt (9):
>   memcg: make the v1 soft limit knob inert
>   memcg: remove v1 soft limit reclaim
>   memcg: remove mem_cgroup_shrink_node()
>   memcg: remove the soft limit reclaim tracepoints
>   memcg: remove the soft limit rbtree
>   memcg: remove lru_gen_soft_reclaim()
>   memcg: remove the per-node soft limit tree fields
>   memcg: remove mem_cgroup->soft_limit
>   memcg: simplify v1 event ratelimiting
> 
>  .../admin-guide/cgroup-v1/memory.rst          |  49 +-
>  include/linux/memcontrol.h                    |  27 --
>  include/linux/mmzone.h                        |  30 +-
>  include/trace/events/vmscan.h                 |  14 -
>  mm/internal.h                                 |   4 -
>  mm/memcontrol-v1.c                            | 435 ++----------------
>  mm/memcontrol-v1.h                            |  12 +-
>  mm/memcontrol.c                               |   7 +-
>  mm/vmscan.c                                   |  96 +---
>  9 files changed, 66 insertions(+), 608 deletions(-)
> 
> -- 
> 2.53.0-Meta
> 

