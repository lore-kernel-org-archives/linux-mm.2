Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B0E106F2FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1AA76B0089; Thu, 26 Mar 2026 04:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF20B6B008C; Thu, 26 Mar 2026 04:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D087B6B0092; Thu, 26 Mar 2026 04:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C10716B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:36:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62DE2C39A0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:02 +0000 (UTC)
X-FDA: 84587556564.15.A4C5B33
Received: from outbound.ci.icloud.com (ci-2001d-snip4-3.eps.apple.com [57.103.91.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4A4B4140009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Aj2oJ36O;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf23.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.46 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514160; a=rsa-sha256;
	cv=none;
	b=Iyudnwv7pDSnBbbvBAUm6V3jfibgtb+gg0ZgwzNYHjjsQ/BZWakQxSmu8tONvJh7qaFH06
	CNkAgcJ4g5Gil9cfYfustZU2bxUoP420gRwFXg6YYdNywXMbgJIr2NfnyTtVR9jcHvxWJ4
	wfuMOd5gJNSOOvYdmRQdfDAmxvVkbE0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Aj2oJ36O;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf23.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.46 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnHQdlgcOL/4fk6OrbKqPiZnFKcP7FFawnir2OWjlBA=;
	b=pVzGCtkUYlFgTtasrB2LgjoXKO2SOBQVjSMuBpukrQp4ZVCi5C8bbROAa5MzQQvtyNDuE+
	c/f3/ajKO+6cuA13QSiYg3+qkHiwNKGuuxcVpunM5ec+drdXRgPSy2vyLWi2rjliW9R3vF
	mbV7Z1dhYb4Wvohzs58VoKdWaGKnqdQ=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-5 (Postfix) with ESMTPS id 959FF1800334;
	Thu, 26 Mar 2026 08:35:56 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514159; x=1777106159; bh=xnHQdlgcOL/4fk6OrbKqPiZnFKcP7FFawnir2OWjlBA=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=Aj2oJ36Oa8STaZhy+ZlxoljrnBpK5q4yqOoxBOey5ztWp9e08tvEKnLOEZKkOu+sJ6b0ZcmOBoH/fN8Wv/Jcv9m0mU9HtRx92yKW/nhXB9zoGJ+l8LqifjE2acdCz1AHO6EOpvlEi5kLvJ/o0TIAjHoWXjoIxXbhoBGqe1IrL/o34gKXTZXfTUFJHAGDOlBw03QB5894GHOgVbW/WmN0rLwEDOS9Ajr04bRenBRINvN+e4oXwt2PcG76NzFWoRLJpqBCwp7UIur6f1FkW8PEY92dDRz+xf9UAC5XcgbBqt7M+bPeq0O/ESEwf6ajJk4xrDVXA3jj/OP0OZXsxi2cRA==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-5 (Postfix) with ESMTPSA id 73B1C1800335;
	Thu, 26 Mar 2026 08:35:51 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Thu, 26 Mar 2026 16:35:34 +0800
Subject: [PATCH v2 1/5] mm/vmscan: track reclaimed pages in reclaim_stat
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-batch-tlb-flush-v2-1-989ba60f970d@icloud.com>
References: <20260326-batch-tlb-flush-v2-0-989ba60f970d@icloud.com>
In-Reply-To: <20260326-batch-tlb-flush-v2-0-989ba60f970d@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514145; l=4784;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=L4RSnGOlWbx1ob39I2cW9qTJxKxYSjJYIPZI0IE6F+E=;
 b=5mK3faRwaQf6T9pJYCHo8hKEEXw/Vn8JHfr0/PR6cQzeIZlEa/fmvoMM2U+AkPtOOvi7+4Lyi
 xLjHYlvRlGoDmSc6lQ2b6EcuVAMtURo/b0d+Flc0cnneBWRweqN3o1K
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: pVimxRQurKr82CmE_GQpIQ7Lord4Eqq1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfX5/7rx9XrGfxx
 PD1dWLBMFQFI7P7RWMk0WPcmovs69DuUvvD3oF/PSNjH/BGZlzVWeTlb8yCHBRJtjEjNfyiH2yy
 Hj99Uhx5MwK770V9uOpa8u0yfVDIpuDqAvpgcVF15qgWoQfYzTDN8nutKSgSb1GmJjDaiBMSMcp
 REeS6662kMUZu9RaCwHP+QX/nPtjX7xY+v0N4/YJaEZwFEIokPPNJSvS5Ne59MKIyToGXLMk2rM
 90Ojh4la3RVorSLgxfvIO5xfMv83xihVi6yo9RYopU/1o3ydV1mK/RZMQXPUpPEn/pBOJtPjTy0
 9uS6KGkfsQEJ5VmtdQEPSt7/J1qVbDBDZD9WxmbqSnVCAa1RXufExnfaWrUTfc=
X-Proofpoint-ORIG-GUID: pVimxRQurKr82CmE_GQpIQ7Lord4Eqq1
X-Authority-Info-Out: v=2.4 cv=Op1CCi/t c=1 sm=1 tr=0 ts=69c4efed
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=_Dbb_MnoW-ofl-KRMSEA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.22.0-2601150000 definitions=main-2603260062
X-Rspamd-Queue-Id: 4A4B4140009
X-Stat-Signature: gocd3pxosyzyta8aqxjymr5jzqg67xmk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774514160-969267
X-HE-Meta: U2FsdGVkX19IetgZt9iBOBvMs26A61lgvYxOUzbTl169ZAVveECvTrFrbs/8VvDxNfLlsPFHuHKORDr+jGA9BG3i/B00nj4LBVYn19lmRcdOWpQvWIg5JdXPvhvftisFBEvAhCz79+QKg0x3hgmut6bLTI0ff7IdhQUYajEjnrf9fWiaZKNKBr3cqOPoRFiaFkoSBCmPTxk4+RvTBadOKkQQhBsSrBUI2+Q+iRP5AeYt/paf8FQlCHnJeDss1LQl3q5JE/4VjUIMJUwnq9y1mf9Zydxkp2R+txOAQH+fed8p34E84i5JQG0pxTQ6p3pHILu6Y2454TD7RmJAu8bWUN6e8Kbj3Ta4ht6yCTQplEcnDiWGSYLcRXdrzc0xEhBl1mBdqDfEaehuHj48rt755BUzcv5BtHiR6tlCwHMYxZPovAb1Hc5h4mYdyge3Effqnu/TI1gI5kI+YJVV4WbI8k+qL3dXzsxms2Kt/JgiHEVVvOmtpr25l99CQnuC0sbSAwrabcap7po3IT+bKRVS9lEe/5Rg5qXS4W5Tsbnno8xmecZBf1+s2KyK7gYrls4MgVmBQut4+572AyPeNh/5uBPiFdo1JGqlBoIwtjicDOn5NGiFzdLjSmoQP7Xdpx+Hi8qEhTl+Xrr9j1Mka6+gcf98+XAvxJ64+Mm4+o0mqiNj1d5i0OeDKqg0/suPEJYb2BkRg3V5FZ8D9YeSsax6o84DBDueWV+AeLOOAg9cFy900LfdeUfOoiZHedmAo60Q3haH0PKuInijHnmcaKa1IK94rbeugQdHCgk6bsNp/9HloDFM4++1Fcd/rxq3j7lcJnao6a6EUJUUxbCW9ULFxXWFfnLm9Z9PKi4Fl8IGGALzkNSd4AAU9qspNVncTPqHROS466n8OPUTq2ioEBxDeXJ429ZFHsMua1Z875tQU+7DtP7n11LKWRj0K0BuTPqXl7+faMtNRpylZWBPk0B
 /bIoMo0s
 yyX9sIpee75MFKv9NXSauVH8NMKTY9S/ow/rfIx2wnb3TUjZUCB7yu2PZnmei/JDp4/GFgnt5SdeWP7OEUkbQi1dCnbtfGhKYVTyNTeVdJHwnprmB2GSEHjKaOXoP5l+42UsTHaiYowUAKemzB0cZxIJrgKLpzEkh5VXNzrF+16oy93wGqAWrEHLoWRrikqym0exAUYyI5Hpu9wZMLIhVkJHbNOx/Gbr4SL13+iOlL/93lfmR6/64nP2swW8OwWlKqNuVkjZWOW2CGIytcm+3DPiZ1hiQXh1FXjBcrkh+I6CG2SGDC6hLexCbnIDRiADQ6p0V+1mUJwVfxmtGKw7r/HisE015QPrhvBXQl/viR3fbgDhZgj6/qDDFTTGeR3FOqinKyhMNTPgRQjFjj4X9WPEYQx2D8hslQ1tV9HAjhwbs7N0ZEvhxkiy+mlYzj4GrnvLzCAhf9xVQuH1n2dXl7Enj4VqLZuALCgL+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() returns nr_reclaimed while all other statistics are
reported via reclaim_stat. Add nr_reclaimed to reclaim_stat and change
the function to void for a consistent interface.

No functional change.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 include/linux/vmstat.h |  1 +
 mm/vmscan.c            | 25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..f088c5641d99 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -26,6 +26,7 @@ struct reclaim_stat {
 	unsigned nr_unmap_fail;
 	unsigned nr_lazyfree_fail;
 	unsigned nr_demoted;
+	unsigned nr_reclaimed;
 };
 
 /* Stat data for system wide items */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ee64cf81378..f3f03a44042e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1053,9 +1053,9 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 }
 
 /*
- * shrink_folio_list() returns the number of reclaimed pages
+ * Reclaimed folios are counted in stat->nr_reclaimed.
  */
-static unsigned int shrink_folio_list(struct list_head *folio_list,
+static void shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
 		struct reclaim_stat *stat, bool ignore_references,
 		struct mem_cgroup *memcg)
@@ -1063,7 +1063,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0, nr_demoted = 0;
+	unsigned int nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1477,7 +1477,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					 * increment nr_reclaimed here (and
 					 * leave it off the LRU).
 					 */
-					nr_reclaimed += nr_pages;
+					stat->nr_reclaimed += nr_pages;
 					continue;
 				}
 			}
