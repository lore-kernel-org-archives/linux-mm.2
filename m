Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B062CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F236B00A0; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26E96B00A1; Sat, 16 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962FD6B00A2; Sat, 16 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82B706B00A0
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D1FDA0343
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:31 +0000 (UTC)
X-FDA: 84774141102.10.51CCFEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9965B180006
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESnahhOh;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pZNI062NAVsocHJg47ev9CKC7p1gC1dHi5M+WVsomI=;
	b=vtA0e48IuXjdFLXi0RD8TZMfRGi6fP+SUwKr0+G7V7YXiwiLKspM37/vGZKP6muR0u7tT4
	xUqYKRgvfD+gfbsh86o1vPYOvNEscqqRbepcG7vE8h56iB26JsXHOwcgqrRCF/+dWoGKba
	1Vf0+8BC6h+Gst1sDNhtAxMdjwIBImg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESnahhOh;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956649; a=rsa-sha256;
	cv=none;
	b=OR1xLFy4b7dWsIFU2RgyYddcSkd/Y/tHKL+FapEPcGVMycJELDYakFN3F+oim6MlZ4+e+s
	5rD5a2HLx15XaCFy1lLGZ1y3UrUcZR7jBilzxkp2LyCA4qNZq8jKnGSDEZ929oQDZn+VYv
	uwQCFX63f2RzwmCvHq/d9uPxDUevlJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5F54445CB;
	Sat, 16 May 2026 18:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEA0C2BCF7;
	Sat, 16 May 2026 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956648;
	bh=d12Khk8CFgdjTez4KpM1F3gx2KwZfImRH/clGa73SBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESnahhOhVlyYRjHuop8ixzl/I2K8aJTIFfHw/0rmy3gV3IoIvAuVCh16iEt19W0bK
	 nBzwZEHfUkGaylVosKJVZYIeBTdwavxdq8LrosxcEj3DFvi0QqvYhBLxWwMFj5SeYU
	 399t4snUJ9ShbFlLwG+jqfjZHCkBI9s1b1Agl32Q1ReDClYp9pSNr4pYY4L9fyZ75M
	 GfnJYKYhSJty5fHoRv/w2H1AwYultRCBMPyepqCUudQ/tWTqMP9TrsB6f/apNDyS05
	 ZeiB0UhfQSFo5g/RW5ocSIxLRcQu/Aa3G0nNcRHQoaKEy4Ros02jYYt0BjL9ZsjmMU
	 THcmrm/FqM83g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 12/28] mm/damon/sysfs: implement filter dir
Date: Sat, 16 May 2026 11:36:53 -0700
Message-ID: <20260516183712.81393-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zmbgde6jwc63enuwzqqk3zug8nhjzten
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9965B180006
X-Rspam-User: 
X-HE-Tag: 1778956649-336998
X-HE-Meta: U2FsdGVkX19ilIMJx9ZWmn1+XxA2GbemJZXhuLF4bn1vBn4KJnc75gOSfZzPdWBIQ1v1uK1lgJLJV2LKxeUFXgXCEyZnQENNmKyySoJy9KSXOrIT+/VP/V+bHbrFT2BDvfpBJTvsGr1HoCm7AMG52T/jktqnrBpp5kPRWxBbcQMKPyhVdL2nspTQChuzJ69HbGXi5/JwwsRrzg8qGILAJGx7N5lpF4mYiPVTxRRKLSy4I/zXcqD3ye4UqdpADaXK5BuZZNi8CjYh2BobdXq+9OE8RriThxCafLF56PsTEDlFYpknanDlgudDkJf+OETXctGHbZOpE0Shm7jD+I2vSgJNyODwURAWmb7YaBWVYzL0cW9iNaZGoX1nKjTw/5FgCr/yhFR0edRTGBFPm2TX5kWyhDcey2wibd0lH6vYjF3/T6pmcKt1KI5RRO6pf0+JpzYED8FyIZDa3ULOPvYC3JqIgyZusQRFGso8yrG/sEWbwnAjuRihwWKqg8z5xKR+tEjb19JR/Xiej4T7ALH4Ja7nLSnkZ6Xkh9lkRyFhi4wULseuKfY2ZQHH7sNDotexhPyI2387SMm2QElOHlOq4Tj3Fz6yEzPf8DDEFxvulfJTqacgvcf7KAPfwdu+3Twz9EyncC57mxCnr99X23SYhGn1oe6EDlT43xHe8hoRmNMfXdlAyVj09e8GCZl6hQkG9BVCy+5WR5mErhKOztiwELPi8sktXGLUOlZzxTMPgfvpYcttPS+HQM59mHGCu8kwYtgW3U7+UTbYDemQLcO2JrCHfrBV8qjkL3aPhrMMKR2zUJmNvWvyX0KepHMsR+EZdIUStRRyYAhzurXaGhSGzbTDunqllerG6Pmnb+wk4AzxVx66CwNCRvxWK08ksKx+APC+g/oFRDzZ/dtN9JhGDT2o/ICEpbXkrowmwaxXl/C9aA0F3Cy89qUGhcCIdoRBglMb16U+r+q3XkKLeL5
 Owztg5Bh
 K9I+ic3Z2zb+JB22a0iA9dH0peF9d4zcxWq/e98TFAO7mt/bxO+BprDxjVGKC5shzlVqJViWDiPjzf3tl52yRZ/OUAOL0SGrdIRhPbyi0Wn1/RlfsI5sJU5XaYDahdMan5+ys4wjqaLN4eaBQDaNdkfrzsnDLlIb6BCtDOG3QvvH6iOMnQA4wcI2iSxQDgXQ7cJcyny6gBjtXFhIMSW0irJVo9SAwL/FptjIc27zObdPZoec=
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
index 184613538d3aa..18c669ce6f81f 100644
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

