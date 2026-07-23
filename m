Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82067C4453D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E353A6B00B6; Wed, 22 Jul 2026 22:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5286B00B7; Wed, 22 Jul 2026 22:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6A06B00B8; Wed, 22 Jul 2026 22:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EBCF6B00B6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:59:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1ECE1A039C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:59:25 +0000 (UTC)
X-FDA: 85018535490.21.568527A
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5FE221C0007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:59:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IvT+tuwv;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784775563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lxnP6SUwergpNTfnZVhMNth7W47feWOp/n3K9KDqgX0=;
	b=IYoE8R2GODwe85vkKPePpwsN+HZh7zTOPSz5VX3m9KY3oWSXLiPAYGDLZSSRYcnpzO0iXZ
	E79TZS3FwXJrvSd2eUX2hrTyDQm9vVyVaFKxAUKQ3BwxUEaMiQODBzbIaTvcqCtpAG7JJD
	JB4R6+TUXOxV3V4+rH4hMK6D71Wfgcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784775563;
	b=Pfs+I4jSw3xcAMZh8Bdn9kVequw9IgrIYZ8Wf8mVpNSGFrSP1Xp++YK8mFIJQULBMpzetA
	36TrfGoIMkWfyK0u0Vu76dwoZ/DQIF3NvDiWC8jkMthqekJnH1ITlzxxk+mL0cdsG587n9
	gjk14NFIMyerISZeG5DFwkmZsBdJ9y0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IvT+tuwv;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784775560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lxnP6SUwergpNTfnZVhMNth7W47feWOp/n3K9KDqgX0=;
	b=IvT+tuwvJNHdUbyD7+s3z1Z3+78G2kQUozmyyg3XdVZuRdm5rEjCKXQvTBYChs6T2lhGPV
	vV15mlwODOefNbdR27GrCSMo9gfaX32qzMfzomG8HuHRbLgVyg1W5aFY2vsIz8ab+WOkzM
	KZX4PToNn2LIZnvBxSNMoT+WGBQspKk=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -v3 0/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 23 Jul 2026 10:58:56 +0800
Message-Id: <20260723025858.1956584-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5FE221C0007
X-Stat-Signature: 9ghhioicm7yqpn1idjwbhejorcjs9kmt
X-Rspam-User: 
X-HE-Tag: 1784775563-936263
X-HE-Meta: U2FsdGVkX1/fZEWzR8ZPDM3PVkLqNlCmqgmAIL1Z/mK003GaLukK0J01zi7RUA39u4XAYAKc+rSrK5vrQYeSNWsN3ExXb9kB21pYqsROns+g4v1TrPjXkD/0YZ45m6dCaYZPs5vrh021U2UUvyB5H19a05irYXwP2ybX0Rm85K3tvUroEuxaVLv5ftyTrNS7Ty2kcy6C56lsoKR2/36puvkmvvzuzYlDfOQlWzcFCNZUrFejT7h2iB+8JGsvAK/q+D5AKZ876eqFQbY8kqDS101uB9qvjaQJjq3E8b5keQtWTnfx827p98SCZXF+YqYaEWomSgycgEYAggAZn6QkX+qjv6j1TZd9IE1MJs5ZE0CezDGaB2BYHmSdC6I7fw14rNOoH/f6CMiQmCavwqAZ6040YK7rPUHFBh1U+q9UUq68f3oLhfi/DTry1Tm/kdwir7aBOU1TPdkchluhE6qsmA/1/93UlOrofT8KmwgYcOQe7VdcKWXGihMIyT4ie8BPM3zox2W+NGT8QZkRT6aCETxLYOIkljqXLX9hyp9CV5J9HLhEr/fGwDTtVTVgxAY6qdiTiMsmi48HIkmW6FjuANDkFJdP04XgJKf4gZwDM+JGE03qCWWXUYQf+KAgPigbvx1Jj0WZE2TRTxJBYzFYxI7rB2C7hb5k0v6gIwUYcE7oEJh0R7PYYntVBIdcTq0mK5OSJ0NQyECe3vgyN9ISzhOHwS1TcZK9awIyvPRY4qJKSGh0uABgmQFrH2waXF6xm8tUnFscAKAg7rBiShwaBnssR2amYP1vE9FwtRlfKPbzpMwmb3fnQOKO1bSG4s6/7wEbz5nUBILfOBmno2HqN3ssA8WIk/UjPlsu9LGHsGCN/UqRTB/1K0Cbn0fiMNaR44ipoXLsNgIVdblui9IIpNuln12eozRrkaOBbmkr4l+SyW+1LGbBv1vU0STp9ra7koHWXIUABaZLK7vPyTx
 KMglNOme
 Hcolw/3+R98lz7YOD537QIa52jRMJcwZ4b9iQLqx59ciUiQp+BxOji/ENtw/h7vg5YkyTE/nUkq2BZf+OjBiZF2TqzW0Oiy56ZyV5Ad+NtgAwzgivvo/7Jen9+81xulSxB6G8lOSc64Z9lMdSBD0eeKKvlPIp4NM4CJEIqpxHmwaDFsgnvOMyb9S+YZ7Uy1bMZT5KxzjKUsjTQiNteJUv1oZK6CklLE071HR44Kc6E3zk06LXAnavrVV+vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The per-node proactive reclaim interface
(/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
!CONFIG_MEMCG, and the latter never checks proactive_swappiness.

Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
This is a prerequisite for unifying sc_swappiness().

Patch 2 consolidates sc_swappiness() into a single definition that works
regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.

---

v2 -> v3:
 - Simplify mem_cgroup_swappiness as suggested by Johannes.  
 - Rebase on the next-20260722

v1 -> v2:
 - Move mem_cgroup_swappiness() and vm_swappiness to mm/swap.h instead of
   include/linux/memcontrol.h. Suggested by Barry Song.
 - Correct fix tag for patch 2.

v1: https://lore.kernel.org/all/20260711091157.306070-1-ridong.chen@linux.dev/

Ridong Chen (2):
  memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
  mm: vmscan: fix node reclaim ignoring swappiness parameter

 include/linux/memcontrol.h |  4 ++--
 include/linux/swap.h       | 19 -------------------
 mm/memcontrol.c            |  4 ++--
 mm/swap.h                  | 13 +++++++++++++
 mm/vmscan.c                | 19 +++++++------------
 5 files changed, 24 insertions(+), 35 deletions(-)

-- 
2.34.1