@@ -1507,7 +1507,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * Folio may get swapped out as a whole, need to account
 		 * all pages in it.
 		 */
-		nr_reclaimed += nr_pages;
+		stat->nr_reclaimed += nr_pages;
 
 		folio_unqueue_deferred_split(folio);
 		if (folio_batch_add(&free_folios, folio) == 0) {
@@ -1549,7 +1549,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	/* Migrate folios selected for demotion */
 	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
-	nr_reclaimed += nr_demoted;
+	stat->nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
@@ -1589,7 +1589,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	if (plug)
 		swap_write_unplug(plug);
-	return nr_reclaimed;
 }
 
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
@@ -1623,8 +1622,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 	 * change in the future.
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
-	nr_reclaimed = shrink_folio_list(&clean_folios, zone->zone_pgdat, &sc,
+	shrink_folio_list(&clean_folios, zone->zone_pgdat, &sc,
 					&stat, true, NULL);
+	nr_reclaimed = stat.nr_reclaimed;
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	list_splice(&clean_folios, folio_list);
@@ -1992,8 +1992,9 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
+	shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
+	nr_reclaimed = stat.nr_reclaimed;
 
 	move_folios_to_lru(&folio_list);
 
@@ -2168,7 +2169,8 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &stat, true, NULL);
+	shrink_folio_list(folio_list, pgdat, &sc, &stat, true, NULL);
+	nr_reclaimed = stat.nr_reclaimed;
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
@@ -4862,7 +4864,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (list_empty(&list))
 		return scanned;
 retry:
-	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
+	shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
+	reclaimed = stat.nr_reclaimed;
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,

-- 
2.43.7


