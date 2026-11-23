Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A22606A691
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XIGC5mS9
Received: by kanga.kvack.org (Postfix)
	id CBEA46B05C1; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96F46B05C3; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62A26B05C2; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9108E6B05C0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DDC04084A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:38 +0000 (UTC)
X-FDA: 85467282516.03.B573117
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02FEF140005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIGC5mS9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460016;
	b=zO5oa81DszAVSPF+Oyfq+uIxF8Gctoj8afL5uM71g57C27Jm3pBcwiTStcFdGi0vp8hcA9
	hm9HAtnP0hcNdNzIbpqamqhntVd4M2lw5yR8t0vheuEuFKqw+8npIaKmKXw786LKBg3xkH
	N4vhWpx0hkJ1Fqv1waeC3RQ4GztORQs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460016;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNY/s9d03b2O9JkaUTE9InrLkFGqrNIrXDiipCDaU1M=;
	b=Qhu2JDxEadSztCQUAM4f9RdmBPNVNxwN3Ity0r7L4nnIIonbYUX70lqttv0sJ3LKATUxXi
	6Z8NfriIh1gim3XXwRTWa7UfrHo33RQWoMpsjp39Cr4msiHFqoTEx66/InZNJaJ2ykKguF
	+/Lm/SCHfj5WKZzsyTxglWjTst4BVGQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIGC5mS9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 419D045A85;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460015;
	b=TaBYPp7HUAcl5F1cxe1mvRCHUDXKPkpvU2xyDrvjgQlLHKkuyfW93/K9PJyplOrjySJ5
	 x77U1b1iReaVztrkMJE4Zt68s7MEDShHItO9D4CTf3Rg8vtygpppT3iW4H+rXjr0G621R
	 +pYmeUeK8TmdZSXpOpmFMT2+YG4nhfMt6Gj+Qeo3W2RBlHg36fKnKotWtvPvcsecyR1FE
	 nyrSDSe4zxyTZBmi9Y3jw8JFOeWGCkj1RFfn9fHBcbat0ira2N4ZggABL+V/T5e/6jVOE
	 053VVg/7oYx6R44s/U2gMxFUvoEGqy57ogKPora3wNJSFdUvDbVz//ZOOVmvmSnYFIg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460015;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RNY/s9d03b2O9JkaUTE9InrLkFGqrNIrXDiipCDaU1M=;
	b=A3Qq/oBeMfzkS/MjsQn27eZzmy2HrWVpXwWH4pyPihi0yevQ3JHN+z8a5pKXCoXLy2jY
	 mCSgguUegttqGrgffM3zsS9uhxPyMVwhWmkLonxpdIBsovJlj92ZNXZEK++fB0GVIllU6
	 cxocQuJkWvUZ+SmFipWyQfuWkXiQ/7X/7rVZJoiVdzjXUkaueXCaHS+RwqdoCIgj/G7QM
	 Ocj0ZwlU+dLg5G2yMA8e8/iQQMrNRwZrAvhA1FkhF3D81vox4VIAWEEBOzpTs7rBEfnTS
	 1XBIXLXk5oJiP1wwUTGaflaKoptVln9fSrUywSNPM+/Z7rtsbg7DCpI75RbNd5uI77A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ACA911F000EE;
	Mon, 23 Nov 2026 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460015;
	bh=RNY/s9d03b2O9JkaUTE9InrLkFGqrNIrXDiipCDaU1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XIGC5mS99HxPgyC26PCZpIlkTSLzQMpVZxoYgNtStpjB8acFHZ4Wb6FzE4d8rrLLt
	 2jWP58i9brqSc0GDyBx6xnpUMV0m4AZxrZGxH8sfPds2eDPoR18kHtbwRyFKBVFrwC
	 DGW5446vf4aHPot1vccx76TlB2bIGBV5sUjQzVEMwmJVlMP0b5STgLt+o43i5ukmh4
	 K9Z5HMx8HZdjPL8kNf73om+QDzn/IkijQlmG9KeFpm6UMktohE7YGR6ybUQzV7sWCt
	 cXYOPPVaZQU8bRU4e9LwuvxHP/7RDKvIl+QL9hhXdorPH+AP/0yHNyoglkS0hg8RFV
	 CA8dTTithUiAA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 28BEF4C64D;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:01 +0800
