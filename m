Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0F4FDEE35
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08AA76B009B; Thu, 23 Apr 2026 13:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D806B0095; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3896B009E; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B0C426B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65EF01602DC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
X-FDA: 84690542790.11.2E97251
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37338C0003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EkyCJPzI;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GwtkSWJIRN2oxyRpienwTULTF1HuGVI++r0zbhg1Fnc=;
	b=uGVWKSpnq9uD2NnBf52/WYfIQ7dDdy1tc8m8arlmqHLXHEW3Jfr7qNQG3XjSxRj8KfcWD6
	/5gGerqvHKrPXcr80l3XHSV+qIpm1PJqa0h7/feUY27052utZ7L+NAOJzDxDG3l4uFpTKe
	f0nf251r2KNg+YAP7lM7XLBa7B5PHA4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EkyCJPzI;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966213; a=rsa-sha256;
	cv=none;
	b=IRvLhgZzRFs1CUJS7ufinNn83u1GO23PW6GKweiRgIy2mOUumEYpj6RsqlgQswKx2dMOyD
	5ulBk63cFvvS8k745sPta61+i/Y2A2u9eH0jHaQE50SHRM8IWBjtfbP+orDMYfI6AeNsQX
	NmgundZNllYW9dzawHVMDiccoSi1rFQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D79E144735;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5887C2BCC6;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=fb/z4l46p6XtOPb396GCXAdoZhV6g80kH6BiNXsa0uE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EkyCJPzIi1tfOCqgUGzmPuQWmPAq5kKb9R1lZlZS96TRLdsLhxpiaBAmqMGzwGy+F
	 pEyCG4THMs4wdXc/k8YpnQcBguPdsbz/OfAQgHF72q07ip8Q9JZ2R16V+Dm6acEu/U
	 hArNWg7FYHuzO7d3t+0KfRE0T42yhT4qIuQdr33AdnU1n4i8dSI9jRMJtY0sc7N6kT
	 yZUAuruXxNhA4yuxXB3F6/EckCRUGP6ZtridFVtfPHY4kS2lJDZc6R2AXOAvcZiW08
	 30nglUWn1E0xFqhOAjQhq4dc4FUY/AcEzTgILk6MBXfKSXTZ0CaQ5WVNGcxX2fhm2g
	 gQQyg7i6c+osg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C1CFDEE31;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:16 +0800
Subject: [PATCH v6 05/14] mm/mglru: scan and count the exact number of
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-5-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=7208;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ODZqtE2pvK8J9b/Qn9DADqSwqh8BtYgqOn3xmvuv5Ug=;
 b=/aNBx65vJgi4oAH2q8DW6+fyqSR0cgDQBJkhovj+OfQOqHjzrcyH2vK14I3MkjtML4NYv0uEB
 wemkWElke0TBxt1LAOtgwQkHLal1jWOzOM8sVTlEuYI2KQgJfbAChNR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37338C0003
X-Stat-Signature: exqgfwj81khdy5drwwo7mrikn8dc1arh
X-Rspam-User: 
X-HE-Tag: 1776966212-789178
X-HE-Meta: U2FsdGVkX1/DmodDGXEpv6/WdSY1EbozIiPfkllGxJsu/mt8uks1mS/OW824wToxsr926U8SCsQt6S5H5q+svlZ6VWeYgPBFggdVjTiSA5TtVcHGKl4LY63iEv960PTj/OfMA6XL1a6d2Z0k4zmpnboGhPZ1y8AIkm0JKLuGOQztMcPlZSm1eyQ33j/QYupOBU0DyOuYHzkWDggTzVoVzQISrDjZfOru+yATBqi8KT4bzBH5mlUGgKF6hZfhgCu+h+AUL1/X/x5kMyynUyEi6oEZiGW8AcsG50awRPf+GWHXE3YG/593EtwbNKJOxN+Pyk4yCIERJe7Y4tqOFgPKgO87XPyn5F5fR50sfIdQlkS+hxDswPTNewkEdAPfghzHHD1dn+NmBI6qllI/gg7tQ6cON17TGuPI/SpnSom5EHJ6fvDdm1r/XkIHpP6yX/vWZnryvceVjiCT25EZrQeosOl8CnyPLn6SI5t4l/1xTZs8EMitIY1qaZqEjm3kj+4CxZBlgfNrXw/2or3KAko/7Zas8Ua37e2hKQ7HynsTWIu7hZKzh8CmikYjaqhnbdWIcf8D5tASWfYzEXLNI+/FC4jicoY29KbnrIfDuBncJx7epLABFLR//YISUkN070AJXbv1qAD21LO+/GMhkXSga4V6NJtGCyBrmrc+mriaewmeDzqcC+XZTJa4MH7M5OQ78zW1XYmPngAt1cNlJpfyn/j7IVfHHAczBqkx8IM55dTeygYGtuFvC2KDizH1bf/PfiI8L84fLdqpHDmnYqzqLmvqgk46MKVrlpeD3nFtOp0RS9Nw2vC+yHRtz9UBDLge4BXOu/Cdih1mYnJ0KuGBDHGnP25oC6AFgkVaE4+HKMeqhNLBY+ZlSI1ttqOPQQaf5ZRafe3dNWlRkJVvTyqOl/Z9GTM8+q84UwHRqGWxqNYGBxFjKeVv9n6k+f/0sggmGDvBiTzZkmOThIDrLGh
 FrkSG6kj
 ecsA/NP+UGX8OoWyt7T1/iU9XOK+U2Cb+PeP9h0s+k7qjP+0kvjwUjxg8peplN3oMyxgT5r45iOzMOjc+JOahFiT/D1YtO7GE+g2ToZdo9VQUMtALxttqq2zEYr/wf+EqjpJZlCkeAnvEIhuBE6oqNvp+KeY3D8/kuxu16FOrL8UlewR7o4WRFI47fM1fG1kRhuEBfOEnBstYKTtdAyVlH73CQn8q/BVaUJEKjkCIJubJcg3I+/izDA/9Nmt9pVmQmab0gjSZ9Z3VhHOQiK92dy8L8vpUKAzrJ91ttZuJLoN047rkwCDzkZ1HeHABVkiQitM68L8a3jVy+MClwZHI0cb/7skgVAJdKZ9+ElPdfhUl+aXAky3pG0v3spHMy6Z/u1aKkZoSaWows4PkUnQo5JK647E3sU3E5Fjt9kiiSa28+c6F99a/tYxGneZT/dppqJkgy/P0etgvR5wppfG1/BpvABcQPXmKcLbILax40UOSUfBdCFTfHn1Unr2HM/0VmOoG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Make the scan helpers return the exact number of folios being scanned
