Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A0C606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PMCDVctK
Received: by kanga.kvack.org (Postfix)
	id 73EB96B05DB; Wed, 11 Nov 2026 18:26:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716366B05DC; Wed, 11 Nov 2026 18:26:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C8D6B05DD; Wed, 11 Nov 2026 18:26:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 318F86B05DB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CE9BA0403
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:35 +0000 (UTC)
X-FDA: 85424424750.07.80BEEF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8AACC1C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMCDVctK;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439593;
	b=sjvaVZjrTq2ACkrnkm9Db2zBCs68P2Sk8qD2PIloBb4VPTZqnkpK9BwP1+VAgPKIOx/5aH
	2KX77ckXYvXRuhd4jWrXz9m76KhcM4zV9o8JpaYZcbE9yTpZ7D0fxbPQJ0wRULNzm13/X3
	/tVibwZUabqQfOCFS2F/7VSD6lyeeWQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMCDVctK;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuTthrTZtfu6mc4h+uORvcmjei37v2/cFoPsDNmHnVU=;
	b=JzSR1P+OygawSnyxjEs1rxMduKKOJcU4s1mXC6MIoEzxQMNfm5Inj+UgsXvKUJKj+NflJ4
	TDHVthB/zWw3BEZIW3rCAnjWZL6DDHlUvktISEYn4V7uByovv3Xz0avPqlI//zDmcpJ6Uv
	EMecQmrrrG9lGg+G3jVOxvuuvapNz4o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24BC661847;
	Wed, 11 Nov 2026 23:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2885D1F00A05;
	Wed, 11 Nov 2026 23:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439592;
	bh=DuTthrTZtfu6mc4h+uORvcmjei37v2/cFoPsDNmHnVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMCDVctKY3XCbpJ3J/X8Me0MqNgWypCG09I+v5gX6qCzvPKl9mgOvu+TMq2r6hcki
	 Lic53vw5OTkpwMZKJv19FCd6f6EoUBqAi8xcVeodrInm0UcMPtRrkagSfgr1QrBpuv
	 7fNihccUamqND1UXG0+ldLBrRs6D5n8SNfwfH4vLl0Tc2H0xkaH8Jop5UI24SuNCuF
	 ap2KbDjW39PgaNnMccGX+UPhFtJnepP5kyLe4WC/jWYd7ztoL/3L34L/K/iMhEpTYu
	 mAe/+i32ivY7wsIv0QI+Di70XnFCdC1Wx3VeVrLI2wLvGdw41YVd4YGCP7kGDIKvR+
	 4F5avq2KZkEzQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v7 04/16] mm/mglru: lift the forced protection of reclaimer
Date: Thu, 12 Nov 2026 07:25:51 +0800
Message-Id: <20261111232603.9934-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AACC1C0006
X-Stat-Signature: ijzza93nwrf1dx5akgoxuc3rwp1fzurq
X-Rspam-User: 
X-HE-Tag: 1794439593-385317
X-HE-Meta: U2FsdGVkX18zaASWZLjcp4BxzP1aF1YDFg02FbJJc3SOjHznTmdLKqeOwHdBc66o6QVgnnfV7tEZGJEkfdBs9GOJ6VB/4hEU+uDEpiXyDCxD+vwIVeFj5Xa6BvwmLxXB4JOIta4cTcMd2sQpaPbjLikUxp29M3bJDqeNhIjK8DKYnFasNZ/pH6IdV+oU+DV3+OYOKsL3yxb4dOsazxrGV6KaTmlsnkDEmtNShUvFmkj0VCPQwajTGHk4vXS+ZlBMSKo8b8dbGe9zOVI8bku6ywc5S8ba8jrYHpO1FCJKMl+Rd98OgHWC1k08d/m/x22cAsBmOWLNb+oe3HE0WZYUmwerKVFm7EBBlONDauZsPOK/OLM/ZddKqMB58313ao+owpbcN7eqEUOgwGFEQB7Of+HCcPCyEhszsz/QDh1tE44QvTsBSBN40luqgtNlsaANDaIyFynvK+FZNfI8rFlK2uqXf/4unn2VervKJpEC8SHSOr9S484VQ8yAwpFGpD+DKHlDIk8nQ+0YPzbAnd/1QmeWZiDhwfC8CoW7eBjzgN/JxEg/AUmwPQzQXHeec8ZhwkW30p+smyX1EIZUIhtjb1hKgFDLZ6RP+fypWfNGKAvoIeGtH8tN9FLkOO2a96VP9J1VoXBnbmH4Bb5y/C5P2WjW5ykZ1xv7ILTREpHfbuslwQ+Hzoa5EcKud8ZSUU8gGZgNKAtBpXb3RkR8iEZTF0z0E3xRKY5aXFPjaLOITRvPZQyXeeDgIeBAyRJeczXREcII5ZGq2LM5z2sMU2jiROV8JEKvfTId4jYeE7VXGxPGh9Vpc7k08tT4fmz0Kh92R9HmRKNEEuxyIm3Xv/WrE3XWP6+eFifrbUXHBIO7/EGwMO9aaFruusUWmghbf9zLdw3rIPDR//LZhROv4XymKMJhb/fBm1y2xjvLdDI026L55fJSFvgMS8MlIzzJrkDFq4GUZwvRNNoMXFTTwmS
 4soRoho9
 d2e5Z8lRfNzSidxZ7Vs2EpYOG1gDfuDS82vecx9NKj5Y7OA8CRbOKg2pQwSl9Nj2uePBvEK/3NXc4SQKtCWEXGVst4fqEti8nkNyKI7JxHDpLfz/VHs9PCJriCVcVrEe3KTrwSs7m7HI4u+RZyCnVVA8ahB8Zzr1uqt0Araj5fEcbohjQwSXT3GTZuuRWX1oTciepsFMp6TLn8U058gpunqZfbKM3kDHl9Id5KRO6fX5UXpGWVbLOruXdSEDh6wyqtFGBHQzK02zyJIdL+IGHdY44jcw5GI2rvz3SlnO/2iAAtQ1ud1uZ1dgpvg3nx/J5gUK2Zw8PCnPRRQ9jCkrgmAFz658VTJumflOgBwFwj2ZwbNjmIu5qSq/NU1YGLZRVPuYU
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 593f407c0668..db0a8a3e8887 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4672,7 +4672,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int min_gen, int tier_idx)
+		       int min_gen, int max_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4689,12 +4689,22 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
@@ -4749,15 +4759,16 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4770,18 +4781,24 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4792,8 +4809,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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


