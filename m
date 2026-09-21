Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E887C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2406B00D5; Mon, 21 Sep 2026 11:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9046B00D7; Mon, 21 Sep 2026 11:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7067B6B00D9; Mon, 21 Sep 2026 11:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 523076B00D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:16:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEF651C1129
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:16:02 +0000 (UTC)
X-FDA: 85238119764.06.BCC77F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E53940007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:16:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JXmy9QfE;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKpBenybAt2skpTkLkXIqtzA/nUfxrfvFxG/+NAT6QA=;
	b=XU5yg/xjmomy325o1+V9YgBZbjCpfEFNPdW1hZoNCvcrWjIZ3iaJs5eUbaUBxjKTu87cWS
	OR/iZhNswxmtSFLWi57J8DQPqJdTQYxqhAVqrpi/oCi8hks3NxtdsI3hAzzAF3FHljXUUZ
	5ArF+rwSxVVZ9Av6gFPWkU1Z/xjXmrc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JXmy9QfE;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003761;
	b=RfCiF8mcHLIuLrhGNKpdnG3XUiAZiAHMf39dk28MsVpQvDCJTvoz96niyiLUezhV49Bv3n
	39PXtQCyVSN6pEZj/iWFiyU1dF/U6FUnDSd4Hl7tK5wlueRu9Xx7RkHrbe/KCmd9cVZxdM
	ExZSUznUnPu1OuZ+gI3PPrsdsgi7vJY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 733D243FE4;
	Mon, 21 Sep 2026 15:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26091F000FF;
	Mon, 21 Sep 2026 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003760;
	bh=bKpBenybAt2skpTkLkXIqtzA/nUfxrfvFxG/+NAT6QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXmy9QfEcwYPI/tNPSUfWcmZK2OvPO0BNfURuaKxF5h9YIMhrUnMM4vFj2sX8VqMN
	 D9YZ9RJFpym5NVLBBcdn7kAsi+ADbCPpi7uonOTui1DTnYbmy+cqcXjJeimWJk8n4I
	 Fm4ss6Uq93K1DV+3x4UJCvl5SLQQedtrdxOfjywEiKCmVD40efRhUpdnILEpejlViq
	 x0Klihsbkoxo2xySgz7mNWR+GGw1ZXba4InQ1N898lk4kVo81w5jX0rilD6VkoU9LZ
	 00MRa34TAFNihHZJffBuN8dixHOYqHlVPiBiMxHpLbvFZDzCCDTLobN6NDo3W3kxx0
	 B0wHQkbEKRtyg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	Karthikeyan KS <karthiproffesional@gmail.com>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH 3/4] mm/damon: fix typos in comments
