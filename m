Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE987CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535E56B002C; Mon,  8 Dec 2025 01:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D8E6B002D; Mon,  8 Dec 2025 01:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A136B002E; Mon,  8 Dec 2025 01:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3618F6B002C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3FF38B11E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:21 +0000 (UTC)
X-FDA: 84195329442.11.2673BAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 37ADF14000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diF8S5Xl;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175420; a=rsa-sha256;
	cv=none;
	b=ofMIWHzVxjEa5tXkCiaXbBbsqaaj3MSd70OfqCxItTbtYFO01ZNLfTI7HXultbUyfLpA0o
	Y1rhiviscl0h5hVnA3D3w8X+oLgoFsVMY3f9YnTOdF+J32tzQ3Q5oQOAI0+ScEvY3L01Jt
	uzIsWNsKh9mhOtfWFJ2p6qnVOzMGY14=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diF8S5Xl;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0BhWoTOt+9Ut/u2jxeB3TAN0x+VfrfFXkJUWhzxOA4=;
	b=PTvnhAfeFwECMiWkkfPIt15ZvlD/xlsZoToD0T9S3Vq2bieoU9AWzvf02oJ/gcy9pil8WG
	7VcAoP3YoS6FbON+W3W29jReG/xTo3hyX6jaL2GL+kulBArSh1ir1Wvcz00PUD7OQjWn9X
	YeqsqcpgO/B7a6GuNFIsuYUoxMk3uyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B04144440;
	Mon,  8 Dec 2025 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D0BC19421;
	Mon,  8 Dec 2025 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175419;
	bh=fqtI2Gnz07OVYPT/2oX+SDTbNLPGFodcuU+kQDn13Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diF8S5Xl62t4a4nrz6s9jCM+NbKUjbmQqLXN6ILr6Xw7ZT9FjwflJzMxaRNvwJ3xS
	 0qJlyuAKQSwruTpl/XCWLD27ziMxSuAnNrATHYkI6vMUm+Pts1Ap79LBGceoNAa04F
	 RnjRiX+z4WCT5BINlgRz623mMcThFeb3xcqQGAcAdB112HUr40JjaHQkUj9NqBW8c9
	 R+OdqQeNs5DTvdLmzFmUorj1/3LKOz8wpb4tvhZ6JzJKvMm+O9ymy4c6YfcIM5cawr
	 3bdgx3SBR+sHWHr962QlfwlxxxUzZ5H2wAPSQhyJrBKurxOcZR/dWoQu3bBKB+cO1p
	 IXPyl/gyERCXQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 20/37] mm/damon/sysfs: implement sample filter directory
Date: Sun,  7 Dec 2025 22:29:24 -0800
Message-ID: <20251208062943.68824-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37ADF14000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 1qn864nb8r1zrjgn88g31r7uissakpzp
X-HE-Tag: 1765175419-880344
X-HE-Meta: U2FsdGVkX1/6FyHXyI6KtZuLw51QSYWW1wTvC1rKn7KjARCwqWxlAzQ+cHawWak3Gdvp9i8rx9EdahRgNtghd70E+HBl88iRsXLWYHX7F05BspbYJp0fV2W0Hza6xZyDk0650cZgeHBCifb9fxGwTPd2P1Z+lC7XIOc4UC8kHu97IuZScxybnCy6M8r+tQfzlcnXewkpAEeu53vWhqctKU741xZxzFErEPSQBZe6S3nqU1+VCA4F22O4nzyXQF+GCeKtUBH/GsAREWFoOb/Y+kdEStJ6eTSVIJJPhPTk0z7CqnaNG0M/hP3za3RfBBMQem401zH2n7kRtETcJI2MYuyawOSGu1LyMJp79gZce2MPVClVdf1AAtPzxG+bLkpA8p91UC4w8ejYm9pUNuDlmjfX/VKCQbaGu16opxHHgqFPNnDriflP9AeD+imDr8LKD+zokR6vCD58iE5/p3LZAfmi6zNcGhr80x8LukzaXd5jgpQRrsXuzZRm0EFJT2r7uCfPuOKetpVbrf6rRnho2zp0ri5qQsUUouhp9N0J7AOKZJKi7TRAZFWD51EXLq4M8mtxBP1dcRPw86ISY1K/bXabUWfhN3bFNt8NqdP2arllrqtrsvaRe2GNF1B0JMJtKgJoPy8YlyYfXzUZozOFKKn/LkZ+LSlkhYOp92lWnCYplo+BaZyEOFEor6ESPKq2Yz1ZTfgxJJMWGLum964LgUkf0Pg6AxPtBFJPB/a35O1aiarMqKpKoVKkG7AbKwbBzNMAw+TYNVy8Kc2EhhztKVdMQBHqJEVAfHTOhcGUJTyiYZWePHLdqIf4aADnj+GqZ+ScyaD2mm/HUEO/ZNDXkwJ4pmQ8dkg5DL78HzIvbuYfyOheXMPGxG6WyqGhbGHL9GyZSfoII7EXkCoLHL7WdCaevB3pxMPXBl2pHAk0rdIMSLfShjafNyzm0qAu66nVze61s9KIBJrATeXqitC
 yWH6cpj+
 tRu4eVWeTT7wDLEQK3w/xdlniCPFf3MbDBQIEk29k/fc3gRXRPAGDa3BSmOS6H0q8MHmfXVXkynTrxONjJWwP2QApyLYfKErN4vASgmzx7pJriEClHtNydEh55zBo4B/fFlsdHwjTC65UTYbgbZaIY4D6iJqScXMmKkrx4dG6Qhy31rxrht8+aSXk1HbNZ41IjO6Mmom499G1RUUtcL6JNkpc+2X/yweQwkGMzVke1TbH2uQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory for setting individual DAMON sample filters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 4208fed2b8df..ba0c76c1300c 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,12 +749,46 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * access check report filter directory
