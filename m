Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA8A106F2FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2350A6B0093; Thu, 26 Mar 2026 04:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BCC6B0095; Thu, 26 Mar 2026 04:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1225D6B0096; Thu, 26 Mar 2026 04:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 017946B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:36:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 978CA5C847
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:44 +0000 (UTC)
X-FDA: 84587558328.26.25695B6
Received: from outbound.ci.icloud.com (ci-2006k-snip4-7.eps.apple.com [57.103.90.238])
	by imf18.hostedemail.com (Postfix) with ESMTP id 892821C0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=xv0llZso;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf18.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.90.238 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnHQdlgcOL/4fk6OrbKqPiZnFKcP7FFawnir2OWjlBA=;
	b=LJkvI8NKBeErURj50EqL6E4+7vm7F7z4cytgMr5qHLwIkZJLWPoDoHKRzPsHytTEb78HRm
	U03eJ4FRIx1FdKx69yuoAEH1+DGu+HuC0C2OClFAJR9m46YWi/K374dEzVRu7F/ZjtqDTZ
	GFYhzInXCDaVvgyc5MG5DYTMvbwWFaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514202; a=rsa-sha256;
	cv=none;
	b=P9Yaf8KL5q1PMrgz4jWT9CfS5ozpMbiFDUEhWwsFSyL8xjRHFVdJz/1kWUer7rVqKVUJpf
	zDJLAJdf/9daUi33YLkLdy57blmCtxBdLD/69J8g7IO5SJj2f+/iSYWwlQ2RXBMYBvcBoO
	8cUbJopkuEnuoNNsyDK3jhe2LT8mcmA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=xv0llZso;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf18.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.90.238 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPS id 0B238180010E;
	Thu, 26 Mar 2026 08:36:38 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514201; x=1777106201; bh=xnHQdlgcOL/4fk6OrbKqPiZnFKcP7FFawnir2OWjlBA=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=xv0llZso92roc6dajC0joL0IrCGYUWOmiaNYuBcCOkIvKjSgC4dRNIHAbkKorw2uVYG2agAW900AuFdKL06LXGTdMJRvpUn/CfNr2wuNVyxFvmKjclEg+F+K2NY/OndS62yUhg2E3q6mPTGs3Cr/ZHCffahLm1eq9HmerHgG+uznXg2jM31OW5pi2Y/PixWMnUTk+E3eP8cFcGf2TJpqz5jT/rCCnEFe+NKyjd2a/mykd9kHwT+DLsp4j7FGl8G9fgT96S60Vt/90xYKms/XpLLfY04yPzdNvw5HPu36x0afTMQgugERhhKzpq6GzkR0Y23Ia4TduBuxP4oVxheQGA==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPSA id 4B565180020C;
	Thu, 26 Mar 2026 08:36:33 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Thu, 26 Mar 2026 16:36:17 +0800
Subject: [PATCH v2 1/5] mm/vmscan: track reclaimed pages in reclaim_stat
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-batch-tlb-flush-v2-1-403e523325c4@icloud.com>
References: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
In-Reply-To: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514187; l=4784;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=L4RSnGOlWbx1ob39I2cW9qTJxKxYSjJYIPZI0IE6F+E=;
 b=2UV1ap/2XGBFOjlcc27PyZc1fCg3+tnRXSu6BT6jv0K3cIvJ26xjERomAh6jkgpWLeAH1rLK0
 ySUc5HwZkDZDb6cRQcK74iUfnSbKqi3c2pFBSt+jf4wYfmgY2Kn6VGi
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: rKqbL-ccvg4837RxPW9bvsrkbaBUYOvm
X-Authority-Info-Out: v=2.4 cv=SONPlevH c=1 sm=1 tr=0 ts=69c4f018
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=_Dbb_MnoW-ofl-KRMSEA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfX9KnOKacCtdnj
 kuHp4ES2ft9H0ny5hcWJTUqgzRxXQ4Hcud1TTC2qe5eenz0nK/vy4xtjtZUNxNoAsnK9Lybsj9y
 UVexacLPeeuzFNen0DU+ZUMLnMzNpLXVk8yRejr3FDOnq2WfLdn7SRy1Te0GqNeFFbb3xa1krum
 0Xh3AZKgc24e6Zbo5QjRkvanSOWHWbiUx5h0cd/DV1L4abYbRmDZ3gw00rJSQBL9h4iue/XdglK
 k4o5OHSpk6hrYgJcU1hSfj2LZi9YW1WlYRlmNm6A8NASMbAQ3L5wdVrj2rXrBhFI5IeCqDPwFOe
 jamXbCYEUyefgQh6bMpWatOtP7+jpVe1joFoAkx32ePhe2DivtW24ih4RgRzCM=
