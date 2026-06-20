Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446A9CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43486B00A3; Sat, 20 Jun 2026 13:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AD76B00A4; Sat, 20 Jun 2026 13:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A313C6B00A5; Sat, 20 Jun 2026 13:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65E786B00A3
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA10C1C12D7
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:13 +0000 (UTC)
X-FDA: 84900961866.20.C7304EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 368FD1C000A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EoWhKPDO;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E40P358cYrxpYfQ/+KC5PiFZHdq8eKTdsuOzYb/xPVY=;
	b=xhXVzHXXlGPO/99ngyGOpTDZzH5mUoHFIKkf7fbaUVNkQ4ApZckRLEKI9vTjpRKoEdxrwI
	sWIc+R97mwL/xxtImZgCKlz6OjbdW5JZqcK7J/B0+vkB6wyW7BLoLYJAeRNDNlrWU8uljb
	UkF1wLGfxKKd6v+yDpjqfIySlqVFEHk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976192;
	b=vY+5KDiC2jbsw/hFwW7cuLAGZhduqjF5KwAa11vFeE2aKnvlOcpxnG5Ag/JzA0UF+fvtMG
	rDCtDRJItExRjskqGGEVBfb2R52W2ivsOC+XHFhq/v/hjD+N1DKjlcIjFZoMJRHVd6RpQY
	I/+TCaAHSD6kC5pcrvs/9RRXBPOBC2k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EoWhKPDO;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B39444503;
	Sat, 20 Jun 2026 17:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BE81F00A3A;
	Sat, 20 Jun 2026 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976191;
	bh=E40P358cYrxpYfQ/+KC5PiFZHdq8eKTdsuOzYb/xPVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoWhKPDObMVUxx7K89FLrUtlZYwPL/utX18TjsuF0ZzniJ5Ct4iTEFlGy5pr5MPnl
	 y6aTbVwIJtyzjFDlYCaBqqs6Em5VnLIcl4gcyz1Ss1YA5zTDA0pDkVKIf041eUaJJ3
	 7YFJNM0r7Uww7y9mnPnMLpPXYv16Si+t2mMnnDC5shMEMJaCwDplAdTT1zpYJekmX6
	 m8vmTeUyE2YSeqivZbkIMV3XNneYX61zlYJ+bz42qjt8RXNhUyNK1Yl1sWTq0WHk1P
	 cuLKMT5NHP7WQP0OfdqCmwCfk3xj9d/QBxyqN2FDggFAf6WgSFcACl9yjDGgTrp9WY
	 ghvM94y6jC56Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 13/13] mm/damon: remove damon_region->nr_accesses_bp
Date: Sat, 20 Jun 2026 10:22:43 -0700
Message-ID: <20260620172244.90953-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 368FD1C000A
X-Stat-Signature: 1cferpnf8mc468as8w699yaog4fwu8tp
X-HE-Tag: 1781976192-137530
X-HE-Meta: U2FsdGVkX19IyqUsEFPPF6+AUe67rNND47ed07kbHvFjQL5tm2S6P1I0AZGHWECdzRy4hkbIOE8e2Mzqrv2mkF+0hjqioNpxaU2+eMAW70H66iaWKRNsa9C8qUHIinLmh2bl7c12J2D32oGrIHo2ZJfyZLLQl5WnYrH+/02VfON5QTNiEUXN2ywUvxWDB9cnempi2qTJ3i0QdUVO8TTCaf/AnjAOD4G4PLP4WOScrko2Go9UpvKeI+O3GHCjraNgg7LGhIo30TwwlK9haBH+7vnqgyz7Z2JVJpD9q0atw7S6sDzRmSnf4wszD2r9cEsE/yiA45o6YA2vE67z/JmYsEH62vn+ZgczQiY6pkAlQrrb+ddfZW8ICGk+lE3XCvKNNPdf8h/tlSNSIvEeZl43GyaxEQ8e3fIpfg7pYdBi+psULkL1WkXYVjai+H4Q21GsGf6GSH5AHE6FXS6XjjukUwGR0vSb+SCEBq6xM0uVQcuWQYPKyLKa/FK+MoR4jQbVSxTZlMnT86iqEhaajZxoCe9mWMrfI9V5DTYO6kVsk/ChkvRC9m0PNffS9weVpSEuHWnnswIEdORf+ILc6J73islp/0mJftB2yUSydZm9bNSmcD2IOqHAiw7guky5xi/WVOpMlyjcG3AZNidV09ApH7mAWWOU3vL4peEJOgjYKHl87CmGQVnTDta5QUY/OXspBA+5P6AsLJbUv0rcJkTXniWJDXXyglPfcwbbrPi2TuUJhO8J1O9d4Pt8FfubwddTzhKByPtsmezEm5G1st88YBdZt3KXttvrRP6t+XNtu4UbuvGJCOhTIqbhx54CLz9xw5T5afClfVezqF22cjczASvtIkBU/IDXv2tHOn2vM6ImbIOQyBsH9nsRrdFX1UYu4CF0R9q2T5HEyCx2x4twlbvtsz1gtKPax49ES75gz9QH/3nDCFuuTSF/jrWzKB3XIaKOMXGq3mSS91DlBlX
 e1UZ294b
 bqVQVAkgKeYSugtjbWznh/TDW44zYGG/JfkqRUc1rNvQvUuyPMRxryLXonsW9xBwnrNFrwrA7d77IeZ+R35TEJ9jFoElL1bVtsWOXXWnbK2r4oirTTrX5vudmbpcJ7ZC8ucw4lDfu8ZpblLmj0z+OXZf0NoozNFUfbq0kO+QGnHSuehsIy0pEo+2rmXV29vCo1ro0z2PHjIr4DVEtlT5Mn/6lZ21v21ZLrwxHier/pc8uTjpGj/8YDqRbm7/98H9Cj1Oic1D40wAGoG9Vbr3eBcetxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No code touches damon_region->nr_accesses_bp field.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ----------
 mm/damon/core.c       |  3 +--
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 55a743d99b567..90d2910b3217a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -47,8 +47,6 @@ struct damon_size_range {
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
- * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
- *			each sampling interval.
  * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
@@ -61,13 +59,6 @@ struct damon_size_range {
  * not be done with direct access but with the helper function,
  * damon_update_region_access_rate().
  *
- * @nr_accesses_bp is another representation of @nr_accesses in basis point
- * (1 in 10,000) that updated for every &damon_attrs->sample_interval in a
- * manner similar to moving sum.  By the algorithm, this value becomes
- * @nr_accesses * 10000 for every &struct damon_attrs->aggr_interval.  This can
- * be used when the aggregation interval is too huge and therefore cannot wait
- * for it before getting the access monitoring results.
- *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
  * regions are merged into a new region, both @nr_accesses and @age of the new
@@ -77,7 +68,6 @@ struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
-	unsigned int nr_accesses_bp;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index f96f54a7f178a..abccac9e9f9e8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3580,8 +3580,7 @@ static int kdamond_fn(void *data)
 				 * aggregation, and make aggregation
 				 * information reset for all regions.  Then,
 				 * following kdamond_reset_aggregated() call
-				 * will make the region information invalid,
-				 * particularly for ->nr_accesses_bp.
+				 * will make the region information invalid.
 				 *
 				 * Reset ->next_aggregation_sis to avoid that.
 				 * It will anyway correctly updated after this
-- 
2.47.3

