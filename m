Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F32CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793D68E0086; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7470B8E008C; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634B98E0086; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 486C88E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13937138E6B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:16 +0000 (UTC)
X-FDA: 83803917792.20.2E699DF
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C85E20002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MA0mrnWlW46E7cfjYA/9rD/IGNF/iHDOOPqWCUOdjTQ=;
	b=A48jPdx8ArWoiH0+BMkxVR8hT7PQxjn8Jxcabl6kU3y/B1WrtL9xoU1eEu89MfO0iKdDNh
	A+2iR0AKM4Wqnl6njvi33p6xWcXQobyHz2SzUGQ9oQBN97P4qdAxZ4EXcVejxoLLiwrz01
	W7tEtwzW+6ckntQQxPr96i8c+nutTm0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856094; a=rsa-sha256;
	cv=none;
	b=NmpIqDS0YWu9YpD+ZGOyJ7B5FdOAhYmNHGKV05+5WFvKcTLwll8gYwKr7+gzDkHl6c+WrT
	i0RddBM9sV02JTVlOLMt+qJaB1rqqZ5f1qk8RBSdckjnp5AMoAlFT6deIr70OwbPDRCgS5
	2bbnKPJ8U3zsEAR25Jo4XCEWdxgAMFg=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c7b4W6ts5z27jJ3;
	Fri, 22 Aug 2025 17:49:15 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 40FED1401F1;
	Fri, 22 Aug 2025 17:48:10 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:09 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 07/11] mm/damon/sysfs: implement addr_unit file under context dir
Date: Fri, 22 Aug 2025 17:34:15 +0800
Message-ID: <20250822093420.2103803-8-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C85E20002
X-Stat-Signature: 6o3wh67jwwh8g83ey3i7pzoem9irm3yo
X-Rspam-User: 
X-HE-Tag: 1755856092-147901
X-HE-Meta: U2FsdGVkX18dtJw7tK+aN9NXXzB8OwDxqI8BTWYSvpnUJs79IUB18nqkd59agV+VtOv+VgCJca5VWoHKE8xBtnLfWJGiGVPprhuL9qcfi4Ij9ieWiaVeqEean6Y6DCHJ+PCP8jxw/sUKbtK6yw//hSTDt/NlruYFIp7D7TJAa3EAq0F3BCAlsESC5jz8AaIZpMLeuSIAC7J2R5iphBvvk6i/18z1AcWNdsT4K+s3o6Oj3a0ciIdnWBAAJzsKqs/u4VoIzxTac6knF0PMzECVwof5wv379SolaGyjcit2jEZGsweRRDb8CeoZKPA/L998Qnfy1FJhRoYpuVNMbWTUR+9fFgzT+5z3szl+2rOdjZrugGlsAh0s2bIoPC4Ta7NTTxi2Pqs6v+IAlaVoqb03ktr0qbRaOXFo8omMpx+7Wq9IkT1SwL/bUn4XJDYDA3Na2dVjKjsHKXvUiQMXpczEdRa/yVJ+fC4HYKRVLhhUArL+imWfdjRX1YehFWv5WOq1FOOEfPaMMFOdX/yS12semMmPUgOxx/H9bElP1oLVH6WClnvrGodx4H0Xt3TiIuPIPBFWVHAj0JIRSJHXsVGjM5uP8gGkrnH6iMFg+2RnAEA6dLwwEzmLvcDDH+FeVvCpu9wbUbEfbqMhS+ZyZgOSnxYyghGOgSqzlG+VKCaxupd6beguvVjT6JkKmacSBDb29r9RLwRKUyN+gzix2SroGCXDzZ4EUtYLsflGmGp1rMkfWzh/sECciH6Ew4hG21EJOSP8E1Oz0mgbVkirULV3prh4q6uOCrfxelT9JVMfCtRgOOT+pNUPAWnNU0nWR46BxQPjAJp63bVj/xOxpt6z+AtwjWoNwk7jEcDTDZbVlnvzv5fre+PaPagmbwo/U+jEM/2PfKJxcpX/VkVAQFCsNQ2KZQ+V8e0UNG6g26P/vvsjtl9ZEGzbWaQU7UQttsJfsujMSeGAHa7+UrirWeS
 YGY4SCWC
 j0V2A3L9cIkq7tqRbmNn72guY8Gcow90vuwq3djRCOaQWwKuWbFHO/A2G/3W4Fm4EUdDeY/Lt4vj2zweUxF8mqx28I1X+P1uFEkqiFQJcn5QsT8XrHG0j/73x4+bD87c5M7VMxC83wPwRoOhKx7zZonjBJM1+Pj6HvcvIP79yqv0rqhYvJAJJR3tDXBU8byAdpJDg4DvynQq6no6PsjG2VkRj91fwtRkPB8E4UxSsGtc3VH1/WRDgxACT6SW2C7Q+KP74
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
Reviewed-by: SeongJae Park <sj@kernel.org>
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