X-Proofpoint-ORIG-GUID: rKqbL-ccvg4837RxPW9bvsrkbaBUYOvm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 malwarescore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603260062
X-Rspamd-Queue-Id: 892821C0005
X-Stat-Signature: dfxuca4zfkfn3wmxcpy6sexxre1frmgg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774514202-916013
X-HE-Meta: U2FsdGVkX193RjALN1jElkcv67wx240v3ND+LMLPEEt2ZTmCH9pSuH9hEU77STr0IR68B72zjVV6g4itOOAYJb7I/fAqqDStm/3YrupfPMuuebq0rh7akLDPaLdo/AqhWZDFHv2hp1nI8E7pdOJ/1Mnxd/XS+kZfYDniUvUlJaAgEdC54KKvTz5O+/5JLpcg3QVCogINz4JIlQdZvCWaVk9D26mE7YDbMLlcnJGrnKwZMLdHsOnD5JKSPV29ua9e9ReFtlk19+02bM1zZ8eADFMivrDFa4TNO5o5OlGlStjUkclQiB9zeDqvTzELpbG9+NBpAugK4GxKTWQzZRKa1U0zbpPkVKiz+5Ml4jP2QpQEsKPGJpEqkL6KvHI6TcqfNeEMqf/lWVsm25YDHLbojuuZKt811Eb1nsDvjBN4yJIhertxqGhuu5BxAlp+DYywbIxPA0hgMVKbYFq54H5nGit+6aPhd5P1+tCw4t0rPnsZeSp1A0llk0zCzXkjhfwwTyIo4ZVqPgrxhELSkW9g5bsn32foO0uhU96nGTmd73VyWCJ05eSqXOKja1zvoTAxtfXetOfpxp37W9ysxGDAa/F4UsnjCb98Jch2GU7DSnnBfB/yj5KFiQ7s3EBkL2JEzePTylIlRkYa5B7QFiJjoW4i1Yq6xhvrN27SeyOI2Ot5/esl/Q1v7mhI5CmyWfr3ryhdb6ZaRFW7O/OIBHXbyMk7jBbDg9JY5aKHreyU+CsPCbYglnN3gzUUX8SrMqysR2bqYairCcnbHw7M/edN7kpF/QFKdy7YYmL9U5hEqpTFhW+uNUy4PMN2vHwp1HQtHfO6JDhsaGb+727naABufS/gPv5JOSUhe/8D7EFZ/frAzQRUcPdjlBX9uHovmoNPYkGrRe3kOeCrPjuSpKRTcYH7DQ3R1hw693pTRPRLe8WezWESxBFHuzPsuQz4rsJ0+qTYTRNj5xEChLEIwxc
 66fUocQI
 M/Y3zvTu/XRtbiisdlqCz/DP5yLyTOivAKtx4YkNUpglKiV6e/dcHaJM5oOIm89Y0OQGCuSg0mw/lck3svFFeoHJxKF5ThH5EOZ2jI01hhFdEaLZUpx00p5puXELUUgcc4rpHIajT3nORa4fXNMdIcJzD1Ug/GdZuhFF66LpVor8O8wAQrFe2g0Yry/ZTUaFC3VgME013DGrUUrNCiRytFdMAZwKPfrtmGhUDQ/9UYkfeWyFNFQv/7w44v+Wh6xEnXY0eBEkVyQsL8mWs8RFwLjDjvm3hBZXdPqyyuO0AZIuRn2IzNoF1sHjbW/S5PTgNHb7/vSYyFBnQyOR8rhzLPPKBNd+k7iDE+rJUfO6z6G7lkAkswurs9ufPYHx/QHakjUcMaPXMalOOu2BbgBGacpjWz8DUc1kNJ+j+KJDxD0n/FnLXUHUnPvUlkXSlz0IYdCLcUMybhf5cA71l1E+ku2IDrxgV41jxWxbo
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


