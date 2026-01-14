Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63985D29FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5416B0093; Wed, 14 Jan 2026 06:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9596B0095; Wed, 14 Jan 2026 06:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD60C6B0096; Wed, 14 Jan 2026 06:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE3BA6B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:28:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F0B613B086
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:10 +0000 (UTC)
X-FDA: 84330345540.17.3BD094C
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id B03B0180004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AdVzvqBm;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390088; a=rsa-sha256;
	cv=none;
	b=b6yWFEpuFeixXUKLaSKGxk09wpPkSHWBjTOYOipmoioF6o0nIn0KBXQ6OtlcPBvlDd9NMX
	UytLrKOLTE5QAVEwQ/J7gmmJhPvUDVlnQAMwBk6fdW1uxkt4UE4L7RDLS89V35xJMlnE3r
	gg0WgyoBrrJVOZJUiGJCSzHQhweluZ0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AdVzvqBm;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qomE5HnihpcoHBR2vFUHdVECzXWs6li/sJdmccqo5Bc=;
	b=CJIzXO8ylVBYHkZ7+MhA6EcMG1lWm3fh7B2/2eD9AxVg2QcWeZahdP6ecdcWYz/49SB/j8
	zbGd8Akk0k/jN0VPpbriFryL6C2RYAKqRfiDmw5potI6j4EqA0EZ1+4Eo5fuduS4BltKcY
	Pgt0ETqrF+1DCuVt+OB+aYh/TAk7IgI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qomE5HnihpcoHBR2vFUHdVECzXWs6li/sJdmccqo5Bc=;
	b=AdVzvqBmYS1dL36VtYJHqvTy71Jc8fzRL8QUahKoKOYiZ5QwB+I/tujZElmvvEDzP4p4Ec
	20O6pXYm+Q9sDcASfLFnLKmosjocC1UFlDSNKk8KAmRj3BSlS5kIx4LR8JEPN+bxDIBDFL
	FZnP/P9i4pLe5YhVfj/OvVaMc8MVcvY=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v3 04/30] mm: vmscan: prepare for the refactoring the move_folios_to_lru()
Date: Wed, 14 Jan 2026 19:26:47 +0800
Message-ID: <65187d0371e692e52f14ed7b80cf95e8f15d7a7d.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B03B0180004
X-Stat-Signature: pj1oge4zf8oki3pn68dqts8o1afu1uzk
X-Rspam-User: 
X-HE-Tag: 1768390088-295336
X-HE-Meta: U2FsdGVkX1+rY6MpmwS/mCOUaDLYhyObsneNX1Bj6GBapl7PfWawEZa7W2xYL2G0et+J3mAIBqW5BwzjgGJq0UCBRy0ExuzEPvOK7VAzQ389IObON4rFmqffa8MbOqKTzlpvXDqCEic5QVJfNyyGlOWRk2EzNDmlXYzNgwkR4yentFWJjx/ghqPQcKuvwAbrkmcY7yLP/GfYXlXmV3hocIPHK8Oetrt+R2u2qFINCkt9zB+ZwnQeJWBwcByCIyK3SPaDyR6s9EviHbNRNA312c4MbbZJ2r7QD6BgTqBrNH1nBC3vCIhpf+vKv1s8WuTXHJ8h4BEE9X2U1OsU0xohHaSEgLWehJiWFeVCOmXIlCBVYS4Ah6Mvx7q4XweKZTZpvYwhw4pM/rxzRCVBAQq0btvBO0sLCk/KF+3j+g+LxWFzGmmsmUxvwJT12ynluFJCFiTdEDYcUH0KXkFGieEgwwfg8Y61jTgAIStee+0EFGiIOuVN5BUOoY03K62qdF78bnDt9i+7XwXflEKjzqItZVf/kWveYZB9/YnoXOHFV1N5DzNYsU2cBved9rmCmlmxlQVSB089mMdyDDZA0NjyYy4NsJkNg/nZVtm3APRyoQb4EGy7ppKpOoeJYdH93+aWhVAItZG0ZwVuAqpm83T1sXr1/sJNB+ghXdgezHMmffxovTP5Ycrn/i/3bxbLmuQRakkBNsrzoqTr6zI9HJzSVzMdeHLslSlcXAX7d/zEgisodUe1EtFUuuOUxkLignGKd7akNRypPpTCm6a9/+wt9QyG/fVZ9omzAFNDpE9CR9BSC10mZ9howVaxytRZO1jO3DEFmRU5Mw5HDq+QD4uXMilaOZKYlW4zVgfwntT4douQVtPy+rf2OTLZ1aR3iAMhXanIiT4UUPxNXlrc+8lc25BtALlWSCTnozbOQB6Wldu5CaRGOLsru73vT0UzFA+gXj5Uf+nZL2MmjMHEplJ
 WsFFsiW9
 lG3C7e8W2GGwlMUbK+rPqN913a4ohw/sYoMtTP5qXIS+U9/d45aQFaqKvQNfivlyJuf1DUArPEFSxmGnrcyXA2JJMpPGs01gj2TZOW8k6EGMxYm2CZetenzrCB9KF7HSuT/RehdN6eLcmk6h/5pPYs6jMa2vruNTMhXR3noBm3XoZ1zbtkSwsLnVeZixMKILoC3XNOlvO3MioE9XFuJCVW0QeOcCKYcltjsSPFt7B/Q95w5Z+u/ujAe3zLxI4z0NZGuuCg2uebhLBc189bZSlSZ/nXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Once we refactor move_folios_to_lru(), its callers will no longer have to
hold the lruvec lock; For shrink_inactive_list(), shrink_active_list() and
evict_folios(), IRQ disabling is only needed for __count_vm_events() and
__mod_node_page_state().

To avoid using local_irq_disable() on the PREEMPT_RT kernel, let's make
all callers of move_folios_to_lru() use IRQ-safed count_vm_events() and
mod_node_page_state().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1ede4f23b9a6f..5c59c275c4463 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2045,12 +2045,12 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_reclaimed);
+		count_vm_events(item, nr_reclaimed);
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
+	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
@@ -2195,10 +2195,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
 
-	__count_vm_events(PGDEACTIVATE, nr_deactivate);
+	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
@@ -4788,9 +4788,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, reclaimed);
+		count_vm_events(item, reclaimed);
 	count_memcg_events(memcg, item, reclaimed);
-	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
+	count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
-- 
2.20.1