or isolated. Since the reclaim loop now has a natural scan budget that
controls the scan progress, returning the scan number and consuming
the budget makes the scan more accurate and easier to follow.

The number of scanned folios for each iteration is always larger than
0, unless the reclaim must stop for a forced aging, so there is no
more need for any special handling when there is no progress made:

- `return isolated || !remaining ? scanned : 0` in scan_folios: both
  the function and the call now just return the exact scan count,
  combined with the scan budget introduced in the previous commit to
  avoid livelock or under scan.

- `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
  scan count was kind of confusing and no longer needed to, as scan
  number should never be zero as long as there are still evictable
  gens. We may encounter a empty old gen that return 0 scan count,
  to avoid that, do a try_to_inc_min_seq before isolation which
  have slight to none overhead in most cases.

- `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
  the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
  naturally returns 0 when only two gens remain and breaks the loop.

Also change try_to_inc_min_seq to return void, as its return value is
no longer used by any caller. Call it before isolate_folios to flush
any empty gens left by external folio freeing, and again after
isolate_folios when scanning moved or protected folios may have
emptied the oldest gen.

The scan still stops if only two gens are left, as the scan number
will be zero. This matches the previous behavior. This forced gen
protection may be removed or softened later to improve reclaim
further.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 58 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 757beb605980..f021dd1b84f8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3878,10 +3878,9 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	return true;
 }
 
-static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
+static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	bool success = false;
 	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
@@ -3907,11 +3906,10 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 
 	/*
 	 * If min_seq[type] of both anonymous and file is not increased,
-	 * we can directly return false to avoid unnecessary checking
-	 * overhead later.
+	 * return here to avoid unnecessary checking overhead later.
 	 */
 	if (!seq_inc_flag)
-		return success;
+		return;
 
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
@@ -3929,10 +3927,7 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 
 		reset_ctrl_pos(lruvec, type, true);
 		WRITE_ONCE(lrugen->min_seq[type], min_seq[type]);
-		success = true;
 	}
-
-	return success;
 }
 
 static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
@@ -4686,7 +4681,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list)
+		       struct list_head *list, int *isolatedp)
 {
 	int i;
 	int gen;
@@ -4756,11 +4751,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
 		sc->nr.file_taken += isolated;
-	/*
-	 * There might not be eligible folios due to reclaim_idx. Check the
-	 * remaining to prevent livelock if it's not making progress.
-	 */
-	return isolated || !remaining ? scanned : 0;
+
+	*isolatedp = isolated;
+	return scanned;
 }
 
 static int get_tier_idx(struct lruvec *lruvec, int type)
@@ -4804,33 +4797,36 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  int *type_scanned, struct list_head *list)
+			  struct list_head *list, int *isolated,
+			  int *isolate_type, int *isolate_scanned)
 {
 	int i;
+	int total_scanned = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
 		int scanned;
 		int tier = get_tier_idx(lruvec, type);
 
-		*type_scanned = type;
+		scanned = scan_folios(nr_to_scan, lruvec, sc,
+				      type, tier, list, isolated);
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
-		if (scanned)
-			return scanned;
+		total_scanned += scanned;
+		if (*isolated) {
+			*isolate_type = type;
+			*isolate_scanned = scanned;
+			break;
+		}
 
 		type = !type;
 	}
 
-	return 0;
+	return total_scanned;
 }
 
 static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			struct scan_control *sc, int swappiness)
 {
-	int type;
-	int scanned;
-	int reclaimed;
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
 	struct folio *folio;
@@ -4838,19 +4834,23 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
+	int scanned, reclaimed;
+	int isolated = 0, type, type_scanned;
 	bool skip_retry = false;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	lruvec_lock_irq(lruvec);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
+	/* In case folio deletion left empty old gens, flush them */
+	try_to_inc_min_seq(lruvec, swappiness);
 
-	scanned += try_to_inc_min_seq(lruvec, swappiness);
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
+				 &list, &isolated, &type, &type_scanned);
 
-	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
-		scanned = 0;
+	/* Scanning may have emptied the oldest gen, flush it */
+	if (scanned)
+		try_to_inc_min_seq(lruvec, swappiness);
 
 	lruvec_unlock_irq(lruvec);
 
@@ -4861,7 +4861,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {

-- 
2.54.0



