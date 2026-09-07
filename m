Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFDBC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764CE6B00AB; Mon,  7 Sep 2026 07:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715D86B00AC; Mon,  7 Sep 2026 07:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652E56B00AD; Mon,  7 Sep 2026 07:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47C166B00AB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:01:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDD2F1C00A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:20 +0000 (UTC)
X-FDA: 85186674720.02.0BCC8A0
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf20.hostedemail.com (Postfix) with ESMTP id 415B91C0010
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XvEVLdfW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fOZgTIi+9CkjJIkHZ5qDJVF7Cb2c4YKm1mdHlDBaqAs=;
	b=KEkUQVbXcStSufHlGDBlBu5I+b3B5XSbG/C7CfFoMvBEmSIg0LY2vm+ssawwSoOCC2LSZe
	n+oT9rjoysv4zARe0ygxuma19DOIfdE5ZVa6Ly75AS9EC/H6iML2ltPrvs7qgRwOwqDI2Q
	Yt6HHtNu0ND9RQGqHhVzWDZhnjGfA7c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XvEVLdfW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778879;
	b=cYJEP2I1GMki47OQP34ylHRJNTjd95vMeVRJxVTiA1QXckgJS8SWTwagjYK8hzBk5kxrxq
	R+83csZdeM308r4TL4ESqDv/aqe/GjoCv56gpDSjLsLTU7O/L2UUlqPaDoOqO2aMlbsUnC
	HgYuO0oYANNWhqYqzCP1jMJT6CG0MGA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788778875; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=fOZgTIi+9CkjJIkHZ5qDJVF7Cb2c4YKm1mdHlDBaqAs=;
	b=XvEVLdfWo5jvs4KjVjXnGS4DN8+wJnXy2KcvLZVvGdH35iHKbJ3tdk19w13QAFThVq2on7GwN32CivlRcFvqEBZUWIHcH3MZWi3Zsp6UIOyrylKOBFX64jDHXhZ0Zf6bbVkgZFGDEwsigebWf70Rk+0fZITt2Fdt5TyA6qkFi04=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XATsvzD_1788778872;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XATsvzD_1788778872 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 19:01:14 +0800
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
Subject: [PATCH v2 0/4] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Mon,  7 Sep 2026 19:01:07 +0800
Message-ID: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hgbhib574g4ykbqpyipy44j9w19ysyob
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 415B91C0010
X-Rspam-User: 
X-HE-Tag: 1788778877-47943
X-HE-Meta: U2FsdGVkX1+PENO+zYBYULDES2Xse00dPqMnDU+s/rVHGYkHoVrLFaV907a22+dV6H1YDjVw+9cUEU4LRSrf6oJWMCuK+XCT91lcmop34qdpwyr/YHedIEZHED5oA3s05ZQnI9+Lrk03HM/6cT9b3l5d4xRxJLXfMh5dRa4Dq+6ixfKqtM0QcYCmAIgROspnOL0sFm/TdypBV1dxGCBkOZQjTDAAq5QYfo4lsjSBEDJdOzbqfXR6TnXqLkJTfy+WBkmG4KRVfiA8Dp59LmAi3mBdTfMmrf5vGLqVZP1rfz/UaP+tmwSriZh7BTGJrESxCre1NKRE2XEfuP5Khzv8sVsHHcDYbOsbqXuB7lg1AwzbZWHZRdfUMO2uv0PR0Gm1X9gg7cGxWGwE0gyof3O8GtCmVRNMcHIvWG64HbqDD5Y6Aj1hlORKDA9p6+VmldckOK2iApGCKG2iExRa96k4Bb2aYt7ZxtCyn4tnOeXsNIc802gv7Iz5zw18AdYdcH/F2Yts/H7p9RaalyLNdOD5e0EbQpn7VyBBsuGVtIIouly85bejlmd702oHi0X3ZR65WC0Zl/C1VH1/4E99czxQ+yhA1qevTUxtaCJeapI+pqCzvixtxpWlrkLy+qfVifEK9bo/hddSacK7Ym+y+fbok73AvaEyEbWRxkAoshGGOuqpoft0z3sRUL2gkCo4CsulP2ICDGJ+KtuwYYDgLyW6X7qJt4P/vrvwzDYfT4KnTdH7QISBAyG/NQmrV0LYaG5Ar9k0vKxFDQc6etgE5/p7myrq/YVHPOrtmxm1F0Zs4zfvoKOxI4jwEowbyiIYsSxUC68wa4Icm0rMNZ1cZUfWsXmEg9FJY1LJGvh1s0VGX0GERkvi4fVspI+C73eVf3whmiDQyLFZbEvOs73ZFx3Q5hNGWYVyFu4KlIBKE0eLDVrlslq8BoVbxCvFO2SApJGtYtjY5AqyEzHKq90F9MM
 hBSPtB92
 YMbK44vK90B+RNRFWF9muFlJRZglre13CLjtsRbHWdgAowp6wOBKaatPTMNqlMo9XhX7TRD8ZNUEC9ZWctbfZw4pd75gUG/ADVK/Q2FrX6Wf0z1mz1a8kb0uzXfAayV6qKzT9b0Ge1Ye1RFmwZZSdOzF0Xk+Z7o23sIF3YSbl8YBNi5y/BFmJqd38EReuu4IGq13Z5qh1081BxLsGoJzGulcv8H1Zx4jFsg/zdY8LLVY90doN6ScBLCnFXjyliy04SGnxm8OJmDCTwo5slmaX4FQ4/eeAq5EnA/t5seMtYNcS7kauRk4i3FLLM2l9SPX4r8vhMhUJW0D+BS/Y3NzHN4Lwyw==
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
accounting is enabled, and derives the list_lru xarray index from
the memcg ID directly, so the index works independently of kmem
accounting.  It also drops the nokmem early return from
memcg_offline_kmem() so these lrus are reparented on offline.

Patch 2 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patches 3 and 4 restore/add SHRINKER_NONSLAB on the THP deferred
split shrinker and the zswap shrinker, unchanged from v1.

The savings of nokmem are preserved: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to per-node lists, and
the per-memcg lists are only allocated when a memcg actually holds
such objects.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com

Changes in v2:
 - Keep the list_lrus behind the two shrinkers per-memcg under
   nokmem, so the shrinker bits are set for the right memcgs and
   scans stay scoped to the target cgroup's objects (patches 1-2,
   new; addresses Sashiko's review of v1).
 - Patches 3-4 unchanged from v1; collected the review tags.

Qinyun Tan (4):
  mm: memcontrol: drop kmemcg_id and use the memcg ID for list_lru
    indexing
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h |  8 +++++---
 mm/huge_memory.c           |  3 ++-
 mm/list_lru.c              | 14 ++++++++------
 mm/memcontrol.c            |  6 ------
 mm/zswap.c                 |  4 ++--
 5 files changed, 17 insertions(+), 18 deletions(-)

-- 
2.43.7