Date: Mon, 21 Sep 2026 08:15:45 -0700
Message-ID: <20260921151547.78472-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921151547.78472-1-sj@kernel.org>
References: <20260921151547.78472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E53940007
X-Stat-Signature: awznkwrwfdj6pwsqptemwrysan7cc7xk
X-Rspam-User: 
X-HE-Tag: 1790003760-635164
X-HE-Meta: U2FsdGVkX19VGu1bILG3aZhEdu3L3+EXUqZZ1FYjfmoCRCXrxn1tY1VsX4J3kK77HdY63xPzttrdFqN9JBhlfbNS0MszKjNe41PlcoFiEyfhxSJcgz3bwIkf2Fvgntb18lKMeuvcxbmmX9s1wFAvapsSz/lZaEuZY/vysMI0jBnri3uSMVpmSEksF0j3YzCiAi/9yx75NR1BaycsSn2UBkLip3SXPe0vSkbqdlbvDhurHvGZyakAmDYZjoyWArvAHPsRIYBOv6Za1S9Swvyp3nzXpS5RQ9Yb32xcTrYOXcr7M7Th4+CEUkqZ4lkFd90feeMSGUV/2dBZm8PQqNPYfG3QqdNVGaQVhRA8DxI4vlMmeFGHI+n2Vx1VAhoEJKc/AVayq6p07UYWiGP2rId8SWw397ak+ksfKmhHbT1dIB04En36zXjXUitjrhDE67dKDnRI1liacsqpV99uBbS5wPtyOUWsaNsJ03r9834MKh8+XBv42ZIIG05jbtJoRIORZwJGFXzVx9a7Yk0eDXrRh70qvl1k4Yc8vymQaiZ50TgsmkQ8lbMxg3sCLaEjKZyIWNcyLCtCiFy4Hq2m6eY34EWcocD13nH3L29XHIqu49FfCF8jF+w74Fs0/xu+N6dbTAGdkW2d4p7DiuxPPQEPZqaqSs3SdJMntn0Do31p6IqBhzUzHrXRlZjAhMUHrSpTi328jZ5DAegqEPKqWEi09QeMO7BgZ90OTGf1zL0+mMlffJD4nS1IethksIl23rBt1BIXBmOM78+mgpFKT2MAb7IKnLt8ig/3hxqS0WR4xemFLegUvaPVDMwDC9nSc4K4P0V7zWDiMSw5bk+TZkPNiAublioCKRil6MKP8WYrWPof0sy27LTCTbynwaex+SiOBmDvUqTaBIcHq4X8rGl/IKFCJ9V8OAHJPQekdoXqOAYREg5SJ8MCuRWJFV+roLJmS38AjIEoFfC4DcD8xde
 FT/McfnC
 j7JYcEtQOuht81IoshabMJyIrq/qPCNSnisRhT8Oyg5M+ktuBnXItvEA4X7KKHRHFMkAFuFpv4Xjc1NYfD1U/3bKDZpXD25y1Kiq0Q8CnJveI/mMyHCiTSCsxPR+3iFtnAYgCQRJ+JpKfsVWrvsuTV64t4a2uygXjmlFEYgUy5fJ2drH/V+FopGdULaPB+kRrIWjnnvTteirAr+zm9XpFrpj5HJl0q4dI8UXzDZNoK1totwLP4Q9wIULYfxOTdWMrTj0z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>

Correct spelling mistakes. No functional changes.

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260915102746.647-1-adrianhuang0701@gmail.com
- Collect R-b: from Zenghui and SJ.
- Rebase to the latest mm-new.

 mm/damon/core.c     | 6 +++---
 mm/damon/lru_sort.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 98c767b9e6ef..0aa5d0ea8ebc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2486,7 +2486,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow, and return true.  The
+ * area that not charged in the previous charge window, and return true.  The
  * caller can see the second one on the next iteration of the region walk.
  * Note that this means the caller should use damon_for_each_region() instead
  * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
@@ -2652,7 +2652,7 @@ static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
  * This function is called when kdamond finished applying the action of a DAMOS
  * scheme to all regions that eligible for the given &damos->apply_interval_us.
  * If every scheme of @ctx including @s now finished walking for at least one
- * &damos->apply_interval_us, this function makrs the handling of the given
+ * &damos->apply_interval_us, this function marks the handling of the given
  * DAMOS walk request is done, so that damos_walk() can wake up and return.
  */
 static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
@@ -4177,7 +4177,7 @@ static bool damon_find_system_rams_range(unsigned long *start,
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds 'System
  * RAM' resources and sets the region to cover all the resource.  In the latter
- * case, this function saves the start and the end addresseses of the first and
+ * case, this function saves the start and the end addresses of the first and
  * the last resources in @start and @end, respectively.
  *
  * Return: 0 on success, negative error code otherwise.
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index ad8e86dd3a93..273efa3c913e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -260,7 +260,7 @@ static int damon_lru_sort_add_filters(struct damos *hot_scheme,
 		return -ENOMEM;
 	damos_add_filter(hot_scheme, filter);
 
-	/* disabllow de-prioritizing young pages */
+	/* disallow de-prioritizing young pages */
 	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true, false);
 	if (!filter)
 		return -ENOMEM;
-- 
2.47.3

