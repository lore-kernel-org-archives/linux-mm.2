Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E95510F3DFA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181996B009E; Sat, 28 Mar 2026 15:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132696B00A0; Sat, 28 Mar 2026 15:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE296B009F; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C05DA6B00A1
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 825F5140239
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
X-FDA: 84596519070.25.32B778E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 75F06C0003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1ch7X1m;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKjLqjI5F0zFoF5bPQgh0Xr15rH8QNESQaeUWTSvx1U=;
	b=ng2bEuRQWU3J+uSoFSAPL/quEE4qt2sdn8ERdNoDBcMPoWpiA5nDkgv2Nj+YbNcuQkvSTK
	0KCQwEfjgpXIFhGjL4Hk3qkXYRdm9LrU5cMIjDxmUw59WeCnLt9R24q1a6YJQDlh/7mAeY
	BEZg9+MZqaJXxVanKbaObwqGm0kw4HA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727553; a=rsa-sha256;
	cv=none;
	b=6net3pAXHKj81eW6Z+5SUOA7J3gUqXACdlHWNivqul7xX3n6BAZ+BrLBJfpOBDJPFwkhHn
	Pe9bFxriECoOA1fpPm1UlVZmOTWufWJC+6qqQ4h64ETnWcumcb2tYlCaj17NTH5RrRLPRB
	E4azJikOgr4g4t+rsmI9SgJ3OQP/wis=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1ch7X1m;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6180445A0;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A0B7C2BCB2;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=Kcj+wVBSDKRPAoZTlEVcVgfXNV9IeRUNYVyk/wgSQrs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=k1ch7X1mb+It4mYbmdply1+nMiadeowZqahxP6gTZfz/We4PjXkf2qMnnQiTdb9xc
	 5CB+nJ6D9IWlY14uc7b124poCdDMa1sn9AbaxxOKrvHkLbVX2CZlwykpVxjBX19SHc
	 PmXNlWvd/LJNhyyfJcjMYH53sTsp9exjZ3Z0bmKMlZMcjPojNFwDZwEWXO8gb39zYM
	 YTwNvKL5+QsJf2ohJIpGfeBFDqmrbwoLLV/pQyjYr9uDD2fZv3/mJaSOv3IA8YHr5g
	 YhuGYh+HQ0P/oILT0okDq/sjp/QGlaUDtC0GJxf7ifqWXsehRclprh8d/Yswg7TsQw
	 Mf5VkaAMoqMnw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7032B10F3DFA;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:31 +0800
Subject: [PATCH v2 05/12] mm/mglru: scan and count the exact number of
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-5-b53a3678513c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=5300;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Chfeg67mZ+HunWCr2QhrTTSvG/K0wkoKuPXlOjYTRSg=;
 b=Ezlxj/mKqH1Rl207cwTO2nDKcU5miZsCt7tpfNHN9Sdncm6boo0rU/A5c/a/LoVajPKUpGdS3
 6pmxRQUIBNODbVXgpF7xrZ7eL/J9eeintIQBlXlOwZRJl24KPFH6njP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 75F06C0003
