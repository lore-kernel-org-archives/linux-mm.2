Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A3E9CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01468E0088; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2F98E0086; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919298E0088; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 512DD8E0088
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06EBA5A8D4
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:15 +0000 (UTC)
X-FDA: 83803917750.12.B21CA7F
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id CE7381C0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i4VE344rkW5UpMmoAMOveA123LRuEfwfHpqSz1lObnA=;
	b=WYpm3FE7F0qFfbIuAQOJQO/ZlIYSCrya8uFfUvWmYI160kRV4rh+O9RqBUCeiiNh+ohKqb
	GKZq8DAezPgqRZsyECh5aPJNhGy1fcqqjvYnUPdENIoyDd8sGz1dCh8oej2babeqoZjEEi
	O7wXTToxN9l8fCnHGd6mB49ccjpwNqU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856093; a=rsa-sha256;
	cv=none;
	b=6REP7dmxFb4TtB9e7GLwS2zHxpNspJCmkin/KWTH1jr3qRw+VB351M5ONkAosUFwQf0ss8
	F3dGVtpiG28r6COyxh2iOJb2GISVb8DgK2kvHYJfi+o1rua/QESg9SazZSN+0zW3HjTVj3
	FyFTJnUPrY4X+atYrzcAzdbROnx/l4I=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c7b4W2Mkvz27jJG;
	Fri, 22 Aug 2025 17:49:15 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D58F140258;
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
Subject: [PATCH v2 06/11] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Fri, 22 Aug 2025 17:34:14 +0800
Message-ID: <20250822093420.2103803-7-yanquanmin1@huawei.com>
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
X-Rspamd-Queue-Id: CE7381C0004
X-Stat-Signature: wnxys85mncenotqtk7fgb4adyaga1h7i
X-Rspam-User: 
X-HE-Tag: 1755856092-74455
X-HE-Meta: U2FsdGVkX19uCOskLwn+5E6rIZyGUFzFHKCBIpnP/UIGg5Kf5rZp9gyJtZHwfZLx1BmFkzkKWd7LLD0B5Wwq29j5l75AXpO3vEqwAFPG+M5Xr2iM6Ap/UUUkNAfmGUj8fC4Vn1SShBVVlo1UBTRBuaX9PLvdZZSDgZkZjwlrOsk4FHvqiTfgA2z8WNFb+fj2oh7Nl8Sq/AujnCBkIqQRaOtq8dvNZTW0/P3OiEqQejOT2CghMxBSS1HIXwJf79vj2Bn2n8C+l50Z1CI4HDeLwIlB726+46Jv5HMfcJ2KVn3ncEcVLDkt6y/F+hFW1SKnz+MitrD2C4WAOUyx3kIlY8xZZ2ol3p5Cw2JXyeZsmCzh4ieIQj6xx9XEKpR8NQX6BXGO8LGdatNw7hiZ3NhYsxM1TE/8QCcsQMeYmuF8W/WrVtWRuGOHb8vnoPxKyt9azzLbS8bQwMEYgj25eaNOE6U2kggnXYVYQxEDWXxfcNPXg6IQoe+eYQfFsWVGZ1HD3W3Bpty8RDUOun01HuxNhO6HuYftAiUUuoEBQaYhArIuEk6zQgvmeqILOeMyXGkw15wZNq3P2lW7HJw0Iar/jydrZqmgiUNTMmP6W5kKdosYtR/O4l3aO5SSTEwxF5HihJgmOcUiCCmVGr4wyviiqq79RIVN6lTdbJIG52xjf4iJ8WRF6y1RHuBY1g+9Z8T60bLmNnN3/iFnEerUW1JyVwP5N3hv14kIKJWGWyn5HeyC6n9G0H7SmzjISySptd1LenK9pc4QrNGAjqezQQqKKVvLiYtgUvOtzb4UiDId2n3teie9CDXzXi1uConKpMFzPn6j88ZvlZH2R7ru0fQlomuoCsChFnry4Vz9sUNfbII1DOcjVgYvaKEAfs1KqhRU0VNI1s+FxYe3XPffr46zCPoWvhSn3l2+9IiaXMh5Qjdwihq0faIALSOgooRZH+SQmc1JGLqyIrkaIiS2KUu
 1p9JZW9C
 IQBM4nmjqJGQbQfrKh7PFsD4DQrjw3lgE4DFbUj9Ihi8nDvUk6klx8ANtX/c9I4DRoWVZdvFbmm9Qw7oHX8yMC7PUHTXDbYKgZHB+lMTnV4CRp4KJxxL8Iou30a+NYa7/ofR+rSq7V8urKkvL92TBuFOsegxySCR8ve2updFPXjUu2D/9NKkllat/yVkfMBiF3me2g1ulStCrUhHIdETnd0M1gaTYlr/JMzL1EqRmNh0EZbgqMNtHBgO2WX393PtJfO9UxoI13k5aVP/9C3RxRLJLgiv38vsOSWFo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add support of addr_unit for DAMOS_STAT action handling from the DAMOS
operation implementation for the physical address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 0305e59818da..5fad2f9a99a0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -277,17 +277,18 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 	return applied * PAGE_SIZE / addr_unit;
 }
 
-static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_stat(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr;
+	phys_addr_t addr;
 	struct folio *folio;
 
 	if (!damos_ops_has_filter(s))
 		return 0;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -295,7 +296,7 @@ static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
 		}
 
 		if (!damos_pa_filter_out(s, folio))
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
@@ -322,7 +323,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return damon_pa_stat(r, scheme, sz_filter_passed);
+		return damon_pa_stat(r, aunit, scheme, sz_filter_passed);
 	default:
 		/* DAMOS actions that not yet supported by 'paddr'. */
 		break;
-- 
2.43.0


