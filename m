Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41CF7FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9DBC6B009F; Mon, 27 Apr 2026 14:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26C66B00A0; Mon, 27 Apr 2026 14:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFA56B00A1; Mon, 27 Apr 2026 14:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA69F6B009F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F83416025B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:20 +0000 (UTC)
X-FDA: 84705117840.30.8C4FFA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4156FA0006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hlfO/9X5";
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313238;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlKnCgbeyTZOqYyxw3yP18dZ6XVEA7HkhLlOla+m2WI=;
	b=dmDVqvdzYZQXvu/7yotwlW83uN0R1mpx1ZRBiy6UOfiWK7pg8jo3XzI7NIzluFs6f8mYMu
	ZharlOsqHArlG3GgHgat7gzq2lZTgg/OqKADRinKUV2HvGRkw5KJSVqK37bipAlRAxIy82
	Tn+AamGXWNz9SbHnOeNhY7HL1xH/2uw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hlfO/9X5";
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313238; a=rsa-sha256;
	cv=none;
	b=KZZubNIhzWscLUU2MNk1q5CJ8/Ql7qQcR6AM1iNG83z7RmDSnMs4DjKR3qTo0Eu94aZCXG
	ScTIk0NQ/gn641W1AX0df8eeHa8O8sHX5XJFo1PTw5WpDxp7zmlKg5VBCxGurkoivX4AwL
	gzYGzvQ4BmubJLb09zIb/+FE4NKx2pA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E883D4472F;
	Mon, 27 Apr 2026 18:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C75A3C2BD00;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313219;
	bh=F69AkOfNOrc8HFY5AD6s9a9y2jE0zbVIRmHPwZMejVA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hlfO/9X5aRPgLXqsraOK7OAb/r4MEAlg415q7Ijt+LMG3QHYhfLXt8H079zXaD+qD
	 Oyp2lt480bafLv3/QAW+OK8ZzvGqfBAxRvBK6a8pT7TLTx3PGWJese3EijH1H+eUvF
	 G4POdCKfLCBDeG3kaffyfjb4JxrOl2T1lXdBMlvncxjmz+nlsBWnAm9Ma7UmewQu/M
	 e9hM8wM3p3Eg6PZKdByeEHRLq1yzfyaQl4lQft4QUxfrnIylw0gTLKBeOwGvWu8dDo
	 l62VmulPbpvoxMxRUtPeU+VvGMTK/2cyT97MzReYdcNBG0F1RjDmwdCdELvZFBx8al
	 AkbWgyGBkxnhA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF82CFF8860;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:56 +0800
