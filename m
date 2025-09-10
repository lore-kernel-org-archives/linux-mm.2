Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89FCCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD206B0010; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47B996B000D; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BEC06B000E; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAAD6B0008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCD0DBBB64
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:32:45 +0000 (UTC)
X-FDA: 83873128290.17.3EA749A
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2ADDF40005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:32:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757503964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7k/bXSXOBK0qcaN3BWg66LqBcrf36F3Eus4DFI+CvJQ=;
	b=d3QWK3c13ju/Kr3GownJ+r+Cc1N0pwTxM+ICr5/nXaWzHkc6yQUnXeRInlxtJ4opCHG1kH
	RwabhCdTl1KKUtsF2uZzzAeozzSREgA+9m+lYqvMDhOQAbPtjk7MZXmonmwMdN5SqLRJTM
	rxow9LC5pVZtZMKCEYhXjG0ApHrCh8A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757503964; a=rsa-sha256;
	cv=none;
	b=UNn0yxo6IQi0FTzNpCeysiBDZWNHbk9TzOnIp98gYg4KbHY2KgKmsbz5qe0aosb/XEx1jq
	+7Ej8SKAuOrM25WTpL6tBDFmFyno46uOwpowFcGr6gnX3p3w8YOTMsCHjFJmGLSugZkyUN
	8VRfKf1JfH88ngzxo5YwLizb6GExIuI=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cMJNQ5gbqz13NGg;
	Wed, 10 Sep 2025 19:28:38 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F02F18048E;
	Wed, 10 Sep 2025 19:32:39 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 19:32:38 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 1/2] mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT
Date: Wed, 10 Sep 2025 19:32:20 +0800
Message-ID: <20250910113221.1065764-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910113221.1065764-1-yanquanmin1@huawei.com>
References: <20250910113221.1065764-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 2ADDF40005
X-Rspamd-Server: rspam05
X-Stat-Signature: k9ouwcgsu5zcgdnhxrhjgpzwpjeizfyt
X-Rspam-User: 
X-HE-Tag: 1757503962-982608
X-HE-Meta: U2FsdGVkX18hIpyLj0dpR7Phf6sT422YiUJeNcA7po6x+fDPGNVrityBGv5r1Dn9XElyPl378R50tq2u81shoZydrR7wrKXx5cPfUmfgI9Pb29EG6rfOIt+KRlp5HD9wunbExXAX+dfrYeXehQjGYGsnxRhMkjVplKJkFHORuuBwn5HQbrWdPVqzDpqk5Hx432eDrFAIlGC+T2xHt01ngB7zfvdqUPBEdi2uDecAoEvfY5RR4ijOLP/3ig1uB5tz9LF3i15aFtX5HrOK9BJ1Q25QoKWSKBJNza6fAT8nowXGMw9KJxTj5JUh43NP9biM+W7vTlzkkASpRmX+Fbb6Gun/lOIF7eSBFZmvyJJ1D27lipek+8ZjSLaqp7IQDE1v5TmlkBESW1DZiIXgTMQIEgFR+u3v9yz1MAXNHYJU5s6lcfMS8D+EQxPRXlcgOb3cMuKAqPsRoIrzMq/IlRe1Y66cm/gKfsb1DXrulJ5GHWqTx1NbTmY68OZ19pp6SEU4fZ3XwmjGXscA5MFF/FCquUX+LWrY2aG2inKYytRWCB+gLpZ8bt4+2PUnFISWqremlzAN2/H5mDbxCLeDeBtrSdNfTwHrhAg2Md0tZnPJCfCVhd0gNuI6ty+YT5rhc4D8knWErLmNFVns7Aceh48ffxazrKMrmikGZe/atSI+Dphl/LZxNJ1Hssq8xeY3CQ8ettKk5en8JPGmynv/xMy/YxMcXw8evxJM3XvLXbvdvdvstb2wDhtwJdIOJTA1J1tMjdVBHsBYbo2BWspBchqzTP/gKUqJstSW4cbnWEY8cvGebiZ2LPYouaYLbLhaEfksPC7BACWq6MW+F658Y8S/+PXjr6sxd8y6GXoLJ7/v4HsDKkjRgNuuspSzchfc99pmQMLhDaAF62jiid+j8cbGb4OV/xZd6Fj6uesBHAtqSlfMHKPWCuq5xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs file to expose addr_unit for DAMON_LRU_SORT
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
 mm/damon/lru_sort.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index b5a5ed16a7a5..14d31009c09e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -111,6 +111,13 @@ module_param(monitor_region_start, ulong, 0600);
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
 
+/*
+ * Scale factor for DAMON_LRU_SORT to ops address conversion.
+ *
+ * This parameter must not be set to 0.
+ */
+static unsigned long addr_unit __read_mostly = 1;
+
 /*
  * PID of the DAMON thread
  *
@@ -198,6 +205,15 @@ static int damon_lru_sort_apply_parameters(void)
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
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
@@ -290,6 +306,30 @@ static int damon_lru_sort_turn(bool on)
 	return damon_call(ctx, &call_control);
 }
 
+static int damon_lru_sort_addr_unit_store(const char *val,
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
+	.set = damon_lru_sort_addr_unit_store,
+	.get = param_get_ulong,
+};
+
+module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
+MODULE_PARM_DESC(addr_unit,
+	"Scale factor for DAMON_LRU_SORT to ops address conversion (default: 1)");
+
 static int damon_lru_sort_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
-- 
2.43.0


