Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94580CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07508E001F; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A419C8E002A; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9548E001F; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FADA8E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 161A2B8840
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:13 +0000 (UTC)
X-FDA: 83800485426.03.31632FA
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf25.hostedemail.com (Postfix) with ESMTP id B3198A0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qU6y5scbrh/0IAhBCHDSpIVOto30muliSWLy3t66GKc=;
	b=tzkkE2OZJhO3l70qZbZZYJ7YIJVBF6FiUzVykzCkqS672DZ0qDGD3gjORqiJQWsCZB7Cua
	JDdJeuXlbLnlLM5ch8uwjHzMgd3b7IZMxYLx8s9FwtmmU1IYbX/9cObxWv2vzlzvNkcbDT
	p57Fg7mdGuA7KYXkDr+l1Mk0pR4gHCU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774371; a=rsa-sha256;
	cv=none;
	b=NvAPBOjZ/vUjMrwQnV2f0xEcklU4u3LL415J/qIeVf5i8yCF+5+bYrzfVxbOq2CwO4DHww
	x5PDQaL4R80cuaAOhtqecMuxp63f2RtGYsaczFc7SwqEUx3APMFtjxns9xDw28PdBME5yG
	Z8ophA1QD02+sNH1Y5ysFv2mzayfREI=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c70q84CcPz14MkW;
	Thu, 21 Aug 2025 19:05:40 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id D8754180B57;
	Thu, 21 Aug 2025 19:05:44 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:44 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Thu, 21 Aug 2025 18:51:51 +0800
Message-ID: <20250821105159.2503894-4-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3198A0013
X-Stat-Signature: i16fpg9iqy3tbx1yzuw9nfx39dcyqhqw
X-Rspam-User: 
X-HE-Tag: 1755774370-777371
X-HE-Meta: U2FsdGVkX1+uUFKGxFOwlEp/AL4NOb58kJGyC3Qz8ZyyEuoy+ZegIP5Gf6ckNzq66cRks9Vcj75NdtFMg8+6SXWBAcE43Kexj0b/ydbktp8mHA32PeUiUtU6IOuF9sDzNikQC0dKi95LTK+9qRDhb4Fw8E6UYx64AYap/gQYqTZTWMcro+F7OKqHN2+zGl8poD9/DMFuY1QA5+pwJGyDf1PJp42Qct6qQoSf3VmHFjzVDXXtVCRsqC/KPgvlzP7Dn5tYB7BYZZBw09fqkAXRNARC+ADll+xS35YHzdi1x9/NhkKtez+MTm3T5jD3ll6ORsQ6Pxi0cISpsqupCzw+6ZMl0JhBzhHIEA7KQqYK2jtT0Cb4NtbJSqGKo5NllhWPgvXlN8kFtfeFI5wjwUr3iJcfhdW6cvalOXEGHwKuRFwUtJiVnQDDpWM/rxj2V3XK9dorhEiPRPsyr2ndP2op5NxIQFxSOX+JMj8H7pIkikQLr/OEcrJyfkEWz1dJ33pVfSNXyuQmBww7eE3avHhamdko/S9tupLrPnqc1I0AFnTBg3R9Ys6imZdZvmCHb0I8CzYyiDNLtpc1mEbA+eDykh6Dllr0c6hV3tC7oq3uHZT3WN28Vmpm5cRlRlOnpfGMj28TvpZW5EAzEKD0nrmY8+Rx7kh8cCw/YHNnQL6ZtSNnzsbVXA1zfBxqurpnRQ+DQn+Te+OrKCQL+W8NzSKSIje4MrxcbJOnMDNwv5LBp/K7Hy/CITSFr6TZDzUH/oaUeE5/fky6TYTWtKvDq4Rtjb5h9ehyvxm6sDyN/0xeSSXE1Y9IW5TZJPXzQMUpSDIVhzzZy0uYjfnWUb+Xm5AdOYcbZ7lTrphGsLodnFfEKaiyJPi3oCPpICKZuwVXQSqKoSBsJ4J9wFHcEYjxY9xCTM8jv1imP+lYlCCCQoUP3ImHBXxZzoqN4Ret2Y8DlktEQOMkWu9e2LIMlWmITWe
 78sJzNMU
 7OMi+HbOHOhrs43fJAeng9x2tpgy8l98ELglBAKlkt4KbOyPdsdUm2SSosQBMDy5pe+3eRz6zdORCH8aYtP2BppTkt7L1jEd1HDSn4npaSoGL1j+1dVdl/1r336twQw91B33QRh+r57cjTngu5L5mHz2T+/vk+dL69sOhPGXp4nDriNKkBxbSPiXKAgOmMAT2kNPg+kOAUkfqUKRUwzG9tpJ5jCQSqadmsNtknRg6c72EtIhoacUx/baPmCdaEYiziXx0ikI7XQZL5AmYEToa9vaaFMp+i0PyW2ePvU9XXihaI9Q=
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


