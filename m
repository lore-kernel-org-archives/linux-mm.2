Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89778C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B2F8E01AD; Tue, 12 Aug 2025 23:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC958E01B3; Tue, 12 Aug 2025 23:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F44C8E01AD; Tue, 12 Aug 2025 23:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F21068E01B3
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B50F1140211
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:45 +0000 (UTC)
X-FDA: 83770362690.28.4F9E107
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf25.hostedemail.com (Postfix) with ESMTP id 731E9A0004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0hyqNgugSvZKi3rOm9NALIkvkrG6FSuda1DDdvnVd9Q=;
	b=hPe65qGN6pIxwPVJKC+AeJnKMISvFBUQXAFUiG1BHii2lS22I9Vnsxd9/jJmSOr/nhUqcu
	Y9XZLm5IA+NYtWxjlhLnyeAZLZ+yJyBaGSKa+W9JzaLR97ulD3wUtZSAf8h/iNynMlOsc1
	oq71DRsirJK8T7ykO09QUEmK+r52sZw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057164; a=rsa-sha256;
	cv=none;
	b=mmql99oRafwc7WoSWr3Kr77y6/W4F81hiip17a+3QPxvSvr5FN1t1f1s/auJh+keDLqBSm
	bOxp6zZpJ9iqQtSXfmrM6nENTH5dJYNnNXzK7GQrQLkdg/X4n91xjMGnhUjuJ85bC6pVH7
	pI3hjiQAFvcqeIW6YP1mcBGNKK65q34=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c1vWy6pGfz1R91H;
	Wed, 13 Aug 2025 11:49:50 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id CAB9B1401F2;
	Wed, 13 Aug 2025 11:52:40 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:40 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 15/16] mm/damon: the byte statistics data type in damos_stat uses unsigned long long
