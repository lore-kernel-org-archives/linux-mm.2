Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB37CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D5C6B00A4; Tue, 12 May 2026 10:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA216B00A7; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B246B00A5; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6246B00A4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1472D1C0C7F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
X-FDA: 84759020010.10.E9518F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2EAC780012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="b/XK5Jtl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ULDK/TnSfLd9MtX82JW3Ej1Gak5V8YvFYrL2vCQeZc=;
	b=fciswOTBBPucxDDI9wfWAxvZLq+W3c068hr6mc1UcucNaxbF6z8HSXeO+ddc6F/PtoQ0v9
	veFcqIpcEGWniweuZz/gAFzzuQ6fbZsWDhMOmJbqIbHtZ1zzQS5yVOwnQrzaBlA5OI6HpT
	cLkSQOrPoB6jC6nu8rpCeTyXpogCoao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596623; a=rsa-sha256;
	cv=none;
	b=EO+GVliIGcb88UJXzoFMKd/m2KtcG4A4XoWO+tN5Y2Cqb4hOMCUT0QaRY0Uk9CkXg7OzzJ
	vGgIEnkDNwphSHnH5Xf0gscx+bTgznSJwBaoSp9wIVp+vhTaB2TV+YbwOaE800eEA/Qc+T
	goD7Q00vk/5j95fkoWehcLHfMyBu0G4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="b/XK5Jtl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C8D244AC1;
	Tue, 12 May 2026 14:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECBBC2BCFB;
	Tue, 12 May 2026 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596622;
	bh=RwyqlL/z+o4fkUQKNxBQap95FJCMMs79UsQe2MpywvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/XK5JtlGn+52Yv82k+WEkwFLcnORxusI4YBrtpmc5BF0eR3NytVfJmuX1JTFGeyd
	 HvM6kR5K0ixZCPSfyYK3JTLjLj9vowAB3Ypmde9SYbbOvhntcL0RBKKWYkFtaK3Ub+
	 lMOlzeXlXJaaRnxzPrFwGej41J2C/QHc5WKwOxCTa5SXbtJcSi1kKCu14duJi1rMY1
	 061pgfBN/c9ILZx4U9k5B1hbocrfeEtK9wahB0eob9v0CtvZ3CLw50UJDXHhDsWcVu
	 /IPyd8ZJcFDBxpGRPoMeimdlU+4MNuWDWo6Xr0MA7Ji2xR3sU/G/zVJ3JQCMojozqt
	 fsCC3bSWFp4Rg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 12/28] mm/damon/sysfs: implement filter dir
Date: Tue, 12 May 2026 07:36:27 -0700
Message-ID: <20260512143645.113201-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2EAC780012
X-Stat-Signature: chfky8omdsymh8k9hra841sizga3ezy8
X-Rspam-User: 
X-HE-Tag: 1778596622-443086
X-HE-Meta: U2FsdGVkX19jw9qibxmc0z+mo0pK75+k2RzSyiUKYdPKkTbdMH4pi5yWVZccMuARg3szX6OqWliGlDGH8ii+uygbmhdUCWhQJ5ByTLXr8swh4az2J4eD6plB1HUhWbGv+PLCBZf8IJ0pkEEv7qIBuJbX58dlOJfgRNUN/SBQtobeJFXDuU9kWHTgsoZQU2xeitNAWMuzCyCm5FZLrCuEOFQ6ycnB6/ZwKXxII9r7Q0SorXezfhAJR6UoV1tlXj4D1ytdH7eO8JmndATMLfkCVOIJ/XFGFjXvUCXs2bSdUWxzDfZvRkIdQMY3OGtGOl2At1ivoVCLlVp6O3+hdXtfa1Xw1NuxsUBRMTqR2wMIkN4UOevK679GYNoPHnZlbzkzxG2yqskCNaOn7aRdbsqExKPTxhGYOyeZQcVXCM0OZO9W8qKXtnj7+RgT3MJe8WPJFoeGTx9hpOMhU9UVuPLLX2p5SIMuuGKqfVCFVedFb8CF1az9O7UlIlpPSDC+6/4rVtLpzolN2BlAxEkgIRQ6i6Rrc5yxJ60ljUrGinZ8AARJ9JVQUeZvvHbI6+hE0MnyagYuz6rMLF1XH3wDsYHd0plEDZ1iZYXJFmZUhL3lk835UubjYbEEgbItjysVIACKLVHg134KzAHVB9WbKiWwfgyi4b74NdgRw+6fiv0bmVAqg7lDQqc3HiF2lrsey4E0Stdb42ucsNq4e6G4d1KMUPmQMRbgXh2vzTVsvN/V9oz9AsZyRhCpbv2hMyoG7CS5uDp2DoC3jnYpHPXXH1I6B1n3qH8TfaVHh7lQ57XfaVXdKBybqtJOlTYyxJqwiEJd2F3+AbV09uptqvSCDja4uIhRFOly863N95p9NJfNy9FvB8L3boWi5CaeMU1VSilabFSTd+6heBuD1mot62m+kT5jckAYemdhbnGeI/eWazQT1vHhmZ1LMKf2fxUxExsRhicxEC2s1nPgX6ee4Ya
 GM3eBswP
 g1YIqtT5K+mgFtIywzZOsuNYdLiz05XTCT4Bu+aigisKSDonQGH/fTIkSwMsy6YWaBunkgpo1bJOueIDRhJxMa3rthxEV029BjthLBzrWahHr295XU2F6YrSvq1krfwMGaTz8hPh69lcg//6Ft9Md7IiXwiFcL7J0b3YgsYRLTASiX9kQa2sG/ZeAFaUf4m5hykMbUntXsSSc9GV9FzjcOPp+S8ih3Qp0Guo+OLOvS30LshI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory for letting the users to configure each data