Subject: [PATCH v7 05/15] mm/mglru: scan and count the exact number of
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-5-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=7211;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=hdXl21AaB9u9Yf68HFt0OG5tzCbMPEW7u+ust52iMoc=;
 b=Ek/aSI4Ik07jOoqPRLdVRrWbg7fHUbDxBwk0wQQ6ARGgZEo7/A/ptlqqlLw9BWFxfjPQ9Xdy+
 J1Tyu5zwyHWBtFsf9HYAHOxiiNG/yHxNJ2j31nrQxGFWDTgJlr3Piwa
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 4156FA0006
X-Rspamd-Server: rspam06
X-Stat-Signature: cp1ozhkky5ai9yr7p9jo8561bhaxgfh7
X-HE-Tag: 1777313238-920691
X-HE-Meta: U2FsdGVkX1/uVvro/eJJ5Amytg0Y9h6UJ6BXHheT+V+ZGfAsmUmRn3x9//GvFeiBTjcd4fT+ua1dwFC8LhD+aTeMcs0XI/9Y/zkaM6gGYua1OJE4pkVUJn2iWGy+NXqqFKiouvT0EOICkRnYkaEj7MxnOsazD6gU2u2xLga94kgHV6J8Y0Qan1TrUErcWvMPq5+sG4s9EaSFCiYp46kqiHBmxhC36D0hvxj7dsagRL25oypZnW7tFyuaYQgdYRLoTU2IfNSfkIBYqviXFkTn/Yg1pnVXUOIFZKKGaT3EBzXrt+9507kT6I8TxnjAlid0HxOYeJ714reFItuMY/R1ZhCEROgKTFhhPCgRI7BYIQrPjBYDqd+01eZRaCl6tZsmrZEHdze41TmsR9HHz33JGlnNRreEHBrIOD5YQ5NL7f9HKQpILC6bFRxcCROHuU5AuS4O9J3qP2g3uUze+gOPJ0qFQTHhJ6kfSyaLAKqhwQD4OyFuSc1p7+T8W7zjcvCtm3VgADrlUVT+eMSQD14r0PWKro86TXG2KHTEMUIrWjOdwDe7kGJx6rtF4318MFCl98dGwzpR7aYVqway+31CdqgkzMRhH+5CqFeAS2WllZfH4IhMZjNx3Mx2r/iJA7e0csXISgSCVxc6T2r0w755kW23Ptwi+ZSUSsCx1lKXIuVZMV/EUHbaAo1oWsg8VmXCOj0fUVw9/Ei1vVGq3psDnJ8a9cm4VazlljhS1D9TJkt8NdNsiJmR6uNrmyidCwCR7uX8N4rrT7HwTFatzdUcl70FdfqB/ezDSvacjy096+46DNNs6ANy9h17xK3Vq+0Th8rq+xFt7SBkET9nap1NbgJKtzpkN1zWpdmDeq5YJ5VGvwmSSpfPjaY/n5HxcDwZBo73A0pgnMCHC7HG8GEnk08HXM+H9znMmG5G0S6bNgtc7NZYtpEwdLIEzbf9w4Pm2nMQbg6yR2MtnM0crfu
 mhyzDfRb
 0ic9rV2cdmDpfLY3ndrnERDsOZ3fELidXVXC366qwwiVjSd3R6Kk1974ctKifDCz0VeM1gmmaINQnR0hKFW2Nebi1jPpeILbP0OHlrJNMDGGI6MsJEQNw3aYqM53ycXdZ8T7nIBOBwNH19tw2p5sgQSRdCTo6Sc/RN/OZY8RmoWnzVlckJrOUvRFaOJefK7GyiY6kpUkK6GxaxzFsqgf9XUPD2OpalAUraBvs4DiWlqnxbryhdLUXflijI52Tww6+1Ku/VPDb02Ygw7VwXwD8vvqETvcePYi1KH43TVY3srSNHHvaoM9bii3RXH5aOOgj265cuwOwdgz/i/BZAfSX2oZR/z+HRicYLElDjOd0GUmc/jLWgq/4QSzCpDnRtu4VsP9IFs4Q0PW0G/hVKRxmW+pYCYNG2/uWOiC+OfpK2ifaTRIGql7W9IP88vYgqShcYW2Xk2in0R8MYTBThlzaeH6bWux+wOwUWUvha513TnJPTnyFlAYleT0WDXHY9Sm7axbL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Make the scan helpers return the exact number of folios being scanned or
isolated.  Since the reclaim loop now has a natural scan budget that
controls the scan progress, returning the scan number and consuming the
budget makes the scan more accurate and easier to follow.

The number of scanned folios for each iteration is always larger than 0,
unless the reclaim must stop for a forced aging, so there is no more need
for any special handling when there is no progress made:

- `return isolated || !remaining ? scanned : 0` in scan_folios: both
  the function and the call now just return the exact scan count,
  combined with the scan budget introduced in the previous commit to
  avoid livelock or under scan.

- `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as
  a scan count was kind of confusing and no longer needed, as scan
  number should never be zero as long as there are still evictable
  gens. We may encounter a empty old gen that returns 0 scan count,
  to avoid that, do a try_to_inc_min_seq before  toisolation which
  have slight to none overhead in most cases.

- `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
  the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
  naturally returns 0 when only two gens remain and breaks the loop.

Also change try_to_inc_min_seq to return void, as its return value is no
longer used by any caller.  Call it before isolate_folios to flush any
empty gens left by external folio freeing, and again after isolate_folios
when scanning moved or protected folios may have emptied the oldest gen.

The scan still stops if only two gens are left, as the scan number will be
zero.  This matches the previous behavior.  This forced gen protection may
be removed or softened later to improve reclaim further.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 58 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b247f216f28b..2dbd39e29dfc 100644
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



