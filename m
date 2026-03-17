Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3819FEDA14
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFF36B009B; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6C16B009D; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD2B6B00A0; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08A986B009D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6EF9160364
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:49 +0000 (UTC)
X-FDA: 84556499538.21.1B4F902
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C72232000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bU8dfYtw;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774707;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4htR8LPOlOrPdxC7Kj0M+ZPkPjhx8poq+ufsf7zolQE=;
	b=b2wCk1i5E9h1whXMDAjB1FvGwpPSPyGqhvx5G33uQVcdbl5gIrCTJSxeUsQZYrHvDUncka
	2kyvAnyn/SxE+1612e3kocBFTP3D4qQef+yrdRdT2T8t//AK0jqmeNZDluWwJpqKyuEyQR
	zr+7siuyDZ9hmfgNrnPQ+ax6oG1K1mQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bU8dfYtw;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774707; a=rsa-sha256;
	cv=none;
	b=WAZ4rGNZifKk4qfjcJtdBH33au4WJMS8Pl6lb+hGBxazUCK/GBTpsLD2FZOMJiw8N8/4oy
	+IEyRqpTwU98bx3vTyfdj4ko7oFK8S5Nj4vtlaFdpMrA8Ty86lfc0Pn92FmJM9n/Ez0Ibk
	A88+f0p0jeLm7aCChGA8NT90vNhU1L4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27ADE6111A;
	Tue, 17 Mar 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85512C2BC9E;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774706;
	bh=ub6TfhBgIDLqvyiHJLGNTtt5hKAAv/82XgeHTKRk6kk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bU8dfYtwPQKGhoGph2hTp9W4+OsTlRhfsK/7B86bublwpQ3yuuDbxkbAqoQU/8DWT
	 D2PT/Ne65EakabxOqTb3vC09jvy3ccipG164ZQpgj/qCZbCN5/CYG78TDgYowFB3JS
	 KC+nPV+R0PlDGDgjZ//sHukOn8pcxM4V3IhdAkeJSQ7UHxpbJzeFgkz2V1Lq5RkkkV
	 4mrX3zCg9hD+0iiv/PmY0hNg1IQDKsJ2cmAoGiylyeTLzsXuBqpMQIdoWqofJNPgJ+
	 z2MZsYzUivWKM0YXTbRlRCvePT62I2nT4HHFIPJXZgEuDbOlomf1RXoy3GEq5ffhub
	 OYc6JNlK8dq6A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74428FEDA10;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:08:57 +0800
Subject: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=4083;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=oBDA7DoT+1LgZqzpmvPbT4X1VuiGCgQ8ao2nlrP+Kj0=;
 b=iHaahECT5wFn/8x3pOujy095P54IV+9WnkgMAUT2I1Czxg3d8ClJY6ZPN97ihTWBUn0bJjLoI
 zQT8vb5jG0fDeEZsBGFTXBGIzPWtlMUzmxDquBHFrTjaMGSvEq7rNk7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: nzaacz83bcua8x5zyndtfr7jd1de7myq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C72232000B
