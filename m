Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9977DC4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9E56B00BD; Thu, 23 Jul 2026 00:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2C06B00BF; Thu, 23 Jul 2026 00:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F676B00C0; Thu, 23 Jul 2026 00:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21DD26B00BD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:58:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61DD61203A2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:58:14 +0000 (UTC)
X-FDA: 85018834908.16.7560F5D
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B40EB140003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:58:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iKpDd6OM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784782692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFTqvoKbwMWTXDnYGsKcqBttpTGihYLNyhVUcDk1sMs=;
	b=KXMXNfA5sp1w62ySzP/j9r95UXua5xC1lGCQzqnDueUvEkwYjeII2xm1BkqLB+BEusRx5V
	ddrdrdPpM+iBvb4XUV+KYIc2iM6H84D0dwDyhVeyqpNLg8fPYAfd94Hr1Hg+B6NRUcLprd
	UveeoS4fyD7nsJ2v81OXWBCiUjFdiOI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iKpDd6OM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784782692;
	b=uQKXi2omkekZdabwTWUs45rmQ8bgszcebZXBKd4mIfnewxOV+RcAHUy2Gce0B+yc7FdNgL
	ycX7N0iUdpzQLtHkc2978PUUx55N0x7sMNyDbRBjEENvakhi1FEln/yILzt2aJfLe4wCYq
	chY+uGrVFtbuzdLOskGWbqDqBw1AGEY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784782691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tFTqvoKbwMWTXDnYGsKcqBttpTGihYLNyhVUcDk1sMs=;
	b=iKpDd6OMt2Ad+zyPxrYsQASJgE94Gpi9OqU2Wzp2irDu8KbfmMKkwyX1FwDdqBYjwZ2mMK
	65qfiTc2sYQEQ1O/U+f9ijSBssMYOzcrY1SjrQChaE7OQxnWfC9RagIDCFGJebJ5PW6VZF
	omyQRZser7Eyngef9o0vXHPwKFTAQnA=
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
Subject: [PATCH v3 4/4] mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max
Date: Thu, 23 Jul 2026 12:57:18 +0800
Message-Id: <20260723045718.2052070-5-ridong.chen@linux.dev>
In-Reply-To: <20260723045718.2052070-1-ridong.chen@linux.dev>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B40EB140003
X-Rspam-User: 
X-Stat-Signature: 8yad7zentdoeoxqnzc6719x6xk4gpe1q
X-HE-Tag: 1784782692-29576
X-HE-Meta: U2FsdGVkX1/ey1ZWIqkBdD63dL48vJ86VTJ5mSIM3p+L/LgDUz5vvgj6hsntIr82Aiav1yQenFjKf8BeM11DZmVZH7CnyCuLsz5JOUOHHFUMpyvBVkNs6PewMOzBlpfAfP2Xdgqr5Y+UN8P9txRxRPvWVrJbn4eTWa0xBeoVjImknnyQLCjbc85DK5bRc2fS8fOkQzFISwJZfritXy0sWAgRTk/mpjC481Qp/lupv+I07OtDLVGl1nGA48oScNUOiIiVuadj5L7Uz8HdasxmT4bhontd33rU2jt8TyWpW4pjm/PDaI+W04MWfYM/+vLnYTd/TyBScVBbE3XbxRZ3CIOCximCcovh+phq88rD50LlGD0xTL40LhQpkrFm0LRkOeNQUICzmmPelzdbCHA7yKY+KyRPuo3qwgeK9pS+xIBKz9E9Zrcpvy4ZPKPHxCj2hOoQggmp7DCJDMS9znHYpRbq4kaC9Dnn3QWnjFfKNTZZ0NpdYoQDcEexPNKLJIfifsN9G86Jh2dX1mh6ZT0b7fYtyjLbDhA8FHF3l33VNVcCW4ckbtvLSlyDAR/Asut5L+Cxuydc1XEy8GGlpCuKD8+QTDhfeB9WduhfAPOJuwHy7iP9m2EicyWoYEpoYQatKowdwINxYiWAu7csXaCiZodxhVOOWQXJti7vaBnVlYMzsIdcxZopa+5upmLpuy/bke9i3FXrnI8cS0Az7V4DU5FL4H8jDTtBxwHcQ9vwHIXpBju4dDieW1mVETU27Kf5cWpttWYRnFoVCiztM2EEe8UbkN6k4CCAySkk/YsAotlXLGkxfb/b7qwxQYK41ilCrShcd1cyb93fBbGAddSgEeV6wq4/3mS7b81INmdH3MXu/nWpxhQAVRMQElPiQ4IxQ65OTh5ic7sgd7C18z+TXNDrxhzJkJH3dS4bkYLrikVdbs4KxPvU4c518VLCmRb1xUYGqq+vmwMFZK01kvE
 yWtpwQft
 rXeTP7XxWxbB42qnI9b4CWAltLCYhs4BnbW24CfTM51cF9XKPZEwY2Zl2V6A3q7ytLIapWFHe8EvAoVI/gAunF/cnwKvIVlvqDZzHJoszF2HAQudEdvvb2Vr5fPnlQpGZRNMDl1ofkVwzPrPLZsLQtEjKE2rWaT6zpDorHDsBMoG6VE69Kxvnls/mVvIL7jw42OaSBdCjrcqQieHEqW78WtDUxTUoTGUB+w89mFHVV26PAJVXEIDm1rdea7+P4qaTNr2TVgxHcFbNM0eb+f4fHNy8gr/52Yy5Egvl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The previous patch fixed this issue for the traditional LRU. The same
