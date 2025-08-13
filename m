Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B198CCA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E598E01A7; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E9F8E01A4; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B8C8E01A6; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 152C28E01A4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD5AD136D18
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:36 +0000 (UTC)
X-FDA: 83770362312.04.5FEFE70
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf18.hostedemail.com (Postfix) with ESMTP id 848781C0004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057155; a=rsa-sha256;
	cv=none;
	b=YgSW6uvsKq5N9qu5OrRMDqJKhfjgHBhZTh88YbRTmKsA+4RuoxAHj44hUrE7ZTAmCpahQM
	ux1MbNPOaJ9Uvubi9qpCrfeZ9SOH+ZnWwy4P8VSX0rj9UxAcfH6gtMcz2c5GlqfBNTQOPi
	UMO8WeNM3qMgquD40exTtc+958YC2eU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5KCBeY5U4rXUD5EakCO5iC6uJ/ikWcX35GHXuhwgZ50=;
	b=DnVfZzWCcXg7k3Kq3Mi600RifiAy+wbvAtGzuzz+CVQQ6baYCXkK8QBc/9cBGglvsbalsF
	Q/mHQqWDDU+0HgUGkwUlEHe9Sxel5qssGP3WQ4xXN9eqgYwqvCz85QieC1NQxvizuuqxc5
	8XZ/wxQw/VVk4ELoqxKDVOC9rtn8soY=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c1vWn3kzRz1R90f;
	Wed, 13 Aug 2025 11:49:41 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EB98180044;
	Wed, 13 Aug 2025 11:52:31 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:30 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 03/16] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Wed, 13 Aug 2025 13:06:53 +0800
Message-ID: <20250813050706.1564229-4-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 848781C0004
X-Stat-Signature: 69eeum6hb375wt9yqc7pdnfkmqd9m9g5
X-Rspam-User: 
X-HE-Tag: 1755057154-440735
X-HE-Meta: U2FsdGVkX19mCY22ADD2Y2zgssK+zo911DlQHPlfDmeMjwx6ghURcahqZ0u2pLQjEPMiJbF0pp9PCOEYreiUhWAKLuOyC33y3uNAveVZNl20Ts8k8A2iRh36EFq9LmyyUX6KK45ouQkcpmLS3jJ9Fkc5vOKkIwVx31Ia9rbqMtB07q9FsAEfYf6jDZrLnksaonBp9YyiI9w1OoHLzokFN1S29OXJOTPZ8+ZiEzyVzV+yX+hawR9poJcb1lAMCVi8AgSPy5YqDHcFAjimepWpCups3SbNAQKzc8UqIAmitgxNvnS4VuVlFmqKvd/y2nCWw7+E/n1brkVrVNVXnouNihC72w1DJLIgNjCrnE8bNGyvwykMohXtNFEyAeZEIKbZz4XMQxTuWz8EyH+awLs/oTuRtA8+inT0+5eNldKDPIEeQ9i66nwoW3dRb6JQ1InDzsvtVe0Z5/jN4zS1mu6U9E36DBIEsn/7xl40T9fWXHPtwp+T5XBbglK9g0l5mjbqBMhJjMURqdiJbAmzaZGCvA0/rQDgoCCBGkA1FpL7CW+Wh1S/x5CQ80BKr7yAdFpE4S/X7vU8SQJhxN/HEtVYV5fY92VaNLQa7bAXNjIcAReX+KX3Dj3l7TKlXtptBv4M4QxqjvSSHEHQmcNcgnsW6L7rf/OIY+R7xUW2CT/0OqgqVvASOv9fDXZdCF8guif2So7HJezGmvkatjIOYL0Mp5YUZPelMkp9IES6v+2LEG3ggeVWHOBEAuJuLqW7l8tPoJuLmwTr6wVUsJrmmNQith5lsMg1v5/CWumsqxi7fLWooRVSzOuNuQbEezIcqjfvokqUET+5TKR0zXoiYrpYH3G8bkQ2tQhHPChkRFOAUxwjRpgL7DCa87GqGoBxcmemIWJAyxNPrqQ11sOlxpw6mGX3wDBiGFQULOj1mF/8ro2lhoh4gAdi357GkmdavAcRAMYpaFFFm4oI0arTtbO
 idcvyDpV
 tiw4qrSVif9SNOWmLQ6Nx9xpqJWqa1i0EsWPBjzRCiJKixPCYIp6aSeJCp7Axty6C8poHP064+PDl2wVSjFjEYOjWbk7VZPxIp7NFnlSdXfJ2CGlSgVfHyZfyWPu5TihGaWuIfpqyIpFkG2HQMhFaNxLGQwN6e1PGTfheY9UjczVeyVFpBfA0oSn159yY+oNcBcZ3/c3MPG4jbbvf+hI5b4pnXZO3gexFiKH3Wgr76j0s7oDDsmyTZjEdJjtKg2lAeZS/XOvJZfROxVc=
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
---
 mm/damon/paddr.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 345a0ae63b19..b548813a0472 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -135,10 +135,12 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
 	return false;
 }
 
-static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_pageout(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr;
+	unsigned long applied;
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
@@ -159,8 +161,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 		damos_add_filter(s, filter);
 	}
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -311,9 +313,11 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
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
2.34.1


