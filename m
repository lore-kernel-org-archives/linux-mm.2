Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E3ECA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F078E0030; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267E88E0031; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E008E0030; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 045F48E002D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8E73C045A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:11 +0000 (UTC)
X-FDA: 83796438222.23.C099168
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32492140005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YeU4mVmVhdnT/3mNe3vckl1eorAqKovJB7wshFZ9k64=;
	b=knNR1UHDInBpBK3EpuWTuogDNxXL9GtDKT2PeR18DWMhFhJpAw0O2JZ4IuES382thk+3KK
	uUzpaD9OvCCg0XWBMtVq24AytZkjHjnzdHQwRjYOv5Hga2cuG0QoidASfNv7jqNeKCSY7x
	wakF1VffwflcrAXT/vwTu17+R31szBQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678010; a=rsa-sha256;
	cv=none;
	b=XLxAqF2lSskKNlen2tXjoZKem56T7R4LTbdok7sMwrvWgRCOfghYMgMJy6tSmVVsdn3OZW
	7w5tbm+VJaMDIQpugq8BMq5pxktbOoicj3Xjti4o/zgaisKpsNz06TfCIAYcUpYCr76b2V
	M2pTbVRZ1iTWMgnsfNuWxmbxEDoMRFM=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c6KBT5TTvz14Mfv;
	Wed, 20 Aug 2025 16:20:01 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A1FE14011F;
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
Subject: [RFC PATCH mm-next v2 04/12] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Wed, 20 Aug 2025 16:06:14 +0800
Message-ID: <20250820080623.3799131-5-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32492140005
X-Stat-Signature: k66ggx54pfidrqiufsc6yrq6sqykgdpj
X-Rspam-User: 
X-HE-Tag: 1755678008-312169
X-HE-Meta: U2FsdGVkX19HVQYeIUDyNy2SCkrLFnJ+UBCQO15OH5GrqUVM+wewteISxHPqERe1XqwIVWfWQ25JBqleuTHWLMGbb4+OfHpG1OhGG9N8tRMtduaJc1kwOUmyrIMyhQO5Qs8yNTDzmUrTq2qe8R9+iBA9Zrnr3JgEDqoF7ipLf47Feku741F1dppUjcgU4FuP67sYO8dw8WkhwbKmyWzzFgQH+cnp6f929JOJQ0KT7cvpVu8/ackpnBnNhwUcSF+6lcNrF0ueuJABQWpEspBQbyMIRGEZAmJclUdE5I1Z2u96w5DKIydL2ey7DbZzIHoSkAa+aso90+i8KARA38CBmQo3LFiRz9djacRjKDCZxqrKCRLYLXdSHJdfcjlZSCW7/b4JupNVLFOmx03vElCXJ/KTjcJu7HWAdj/nVHl54EPU6zWL45lbY18IUMniS3/VuqpTJ8lzNw72gW14OYkbFw643Xn+l3LgrUEmNzhtpghNf9lEYBSdH0nHZ44JnhvMKg8HDTz4cLxMdVzJuZe1YYwALT+btiFkx3TzxTyv2Utv0maoudszXbe+ZBb0Vfd0KiSG9DucZOQLWf0Ek2P3E8nx+usQHRgUenP16Pkxr6yGu6TSzJschKErj339uu/VQscndB4NLD8Iw4yOjeBxNi5Yv4VlgvuKUlBJeJhv+sDW9vj3eCGNuYQAf2vQGzWDN8l7O4KwbGMt2WXfZobhnJPZxgHzoCND3VMUwMjW44ckgTbPrantxsfhoo/rPfO6vH5MnXGs25F3JNAjthbWd7mYgWXiaYbcyxKAWYtOzCqUPADlB5m8gq2SR37bFpYC5zurxfiss+oAKMcmqe9KANyRTyy8KAJCfPR4lELmGIsrxegHfjhtUL2TSy6pXerK+iP9ZygGyC+mQjByL+/Ur1RB+9uTFSDpS37I4px2eJqGm41upTlhqC+I5tl9XbIwf2k/Q326VpHVedGghZs
 s10nNzT4
 y7U8eMZWOte7DlW2vjHcqAH699UG/7Y5NSYlS6rmo7v9Bo4OpS2FXHmVakoWvSV/1wz1UstiETg/eVgFpcuXmNxcXcwDZGhlsENCDTZskM3Wzp5FITB7UGfE5A2+LfCgCw1GzyIaTE1+bh80ZRmIL/G2GwTi8em+1M9mVL08S3hscl7LfcbSSZDe+3XTTIx45dsQcsHZOqswzXblYRhWiS1lu85ZW6V9Eigof37Bvd0f/Vrr8AUe4mSxxI/o0ZWmw+3BSP4wfy2fRaUDY7306WkVVecipw43TmrpOIN29JUX1YdQ=
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


