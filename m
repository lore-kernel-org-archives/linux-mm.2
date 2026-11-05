Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4904C606A337
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IqaeHVKx
Received: by kanga.kvack.org (Postfix)
	id 395686B05B1; Thu,  5 Nov 2026 04:22:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346636B05B2; Thu,  5 Nov 2026 04:22:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236276B05B3; Thu,  5 Nov 2026 04:22:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9A956B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:22:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D79C1C4338
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:46 +0000 (UTC)
X-FDA: 85400525532.20.51063FA
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf11.hostedemail.com (Postfix) with ESMTP id A31B940009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IqaeHVKx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UWmb9HUpIQPQz6k2PGeMG/U7KreRlMRXLm0OBejdgFU=;
	b=Yew6l2JodmP8+9RQtxNbZgwe2T6ZooXXbpdoIUp/51/wJuUg8vEuGpeXprnDka6WoO9VbV
	L3pCCG7v07mowWFWUm+4H+hm56gefDzdMsSq+Q2E5Sm/oHeb91FNO641/bVwDXjvxfWJJR
	DB1ZLpE1tx4V4DhwuuhauTNCCDfUpWI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IqaeHVKx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870564;
	b=IQmWXkIkqQeLdX8EQ0px0ETAlXs0wlgto6nGEYt2vF53sU4sdtpYEnH9mWlgU2H1lhChgC
	f8gpSJ1OHhxcyL88bxt4GL/WEu731zKECmfTZbxFeNm940huZnoWlXOez/aJkR+w7HIh9W
	uKkV650k0z0JThW5PPOwaTB97RcQLqs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870558; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=UWmb9HUpIQPQz6k2PGeMG/U7KreRlMRXLm0OBejdgFU=;
	b=IqaeHVKxHvpLL99rItKp1iCRQkXSIVs1/nXDz8iQOMUiZbYT3IgGv7lY7IoaX7qXLdKKbriHTO60SK/Sffy0qruVNbPiAe/keIidCiRJUJEzk7ufb3qLY7IgA9jYIW/QiADAQtUk2kmFktTYfdRjhDydCqZDvRrPW3uss0b+I40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-.B_1793870554;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-.B_1793870554 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:36 +0800
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
Subject: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Thu,  5 Nov 2026 17:22:28 +0800
Message-ID: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A31B940009
X-Stat-Signature: pg1bn4x7ks3fp3zj69rtgds6qjnedznj
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793870561-799019
X-HE-Meta: U2FsdGVkX1/bJKsYbDwTnMSSy5LEmjkFWfwynVXOBxbc2mnKOmAvNpVNZ5GCsHrq9yaMs0Hbbcd2l6uWivsbCFYWpBVae+nFPuhcr7cItiXh5vAW/RKOC0NsLbeHPlkVUagUs8IlEmPkw2GnMY9bhpeQc4YIFBwbH1+q7y9QhAmlbg+dnEFO2pW+oVxdeEL6cRyH9aNYXfW7V5TnrdoBWvc6TjawcBPW0DSQyotyyosDSOLnSPdj1qbPPLf16zV+u2SykkGVQnxSJltexlPljRzkg57PCtTtVGXlKzyODi+mFkXR6msOkornPmC37Vb+NBcIPyzhb06xTUtiWwUHyzG4k2q1zjSwaUwxasQG7LmU1tuadco8WcnKsIL50w+jzChehG3qAyj0BbkEazYjZm8v5eYkojjDxM4/donvnFRSzM8l4UEq3lwGb/KaUqR2rqHBUbTNRqMgWI6MR5+6JqJn3NgVgTjPW4sYi2/RPONG9cX8HRKj9/9nPoTqEK+rH053t5OQgmpULpkmjeurTyciqWK3izr6RpEOry4HbBJjORgsIVSdKFtQCNvFHt0F3qeAOWkS20OjdD/9FGQyJXCFARUvqT0WYFJwBj9ODEIIJuiNY3927eTG9zJMN0etgV13XaOFTZ6gKZLotOawX2czUJPU1KcOsrdjPUZklmk4lsd9TDbYDenl49QoIZqpvKL7pwDAZcFmWD0fbkeA2WXbxiSPbhr7aV1rHaC0KpW4QOXzOtx1ixZsiEoL7d4q1EYf4FWDZCHCbmIvPoJ/T509ja0zLiFPMrjP0QljTImoDxP/qfbk/9X8EMAxmRAGDaGgeylRvwGnd8ZEjpnHwM1EezLKWZ7OVIavfnPCmW/gkJMvPB5nCduGJ04VG2cSVM/rfqXfB81Gmy/lvZFUQIX6YZqEzcjSEyJcFsGcsG6ilJAEkDHb60NjY8ZJjBW64stqEhZQwynydOkwoig
 YW0L1Rcs
 8dNR8wSzpmWEyvXD3HppAcfNMzG84WZXa7oD9VElsBNUmKJCWVcGHnkRnrh8Qww+aXD2wd3eVPQZCfHxo9whl4o+W4mVeHzVF9Htzjdvixzm/a+KN/KlOODe0u7onaWcq7lFiwPyjpAJc9WeuNQ2+0jnCZXsFFVZsdhHk/l9168UkcdbEGBiS96L8hF1SDZt0SHHYnxgEMDPDbmlr5ssr+Q8ZTBHrGdanVXdV+VT6/qpcw1uAVF7noHSEDzsfGaO3LA5XZdbBaC0AbkwCCbT8TC3oFn0aNLGApHReN4oADHtHSvp/mNMCDDlnZoLEsxzueis1MoGtUOTSNdwlTqMGzfM6TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Resend: the original v4 went unanswered while reviewers were busy
with merge-window fixes, and Andrew suggested sending it again now
that the window has closed.  No changes of any kind since v4.

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
 - Describe in the THP patch's changelog why the list_lru conversion
   dropped SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
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

