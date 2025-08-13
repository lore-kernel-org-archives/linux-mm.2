Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA51CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8C78E01A9; Tue, 12 Aug 2025 23:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0268E01A4; Tue, 12 Aug 2025 23:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE6B8E01A9; Tue, 12 Aug 2025 23:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6BD68E01A4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7259381EC4
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:38 +0000 (UTC)
X-FDA: 83770362396.01.FAF598B
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3FB291C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057156; a=rsa-sha256;
	cv=none;
	b=1LcENlv/ghh9mLEBmJSA3LnsULR9ovQrVezULFJ8imNpjBbgflgevLJzsoPUnZN+8/5LVG
	3PVxdxefIX+FLxr4Ev09GZQ+SLK9ytY1r/TFEQJb3zY4N0rRy76mhXeEF0fTKlXbCqRCWJ
	2DA2VbUAjMN+dTzCBhnPmpqqvu262KU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O0hikmuBXhgDG+P+TyGK5N9ETDTYyeTbvcmCjTiVRBw=;
	b=jZbaqgNPUdUfhg7ErtTMSwRQP9DeYRYf0wzxr0KRCpbmYPGep/KhCXtSIkPmI9y2r+PP8U
	70pBVwLUhjB9g2t3Iloq8zvB7xOimFVQfzF655HoRlIjAKaXLyyqmz+3yADPKrajNyflzK
	oXMD6/u3HLSh2rexNjFj8M1kEUa/EMY=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c1vTK4X9Vz14MRH;
	Wed, 13 Aug 2025 11:47:33 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id E88C3140202;
	Wed, 13 Aug 2025 11:52:32 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:32 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 05/16] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Wed, 13 Aug 2025 13:06:55 +0800
Message-ID: <20250813050706.1564229-6-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FB291C0002
X-Stat-Signature: eybixyksbb1d4ze77z3j8fei5uxgzhtg
X-HE-Tag: 1755057155-677327
X-HE-Meta: U2FsdGVkX1+o/JKivaWvoMdzkenzuDeCkslxcnW+TvrdbVi08Z1yubWhWkbCwH2kcXTFQxOjM9rOtgHRPGufpZOk+EjRrXeStagtGPhAqaIUDwt3gMXMukdLaeibKRZb7OIAubZ/ol1FEAb/+iTXdX/6/LYbZyHWGImwQB1pldZElHymlqJUP3V96aliMcfb4vCgJ+tp7MRoEr9vfwfZ4tmXnwsu6YoSZZWi64adSrliCr4EBguZEuuHUcOmO6GgBRWY/6ZrEy8taQz0R6KWJTAael7/QDvEbB7+GcK24qAWRgs2TQXEXhRy8Isa8rxgXueYWz1g8OTvLNZ8BN2xxV+16G/ZAjq8uQjNwMvmIjMlOarCn5AcdTbNB6oDZ5Yp0Q1AVJgq2gcnNGmw4VhbNPmGKS8gPv2yWLzOCLxRBs6MSOQXR1LJn8mjoj5ZJmj4ojXHsM46YCmOjD4vjGrRlY1oQEcy96NiZQMs+1QrnbY7t/wcJbK9wWNtmmd5ol2YP/FEOjfr/f4PyeosAYs7erTbkoHNx0nRyQX51BZ5oEFMH/4RvCT2bfcSirOwMzCFROkaL4s6+zv8IWl2BMQAFmlYPakyZuAKVIYeevhfxlCJtWun6fsr9Xh5tvm9OT1ReqYBEgtf3aruwegp3fdOnARFQNhynqpfEh8qwF4Gxy+CUIUdSIKB8rE30diZR5YhPu7fgbN2SQ9M06hUXrbg3DVJhYWzstpHnw4kf75F0V9voB4BmBlIy1/nlyHajGrD9UYwGMRK1ofwxe3XoCP8BZErKSOZYqj80LUTkSUdYBPFmbXkBaBfzLUKSEf+7bWn1oHkXsmluPRJfeZII8UeG7lwCFxRlyXyuDU9c7kKO6apG22UwwAtNqhRgevfPL+2yTL4OmuAjZRnrU9GAiNL3iHZjFM5x1XTZqZZ709CYbadxdgdQft4nOQmXGuqpFOtL6cRIp8bytl3haehcuG
 lHdOMFGo
 vdAfMdUeJjuiui/iPoTUFLK6fDcSMzU8IdEy4jySBztc+QIdjUIfaozREzVa1BnWMC80IbyxES22cEcyCWme5tOLvY1lH/+MDCFFzR7MDRUUMBzFrvd6rnNdRnvfK//NVG+sRmsEy8yY/evtSKZ8Nwu3AvkLVY2EsxmQHalprajFwxNMlfQHoU5StJ0fA613Njr/JvuV70q/BWjCWVhPwnSjwzKz3JaStkBcH4VJ6m6cLAQy97RrDPgl+c7VNkOAg7yJD67IoO6T93glkGTjGi14uVA==
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
---
 mm/damon/paddr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b8a7f462967b..76e1ee82b441 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -245,15 +245,17 @@ static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 			sz_filter_passed);
 }
 
-static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_migrate(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr;
+	unsigned long applied;
 	LIST_HEAD(folio_list);
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -330,7 +332,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 				sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
-		return damon_pa_migrate(r, scheme, sz_filter_passed);
+		return damon_pa_migrate(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return damon_pa_stat(r, scheme, sz_filter_passed);
 	default:
-- 
2.34.1


