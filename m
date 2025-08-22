Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E80DECA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578078E008A; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEF68E0089; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D828E0088; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 075A38E0086
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB8F11A06E8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:14 +0000 (UTC)
X-FDA: 83803917708.25.46F17FE
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf08.hostedemail.com (Postfix) with ESMTP id ADC21160007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MoD/JSUGS5gavTd4LW3wP2tFF7qRB6FW9Mxl3Sm84TI=;
	b=5xVBUdLyzTQRnUflTmTe7skR1jxONe90hrOwO6UMdMlLO+uZwfj76sSH2EDFtsN98+yZ0F
	Hl/WE+EJEczL7O/PCPU+j1bUIiFgkk/42eEsY2wUAmoSKTuQza1nPomFLV+6h2yZUaqzWM
	xi0FTqIpZwCaiLMvQQxEpZ6au0O4Mfc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856093; a=rsa-sha256;
	cv=none;
	b=GPqnlRkcEx66PUwxG0trW0ZDr1js9CBCa1We71TFhWTgDX2Db3l1Bap/L6BeJqU0UwBwhE
	ngIxWn4Vkjea26ta2cIS3s9OYNZOsme5RAxoiM5tPcoEgGAHXt3cAZnNUWQkR5GHsRhq1m
	adNKgdiFYl+LgdJeFlxwYKCkErjPAzI=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7Zzv022Qz1R91N;
	Fri, 22 Aug 2025 17:45:15 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 01A81140109;
	Fri, 22 Aug 2025 17:48:09 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:08 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 05/11] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Fri, 22 Aug 2025 17:34:13 +0800
Message-ID: <20250822093420.2103803-6-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: ADC21160007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: p3upqsjr7r4y45at96xtcrkz4qinbx61
X-HE-Tag: 1755856092-36131
X-HE-Meta: U2FsdGVkX18M1gpNEAsDWr1sTTUMD6Lc12Bgi+OLMhkduVR+IAVZg7NZ3FtPBb9WgGaPPxgsTzdSC9XjvDq7VPTb1Ml8+B0IchXTLamcMqUgNky6igTHAA7Y8/jNhPWZWpow3Ia5Cf8tJ+jukyoRwumM+gxWyOFFqueJsulj2BYk7dd0Q1b2jLp3VzL14j/UlVRu/qC+v4zPhyRR1yeZ7bsMKyz6E69wIdkXgotSaKvlZ12/42wY9o2fBIDMqLanDWbg9JsvUVu/Grc9taxQdy5ocGPhzODDiVnduik3iVeCHeErCZK1gu+YWacT3lJsbMNwgfZjHlzSdzRqL0EkBUpIAsbUCm2k7N9MZYg6EWQSftYPfPlgG8xma42ptf+1tUlQsILvAWXB1b7h6ng6fOf7GQMuXAx1UCiVuik36tAcrcUmhFcS3gxdfnh2Sels7H5f7eOEnWXwS7SM9XboV2d9IPiUBRbFwG49dM6sP+3JYOK9vNlkL/R8Ii7n91kyGcsXJRhwXadwD4Uh+DMayVF9+sHBH/BCg+vntoLKJHsL4/HZYKHIHCs9Fx+MAznbcisORW0bnvYOvB/Q5bwubIkNOTy+8elbXc8QP2hIrvaa3sew/wJfgmsFWeME/b11/tnwsnAIs42xRl4EVoyWcNsjNpWSKkVweGjo3X/jtFm/CYHFaMqAyeW+MtKk4fKtpeHFjOv1HZ+t9bxz5IvVdWC4M3XxHLUutmTaX8oP6IoqsFDWuDpdF+jd/Roq1u5f0ohR98QcT4UjRwgsxEqnm+sVP3HJ0xghhHiFpFtIcmOXBVNfuNo/bK8s4JgAyhS47TT8AaN5J3UKjBN6/AHZ6Ay1etMcCoMyxwGJL1uql/kQfhT/EfGdN9dzFMuO1JZeOpD1YJtNM3AbsFz6faQ4vzLrtTdyj4/uizvCQV+Qsrae+kXckJ1B+F/HK+gmk5VHod6y9/BZ/hAZ6HclV0J
 a6Q==
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
Reviewed-by: SeongJae Park <sj@kernel.org>
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


