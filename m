Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9534CCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6608E0034; Wed, 20 Aug 2025 04:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267188E002D; Wed, 20 Aug 2025 04:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156C98E0034; Wed, 20 Aug 2025 04:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED5928E002D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B626C137DAE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:13 +0000 (UTC)
X-FDA: 83796438306.14.8EE52F7
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id B60B91C0004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6cvRxLD/HynLXLH2prU43m5M2h2d2eDv9oNKz4GIGc=;
	b=bLCl522d/3maQNHu39bjnmkkAm7iclSoWNAA04rs8Ln/b0wOXOG4Pq8HelC7WU3yRGb3qq
	J7QBB4BqZbS1MwlZ6RCbFbD5MI4Z0jwXjHC/93wkTowTSrqDFHd/FnEivd7rclNrwYm6/2
	qXIfDSO8dUT8ZCTZXOuMwpeyYtCM1n8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678011; a=rsa-sha256;
	cv=none;
	b=xKbk0xiLYmmkiWoLUez+u2ICqSbu5RoNlIBxD0H72wO+of23XCYeJ6JAUX0+wOqXzh+eOc
	YhayGSaGJoVGaV7DQcEK8Oyd3at1ZHrT6VQQu69mjS+D1r3gDYhwc/PaOPcLDt+CssCx/q
	n8kdJGc07zoDi7I4/rqHqLTiCbjwpdg=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c6KCr4t8Rz27jKp;
	Wed, 20 Aug 2025 16:21:12 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F67A1A016C;
	Wed, 20 Aug 2025 16:20:07 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:06 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 07/12] mm/damon/sysfs: implement addr_unit file under context dir
Date: Wed, 20 Aug 2025 16:06:17 +0800
Message-ID: <20250820080623.3799131-8-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B60B91C0004
X-Stat-Signature: b1hymwijmja5uzictosscbpqh81kjtww
X-Rspam-User: 
X-HE-Tag: 1755678010-561
X-HE-Meta: U2FsdGVkX19b6NaWdD2/r6wjYABQYi3sL8gigNPf9/sIv7TjPsQOMuU09gw+aUaha/obLhkHhKxG4bniNuz5zOAtjrxnIZGxXTwLI2wFJw62vI4T4pgLCJ69HwlZoSX15TV0rk6ojBpBYC42/465ymh1oAC5MC5OI+FBeWVctiF1+xoLsnByfFJeKczX7LakiZcnZAOEHko3LU3kdwleVa7nbhTwUgJwTMLZqxLIZ+oG0wWg0HLKGea/oyHq5/gESxW/wmk8kGZFmgF/UxllN5jgP3rG8sCYlkgnHcQcvYfQmxFYyqbTBlvl7gCmHFSROW2PEgKru/tizmWebxEjwF3egNvyY8oTuzF3j9TOMDWho7ta0iREgH//xDS5hzWjJ1cQIYkFHIuyw0i/xFLIz/NAhZmw++SgaDg7odn+fKeJwHjeogPBWJjmE5qTe2WoIgYl8mtqwKC7MszXd2m72YwhVaBE1+VW9MIqQLZWLRsLp5iLK0pqfNv9lZroplz6R0prxNFksx8sgvJjQVqe3qpT+Cm85KPxhCi946nKTZ+cEDNNYSSWDIsjCF8g8Z9WZ4Hq5ubDLSQGrYnFb4iPzs5qbUt9LYqMu7ug07jDx6QXTAw36fG08Bzc3QwzohOMcf7rriNV2wBioJ2ZmUmsVfArfZWAxac5KYttPqML8mjbOq4dx2U+ygTzD4j6B0D/romeo2h+CdoIsnTt82NLapuanCKYRcOKSylZVIk+a4ayICUAbXcEtfWrUKedY9beio3XSsjJS0vPxoRDTBaYr5WK8h8vOVFSryC0WIT0j9wGp82l/FTbi09jJRjUI83AiyyehYWwyYFeFtt9sdOKo6YVIF1j7nLTa1+ugxqtUwpBpkQBoisdL4co5t6jLvnKwiXAN5dU8xHjHni5mTpGc48tj12MiYn2g7wqJAo9UfgOpy47SW7piQWaYvetZI01c0N8ipwlfVgWsy+49Dn
 e2xCQ0Xh
 8mECVwmekbY2ZODKK08haOU2Hy8HOsDuCDoGQjBmIDso0xohH/BnwZQ7knFJMFkFAx55qe5xS/+n2T8zgK/SIIEu+2IeYyQvbXYiEhjSI9h2VjEh79nM7b79M1DCFfQqIaDtE0BDJXmcHC2GBg1LxVV3pwUqW8DBqiZeV+36KapfA8MEAK4D5LmkrSqxGQwbGIgwFK+aJE7H9TfXoruzPfYnqYZnvqgpn3kx2HPh8SzkNruB/6Ljg//HG6U7MJZhX8tHb
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


