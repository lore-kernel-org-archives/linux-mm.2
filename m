Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A4DC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9535E6B0095; Tue,  1 Sep 2026 19:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92BA16B0096; Tue,  1 Sep 2026 19:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841086B0098; Tue,  1 Sep 2026 19:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65AF66B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:24:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7B01C0524
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:38 +0000 (UTC)
X-FDA: 85166775036.18.B6CD38B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C87D80002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXAQ3QSm;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305077;
	b=BjYwimfOb/JOSHC8hsUppwfi9SiY4HKSFHJEF8nApyuLqyI62+mPf2i6I+4+ZQaVlN3BoW
	gmgSidv+VBJRRjSkufeAlSeOTWP7L1ueyl/4HXeqVW3odew/Xnhw2zZ67kN0cwsOArIxwf
	c1m4z/3LJfj+PhDO+8IV6+zvGWBhEEQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXAQ3QSm;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mrvoCwf3JhHo6/B0HvRbUVwX76oJvSOJSq8DmmzItY=;
	b=Glx0KbU7hDkrwF0MuQQfL+2ie0cT8Wu755UW1MYnPq9He17NscD32SXVReljJIrFVFSvDY
	6Rs9E14N8gAgVyatg75f77pa5v91ICx0ufHeY7a7DN3CawsiWTB4vr5s/HRZy1J0hQPfhR
	IiJovTIy2QaYvZv3TUjRqeFjNeMUh7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D6AB43EDD;
	Tue,  1 Sep 2026 23:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A611F000E9;
	Tue,  1 Sep 2026 23:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305076;
	bh=3mrvoCwf3JhHo6/B0HvRbUVwX76oJvSOJSq8DmmzItY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXAQ3QSmW1kL0/7w7FaPW8RnsDkCuqPXbtBoqB0y2WXus7vg1zrqEl/L0Q9l4bFNl
	 ri6q7uhCpuIhvRBdIjis6rb2sE9cN1rdK//O9NnxouQgBFBkHYVcliV0NisEKwbKed
	 O6H0SpjWaCY9ptsqg0RI9Hgkpm3K0n/9OjVK7PigCLKdp0HbR3EtbEjHziSrN9wFqb
	 YahoOIrYqne51/guURoNXtmcDMcZ/7j++r1/CM3q8wHS+CU9JTsWkCrbH69xgLaWVq
	 v5TROxmYjEv9+W9pIxioG92t0dslVeEDrNNUXZ4ibzKWFR2n1zTLfcWd3SUJpMVblx
	 C25N/pdk72h3g==
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH v3 2/7] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Wed,  2 Sep 2026 07:24:16 +0800
Message-Id: <20260901232421.40157-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260901232421.40157-1-baohua@kernel.org>
References: <20260901232421.40157-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cbymgndg6yx4e3dk1bg8jbpa7xkckbod
X-Rspamd-Queue-Id: 4C87D80002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788305077-835864
X-HE-Meta: U2FsdGVkX1/9i+UOwStkPAPTBhQIOva45GEI7H+9eL8iQVT0apwzfoNaOa6iw13Gp6a7t0KqegOjs4ptNb704Nj1beHc8P5brpZWrafp2KoLNOnSA5aW830ehQTUbHERnbDrQYsIigUJTVa4BrasH7Z4H3F1lafg7Dp65Wi+WlsRI1r6iRnwN1Y/NyswiIoQnN+f1oy5ctfPZpozVB+ADDLY6kK7VnNMyEYuftj2yJA0mhBr8B5t/t64p+0suFr1/5f3hn9wh7cpEc6ebV+VxdLvPgnoFcKGPb5+WlH/Q9LOrOVeVLWHaJ05ca31cbbAnBop468z07a3/l0S3ys3SaMghI4wOMpy/ue5+j8JoRg2jm1pOhmiKfWhpCrw3DW8HMUwK/jQQeRIkmI3/mf1vf3KZtb7vdgxzRAf/FMzl/mtZ4iGf76jRyXWjhxb0kggvq5Hler8dElxFhrkOCX9LwnYYgsle2IF3uNmgk4ou1CmjpJYgwWcimgvKy2+wELt4sBMYaYweiiMHo3CQOniCxx5ibhkEChrFAcfbSlSlU/RNI3K0V0ue7DabHiWer8/Nx3KIyeZeeqy2SPaH76sWGSGfiZMBOAAYiUGtFsUCaBJbNwGW9Mb4ZjxOXJPqLa6oWlyINwxV3/nfmPZZYxntf3HKZqS5qVzrd6Qdku0m9ONvoPenNtMhRCECQ0dTtOKYC4v8APIU2F3Fk98JZ+n3RX0ZyFXJH/H2ZzKM14nKFBpezH0sN0TpVtY5Hf9OHeRmxy0rSRuBsJqdUSX3KjAFLIs5xJtlHp/6x2wZ758aig/U7lC7L7TuFM5EFodJuXceByqP0DFaz4YsAtdfgKOIjreY8IFSgdtGp+ck5ExABaydFThuN5HnPBm0nMPrr/s+PxhkEeZk9OyYe8Cp0N6pWRczngUPGIewdylYM5rTGYgS73jU417PvInJdZ2cZ/EJq0ZgwPiiJpEAVWTUPD
 zdpK63f8
 LxxQCxlTDO5ClU8Rm8ox4VWhtIerf74I1NTqoosmOVzKSk5LL2FVdZd/1ZltUXJaeKR72MvtaLPYg6FElaJofEhWBSOVHL9yRXaYdnxy/f/t757oveazb9tpbPW4wmC1jxD4e6zAup3ikW55wfXsvTCWopXHoLptbWqiHrw2+fbb+mwBj9VaNMWPa5it04/2AqonYbL6O0wrxJ3mfoEDK9r2fiKMyr8Pw4vwYELKFLp0A7FZQ3Tcb30qdbjhhp4US29xRItCI8AM/sPCFMJUJyKyRTX5csDnzjRwbu5LIBg6AsyfNCy8bV2AzBJgPHbD1yBxxK+W/aTo71fL0yNevIRsFbzW9R8glPb6C1msABXqsu7Emsjiwcp4jc2KfG1516hDy
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
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 54bce2f608ef..27494505cecc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3918,6 +3918,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int target_gen = (old_gen + 1) % MAX_NR_GENS;
 
 	/* For file type, skip the check if swappiness is anon only */
 	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
@@ -3927,35 +3928,47 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	if (!type && !swappiness)
 		goto done;
 
+	VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
+	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) !=
+			lru_gen_is_active(lruvec, target_gen));
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		long delta = 0;
 
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


