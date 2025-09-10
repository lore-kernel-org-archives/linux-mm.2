Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD592CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5FC6B000C; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66FF6B000D; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3116B000E; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C94CB6B000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F1C387023
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:32:46 +0000 (UTC)
X-FDA: 83873128332.27.A4F7A68
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id EBB7314000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:32:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757503964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZ5e2yLlJ7eMjzYVqpZ8aB9ZJtpGY5/ZiCl/kD/P9/E=;
	b=EZokPTXnUhF67EzKXoCFkdA/Mq2LbutrrIXO/WaJLWjf6mymyF7Dw52pU0CW04Jg6fHW0z
	0gOLrkY2P0iDWUonQfFqjHsEabGGUOV36ckiRrIJ9c94fWBKaxSXuAOMfGtkunzCDdo5OR
	oEzf+4KhZJ61zo592exT7T7jJfBRBOg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757503964; a=rsa-sha256;
	cv=none;
	b=75rR9sf59g06Fm101AwMBDopzqDUzojdRGJI2IZt5JGwDaQR08yZwc6fnrX1hy1IHl5nJm
	tJj7aI6x2z+jg4GcaoVWZP0fKPhaTxF2J59j9T9Hn99fNcFX0rkQLiAUmH3DGvyicajO6z
	o/cW9YM4xDb0isYc0PR8SpMBVYG3Fss=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cMJVP1cyjz3tZdn;
	Wed, 10 Sep 2025 19:33:49 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 08B081A016C;
	Wed, 10 Sep 2025 19:32:40 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 19:32:39 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 2/2] mm/damon/reclaim: support addr_unit for DAMON_RECLAIM
Date: Wed, 10 Sep 2025 19:32:21 +0800
Message-ID: <20250910113221.1065764-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910113221.1065764-1-yanquanmin1@huawei.com>
References: <20250910113221.1065764-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EBB7314000B
X-Stat-Signature: 5tthnibxe8fwjsoigpuk1o3y58rdait1
X-HE-Tag: 1757503963-283027
X-HE-Meta: U2FsdGVkX19qohLlJqcz50CJX5OLmsJZVv61LFy9+xnZoDzc0VBO6JH2W9dlelVKI//dPWvad4RqtCcGwZYb+RHPlaQGNPMIAlFElsqLdmprlTYRIOXUytvAPLFsuYg663N8jDJFrS7sP8qAmwDdSDi+Zb3vuWJwKXTBclFZgnj2sVPhxYJTZBoqXOZal+pJgXa5qerfRG0Qn5Pmd6SrJLjKBv4O11Jw861oGyf8QkYeWfM/9uTm1JvIKxp1pp9wNnfWOThlSuhf47aVmWA3wH+t+Ef82iSPbpI2hvXLtg/a6PTq8qrwtzGAAhWvGDLrhDFuyaF8i/txNTAr6mxkuZP5gvoApqfhvNui4iTohsssiZyrpazcfLk82w65qH/zbKAX7z4yufjpbvAN61nVyhP5J7p6nHX2D+WnhoRxxnnQZF3+StHTYBCN2CPLPY9mun2nDyzXoD3C6riSkHjJOl+bE/n1MSgjxiKrGFsGJVktC6CnN+vZszdKFjq1gKaa4ZVFWT+SkwvMPZ/uzww1iECV9/6z7ZUkzT59GHc1Yae8jJP40UAxipX8SIPvFovyNsJ7TOs4psLGjs6gzEqMIbBASg8GMLxaB0R61wbIDIKqFnp+5R9ENS1Z8Z4X1GmjIdG96LpdTxmR4bzX9wNUFvFoV+ps1lmc3ycL4yyq9ZZChaVie5LcrF/OeaJVWsH3wg4DBL+zx5kfhIUcDrN4YUWPcn8lPxjaqYPKIkfDWP3tgDaOUNxo4fu+s5/Uk2nXAA88PPMOEZC4qCFLyKMQaf2026IgS1yeMa1w/mJXNBnagitsYzSTa819xLKOPLqmSe8GfrRRbEzuwl9SXrRuGQGUxEm/Hb/++ibyjmwKhBidj9PjAWy8IxWo/L214MJuGMa0decziC5cj0rVvvcZeZBmigB+r+fqK68/evJEZq16L/s8to3ix/eootCzGPi/e0/vQya9MQ2keXUbf6u
 4WKglzu6
 xHxtSM3XuymrEbwLPrbmKLr4H1upmtsBi7qULrkzbWK6Qlj04L1xNqR5nxnUtFJhYDiiygTb/i/kGRmdebkaIVs7MUI4jmWSpa1oAdmsQjJADRONL/Rd3HAye0y6rVJ31HKwSY+jotsSdIVB6+JLU76ETcZ2xxHNVewX2j4cmNZMd35IoUI/mTKL6RJmJnJEAxRsbDjU2TSzVfAGPMhXwUbxdQ7zJXDVcNmA0PsVG4+nx+fw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs file to expose addr_unit for DAMON_RECLAIM
users. During parameter application, use the configured
addr_unit parameter to perform the necessary initialization.
Similar to the core layer, prevent setting addr_unit to zero.

It is worth noting that when monitor_region_start and
monitor_region_end are unset (i.e., 0), their values will
later be set to biggest_system_ram. At that point, addr_unit
may not be the default value 1. Although we could divide the
biggest_system_ram value by addr_unit, changing addr_unit
without setting monitor_region_start/end should be considered
a user misoperation. And biggest_system_ram is only within
the 0~ULONG_MAX range, system can clearly work correctly with
addr_unit=1. Therefore, if monitor_region_start/end are unset,
always silently reset addr_unit to 1.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/reclaim.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index fb7c982a0018..590f9d6c55ef 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -128,6 +128,13 @@ module_param(monitor_region_start, ulong, 0600);
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
 
+/*
+ * Scale factor for DAMON_RECLAIM to ops address conversion.
+ *
+ * This parameter must not be set to 0.
+ */
+static unsigned long addr_unit __read_mostly = 1;
+
 /*
  * Skip anonymous pages reclamation.
  *
@@ -194,6 +201,15 @@ static int damon_reclaim_apply_parameters(void)
 	if (err)
 		return err;
 
+	/*
+	 * If monitor_region_start/end are unset, always silently
+	 * reset addr_unit to 1.
+	 */
+	if (!monitor_region_start && !monitor_region_end)
+		addr_unit = 1;
+	param_ctx->addr_unit = addr_unit;
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
@@ -294,6 +310,30 @@ static int damon_reclaim_turn(bool on)
 	return damon_call(ctx, &call_control);
 }
 
+static int damon_reclaim_addr_unit_store(const char *val,
+		const struct kernel_param *kp)
+{
+	unsigned long input_addr_unit;
+	int err = kstrtoul(val, 0, &input_addr_unit);
+
+	if (err)
+		return err;
+	if (!input_addr_unit)
+		return -EINVAL;
+
+	addr_unit = input_addr_unit;
+	return 0;
+}
+
+static const struct kernel_param_ops addr_unit_param_ops = {
+	.set = damon_reclaim_addr_unit_store,
+	.get = param_get_ulong,
+};
+
+module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
+MODULE_PARM_DESC(addr_unit,
+	"Scale factor for DAMON_RECLAIM to ops address conversion (default: 1)");
+
 static int damon_reclaim_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
-- 
2.43.0


