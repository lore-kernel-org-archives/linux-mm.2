Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDEDC531EB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3776B008A; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA776B0089; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101656B0095; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E25CB6B008C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94E77140924
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:10 +0000 (UTC)
X-FDA: 84462832020.10.6597037
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B233F1C000F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFjDBJol;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544528;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQCCt5FNNq1uYpw/8rWea2kFBzyVnTfQ1cGU9jbW9PU=;
	b=OMShFX5mIDpyOtd3SJSC4V2XpWi27p24MmgHPMOA1QYRlRuLQRQIN7VpVJ+SyvYrJf5F6O
	nqcYVdt0BmnwKkyElVKHx/Zj7GtLRca1M0Op+EFMdiO39iGGzvz9w0PEpim9azgK2Th0pQ
	SyMu+Gi3+Ia/hn3Kq2EFXNeMHSQGTWI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFjDBJol;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544528; a=rsa-sha256;
	cv=none;
	b=jgMaSA5wB4gUNc23vLo7c4tWBS8drBp7Sxk61rSxEjq6oMQVWR+XwOc8l0//Whsr/ExmiI
	OwjkU/d4VqzW+SbZbyrchJdF7uB9RBsj6OMVLGRaUV48i11SNj6Gv9s/LIaoRUaM9KviNp
	qQlv5RtaV1dLuklK1bDO7xmsrW/sac8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D554A6183C;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E549C4CEF7;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=4iTCLXI0G718VK6Ca+BP/6nuHLoyDqG29VXYYyUPsLE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bFjDBJollDR0O+0bka0eoDtbc6D06nyu9hdmjQGBOI6slfe50chmcxflzdT62fvv4
	 nKNTfKzaGo61ba8mDZfbmS/lJLuIkGRm64M8PIX2QvdWYEuHBqNvxqXskSBQTgFLlh
	 KQHvUq5ZT4yu/xvVa8/721Q76mPVkzCopbjG8xrIX+gRNhS7NXpxsCckjA73uTlfoZ
	 G7eCGkbROvGJ7gKkF89eg0e4yuk9OwrDXx7jA6Zm+DRHRgOuQSmzqhxHztvtQ3FQT5
	 GrThfv7MrpJTrbJ4/N8dppdT3KiONe5MMV9ApYiYY9j8oaw51wiIQlqNlChkRofvla
	 juYBVUtREH9Rg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EFBC531EB;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:07 +0800
Subject: [PATCH RFC 06/15] memcg, swap: reparent the swap entry on swapin
 if swapout cgroup is dead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-6-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=5359;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=9vO+dDP6+je7+jClnWWZNq1Qut+lGRZYCcUUD2nWDoQ=;
 b=IJcUr2SA72vqNqyIF134yy4jJ7YYtmhGsNrcSmy0Q9+wfm8Xie+xv3UHp/3cAaYgf2KVDPluh
 fEz1zi/4rLRAHAdpMH0ccI3u2DKM8Z0eLSBfg87HH3CD83K36kEjcv1
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B233F1C000F
X-Stat-Signature: kjdrxcnhppnn4cz3cb585bxjnysw81n1
X-HE-Tag: 1771544528-267623
X-HE-Meta: U2FsdGVkX1+kLEZ0n4h+NITnvuOmWJS8BvnWH3nyorb5HuIFcrQOzKCsj0BhBwNtVR5W4H/e1aOFgV8KyBzzv+UR1zA3GGEkUjyCDylobwL+ZxFSTryEDcOQzc4v0abYhbosxQv1zHXrpxoQpmSr2dd0FcBGDSf/ucGkNm+xLxS2tsIB9pTSuXG1Sbzs3429l59pHd68SQbu8SVKFtpyjMAeJYUX4o1BpnwgMBML09nFhiXU47H8jfD08S/QB4OUVDgvmQbNZ9BU08odCDkQy9kRYHFjcfZYKF0Ogj5e5pk8yxbYmrmouAuFzGAK6hSlPGt3LdlCILdAHohylFtg9mF4tjoA2UiW3V1ZpZt762ibrcPwL69UZIy1MUq6Bs/ALMA9L9ndTECQXk5rxzhlxuqMxgKvoZTdOPKBo+ebLyIrdeb4PO529IKJbbREl/1wbs9qUCaRczliWA/1ey1tbWKeEGCpgFgm47KDlI4DDZXIZcczlOZ2gfqYPuEmh9CObWepuaWzbk+WgUljr/zl1ijX8WImG4ZtbMdhjacTjosrdVoU8AcefNEG+r1De0QusfRb4mZJzdcihhYMwc9oBLZ/8kTYLAzTyEGuqV2s0kFdcozchODTLCypeQdKoE+kx3easvtKk3q0NlWYAV/Kj/apmEsmvl4bAbVG26l9YiZDFoBQUr7Db+5s4yB8m0hsBNZf7cfwBpm3T0W0x8jA+JXiXz27Gxy94lmZuUFnluIX8f5DiygJ3rsqK+ISz0DmYkweBvT8c+io/1ORuAEpnyd3FxV3SpHv7TAE+GapatVDPrKyNOV7VTotcxXu6JjPbeb+GQnffdKQ15a/FBiubBu2UbBFsUGnV7Hda6VHOERSyXGJahTZB6JSpS3rn61Ati6LkcYxiN7nMM+NFPx3cQlUJKuo5uKXX6/bUHHlwoH3h3vg58DHwQ/UzvZ/NncedW00VKBebYk+PcW/a0H
 k4VdBmQ5
 24t8hzuueL6BAPcibtgMSA4tv7sb3irBf/W9vJd+uNfv5rj1n8w9xft6GvZoUlp55j5ZZe3UvLn69AlBFmwuozLbTqO0CETTA57q39USjj+BgfpVB82V/SInz8rzsd/5JAgs/jOuWRKgk7kzDJGUitUbnXUiJsak3kmHN6SE4zRkjzwourkcAq/1iGItHEpmWUk8QUqjLqdCnNbveY33+KjIXuzBW4POFo8MaSla/LHtcD0qps1l7Zj0X+g+IqYa4D8lyBkKjMxp2DEGP0v473mOQiyADw/JppgSJ1sZgi1SEqyyEHRTTURUPETEnQ7ee2pWLp7t66DH6etTmQePWMaF0AuyBeDadn2fSYJyawCy8BnVt85ydUFyoAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