Date: Wed, 13 Aug 2025 13:07:05 +0800
Message-ID: <20250813050706.1564229-16-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Queue-Id: 731E9A0004
X-Rspamd-Server: rspam06
X-Stat-Signature: rrby6jca4q9s7a8bgq8pwybupp3msq3u
X-HE-Tag: 1755057163-583203
X-HE-Meta: U2FsdGVkX187ZPfi1Z+9mW26xBe3VmzuqaSCl+8MJ4lvDfCLCvrI4yiC93oDCwnbGtAtO8J0NtZGYb7MzhWlR/7DavDxBO23sNArd8tczIsR7Y1eCNsdFGmLqblXI7cUr8P9or1HkLDVlOFyEEwdp0e84+WU71J+ziwM329nF2lISQnrVA8q3wwh3DDxf3ZtihQY14i9SHlKHyfLZoLXWSwT3jHSFhoNoZg7Df6ZC0qgoRFSxgvT6okpFiTn5o995sgxS8E+D8ON8udJIK5fC9klzaoh7djqHsKt8tWqGXW+8LkpHqzTz5ED1/sHI3igeNZcr/1XKW4dX61hQmyWfyLiryj+6zY/Hr8ODmX+5H8vNLxyPidZN3SEpi4SUw/23Wa9n1FmuduT39A+qE9aN4Cz+mWfA2St7XF10m+NYpc+aXB0feKI2/174gI5YqOLTzJ6ZXBaJ65at4x07JBlHpCo8RTon+LJ04xqpt4DeNCqpmnUx9APL3qm9oOtedndXm5lXog82xN8wYKEOgMLr2GnCzv1z69V7xKxC5gHxYXW+6Zl+Q+TWBXF6anCGAg7oAidWSN7WNA/EMbKDAz7fve+a6OOZkRq4R5Pa9Z1SZP/j2k+oo5CdNOLm+vDFkuhoPy52pJd2tlgmjYVgCTx4sPctNewyzeRQtR55sKEznM0X4vU5uoJfQ3qUKbaDcyguhnwR+pNKs3X9CzG35B7ju8qOqH+tXsvUvVns50bZRBQL8KeqjlgQgMA2JwE5pUe7wypOmiBio5ZdMZ/lUcPR7Un7ngXm7viovvzJstE78XsQOUo/JRcDnWDlYxddx5LgMBzbrqpkuKcElAxLRK6Nk3nrG9WXDgJMA847at/zfRxmtuHKptaFRRAcvw7efVpSEBXYKt4X7pHUkmsawerKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For 32-bit systems, damos_stat now uses unsigned long long for byte
statistics data to avoid integer overflow risks inherent in the
previous design.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 include/linux/damon.h     |  6 +++---
 mm/damon/modules-common.h |  4 ++--
 mm/damon/sysfs-schemes.c  | 12 ++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index aa045dcb5b5d..d85850cf06c5 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -333,10 +333,10 @@ struct damos_watermarks {
  */
 struct damos_stat {
 	unsigned long nr_tried;
-	unsigned long sz_tried;
+	unsigned long long sz_tried;
 	unsigned long nr_applied;
-	unsigned long sz_applied;
-	unsigned long sz_ops_filter_passed;
+	unsigned long long sz_applied;
+	unsigned long long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 };
 
diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
index c7048a449321..ae45d0eb960e 100644
--- a/mm/damon/modules-common.h
+++ b/mm/damon/modules-common.h
@@ -36,11 +36,11 @@
 #define DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(stat, try_name,		\
 		succ_name, qt_exceed_name)				\
 	module_param_named(nr_##try_name, stat.nr_tried, ulong, 0400);	\
-	module_param_named(bytes_##try_name, stat.sz_tried, ulong,	\
+	module_param_named(bytes_##try_name, stat.sz_tried, ullong,	\
 			0400);						\
 	module_param_named(nr_##succ_name, stat.nr_applied, ulong,	\
 			0400);						\
-	module_param_named(bytes_##succ_name, stat.sz_applied, ulong,	\
+	module_param_named(bytes_##succ_name, stat.sz_applied, ullong,	\
 			0400);						\
 	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
 			0400);
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 74056bcd6a2c..3c4882549a28 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -199,10 +199,10 @@ static const struct kobj_type damon_sysfs_scheme_regions_ktype = {
 struct damon_sysfs_stats {
 	struct kobject kobj;
 	unsigned long nr_tried;
-	unsigned long sz_tried;
+	unsigned long long sz_tried;
 	unsigned long nr_applied;
-	unsigned long sz_applied;
-	unsigned long sz_ops_filter_passed;
+	unsigned long long sz_applied;
+	unsigned long long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 };
 
@@ -226,7 +226,7 @@ static ssize_t sz_tried_show(struct kobject *kobj, struct kobj_attribute *attr,
 	struct damon_sysfs_stats *stats = container_of(kobj,
 			struct damon_sysfs_stats, kobj);
 
-	return sysfs_emit(buf, "%lu\n", stats->sz_tried);
+	return sysfs_emit(buf, "%llu\n", stats->sz_tried);
 }
 
 static ssize_t nr_applied_show(struct kobject *kobj,
@@ -244,7 +244,7 @@ static ssize_t sz_applied_show(struct kobject *kobj,
 	struct damon_sysfs_stats *stats = container_of(kobj,
 			struct damon_sysfs_stats, kobj);
 
-	return sysfs_emit(buf, "%lu\n", stats->sz_applied);
+	return sysfs_emit(buf, "%llu\n", stats->sz_applied);
 }
 
 static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
@@ -253,7 +253,7 @@ static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
 	struct damon_sysfs_stats *stats = container_of(kobj,
 			struct damon_sysfs_stats, kobj);
 
-	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
+	return sysfs_emit(buf, "%llu\n", stats->sz_ops_filter_passed);
 }
 
 static ssize_t qt_exceeds_show(struct kobject *kobj,
-- 
2.34.1


