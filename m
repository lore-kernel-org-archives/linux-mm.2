Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7356BCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527008E0031; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8CD8E002D; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1C08E0032; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 221A48E002D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAC7311772A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:11 +0000 (UTC)
X-FDA: 83796438222.16.647237E
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8CF3040003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=70JPRFj41DPjIPP7PakfbRIXnzfA2xWh7Y/tXH47wqI=;
	b=mtUbc8QcfA0qHMArUwCCH+7GMcHS+jswBZPw0F4V4cZUN4eLbWd1pW0IsCILmEtwys0u6B
	JgtRR9uJh9sz9a2sylbhHyav5mh9n5ARnxxXQ+/9qa7LHb3zaXlgapa5cf9nrSUm79HMDK
	BOIniVVsTt6iX5yVsjYoqLDvHhDc5ts=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678010; a=rsa-sha256;
	cv=none;
	b=phKln6BiSxo2LNzwwCfQwLe17VPy/PYAKpZsKXjSVPH9/e2HS3ZnpsAzOuqYIXHDpySYFD
	KXJp41RbNZXcw4soyVz1IQvkd1aeiwSuqvfL7CdSyL3EnOZAjTfs+iz6RWze6apqtPN78N
	4P0Yp+GFe68bFRg10wQvdiFVbU+NKlE=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6K9R1gXHztTL2;
	Wed, 20 Aug 2025 16:19:07 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2FBDE18048F;
	Wed, 20 Aug 2025 16:20:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:05 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 05/12] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Wed, 20 Aug 2025 16:06:15 +0800
Message-ID: <20250820080623.3799131-6-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: 37ae7qidoff1x5s6ao87jmk6or8zg1hg
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CF3040003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755678009-418944
X-HE-Meta: U2FsdGVkX18gha0BCSor2MroLVd6vdUTkQ3gtQFcDnH1XA8hcYnkPGqaaxXAlN0ruR0VHfadgoDjvIbay0qNSDrypgUacZOu4aj+FDHLH40m3FCv16EeqKs1Bg4NMpowv1noIKeoR7CrNIG2mYuXsfXaVo5/LRImANGl3Mtwo4qQKESS+q55Q/CbgO4GpJy5kukIrvvl7VRhl85tOMv/VV7VE6yxZfYiXsjxcMKDioXgQYhhdknpJ3OK5kb+91jgPt0UsD7O8oKps0zbfT+bGj9MVnGGHsAKcM+dEqn1Pq1SCU8QEZo4IlfdUBOxB8IVlwuHizUGljwlbNKLIfZukFFkazbmn2mEVJSetl1qAvtCXho4O3oEu1P+gjSK08QQhR1AF8WOY6ncjfwKkzDoUfOzOk3plGH8SwNE2vSZUsqEllxev64lo7Qytr8dHJYPpT5AZAmE/23L1iHiw8yj+F54VHZ4VwGzBRP6oLo+ku3t1l3BE0n0ZVm2urppQxBi7Tacb6phJhxeelvQqSjrFfQY8hAeziPjecdVNVYImN8n6QnXvFvEBTLuAYQ+EHsDD7fJflHo3mkOwo8yIFB3XJW3sURjkIE2MXmtSpSNyNMVhZ0qoRU1pwCKbRyG5psoL4UXJf3Q1RdYGV2UMIh65xYEl+eq0dosWwH90gaiDn5wdtmbRSlCquFTcnjx0f8rf7bDjoddIx/eL8OoU2EJ+178xypAU9MoHViWG+RCpdtGN7UD7H7rRnKIRyZTC+8s/WePuPDot4YLPfC0rnk+afi9kNk8Blqh+Nj2Q1sTz8aDWfd7UMv7+HC+Wh7OfMOQ7RLyqtOH8O+qkSZixp0OcUI7u3Xs70FY3ppcs7Rfxxou0c9V9EhnHFGKVAZkwgR+6XAu0Im6nztUNjybKamrTM0mpfJ6umSUnw/QEa7uwBgdpuMp/bEOF9qSz1GkxoraeMc3ZsY6aH8BxofC9Uk
 JuV3qy/d
 ZcugoHNZOmViMPQgiSpanxG3H66hR64VBsZZ+1Ih4uO48e+zz0fIeIoBQ0i7ks2ozJ8BNSsgizDeTUaA2f9ys2rUkQt3xIq8bxGoVGXzWXHhRyiUszasKTcsUOapvgH3LMCFqUaLommHoKcafy5vreBrQXbQk8PaQ7xahVE4es6e5RK6Ise4dHWfH2TxMCoSdPCcuWSiKun44wGIHIr5SBQJktJvdlaxxMgjpf9X1/NQC0UaJBX53+IAhEO8dRrsTxFb7qX+5lNmQhPlgqngS+ARy5hQi8M6rzJDF4VavakRNhb8=
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


