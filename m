Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2930BCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6D28E0030; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F848E002A; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0418E0030; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C11B8E002A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2D41588A9
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:24 +0000 (UTC)
X-FDA: 83800485888.17.2D0A875
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4EC4D40017
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6cvRxLD/HynLXLH2prU43m5M2h2d2eDv9oNKz4GIGc=;
	b=Z8C0eXZarHX6BtRQ57ih/PQrVBOZNNtwCC/53eWYNgFyNHmFLMyrAX34icOKujQ+kNzpEV
	kwLdEFMaRn4tbO+CnpS7lm0yKpyvnDnkchuiFNABl1tIyRfhzyAiO9ilEjYhcm36Tk2QPD
	GvdvqWomsSz+N+KfxDVlRsQDYuDYOMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774383; a=rsa-sha256;
	cv=none;
	b=lDAyGfzvTuZA3NDXnJgTdjJIFiZfVAdD/eMwgoT0mcdo6stg3ULiasNtRYLfEkX/B6r1v5
	90b31sZeyLFDSo8EZGCy82CSQYwXGe4WO5MSOylokaXZ51sTTHZK1GO98CKSgmKfrnqVdS
	oFpdaGrhacEMXsX1oPcvgZKf97SdL5Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c70rY0Ljjz27jHN;
	Thu, 21 Aug 2025 19:06:53 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A7F51402C3;
	Thu, 21 Aug 2025 19:05:47 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:46 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 07/11] mm/damon/sysfs: implement addr_unit file under context dir
Date: Thu, 21 Aug 2025 18:51:55 +0800
Message-ID: <20250821105159.2503894-8-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4EC4D40017
X-Stat-Signature: 4s34xu7tyurxfzkz3ohtrduesxckjjmu
X-Rspam-User: 
X-HE-Tag: 1755774381-957878
X-HE-Meta: U2FsdGVkX1/W1UTi1qtLvjL5Xk59d+Ovthe6NQj83iHwEqBcf4vphtu0e0onf2uuDaHlWQfKnI6NvpbAQLJiKmNMmP6lqt7qz3+tL+/nw06UcemdMBtPTxeXMlzaSWKdeE4c8czDTTQDG6HxiHO9MftIy4+hUT7D4jTx7xa1O2/A802aZLypesRimzrKKGAjfZZ06RK12x/2lnUvyDXL3IpR9NtN2JjosP+tYtq8sZXoUjcWoAdyAjJC+jsZEgnY/60f9AK40+vWfI148X8aIl3ggHFvwOLV54Rb1kGYTEllVhqgEYrSIKaFXIO96W+s1bzDv1Uw3I4qp5FxHNI/d2483UQhUSy3scpQenjz2owifPwe95ROkjKdT/OjSRmllDIoayk1978PG1zdB9CIefVgW11F94t0wTSCKHqgDUSthGMzY8/xG9YBDUkknz6Kk6APX3WyNubXqLLAGeOwZ3zHv+K/JXcVTtOZahPYtrwVnRGju1osJfSKAxuVRGNTtlkNBjK/W5QgfIE2vKvBZbGK3CMMFOFp5fO8qmd1A09A1S6NY1GIksH+VHaENs0S5Hc3yqXvFc4fG6bdKpOia+BBpnjk4DHylpcSc7gcPqjVsEnLzNumBPSvpTJKJC9OB8+Zp5H6L7mlPBlxYVWP4zCNMFLP4SmV9Y2JjGRwN3B29tGtQzSzhYi/hWt2EMaLQgv5tyECHOSImmYfnMCQp5X1/GRfOywrkSZ4bnPyHcFL0G/0WDU66b3aWeZrp/gm310gq4Ggg2IE14PegDNi2ZGSMRl9R+9ArxV+a1wOg+FPxPj4Xb6B/QORbiga5rgY/2rVBgxMZLCk2KSSAmIA/3+rt/UeaxK+Rouskmi23fd+qeRa9OPCbQgQLnP52t6C0EIWBbHt2HWroLOEkcfiiZfuj2sUwcenvBJw0UIXlQL7jcgREByMaTPWbQgXaj8n4lmik73ldbdvmFATl0Z
 ZVvWEKgs
 M+mqtt60OrUDALtjUGzanjnoMIK2Cq+T9ceWarYv32T+mr+JdqcgtCiVGbEVpZIRzcZfXO2IxIbgntj+H2wctI2CvbwHZ0fc9VtoAf7/bu/DP1iRBQ9ozT4k4rMC9tXgqoq9cYqW+N0FoNWWSFPGkYjoa8KfmoxbmKN6oynOa4TZqJ4gG1pBZx0fuw9bqvPXjW7QncXMvhDx/Q6Rxs8Fgrn6WI73vHV2HcqxyZbGKxNUfMe/5dxWPi4qCByQnHq0Rrx2b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Only DAMON kernel API callers can use addr_unit parameter.  Implement a
sysfs file to let DAMON sysfs ABI users use it.

Additionally, addr_unit must be set to a non-zero value.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/sysfs.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d2b0dab50cb..98bf15d403b2 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -834,6 +834,7 @@ static const struct damon_sysfs_ops_name damon_sysfs_ops_names[] = {
 struct damon_sysfs_context {
 	struct kobject kobj;
 	enum damon_ops_id ops_id;
+	unsigned long addr_unit;
 	struct damon_sysfs_attrs *attrs;
 	struct damon_sysfs_targets *targets;
 	struct damon_sysfs_schemes *schemes;
@@ -849,6 +850,7 @@ static struct damon_sysfs_context *damon_sysfs_context_alloc(
 		return NULL;
 	context->kobj = (struct kobject){};
 	context->ops_id = ops_id;
+	context->addr_unit = 1;
 	return context;
 }
 
@@ -997,6 +999,32 @@ static ssize_t operations_store(struct kobject *kobj,
 	return -EINVAL;
 }
 
+static ssize_t addr_unit_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+
+	return sysfs_emit(buf, "%lu\n", context->addr_unit);
+}
+
+static ssize_t addr_unit_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+	unsigned long input_addr_unit;
+	int err = kstrtoul(buf, 0, &input_addr_unit);
+
+	if (err)
+		return err;
+	if (!input_addr_unit)
+		return -EINVAL;
+
+	context->addr_unit = input_addr_unit;
+	return count;
+}
+
 static void damon_sysfs_context_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_context, kobj));
@@ -1008,9 +1036,13 @@ static struct kobj_attribute damon_sysfs_context_avail_operations_attr =
 static struct kobj_attribute damon_sysfs_context_operations_attr =
 		__ATTR_RW_MODE(operations, 0600);
 
+static struct kobj_attribute damon_sysfs_context_addr_unit_attr =
+		__ATTR_RW_MODE(addr_unit, 0600);
+
 static struct attribute *damon_sysfs_context_attrs[] = {
 	&damon_sysfs_context_avail_operations_attr.attr,
 	&damon_sysfs_context_operations_attr.attr,
+	&damon_sysfs_context_addr_unit_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_context);
@@ -1397,6 +1429,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
+	ctx->addr_unit = sys_ctx->addr_unit;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-- 
2.43.0


