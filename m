Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3BBCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA928E0028; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D628E0023; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD818E001F; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45A8D8E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AC7F117756
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:13 +0000 (UTC)
X-FDA: 83800485426.13.9FEFD9E
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9E36160011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=70JPRFj41DPjIPP7PakfbRIXnzfA2xWh7Y/tXH47wqI=;
	b=g0EPc+5rHZL1g6A1u0my2mooL0/UfmDU+KJaVUC03f5CvX946K/pGcjzfaOBiU/kP07zpT
	kcjI3vuNAS7nI9j9oxV1eXt+nhFbkYi7bAaMNXYrWwo3FZ6jEK1Uc32SIuHjNjqKWb1hXz
	mLhg/vn/B6NFoS8d/IyVBzHyxbi1ecs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774371; a=rsa-sha256;
	cv=none;
	b=uHhkjvFU5DKnOZVcRjHyHdBPBHhSa2hlKj3Neuv99XQ7isP3PBQqkbP9StZKm15RkVGFDS
	PR2wry/1K7Cu2gU7/Mt+IXDnqXk89nGzWEo33+etuHZEKuSuZBCHTY1NbSfVkrUzpEQHlH
	+vqlsguwYUyS0QZ55GpbmPpgiXKwINc=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c70q96bzPz14MNf;
	Thu, 21 Aug 2025 19:05:41 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 35D24180087;
	Thu, 21 Aug 2025 19:05:46 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:45 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 05/11] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Thu, 21 Aug 2025 18:51:53 +0800
Message-ID: <20250821105159.2503894-6-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: B9E36160011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uhfzp5ecwsr6f7i884p193h5c37c7xqc
X-HE-Tag: 1755774370-83069
X-HE-Meta: U2FsdGVkX1+Xq/D/Ui3gObmHF+m+CcspxAOCx8D7XSkjEc1WibgyukLbqL+tswYU252qoju1K8FmTzHy08G8t5YEHq4U9Bm0WHl28WEkZfFyova2W6/x3Nw+iTQ8cJcjqx3P98G+S+bf2JiAERMtYJxT41JFD3miztcWGKgURFRNKNbBv+/rBhmBqfAL7tBi9WxU+cnd7vrk0mwndGwfmOMRmaXPPQAwuA9tDN2G2xZD/yLK5/ZgK7XLbsjBXePVxBE7z3z/P9u5dRH/CgbBYs8O89W6EaywyTf500Bb1NMZqWZlWTqn9sZwLTl53lp4DLuo6Eq+i7v4d4egmfjLoh7p2Wev8adpP/MtzJpVuLHkt+YFq/TKNYXRwQWYcIpZSjU3F5899MELTZYupkz8S+9kEZnvWE3n6kAM9FaQeLN/1jq6DN9M5N0e+uNBFaoQNCYY2Rdnxc0484uZbInx8nkMHK+b7LyhgG6CLHR9khLaIobOYhTRS8iRC3clEAAOFA836EOV5DQB+gdHFLRvz2YsXWDQktKkf595bHQ/Q/BFs2gud9MoNd+anaunXbgDhd/R8wHh93HKjqKtqT26BUdvMOB2sXI+2E+9jdHgaobYzAEBG+/nOJ8iF7e4GuQPBSr3NqWk8JWUkujq50kuI8oHb41lTLTJZNwjVtTD1ei8ztzk61rsswhje6sS5uLD1vxsgDDV/7gZF1ZtW+avGtFSGShBNsvvqgAIZCJTrTQkqY3//DMhAj3fKxroh2h+bOlSRr5Xb86oMLzkC9ha0FbASUHChoGKLPhXWQXM40wOLKCfp8O3GIisKBJXPNWXn3t0TYG6wfqwTkZkXSluA2JfRorvPCfEbdOeuM9lB0iaoEBlT2ALusRLhwo/UHzDPzEGiGjsoi7loiTgAfFQPlvL19eE9YEewZMen4R6RLsnSZWZSXZNMsrc8LY8IlYayWsXZQ/ZoGnxyPt5auR
 0DyiuXY3
 B/k7VPeWGvNMOaja7yH+w2zstmF1ci47BV2Fp84RAKykbr1SPenv9g8kNadXWiJ5joo+Ud6S3Js8rg+0FaDLIW5gGhd08nfM1hRty+5M2zZnkdDwghthJHi8zUUMUSKU7iL0KmaJJEHo1ZPnLpUcUaTAcS4zdIXc84VkDDrtx4T8BF/meFbIYPqnz9MerXH4r7q1B/lSnIaGhtVj9uNGXBEdmJQ0Eoo43XWki0/1atFsHj3V26KKw8UzR+zL2ilSJEzBzXQai3yUYoS2TlneTunv6uGU6/Nf30vHALcYiNPGjO4A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add support of addr_unit for DAMOS_MIGRATE_HOT and DAMOS_MIGRATE_COLD
action handling from the DAMOS operation implementation for the physical
address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/paddr.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index ed71dd0bf80e..0305e59818da 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -243,15 +243,16 @@ static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 			sz_filter_passed);
 }
 
-static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_migrate(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -261,7 +262,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
@@ -273,7 +274,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
@@ -319,7 +320,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 				sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
-		return damon_pa_migrate(r, scheme, sz_filter_passed);
+		return damon_pa_migrate(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return damon_pa_stat(r, scheme, sz_filter_passed);
 	default:
-- 
2.43.0