problem exists in MGLRU [1]: when swappiness=max (SWAPPINESS_ANON_ONLY)
is set, reclaim is expected to evict anonymous pages exclusively, but
file pages can still be reclaimed when anonymous pages cannot be
reclaimed (e.g. no swap and no demotion target).

With SWAPPINESS_ANON_ONLY, get_type_to_scan() always returns
LRU_GEN_ANON and for_each_evictable_type() only iterates the anon type.
But if get_nr_to_scan() does not bail out, evict_folios() still runs and
isolate_folios() falls back to scanning file pages in the !scanned case:

  shrink_one
    try_to_shrink_lruvec
      get_swappiness   // returns SWAPPINESS_ANON_ONLY for swappiness=max
      get_nr_to_scan
      evict_folios
        isolate_folios // falls back to file type when !scanned

This wrongly evicts file pages, violating the anon-only semantics.

Fix it the same way as the traditional LRU: keep returning
SWAPPINESS_ANON_ONLY in get_swappiness(), and return 0 from
get_nr_to_scan() when SWAPPINESS_ANON_ONLY is set but anon pages cannot
be reclaimed. This protects file pages from being reclaimed, and as a
side effect avoids the useless scan work.

The test result:
Before fix:

  # cat /sys/kernel/mm/lru_gen/enabled
  0x0007
  # cat memory.stat
  anon 204800
  file 67108864
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  # cat memory.stat
  anon 208896
  file 0
  ...
  pgsteal_proactive 16384
  pgscan_proactive 16384

After fix:

  # cat memory.stat
  anon 188416
  file 67215360
  kernel 1970176
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat memory.stat
  anon 204800
  file 67215360
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

[1] https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev

Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 859655fcf60d..20cb93fd3da8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2708,6 +2708,10 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int swappiness = sc_swappiness(sc, memcg);
+
+	if (swappiness == SWAPPINESS_ANON_ONLY)
+		return swappiness;
 
 	if (!sc->may_swap)
 		return 0;
@@ -2716,7 +2720,7 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
-	return sc_swappiness(sc, memcg);
+	return swappiness;
 }
 
 static int get_nr_gens(struct lruvec *lruvec, int type)
@@ -4921,6 +4925,19 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 instead of falling through and evicting file
+	 * pages, which would violate the anon-only semantics.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY &&
+	    !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+		WARN_ON_ONCE(!sc->proactive);
+		return 0;
+	}
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
-- 
2.34.1


