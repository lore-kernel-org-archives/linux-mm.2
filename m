Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C945CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460946B00A4; Thu, 14 May 2026 10:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0946B00A7; Thu, 14 May 2026 10:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E0D6B00A8; Thu, 14 May 2026 10:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 077F66B00A4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C491CA05A0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
X-FDA: 84766207890.16.87B80B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18453C000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4RxI1Sr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767764; a=rsa-sha256;
	cv=none;
	b=MCW19H2SiKjcjDSn8aiVx+PvBn52KNLE8kU/+tRP5D2jK09Xil6VSlZRs91yP7EiQ+OYv/
	XnWDoV2sx0vCPzR27gFAbKvNmnBXJ1NIEiG4eB1Br6uipo+pEVdlGYaliML/k0RLfUbQPC
	fXSYHaBzqOHJyWbo1Lg1J4Ogp59R/ws=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4RxI1Sr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XJQP2k8aVUlLi6/RQSECu672yXaLG765pR+wZW+F8Q=;
	b=ZfaQs4ZH8AQpTy9+d15vhko15fAbNMUOOFdH2WJKBBo6pq6G/PS2qdcSaSIqTcpbfv+XHD
	dKEqh78BslD9b2YlyQVy5zftAaD64/7U1Oi6CMBtMNW3ZD8rJnliwXJ2+t0TQrYILcc1bg
	gbhzcmlxMg8yXgBm/30bd5dRCdLSivE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5067E446FA;
	Thu, 14 May 2026 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADCCC2BCB3;
	Thu, 14 May 2026 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767763;
	bh=9wtcGKd2TuBKZzqqapx90lRnyNtTZA2HcxLo0K3VUw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4RxI1Sr+Oi1uIxX486NzJf6dWhHzlpc28+YtDhju6ZSxfKzMGhdhjsFngntH5tbX
	 4CUowp6L33KlsDnUUu0KAWjSlPOcu3kVviKWH/kjUdbFnK4b0tsaF0i4VSJXIZyRTs
	 BbksGSFQ/0I1ywkl9Pya3g0hSMjzrrmnmgfIptdsZ2czrgK00IYcXBNozEHO/KVbUa
	 ZxzOyU00fLB8WxvhaCL+qUYfEh5z8gOqovcd+jWgr9xfwkxLN9qPbLo1Te3N+0s+7s
	 +YYKizlQ75adz31sANHe2gbVn0S0Iz4Ua6dxoCCvJhEu7y1BIrEdVjZgoM9G+MXPsZ
	 qq/FX5okWoFEw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 15/28] mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
Date: Thu, 14 May 2026 07:08:48 -0700
Message-ID: <20260514140904.119781-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xy3673btzccsorrp8utctxqwruz5u8up
X-Rspam-User: 
X-Rspamd-Queue-Id: 18453C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778767763-129313
X-HE-Meta: U2FsdGVkX1+TB9I6QjQfp6mDTsrJgI8BviiuvtoRla30Kfc7uQbCXyF5Fkwur9yigTzh3AMBsY92gym4Ht6mapPWxWt/w1hyMqrMhnaKfZzzm9P9gs6c02x03or/PUqTR5Y6KgPFFB59ce/MUQoxRQlNAmLEmP/25XR5SvNqDqFOoYgyAevLQ1h9jaDMaPELL4YrXe1cKKRZFhoJKqpuuw5NXDZDcphHlVfMY4MsMsp87YCy2HlXhND+EW6evgEUnwAlDj1U36WpJ0ggTeY63hfv7lX02DqRNB3ojYfsDN23qyDEwKqTyGBFEMeAFrAWUVdmFGQMHaHd6N2/zu/n0+9JIVjvOUKaR/FqlfLFaV+yxucbq0KrBz9MMiuRnTvYg7mZOj5WGBkeKrt6HyU8Nsv9kBRPEZoMcj73WozlzQjd8t5//CyQD/WoTNfgxsEj57PlPeQ1vJZtSN2XIjtKJjD733uU6No8M5mmabbYbZ63SSXw6I+NnNG7GlzIf17M7sx7tZMB4M5U6p6mcyxnwkqbpPHrmGSIB1ELF0PN/WGnr8Zfb/ilhBhvR/v6H8TEZZ5cb5R/oGeYBQ/uKBrsD+eWiqlkybFOysSDdkmw/h/+E4xDcGcRbNrvUSmv43n9etG5SrO3/QQgQFPi5K1oyeq7xFmAx1ft7s9z6Z/nlCHhuVsjzgeJc7nuPp/YxGl4jiRVJtf6bYcrbnMbd/r6xmt2r4AyT2U4ClQvFRp4Kco+DksDMIdL/nlbPTyxHLqNN7T61czQu6iihc6RwhG5wLoBVwLrkX5WJgv41INUfC5j6sD2O5hyfah7Ti+85v1jUqAfgUi59bBMaoYUe6eP7/APCy9jirM9jx+uaU12Ci80c5n37omMdEvEmeZE7ndPryjlDJrMjY74ntnf9NoJxJaqad2eDRh8ld6BmwPmNM4mRXuUdfCflh/LoBa9G5Gnu3RamZkcMoQENybzjdQ
 M6dvcCab
 TER6nqWLCbiyPhR0lr3f/hmWPj5fQEW6hQVcE6BHj5z77VNdbwPXhUOfebeLc7ApXkGSDUhWMlBKDVjumFNmaUUdRKgs3C66InsCFgql4FZgEmKcVfINBxoRshcs6sKajdxH9R7bcLRIZaHZG/hRq5x7VaLfhmDZM/q8zA1dH3OBhURyT9nAulACDBKSORtWdlN0ilCk5nbgc7gZAvm3OzXqfS0+hm2X19kii3l7U+eWyzI3TB1/oJNuPy2BaFhQxUOXQaAHyXHSe2dGDTe2pNiCVCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory for showing the per-region probe hit counts.
