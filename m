Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD517CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1838E0007; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33948E0030; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0A08E0007; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 852658E0030
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4573F1384E4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:11 +0000 (UTC)
X-FDA: 83796438222.13.A904642
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf06.hostedemail.com (Postfix) with ESMTP id D26F2180011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qU6y5scbrh/0IAhBCHDSpIVOto30muliSWLy3t66GKc=;
	b=uwhKqGgB+/YgPd97CwcrhmPovOSMLkiyaEpZ0R9iydHpMaWawPKNjms5Xp4WgRIRqnUkWa
	PxyRul1rdFWSVb5kXuO1BL6VJjkPSlg4nyvHYYZett8QRHy8h1o69PH2t3GEUPVzAkw+Zy
	Sqy4zKMhecELQfztxobOSuyWEQv9k3Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678009; a=rsa-sha256;
	cv=none;
	b=4LuqaKNDEnpo3LIxeNcsT1vXk8sxdTltMuy9NmgRF9Zj5fqsdKPmSpxn++muG0In/cj4rt
	tixd7axu53YZypTeu/e9Ulx4TGid89w12fay413pYP04g0is7gjozJtv7ZpaMmO4+ocqxm
	8zAjgCDR4pEeTmglu5G0rlggU9WDdLI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c6K5V1mr8z2CgDx;
	Wed, 20 Aug 2025 16:15:42 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 04138140275;
	Wed, 20 Aug 2025 16:20:05 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:04 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 03/12] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Wed, 20 Aug 2025 16:06:13 +0800
Message-ID: <20250820080623.3799131-4-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D26F2180011
X-Stat-Signature: zjpy4c5aei4duz6uparemfti9x3qfx4z
X-Rspam-User: 
X-HE-Tag: 1755678008-406283
X-HE-Meta: U2FsdGVkX1/9VtHlJr2bm/WICtjUOkZWIlsPC8GU3PidDHnT4doJTaRpXrd2SFNT6dAPIV7sLcsRkWD8RYuk+SmQXYj/3/DfK8JxwRr4WMAG7L3Rc8dh4Br3tk7ul8lzyUju7i2nEcDUIGnhMsinTDtTQSbl/kUvIpoZM+R4DsDEynxIKXa8/8tH5iId2DzvlyctWF5ShWh43Ot7yoMk69hxcUbdZ4QxrIPDZm9BjR4Mz3O9ULxr9NacCPyMH8Ndkve3Vi4tGqlBxXFczhazuQrhv/vtiFBJUXgT1S32piKu3jGBtUOqgfiQNTKZO0Cl6nU48UL9W/2WIYLg4jUzf8souZvdz3MzpfGUAJgQzm0Az4wvXlisVaUwi4JZxZYKlH5uAidaHsd/egFFAAIHLSbxQwwGpoWBAOVjMDsFbljtletJPkOUhYPYi26sFWm2YTlmatQrPKCghB08Cu3r9oUUFw/OTqtTbBaenSG5C4gsreV/hPeKmPVJCtS0K1ckkrsu2peaBEXGv1EqNqLlYXVNNHpMyx3OTEekrLMCxZinrqADWd5KV2M5arPMXNV+n9SJG4+YoUsKTm9fnJ6K29SilZauAcbFH/KRjqzl3JPvNQ+VEuvePmJ6oxvjzw9ENiUyPgkAmlKlN0NmhXqzVvjnmIyib1nkicaue4PjfdVcPqUd8bxGPrNuhUEUu1liIm/4QkT5aF72/61ZMla3x3G+i50hdbyy8UdSmJQzZfq4Lwsiv+vr1p4iZ8TIC+L1nYHnVPBdrLy+rf2BgvJDLSskxfKeVi33FK7+sP426OSP8pMFbHSrXDVpQl8SHuYcGtIzB8gfnyrC8gfsl8TJsNTN89ZN8UgnDJsz4TxApu2lAesQMsfUJRM4RhI1cNvLN7q9Blf9SquQplElhwSNocqYcmjhqCWkhCrVDBiPqadlQtmXpoIUgBMV83TXPQDDwHzPkNdaZtzfJpGuprI
 LUiOldaF
 Qn7YW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add support of addr_unit for DAMOS_PAGEOUT action handling from the
DAMOS operation implementation for the physical address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/paddr.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d497373c2bd2..826c2064dbfd 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -135,10 +135,11 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
 	return false;
 }
 
-static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_pageout(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
@@ -159,8 +160,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 		damos_add_filter(s, filter);
 	}
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -170,7 +171,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
@@ -189,7 +190,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
@@ -302,9 +303,11 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
 {
+	unsigned long aunit = ctx->addr_unit;
+
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
-		return damon_pa_pageout(r, scheme, sz_filter_passed);
+		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
 		return damon_pa_mark_accessed(r, scheme, sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
-- 
2.43.0


