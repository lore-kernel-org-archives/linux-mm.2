Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D3BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DAF6B0099; Wed, 20 May 2026 02:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE126B009E; Wed, 20 May 2026 02:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920A26B009B; Wed, 20 May 2026 02:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE806B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C89940199
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
X-FDA: 84786820944.24.FBAD3F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 91F774000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKNodR2m;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwOzNgtGbmRdNv9xvtTz1sguHFhxD3l9rWcheeXYL1w=;
	b=MSCvq0xwHISkNA6BBerNLD7kl+nf+w9BxSfSS495TVVsK5qFZ9o16qdU9FwQ9fB/clLMci
	kYsj42OgedrSAnBl7PwnyngaJ+9T2LY5GZAKLxzRY1gAcZ84To/jljIPavZZp+AMykUM40
	beEAaxFRz0NqTYUZWdyrRY+TJYZN/d4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258550; a=rsa-sha256;
	cv=none;
	b=3p+91N7ZxivhyLdK2PezBOs7yxLCRJLWDigj6Wvnew2KQQtM7OoIJ8kGUNqrQf3oCRNSsi
	Ucse/wCElWPnJFZsNsq9QrdvOYh22Dky147dAr+QyTLjtR+eGeol+L7TgPb497oofmXjrg
	r93F2J5WQhlqISZBYi+mAn4hLAPzzmo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKNodR2m;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC47544560;
	Wed, 20 May 2026 06:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6F11F00898;
	Wed, 20 May 2026 06:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258549;
	bh=NwOzNgtGbmRdNv9xvtTz1sguHFhxD3l9rWcheeXYL1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKNodR2mXQacDR6VwfgdI84XtuHCPEtfsbxXjj+VOEIJZHsmXqa9fgdgzD9zs3KwY
	 oVQvotEN3KJh1Z7OtyropMGw052yEne4+wEvRukSS//nfcwVwRwg3PDBf6BxyikS3j
	 2o9r0acV01uzHH18rJOQkyKnAJ9n6OjE+n7afqX0ZMA26XyiP/lbQoq8ncOCB+/uYo
	 x/S9mTXuwI2nJFowrXRJOvfijga5GSlsvzJmnZClUWdccPHM42CH/2Ph1DuJX1HID6
	 vOKEd71Awc0pVcel40aRflw20k0rzRNlT7FCPNLYfwp9EfcuYwXMsJolI1/kPG/1eR
	 adROpNMleuf5g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/14] mm/damon/core: hide damon_insert_region()
Date: Tue, 19 May 2026 23:28:38 -0700
Message-ID: <20260520062858.167011-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91F774000C
X-Rspam-User: 
X-Stat-Signature: pmempfg7651a4n75zx9a8mmghnf7aqch
X-HE-Tag: 1779258550-722874
X-HE-Meta: U2FsdGVkX1+5lGaNQsjOn3K2OBWMRIix7s5/EQSl5WES1Vb9I/nIBhcGZW3iU4GuAUIYEq4hu60EnFqT6gr7F+RoM9TViYU7mU+YrPEe8THGoU115OBI/0NK58L4VXqpxE/5YZO/xHk99pmIxZ7er63UOXLFA043Gy18htsJNyiuvUyXYMTLBkGNURnp9EeW4LKWUz7D/CqxDAIVAIKGUwP3fIeFApFtryO7B6pfdIyVVF+xkFWpX+I21fjVGAfJQ+wAllOqSNnXM++8wrOE4IYQk8J6Gn7DQVGAttFiqbe3uvfqUvyZxbz4/PmJYQlT562b8Z/0i/AXbX9HSdzYtdYQK4MQGagHARobFdG+kcgB27Y7HkXCRaUFP5yt50zbkVUhjZyoRsbm7w/4wEmnviCYDwsz9wgnYfN+v5MTvMArIVAP8gt/5m4k0udghpoYYzMHYsXiGmWJPL+vRwKFWsZkbEePz+SLUTSgbowA8nuN9mRthTXoZgJjgf48Od2CVsoLkt/jgds0H5r9EFGRNn5jlu570ehzra7MX9SXB3iab5Phb2lcP+GkpXl2Njl5ZYF+DhbNT5CNu9GMDf177hfj5pFrLGDiaUsMd30Wbpz57mSaUmz03xWGXk2Z1sBCpySh0+pv18n0F0n7Ee919rHjvgXgtif/PIMlJHbVW+JLTfKuhrcrieSJmV1rbCvZmkNKb1++75du6OTx/OkkR55BZy3nX4/2z/R6R34zQGwqi/XUO3R60ZKzjpIcB5Vv72OiadhHpwUbK7UTCAXXRiDJMWUSjzTRgJcKamd58ikskeSGIC/GcTbPBI1h63PsLLMrk8JlskOTIEnfJhI2VTyVbj9MGC7IIZwG/MKnpVrSk7TKOtIW2b31O/Z0cSL9RY17SZBZpTCl2kMt46a9HDl9Gyxf6EDUsXUVbBRHggY5QSPPezcJTqym5OxC3z6zWWkEyAlsu8ZhD/6Qead
 NjLYi7gH
 EnsgdL2/6w6lb/OcmptboY40xz+PfCVMlbk2UfwlxYFdmErRpbFDWD6hBi/yPCGhx/rf2Y3HWpMlhqcx36fK9zxUHaKuBdsMxfXbHP67qzbfEOZzZYU5pFY27CPfcZtai/BIMZtcp99B2Dgrtfv1hh1wZLXc2z6AwpXISva668pushItJI7C2CEgAcqoJJhpMF+o8r8XsNOgzEFPCDBHEHn05ftwedTgNxm+EBmz3AQoj7h/rLuhEzqEE4Q==
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
index b9370c1779cba..3acca7deb1693 100644
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

