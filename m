Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18AE9C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91116B009D; Sat, 18 Jul 2026 05:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40E46B009F; Sat, 18 Jul 2026 05:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80D26B00A0; Sat, 18 Jul 2026 05:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A97E96B009D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:54:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C51A14033F
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:15 +0000 (UTC)
X-FDA: 85001436870.05.CB4529C
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 89A5F80002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IPZJ2vmv;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Q+i8KecsNiTPDlAIDtRLOAH9MLCuFDqX7eHJi+IsDY=;
	b=qqSR820d1AKLnlEiapIOsTCBVUR2O2vEGnPbtu8HRoRcKRVTQCi3+CXKyGQ+5c9ELV4QS4
	0pAlgfDJE9kOLuYX5PkoBn/iOolaTkcjtsGRdU7QEutJ3uCH3Qk2LDxFs8KxYEzzCn9oFy
	eejwXKhYe9OpvfgwGQPEdIC9/clB4Ns=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IPZJ2vmv;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368453;
	b=KFZnHHB6VbG2Gpq/ASYWX0zvvIM70Z3hIu7ibeM4qM45BN4Kq6MZGzo4t1uA3UO5+FNrPD
	XZI/018/+Hl7Z1cXxUWR4GWIgtRoGP10TzE6u03KHEKCEmE8WC65qvTHGo2xyQklxZntyJ
	sDGfQqNWW97tUin7tsw+WzKM50vDV8Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784368450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Q+i8KecsNiTPDlAIDtRLOAH9MLCuFDqX7eHJi+IsDY=;
	b=IPZJ2vmvhKbB2s6jo0mwrZ5E3jVAfCVyiNyvZzuKXamWBoC2sL/Dj9CDm4Sxw640dP4ApZ
	imoYOnvUxNFjfm3w884NaHFRKH64hmv0sLPWe/uDiPo5CO9UmEjMtAQ+wt5Kr7siFL5IUz
	tFno2FMVgo8d4AbnwDd/uuNUw8x21go=
From: Ridong Chen <ridong.chen@linux.dev>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hezhongkun.hzk@bytedance.com,
	muchun.song@linux.dev,
	dave@stgolabs.net,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 1/4] mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
Date: Sat, 18 Jul 2026 17:52:48 +0800
Message-ID: <20260718095251.82937-2-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-1-ridong.chen@linux.dev>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9fbacrpqxr7z5hnsnaeaedae1dfzp1tb
X-Rspamd-Queue-Id: 89A5F80002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784368451-460748
X-HE-Meta: U2FsdGVkX18WX+ycwbZtQ/BoGDlUDw0D07NbxJQvoOZPZrLyEIRh6fLwXhL6yvPMka9/ehad2nZKLXWuJSBar/q5ncwXaaHHsESFyGDBMn2qnfGfPhlBixPWA6GIYQqVFYpQ2CT2H42z7+FWfD17cJDEICGHQ+ucPvng3t8NWUOfk76UcGwqbxVLwbvYEElcN71CBV5lnJ8C+9HAt8CUb7T6wUz3LhCYYUhc09Cy8Y2gTxi/97PHDsiosyRpO5/gHXwNUpINp1SPVsm86TIlkvBrRt6jGvbdPvSLC57oAJVBBGrvN2HHzAPFWYJG5bD0UgImmyHIPfYs2wD7RGkEQDAETBkw9l/e4kLW17scstTtJ7TCvWBfpSc480NsOn8/DOheMtbcspF7xLFIWIebGjOTeDsEVwwb8jJOiRTPtPle+XYgjSOV1C6vbNNjAWtXNRCx3T/d8jk1w/L20QQAsWUeN/TQF+ffRCar43kXJie1TNPKjk4vBxmXgDLZ8SXZqgF075jtZjR4YV/9+zLyt4rLIt6cZK28X5xKg9cydpsI6ymE4/GSZE8nsEbCymSEPA6OcVlJrVfWUDxafksmSJVVCw/Es05Io4guHUvVkUzkPLua/Hg/w2h4Pg1kVhN1XEODgYS39fEGs1osPOKie7frnD001uOUEo8G59rpXljbkGN0HvMoA6SiSHYS07PVJyZUCjxGzkRSkhjAp9djYOQwpbnGMYkc+/e7wat8S8U9SfmdNSze2HhmpD4CB/HfZUo049lYsXxV9LUMXxw2bj/OVWuaBSfJOx6M5bW4ftvtyK5XLKVN1rKA0bFsZRgbN45vxfrx8+KRCAfQA1lOGmDA8iwQhs0hfuBHxDsnPEkaYDvKBfmSBTqDmxZYfbAJRB0mvzord1geV2Sy1bWnhOjsQ2qkF3zEhu6i7p3M8e/ry6H3+hYwAleg7ez9Rb9C1pm8uIDLdL+Se9Tspx1
 EyuoBLSX
 zbueGdUCdD51o/fWw9sX1uGMoceNTfSkHBRU0hAYB8A4K93+BsOSlJ6uH568yHrmD1wGLRMJjMNRhjvNzLhoeKAfgEcsMYugzvnldVQ/v1vmxWzHe2Ty8+ND3gs+3DqblnMfOuCwUACQTsYTCBd7VZi/3w7Ahq2fyuW6J9mlV5+FT3Te2cYVevQVtmFdTvXQh9iiZhThNoj2kExcD6C+9n7l1B6iU6OlomL2HOvOYECbqAQy8KcaM9nBpkK/PS0DTvOrQ4YYrZQPOHL2lRO+gSc2M8a5d++scEWm+nt7RRJ4EgaCsdbJnnU+JsA==
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
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..d6b383d96a0c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2501,6 +2501,17 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	enum scan_balance scan_balance;
 	enum lru_list lru;
 
+	/* Proactive reclaim initiated by userspace for anonymous memory only */
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
@@ -2519,13 +2530,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
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
2.43.0


