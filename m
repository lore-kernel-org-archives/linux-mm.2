Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 970BECD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CE36B009E; Thu, 14 May 2026 20:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD606B009F; Thu, 14 May 2026 20:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85636B00A0; Thu, 14 May 2026 20:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAE256B009E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7489DC2798
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:53 +0000 (UTC)
X-FDA: 84767809266.24.62B1DD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE12480002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RA2TSQEV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805892; a=rsa-sha256;
	cv=none;
	b=7u1iG9wP5jYIRkA5b1S36Xo36baF2/2lmVNUejfHIs8qDTTum7nOrtBNIZUA8bOHq6sVZp
	0kQLHpw6xBnxU98TPB7awa3NHjJtN8ExO3Hpi4yV/DRWBKDOpkwd1ERl0YOG7D6ejtVG0z
	X6Bk1JRhDc+56CjmV5lVziY7GrkWTw4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RA2TSQEV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=py9c2zaAYyee0yY+OUQrpSMT1y6XKfC5Vd32tm9XeJM=;
	b=S5P4o0oFgP//K6Vlu7Ms+G43p7K6HK/scawcdiJRHLt2JBFDgf3Ay/OWYnrruYwkgitZiJ
	SUeN6bG/VPFaroPv/DXhR1KrmfUGOkTpj1b96IZdPUWkdeYT7dDwwd9pKM0BaQ+3WMknDo
	LLCuhBJXu26o+WGQfbmXAv2yC03uCbI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EE4C4036D;
	Fri, 15 May 2026 00:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C939AC2BCC7;
	Fri, 15 May 2026 00:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805891;
	bh=zfDwKIyyj4OhfH36VyCWqtoWpGK8YTbqZuxXCa/IX6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA2TSQEVJhVhzO7gF5aqMZ/OvHsa6L40Jgzr1AEMykZpdrFgObt/f9S5tat0JddI1
	 naZzD6QeN8XperO1UlN+3CtDrK5cI0mHkyJQvvLPRxyJVC2Ioa9c5EXRDPIYCtdVx8
	 yIsz9NDuh289RfhKm46JIXVX6h88MAu2hUw7ccI6QMadWIEU+mAEcX6d/Pve+bI0Cs
	 rqsj1X5e+3l2BsiuP65I8QSdrBVl0YS0xuLdyu24SeAqJAm0nU4wvSiuVLdoVDDSQc
	 aRFQhZ924DCxOvbtPCVHXMngPEX6YVvKp5RzMnByG20O6lTuUQCTTRVYgtGwWQVIT0
	 QztMt2NBIcZJA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 12/28] mm/damon/sysfs: implement filter dir
Date: Thu, 14 May 2026 17:44:13 -0700
Message-ID: <20260515004433.128933-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ophnt75t7xjqqswcrfk8upoxfjyziad6
X-Rspam-User: 
X-Rspamd-Queue-Id: CE12480002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778805891-132972
X-HE-Meta: U2FsdGVkX1+2efNkoN+v2SsersJOe2pPxvQ/Oja32r3Kzb5Dr+m/rCuHHVU5jeJwAm0331CH1bvRNLCBWzeOALNvkAHknhgCCxUfophLwyqiZ23MT2pl9E7NPwrwxIUlDSHmFaNahrx/pm6rljkeqYvMRz3Ca1FHqqawRUaqTqI2XPKNUT6rdLQKcEQyHEmENVYL8MN2UbCxeuAGYXag8E94T03+9sp/hS7pF5r0snL098/jNnsDE/AS/B+tRn5g6wPSNV0sTAnPe071cToxgvLRIS3KIn5pA6JyZEF2p3I6SZ5yTXi3sL70KvPjo9HQwRtm7zUa8GQHiC7xHvzA9UBcOinHqV8tVRKrJIQeEKTDWnJ91sa9kA9SQzLBIScu015+DtB2FzI313kt7Kir35WU1tSZvtNfaX2vXFRp5dS3z7PceMgCqokOI9OzJOGgdIH8Jvn2+xGLOv6CbPV0dsOKxbqhs3yv2sdKMOXT6IvscIuSiB8/zv7K3Y4FBfV82Vut7hHYBU3DnK3i+f0uUp78XQRW+qrFDtZ9uK9TfD3STBC48dfrQgO4PWPsAOs44s+tchS8XrMSebfdmrY9MzS4nKM51snNXI2SOfN9qKEcYlRbXZCw82kcZUPnUJ1anMJKXsu6O/PUSrhV4nwxLiboyzhu8aDxm4l2r1vcF6VpClKYgZ28Vuscma8mzL85puTXYVHJL2io6a6fr/NXp3h6d+9I0Bx4A3bl2GFurr/QV2tYA+RG+EbdIqu744nz8JSD63mfZUlfvrjDT01yr7D6w/TD/p8rZTJwYu65sFC/+36tyMciLclPKApJFz6bqwEcHFHFH2m9Huas2xUlcI+gmz1cit1UYZJn/L/1ksVypXvz7PN7AGag2ZmT394faWoP/n27caw+WViB7yLh0j61zf0JH0oJOMLk7rHAgYB0J9D5PFehvl6aYH0IWzyiCye6ZNdHOMdjuTwkI02
 2I00V5WJ
 870I1rkVOJfuZFi6tOqs3ljZ4VBtYj9UOeHRHiAUBaOTHgMKMKk3IOyfBkzZYTfl0mhspRMmxFf0qY1NjYpgauqmzwyOXxnmYahL1sxAnRRBdXJRaaXuQdlrlbVMwl7neELq4Y+JFDzB3CswOSbP0OjOzhsj7YZ1sFCaMzB/zzpOGwWn12ChyL8i2QnDPvHub7Eptm7ns045BXUDFRlm4WqhanxwjNLosYVa7aqtfMRdcixg=
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
index 6b15886190545..9f4ab28cf8734 100644
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

