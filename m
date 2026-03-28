Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD3810F3DF8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56A86B0096; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59716B009B; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B556B009F; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44CAD6B009B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0850C16021E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
X-FDA: 84596519070.18.442508C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1BDD180003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s8VTAgzS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727553; a=rsa-sha256;
	cv=none;
	b=huf4u1pfnIagknKayiOI+VU7sG0uGRuTti2wBhAU3HZi+l09DPycqwiYB/YhUHUSU1w9Lo
	meZtzAzRvWW39kvfJCF2200K7CjbA04yFEDc6XxesjgBEIEfGLwUE1Ga4wzZN6VmFIkbo3
	bJVcLnRFSIh+RbehFdslNJrD5Ia3paw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s8VTAgzS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FE2aDjgzNPGS3jdt+ymcoY3dUOjYQ8HC2+8oUyorW+s=;
	b=g9Z298n0prUVIe0NfIakmLUh7TLjzw9SS1ouGUmd8d6IanuTSGPJAoD+jbm42DN4X1EkGi
	Amud/Nw4u6a6vs0Aim8g7vB2is85X5IeX+sDUpkP3CC1Bmk2sRMoLtoTwF90XwLENVECLd
	FqD0a8lHijAO58lDTQMh6IjQyzOzaQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B50344595;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68DD8C2BCC4;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=t6MsHbcxvfU7IqiZkN8IgPyQhTVvlGzqYWvOIjmPUCQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s8VTAgzSmPwtDN1GP79+hO4kjdVsFxC779L2/EL8SJA5psrugNCdmqwQK2Z9NdxfI
	 VT+1rXTihRb5YMDNZh0Vtrk1gXiVxSMeaCTdaKIApTP/aB9nKPay3YQDveGnt3cTmj
	 mCF028ALIwxn//NTAG6mpFmmVVCCJruocg6XTdcQQxereYnYlZJoB8u0qx7wnpJJ8e
	 SJWvS4OBEZHGA0pkwq9i65qRX0XGTVJk8/LjKsJUg733sCkcegOBjNoOO7FnxsHuLt
	 9De/3lBkbg/bdvCOMeok77vsIel74diDOK71ApiSrZmdBNZ+nfhnEIEyAtIN4jGcIS
	 ahuUzfNcJMOvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD5910F3DF6;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:30 +0800
Subject: [PATCH v2 04/12] mm/mglru: restructure the reclaim loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-4-b53a3678513c@tencent.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
In-Reply-To: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
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
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=5791;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=NTEcn1j1VzD/wA0hpGeUq8Ux67UjJ/BHDr4z4JuB2Ak=;
 b=ZR4spFHD3fszxHo09h9YABEgsRpcCC2VBGLvaWxsV5L0Ba2zGd1rjDJYWfE8ZKU5gqpLtXv/9
 g9nmZviuqhGBRsBsBhJ7eNpMLRCSnRaHYI+odCb0I2qqilJp8/Rcezy
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: wi8dr8qqti33w6t3qxsihyxe4p9e4x3b
X-Rspamd-Queue-Id: E1BDD180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774727552-592054
X-HE-Meta: U2FsdGVkX18f3gjbQmv9j2fmLn0uvoX9UHO4vnNYWvEal+JrSmk6k7UX1GtnzMQbdeIyhRA/DCAh/q5fLBcsI1HTD1yq8Ybhih97peLtSXG0V83ShEqYUbRJPJKi216RRb32VaIod+QGY5ywc8IMPWNrnnBZsRepNaF/6NG+4Sp29cw32C0XSKrWlKG/cq93uClA41OK5r2ss5drpFY1hT61Abm8skqMgiqfw0MbQcN0jWRQ7OfFvGu7WRwGXHLNVj0p3Ih1O+2Fn0noepGBWDn9fch0Q2KjjoyhLR0EF3WqndlGeYWieFu+qnT6os8u77icEZxUyeuWcwI5OK2rjDDNxXrqNzawK6MgNHNoBcbgK3iiynlg0glmUbUy5pVq7vJFGiKqnhLxAVh5SW3RBhvEgRiVlo1DWtiCBYRVfqgrP0A/qt/vPF3Mxw1f3LvPofh/zfYsftQA1B2mPFz6E2vyQde+LyLcFMuY8ntsEJ3PCVIso+y+7vNZgU05Z3SR3LYh81RS2E7kE2qu/UOZqE1cMGLV8zALaw8yzgcDW2SdNm7HKnsjE9Rvjvn5y+bOTr1El5sjuo/DC0oHvs8Tr5MFW1b5xtjAsITrirfR4jo25kvQOQrc7XjUKUysn7YdERNIIi7hhXjvFZXrjJ1N6V1se1+BCSfbnLpF1aUM3rMvB9BuTBUtmCf6S3Dmgdm5iqiX3tFX952WA/nLUAAuQtA3f+wRJO6x7DvM9/aj6gaCYAV4+4FnN0eUOaLriJKz8kTkihxHi4bmemJgMsK+BhqQxviGtshQ1FX1lIDQMwULfLNmC7yYH3vvN728qHvclaGMOHDKJExs4zR2Oy7mT69+Htta7k5Pzzml0ja2N8q2OXVKvDb6sY3kPP9p00ffO9gpI0UaIb7CO7E64PYQF6Cd5wwDnVA1qPPO1fQyuFhdFPWF6LzEithlVhfkswpGSZwPMrICHitsxjCImQ+
 dXUq8Tbl
 vqYzsv7N6SdpP0Tw6Va0I/rLEk86xbcTpXFCa1pfqX4uMroqeSLhiD4UnSzmfj+o8fh257qJscurmKeFyR7UghDIMG/daHW5HuCXX68ErAC0vTIKzJTUVmz/STR2fDqlHrYeL+/20rRZQf42SlStOZ74FWqL0rm2lBMmpL9iKuGas43Qok01/E7OWeAXeVIKlKlVs+OH72luaVmredRW3tyTUUIxh1pABbH4nmYoQPFN/bt4aGAp3qhymAegj1jr7TgDQDMqHBs1nS3Hw4DNGhJp5OltcI3WavcfZs+ZBlddl0T5Xmxpq5UxBZh8nTB50in8pgc4UhHFZ4SNtXUs5SE1MQBBgBZTx5oU7SDUGGJ0ZX5fmTlVvHqSl+u79XDmYFDnp7Wg4GEKYe706QK7OhjMuomymUV5TcUcX8AyahqBiZ9QacPPLeYq667HFkbx9S9mGduLW/ucUC02D0gup9f6iQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current loop will calculate the scan number on each iteration. The
