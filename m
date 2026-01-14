Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBE8D31A12
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5896B008C; Wed, 14 Jan 2026 02:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E75F6B0092; Wed, 14 Jan 2026 02:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C316B0093; Wed, 14 Jan 2026 02:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3FB36B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:00:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 716CBC1AC7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:00:58 +0000 (UTC)
X-FDA: 84329672196.07.70CEBAD
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id B6AC91A0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:00:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0El7bEYO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Jz9naQgKCJQz6B476yC4CC492.0CA96BIL-AA8Jy08.CF4@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Jz9naQgKCJQz6B476yC4CC492.0CA96BIL-AA8Jy08.CF4@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768374056; a=rsa-sha256;
	cv=none;
	b=m7ZIShp0fd1NcPRMe7CZ0UduD+NnYg0JnaYEdd2NyyXXub6sthc9Avbxz0FEMOpiQ1mowF
	lcGg9ftdNh5hUuas7NXFLl2IE3tj0UeZIw+pwlDScPHZxLu227lIXGLzDV7K9u9JUe8JnZ
	ss6Cx28Qkf+OCim6U7+mrkj4l/uHZUg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0El7bEYO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Jz9naQgKCJQz6B476yC4CC492.0CA96BIL-AA8Jy08.CF4@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Jz9naQgKCJQz6B476yC4CC492.0CA96BIL-AA8Jy08.CF4@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768374056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cyv6P5VtGm/MbLQqPn/8e2BMzUG89IA/lF6ABr1FhIs=;
	b=DEpIIATApUVWTWqC1Pf3VUKKaLx5L8Ca8ldLljPZ8GCPgNKax/8Kp+3AdgaMnaKxcUKQAs
	RBWP/W9GglaIQ+R2lq/tsrm04zNIByINvDjrqbiee/DnU8y7pcjTsYdNlXJZhB4JGjhIlr
	/o1OxoSwHBT5acIs/49JT8gURHiBXnY=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b1766192e6so7298448eec.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768374055; x=1768978855; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cyv6P5VtGm/MbLQqPn/8e2BMzUG89IA/lF6ABr1FhIs=;
        b=0El7bEYOb1eQPI65CZijEBmVp+I7I2h3krjDNIGDwXrZk95q3WdOQjs8rGzaZ8mHlO
         Wl2IKAmu1adJYfrCDhFGdS2925ObaCMUUlh8qY+/JrFlqbAWqZKqNyy+CjM5BrT1XWa8
         cHmYPvOyhlKICVjY73aOBajTMJWxePcepdey73VH4UQpZshD4W9pR0nLzqUNrlTQOQGa
         QPFNVCtV2tDGbBMr9pJSAeGJjV2cAOsH7m+oKyJ4UJo59h0k+9DsuyCBbsRZ1GG+tESI
         n+nuCE9dsLiy6MiDsJ1WVNQGYIgOzhNxbp1guLn59UnwJXAX1YKNSvfvw+6nSC5kSL4i
         r7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768374055; x=1768978855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cyv6P5VtGm/MbLQqPn/8e2BMzUG89IA/lF6ABr1FhIs=;
        b=NuZungkf9QOJnYsG+0+kC99EFRw0/+XfkJbDLlbRO7hH5URcOSPo4aT96wKl9Nh2I4
         IbMVH0RonKqlXIqqInpW3aepTNYXkpnwb2/VBO+u/CGEEIVsntn1XZV9arEKYJHOZNlT
         dpcc5n5uNC6n5+YybfoK6kukxiVBbdmLTSDDdaHRltUuIjp+P5KOXfyhQbpI5cvI7t1K
         x956RsEax/nax9NZuXnRLJGwnMmPTxeRC57GoCxadNV65Z5eroSHjuoBXQO64NeEbvGV
         6NC6y7XTQT9aSe39imn2vBAFZRamnmsoF6ZS5+DktUIHvk0I4ipAEYd+9n5BpClCM4FV
         rrBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGHK83IAqEsdeVq3DCzDfLKTxHv/BnkUzKt7qsn9uOC2yfFbyVMn9Ysr+yj/sf9vOUNam4IErkdQ==@kvack.org
X-Gm-Message-State: AOJu0YwS5O6wCVWiOA7YwspJ3ZhdOlT9usO9EFZd5JLKm/bufyjAhqwk
	2tYJc4FFqS6eNFUnOVSPUJk7opZAg4tmYj95GwTdA9xNZu9f63x4ducpZ068kkuGTtuDZXmpXoz
	hy+xV71gz7Bv+HA==
X-Received: from dlbeg14.prod.google.com ([2002:a05:7022:f8e:b0:123:2e41:8b40])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:3f84:b0:123:3424:eb5b with SMTP id a92af1059eb24-12336a400d8mr1564087c88.18.1768374055383;
 Tue, 13 Jan 2026 23:00:55 -0800 (PST)
