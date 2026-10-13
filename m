Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E72CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550DF6B0088; Mon, 12 Oct 2026 23:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528A86B0092; Mon, 12 Oct 2026 23:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0A36B0088; Mon, 12 Oct 2026 23:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 039BC6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:12:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7864E140AA6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:33 +0000 (UTC)
X-FDA: 85316130186.11.EB3F9A0
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id CAB881C0008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HMQniEMj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791861151;
	b=5KC/GJYyF9mvNQFK+VtkgSoqOLQxfxfe33EvSrM0WAx7qFlOeGKINaoddzeq9Ewy5+spUD
	X1F/eXdCpAC2PvvVbvAjK4U2TBkBC2AsDUUj6D0mPsyZokU1mAz3CdSrsK+cU0m5Q/KwZu
	z/e+y8Vyjfybxe10uc5/4sqTWKjZ7TA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HMQniEMj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hlzmYIV8LpHzzL0P6N9e/k7OXLBUw21KQOWVEEg7vNo=;
	b=PM2jg1cD1959Z+j7Vafda3ZqzG7udFunZo5hP5n5Xj0wvjPj+xYZcNxNhrAvuiII3OBQVT
	gDTX+wC/bMxKyhHpUrH9KBeDXIy7Zrf9TufgWRrJHWGn3o/7PnXNgPgvBWR8E/fZzd+7Im
	9KpzUi5nfOOqhl4ULYh6MYy1EcC2Puw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791861147; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=hlzmYIV8LpHzzL0P6N9e/k7OXLBUw21KQOWVEEg7vNo=;
	b=HMQniEMjbwiejzQNKQsaXXRttkosqeoXUJkSTR2l75eA510HIWNd78f6lIu3Kd0gVv6SeBX+6rvThQsj5y+Y32WPDHV271MeK4BGf7pqk+sYVmq3D/S6quyNxSo5FuYnVrzWot3H/VrdtR0iyJyW1tcw6dwXpMCbsK/dEhv8Q5s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XCkEjbj_1791861142;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCkEjbj_1791861142 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 11:12:23 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 0/5] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Tue, 13 Oct 2026 11:12:16 +0800
Message-ID: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nin915w5mnfyg8nssspkg1onq4ptiz6x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CAB881C0008
X-HE-Tag: 1791861150-709900
X-HE-Meta: U2FsdGVkX19ir6tt5qlUMWTCUdSuR9FHCGpstasdoY0DfNmVb0DrxmLcWvXBa4Ns2gSIWKMpEca21PtsIhFXH7VoVWAv9/rhUon4s/bcbHhU2Ou5+hpFh9hmrHSuz99HZTnGAbtabyO+fi4uTOD23LBb4DalYKJ9DDkv3H7w9BUXNm1YZNz23+nMV+QkMlbWz8vB1X0dXB8WgDLFnEpGqBdfivZu+/bLzN+ZSFQ5yfNCvvyKG0+hOEPJK0qjMj19kmPVf7iQ6Q4i5YHpLmTMg36LYdZ2yr2a1W6/oVF1/JHzfF/YNk7v9etnq2zpX6aRiP1nsv06ym8P+PigIDuuyxTc3bfS8/aUhW4Tzuu8mqI7QYXRyzkAl0Ly3TZyxyVAWeuYHS83IS8hqHTOQCNrFTuoiKdtFTis0c45eV+u+bnmpWmbpSWcC2WMWV8NLTGqal4jozxP4TbaaDM/xV0e0Yq7Vv0Y5V9FgxO5XvXpc0hJtSjThr1dwcmIuuSpbcWdw9+83oXBI3K45/OPqim1D0BpnGyKer5TmZXMSrC1zAk10LQALMKfE9ylVpSQqHAdFWV43UCCtBJwSkFVYtpGO/cyPgo7ulWJ8I/ULA0qtHBcoI7J3p18oUokMNqxV5P6qbwpySsLdtfvjvv085un7xke1o2/z8HTR1+FMBRXUjtCQa7ncahYP2hCu/wrEs9G8Ijp4bf8lgJ0hgigKqU4aSwHCwRrpKY4SUEDpA+547LGVyWlQefG568Rx20M54NpMITG1BFlz9SVn/LJ5q0XA3oi8SOLmsyqX4qLfWRz0WLMaCa7eMq6un0iUXWC1uaLNe9b2ylH22/KYmHWKabVOWwPiRG/bcINaxqY1rBjvRE2r9GiferIz6sHx+Gp4D5xmwpztRg/Sp4cpNN8/PyJMnT8Ju+ff/d0wS1xzNkJjh75Dbg/qaK3YWtTILrqlmeVJgncrSdDpBeHVy7Yqld
 QeOo9tXL
 +nHXI+u4Z1sN4bBC3aFmzpYw2dmk9kSbl6sgO0iTN76nCmfQyDZegzROtTKQHM316k2M5EyTwwIxbuQTZfbw7YnD3AX8tWRNSYzpc8ItAlznhEnm30rQKxpgd33GKJI12EDdqBRb6l9hvzGtO5WYoBSxPc4xiD8PWuBe/N/U1udaDb+iIG8RcbEbqx8ENUpJxo97FAe7U3NrokQPPpx9VNj3JBpXqkciOH1+Hzi2JdJRyxMr93qPyuAF20ReD1MgpZjcbC2DEh5HrgDcA4DcscIpaiJIjxrn3NxPZ+X1itMdrcvRukKF8dBvi7YuN8Hfplgg+xl7YZPxu0loTR6E7fHhuxg==
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

