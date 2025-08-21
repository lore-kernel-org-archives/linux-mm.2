Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EBDCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0442A8E0023; Thu, 21 Aug 2025 07:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66B48E002B; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40818E0023; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 989708E0023
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69090B8960
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:13 +0000 (UTC)
X-FDA: 83800485426.28.98652C0
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E9EE1C000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGHtYMG+xT81XnTJ8iAPYPR6rQe/EN13tUJDqCnc1WA=;
	b=pmlF+YpHOVT484cHEHIyTnkozFA6fLo5OM8Z28DanYyZJ4AQnzb0LMLMhzIjpTWn/W2olz
	+hJym7xY7LeSPn/SywTOx0OtUyTJPUmHprsakeIJlcbewu9nE2Sabeb3heMcfF9vCXW8LY
	kvnIYVB8HK6TRMOxMdpoCUeEigO3c0Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774371; a=rsa-sha256;
	cv=none;
	b=Uuxo7uOE+mo1mjRPwzIhIe0tFCVlodHK2YyDO1vCVl2qO1VqpnL7899S5aQzR53cfAqxIV
	nyzZsk0JZtS6lfklJTdjkskm1OSBdUw6sLENvHmZKA/wqzmOepHkPdEL55S/j5YAuC+Ir7
	rhEUYYzHUtafTcEDVeC8ADBx6v+VR7g=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c70qB47mtz14MXK;
	Thu, 21 Aug 2025 19:05:42 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id D71A41402C4;
	Thu, 21 Aug 2025 19:05:46 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:46 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 06/11] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Thu, 21 Aug 2025 18:51:54 +0800
Message-ID: <20250821105159.2503894-7-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 2E9EE1C000D
X-Rspam-User: 
X-Stat-Signature: ipokihkb7pr5s4mf1h5a7gbykrypnpm1
X-Rspamd-Server: rspam09
X-HE-Tag: 1755774370-563637
X-HE-Meta: U2FsdGVkX1/stft3owt+kCh7c9tIISkTZ+X0oOP7nZOjJQElwRkzQjqTSG93pLVPktxT8JtNe942Hd0XaPDl3VB3viwahG4LqeBjDBJPeAz4lRzIluQ4OG1Wo8XzdympCmlIjuT4Z4fhlyLXSOFYAzLb1pPiDcWy0nX0rSI6TBblNSnuYYiVBwTShxfIEVmPfhBRcccRLfkhwDwV349tnJ1TOjlnQ+HuIc1KRpL0/PsYuSUbkeXuxeJo6ZdIrP48kJ2HPZeH/A5ll1yw+LaKbHnKNDceHdZZOev7VmUy3F9aBgdk+sUHp/PYk2oOhP8YBuoHrqhJ82MTg6kJhQJeedj6iZy7xiXfNDSFYPIdnDHAisfp8PGkoaW0Pj/oQRNXZrZEy5e39MXOKJg+VULNUJwFrpiPg8qpuihOer1jbg9FUUVOWZg52mYza/dCWnazPPZmAIfLokXn7XVtPaozBVgpyAh+S7G80pEZDtPnx73som4ofhov5Z0F2Sqo3beLw/gH1eAhzuqMfo8Ay9tcMjisZa3PRpX2UuVuHzVyav+MqHbsfOnyJkPkw+3KePXSaP0lszF0JDgbPxt9oHXaPRvuT3uOY0YefGrGn/ZXqWjvue/yQPhnaKhiRvBrmBbcYfyuzruEkj/uz+Na5BZdOF/cqsDC5w5vK9+ffA1yhzp+IoI0ZHBhTZ7POzRmiHDr+SUKPODXhk03IK+TY8lqdJGqZxTyZiZAKRYUfsPiKyX/EGJANf5Cw+1716FfL8ft5mMbBoPWmscaSI1VM6Ilw8PaMUMO9gAIxuWyxK068Cg0GZSfte/2CnS9KUlljbPXfEiWNoS86MrcYifs8fy6K8KdDDcXIjo2BVIiIZza+z7kdRyTCk/w+hkVzoVsFu3EdO4K9jnprkqqvIqfKIkKwPJmGAd2Wa2yzXla9FBSeKlKR4oaWT3x3NRD29MZ+k8DlihvhWkcChZrl7+ZZnO
 XUqqJtEK
 Xj1WYbSzC6rCaSrcYLoFkQIHjvxTpVCfjbO+XgWbWRwFmqJoyOfiCjK8zVMBOo/UgYACBCZ/gEdXr5Ol8H9nc9d+5ci9TMLEZuP3yNE2a2HQSsR575FTfd1uzeq+jnxFH4zZCDdg8tsYg2BNhhmX+M740K2tnIr0+RYJ/79P61Bf+dtEbwQjGBU/YuGT6he9tpWdrfL94HUx3t/ENS4Wl85tdR4FymV1P+Zwg+YgNaO5Vh3kwL4ot26OlSdjc9Y3nZGjte7/cHgfK2Ss9LhAz0MzHF5x49qVbCmLsPWJU0kibOfM=
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


