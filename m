Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DCBF44855
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49376B008A; Fri, 10 Apr 2026 08:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9DB6B0092; Fri, 10 Apr 2026 08:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910156B0095; Fri, 10 Apr 2026 08:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8234F6B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:44:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 354D71A053C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:25 +0000 (UTC)
X-FDA: 84642614490.21.74DBB9B
Received: from outbound.st.icloud.com (p-east2-cluster5-host2-snip4-9.eps.apple.com [57.103.79.22])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36160140003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="Bwbh/WpM";
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf23.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.22 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775825063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnHQdlgcOL/4fk6OrbKqPiZnFKcP7FFawnir2OWjlBA=;
	b=JUuPLuhpuYIAiWgqWiavPWzCFoHyow5KYRFpbdklW1+FiJyxGjLaZVzmYE6kSz5Bq4K1ff
	jzzUGXWr90Y0IXOwEi8HrIWBQvFVH096/FuikDCvwO+ihJBMCXNuUWoV2BdIk3ZCoEh5xH
	8kQjaOB/k+WXuuhfNTIbaxz+hsCSwbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775825063; a=rsa-sha256;
	cv=none;
	b=4AGaGVQNAot5Mm4PoT71o6xewA8C+OKaGSGvKPTikK8SEf0B8FkILNKTMS8PnCnSiTlVV2
	HyOl51UMef8dOGmO1qbTrugX2LhFUNm/30Qo3La1vDTmQp60Gq0lIS8dwqymvujOGo4vce
	l4AHK19u6/WrgyC7PEhetMEAvjJ/MLY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="Bwbh/WpM";
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf23.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.22 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id 05F991800370;
	Fri, 10 Apr 2026 12:44:18 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1775825062; x=1778417062; bh=xnHQdlgcOL/4fk6OrbKqPiZnFKcP7FFawnir2OWjlBA=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=Bwbh/WpMXu14l1eAf+6SpysHVgxbbXiWS9bo9Z//gBroQLPS8aTS62h/sarDCcBrJne3AGys38BrvIgbydxiOb7aAfGrnMc3Pt1f44J5pU+PYsfOv9uGD9v9NLwnddhnlCn9S6P1briLTnPwqSM+YrzZwuYztyHI0mqax+JW9Lbjie0AmGQim6Ue+ukaFBOaNF9LY3sfavIsohQ+cpgsvSKsDhjtt/LpXyAnap+qbwEY7t46UfGocrbYKVOzayk74ET/Am9gHS1+Lb2k0GlSMDuAqfOdeYIsPSVJjPOLjtEBkl/SwXwE7OUa/VMpOlYtxRhhOGaXa1HBFvIl5VtqCg==
Received: from [21.6.122.162] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id 1BC7618002D9;
	Fri, 10 Apr 2026 12:44:11 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Fri, 10 Apr 2026 20:43:59 +0800
Subject: [PATCH v3 1/5] mm/vmscan: track reclaimed pages in reclaim_stat
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-batch-tlb-flush-v3-1-ff0b9d3a351a@icloud.com>
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775825044; l=4784;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=L4RSnGOlWbx1ob39I2cW9qTJxKxYSjJYIPZI0IE6F+E=;
 b=gQ9yLWGUxW517zEk1IQvsIrvKwskhHYXuieEWSNucHDUrXNZoYMUsoqxvdu9QG4YJ8utPTMaH
 nxzrqn2oSXJBbe8SlTaqo/SI2qppqjltR2eijdLF2P5/LITQ5LcTV3i
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-ORIG-GUID: vaOzalWNA5dld2tRGp3kg27SWnVGxl2v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExNyBTYWx0ZWRfX2XHa8stvVtpF
 BPoMCkjTdv2QLkEvhwXsB0DDRj3wFo0+/JQa3rO+zlJtjFQMji893q2bvF08omGsoPYMs/f6Jzq
 py0b8c7zAyU9Pu+5xlAWH16EHH8uleRxDlYZpErHCitwpuRajSJG6sPpx5cfSVF+OM2pyp3ff81
 GSOrdhgts6jvbyiHMNWapM8JJELSjGjEBFfyP/AcRj2N6Jkl+SedppnH8mOPfivW+I+Y15kNRFs
 l0eW7MB6l4hIUOY0HKcr9R0CqEL4iRj+LrB7maYqt4dXJ7ehaSEKDI+tLY+oPeKOGP4FUlv9dqK
 vydVwDlqgSSfIref8+Ah2xpOyPcP82NiOgRM7gd2y12DfTLswxZTDODfI3I83c=
