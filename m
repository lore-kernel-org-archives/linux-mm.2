Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC6ECD5BB7
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF5F6B00A5; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BD36B00B3; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7016B00A5; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 362C76B00AA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 031491C07BC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:38 +0000 (UTC)
X-FDA: 84795468198.06.F469AD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 71435120002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMhFBj4Y;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464437; a=rsa-sha256;
	cv=none;
	b=WtLq+6WS7MIy6og+ReM0n6uivkTRUhlbJ1MQAhT7xJuS04CAMVrxvEali8MnWdPUFUHCBG
	+VlYCbdwmriqMDovnocurfQo9pn1BPR7XkTsO1jGz8081Yk+NsPi9rYzWbdgOGzxzNc8bj
	LlUA5YllJRe5VmZa5faDInxk0jHD7pg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMhFBj4Y;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LO1dOAAxPWHeMgWwIocthOccI6BSn+cm+tEw9Hubn0=;
	b=dSj2hTzKoVZ9PqyIBLGWHRs8MICJP+F2C4hbo3Vvdc1m1/hpRSdk+hO9SO57Uo00CjAcsA
	KP9yprqtbas/YOjU58Ik4YJzzzCyVaHJfA6utu9Rvi9rLhVEk/6tOHyijB1r6jbN0RVoNG
	vlYZWh8zFkzyBX+fn97hvGTH8GlwQfk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10C576021A;
	Fri, 22 May 2026 15:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929671F00A3E;
	Fri, 22 May 2026 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464436;
	bh=4LO1dOAAxPWHeMgWwIocthOccI6BSn+cm+tEw9Hubn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMhFBj4YwcQzQqOAhG2y1ylPij+zzBtTMGSPZ1txNtwQGCVsmy7KfxQPvc1HhQBJd
	 t4mYBQYVIigRg+QSpdughFfVQKa4rzbVtxXV3PLrO6LGIRUiCV71u+cXPYgfqSNd5w
	 PweQ65UqGSP7hua7x8uoGRPegNb7zjnjtowOrqzu285Z0tAPBedhi1WQ1ZIOeczkRH
	 7cXmNGVfkgRLWNB10duHaoP84xKxARQ0T6IYk+SHdJK7e54A9svEmdn6tv1Ym/260g
	 S3QkMAHfhySDFEXyt7XgBzhCYtloHJBPfj1rLkil+h4Agwb3tmzw0pZlzZns8gEUWI
	 gRDTLnwDNOeoA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/14] mm/damon/core: hide damon_insert_region()
Date: Fri, 22 May 2026 08:40:17 -0700
Message-ID: <20260522154026.80546-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 71435120002
X-Rspamd-Server: rspam03
X-Stat-Signature: 66r9i7g8h34gysq17ok5g6cne7cpnpdz
X-HE-Tag: 1779464437-233735
X-HE-Meta: U2FsdGVkX19ESj7V/IiIEGMlNO8b/TQSFHEvDxJiDdbuZUIm2Bhio1p3Nd1ZK2Czza2FArOOAoZ5gCGRNNYP0oS1Yv8OyGBrLXTloiWhYPCwY09MhQg2PdPTa9GhEQ1vsjqvkmOtEIC06kLs3Xe0P8mkxsKWhj91QSqdkiJkIEHJR7vPKFP45vUNbXj3l4HEpbe0hZIf0Y8bc1gV+5aLDVcb0hqglpFc2MXbNvqRVaIuFmuvnqmsTk33YMsJWJTRZrWG7bSrpC7efDVOGzI/qARFoC4mvB6Gteu+ukaup6ijKDhm+yaMzLcBp2AEIs+hqlSbDo3NqqKOEBqZrj1M9dpmoayasL/SyEQcAJIqLerH7FpQKaqHissSbdUkt7En9kbVGleChKYS1Ttc4DvuqfHAz1AC92ynC+0mGZAiGUvt4iscCK3Nn6mLROno0SmLj8w5Rrzjgcoogb2Izm33nNMoNiqE4fS7EBdRaX9tfZZVzJj3I+ZBl6PTtS2crbvnOjUhkBR2Ibb5uGT1LPBeriapeNdJ+cSnvA6C7/+m9q+V0+6WKjFNZaEBl4ueAEEVhHMJkuZWlYJ+aFh97xaeoSZzA1dPQGB1gGgitacsWa0XPC6L2fOaUt6p2FVUfXXBBZR9SEdc2g5JtQYHNX5Fi26N+xIrBqQJw8+IoKufaFARWgBTU7+/k+949H3WsX2n77Fb5WiHyKM57JjXBjI1dF+zC8qxNrlLQfPqc6PQLlOhJfSCCpwhSiWMExpJBPbHyi3+/clzKxJ9zlvXP3W/24o3CUDl0WByHqCQ0xhNJuS+v3mTM12G4/Y0rCNQnKjNqMKGJKeo+W9MQJBm/r6aF87mWwXt6dCwo3vw7XvORaCxnKRt+tP/Y3bOWzifl+a6jG65TlD+2eeSw7Hl8t7HPPJW/PflaqOpL1u2IFIe+hg3t8xQqSlDg+Bq69a8ZOgmiUJWgiyiz3HOt+/kbLQ
 FQZJcYF8
 eYTayDBO0ckQ1pvDULahDHyNYnjciyZp/E/EfaOxzxP7w99EUBg9Iv4KdowjRq4nlT0J/1QCDVh63T36ZW4Hi+7SD5jqraVUSJvmx4dMzSCYFu9VjpWmIVp6MbA1fI7336MgnINnHojMXPc91R87zG7Dr9Dfu9aPrjpCtzsT1fBvTHdvCh/BehWlxXqstxRi6FsQKtTKLePQxaBlSDYzvfIB5Pi7NHkl7qCmleWEbHQE19mQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_insert_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 11 -----------
 mm/damon/core.c       | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6ba80dff56946..05682839e17ee 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,17 +1013,6 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-/*
- * Add a region between two other regions
- */
-static inline void damon_insert_region(struct damon_region *r,
-		struct damon_region *prev, struct damon_region *next,
-		struct damon_target *t)
-{
-	__list_add(&r->list, &prev->list, &next->list);
-	t->nr_regions++;
-}
-
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7d1de6ff54eba..53b4bdd27b39d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -256,6 +256,17 @@ static void damon_add_region(struct damon_region *r, struct damon_target *t)
 	t->nr_regions++;
 }
 
+/*
+ * Add a region between two other regions
+ */
+static inline void damon_insert_region(struct damon_region *r,
+		struct damon_region *prev, struct damon_region *next,
+		struct damon_target *t)
+{
+	__list_add(&r->list, &prev->list, &next->list);
+	t->nr_regions++;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_del_region(struct damon_target *t)
 {
-- 
2.47.3