As a result this will always charge the swapin folio into the dead
cgroup's parent cgroup, and ensure folio->swap belongs to folio_memcg.
This only affects some uncommon behavior if we move the process between
memcg.

When a process that previously swapped some memory is moved to another
cgroup, and the cgroup where the swap occurred is dead, folios for
swap in of old swap entries will be charged into the new cgroup.
Combined with the lazy freeing of swap cache, this leads to a strange
situation where the folio->swap entry belongs to a cgroup that is not
folio->memcg.

Swapin from dead zombie memcg might be rare in practise, cgroups are
offlined only after the workload in it is gone, which requires zapping
the page table first, and releases all swap entries. Shmem is
a bit different, but shmem always has swap count == 1, and force
releases the swap cache. So, for shmem charging into the new memcg and
release entry does look more sensible.

However, to make things easier to understand for an RFC, let's just
always charge to the parent cgroup if the leaf cgroup is dead. This may
not be the best design, but it makes the following work much easier to
demonstrate.

For a better solution, we can later:

- Dynamically allocate a swap cluster trampoline cgroup table
  (ci->memcg_table) and use that for zombie swapin only. Which is
  actually OK and may not cause a mess in the code level, since the
  incoming swap table compaction will require table expansion on swap-in
  as well.

- Just tolerate a 2-byte per slot overhead all the time, which is also
  acceptable.

- Limit the charge to parent behavior to only one situation: when the
  swap count > 2 and the process is migrated to another cgroup after
  swapout, these entries. This is even more rare to see in practice, I
  think.

For reference, the memory ownership model of cgroup v2:

"""
A memory area is charged to the cgroup which instantiated it and stays
charged to the cgroup until the area is released.  Migrating a process
to a different cgroup doesn't move the memory usages that it
instantiated while in the previous cgroup to the new cgroup.

A memory area may be used by processes belonging to different cgroups.
To which cgroup the area will be charged is in-deterministic; however,
over time, the memory area is likely to end up in a cgroup which has
enough memory allowance to avoid high reclaim pressure.

If a cgroup sweeps a considerable amount of memory which is expected
to be accessed repeatedly by other cgroups, it may make sense to use
POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
belonging to the affected files to ensure correct memory ownership.
"""

So I think all of the solutions mentioned above, including this commit,
are not wrong.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memcontrol.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 73f622f7a72b..b2898719e935 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4803,22 +4803,67 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry)
 {
-	struct mem_cgroup *memcg;
-	unsigned short id;
+	struct mem_cgroup *memcg, *swap_memcg;
+	unsigned short id, parent_id;
+	unsigned int nr_pages;
 	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
 
 	id = lookup_swap_cgroup_id(entry);
+	nr_pages = folio_nr_pages(folio);
+
 	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
-	if (!memcg || !css_tryget_online(&memcg->css))
+	swap_memcg = mem_cgroup_from_private_id(id);
+	if (!swap_memcg) {
+		WARN_ON_ONCE(id);
 		memcg = get_mem_cgroup_from_mm(mm);
+	} else {
+		memcg = swap_memcg;
+		/* Find the nearest online ancestor if dead, for reparent */
+		while (!css_tryget_online(&memcg->css))
+			memcg = parent_mem_cgroup(memcg);
+	}
 	rcu_read_unlock();
 
 	ret = charge_memcg(folio, memcg, gfp);
+	if (ret)
+		goto out;
+
+	/*
+	 * If the swap entry's memcg is dead, reparent the swap charge
+	 * from swap_memcg to memcg.
+	 *
+	 * If memcg is also being offlined, the charge will be moved to
+	 * its parent again.
+	 */
+	if (swap_memcg && memcg != swap_memcg) {
+		struct mem_cgroup *parent_memcg;
 
+		parent_memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+		parent_id = mem_cgroup_private_id(parent_memcg);
+
+		WARN_ON(id != swap_cgroup_clear(entry, nr_pages));
+		swap_cgroup_record(folio, parent_id, entry);
+
+		if (do_memsw_account()) {
+			if (!mem_cgroup_is_root(parent_memcg))
+				page_counter_charge(&parent_memcg->memsw, nr_pages);
+			page_counter_uncharge(&swap_memcg->memsw, nr_pages);
+		} else {
+			if (!mem_cgroup_is_root(parent_memcg))
+				page_counter_charge(&parent_memcg->swap, nr_pages);
+			page_counter_uncharge(&swap_memcg->swap, nr_pages);
+		}
+
+		mod_memcg_state(parent_memcg, MEMCG_SWAP, nr_pages);
+		mod_memcg_state(swap_memcg, MEMCG_SWAP, -nr_pages);
+
+		/* Release the dead cgroup after reparent */
+		mem_cgroup_private_id_put(swap_memcg, nr_pages);
+	}
+out:
 	css_put(&memcg->css);
 	return ret;
 }

-- 
2.53.0



