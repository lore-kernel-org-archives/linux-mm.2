Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54EDC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60836B0095; Tue, 14 Jul 2026 23:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38506B0098; Tue, 14 Jul 2026 23:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74736B0099; Tue, 14 Jul 2026 23:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D63B6B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:10:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F094A05C0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:16 +0000 (UTC)
X-FDA: 84989532432.02.49A8AAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0189100009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMMF0rtj;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085014;
	b=hstkWJgSdArknfk7JsMCVYZsEajIpqxJTXqshef2YQg3b6VujJh7XHef6NU179p+ccBY1k
	Sw/BdLs4XAaUdUCWCvqv4zTcW7f51f8ui0Zer5r5loewzkdxCVSq6Za0vEqnuS9Z3b/zE7
	Unzb6JUEvnZTQgWYqt/Go3oYuGkqk5M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMMF0rtj;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZlM1xLtscWm6r5E9re97Un+lNNnhMeBCpTniJTuHyU=;
	b=WWvOUqZlkEhGZ15q0hOan4OcDEbMoiOLxbHDyfTO7yRXHvzTezDq0Nv3iFOm+LAxAJZqDv
	3vv/3qs8ACrgI0osKVGiS3Y4BpOIUYPsYrvGcpGVKrwEg2ax/x5xka9abgLSWfgVbyWs3L
	OsLmIGIvNfr+y2QtQB910z1GW8YEee8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2692343D5F;
	Wed, 15 Jul 2026 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AAE1F00A3A;
	Wed, 15 Jul 2026 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784085014;
	bh=OZlM1xLtscWm6r5E9re97Un+lNNnhMeBCpTniJTuHyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMMF0rtjKzOj0NNvQBnEZPkh8CNIg1ZQIhxvDGhbBTy52EkzBm+3e/8x2Gnzj6Nsf
	 6JdD3stcnyBiFwEMkFGMjBoB8/1rpHvUZEJIp8GfgSDkdu5qbhFDbhc1rFv6FIDUdb
	 I0oASfLvYVVqGqRlhbySFBlqa/S6A2xwZtSa6v3RHhl7Z5R/2OkdsSuCpphyhzhK5A
	 oZMVmL7hEPWSPhDuJInt53pgNVmyltHbjgSiDItpav0q/hMrlqnE4f0tjzEmPrIPp4
	 THGzI+Km+xtK61uFANf0yvaKZxb+YJpaqcz4xaUzCegDhRuAzJfyxmTiN76AGEoGiK
	 I5wFy6TESpYIQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 5/6] mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()
Date: Tue, 14 Jul 2026 20:10:00 -0700
Message-ID: <20260715031002.108504-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: <20260715031002.108504-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0189100009
X-Stat-Signature: y7bqw4wgps1nqxwztg3585ikc33zjne1
X-HE-Tag: 1784085014-996157
X-HE-Meta: U2FsdGVkX19ePnnSWIcvZYk6IzIBakMaQTMJBf209ZPdaC6VfY7wCrOtAdePnmJi8DEHbk/jWgsNj7hnHhXwzd9rXlgL3lH//orDrbaThp9F9M5Ttfxa6819lb++dboSrzWQEM8bCATv4I4erQUEFE25nj38q73Gwmqj5HdxTP20sS1IxoPSeAmVx8v9zCPO3SW0a0EGmEzJgP+w+xK1GM9uXXv8lKPVuAXIzZ86RCnyRNKNlNHS41lVgk/LJN1PMcqcIy4MvD1AQJRwGUtii7nBRkt9j2tNg4rFFgqemrfm1I/mt1EQVOASKwdzA/jWnPeSAZq1xNza4LI+zKtew05b8+k/xqRpTMjEXwOQrL3Iw+W4Gg408fFFnYRIOb5Th5Gj3Q9YNiIBj2900Rr4RT1XHhgNwhy2eTVHdXpG1jCN4RWUEfbpOP1q//Q05RI6iJSwjpie15M/MEzYWo2FfpnQMtOUDf8D0FjzWpkiY2qau9ktUSrPjpcEqKPP9MQBvSRUK5x5S9zt7H8tmGrVw5xtPCR+C1wALJxVyjk0KMolhRQ3gqEmleRjNxz5cvdc5sQpq0K4bxKuHGGVkNNLL9vVI7NCUNdRgIIIIVOberCf2QCwzzxf6nfav7dv/U9mfv/KceTGXncVCbU/TgbzZNN+i5ryHYIj9M1xfCePpnmMhjY4h8iitC30pJXvo9e9WbUvZ6uVJEbtLS+2sZx7/GqILZgUzvEPm2iZgAoovPCjYYpWSr3Kb4xy16gWmP5h7299ZTbb8eUpn+wzcLrJm4FKAYLMX7pHlDld4x92wfYazkZAKrmZNCuP2/XwrqswpUXB53kXrr8ktJs5MfKGNuofwVyBc9qDz7uKLfjV9afZMxpoJ1/tG8INCt+6Z32XKvaJOR3QUOM66JT2lAFMbVGp0tMq8hn+h9X78sI3A+sEpADQrX6qD1QZT/PpI3hIzZoh7YY2NfVKZUfsaNA
 tzfifRSF
 9KyroQCZ8FJFq3mwAHea/Rc+Sz0iS8RTULNbTb6rJ+U/fF3EeIEYWqV0h35oMdjrJ82GNRx1BqoEZY9fA14bv0Eny99zBeN0geJpbjRLbJBnPibCu7mm2mZUcJ+dEtC8A+bzk77BogJpah/qF7qhoJ9CyXfKVwia01Gdawotg0/K7i522pXRxLO0HaEL8S3t68CuEKdqGGt5f8l4/ylSiOKoBRlO5kX1SXwFCJ8ly4709/8/VruoLfWAGs07BOdusJRN/vF3x1VYPz6zRKEk03R1hmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_apply_inputs() reads addr_unit twice.  It could race with
addr_unit_store().  As a result, the min_region_sz could wrongly be set
up.  Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, the DAMON core layer handles the wrong
min_region_sz (!is_power_of_2()).  Even if somehow the race ended up
making a min_region_sz that is different from the user's intention but
still valid, only monitoring itself runs differently than expected.  No
critical consequences like kernel panic or memory corruption happen.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714142950.100711-1-sj@kernel.org

Fixes: 540a2aebc657 ("mm/damon/sysfs: implement addr_unit file under context dir")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b5fe036f78015..65a502c7746c0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2099,11 +2099,11 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
-	ctx->addr_unit = sys_ctx->addr_unit;
+	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
-				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
+				DAMON_MIN_REGION_SZ / ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
-- 
2.47.3

