Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF26EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2236B008A; Wed, 25 Feb 2026 02:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F376B00BB; Wed, 25 Feb 2026 02:55:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88DC6B00BD; Wed, 25 Feb 2026 02:55:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5A9D6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:55:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 741A38BC0E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:55:12 +0000 (UTC)
X-FDA: 84482218464.22.A0B280C
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id B9CE518000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:55:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCSZNJHf;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+e+MrbxStkCyw/Uqa2jpcsS2d2D2I5PIhTEX7t4Mug=;
	b=HnmFwHvsMTnTTmTxaDaXSNXj2pGFLQguy6RatY5l3dgNHLTdnvkmXqZfFpeTlChtMkNugr
	rh1uT5AhQBdwdf8deP6OEi7cp+z/Df0ee17Z2FimpVjMmgeAs1ptc08sEZeW9XOay9gLd5
	fjN4iB6ZDVp25W0lkbnEbQmT40RDfJY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCSZNJHf;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006110; a=rsa-sha256;
	cv=none;
	b=kcTUzel7UVGr8VqLIcpF0/Cs5n5FDxs6SbL/yTa0pejxhzGU/MTPeRF/x8MZAvjEoomyNj
	QRMdJQc5az1ocGr7W0Igcio8LlB5FJHhE5s+tieLPWyO6AI+EPleU66XeZ+VlX3hkJ6W5V
	d5v4bRxElMw39jMS+3ef59uwiZ4ZnoM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+e+MrbxStkCyw/Uqa2jpcsS2d2D2I5PIhTEX7t4Mug=;
	b=mCSZNJHfd90ZlK4cL+EpjAjgG1SmuZQe0G4TFl8RoR7n2xLpoLbc6jStwi1xux9axli6/6
	EQODJy4LkMiQAImbBjOMfcXIqUhYX5TsUF6lfISMhfG7fGhrsibZOPahSWZL8MZcvLqoWC
	OAqKtL7dmPmtfU2i3Fjaj2AwhHi975w=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 22/32] mm: workingset: prevent lruvec release in workingset_activation()
Date: Wed, 25 Feb 2026 15:53:05 +0800
Message-ID: <c6130476affbba0a7d309a887c3df11e0167990b.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B9CE518000A
X-Stat-Signature: sejcatiety79arskpwxu6us3bdcrz56x
X-HE-Tag: 1772006110-537487
X-HE-Meta: U2FsdGVkX182H6bCrU1/5aJGyYPtyOqQb/jHchOJRG+pibxRliEuScy1GLRRiVi6gUTcvia5OQOra/7lmKHN90nTlOtytu/tpZbEabiNZcdbflvkncELr/ejG1AhcL1BPDM8bLH7K4Tt4KqFSR3P1AitI6wYuBzP2yWvyJReD5mby+OZAJj8xOiuWpVx9ANsxH2y4dnG+MoWMy/Figyqf75tiVwhdXB5T8YLvtgSyN5PF0C5Gt1Pyhkk63zUs98Mm/KI2sM+0IA8JUVdK2eA247rzjEZna8hMZPV4aaCTdHkE+3jnS9HE+vHu/A7Kobvq1Ok6LgT97TWUuzYVDJvMuw2peZcJGLmDrQmyqcZ1Gxa6u8vXo0T+Jqm2jp226W6pVcVTyySiJ3RjeVGdaBpz6FzED63q/jqJks8OvIfAqrhDow/etv+D4ahStAzwY51nNGxAjqVOjTna7SHKxUvykAbD9pRNyZHpljE1M/tZrXo0UKCvOmpRcjH5NbBCpncgnoSW84QEUISc6ewGRULzoeInw1Gi16YblEg+fjU2k8tMW7IrrPw6Ks0mGKQlwLvcEnLIO/CjwzAB5u8kq+9OxWkqfT865UXKSar63UzN4bcx0CuAwcMa2VnmfnowakXkHWNG7taqSlOTDMKvrq//RS+eFMGmrti1wIvYswkahf9ZYr/tJacqdSIgFdibDF4tAV+y67loDv4a1TS4iAUCXVHBrWVcWrhHZQ5o+BLAyUkYql0IwBZrGelwhFhidV6mw9ZGOpkY4xg4ATyhsd1JgtZUZiOmIXvK2HP486W1rIrf2OxbJ/Y3Zx5f6iIiBxZCAUIbdARI/Fc9/MpZsm2XHY3XFWsND0PPtzXEU2JdX3IEmutv6ARPWONL4SGl701Vi8GbuBmgVTNIvGWwoAWc8gV2AKgyZxupeknOC6AJabN5M5/hEE0kyyBPeBOZO2nPW8gIKZloz3bvPSxNCX
 3srso7al
 /IaABswiy3OuEvmAk1pfe7wHPz8B17uFGaXLEuYRYvlRhIyCxmW3ERaiuyek4K5konvs9kiYvFPuZa65zOFSu9A+e6LV3Aw+LA6nuKItr62XqjzLjjBShxe+X4rT6l6FJZIL1Cl55dxG8vZRKnQDspawM8n5vPwjFCC1UhtmOk5R2qAqpQy7hG4UzL8l8wb4Tw18w0eluxM9h0w8eJpYPt7P9esJJkbkLFrhEBp4xun2fbSDKhmvnZXWln9Bl3Hv8nbEq0LXgzsS1MS5SwIQGmjXK3UgGeQin6SVKHkTUUHxxT/0Z0KkfDUDAYYacfcljvPr7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_activation().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 2de2a355f0f86..95d722a452e1c 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -603,8 +603,11 @@ void workingset_activation(struct folio *folio)
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
 	 */
-	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio)) {
+		rcu_read_lock();
 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
+		rcu_read_unlock();
+	}
 }
 
 /*
-- 
2.20.1


