Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2726DC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B808E01AB; Tue, 12 Aug 2025 23:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC9A8E01A4; Tue, 12 Aug 2025 23:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CB08E01AB; Tue, 12 Aug 2025 23:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C59C8E01A4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42170578C5
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:40 +0000 (UTC)
X-FDA: 83770362480.01.0301675
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1A727A0003
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AKYZrObwH/k/0Xxd4YgZbqbyEuIcDWt1rj8cQ1zkfDs=;
	b=Da5bkKXE0oVRKQRvmza5k4bppuSgiC335OhKd9U7KAhBJns0KC9/Mx2XK1v9pQBklCQZ57
	bbYCwIz+qA51Ief7tVmo30dF4ROdAwh8oJG5c7+jpbewwQe3IEN7L1STgaHLw2i2OmW1CI
	IMLqRrguRZnQ8XyRqtI5m+poZxKVta8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057158; a=rsa-sha256;
	cv=none;
	b=LmaGdnp2EeqDdCetYwveRGkw6cm7SnUjspC+8nrTQEHa3AmuY+HlN8ELKsAiAI5zA+hpMp
	ciBQ8mya3mYpIn9gG4yfZi0/mIa0cxUaxDwZyFXXJyClIo+vlwv+PSMRQJAAOeFe2dMRV6
	bz2c0EDLqMR2n48rAkT72gCdSMVnruY=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c1vWq69vzz1R91D;
	Wed, 13 Aug 2025 11:49:43 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id B40CA1402C1;
	Wed, 13 Aug 2025 11:52:33 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:32 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 06/16] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Wed, 13 Aug 2025 13:06:56 +0800
Message-ID: <20250813050706.1564229-7-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A727A0003
X-Stat-Signature: bb1h1n6xnuon4sinwzts7zqymxrizoro
X-Rspam-User: 
X-HE-Tag: 1755057157-35600
X-HE-Meta: U2FsdGVkX197Y5BcC8HYugSTVlk4M9r9dqUcjfQva3yHNJAfkYIBrhSVgy/BTJLUt+wvLX5pmpYQ5F+DMFNpZRSvHKCUXeLSYpGd8DooDSoHhL1fayUD2RBklS76DEugSrjTLEtmDvsX4q8tTm09wUWTTUcuegigecd2kgY+X9L0E8isGAu3sGyfrs1DQGT7EFFmjfGIa4JAH4FwoglbGiyoA9qCBMSWAr7MeZ5M67yNwMOGUeRhtbkrM/XQvIHecS7K+BuwgLd4bfK3AkuUshUF3+OLRgRUdeAoqCaHldeUiC7za8vH2oVB/tO37aQ5zpIM0joZ3SzxPQ6d4WhSkWhC6fghrJQK5RMWjxoBEXQczfwNz3iwjWi0pq2vgrNHTvl5puJMBt9vbObd1SlpyIR6zmbrLM02HwycY8c77+ZhLAMXGoH5LKNMIjNCQu1yEaGj9lZtVJ1JLcLLOkBr2R+iNCaIL1AucEtznqfs57uv+27f7ZWbdh+fbXWA3Af7os55rRHkNbAZJKkqTcgRSYSqBNOWw7OhKD+KIpECWx+iIuvhFJrVHE2vOHPEv8Lv/6Dl3QSBIczPeUR3v1yxPwIKL+x46bh0J/hBGrewELAgSpXqNX5UEuMQ9Oqk2nTuO83VlZCAsjJ02fJ9bTrLgknadLu8HdSDDD/gYN0QMYN6Ut9Fos5Jgg7gdWn/WW+UjhIKn+O8DpbbaEuymmLnfIoZ8f5mEc5mRg5eRdYLmYWWMlXfXglel2i8dGjgjlvgNqbmIPGlM/s9bwlzdyYSzE85nj/t4ZwsOfQClX055c5ww6TAXuh1w8qLh/jIPRHIF5/dd8nRqyaVqYip8mSJpQ2DTmD2kYu7zV7G8qjRWf8YjnI9ZCE85PlYr74tRF2alXPjM8gtzgoLhtYV1Vn6mkTneiJaR7xA3jVc4MRUNDzXrHMkam//gB2li2TMkuQqgca7dib448/iYCmamFx
 V19BnvSI
 QMcZ4H88o1S5kS+Tcf7x1D4pZMb3jx0c1vIGrNxv5KRFyJMMe43XsRHcj8C6rvQV/Q008P3smbeVOLQpviQfnqawTw8Z97VOet7v7c1t65ZTxgXfvlGADmmI1ADX6SrT1Wsfc3r9oVfvQL8mhZLP+IQpr9ALXgSK53oHfdsTT+H9VCGfH/QteJuykYL5OBt6T/HE0SOLvh6ax0RdGj6sgBKgjhd+8hGVL9tkwgDDS6fvac+0NQ83lvZ1LU2sSmy3Y5dKOd5wit0a/USE=
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
---
 mm/damon/paddr.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 76e1ee82b441..530bc9d3ce3b 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -289,17 +289,18 @@ static bool damon_pa_scheme_has_filter(struct damos *s)
 	return false;
 }
 
-static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_stat(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr;
+	phys_addr_t addr;
 	struct folio *folio;
 
 	if (!damon_pa_scheme_has_filter(s))
 		return 0;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -334,7 +335,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return damon_pa_stat(r, scheme, sz_filter_passed);
+		return damon_pa_stat(r, aunit, scheme, sz_filter_passed);
 	default:
 		/* DAMOS actions that not yet supported by 'paddr'. */
 		break;
-- 
2.34.1