Subject: [PATCH v6 09/18] mm/mglru: move add/del LRU size accounting out of
 lru_gen_update_size()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-9-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3303;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XjHe+HTYVXiCfy5n6y3gV9Xu+nsGkLXvrSZveSG9Y+A=;
 b=6PcLKWJPkD9Wt9zW/Q9V+XxxJuDjPsiQTYZQZ7sdj63T1Q8ux+NwJLNGLG1Ut3i3fZi9bdzti
 /HiciYRGuqEAXfzhybTHfHBrA7MVjcWL0sl4vcUv4YI6NtgyPflAA1h
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: twbjehbm3bcg5uyd37t1wn5bq8d9o7ta
X-Rspamd-Queue-Id: 02FEF140005
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795460015-711085
X-HE-Meta: U2FsdGVkX19w++0UPY0igLWIQti5l+g45gxa0KB7xMirwHdQ7Pl2GvIFMW+LRlEtFyATllzVygUM2vch/VXNJ18ZJTvUZtBIajJJHFMFlmX4OIQQLCjagoots/sIlI9Wo4IORSkR1bbe9XZowxf+ggb4EMIXYYDkuwCewdfy+16OCSSdSkeiz6szFp05E+Hz0tK+DL8alg9R1jB8BSyc3IVds3BSI4GTWZN41ldVOTnR2TROx0cVrK2ClER/TCbAkdCETOke4jvcQC9ynrUsJ7nabmXP4BF/IYn4JAAuXNi0BgWfSkR5ZwZIwyUenV/bjdTQzJI0guqPKeRIY9kxD9q8yOJViS2sG6utO2FiSZDjsAZJQWxNSIbCMCbm6IHhgGeQjPDBJJwhW9QolawSVPwdsad6bWfUGMXIeynbGF3vW3hiQvl5Z2JXYiwHR0++gVBw8WL/qdio/NHBZ1O1Yzgef5P39OsEFxWt69SQq2Xfp9ORwbJHZbTBpeELHAjc0Z4J+AgNC5/rgAzfpmVuVf1RMuLxUjGSQWjIb7eykUMobUj6rb+dbIG24Mol12SqgcyQgN7Npiur3PT5xaQ/WpOqzn40wapu/qIT/GJp3CvQcjCVA09sbE3FuPx+gnkybfw34N9CEX8YbZp219KbAkDFWFDg8R2oqFOil+eoJ3YRB1CuVBD7eSJSo6ybl/SEraixuQCdmUnClzux7uGs6pvtAAwIlZbqQwehIxaV4mwTO1yFIlmZ/WtS6OLxZDho0uJ/SMY02ff/hLkPrL2ABkR4DX6GYuVzQP393TCuC8RYUpVrvuACGzELJInkgkefFj5cskN78kaQqWhcWGhtC6DUnxsFhM5PwVD4TsgHdNqhcI89//gQeOM54xsozI/nNlZ4BkdmVyh2pXMuvVg/EGClT2Lbaaaib37O8MIWrq9lLYfid669ERj4NRnuJwnzOp9LFkK3PI7qU4t3VmF
 pRy3QcPV
 sNsvZHZZc6DrAeeCn+acfLpTP7erN+NqWbOGFvVfU0H20tD/RZ4yT5LMWuaPsZkEiWSkXh5H/MWqtHcD+LhTdmIK0yFNHx5lto7TqGxv281nvOvHwNuC5hfM0wiJWE/RSF3JEfqeRPFLeqIDWnEJbE4Dg7P6XolN2wzX4QgDF1+QJBMgAZzsWlT1O5sDQjp3nKoiuzGBKHty+TPzRl6FYyMmN5kVEKne8DYM2wa3h3OApmsxSX1uSHVVikjMXUzH/CgjI4XhUdkdElK5D77YoifdUzT9kF0xWA00HrbwR3eVYX7P8wXz0KSk+aNYITV4ed4H52QXP8nZYriYs3BeEXrZSoAO1bLPnGNsdnHPfoz94sDrzpRDN9kIsm6PXQr3xZBaAXKhCLsNyr6JMrZcgU9qZeSWaR2jgFqlfN4F3Mn0yweGHBdJVVnoyAJFDl4UIfQYmefnaw89gqHwc8tTUS8roAR8z1Ojf+XAywEIIpEWPjjhGZxWtMqmIQGO6WsB7Fx4AzuE/EP6pHMSTWUHawbJ112d9NCk9kOKP6qPVMGuORdDROa7MLBx1GAiyni1AZeUjVEOV97a9ZBeHXy7rpOb8F8rh/4cAOe8lg85vfhFoHjthyExlDJ5RbP0u0N4JcobkdIxSHn9jyRLhfXHrEqKUHE8xZYTNjshZyw2uW/EMxeCWiC1VntRsIrwcwXOq6jN4Bb63yxpopzBnPWu3zMP9Z8cpjB0hVNYHM2nCb8qVkW/XmkXkn/oGateyx2c3PFjFP3aELTQfdlEh/YJ2Josc3v87oxb+lfJx034eTbP5s3ZsXWefPdnhR9XayiQFv1SJZLrsuTEeGgE0ZpblPoFgrCkljIfGhuy0+y+2HnFtCUkQeMRw15L9gjFtSHJHXAATQzhT01m4D3aDkwCneuab2xZ0fLx3PI7KUgWKavPm3Pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.  lru_gen_update_size() now only
updates the per-generation counters plus the promotion move; the
addition and deletion active/inactive accounting move to
lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
and can apply the active-window test directly.

The unevictable case is untouched: unevictable folios never enter
lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
before.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 180db43c3a85..b15c3618a1f2 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -322,21 +322,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	if (new_gen >= 0)
 		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
-	/* addition */
-	if (old_gen < 0) {
-		if (lru_gen_is_active(lruvec, new_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, delta);
+	/* return now if not a promotion */
+	if (old_gen < 0 || new_gen < 0)
 		return;
-	}
-
-	/* deletion */
-	if (new_gen < 0) {
-		if (lru_gen_is_active(lruvec, old_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, -delta);
-		return;
-	}
 
 	/* promotion */
 	if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruvec, new_gen)) {
@@ -391,6 +379,8 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
@@ -408,6 +398,10 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, delta);
+
 	/* for folio_rotate_reclaimable() */
 	if (reclaiming)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -432,6 +426,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen = folio_lru_gen(folio);
+	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
 
 	if (gen < 0)
 		return false;
@@ -445,6 +442,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, -delta);
 	list_del(&folio->lru);
 
 	return true;

-- 
2.56.1



