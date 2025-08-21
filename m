Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F81CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698E88E002B; Thu, 21 Aug 2025 07:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622038E002A; Thu, 21 Aug 2025 07:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475698E002B; Thu, 21 Aug 2025 07:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDA38E002A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C32F1140322
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:22 +0000 (UTC)
X-FDA: 83800485804.29.5DC49DF
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8304D1C0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YeU4mVmVhdnT/3mNe3vckl1eorAqKovJB7wshFZ9k64=;
	b=AgDZEvAZS2cAlKxiJ7inQ95Mq3V77jTS1mBJAiIq3djqCZtexILEln7iel+K3nxP6xuq3i
	AWjjvhGeVEyu5vbd91JD6whfxtRUMNWG4XT25c3mlxvO6xGcJy/pQ9L7oLSTYue0/UGJmR
	Xj8jcxMJe5afs3SDIqVPILTOnkeERqY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774381; a=rsa-sha256;
	cv=none;
	b=eDJd4Gbw2VI6LQpFJWgNlpsKSUJvkYSyIrxx2amKiG/kzALbKZm2H7JhgCYWQS0HiAaW16
	xc9GYwnmH1k1FDBJo+y/9o/DtaEo5MAMt2lA8UVYBNLbXfMvvR1dtqsQQTdrhGr8jVMx7B
	KqyIQIkz/3YXJhFpAVr3gBkCkaHgwrM=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c70kB0GV0zdcVk;
	Thu, 21 Aug 2025 19:01:22 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 83E82140279;
	Thu, 21 Aug 2025 19:05:45 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:44 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 04/11] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Thu, 21 Aug 2025 18:51:52 +0800
Message-ID: <20250821105159.2503894-5-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: kx3d3q81mbacfddaaeaejmpknkob7ebo
X-Rspam-User: 
X-Rspamd-Queue-Id: 8304D1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755774379-408154
X-HE-Meta: U2FsdGVkX18RJDia4P/Dmeo1e/LF4E4Q8nG7A03NYdas7LN8s1EHljJIdbjKMWjsP3pjcP66hxVbRbXH04hv/EdcZYfedMOAUpdAfVCLDiid09WZpizs4ry0Ug1R8ppFzs+183CXlWerecenTMedZcD4UMVGcHe2fte68l5WWn/7vz11xbSOCDM5x88AqKVL4+sB62jR5JsZ0hcgi4F/tasJ7Ziq964GprTbj454TI6w1WAAa5CCnMf+jzEKJFvRZF2nqL01Q37fKlAt2YogYaRLEbxAiIwbHIE3JQMofojuuZYOpluwuE3dD2IFMc5V2XkvkCNfgu9c7xWGm95g1moNygU4mmDnKRhqnEIP7yFayctsshLuXn3WnD/XzVcx8dyRgf2zCkCJZ0LHeS28KHNuQsul2thXT5K1DtjkiIIN9jaFzTIXen//Wnq+8gZ0/3dp/LJMr/SL7ZR/AmsvSjTC0zQW2lUGsdi2Ye+4ObrjB7C/E/Pz+igtLjR7njFZMfoDm7Y9XdsgO3uQYniVT/SM+iB/Ee1LUhPiYT8sV5cp9wL0TXPw8+mni1tK+xmjDHEj90RRa7GSm9455I06miR4ikjnluctx63T3dVuI684hl2uoEOujhJWA0FOrkitl3BSjeXH5oT0GNkVmv9rOC0ppiJ/R/ikWWhlpgzXeX8AViBpfBIb9jjhMctVf4KZb9M54gvfaLL4U53BUlYHd3x9t3Jwgm654JvJKwakTGmPXgrmNop20W0lCIxG4Y+SZmAgK+aLTcdW+8mHYS/jHGheSK8/YWIgVBVpq/Pdt2PJx1wMwiWl/ZQ45Hw4cFDCHCC8uspAY/3bK81S2yOmndJ+zwPI4BQ8tAyvi1jbJr//aQUEsgBFS6xAqY0E6DrIC2+VApiP+Eka69MPgodMl1DM4zineoYpXhhnWnL2AdKlsjfHmw99lfsTUMCwuLJXWGnDWck/hhrtMP8SsyS
 7BKXX+yF
 6rbOPDts0Mv+9cjAC+5BIHRM8CPEMAh0y07kfNvrGKPezKf+TdMm3W2f0s1C0zof80ixcvty6aVbYhaW8Xtt4m6ZgNYN7Ft4hR0korlUhhaEyUDj1t70GJhf8a4E3UavYZPZa62Knrj4pII6ipsmCX+hsv96BtAFka5EUDU+CgLWgnvsZIg2DyII+g/eMfOGyWaPVLtWZLYaFg2cQqB8wYjvwYYs4kaXrzKwFA0f2c7iv+mDu+N1aAn/xGd6Ze57pII+fXRSxSQdiuyxlRB9UP5RSgV3SSfVsRU11y+qHbuOvTyw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
handling from the DAMOS operation implementation for the physical
address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/paddr.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 826c2064dbfd..ed71dd0bf80e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -194,14 +194,15 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-		struct damon_region *r, struct damos *s, bool mark_accessed,
+		struct damon_region *r, unsigned long addr_unit,
+		struct damos *s, bool mark_accessed,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied = 0;
+	phys_addr_t addr, applied = 0;
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -211,7 +212,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (mark_accessed)
 			folio_mark_accessed(folio);
@@ -223,20 +224,22 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static unsigned long damon_pa_mark_accessed(struct damon_region *r,
-	struct damos *s, unsigned long *sz_filter_passed)
+		unsigned long addr_unit, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, true,
+	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, true,
 			sz_filter_passed);
 }
 
 static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
-	struct damos *s, unsigned long *sz_filter_passed)
+		unsigned long addr_unit, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, false,
+	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, false,
 			sz_filter_passed);
 }
 
@@ -309,9 +312,11 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_PAGEOUT:
 		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r, scheme, sz_filter_passed);
+		return damon_pa_mark_accessed(r, aunit, scheme,
+				sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
-		return damon_pa_deactivate_pages(r, scheme, sz_filter_passed);
+		return damon_pa_deactivate_pages(r, aunit, scheme,
+				sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, scheme, sz_filter_passed);
-- 
2.43.0


