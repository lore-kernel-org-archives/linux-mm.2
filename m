Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19EADC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BDE6B00C6; Fri, 31 Jul 2026 04:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27616B00C7; Fri, 31 Jul 2026 04:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF1F6B00C8; Fri, 31 Jul 2026 04:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7B366B00C6
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:39:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41086160348
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:19 +0000 (UTC)
X-FDA: 85048422438.03.261CADB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 92AC440009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oB5R0jJl;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvSIyHGbFQ1xRyWKcwWNl/S/3zQ4GNtnzqsqU1kijnI=;
	b=B4RRE80YhFfhODDLq8/pAW6E440WoZXDZgEQbutIeb01ihgOcF6cE1oEyN08h/MeZLXw4G
	D8jSFSy2MiFFbtwXgqZUpID5UnkbDVMFFp4vGDPsNuCpTyC94vn9ptu6GAjZ8FUWLodn+N
	rLKD8yI1rm2ysvYLCotJHxmd9ok0pFc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oB5R0jJl;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487157;
	b=I8ziY93y1z0ayTE3FHLJO+c+Vz2+wkjEGz6DN5xli00ahp0Jncnd3yVzxu4WT17FvfJAEX
	2rM8zz8dFBrnKOrx0X4G2lEMgvlViwj3YZJG0iqzoCXJBvD7zLIu8WpfB28mMbbMcBZfCa
	jz/a9oSe8gyqcQf1lH6YqYP6eRhYlXk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C468043E10;
	Fri, 31 Jul 2026 08:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491851F00ACA;
	Fri, 31 Jul 2026 08:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487156;
	bh=AvSIyHGbFQ1xRyWKcwWNl/S/3zQ4GNtnzqsqU1kijnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oB5R0jJl9rpHQNnSXw+f7IDGKtQYOmfWfdnJgVy38zEsNN8R5zf0M71p8oteLlYZD
	 oMGUm2b87+pPjeAkFYkPI/iRVCG39Kp/tGMwtnxEfBDR0wQ5xyP1tCfuKD6PuASCRc
	 LklG8eCQrx/rPxMfVcHtcUTG2k3fM5uGIKuHE6dWrt0dMMySoVK/SdhpvgTV7xM03M
	 EUJMERFNO4b7wctVfbVTZJEopBnlQIckPKI+yzMdYTczrhplEKDmbnQgVE1D3w+SiR
	 0lL2r4ntXf4c9xn4ORaVdh67DAhwOSpV5/02RmB1ANDVSPqdlQpiJpxsqhHCyfLiH4
	 6qEF87Nx8PhgA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	weixugc@google.com,
	yuanchu@google.com,
	chenridong@xiaomi.com,
	zhangbo56@xiaomi.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 4/6] mm: mglru: improve scan_folios() exhaustion detection