number of folios to scan is based on the LRU length, with some unclear
behaviors, eg, it only shifts the scan number by reclaim priority at the
default priority, and it couples the number calculation with aging and
rotation.

Adjust, simplify it, and decouple aging and rotation. Just calculate the
scan number for once at the beginning of the reclaim, always respect the
reclaim priority, and make the aging and rotation more explicit.

This slightly changes how offline memcg aging works: previously, offline
memcg wouldn't be aged unless it didn't have any evictable folios. Now,
we might age it if it has only 3 generations and the reclaim priority is
less than DEF_PRIORITY, which should be fine. On one hand, offline memcg
might still hold long-term folios, and in fact, a long-existing offline
memcg must be pinned by some long-term folios like shmem. These folios
might be used by other memcg, so aging them as ordinary memcg doesn't
seem wrong. And besides, aging enables further reclaim of an offlined
memcg, which will certainly happen if we keep shrinking it. And offline
memcg might soon be no longer an issue once reparenting is all ready.

Overall, the memcg LRU rotation, as described in mmzone.h,
remains the same.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 70 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 963362523782..ab81ffdb241a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4913,49 +4913,40 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     int swappiness, unsigned long *nr_to_scan)
+			     struct scan_control *sc, int swappiness)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
-	*nr_to_scan = 0;
 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
+	/* try to get away with not aging at the default priority */
+	if (sc->priority == DEF_PRIORITY)
+		return false;
+
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }
 
-/*
- * For future optimizations:
- * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
- *    reclaim.
- */
-static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
+			   struct mem_cgroup *memcg, int swappiness)
 {
-	bool need_aging;
 	unsigned long nr_to_scan;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
-
-	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
-		return -1;
-
-	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
 
+	nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
 	/* try to scrape all its memory if this memcg was deleted */
-	if (nr_to_scan && !mem_cgroup_online(memcg))
+	if (!mem_cgroup_online(memcg))
 		return nr_to_scan;
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
 
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
-
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	/*
+	 * Always respect scan priority, minimally target
+	 * SWAP_CLUSTER_MAX pages to keep reclaim moving forwards.
+	 */
+	nr_to_scan >>= sc->priority;
+	return max(nr_to_scan, SWAP_CLUSTER_MAX);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4985,31 +4976,43 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	return true;
 }
 
+/*
+ * For future optimizations:
+ * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
+ *    reclaim.
+ */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
+	bool need_rotate = false;
 	long nr_batch, nr_to_scan;
-	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	while (true) {
+	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
+	while (nr_to_scan > 0) {
 		int delta;
+		DEFINE_MAX_SEQ(lruvec);
 
-		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
-		if (nr_to_scan <= 0)
+		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
+			need_rotate = true;
 			break;
+		}
+
+		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			break;
+		}
 
 		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
-		scanned += delta;
-		if (scanned >= nr_to_scan)
-			break;
-
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		nr_to_scan -= delta;
 		cond_resched();
 	}
 
@@ -5035,8 +5038,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)

-- 
2.53.0



