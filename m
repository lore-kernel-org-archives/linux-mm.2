Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78CEECA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB5F8E008B; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0B58E0086; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1797C8E008B; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 047778E0086
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C45491A06DD
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:15 +0000 (UTC)
X-FDA: 83803917750.28.807C11A
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D0B8A0008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feYcglNLz2jlUgz24dJCjq/ggI2Yss9/VeGbe2mCwgc=;
	b=bgqdPW70JZ2j1yLIBAqNEX6OXTZqDrxT6uT1FN5I/02nnVjig4rnVMxyUD0kdMOAHj3IIi
	n6AD2FGiuRkzBgjzV8nV0YtRwBa5BjCg7ij62MWXysW+CeS3CEP+JIzP1+e9T3r9taWQJa
	Y8tiDrPuCo0DTbGLU7Hlopc/ccdGpEQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856094; a=rsa-sha256;
	cv=none;
	b=wu1GUSTHm3sZcLEIrrPIXidLF1ZNX+nEN6jyF/AJIZJuA1q5sheT4JnXzjhTUZF+vJ0SHI
	q7ZVhqavc2U/Gx78WeA+EWkDs4b+i7Z5aPwESN+qoQD4W5fNhiruyiPMc1Dyd9wrSXAFXI
	vEDAElURh7B7gbfqqSPPopS7SewJl7A=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c7Zz36z9kz13NH4;
	Fri, 22 Aug 2025 17:44:31 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id CB43A180495;
	Fri, 22 Aug 2025 17:48:07 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:07 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Fri, 22 Aug 2025 17:34:11 +0800
Message-ID: <20250822093420.2103803-4-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D0B8A0008
X-Stat-Signature: awiprtj31jekbc9niupzjor16x1qqem3
X-Rspam-User: 
X-HE-Tag: 1755856092-769015
X-HE-Meta: U2FsdGVkX1+9sfkMXfDIh0pCkxw4S68K9KAv96bcvTpdV1r2sXgIcaOEEoZq+4Czft8C9VbA3SNjet+pvy2r1bQalroIMolo5xKsmqcZmr7GWaYSdEomKYknEwbpBuB8lG8sImjeyfW9jpWq0DzOk/yauWZG+OkrX3w9J9oiIhq/i6rJWt7vaOSLZkISRmAKnxuO1978bfEDvqzPwhZBPu3MP/tGU7BCDGozWgoo4OEbYB3HRbPDBm71YKiZaPDL0lQNrx+M/H7dsnEW/Gxyrmrmp4D4RoQNffVG+tnyvcCUJYyKAYMiWvx7E68ZHJOvLXQR7TFXb+flVtw9vjyHbRYbeJrsPbBcTc9C1i7qZJGCfqEUn83HA7iTBobfw7t9TsGKKXAfXGOzcCU92ozX/LEJ3afHXR8ldebmqLuw734T3aqrfHTErrNgHRc18gABtSuXpiwHzaA3CF0Mkwfbis3pYtSkKRo5+8J3rF8bXaA41PHrqn7T4APNM97OFBvN1gGhZ0zGL66TghwAaqt/N54PIEURKE/ki7lxqmx+1dOC1G9f+7BN+paPPWb0dsyF1ujlyzTTq0GKegDh3kzVYsGxESEHU3uG6xGhG80jqOQoMom3pi2IiRspP1PqWkJN87JRdJfoqf2XOpwKZWLRabu8pDjpM1cKGNiyas5ABozYbuJ0FaCkGb9uFE0g35r0lvg9fDzgRCizds/me3ncbIv25shHKY4rQlyjBpWxr0lkM4RgmQpDWa3xKmSlCpSPuE8y2EuSnSwLmDbDBzDXDW9N6TRjZMRnVcQlq91C3JvWLgKo3fzKYtpZdnu08bOVuxwmqj2u4FqdjisFdBFoNf9BmkwOY5XDxnTILaVFG2pe807TXM8LPnBU3Pea1B2bncA7eaWHqzwC83Hw6wf+ZOsIN2QlVKHhyLUEQK4fBQWIjhYdEfciGvwhadfypKHcQ5cggOPQwCsQwTIlyBi
 57BlBX7Y
 Pr33sUyw9IJ5gS6+cQE9ZrSUFEASkV0LY7bg3RIayiWbLTH8v6NtDMagaBCRb09Tmqr/8yi1BLcqyrht+Cw3UVLGhSJ5O6AZg04fRUAKJmlUXkiOMrCVRPu/yqquXqEvzQYUt8f9nZDAvHjEHwd80xfJCSY2u8DodnpQsA41m+5IvUWD89K55yIda8PUVaYSXOOXPcmU3Ncg4ZFRRQAMdcYB7CBMQmNU4J9lyMKB0aMWoPD7S8jAoG9v0lOfThTY1ivLHHF0wQj1wJl7zG1H8Bk/fqHP1S35+36xQ7tomBbW0Va0=
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
Reviewed-by: SeongJae Park <sj@kernel.org>
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