It is named 'probes/' and located under the DAMOS tried region
directory.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 65 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5d966ac864193..b2dcbdf1840e4 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -10,6 +10,32 @@
 
 #include "sysfs-common.h"
 
+/*
+ * probes directory
+ */
+
+struct damos_sysfs_probes {
+	struct kobject kobj;
+};
+
+static struct damos_sysfs_probes *damos_sysfs_probes_alloc(void)
+{
+	return kzalloc_obj(struct damos_sysfs_probes);
+}
+
+static void damos_sysfs_probes_release(struct kobject *kobj)
+{
+	struct damos_sysfs_probes *probes = container_of(kobj,
+			struct damos_sysfs_probes, kobj);
+
+	kfree(probes);
+}
+
+static const struct kobj_type damos_sysfs_probes_ktype = {
+	.release = damos_sysfs_probes_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+};
+
 /*
  * scheme region directory
  */
@@ -20,6 +46,7 @@ struct damon_sysfs_scheme_region {
 	unsigned int nr_accesses;
 	unsigned int age;
 	unsigned long sz_filter_passed;
+	struct damos_sysfs_probes *probes;
 	struct list_head list;
 };
 
@@ -34,10 +61,36 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 	sysfs_region->ar = region->ar;
 	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
 	sysfs_region->age = region->age;
+	sysfs_region->probes = NULL;
 	INIT_LIST_HEAD(&sysfs_region->list);
 	return sysfs_region;
 }
 
+static int damos_sysfs_region_add_dirs(
+		struct damon_sysfs_scheme_region *region)
+{
+	struct damos_sysfs_probes *probes = damos_sysfs_probes_alloc();
+	int err;
+
+	if (!probes)
+		return -ENOMEM;
+	err = kobject_init_and_add(&probes->kobj, &damos_sysfs_probes_ktype,
+			&region->kobj, "probes");
+	if (err) {
+		kobject_put(&probes->kobj);
+		return err;
+	}
+
+	region->probes = probes;
+	return 0;
+}
+
+static void damos_sysfs_region_rm_dirs(
+		struct damon_sysfs_scheme_region *region)
+{
+	kobject_put(&region->probes->kobj);
+}
+
 static ssize_t start_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
@@ -165,6 +218,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		/* release function deletes it from the list */
+		damos_sysfs_region_rm_dirs(r);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
@@ -2998,9 +3052,14 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions)) {
-		kobject_put(&region->kobj);
-	}
+				sysfs_regions->nr_regions))
+		goto out;
+	if (damos_sysfs_region_add_dirs(region))
+		goto out;
+	return;
+
+out:
+	kobject_put(&region->kobj);
 }
 
 int damon_sysfs_schemes_clear_regions(
-- 
2.47.3

