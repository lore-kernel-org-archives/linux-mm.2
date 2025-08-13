Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CC8C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B118E01AA; Tue, 12 Aug 2025 23:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FB38E01A4; Tue, 12 Aug 2025 23:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A540A8E01AA; Tue, 12 Aug 2025 23:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 941ED8E01A4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B7C2B73DB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:39 +0000 (UTC)
X-FDA: 83770362438.21.0BF7B84
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf08.hostedemail.com (Postfix) with ESMTP id 34E68160008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T55MbBZEuJGkBcV84r7h27FXqjSjQrK8uID7Sn9xNVM=;
	b=L15YoUsB12UFhCQmLt6B9MENwlwLWT/m0I/YU5T9a9SSaN6/QV/pbIYJ2b1rZ6V2My/CQF
	IYH9V08AFjMNeZIIgBMWI0k9A+qVrMbifhbVqSyEt8Dxsbc2Z3f1sGcPgQq1F4n+P22H55
	aVElDdKY1zgqOstPVb9JsGvgb0PjgxE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057157; a=rsa-sha256;
	cv=none;
	b=GhC5UdOGJRV2z2WOKqGgfkCHjDIfkvlZD5+mnjOpoUmuWeKE/cuJ09OZpzXmnKKha6oxCW
	ylxKCYFSFt8qRWRXFbykQaV4ENo9hL1wN53vZlmDTNuKtyf/pMMKBaLCggTtqWFw4OeIvp
	da9MryBWu1mNoGfYU7S866A6hewYGYA=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c1vX30h4Zz2Dc11;
	Wed, 13 Aug 2025 11:49:55 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EFDF180044;
	Wed, 13 Aug 2025 11:52:34 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:33 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 07/16] mm/damon/sysfs: implement addr_unit file under context dir
Date: Wed, 13 Aug 2025 13:06:57 +0800
Message-ID: <20250813050706.1564229-8-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: h5hxheayjukr17dhfapjehxqw39kpebj
X-Rspam-User: 
X-Rspamd-Queue-Id: 34E68160008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755057156-749210
X-HE-Meta: U2FsdGVkX19fdvpGet/SWYHebBKPmml9euocVMbT5GatuG317aqqEXAitTqaqz+1F5eb7mn2u0XF4e/mpTV5FT7KVtWB7ITkVyzeDaaFz6ykNn7jJk2qJDewdb1vorHo204r2upWYE307d9fII9JU2xsQqH7SMZRWQfERN/ka1IBsPgWKkgAMQGgIlBO//GaEl/Aj5DA0F8LJMnJhKLGJzAoBq6IgXAeQA6hLR1OhfCPMIQ9bDOCrYr+6WWtDfjq0rozT42cekVnaI4tv501TU5Ws44S/NebnMAhpg/tAaVPHy0o9Nmom4uLU8XH8BNXV1WZqfZa1as/vqE8Hck1So04PmBJiC6lqf+Ptl71ZemB5o6FEUUxSq28cybILB7SYjPtK3kCYKIvdAKbJ7ur3ekJ/c2nvvi6OmVQjstk8H6M2O+svhArRwWEvQkRVxkBK/KCoAgdSpeIX6gTJ5rEJGdo3N0NqKIcpssbPckS0xTbkQlkEs/+wgE9OVZRb0XsQhiIrMSnTbR2NEP/585eOqdFCtGdfOxwmhRzdPqS7m6gRKgQOhAvKkSBR0Bw2vtZlSUBtJmvXwwFD+QuKWa89X2Xzi38v09t0z71qLVRuiHDKTKzoNS6KN+uZ4frYrgUgWfqIIWeSMiwpXtyHJlqlneeAqw0FjbMY2dLNdp+uauG2SUf8lCdK9LDPsEcPuyKG6VfsMgwjL/uHJoYFAEEgeClRU3WYSLZyls8ci0L/M/MI6eWzdn9DQC1GLGDsv+PCUUDibsesvKGuEB3V1cYGeZI2X7gQR+g8//ldFDpuZtx6XGYGNEd2UXArdz5mdJV+dAp8WFRl8l/THQDlURmrhvqkWxIWz1BRiD2ILP3wdxW9zQWEtUbFO9ggwRKcaTtQZkCZJWHf6Wx7nlbDQyUbC8joBrF3UkW4nZALSgsMw+lHy6OZHtuP0lQqwy4V5uj+LvsGRU6e0CPh3UAlF4
 O6ZpRoEA
 cWOmehVl+QMrkNVqNqIaAjs1G4lEEU8H6scm2F1Dzn6a16o3XcAtNT4vlt18akZ6I2SDvVmGLIFhnhbY44WjgKLyXz/nb761uNNIouuEkb6uLw9om0F55W+4q8B7kXgrKGmhSgduUykdT50ZRl7TX14SUgt56eMHpZg//Ad5JcLDaFXyYgr+/ZDudrOpHU11ZPMUn7nuRG6b+icm/W7wZ7XR0E4ux321yKxgWFFCIHMJHG9hLxa22hcUz6/MFTl2ebrcfDsDBsIZ3MF1R0qUWzXKANA==
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

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d2b0dab50cb..bea782b0a711 100644
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
 
@@ -997,6 +999,25 @@ static ssize_t operations_store(struct kobject *kobj,
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
+	int err = kstrtoul(buf, 0, &context->addr_unit);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_context_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_context, kobj));
@@ -1008,9 +1029,13 @@ static struct kobj_attribute damon_sysfs_context_avail_operations_attr =
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
@@ -1397,6 +1422,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
+	ctx->addr_unit = sys_ctx->addr_unit;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-- 
2.34.1