X-HE-Tag: 1773774707-630846
X-HE-Meta: U2FsdGVkX18/AsmQYu06ziDIyIWnThl+1aqzjPVzDsk8fNcnEPX2fthqjx1pdi7DiEgJ3Eyq7+QKBzFiiYCIhQeX4neDiqGIgdCFa58oHvHLKhgjpWixF0x3JW21BEcg26TaDDMqX8OhnFd4rA2mS/7bF/UNJtyg5yK3uSV618GiB7qe0mLVFpbtW+qQWx93G2CnPmHNiVZiw8FVCD89H6bd0e80eXQoRZJGxlD+G2lV6iKLx1xqziePjQLyxxQi6vF8kzSCchoJPaOSfFZu//4R198PB5RKQ6AbxzgaCU7S8ML2XO2vV/ZJkSB9hCEHa0EovDUK59f8SwH3BPURSjS3HwaBWlT7oeVKuGw3+w6va7WUVxRbFvQX6fB2cF7qqSVRRxrjA3SA8WDaVm2KZLtTTzhmL4fioySB+FP1y2r+cwri65UnP77u7xxhY/frJnoy+lx+SSHpou3KyCO5smUinATUtFnO01hpJgCFwnuRmlKw5Y2TnKwqMtQZvvMULmcjK5bFSiz9JRQCyzK5AsSQvhDyhqvVBhsvBBn6t7EaXjc5jpSgdyGasIONr6aIDxG4Zfz9xWNWA5gjuAB/HF1Rg+3fNgY/VLarS3loTWys5rLqkCwOfiliVySQB6Wd8IOe2ieZoRHYaORw4lGfIu+/hc/ZtYaOD4zzyjCrhMmi2hGtpiQwnEyyEhdCjqOx8cTZwVS0unMCXMeuJlLoQZ3m2thUnyqDrt6B5Ta8ZaRZh1tbG1QxEKAxTEo6GmwSYwqbpnWZpIbEoMlqMdDVwYhr7rNFr17H8PjWxU/NKXOee3NBZyOFe7+zoK7EU+oivHBfTnxv3RCQprjTVCpeTiq7j2tB0nhR0icLPLEpiHw6E9m4bSZPSyk+3iIG4aVxSn8l2Mjrs7rhoICCmFpwczm56CcICBPgDfy6cMXc6ItLJgbXO2QtmQvLEr/YQmv00hvj3pX8stax9I0RbAd
 nGUNQs2V
 JHEY+I9U2oCHf2s7GaSZD/zs/twGF6tFEkUlWrZ3eKNLUhehBg8APk3KgtlGSkTpSGyYHH7M6c6TYnZ8Q1UqIhrkElZyls6o9yhVpFfGXGRJV7qO7BPfeskeyMpMyFoFQ15Trh5RuKXjr9glu3PhbVLWCymN1v0yyLJReIhC6xTfA8eFHsIa6j2+PKLIbY6IgAbsUWVamI4mTfhH5XPzoOTpXaQhZhrZbyHxsObdM2dsAkrjgv7r7jvUcH6JGw3fb9G0hBbylmVZHcgOiGzGlPVVnMRCEK6K4dBx9Ns38zqJY3bpXNWheyuc50JIxOZmmlccDHEqMErAao0sz2MmWX2mR4E2CaJ/lKff/OH+j1UfoPhOrMB2JtO9AMfcrTgHaANgWtZtiEBbM7AJOkPDpQHKUEnq/d1q+pFUk/8OfIvQwZZ374zxgSPvgPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Merge commonly used code for counting evictable folios in a lruvec.

No behavior change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..d7fc7f1fe06d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4078,27 +4078,33 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	unsigned long total = 0;
-	int swappiness = get_swappiness(lruvec, sc);
+	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
-
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
 				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 		}
 	}
 
+	return total;
+}
+
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+{
+	unsigned long total;
+	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	total = lruvec_evictable_size(lruvec, swappiness);
+
 	/* whether the size is big enough to be helpful */
 	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
 }
@@ -4921,9 +4927,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     int swappiness, unsigned long *nr_to_scan)
 {
-	int gen, type, zone;
-	unsigned long size = 0;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
 
 	*nr_to_scan = 0;
@@ -4931,18 +4934,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
-	}
-
-	*nr_to_scan = size;
+	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }
@@ -4954,7 +4946,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
  */
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
 {
-	bool success;
+	bool need_aging;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4962,7 +4954,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
 		return -1;
 
-	success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (nr_to_scan && !mem_cgroup_online(memcg))
@@ -4971,7 +4963,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
 
 	/* try to get away with not aging at the default priority */
-	if (!success || sc->priority == DEF_PRIORITY)
+	if (!need_aging || sc->priority == DEF_PRIORITY)
 		return nr_to_scan >> sc->priority;
 
 	/* stop scanning this lruvec as it's low on cold folios */

-- 
2.53.0



