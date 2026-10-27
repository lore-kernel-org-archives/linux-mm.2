Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F56606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FwXJc2bw
Received: by kanga.kvack.org (Postfix)
	id 940266B05B2; Mon, 26 Oct 2026 23:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917636B05B3; Mon, 26 Oct 2026 23:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809106B05B4; Mon, 26 Oct 2026 23:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7F06B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:54:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C77A3A851C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:54:40 +0000 (UTC)
X-FDA: 85367039520.15.5298242
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 206C61C0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:54:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FwXJc2bw;
	spf=pass (imf18.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793073279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2AEMzOaulMq/RsoCrjXdy/D9LsLssAz3PfPw5l67yFs=;
	b=AILq3Fja6kPCDPRvVtwzXdHlYsblX9YqMed5XJwFQK2tItwQM3MCTGKtxtwgsI1oGdxVkT
	UXnoUq9i5fBe1J14Vr81qtaX6C2V/KmOKJM/SK756he4mzd+LpFqk5qn32qKBC4iNnko29
	eaCXHuB27a0YB7a2LO9EIRn++Inz0ZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793073279;
	b=AGLX+oZ01gjWGdWsLM2NQjxgn5CWukCiBS4ZJRYHSMXBMqjTNa50fyBIccegiJpX4KPPy2
	yyKOaIFa+JvqqznW4YszxWv3M+yWfOK7PO7WBG7BweaxGVdj5unNm1Xw7jP9m/nRNaHTt5
	bxXuF4N4xSis2lj1jnKBGo1KVxy2CGM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FwXJc2bw;
	spf=pass (imf18.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ac7a053626so436817a91.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793073278; x=1793678078; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2AEMzOaulMq/RsoCrjXdy/D9LsLssAz3PfPw5l67yFs=;
        b=FwXJc2bwZUVRuWuCt21oKmLjUM7XBY16FUbz4fE7RbnXGMXcauVlWy45Sl5xeta3Lw
         O+1cFsVUUuVCbTF1PzKhzT4peaReCFkw3uxKmFhfTuNj7r+7f+Pi2Mio2o2XjBKP8XHt
         FDPshfBGN0w3bMN+nE+swHH1DUR/+DjMKXFLjd9EPdWzzj2+ZSJpecHlQRo9PEcfBAc3
         JWcLll49Rzqw7TzWN9QYK0+XAiyOCDDCYSSxMCtrHTuppBfvmyONEY+d3/jZEA9vdmHM
         dp98KRgEerSPtf/GseAsecs8kVRASp/9aD+R9qEFejJneW0QzJcyPVzl94bi1jFKdQ76
         3zGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793073278; x=1793678078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2AEMzOaulMq/RsoCrjXdy/D9LsLssAz3PfPw5l67yFs=;
        b=SfaVbDXmmy9DuS3E3AMfZ793kHDihr3pjRoFFZaVP3IRNBUdU5XrXeX3TBbIkEoEB1
         qUk0Qdy3wsyJVg4Yb0UTN/fzrSzTGs370tlrRQ0zu+55pz+F9BGZO2Ysb8P6zlPPWPHR
         DcYS8xhrK/u1evltFSZ3HsY5NY6iGzpSNfMakssIXjQEjzZ0pITkDPq77MRL/aWtrYEs
         QyoF8TDl50CP4/kh0NlE1ovvUSpboqPhGFiHlxA2ULim4nyW8YmojZnkKTabzy05e127
         gGxouYoWCQmvdvyctSVy6qWcoblhPc2PB4oHt5yLQ+U9zNPbmtDmwC8NHcdZhbvppzqR
         mJsA==
X-Gm-Message-State: AFq9FYL71TL8S0+2VBlqgl7DC8JqUg/sb9KksS/gZof6G4ARVTFNAU+b
	1GfDm6pJONN57QgWN3iPgAwEdOvrjhjh5KBt6k8Hze6wLr4uzCPFgxnIQ2JAbv6f68o=
X-Gm-Gg: AYBFou0+6fFjO/6BR95jdgDWaSJlpf8kQzJJvSpA6hUKg65opq+6V3xjp4wgvoT8Ed4
	0vBzKFGnwUK6dXqMCT3R5vh1F2BqxCg/RvBqxJG1LI9vOo4HdA2wWm3WdMaRaqNHFpgaO3V53Cv
	Vu2/ZSGw1OZwdX4X5zvXY/MoPbrZwb2HDoIGTOKd7ZFaIVqiJERs7Ce5f7mBaDSbJJ0q+Xi4v59
	BRbRYtdYQq2jpOExgA8Ebm8OvAsdzZ/fDOS1glQ+7fXcszuP0qfDxmGziFAEpYydTw6e6yj16og
	N+ANiltXJNQxDTbbFHFzLrorzyPjkDLOqHQBMH9vGOzntgWN5yJJ268CNklms2p+U8RWEQEenqC
	UtCZkql1qWlTUOGpbcjvpBnTCyuQLeb2+u7d+KVf617zseeBFmC3p9Fubl8WQ+L8RAYwOjvmMjQ
	DSpn3uwE62lZBb9LElzs1lcv7emECPsCrv+HUKbAklXuwojPx9+7NJ23Ma2gC3jomzPR1Ib2i0L
	fBSO+JQUF1rYltemNPIpqGhDbKk6Pe7Sqeref/g+tjhd3um
X-Received: by 2002:a17:90b:2d84:b0:3a8:736e:c19b with SMTP id 98e67ed59e1d1-3adeaf9ce48mr12810128a91.4.1793073277737;
        Mon, 26 Oct 2026 20:54:37 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae406153fesm1657632a91.5.2026.10.26.20.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:54:37 -0700 (PDT)
From: Daemyung Kang <charsyam@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	bijantabatab@micron.com,
	ravis.opensrc@micron.com,
	Daemyung Kang <charsyam@gmail.com>
Subject: [PATCH] mm/damon/vaddr: preserve migration weights above UINT_MAX
Date: Tue, 27 Oct 2026 12:54:31 +0900
Message-ID: <20261027035431.1007584-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 206C61C0002
X-Stat-Signature: cbu9nh7xi4bfnrkd7jzyehwcfzf4se35
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793073278-276224
X-HE-Meta: U2FsdGVkX1/lMh5Ki3hBMorbBYynGVlBrt9i/toZ6WMQl7U8lT6MaHGBCXVBPfxfT7oFBraJhmj/zln2Wx/tkkxsITPj3YJRFbKIKCtRohX7X1LRIn2Znk3aOzbClblH+qTuTv5Kol3Ew7Ul0kdfTrDXf+lMk3Ry/LSEv6el12njNZl/8GCLX8gjJ/JWQmlrO/IYos4opCs050mmpPm1tW5w1wfb1G0OZRsuH/xwHTkVjOPsBZa5q5PzdeRJKdePvVls86JG/kMjNC7skl7EsT/HDgj11XC42SBdMnMxx1pQtffbELCgcUYUlDDZlnr1ABMeeFSKvRYt0CuJExYWax81cWpLizn3ADtXMycXEHqVF0JBFk8cW3XRIMBiJmOxRwjIZlA7/zbTNFB8hAU/ZtugZZv+Zt4ySooSn+Z/Du7UOLS49D74Nv37ucka1oNbQ2dSO+MNLMmJDUVrxE8vCibl93mbl689N19M+pW8fgqJJ7XBkZivjROUczuZCRfhaHuxBSMTXo9CGpNolp2asPFbfg4uZqAH8YcD1MRx0sCqSD8Hk9bKg/v8Ysdglhxz4RHz3r2/qf2LfEmQP70uE7P9V6sIpVZ05n2lMQWR3GDXvWvCSOxuRiHK6nLr1sLtl6syBrdu0Lr3JnjzmYdaUt/G6cUDZ1qjhyXgTLzlND1LB1iHb1Cy5KNY+dw0qZQIcwD1KpOHDokk38+ycJJIsQRDtZx41QTMe02GFzvZsghiawMN6JjQnM/2CjFizXBmn2m3NUlLRE54e4o9c5PK6cq1ceG895LXpf9DDgthObwnwU5FkYHklCVjmH15WqquTjBcmhuDM/1uwDqJfmTGgyxDsQrviYb1FG2M3AMRWRTo7plj1VJBUM95OLbG9X+R8yk74icjaNjRDmDCa91rnBpqwofQ/Sa2oyi3x8Ra7ESg6RUOLq60jLo0WPn9iaCz47tAfhlWoQOPVFarXyE
 YphnWuen
 kizS4jbBESH1Xqktgr2pJLUnf+lIMef8aGhk8ipmRNMV9ywccw8KRvaeze8KTrT00GwPr0WoJY20QYWkGsz01q0BNw1vPbjNIaXd6QYFbWvb7Hn0tCJ6MM6dJVISidEH4fNFPRhnMiwqmp2p0bt/cWwmFXYCWbauXpGjANFYOtEASrBcRpRmKlEj003RB91ym9k5EFv+XI50+zrj4aS8eFQ9YAXh9aMukdn1wBmZ3gef1vMjCHiUzhR5tjT35E07b+5KS4g7cV4E954nQZuC/ugqx0KWnpazPNxGzfprNfxjfpBfGKJzvbHqqrMztjwur5Qyunuy5JVtRos5/qeRRYAWLmu8ONnzTNx/RX9xi5cUxUqf8eEwPwOGcwV+FDdfVOslcSpqoYZwcY+pKHr0cBWo/9PnygO1An8rZalVLAaazzy6ahKPvOClESZ5ZRMAIvvHNc11CDg2xHd4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS migration accepts an unsigned int weight for each destination,
but sums the weights into an unsigned int.  If the total wraps to zero,
no folio is migrated.  Other wrapped totals select the wrong node.

Sum weights into a u64 once per migration walk.  Keep the existing
32-bit divisor path for totals up to UINT_MAX and use a 64-bit remainder
for larger totals.  Add KUnit coverage for the actual summing path and
for destination selection at the overflow boundary.

Fixes: 19c1dc15c859 ("mm/damon/vaddr: use damos->migrate_dests in migrate_{hot,cold}")
Signed-off-by: Daemyung Kang <charsyam@gmail.com>
---
 mm/damon/tests/vaddr-kunit.h | 35 +++++++++++++++++++
 mm/damon/vaddr.c             | 65 +++++++++++++++++++++++-------------
 2 files changed, 77 insertions(+), 23 deletions(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index d61b503..f67f1a0 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -266,12 +266,47 @@ static void damon_test_apply_three_regions4(struct kunit *test)
 			new_three_regions, expected, ARRAY_SIZE(expected));
 }
 
+static void damon_test_migrate_dests_idx(struct kunit *test)
+{
+	unsigned int weights[] = { UINT_MAX, 1 };
+	struct damos_migrate_dests dests = {
+		.weight_arr = weights,
+		.nr_dests = ARRAY_SIZE(weights),
+	};
+	u64 total = damos_va_migrate_weight_total(&dests);
+
+	KUNIT_EXPECT_EQ(test, total, (u64)UINT_MAX + 1);
+	KUNIT_EXPECT_EQ(test, damos_va_migrate_dests_idx(&dests, 0, total), 0);
+	KUNIT_EXPECT_EQ(test, damos_va_migrate_dests_idx(&dests,
+			UINT_MAX, total), 1);
+
+	weights[1] = 2;
+	total = damos_va_migrate_weight_total(&dests);
+	KUNIT_EXPECT_EQ(test, total, (u64)UINT_MAX + 2);
+	KUNIT_EXPECT_EQ(test, damos_va_migrate_dests_idx(&dests,
+			UINT_MAX, total), 1);
+
+	weights[0] = 0;
+	weights[1] = 0;
+	total = damos_va_migrate_weight_total(&dests);
+	KUNIT_EXPECT_EQ(test, total, 0ULL);
+	KUNIT_EXPECT_EQ(test, damos_va_migrate_dests_idx(&dests, 0, total), -1);
+
+	weights[0] = 1;
+	weights[1] = 3;
+	total = damos_va_migrate_weight_total(&dests);
+	KUNIT_EXPECT_EQ(test, total, 4ULL);
+	KUNIT_EXPECT_EQ(test, damos_va_migrate_dests_idx(&dests, 1, total), 1);
+	KUNIT_EXPECT_EQ(test, damos_va_migrate_dests_idx(&dests, 4, total), 0);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_three_regions_in_vmas),
 	KUNIT_CASE(damon_test_apply_three_regions1),
 	KUNIT_CASE(damon_test_apply_three_regions2),
 	KUNIT_CASE(damon_test_apply_three_regions3),
 	KUNIT_CASE(damon_test_apply_three_regions4),
+	KUNIT_CASE(damon_test_migrate_dests_idx),
 	{},
 };
 
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d5dde97..279dbc6 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -7,6 +7,7 @@
 
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
+#include <linux/math64.h>
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
@@ -774,8 +775,41 @@ static bool damos_va_filter_out(struct damos *scheme, struct folio *folio,
 struct damos_va_migrate_private {
 	struct list_head *migration_lists;
 	struct damos *scheme;
+	u64 weight_total;
 };
 
+static u64 damos_va_migrate_weight_total(struct damos_migrate_dests *dests)
+{
+	u64 total = 0;
+	size_t i;
+
+	for (i = 0; i < dests->nr_dests; i++)
+		total += dests->weight_arr[i];
+	return total;
+}
+
+static int damos_va_migrate_dests_idx(struct damos_migrate_dests *dests,
+		pgoff_t ilx, u64 weight_total)
+{
+	u64 target;
+	int i;
+
+	if (!weight_total)
+		return -1;
+
+	if (weight_total <= UINT_MAX)
+		target = ilx % (unsigned int)weight_total;
+	else
+		div64_u64_rem(ilx, weight_total, &target);
+
+	for (i = 0; i < dests->nr_dests; i++) {
+		if (target < dests->weight_arr[i])
+			return i;
+		target -= dests->weight_arr[i];
+	}
+	return -1;
+}
+
 /*
  * Place the given folio in the migration_list corresponding to where the folio
  * should be migrated.
@@ -784,13 +818,11 @@ struct damos_va_migrate_private {
  */
 static void damos_va_migrate_dests_add(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr,
-		struct damos_migrate_dests *dests,
-		struct list_head *migration_lists)
+		struct damos_va_migrate_private *priv)
 {
+	struct damos_migrate_dests *dests = &priv->scheme->migrate_dests;
 	pgoff_t ilx;
 	int order;
-	unsigned int target;
-	unsigned int weight_total = 0;
 	int i;
 
 	/*
@@ -806,20 +838,10 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	ilx = vma_start_pgoff(vma) >> order;
 	ilx += linear_page_delta(vma, addr) >> order;
 
-	for (i = 0; i < dests->nr_dests; i++)
-		weight_total += dests->weight_arr[i];
-
-	/* If the total weights are somehow 0, don't migrate at all */
-	if (!weight_total)
+	i = damos_va_migrate_dests_idx(dests, ilx, priv->weight_total);
+	if (i < 0)
 		return;
 
-	target = ilx % weight_total;
-	for (i = 0; i < dests->nr_dests; i++) {
-		if (target < dests->weight_arr[i])
-			break;
-		target -= dests->weight_arr[i];
-	}
-
 	/* If the folio is already in the right node, don't do anything */
 	if (folio_nid(folio) == dests->node_id_arr[i])
 		return;
@@ -829,16 +851,14 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 		return;
 	node_stat_add_folio(folio, NR_ISOLATED_ANON +
 			folio_is_file_lru(folio));
-	list_add(&folio->lru, &migration_lists[i]);
+	list_add(&folio->lru, &priv->migration_lists[i]);
 }
 
 static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
 	struct damos_va_migrate_private *priv = walk->private;
-	struct list_head *migration_lists = priv->migration_lists;
 	struct damos *s = priv->scheme;
-	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte, ptent;
@@ -856,8 +876,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_out;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-				migration_lists);
+		damos_va_migrate_dests_add(folio, walk->vma, addr, priv);
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -881,8 +900,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-				migration_lists);
+		damos_va_migrate_dests_add(folio, walk->vma, addr, priv);
 		page_idx = folio_page_idx(folio, pte_page(ptent));
 		nr = folio_nr_pages(folio) - page_idx;
 	}
@@ -958,6 +976,7 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	use_target_nid = dests->nr_dests == 0;
 	nr_dests = use_target_nid ? 1 : dests->nr_dests;
 	priv.scheme = s;
+	priv.weight_total = damos_va_migrate_weight_total(dests);
 	priv.migration_lists = kmalloc_objs(*priv.migration_lists, nr_dests);
 	if (!priv.migration_lists)
 		return 0;
-- 
2.43.0