Date: Fri, 31 Jul 2026 16:38:41 +0800
Message-Id: <20260731083843.37811-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260731083843.37811-1-baohua@kernel.org>
References: <20260731083843.37811-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92AC440009
X-Stat-Signature: wykz9fdsftmzskq87kto8y45dw5g5k9u
X-HE-Tag: 1785487157-89387
X-HE-Meta: U2FsdGVkX19DQBelXfVXPwuAzCxlYzW8dtr1CekJSIIzcQj6/fujOnn9z/mUQY1LYV11K5thUoKw4H4K6dzF0U00gO/oD6MffWp3FQ2Oi1sPH+2nb/tLlLWlRPGAOVtZjSlppJRUVysCJH9LVxkpiKnstE8TlQMKu2AebiIa0CgTrN86wOxgUFNBdz51/OQ47E+fA569eK6HmmO6297Wl4u5Fvnfnf+Wfc9p02XHYgj6wGBulMfuJZCt6vZCC+m2OjFB0gQp2Po/MnFSizKsxOUDLOYLDm4Vssxk6/9Vusn1lcytL+hJGjYbYSTUDMJw2+6DgceZnBd94g5oUpDsUxOQtZax+XkoyxEeCl9LZuXvHT0K+z+L8DTD2Pr5RXYGFLCmy7UH4frgE133UFM8WJKUnXp903WTjft2IFdxg+vH/JXbJRcLtBCRrdZqQ+/kavbzH2592ewZKl2G0z/9CDhhCMX3kPaU/pjkL4TkPYlK4RY4vMPMidS9gCZvMBzoThTtxnn6GR6ka4bWt6sxWXRmTs4slo5d8vaYyn4ESmRqM6ng8p/JJdHeoWjoOMGsXVEvbmALZ6mPbNrcEzfBr27T61jCT8gmFe0YpTdtj8v6u3c3ZBSBtP51lHzDCJFfRkuQyhhBLP/n3Z7/WK9PbNtAm0eaxgMFvOcb27HPElFgMfdHA7iV3h27RGVFx3Sl3/8Et8M7kH7m/kjcm3qBibwHIu7X4IeDbWJXfS7XptHBQEToEVIkPDpGZCK8sneZPkgCGujqU9VzTWgNR4AYkoiFtMjWuxrrNf/89DzAGbnPp2jMph6s9Vl2rn4Otod3g8QDQlFYv2VfJv3FpxdJVnCQWJD+hoJQAZv3nrYwPAQmFvtNsdoDuwynu6mv5ai5+9Sbt0nIDplOQiI108o6sfYXcgTUG9Csx2ZwGAnOF/mPPU6W/doJnt4Xb/dNjh11rFt7VVc9WK5YWIWXtSe
 8sswCSSh
 tNkQPN8VYu05qvEkAorTULP2L29LORgFyC+XcDCducaLRt5SDAI28jpUkjRShD53blW0hzq30zkeyN0IgGWAEzYYLowgGU69n/952Odeq6ceImBR1nHTxwU0LA/hc6eV9Z9W7uSccOyJWo0TBsXvX/ZYQOiR+EIwC++VAzSWq85LkT0DhqvIdN16xRzvxD/hPIpEP+tF0h6FONdc0eJo87aLmyWK7LdttwkkFA7zJeGFJ+0as+2T92bHbVrHcBp6RLsM7LcQln3vkeNikImNnzQBiCV4/2so8rkh55Udc8PVxycE4oKke8TjWcmOp5+7UQFmBMz2xrV5desVd1FkmbtPhueF+NWSgnoTcDYMCFc7DqMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 16b475d2ac3c ("mm/mglru: avoid reclaim type fall back when
isolation makes no progress") uses scanned == 0 to determine
whether scan_folios() has exhausted a reclaim type. However,
this is not always sufficient. It is possible for scanned > 0,
while the oldest reclaimable generation is exhausted after the
first scan_folios() call.

Add an exhausted output argument to scan_folios() so it can
explicitly report whether the reclaimable lists for the current
type have been exhausted.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0038f33aa318..2e7fef6975b6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4707,7 +4707,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       bool *exhausted)
 {
 	int i;
 	int gen;
@@ -4723,8 +4724,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
+	if (get_nr_gens(lruvec, type) == MIN_NR_GENS) {
+		*exhausted = true;
 		return 0;
+	}
 
 next_gen:
 	gen = lru_gen_from_seq(min_seq);
@@ -4785,6 +4788,11 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	/*
+	 * This scan exhausted the reclaimable lists before reaching the
+	 * scan target or accumulating enough isolated folios.
+	 */
+	*exhausted = remaining > 0 && isolated < MIN_LRU_BATCH;
 	*isolatedp = isolated;
 	return scanned;
 }
@@ -4842,12 +4850,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool single_type = is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
-	bool tried = false;
+	bool tried = false, exhausted;
 
 retry:
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, list, isolated);
+			      type, tier, list, isolated, &exhausted);
 
 	total_scanned += scanned;
 	if (*isolated) {
@@ -4860,7 +4868,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 * We are running out of the current reclaim type. Fall back to
 	 * the other type if allowed.
 	 */
-	if (!tried && !scanned && !single_type) {
+	if (!tried && exhausted && !single_type) {
 		type = !type;
 		tried = true;
 		goto retry;
-- 
2.34.1


