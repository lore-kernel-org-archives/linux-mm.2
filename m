Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B1ECC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FD86B008C; Thu, 10 Sep 2026 04:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8280A6B0092; Thu, 10 Sep 2026 04:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764A96B0095; Thu, 10 Sep 2026 04:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 589556B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:07:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1611A0497
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:33 +0000 (UTC)
X-FDA: 85197123186.07.C3130BA
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf27.hostedemail.com (Postfix) with ESMTP id A1BD740002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="j9pDs/JB";
	spf=pass (imf27.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789027652;
	b=rHEW8edoNJT++zeqxh0DcNLlLmbcDJ08c+pgGRVv1LWsnO7pOuKkSAzR8ceXiz+soGzS5k
	FvjGkqAOXRGfULAWFLoW0OUlDxhytrnPu9QIkkSmOmRRUWWzDP5G1qUB4WCGZoMyMMZBTI
	eT16LR1ItqVcYIfhu3izLoJimZbq9N4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="j9pDs/JB";
	spf=pass (imf27.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789027652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vs/fzTE/mrTKphlkA+LD1zojb3NEuHfTJzjqRzU7CnY=;
	b=c0K+7IZBm+BwyoRi8+4ezS8QF84l7BhM6wVk938qZYiW1Qg+iuwDciMxO1WmhUkot3K7td
	rH4cKprIgKBC397H6uJ+vmnXVydxJwjreQ61RFpvNp9CCcJn/+NLsBo2/wq9NrdP6acSgd
	TddodT5jVud+dBsAqhPsIe/13J9QB3w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027646; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=vs/fzTE/mrTKphlkA+LD1zojb3NEuHfTJzjqRzU7CnY=;
	b=j9pDs/JBC64I1l5hDg2DSciyRwuSSeULlA+xes6FOBAH4IGkBZdEyZCopb9StYehfhbVpmWrcCjVXKxfU8uqngQ5dlZ4+vhrIOEqRwECGkt9DFFuzUZONS+zyo6OQbmBxUSK4GjF1T9YHHBij43ZlOJkteWr27V6nWqiarXb0kQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I-Z_1789027643;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I-Z_1789027643 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:25 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Thu, 10 Sep 2026 16:07:18 +0800
Message-ID: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1BD740002
X-Rspam-User: 
X-Stat-Signature: 76dhdmqazdfi5fy89ymptoq9kwiwz8xg
X-HE-Tag: 1789027650-405488
X-HE-Meta: U2FsdGVkX19ochBlHWrkQPdhZQoen9IUK2a6tYx247G/qE9uHMYMfufzHc0Jl3EExdEQHQQe831juTYm2/yaxPBP4WTiMSKP2qhd5Ylok6dUMCo+0I2S4adHdNpcAuPwctG7YY3xXWvtUziag3ql49DmE+gNv9j08W4pDIZL/jXHhDEiiBgoGhlDa8hJAH52UEePG641wqSDNcEn06GZG2cvIzNSisFN8blTG/dKg1SnvpSGqmeJffv5uFFUBsj9UXbwdyYQ66PKrkr5xP63zJ1saMx83z6WT2n3mQ9WvpqSOqmtdJ4Gs+nQEZjgQVdq7rDIsSB4DdF8i9lgju2de8WMExxAt5QYfNS1+2Rwmqv6CrXkiOCDkkURDoli9CFAiOED9r55WsxVCLVISH/m+4re2J2VuPN5z51aPPPX1yliZN3+Gql16AoAW9KK1/k41P33fDwLZCgp2nBdGIfORnQRnVYYeDugiBc6YEAJPR2Ym+8wbax+bmBFVugYhAPy+0ZuavGRMFhn1IpU6HvOTZToIO9LT/SufRxqn0WRjo00jjRqdi87+gG4xK9BTtgWgdFvajhxvAijEIKXwdg/6rTlBvB3ArMro3OsNr3sho1ne0UHc0Y1yAeq/ZIlCxFPZ6+EQMEj8ih1+k2yIP5Yh6npgq+DuxoM8Ud8cZ3il6OTmsnIMIYc9IjWHqzFdVsmxoN0P7SQkiUDEVr9Gdidf4PDEcKEPva4r6Abfkv5+KXzla16Dcpvi7FzPLOZND+Tcomdl6hQ5A77MQx/HGpZGuVLqK9AeY7DNpiLpIYP3FnMtGsAYzkcvl8ru4+oEUSA2N+bjvUQ65O/onz2u3t3u67xAGvSpw0ZdB/+HMWiz+yKWB1DFGakv0l+K89cn/CuqVce+uk4hldoHYcIXh2arBNhFI7ERtcZGVhgeOQW7jDiTX9dAHl/wTqIyUI54x7OgE8XH3pFKBkqaGLhYHf
 CTA/MB3b
 mns/L4GP6HMoElYQSXcIB+3ONefgGKKzyOAvIL1GRYyzm1oNNQVndwxUNpB3OWwzoV00TXITsPCI0beSvQ+pfEhS52Ic6eEapik7samhtJjChd1WTZ4JDiZlcqKlIbv47/9y+0xJuFxZgH9FuZcKdipx6L+tmiFB2mb+EfQO6wItgnt4htxK0ynvUVe2UwMlrId/gkijEkRUhMNqx2ho6WkjvE5p4lRd02eh5yciC382a2EGqURYDbTyB0URwPet/N+WTCCMKmkDR+qgEOqzIKmZ2ErKvTHjEuvqoJePojVqJhm5mtyTZMApEuM6Ix5Wpd/YT4QZYbkXNYa6bH6vgJDSBEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With cgroup.memory=nokmem, the THP deferred split shrinker and the
zswap shrinker are degraded in two ways.

First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
limit-induced reclaim of a cgroup neither splits its partially
unmapped THPs nor writes back its zswapped pages.  v1 of this series
[1] restored the flag to fix that.

However, as Sashiko's review of v1 pointed out [2], the flag alone
is not enough.  __list_lru_init() also collapses every list_lru into
per-node lists under nokmem, so even with the flag restored, the
objects of all cgroups share one list per node: the per-memcg
shrinker bit is only set for whichever memcg happens to repopulate
the empty list, so pressure in other cgroups may not even trigger
the scan, and when it does, the scan walks everyone's objects.

Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
list_lru"), THP had fully per-memcg deferred split queues embedded
in struct mem_cgroup, working independently of kmem accounting.
nokmem only opts out of kernel slab accounting; THPs and zswapped
pages are user memory and remain charged to their cgroups, so
per-memcg reclaim is still what these shrinkers want.

This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
memcg aware under nokmem:

Patch 1 drops the kmemcg_id copy, which is only assigned when kmem
accounting is enabled, and indexes the list_lru xarray with
mem_cgroup_id() instead, so the index works independently of kmem
accounting.  The list_lru plumbing passes memcg pointers now, and
memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
online/offline hooks.  It also drops the nokmem early return from
the offline path so these lrus are reparented on offline.

Patch 2 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patches 3 and 4 restore/add SHRINKER_NONSLAB on the THP deferred
split shrinker and the zswap shrinker.

The savings of nokmem are preserved: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to per-node lists, and
the per-memcg lists are only allocated when a memcg actually holds
such objects.

Changes in v3:
 - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
   instead of the private memcg ID, whose lifetime only covers
   online groups, and pass memcg pointers through the list_lru
   plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
   the css online/offline hooks (patch 1, per Johannes's review of
   v2 [3]).
 - Describe in patch 3's changelog why fafaeceb89a5 dropped
   SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
   original discussion [3].
 - Collected review tags: Johannes's Reviewed-by on patches 2-4,
   Nhat's and Yosry's Acked-by on patch 4.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
[3] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/

Qinyun Tan (4):
  mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru
    indexing
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h | 15 -------------
 mm/huge_memory.c           |  3 ++-
 mm/list_lru.c              | 31 ++++++++++++++-------------
 mm/memcontrol.c            | 43 +++++++-------------------------------
 mm/zswap.c                 |  4 ++--
 5 files changed, 29 insertions(+), 67 deletions(-)

-- 
2.43.7