X-Stat-Signature: ra64fiqfzstw3ibioxqf1y4goepgihab
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774727553-364404
X-HE-Meta: U2FsdGVkX18jc6I/bmr0nk3/nom3r2BHvztIWzfh3kY8wnAUfGhJNrL38phDJ0zCV4MBaPSFkKjiFXUeF52Q+HjfWtkMj5lotZiHiupqqa2VBfgeqwVQMfKJU33+80Dm2V/doTq3klpWO5hEiW1KPLz6CAwIzSg/W5tU4kk7sNK+LUV3Rl0UD2BsL8Jg2USo99VQlcDyK23qUXYGA9s0dWRvxvno4sp5VuEyqf72mOK4IgJGyjfUePb+8t3ciO6TbMV/HL2Vb1khy5EeNdJfNzuW/14XZFm5FbbLLRWzmGc1qj5s3LUKGfBOc9TkX1lo/J009rDSDObXVaqRmn4iCz9iVdbiJToS70d4RlBaCEk5kC8GpFJIJgFzpMQ+Z7pfivdNYmWUBil3NKOjARCWna97jtCV5Vzc/5Cvo0DzwFm+Lm+uT/knqdOXlrKj7LbiwmD5pUGOTg3XwEmjLoemJSKMCwl4+r485EmbvGU5hdiGnvTvK2tNdrNWDzZfNYkKzCBITMrAulkXJnR62pzAA+1abgq8WNd094f3PwtITWuqkZ30/25mJvbbq20ntRsaR2m+NNeD+NXRIH42uftBjwwO7FzgiZUT0TsI/TtuuRb0yTx9Hoh6IqIv2vw0kGiBWN3vWIOb/tJY5oUfwNk9J77PKxn0VzNwTky8dWYjozP30C1AM/6k92VmU3Ts/6Oqsp3IHhbBVcIXL5Tkh+ttcTNh40TTm26BN/30Btw4mz2UmLX4ZsaqGxiOPOmWwSlxeiiKOurG2oTmhZVZdOOj8ceZVEC3fW9i9oW2cERGnG3qBGclkFMC61T+8WcZZk8lltgJ6oZkWPODHo+ikhk8aE+mmHmtM6O3oLkTDgeOBjAwvm5VvUpgbzy40WQ1oM/idX6FcUmojlCUgoUs6y6TGVexw1+hnjkwIByV/iz9pSBAzkhIIlRAG/EOVzWWZmdsPX3jbYKQIPcGzvssHnK
 nYZdCIHH
 9XXqk43twfG2EOvoo+Y1RctHinKIuhhD0M0UKygzesqDqE1JNfffbTx1HECceXiyr5EpwOniHpPzXait5qcYt2aUKZY5YzIHdN7meztDgI2G/AKeo0G5QUa3VCpelg7WWVHRRspPlG6TORyrI2A0ChF5HIQfQeKUZaYE9e8QmxWO3998Oikfxcag6QIXPzL+abdbFuLvXtOl3EElKU7Sr56p9GkhMOK4UuVSjOk4wGqKbKQ3O1BK+YXYiR8Dd4JljYTqkFjVJXhqosigrLzIT0I6yYJVO9Pit/24qvINJpFPMbXjg6+P4URj/m1v3U59zal0Axx/0vSiusqtRb5nDHo791mirxIRlep9GZZXat7TK8eOTM9j6rc/31S8edUV6sZrEqtLpBH99D5jLs1S7UmFqneYL7Sb49DBhaHA6MnjGIUmGKDdPK04Pn3RcxrnqGWbI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Make the scan helpers return the exact number of folios being scanned
or isolated. Since the reclaim loop now has a natural scan budget that
controls the scan progress, returning the scan number directly should
make the scan more accurate and easier to follow.

The number of scanned folios for each iteration is always positive and
larger than 0, unless the reclaim must stop for a forced aging, so
there is no more need for any special handling when there is no
progress made:

- `return isolated || !remaining ? scanned : 0` in scan_folios: both
  the function and the call now just return the exact scan count,
  combined with the scan budget introduced in the previous commit to
  avoid livelock or under scan.

- `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
  scan count was kind of confusing and no longer needed too, as scan
  number will never be zero even if none of the folio in oldest
  generation is isolated.

- `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
  the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
  naturally returns 0 when only two gens remain and breaks the loop.

Also move try_to_inc_min_seq before isolate_folios, so that any empty
gens created by external folio freeing are also skipped.

The scan still stops if there are only two gens left as the scan number
will be zero, this behavior is same as before. This force gen protection
may get removed or softened later to improve the reclaim a bit more.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ab81ffdb241a..c5361efa6776 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4686,7 +4686,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list)
+		       struct list_head *list, int *isolatedp)
 {
 	int i;
 	int gen;
@@ -4756,11 +4756,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4804,33 +4802,36 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  int *type_scanned, struct list_head *list)
+			  struct list_head *list, int *isolated,
+			  int *isolate_type, int *isolate_scanned)
 {
 	int i;
+	int scanned = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
-		int scanned;
+		int type_scan;
 		int tier = get_tier_idx(lruvec, type);
 
-		*type_scanned = type;
+		type_scan = scan_folios(nr_to_scan, lruvec, sc,
+					type, tier, list, isolated);
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
-		if (scanned)
-			return scanned;
+		scanned += type_scan;
+		if (*isolated) {
+			*isolate_type = type;
+			*isolate_scanned = type_scan;
+			break;
+		}
 
 		type = !type;
 	}
 
-	return 0;
+	return scanned;
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
@@ -4838,19 +4839,18 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
-
-	scanned += try_to_inc_min_seq(lruvec, swappiness);
+	try_to_inc_min_seq(lruvec, swappiness);
 
-	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
-		scanned = 0;
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
+				 &list, &isolated, &type, &type_scanned);
 
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
2.53.0



