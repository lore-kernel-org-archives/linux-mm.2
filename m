Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021B8CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4016B00BB; Mon, 18 May 2026 19:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6176B00B3; Mon, 18 May 2026 19:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130846B00BA; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C103C6B00B3
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82BADC33FF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:30 +0000 (UTC)
X-FDA: 84782164740.13.E8770BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D01FE10000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=txaLbiZN;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbucOkHOmgXSIIdVITlH5aOd+EM+HAek/wo1AUEzzmE=;
	b=6e8lW943zN1YopaTfMRK1cA/OhdVtQfmwWSWYSoy9OgJufZIO6OSNaaC5CWx4d5GKYDT8z
	9o/4oC2RicPhiVpdYiskMcYG6KZIDjfz8LRaTgm58Qp6xf2nxsZ8nkKoZFNgWBXzVzTzGr
	xL+S2w4gR2Tj633yPYLovjAeVI8QRWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147689; a=rsa-sha256;
	cv=none;
	b=F7RYTfh4gH++xUTphzMg6D9Ll400GEhwGn7QkZb3WtdT/9ByEECIMQ5YeU5JRdceYHajVr
	cA66mEIkYzhWl4xbdoyTe0Ljtggc+nLXbxz1PkfhE2M1zWurYmEp4VK3MOED8kKN3oa9gw
	C6ghaxYzc0pJTKTegNYgrSLHjtQJD/M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=txaLbiZN;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10185445B8;
	Mon, 18 May 2026 23:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD693C2BCB8;
	Mon, 18 May 2026 23:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147688;
	bh=wvd91ossHZGuFvsrtP96Nxm/U0YmccwrdIjw/ZrtSSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txaLbiZNBQJiq6Zd9QUOcVEvx9pJQt7EQtmx9ikkY4h0tGLsWWzXImChAw78wWLrg
	 NvTvRL0ftQecPSWuh16J2Xk1ktWH9Ql9MXisPYuhd1eJBeayQ3HKz9NHWWYhKb6kr7
	 hhwSVI85zXdo/6ZBwLj7ov96QNCNtiPGv8XqtH61Njd0hhKRM1DmDBVAOxx3yZj5vD
	 pIHEzFj74onFpR65qjZtKsmqkN2I88A1vVvOhVUtrCyET6/cQYhLEVojV0Y06E60Qx
	 VFDiqndmcyNZRqWw8b042buVIOFn5GATfSwcp49QAkneZ5TG3xa1STVDUp8FGsb2Mm
	 gmBmQo1FpotBA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/28] mm/damon/sysfs: implement filter dir
Date: Mon, 18 May 2026 16:41:00 -0700
Message-ID: <20260518234119.97569-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D01FE10000B
X-Rspam-User: 
X-Stat-Signature: uwg3ow81suoryz1748x5b4arp7ctuopn
X-HE-Tag: 1779147688-817092
X-HE-Meta: U2FsdGVkX199j/JRYHVfaf2stRBCSbq1JyMDWtm82w6NuH5ssOq+pIeGkm6K1p7zK+tKbS+0eeInC5+b/wVqDH8nGKHnrIOgdJ1PTq6RqBwwJ381yAnMrv/TgI8plb+83we+H89rybR4CN0rMJiUf7o5+0PBISyDToHQ6i8aeJTKW3/skbpD73sbKdhOjUoHjo0+zQEH0NxNjdZzP7cmBKn0KjwGsNC3mHis34vzB7GaHxSBVElwjMWaE/H68Ea8FP5iKcj51ecmmjU5kOsLPrCGdkkTSH1z3KWo0ezPoLtK266wPW+kPRJLUCH3n4IwO6di1uV2l9oAougpc+rLRR+4jgoEba7vGJ/ZNFiEriNbKREvhq6ZLs/9GTIKIrfgfzwn33gAanhskuDK2y2eMDvhnbcnllktlXE8pwHdD7rkMKurYIW88TTzs0RY+RwBjTGNXCspe+Gc03W64Dc0A9uKXKF7JpJSIc0r2Xx9IgZfAY23m6qow6h72HpnUR0U7SaZjhfl01oReIAX/UiPBNw1UHsHM7NanOIgdX9fzuIU7JXzGge4wdo9GoMV7ZC//nyi+gGTyGAj9mikR1faSVe+zj7m6SMv67qd3acmi7lyie6HT0ze2G8p7wfPjGbhRiuXXtJiYh/GmIBeuU+ioRHAgJ4xw8qpixzJMrN5zRVT9Xv4b/62gFXq/WHVpP9dhAKoqGYBM0I15XwDklRr3BoRkJEgADMMVICoWJlsc10D3vJFZW8ayfZMUVnFMetss5jXPU9ln0vXRkYGwZr+QPCuoV8E87nvuzXMAwE2zortL9F4wpALCn6UuuGeZcXukCoRcyY+PueIbmQeAOSidIP5E+FFHEMSOiAa/OKaur4jy78MBM3vlU7afjrFz/CN8HSeaG14zKj0uxR+prJmI1cJmE6wRduxQmc01+CJwtjCFGVpjFuErE0e6jLY+zppg+yd5q8r5MWdS/6h4ys
 Cn3IuqyQ
 9LB86sKvGVo05VLNGJimATnigdDOiz37njlPbvkI+56OAxCcocP/lVGQL8ab+Bc/Qv0KJs9IN/XF6Cbh6coq+AI2h2usgmq5pOvkDX5+eu9jdMpvxU8EzfZMuuinr3zIzc1BGsHQfGCTq48fI8NZfBeq3gtUg/56JdODs1vrGEXkhXJ3eKdJ6BWJN4Szu/Z4UZq1n8G0kaYoiddiH1djYNnnMvLRKnk8J/1T45JKwxJ4mXIc=
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
index dad4985a826db..2dc475ea0f0f7 100644
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