+ */
+
+struct damon_sysfs_sample_filter {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_sample_filter), GFP_KERNEL);
+}
+
+static void damon_sysfs_sample_filter_release(struct kobject *kobj)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+
+	kfree(filter);
+}
+
+static struct attribute *damon_sysfs_sample_filter_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_sample_filter);
+
+static const struct kobj_type damon_sysfs_sample_filter_ktype = {
+	.release = damon_sysfs_sample_filter_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_sample_filter_groups,
+};
+
 /*
  * access check report filters directory
  */
 
 struct damon_sysfs_sample_filters {
 	struct kobject kobj;
+	struct damon_sysfs_sample_filter **filters_arr;
+	int nr;
 };
 
 static struct damon_sysfs_sample_filters *
@@ -763,12 +797,99 @@ damon_sysfs_sample_filters_alloc(void)
 	return kzalloc(sizeof(struct damon_sysfs_sample_filters), GFP_KERNEL);
 }
 
+static void damon_sysfs_sample_filters_rm_dirs(
+		struct damon_sysfs_sample_filters *filters)
+{
+	struct damon_sysfs_sample_filter **filters_arr = filters->filters_arr;
+	int i;
+
+	for (i = 0; i < filters->nr; i++)
+		kobject_put(&filters_arr[i]->kobj);
+	filters->nr = 0;
+	kfree(filters_arr);
+	filters->filters_arr = NULL;
+}
+
+static int damon_sysfs_sample_filters_add_dirs(
+		struct damon_sysfs_sample_filters *filters, int nr_filters)
+{
+	struct damon_sysfs_sample_filter **filters_arr, *filter;
+	int err, i;
+
+	damon_sysfs_sample_filters_rm_dirs(filters);
+	if (!nr_filters)
+		return 0;
+
+	filters_arr = kmalloc_array(nr_filters, sizeof(*filters_arr),
+			GFP_KERNEL | __GFP_NOWARN);
+	if (!filters_arr)
+		return -ENOMEM;
+	filters->filters_arr = filters_arr;
+
+	for (i = 0; i < nr_filters; i++) {
+		filter = damon_sysfs_sample_filter_alloc();
+		if (!filter) {
+			damon_sysfs_sample_filters_rm_dirs(filters);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&filter->kobj,
+				&damon_sysfs_sample_filter_ktype,
+				&filters->kobj, "%d", i);
+		if (err) {
+			kobject_put(&filter->kobj);
+			damon_sysfs_sample_filters_rm_dirs(filters);
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
+	struct damon_sysfs_sample_filters *filters = container_of(kobj,
+			struct damon_sysfs_sample_filters, kobj);
+
+	return sysfs_emit(buf, "%d\n", filters->nr);
+}
+
+static ssize_t nr_filters_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_sample_filters *filters;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	filters = container_of(kobj, struct damon_sysfs_sample_filters, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_sample_filters_add_dirs(filters, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_sample_filters_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_sample_filters, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_sample_filters_nr_attr =
+		__ATTR_RW_MODE(nr_filters, 0600);
+
 static struct attribute *damon_sysfs_sample_filters_attrs[] = {
+	&damon_sysfs_sample_filters_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_sample_filters);
@@ -940,6 +1061,7 @@ static void damon_sysfs_sample_rm_dirs(
 	if (sample->primitives)
 		kobject_put(&sample->primitives->kobj);
 	if (sample->filters) {
+		damon_sysfs_sample_filters_rm_dirs(sample->filters);
 		kobject_put(&sample->filters->kobj);
 	}
 }
-- 
2.47.3

