Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB64CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04AD8E0032; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCE48E002D; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3128E0032; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DAF08E002D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 694241384DA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:12 +0000 (UTC)
X-FDA: 83796438264.03.E5AE526
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7853E80008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678010; a=rsa-sha256;
	cv=none;
	b=IYHEDs/b11JOhT3rXnHb3Wxaj14oNUdHAYRHDr97S+PQj6VbrqL+IinlVDy8kofHdHtWUx
	QgOhGk/h9Q9j0UDkJiaKeeTtQ/RASy90KGd0nMGCjvVgVmDi5JEQpuJOCBfmzPMNApeAQL
	wKmduZ1WXsZU+bWlTX1dKHLvxdT4nmY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGHtYMG+xT81XnTJ8iAPYPR6rQe/EN13tUJDqCnc1WA=;
	b=G1UjWWZB2AG53V5OjyuIKh3JcsvtNw7URun7vzjScaGHYGVPrPACFP+Ea78ZwBwbHLqKyt
	LYc5TUp4U/LDfoBhgIxLc8dvAmLG/lpG6vnwoLBYrhLI+RiLzgfizdPSLKDcKIdP69aKhk
	Ibv1punMX9vVfqGc3DYFXbJaD54IA2k=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c6KBW05Dgz14MQG;
	Wed, 20 Aug 2025 16:20:03 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id C53A318048F;
	Wed, 20 Aug 2025 16:20:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:06 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 06/12] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Wed, 20 Aug 2025 16:06:16 +0800
Message-ID: <20250820080623.3799131-7-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 7853E80008
X-Stat-Signature: kgjxwdwbjdcarxfkhjkq37uo1wtbd3tg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755678010-526256
X-HE-Meta: U2FsdGVkX18ARVtMRtqs871MsH64XVaTVdy2WOCJmlORIRzhglOZOVQJFkm44Sd24+QnHS9wobprRwZOMGPOtnDGMeNHeyv+s1s377b2UtitHOz8AnLS3ZAhFPAkat/qW2+1jKRr6xJgd6R6zSw44DkbQhsjpHzauGns+TbzXQNdF4shrkEjlnvhsMVIj7YBjHyoX64tS4e8is8ERR887Hywm7PMaGjoJGiPuRN+Ni9RwhlkR/We9SGlsi34qdrjBL37jZcVLyxtqh+gQ1egy2DZJg0Y03J8n8rJmLzh122st0HPmFub1fF1xpJuo2zr8xLcqRl1fIoEMoZ2bOkfonnAzHoa+W7izLhGyfUta5LTsb9pEsuH//QXWjBG7rI3e61XcKruwIEc5cDsNr8EL9el+242WJY5+apiS+U1RG8AHGF9CwcPkPoQbNWB+9aUrF0xYZKyxz7AIHZSVrcxGBlhR3cjHyVs1VomIvuS6BdpX0xXzATgW3LvOANRE8ws9O3eL4yxaLCK88z+0gY6SjPDDUZlDyuTKceUuseFijKH/bdf3nvHBeQqT7RggaQSigSvQMlxawEbUdJfD8wlVnnLJSSJeRyCLjPHdSdN2SNjzUQReV8sx7u6qLPFfnNom7vrIE4dzgTfnj64lbgGK6rkshIZVd4sUTH6k/XMk0FYydfEEVKi0XnDXxAFjHUQl3tviOBZwnIi8NV8sv6PgQxy+ZxvGyqjmple1MNoNjLQ7yAmZN5UmxYhckVC5utAhQliXtQD4/x/0MfvOePbF4QuT3Q3JjsQyR0gnSuMjHsw50FhL8+isa30OwbxrfIo6jnnCqMUofZLeTaH7D+e82+yRr1yGYY9GLwi1xmMqMalyoOu/dKVo95hANJI/U5Xy90uOagYDW3n9UimAKao+x3HGDlsfMxJACuAa6iAiJCN3dImeQ5DA75R7frZgtHQSTG+88UTcorfbgJMf2D
 /IAPyRqf
 SkDKR
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


