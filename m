Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CF0C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774E56B00A0; Fri, 21 Aug 2026 06:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C786B00A3; Fri, 21 Aug 2026 06:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A8C6B00A4; Fri, 21 Aug 2026 06:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 466746B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:26:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA7C81C17E0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:24 +0000 (UTC)
X-FDA: 85124897088.16.C053284
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EE8C80009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9lhzXpN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6QovsgX/8e0d2F73NtdKk1ypNzI0fiIVIiWZ5AR6Sk=;
	b=0NQKD+PpkHvK+0h7E0Ocy5fylE7RuHri+7/Oqs79lRk9T0+V81GOYE9et4C22NEsTKllWn
	kOo/dEGj7CuycJyAuQCr+431IO0Azfw14z5PG9I8Q+fX615JQVS1PAzjoiq5BAORFcv0W2
	1y/0+7qm5PkFQoLsnq5oZyQ/NJkIlWk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9lhzXpN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787307983;
	b=vXGKTqJomFD/4u1PDlET6ClnBBihh7VrSbIVX/EMbagmi081o4s18IfcDzGlKsUDaUneuk
	BHEE2AZybjEvrsxU38E3qQt2YieOmI5evBzHkyXyEnxHjekzWQRa9mxcPct/3eSaT9F6q6
	WfhhtDQfUjawVoiovaSZ/a8p8XXPDQ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86B456112D;
	Fri, 21 Aug 2026 10:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4CE1F00A3A;
	Fri, 21 Aug 2026 10:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787307982;
	bh=V6QovsgX/8e0d2F73NtdKk1ypNzI0fiIVIiWZ5AR6Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9lhzXpNhEP9xFzYvNcj0iz1hYBR48fDyI23wrWar1B+UKVpKzY4C1MbOTT0yltZ8
	 w8gWnNgfqIHsKYWPIT+2pLWu8F4y2SDN3fOvyUW6apHrkFJArMFAnyeD5sFCQxHg4c
	 +2OSLcGznOKOqe65NdAzMtVtGALQqh6r6Pt+NT7iEe4IIu4JdV/mP4v3nc/wLuYzre
	 xtqueqW3+evvnLuaNDfkfIfuo8ECe2Gx3OOhgNZ4Y5SUEs9zxveu5JwItjtcKM/4MM
	 OoQ9izQ2AbzEeW1Re/qFby5I5RB1eTnFISjN4xtYbAWRVAqdXQwa9TbFIL8UF12n3K
	 4Fm3+VduFLtcA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH 1/6] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Fri, 21 Aug 2026 18:25:33 +0800
Message-Id: <20260821102538.22642-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260821102538.22642-1-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE8C80009
X-Rspamd-Server: rspam07
X-Stat-Signature: 1z9tnsbtbwaduq3mx1983mpnbfdm15ip
X-HE-Tag: 1787307983-989282
X-HE-Meta: U2FsdGVkX1+UMlWfNc6Q6zEvk/NMd570NhYOswVB7mDSrvX2+8E0tF4dC9U8t0bbyv50/jridPz0eeMygiTvrqxaiT2aXDYLzCp6l3Q++QruLab5uKnuGQpVII807kX2M95BKXHjhQ0D1zU/J+MwWkxPLQSPRJukOZJW+lz0rjSxrgU/29r9do/ryj4moVsHsS8uTTi38KRqdhfDhuKzhD/qycrTtdenpEqJ/sPS9c+tZbCgNRl2rV1H7Go0ACj21xoZBNeuKdozDgGCrPRBsgcbcFpDoQJi1ThXZ6t2gRTkAa5jNyJTzbUiOJ6HSCAWQLkVxafR9ZcxyTB5OG2j1XxnBlh1ZhCZZI4vT2GAGaeCIWj9Wx4itKUFUJe7/pSt1bFXmj4PVPaOpuaq8KNsZjoSVcLL5BXoBKeXLVB01cmy+tnbXlk1vQc7nFcmjMYvbKFRKQ8UTMBHsYBK9Ndm70Y73H1sL0b985Vz+s+AeveGz5wWEGNsZVYW4HMM6f0mvchD4Y7rpEHtQyk8ykKDS8veKc4iF9YwW6ksiytT9+enfNAd7s1Qm8dDahcVvqYE28TzyinqJtRdTXBj67q182xVIsnA/gjNLaeQB3GouTNfacWnVY4rV0hoIKqIj8zh69Fa5k5ON3yfKAyZpmKbQ5BTNpj2/w9lex4wDfQZoAVch4wbLsMm8NKWQKXX51Hff7Zkm2qZedhJlvHV4gQb0+/9MgyoqlFlakreJr7tVsSUhmw7wuKT4hLQU7NHbXVUjdOPDCm3e74s2FxYuWtoNsB0NA66nQot3m1n1Lmazpio4kWdpuhIz7ndK59sgBA+JedXaePGfPzkMhj0AUoX9gzhj2nPrgy8sTk2b301ucFef2ifBHgwQY/uhoFbDd0RgY9OOPOhzDlN1IHLDWAMUJLxSsGubMintM1FXqtsHXirnq/4Hm9FCkzJe2Y23WkotrNciV/oboD4jxMk1+M
 luj9eXpj
 OCTv9HsKOos/sxWE5eqBG2HJYwLF0H6ncD6ptkmyea4owQT8YzuXS6BITpFKII3qBPqLuSXVgX6Vy6PNN4MHtaNW9tTGwJQ/6nVdgExOxXgVYQEVvQACN9GQ8bRcJvaqgVT7ZFJH/Rzd4JWctPq/7h6qwVSjj6urCA15DlJkIdNbPykFhGmmvb1yhVQeL+OnJ48hpG0czxQqWVPt6xHGurd5LLcgfJuSdPudpkAepbI9Afhdg0h6fWlBatcJueuj3pjCkIkYTTZZxai3YG78vtwwZg0twjoWOjkPUPFtfaB5rCghmr725AJ0TbBo5Yrb7Has6NyS1bSADPD1efbPT7QpsIOfO+rMvfZlb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
as it advances generations. Instead, accumulate the size changes
and update lrugen->nr_pages in a batch after scanning the entire
oldest generation, or when the scan stops because remaining reaches
zero.

Since we only move folios from the oldest generation to the second
oldest generation, the active/inactive state cannot change. We can
therefore skip __lru_update_size().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..0d74fc00abd3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3296,20 +3296,21 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	int new_gen;
 
 	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
 
 	do {
 		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
+		if (new_gen >= 0 && new_gen != old_gen) {
+			if (increased)
+				*increased = false;
 			return new_gen;
+		}
 
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
@@ -3317,8 +3318,21 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
-	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+	if (increased)
+		*increased = true;
+	return new_gen;
+}
 
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	bool gen_increased;
+
+	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
+	if (gen_increased)
+		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 	return new_gen;
 }
 
@@ -3904,6 +3918,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int target_gen = (old_gen + 1) % MAX_NR_GENS;
 
 	/* For file type, skip the check if swappiness is anon only */
 	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
@@ -3916,32 +3931,41 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		unsigned long delta = 0;
 
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
+			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
+			bool gen_increased;
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio);
+			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-
+			if (gen_increased)
+				delta += nr_pages;
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
-				int delta = folio_nr_pages(folio);
 
 				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + delta);
+					   lrugen->protected[hist][type][tier] + nr_pages);
 			}
 
 			if (!--remaining)
-				return false;
+				break;
 		}
+		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
+			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
+			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		if (!remaining)
+			return false;
 	}
 done:
 	reset_ctrl_pos(lruvec, type, true);
-- 
2.34.1