probe filter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 125 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 124 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 250208d3de21b..25487a0268cbe 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,46 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * filter directory
+ */
+
+struct damon_sysfs_filter {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_filter);
+}
+
+static void damon_sysfs_filter_release(struct kobject *kobj)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	kfree(filter);
+}
+
+static struct attribute *damon_sysfs_filter_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_filter);
+
+static const struct kobj_type damon_sysfs_filter_ktype = {
+	.release = damon_sysfs_filter_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_filter_groups,
+};
+
 /*
  * filters directory
  */
 
 struct damon_sysfs_filters {
 	struct kobject kobj;
+	struct damon_sysfs_filter **filters_arr;
+	int nr;
 };
 
 static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
@@ -760,12 +794,98 @@ static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_filters);
 }
 
+static void damon_sysfs_filters_rm_dirs(struct damon_sysfs_filters *filters)
+{
+	struct damon_sysfs_filter **filters_arr = filters->filters_arr;
+	int i;
+
+	for (i = 0; i < filters->nr; i++)
+		kobject_put(&filters_arr[i]->kobj);
+	filters->nr = 0;
+	kfree(filters_arr);
+	filters->filters_arr = NULL;
+}
+
+static int damon_sysfs_filters_add_dirs(
+		struct damon_sysfs_filters *filters, int nr_filters)
+{
+	struct damon_sysfs_filter **filters_arr, *filter;
+	int err, i;
+
+	damon_sysfs_filters_rm_dirs(filters);
+	if (!nr_filters)
+		return 0;
+
+	filters_arr = kmalloc_objs(*filters_arr, nr_filters,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!filters_arr)
+		return -ENOMEM;
+	filters->filters_arr = filters_arr;
+
+	for (i = 0; i < nr_filters; i++) {
+		filter = damon_sysfs_filter_alloc();
+		if (!filter) {
+			damon_sysfs_filters_rm_dirs(filters);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&filter->kobj,
+				&damon_sysfs_filter_ktype, &filters->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&filter->kobj);
+			damon_sysfs_filters_rm_dirs(filters);
+			return err;
+		}
+
+		filters_arr[i] = filter;
+		filters->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_filters_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filters *filters = container_of(kobj,
+			struct damon_sysfs_filters, kobj);
+
+	return sysfs_emit(buf, "%d\n", filters->nr);
+}
+
+static ssize_t nr_filters_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filters *filters;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	filters = container_of(kobj, struct damon_sysfs_filters, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_filters_add_dirs(filters, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_filters_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_filters, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_filters_nr_attr =
+		__ATTR_RW_MODE(nr_filters, 0600);
+
 static struct attribute *damon_sysfs_filters_attrs[] = {
+	&damon_sysfs_filters_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filters);
@@ -811,7 +931,10 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
 {
-	kobject_put(&attr->filters->kobj);
+	if (attr->filters) {
+		damon_sysfs_filters_rm_dirs(attr->filters);
+		kobject_put(&attr->filters->kobj);
+	}
 }
 
 static void damon_sysfs_probe_release(struct kobject *kobj)
-- 
2.47.3

