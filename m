Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C748A606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OJ3zIY6W
Received: by kanga.kvack.org (Postfix)
	id E6ADE6B09DB; Thu, 22 Oct 2026 18:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42E66B09DC; Thu, 22 Oct 2026 18:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32486B09DD; Thu, 22 Oct 2026 18:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B339C6B09DB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46C6680123
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:36 +0000 (UTC)
X-FDA: 85351637112.07.7B3B9B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8F67A2000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJ3zIY6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgkFapEPLD9roD9P/vcmIEGrXkWeL1ACQEKipCA2Y9A=;
	b=Opj9JsZya2tc/tpXX1Y+8mBznuIXDPHdOM/5B5JObRAnHMIZcXKAUv9G7eqNT77ABIJd+i
	xMp7UckEpzYqltPiTYSiIq/DFuJVDQIwFpivSOZgYScOoGPxcxR095DxKWsN+FGMF21p0T
	O1tyk2wenKprX+rdiK3mhUPhQsZ2nsk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJ3zIY6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706554;
	b=ZZbDNpSbosTDIaT/vBr+9kzClAvvqvFqL45taAqedtbSbsUhcM6rBMMbv2aLem9xPVLkte
	zp4XHCZqxyEI5PF3HSsiGIgMreVNMpx1c+Xe9ggab+2avtluuoXAwNq7aLu3XUIXjBy67g
	P2vLiuJGLIUqthxCkwwtlhxT+w/iGAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D85BF403E8;
	Thu, 22 Oct 2026 22:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABB61F031E0;
	Thu, 22 Oct 2026 22:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706553;
	bh=MgkFapEPLD9roD9P/vcmIEGrXkWeL1ACQEKipCA2Y9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJ3zIY6Wjh3VYB+tgueOZ6vDCEvwe+ck5yzv/T+zwiDUQUo9drDt1ha4p+5UOlitv
	 xNOQMIdX0n/aKPcaLFEHsGBR6SvrTXmwiZjq6JSrwDc7dHiEhcLRNQYpdk42LDJ5jn
	 OrWfAKFDkhfSjZb+HQl1hxnFD9+GJ/BiofDiuI3rwP2wrKV6lsou9hqVXG+iZJgxYc
	 PI3DrexfD3NjLP28hIENJRuDI5+ji2RoQRedUSs4EyH+frIJjoG5+QNuFmLHS4FESK
	 DdFJHXtpFXMC1xUm7NNoj38MdXmlEQN/VV7bZgU0645Wbf7+Vi/jXYCKNz3eWRULdR
	 XMF6hWvERkCqQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 04/14] mm/mglru: lift the forced protection of reclaimer
Date: Fri, 23 Oct 2026 06:01:53 +0800
Message-Id: <20261022220203.91911-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F67A2000B
X-Stat-Signature: hqqanjn69xd5zi7rpkmk5dkd5ez9nftn
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792706554-742030
X-HE-Meta: U2FsdGVkX1/t9v2sxR6Q/+6dWKVLxTJXiIs22o3x+5+yPfHepjEXyyQ5xvZoa+OGbdzmHjQPlXGJxuUX2yXvhqj+k/fJWWUx/XTbQYiHG8JMjl2mt5QE0PDsFvLYwnlGtaTIVXBCqZRC1Q/Bd/p4HRMS/SGtRb59oa/2hsixAcSodKkD3vTe1tEoqz4b8+ijY/j3VLylUEH4NGjowhd40i7/A7JRbC5s0RkVIOEzIWNTh6iNiN97P9eBGonZ5Hq1znWuDQ84WQl2bHZpNmI/DvpLnygP5mLmDAdhwUqYjuQk/+FZIghPqByCCLvu7DJiEcs06e5Jm3wvvEobOwQ7NSdZeBxZHD8LdKisZVPLqNrQ/Xy2iwjANITCNy20nhMB16E8n88VXwhlQ4DRSHI3JIU9c2kJ1vQAkT/CsilbnFf/Sh3HxWCqtuZ5gpb4IN8hPC0FDsFEkBSMIMoATgkEdwlLlQakjtBm2z1eHuun3TtpmZbL2oBHX+KU/2zaDQK6vDnQB7AqNnez5oSFV68TfzbP/3t3Nl7tUSqNWXKh66zvZn0+nzlTPvKu/2UgG8qG4YXdtAqjrKi7lcxjsHiYxxlieeJGC/F3MV3MSJZYrbMbZ59LaGGbmkfQ83JHsOXB2K3MVxHcYPJD+joh9gdzRk68Ssce3M4+OAWf7ycUWThPNyn4rBKtKP3/rvk/D5+8686arWxEIybdCeeIq9sNWldxSsAUFH31whA/cDnh0iABTZKXFeUO13fYED9aghX8i5WO6qcdm12Sid+mH4Jiir/MEuVZQrmrn6a6v/iMcJi+lyZyLrQKsKLSuumHsbe2p95jBWRE5sUzli7H8CB8d+FDdVdj/m1zDUMV7bs6vGoNfJMJF++ZNIgiYWh0CSws8dZLVAeZR/4ZlpC/acw2kLzgeWO8Mq2b/QS9PTNInOW0cG4X94YFMcogbh2XDAcJpZeCpe0hx6lhXROaRuz
 b7umjjPC
 V/RsEiUAY++r3q/IDRXv1EauX0L+MbUSNA2ao79BoVd2/kF94jeaLd1NNPFRoLEXILSpc7B1Z+7rXFQNbayR98Xf7hzpipp68+LzG6bKXPLAFQAHXjNMw2ucD4+P6kkMeoQNvZm8KeZoT9O8CnSeEMxQV0mO/YHQ8LgXx/33q/WpGyqd4I+YpnJzWbL9GYrLRNpaZKNWsV+xAA83byyjdjnOsQK3TIoDPr7np6vPjhavfBMUkpOS6O+vPLyeeEFojATs4kHKVKQV0EtgNatAW3jns3UOe3fJQtumpfk0n4LDoS/86JGREu9KENeqyhKzwwxMYCat2qlh/jkZbrZE8y+Q5zudLXZKra1HKTVohaarNqVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

