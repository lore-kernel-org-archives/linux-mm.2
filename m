Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22EEDCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3738011F; Tue, 28 Oct 2025 02:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ABA2800E4; Tue, 28 Oct 2025 02:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E83E8011F; Tue, 28 Oct 2025 02:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDB1800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:18:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFA3348CD5
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:18:57 +0000 (UTC)
X-FDA: 84046519914.30.9D69609
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf26.hostedemail.com (Postfix) with ESMTP id 32256140002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:18:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Q0zkTcDR;
	spf=pass (imf26.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761632336; a=rsa-sha256;
	cv=none;
	b=PV5uQGsReeYdtll+HYVODEpdbAicJYckho6g+yhpkTZmtkYS95KZkfBuGflNE7a8gG0cbg
	N/4V3tWfo5kDMRRnOIh1V0xa9jTFOzKVJyuIJXCansL2ObClhcH3tKe7fXVuFzqCQe2Qje
	PHgR5jnSOFviU+AnzackHYxklfpQmIk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Q0zkTcDR;
	spf=pass (imf26.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761632336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Xq9ZpBKijRP4yN0dW1eTvhFf2QVdu1P/bLYVpE2xac4=;
	b=XxgCZY2ew9ZfNPFzSRaTmbY9t4Wxw9tLjWJFSaLcKNGwpBuHIu5laYfpY0gqZvr0ZkjBr7
	FwnxL/C/XbaKB44qbBemwLkwMLAWP/GAmgIQjtQzGSHHFPVFAh/COa/FVQ4uHsiA/lGMdr
	StvxVnCyIBm1//rPRXwayhHlof9b3uQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Xq9ZpBKijRP4yN0dW1eTvhFf2QVdu1P/bLYVpE2xac4=;
	b=Q0zkTcDRWzoy2qrLKW917T7U0pYBoZvoP+MlBy/OSKPYNdKxaJLI58w5moDfgBIUk9jUqXyF2
	u9/Cuuw3E29oFpSTKnQNPBWxdV9+opsJQreD3AtklCeJT7zqWgXUP6IHN1cGUbHVY3L1h+Kv5yb
	QHr/QpepM3Q34x9FoTwZLLc=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cwgDC3bNxzKm6s;
	Tue, 28 Oct 2025 14:18:19 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 9087F14027A;
	Tue, 28 Oct 2025 14:18:47 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 28 Oct
 2025 14:18:46 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH] mm/damon/stat: set last_refresh_jiffies to jiffies at startup
Date: Tue, 28 Oct 2025 14:19:27 +0800
Message-ID: <20251028061927.1378746-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Stat-Signature: om47n8s5bpriaf4merqmtyi63uiwkda1
X-Rspamd-Queue-Id: 32256140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761632334-719066
X-HE-Meta: U2FsdGVkX19J5qmyO2omarvxA7B1zsBjnbs11nuW2fuDbqe3BRB65u0KCcvtPvrmw+AUJr7NxLYhY+9ipb2tFQCjiX0GH3nu1RA3F1K3zFCNmImBmWHQVJKvRkxWHuzqUBFerA1eKxQz8QBdl62jLVm5sPDCGv6wy+G84tdU5i/EnDX+JrV5011Mh7zJ2IpjhLlWGR3G/6ZbJ6VYj3qmH9f+yl620MhaKSLuN6KjIxOCc/eNwnGI39Loh4BzAd1v8NiZQSZ6zSzPQ9kd9kXH2TX0tb6rUnBbvLi1C2ACKkZBxKOJaZE3YheKRSOnMziS6fYjwCn1jrO7AsOdkzcCT7GfZr0UmQyuVcW6iS3K32hpJkdzjaZsOqMZXMmHJBV7+X7NQDNCWV57TOfZCnnqqoU5+c9GMN++1QJaFuLf+nKQ/pvmZO0Eyai/lyfeiOgF4JyI0G3xxT+3yEDVC7Uy+IIy9Clq4Npm1mBZsy0UjzGXc/jtvfI2pWyKMAu5q1tJWSbxljGf+qcZGE87I7CzB7OuVuGt+sWKm1P9jxg/eDkfG/wZ/h2QEkW8CSdm1i01yhvUP0zmS+0x8YWhAdC3KMdkNA1kb18kYPmhi+qC6IhxN19oaEwFYbMp6fkRRtwPTkX3H+uGv/PY13o0bj9oxqpnutaUnntOsrZ/MmKiG4hey0wA1pt16+Ny7X+AxCfLt7Vi1L9KOZZD8OcnXi8G8lXOgLtrgMgh3bhFUhBhkoUPmOM+zl2DJiwYd90Ss7ItaTFNoETb6wOCqUmCUoqwEjWQF1FHZJSpsOI30nXoRT/yS5B4V7pUS8AO76lLigmt05E7ZqZB30rbmwENfCZX1qBOBCH5CLGg623ixnBV+EDAR9JsiI8JT/PWKYRBc43A0lg+0lDHifHt9DeYPKwRmWNxfszYNgHcfxV/ZISLq0sJRWuZBDKzbbYWyG7U4jwkOvHUCRHMEEtuUNVzari
 dCHB5PRK
 yqSHxKUkWkUSBrwZ4/35k7yH6sQgugJ9dm3H9zu2IduDOyUpN4X6F+LOXhGnhWVfBNgEQffczn+Hjdtg+ymzlI493S7889tQYNI1rwc3/krAB+sTBZNnKqJTApxqdBZAG8JryruZq87Je1KAjYIxNm2X5N+NogObP7SZLWRq4ou5XVwOEwQ3zE/oQ0m1i4y6WFhOYrvvj+jGWIGXoZWh5bgw2Vh/BQAuXiExI8vbkaZqsM4M+USHFyOTceEP4tI/iWomDiH/Cw1HRPZgvES+uMtzdJxwafj0cikbuow+16e5kGwUQ8H0qSWk1JQ5sw5boa9srAFokBGGoMWateQ2qpkCS20hnWK8z7C2GtVdAnfyFcpVvyy+hmrQJ4LTg8mX3dBNK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
avoid unnecessarily frequent stat update.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier. However, this causes time_before_eq()
in DAMON_STAT to unexpectedly return true during the first 5 minutes
after boot on 32-bit systems (see [1] for more explanation, which fixes
another jiffies-related issue in DAMON). As a result, DAMON_STAT does not
update any monitoring results during that period, which can be more
confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.

Fix it by setting last_refresh_jiffies to jiffies at startup.

[1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com

Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/stat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 6c4503d2aee3..6dc3e18de910 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -132,6 +132,9 @@ static int damon_stat_damon_call_fn(void *data)
 	struct damon_ctx *c = data;
 	static unsigned long last_refresh_jiffies;
 
+	if (unlikely(!last_refresh_jiffies))
+		last_refresh_jiffies = jiffies;
+
 	/* avoid unnecessarily frequent stat update */
 	if (time_before_eq(jiffies, last_refresh_jiffies +
 				msecs_to_jiffies(5 * MSEC_PER_SEC)))
-- 
2.43.0


