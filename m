Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CBC9C4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080856B00AB; Wed, 22 Jul 2026 23:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030F76B00C5; Wed, 22 Jul 2026 23:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63F86B00C6; Wed, 22 Jul 2026 23:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB0846B00AB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:25:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20E70A0FEF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:25:01 +0000 (UTC)
X-FDA: 85018600002.26.4CE5D96
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6FDEF80008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:24:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GvZkGeK1;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784777099;
	b=NJbTLwY+T2ySK97INfUJYZ3h6kJN00dFbhkCy7Das2cGwmbwPD+QiV6eWYNDUQ7kgDT0UF
	fSrXJm5FqQfCAPBv4cO2wvU5zjoQYejh01pOC9/khKpwupYvdmPGVW66w+xh3tc3aPEBFY
	WonJJ9+yfTMg37x45mkNE/VXitWDwBw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GvZkGeK1;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784777099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rZhMI+Xfi/MnQ7cYAB16qZh1E4VoFljWZHADbHhtJCg=;
	b=HBz/lqz6ix3OGsPej0jkQVni0PIROrxgeiOl6EdmRGCh4dhmSkuAmV+lm+IHcnkpCScFEZ
	PjIgduQJIYWQNJiDEabq4/jq9aNe9yYbVOStasXnT/7S1qv/qJF7qeMkbhoHEnj4HNR9kK
	1UqoL9iLuthO9eC6+jKxtC3S9CH7VZM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784777096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rZhMI+Xfi/MnQ7cYAB16qZh1E4VoFljWZHADbHhtJCg=;
	b=GvZkGeK1NssUvw2Hd/UC0LKe7Tvt5EcyWhdqxxdxGdvIgpyYh6L0pSkLMfJCwftRKMSonH
	MU5GoMUoBdq8aM5+8y4Qd00TVsA+kJfR1J2nUU4fz4UlmRg1JciiUh3yK8mkSM2LD9AFjr
	9uRHyDYFLi70knt4TRJdhsg6QG71WoY=
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
Subject: [PATCH -v4 0/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 23 Jul 2026 11:24:32 +0800
Message-Id: <20260723032434.2016749-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7r1pftpr16uzfocrn1n4zbocjso718xo
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FDEF80008
X-Rspam-User: 
X-HE-Tag: 1784777099-411170
X-HE-Meta: U2FsdGVkX1/BiBxjLOWshv312pgvGZB0jk3dEoNPa4tna8rMJ062kyWDRyIDXmaMW/jN61DRNO/i/VSnyvf6Sq9vZMeaVbhYlhkkfvsYiJVk2MfOloFL+fix7bzoMlqf9x02YjSFzuNIisizut4g3HAqqzYiw8B25+OKbsRJrMt4ibvw6L0CttLoOHRHNWsTow3YRUZOwPdK0eCIlqyURw1wEg4uX+ROZrSJbGaLL9ogZpEkxJdjweKJv5m5D7mvwZiTaVBXNX4ajpCQSPevsZj0hr9xR1pttPGXS1kgGzdfZoAfJExklj5SwYW/quUCkdDxTtAnnyYWoLADwnoS9Y6o/u0Aqkym2+qNj05h0QS1uRPPwl9De0LJlWMvI6GM4jD/sH+0vYOZPVcDMwUybR+bvjDyXVOvufI3sf9k3xG+LL8nMGHScdVwu/Wgvjigy+T+blJUjkPPcuzdbOwICxq3k4yDdOCwwwKIm1kZ+jbLPvIm4g0mlExsHx7aRk2a159eGbodSYpG/DHJVMc+015OEsMBPNp0zsPdX8ySGvU5MFMjg+DL13sV2jeKfDG6eg7kTio7HEm01rSBfa7ReEhqzXsWu1Pz97ZODsEDIqR4Oef5ufM5Tqjey21C8Clrl8Bo+en2A6M0Zj6VyaFnXEUyA37c1qStUO++zmYVlmuxz5NADgctQBo+ehBuiHkU6WOmp6CcKnDyCKakDsyk1K8ZPanXEVtrPHgnxhcBqc3P5ckfrTVj81AzxGSByK9vP858u2xlnr7GpQ65g+GPNhZvHLt8hMneDndCtQ37szENlB/q251US48GYTb0FPmi1ljeqP6WUINBTGDb6rDxc1m6CcZbvBSqDVN8myLpsjs5zy2ptcUx2cVu02o4+5+suJSBEZM6niwt+rqwXxtnw2cnP5d4fz85oAUtiFoYxmsphKxPtBP8I/dZ3dvHZ3MpRB3OVAnD6V15MGekjRN
 r5V0fNoh
 CVZV8xuCKn8wUN5AkRZbsmdJqlt3Q0m4IhZBIaV+vmxAf4kL4y4lZm9Pmj5KOOAEAOF9D4dMixQlqkqfV+atYy3InpdJr9s91oyc/HXZ28JHKI0xtF5MU9m7WjauXdGXSppFNoFKCINi4viP+qOOk87hNsc1zICuIb2sJLsdostcsQmDnMQjYsr6PE/Iw5R6+g1It53VgiX8eK0AqTAxQlh695dAjgPmWDDNEnP7UF2PnNhJdIeAfVig/iA==
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

v3 -> v4:
 - READ_ONCE() was missed when reading memcg->swappiness, add it back.

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