When a type is drained down to MIN_NR_GENS gens, the reclaimer will
fail to make any progress on that type without aging.

However aging comes with a cost, and it will take time to finish. Even
if we do aging more proactively, when under great pressure, gens will
still be drained very fast so the new gens produced by aging can't catch
up with the consumption. With MIN_NR_GENS setting blocking the reclaim,
we will run into OOM. This OOM can be reproduced by the previous test
program [1] used for fixing another aging problem [2]. When running in
great pressure, certain workloads will keep seeing premature OOM with
MGLRU, and never see any OOM with classical LRU.

This might get worse if we implement async aging, or avoid hotness
inversion in aging, as they will slow down the aging process even more.

To fix this, let's first drop the get_nr_gens() == MIN_NR_GENS early
return and let the raised-priority scan bound cover max_seq itself.

Mapped folios will still survive as the rmap PTE check will keep them.
Unmapped cache folios may thrashing more when under great pressure,
which is really a problem that should be fixed with refault distance
and frequecy aware promotoin instead [3].

Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [1]
Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/ [2]
Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/ [3]
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d7eb15533de1..2cccaa5dd4e7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4834,7 +4834,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int min_gen, int tier_idx)
+		       int min_gen, int max_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4851,12 +4851,22 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	if (!folio_evictable(folio))
 		return false;
 
-	/* promoted */
+	/* promoted, or moved due to reparenting. */
 	if (gen != min_gen) {
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
 
+	/*
+	 * We are reclaiming the last gen left. Folios in this gen can no
+	 * longer be promoted or protected, so just isolate them. The one
+	 * exception is lru_gen_reparent_memcg(), which is handled above.
+	 */
+	if (min_gen == max_gen) {
+		VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
+		return false;
+	}
+
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
 		gen = folio_inc_gen(lruvec, folio, min_gen);
@@ -4911,15 +4921,16 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct list_head *list, int *isolatedp)
 {
 	int i;
-	int gen;
 	enum node_stat_item item;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
+	int gen, max_gen;
 	unsigned long min_seq;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
@@ -4932,18 +4943,24 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (sc->priority == DEF_PRIORITY)
 		min_seq = lrugen->min_seq[type];
 	else
-		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - MIN_NR_GENS + 1);
-
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
-		return 0;
+		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
 
 	gen = lru_gen_from_seq(min_seq);
+	max_gen = lru_gen_from_seq(max_seq);
+
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
 		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
 		struct list_head *head = &lrugen->folios[gen][type][zone];
 
+		/*
+		 * If there is only one gen left, rotating the unreclaimable
+		 * zone become meaningless, just skip them.
+		 */
+		if (gen == max_gen && zone > sc->reclaim_idx)
+			continue;
+
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
 			int delta = folio_nr_pages(folio);
@@ -4954,8 +4971,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			scanned += delta;
-
-			if (sort_folio(lruvec, folio, sc, gen, tier))
+			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
-- 
2.34.1