X-Authority-Info-Out: v=2.4 cv=V+ZwEOni c=1 sm=1 tr=0 ts=69d8f0a4
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=_Dbb_MnoW-ofl-KRMSEA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-GUID: vaOzalWNA5dld2tRGp3kg27SWnVGxl2v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604100117
X-Rspamd-Queue-Id: 36160140003
X-Stat-Signature: cusmqafh87ckpa3qjcpf8b5ii9on5bur
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775825063-888103
X-HE-Meta: U2FsdGVkX19+mMf4eFDX+zOnO9m2y4/S1OQAu8hGveYQoPHGf4BrU9r/HH7a/mPU1TPlVpuhR9GROg9BGTHAiyjB8N/eb6Pfo8a/Ede8AxFg5o+K7faxSQ2xYdsBFcJ3TA86NmRKJ9fMXK4ksd9vWfZxEDNgHUw+OIgUFB8XAF5wYfRKnWkCA9fxRxMqOGQenkKGiFBVRwQ2daw7AN8I3VALDllN8K8ma78Ii88I9F0vYmlN2DusjmPAzefmFns715zmNaieNZMrZX1Qa1Aka6C8dMYUr7sRz4muFWnlil5E/ndUmnmyNsI6AyfuzC2pHvYry39Lm/cFFpEnXF+5HTXaMGZNiog7rMgUZ8QGrQYFCmd7LbRGctRFCTZiqPTFJ2QCscebCUKfSzSd1UKukqfE5uoQ0h4s2HpkhSdKRMksy3LnH+8Z8HazkfnX/TyBW2A5QoUdgrKKCS7h4RIzde6AKD5Z0FM52VsnKNaMy9HfNR6QnYUkktqIrdyjoV8eLKhEVCdWRVnLsTq7EK9SBceSOGt6X+SqRIR3DOvErU4jaVBXNe/H2eC7Ksj8fesUpkf0sjKhBye/OHMlyXDPWx6CMZFUEy/W37TrnG+kNnpn703maQHOZwszjAJ2ljlXqlIIpjaSwkY46GLu2XJOW86Ra6HYjQEnXkPjRZ1FCderGn6BtwXAh3f2U5AXWoRO7Q4YCViEajMW8Vpl1/iT3a1BlWyIOhOLK0rITTldW97TO7RSd/z55DAGZHYLyk5+SJYKUWzbZmh+Eo09UHZHt5tZjk8rYU+ed3q7Hl7z6O1ZaBJw/c91A+G/j5KIWV+P02/YeugENdvlnUu27rKQNloM/t2+JYM1oDYjf9Mz7a6pQMJ2CbtgXsdBe63x85Ydo+FJ2BYGqmAyqcBqjub4NzzJ9Zhdfq3dFPbXEMe/uev2BKeFQphzmqprRz6gt6UTRb7ByQQSVcWA1dnVkkn
 fgdsHROy
 +BRU3yLgL6JoptUJJrn4A2h+8GMiEyzk12eLwCnZPqawdNCrLhLTkQ6NkrN+UIXcNPyCODkIB8Q+KL+yajg1N7U6Qk9MbXXAGfstrd/ZIpP0FfbInmHKyxuzhgw8uwQB3WYUlaBBk3xtvjdcj0gtx6ByTJTbXXjcfYK19HOg2JF2uIW+lY+Mk/zjg60pWdsniU0ejnU0UMzKoTnfOYEZLFTXeIs03lASUgifCd5rufPo+OzkIeagKlw3W4TgiQAcWOAJNCnDTXobHIKt9QFPJTgVtUal4TKgTSXPUd3GVMPGFrF5894/XHkp3d4JGFHiKVgrizbMMvnq5vv+osph366/XVAHWTn+UsDDSg9jIvTBalV3lCgp0oAFkR+g9yq5eHSZKfoWx0MyWgZwZwDRvkv359Q/ZB3oNPHo3JRbjt2NvisHg74FbtC0L4gAqOwaBJYxIjU6QjL7+fKoEaQ+vVYaAaKy+lcq97ugmRbJOhckXoTqBtG5HOKceLY8AyMpEOLLZtvJIzo/JL3F/JG7FcCBE67CY5hHbRFi5
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


