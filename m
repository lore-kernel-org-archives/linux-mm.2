Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D926C531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090746B00A3; Thu, 23 Jul 2026 00:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041526B00A4; Thu, 23 Jul 2026 00:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99ED6B00A6; Thu, 23 Jul 2026 00:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B14C46B00A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:57:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36FD94036C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:57:50 +0000 (UTC)
X-FDA: 85018833900.04.5B75322
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 21FBA100008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:57:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PVYGstw7;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784782668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+M31gX24/lXdo/71mKqeb9yMjPYP0lhEdBSZm1x7d2Y=;
	b=IRkVUY0d0FDTq/4b6hrcJ0ipX1NjWZyO5PHwktV6gnrPGv/PdVtAlS9g5n6GG8B0UHoCku
	BczkxDkpd4NmpVNtX1HI3nNzQT6rl1m6o3/7CxqckR7wpTeUXFnjx7eMVSajnD6MmJaja4
	XzXYWLn2bQyoUSKv0MOA/uHWRbUajgc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784782668;
	b=MaOLt6weB1oBjRbUJWKNNmXRH4SliNF148mZNhegqx3iG8vUf1z/oiwKbidt2Vgdh6yix2
	Mj8LEGY53zCNwKheu1KD4A1OFb/p25InN2NSbtBRrZFrzUNUl/S7gStA50jbm5g0N9EBlB
	+lOGIFs6PiFhVUhcKOf5jNvjFqO+WbA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PVYGstw7;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784782666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+M31gX24/lXdo/71mKqeb9yMjPYP0lhEdBSZm1x7d2Y=;
	b=PVYGstw7O1AshQlF7Vggr7tyf7t6fBgn/m1/RtemzMXcw63/0ICwW4qp8tqDCErm59X7+q
	WMgJrDtEtc6OS2rQPuc/BSRn45sRy+z+XeiJwIiDqGsX72W0torSudl1fHn/gkEzoM1upD
	uzVrvWaG2LLwEZoO5GDLy4Wz2EAlZ+Y=
From: Ridong <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 1/4] mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
Date: Thu, 23 Jul 2026 12:57:15 +0800
Message-Id: <20260723045718.2052070-2-ridong.chen@linux.dev>
In-Reply-To: <20260723045718.2052070-1-ridong.chen@linux.dev>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 21FBA100008
X-Stat-Signature: ya5pf8o3whx3jdeikhgzufzt5kj5cuae
X-Rspam-User: 
X-HE-Tag: 1784782667-217028
X-HE-Meta: U2FsdGVkX18/EW9mNxcigvHZB0vzXqE3yGOUS9v8nTFRC/5m6QW7YBtOfoQfnecQKr+p+MHLZvjOTpt7PmMptMFRjpXVmE47Ca1HYjdJG38wdV3S9ElAJPUPEXv36zuzZyIo23xqR1sCRJLKWSLRV6pP1RIsHDAaOBHDnHPMGAD8ppPQKHrfRwz6nv2XLimUULAGoFw4D53SiSATE8e1UW263EE/7d3C/2MoaR/z2THiKpYjzNvhNgXQW72ToSdGzhZxaD970thy6/RqNFK2IRQ3r2Wm+VN2Qna1ALg1UW3BIFSqOL8oZlW9mkykZh3sM7as9zhY7hIazR3iTlOuxtqAvREON/Hienqq4ruW/ZW+tsBNZXGc1Ls+qxK0wU+D9jDyruVEdUBzh0YPFNR9slvFwkQPDw2Nyxa0QUU2dmZ+Y6aDgl023plodoiLgCBNbxz4CyAoXTV/6yHJnudpIOyDKu9wIESNe2GrhhEn36x8f9IKTSSH6wOwcwMG1WBpSrE2pxO72qBYNxDVvC4UjbHZ1HWBUeQ/GDQC20da5NxriYsAbrzhqvDBD75hiTBbxsy9+Wmijgu7rxRnhJPPNdMp5V5Z58Tj49x/WPG1cNGcZ3gueD/F5hnt3YTmg72ZzNo+lDCoS7IySbuGYZmzH+XWtx6G9v9GiezItNPL354Hh6afr1AiayFu/TXXeQRQ6TvvbI1N5aHUySagEvZgCOTpj4qYT+y1ZofYduZzVIShvvNxhnP8roxwud4FvSS3NLay/ENt6EIeUoglniLOoT/OfwxAv1W8N/l5OJsipV6avRljL696JHXJtZSgQ6ob9UnD/CdXrqih130DYpZZm3XNF9qDSr2uQ8D8wHaeEe5+KXxOymzAwcRPHORqznW5+wf7JyiHV/CiYbppV3KzQ/zepnutbsnAg3sybzmWrx6cJUzip2kK1kMSOd4CVWmzAqpoq++p9lWav2hZ8ww
 SUqv0mX8
 S+6yITYU+N98Uhi6nr0rLQ/WeJhRM7Su976lUINdLSAQAcY40lA5gWJV4aA3USLuD8xp8qHOPpMvvCu2RBEwWgyn/Fti6fZ0n6HZn4c+pTOVVNtALapLX5snWWu4n3TqwwvYdAFu57vGM9jxRgI4383LtTS0+xRN6U8+fygG6veFkSzgYJCjHWuSj1F860b+8cxOKja6KpKZM8xRAEMu9fX5bbDrfSmJoW3+vBPv7zhc6S9j7xXbqm7lU5tlU7lpEyLY7f/pi135d4cGzM42lENBNZVbYH6oKBT+i4Zg7HVKynLYx6E6cUBQ0dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
the reclaim logic is expected to reclaim anonymous pages exclusively.
However, due to the current ordering of checks in get_scan_count(),
file pages may still be evicted if can_reclaim_anon_pages() returns
false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.

Reproducer in a cgroup holding 64M of file cache, with no swap configured:

  Before (file cache is wrongly evicted):
    # cat memory.stat
    anon 196608
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    # cat memory.stat
    anon 208896
    file 4096                 <- page cache evicted
    pgsteal_proactive 16400
    pgscan_proactive 16400

  After (file cache is left intact):
    # cat memory.stat
    anon 200704
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    -bash: echo: write error: Resource temporarily unavailable
    # cat memory.stat
    anon 208896
    file 67178496             <- page cache untouched
    pgsteal_proactive 0
    pgscan_proactive 0

Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
anonymous pages are reclaimable, before falling back to file reclaim.

[1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/

Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Suggested-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..2c689682b952 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2501,6 +2501,23 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	enum scan_balance scan_balance;
 	enum lru_list lru;
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), bail out instead of falling back to evicting file pages,
+	 * which would violate the anon-only semantics.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
+			return;
+		}
+		scan_balance = SCAN_ANON;
+		goto out;
+	}
+
 	/* If we have no swap space, do not bother scanning anon folios. */
 	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
@@ -2519,13 +2536,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		goto out;
 	}
 
-	/* Proactive reclaim initiated by userspace for anonymous memory only */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		scan_balance = SCAN_ANON;
-		goto out;
-	}
-
 	/*
 	 * Do not apply any pressure balancing cleverness when the
 	 * system is close to OOM, scan both anon and file equally
-- 
2.34.1


