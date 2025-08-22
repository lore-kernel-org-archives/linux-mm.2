Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE56CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B988E0089; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4CF8E0086; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7FD8E008B; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AB318E0086
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16D211A064B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:15 +0000 (UTC)
X-FDA: 83803917750.11.C1700FA
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8567640010
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5+zguP4DZ2UgV35v49CyaKAxszLNPkCsZN686HizfA=;
	b=sbPwk4UbttpWS/wvhDeaQAO8AepAn1VV2XgtodzR+qXwilrk5liceKEpyWFp1eeNW3YmS6
	M4yKTWQmFhx1jjzmQsF1UeePPHJrSjG8b8RIaCb/MA7lI39EMdMg6MVxt+VeUmyTx+7HWM
	m3GOWFNBZ/xAwn7aYJAiieilfxYbgN0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856093; a=rsa-sha256;
	cv=none;
	b=kyAg6NEWD+PZnZFpoTj/73ANgWCdOoQEDgwSvbaAr8v6d9nl24IiM1h/lTA06EB/emhOHA
	AdYgBVNVb8gFkVskfBxBTh6em0SnQZB0xt2TSEtNAjHQIpf0qszKIORD4nCMolnFqA8frG
	zV971d/nVsoicCuy6AvIa26RoqFi7p0=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c7b4V0gxvz27jDb;
	Fri, 22 Aug 2025 17:49:14 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 63946140109;
	Fri, 22 Aug 2025 17:48:08 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:07 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 04/11] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Fri, 22 Aug 2025 17:34:12 +0800
Message-ID: <20250822093420.2103803-5-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 8567640010
X-Rspam-User: 
X-Stat-Signature: u846ggns7xdh136u439af4rx5d11hpfs
X-Rspamd-Server: rspam09
X-HE-Tag: 1755856092-401215
X-HE-Meta: U2FsdGVkX1+t9KBXGKBTiqgUuf7ONQocrT73XfSYn23NCkVhL+OUm4rUExjgKFSQyXHzPd9RHEjnw116pGsRani/48um4nWlsfkJfCk1uRHYAaNTst7mlMBQyiis9qm4SlVApr00C9X6TmHO+09kDiHY7RV0w/GfkcpIjGtw1/lONwUdP1x2g53+ItG3CQNrTthCf9mjJ25HPpW30UmbwQRQ8iQaeJ5kCzAPKaIS8Po8hTN+8Pj/yj3lnwgPJifFrfFcyFtjjDv/u5/njL5XmAxYAbpl/hHopZnLQDFsW29vjmvvpXGDD9tzbW/ghDYYFVldL2l1hWSigCk72bBxXG5R44J3NDtbYEp6XWNgFvEywWhBo78PBvAfyiqEtuFLgB81uB0fqnzMKqSQKw4kH1mnQVvY0JPWBTNDM07FPcwEcrZRuSi7qDTZPlnODEBvjwfbLpp7jWJixnkQKO88tpBc+c6QVM6rjiBipj/nCLbb8y4ypX/7xtKVdyIADvg510wA1yBoDrUksE248u72ZN6jdqwDBLNaHHfFm+a3zHTa1kCgthAT0lZRO69G9WsaUrlaKeGySBnLqkyAbe0vZY3FxyriBPzZ8hT3bBjL38sgcurzs1MjaCf5S2wVhf/AZ2xABYj0EoOLlLcUeitjx5cwyzzgzS55Ki+kQ8o/+xtzSxpIJ+PFtqL60ArNmtJfQ2nYeYLtzKlzglANRdf74FtNjpTk5y7oKIuKoDiEQxKybusUGUiS8XiyD/iFQxdEu0FT2grP9L5HmlTN84xk8LKiK2Tn3W2rkjR0j1OXi/kQNT2sMH5y/v8WTcqCkVVM5jjBQhkuhB29eD6EfcNtqaSRaGc1Jw+qFSwhWam0QimlAjud6i247KygfyDgiwd27wVTtsZJo4Fuo9fPFgw/hijRObGSEoU/4bZT49+asnbKuaif7XAcbKbrTvcURC5BjjRQgVV76JxfAZ3DSh0
 FfPppXYm
 Ja7WPogmVHz/ZoFaikh/qxTyx4SqUx+gIGDphPMgrMELvynvyvtEaLV1yr+5NsjSJkBHYWqKhO9HL7/WXRpM6P7963QBonA13YogCIigXAHM0HtP35HPr8hfjpb/G9+3kMEu7KWlyX2G70Q5KFEhSxtdiY9KnyjodB+U1cQpV04M5eh5+QbgeyMfZmKjnXCcbRcFKwU7GNsKMs/+yJaO2MsKeGzJO7f+PTXkAg/YBXgxoBn6MC0X3GoiYm3qFaHz2eSfRoL9m+gRgaFsHOUsvk8vdAgg/fNJzG+jKp5uuxJXi7Is=
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
Reviewed-by: SeongJae Park <sj@kernel.org>
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