Date: Wed, 14 Jan 2026 06:59:48 +0000
In-Reply-To: <20260108033248.2791579-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260108033248.2791579-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114070053.2446770-1-bingjiao@google.com>
Subject: [PATCH v8 0/2] mm/vmscan: select the closest preferred node in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, chenridong@huaweicloud.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B6AC91A0004
X-Stat-Signature: bgrbuzaopzfefjzhf1h7guzhn4nyidfb
X-Rspam-User: 
X-HE-Tag: 1768374056-419214
X-HE-Meta: U2FsdGVkX1/TZCjZVW6KQpiL4BpkqaIsqUPMomrl+in1n67lErvFA1JB1baT9ZSzSo8KP/3Gkb8jP07Pb1z5UC9Mp3PlvUUU5+EPmFA/KwtDy2w2QzAAomloI/LG/Lu0PGS9LP7ZG5i19VqRDetBn7/QFDQVSstOeHD/uJoBsrfZ8tGsem3T260UcHE6oqc2Uh5rfs6tc3aMGfTpJz7wSGf/dzsddxIxgEh6/1Ptd2RtQF5E0qPlTM8DK7mU94+dwmwvnJjzUMVqAvAB7huoav4zFwaJNv57lygcVYrimbn2IhAvYg7KLMBQRlQ3Ql0200ik42GkCbjktCffW9YslqRy+g61kxAF0jzPKqOXe/073OTlaNZ10N427RPzHIdwdMOqIX8d11wsAWDSpPW4ckM1NnXbyO5comD+++9GTB2v6YRleN51/9o91c/7rRO7gCrBzkE5zmUjTMSxw4t0KcgF3jEREfYobBUJCUQ1yrWK59l9629aJoW0hVa61Jr0Kg4kDmeM7YlfP+bvWzyvacry51MrqWA3+83RZB2wS0nGrI0ZpYYfEqBVLhLy14F0f/vOOoag7wvkNtf8kpogMs6b5iaI24uH6buXCTdKI+goe/W4IQnA/8Iy5ngRcYtZNzrssPqsYuAspWKxGE13BjDzBLdQaUTQH6Rz2Jv0ZmntM1A9Gpv7GkgH0yYSR+pkiifKmvR2+WowHTIObrQvOD1dzNvynCT/vasZ0xBVhTurlEPL/eJlGuPIcUhzNjZDWk3gg7Iqcz8bWN0Iwc6IO2vY09dkbzg8cVSIsToy1JcsN0mBK1YTqfbfSSzF2DHwEqVdheY9xU6Nv/b8hVojTa7oPeaKmYS0llGlnUpA3+981WuyaK5t3H9KVWIfSXuvclIvpDZ/A9NGwh+YgBWscUqJi9eWl3lUpOcEQqoAPpBwy0ndjoF5TtfQbpSKu22x58JDX53awTvH9MhowfD
 vxYZT7/d
 NAgd179aUaGl5M+MDX++70YffLdJSxxO+wRnwOxg3kGGR3zyBx8/wO8Y3wIuLZvYXjTu+I3TFpcYYEl1tFY9NQ7GhpQWvcyXDXVGedrhT3Cr/X4EJ+4Pr6hKru6bftkHO/P50NWQP7Qt5KtUpwb+5kGYeM1EvWXa7hXkIDeQBmVF0V7YWIy6nB/xKVXqka1rpyNoKEssD/1DRPViqVx7nPOypCCBXhjElWMVq2K4RbgE5J6UBSafHeSONy5ysGNZvQZMwnoxUwIUfv+wCYIwiFHhBwkY+TBWrgmkyseWGj8Gtp6qyOWF5zNfomP6kmeJYhL76ggxdo2y2k/q/Fs8pou75OuAhlOZPqVUiUlefyFzHSp1U7jvN24FqshDpddG4ICXHXdfo2GhLgOuHcJaRxIeZvzuRZ53i00FUlGfFSWPmG4cTZF0Akc/eM75nDX22gsA8GcI32VbkXbeNs1aG6V+8TwDLNQJLocGpxEFGd8w+TZbwBCR6v+h2gT/jugiZHEey+WqaVNIKzyLbHAhvmXxRtYONZYuQ3QpeleV4VwbiBF5Tqux1vdb83yWhU8LwwA1jYcwnV1GVaTlD4/xAU9zzKv2j2PpPDrekdM0Km+DpRbo37XvvbJWKU44A0CluSzipeHEDrrXDuqqAV7c3OqKkt6W9mhDODn5y390KEFy4goM4W+9o9axvBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Patch v7 2/2] tries to traverse the demotion targets hierarchically
until a preferred node within mems_allowed is found.

However, node_demotion[node].preferred may not contain all nodes in the
next memory tier. For example, in the below typograph:

  Top-tier  Node 0 ---- Node 1
             |            |
             |            |
  Far-tier  Node 2      Node 3

node_demotion[0].preferred: [2]
node_demotion[1].preferred: [3]
node_demotion[2].preferred: []
node_demotion[3].preferred: []

If mems_allowed is [3], demote_folio_list() cannot find a valid demotion
target when demoting pages from Node 0. Because next_demotion_node(0)
returns Node 2 and [2], which are not in mems_allowed; the second call
to next_demotion_node(2) returns NUMA_NO_NODE.

This patch uses find_next_best_node() to find the closest node when all
preferred nodes are not in mems_allowed, mimicking the logic
of establish_demotion_targets().


Hi Andrew,

Could you please remove Commit fd8cb9a8cedc ("mm/vmscan: select the closest
preferred node in demote_folio_list()") and Commit 127714c76c46
("mm/vmscan: fix uninitialized variable in demote_folio_list()") from
the mm-unstable branch, as this patch serves as a full replacement for
both.

I suggest allowing some time for this to be thoroughly reviewed in case
there are any remaining edge cases or issues I overlooked.

Because no modifications to [Patch v7 1/2], I did not attach a new
version of it.

Thanks!

Best regards,
Bing

Bing Jiao (1):
  mm/vmscan: select the closest preferred node in demote_folio_list()

 include/linux/memory-tiers.h |  6 +++---
 mm/memory-tiers.c            | 11 +++++++----
 mm/vmscan.c                  | 30 +++++++++++++++++++++++-------
 3 files changed, 33 insertions(+), 14 deletions(-)

--
2.52.0.457.g6b5491de43-goog