Patch 1 passes the xarray index directly to the list_lru walker and
drops the reverse memcg lookup that v3 still performed between the
xarray iteration and the walk.  That lookup was the cause of the
boot hang reported against v3 [3]: after the keys were switched to
cgroup IDs, the walker kept resolving them as private memcg IDs, so
the global drain kept skipping non-empty per-memcg sublists and
shrink_dcache_sb() could loop forever.  Passing the index directly
also removes the temporary css reference from the walk.

Patch 2 drops the kmemcg_id copy, which is only assigned when kmem
accounting is enabled, and indexes the list_lru xarray with
mem_cgroup_id() instead, so the index works independently of kmem
accounting.  The list_lru plumbing passes memcg pointers now, and
memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
online/offline hooks.  It also drops the nokmem early return from
the offline path so these lrus are reparented on offline.

Patch 3 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patches 4 and 5 restore/add SHRINKER_NONSLAB on the THP deferred
split shrinker and the zswap shrinker.

The savings of nokmem are preserved: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to per-node lists, and
the per-memcg lists are only allocated when a memcg actually holds
such objects.

Changes in v4:
 - Fix the boot hang reported by Kairui against v3 [3]: the walker
   no longer reverse-resolves the xarray keys; the index is passed
   directly through the internal walk path (new patch 1, split out
   as a preparation so patch 2 remains a pure key switch).
 - Drop the kmemcg_id member from memcg_struct_check() along with
   the field removal, as pointed out by Gregory Price [4].
 - Otherwise unchanged from v3.

Changes in v3:
 - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
   instead of the private memcg ID, whose lifetime only covers
   online groups, and pass memcg pointers through the list_lru
   plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
   the css online/offline hooks (patch 1 as numbered in v3, per
   Johannes's review of v2 [5]).
 - Describe in the THP patch's changelog why fafaeceb89a5 dropped
   SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
   original discussion [5].
 - Collected review tags: Johannes's Reviewed-by on patches 2-4,
   Nhat's and Yosry's Acked-by on patch 4 (numbering as in v3).

Changes in v2:
 - Keep the list_lrus behind the two shrinkers per-memcg under
   nokmem, so the shrinker bits are set for the right memcgs and
   scans stay scoped to the target cgroup's objects (patches 1-2
   as numbered in v2, new; addresses Sashiko's review of v1 [2]).
 - Patches 3-4 unchanged from v1; collected the review tags.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
[3] https://lore.kernel.org/lkml/20260910080722.3961351-1-qinyuntan@linux.alibaba.com/
[4] https://lore.kernel.org/lkml/arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F/
[5] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/

Qinyun Tan (5):
  mm: list_lru: pass the memcg index directly to the walker
  mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru
    indexing
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h |  16 ------
 mm/huge_memory.c           |   3 +-
 mm/list_lru.c             | 114 +++++++++++++++++++++----------------
 mm/memcontrol.c            |  45 +++------------
 mm/zswap.c                 |   4 +-
 5 files changed, 77 insertions(+), 105 deletions(-)

-- 
2.43.7

