Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3932CCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227BA6B00A7; Tue, 12 May 2026 10:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DC16B00A5; Tue, 12 May 2026 10:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84BF6B00A8; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13936B00A5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BFEA1404F7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
X-FDA: 84759020010.19.7C69A4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D95671A0011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H2Y4UCes;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XJQP2k8aVUlLi6/RQSECu672yXaLG765pR+wZW+F8Q=;
	b=KyubwL5NyZwPELB+xc0HQggTAqvJLahWos8vvqssvzqAfVn6mWSK9EyjqLEvSy5k2ASfOn
	sJDdz4vSR9d4vVwiEKFQxuoL8JK2/LBKN9elP7zmeSt/ftEuj/ZxAz6BLxfYdoIgiiUVnk
	XVHm8yVfahFLKr2ZzCos6IgOdoU4l7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596623; a=rsa-sha256;
	cv=none;
	b=x9Uf8lFlf0AMI+o4Ve05+yhDDR8v3OaAS8P0i/qYuzdWbnsEtF0ymAnZZbQLrEVS25kKvA
	BAC7kGxt/WI4/7HXDKUI63yjO0enj/u/1Tq4HJKQANEs4HZYl7C3yTfH/Q/SOH6eMmj5+u
	qTQ7l8K6PLVtI+Gp9j1VfhceXtLxp6Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H2Y4UCes;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6830D62D50;
	Tue, 12 May 2026 14:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7049C2BCFA;
	Tue, 12 May 2026 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596623;
	bh=9wtcGKd2TuBKZzqqapx90lRnyNtTZA2HcxLo0K3VUw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2Y4UCesOy+wGS0CfoGDjUOwM9unW/5gtT+8MjUcQMjvBOCdeXJijU4KYWHX3fjRL
	 8ldeztL79sTfhJjpR9WET45TZhiY1XDl5YIx+1GXRP2hhjkt7YTGnjZv/7+U4yjM7T
	 6VudPGcxRF7Wy+2eM0/t+v0a9AU7PFD9PWKD+UzhpeEvU9JMyqgKYY+TZ8NRBzhPyD
	 k+qxrPis8998X5cl4z6ZfX10p7/NlZS6Gona85BoJWHQZ/9LyIomYG95WwlJoVItnc
	 7Mh5WSkZWdyo6EU1xthtq+oRpb9MT0BABr7WHaXFvUs5pfrGh4Gm/ao9ollbCm8eDb
	 tEYbOq7lYhYhg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 15/28] mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
Date: Tue, 12 May 2026 07:36:30 -0700
Message-ID: <20260512143645.113201-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D95671A0011
X-Stat-Signature: 4xca8ij33jqbt55qn8e7oom9xexpzafc
X-Rspam-User: 
X-HE-Tag: 1778596623-965871
X-HE-Meta: U2FsdGVkX1/sKBRZfKOw0uflqQKgLfDNjHBSX5OYUmxwDQ1qlMXNSiyHizFxDTzvjgEF3nf4BNl/7Z6CxrDqDNL8A5kdQGaEsf6SjNVgkeAVSY7Ua/qvxXP49n8WWphUpPDhlZglE9Vb9DQBE6rqCNQywSQ/inFjAcMMQWcVraHdR0E0a4sfmckoBff2l3nE/xSdFsdNd5CahNdYYdD/Vj09TQ78izKib65MPAmTJI3L0ABROIBpv/LO/zmNEJvI9KCtilniulBpVJfymVznqLM6N+yImVmVsfDbiiLGYRpsHeHrwfbB5xLK5ySIm7SDInuhw0I2Ga4+XZV0cGBNhYW/FTu1hrOAUYOgD5v3/RLe3ZP+ipj19P7S6mINoi7D3QYisjAm8pfBsXR1YM2xdUFau7SsEmQwTwR7097oVxQAG3k66cDja2T79JxkMvVqUAMfl2hzuaeJ4BGiUU8k464mgODQEw6Ja6ssm8qooYBN8c+rHk7uneg2HorNQPIAE8dWxI2/HKKT9IRMHpJtzTz0Q9UqkjetgVClYKVMeIBswDibH8SrWPDIrbgC6W+/c23ISlFYxaDHI3OYgFyPAhYwwuV6NjoSJlR7jojLSdCh67GIwL4AtZq9pFXgZkjYZJHdnAAUh2LLYiRJ7nkq7nvhbLNhiwVGd831xCdqI4YkwNAGyLM6rF3hG1zpM26oS/baW7A3hgn+he5yMefDXOTAlxi21QS48ljd8WCjMx/yUV+WwRZJ9IHN6+l1AQkcYuTUo/rGCFgilVZppKIyztr7+pGh8ArwugMrEnMaU8L8zTvnVcYA7no3kyXs1rfApZQFPlZPYV8IOKrYeVnq7UkE6Ym4ErSWPYLhC7onxl3OE8fE5EXaeLJ6Z/JxRhnXh5jXDsYdMoLRF/yUqgSxu7G9Gt27P0nsOv5K0PsSbfGQUqtRw24PwsMr2ssB9omm1ush2H3Z4BewT71yjyp
 AATcTZXc
 aEqNcECXS9oE7uINNOpKQlUiFNQuhlaM1hrSRL8OMJUxQrYtg2IhX6DI5e0ynsaLmeQQcDKWCxfO8rit6F8mInVriLfD++XTZQ9ugD3ClWYez/bHPx28emaU3QMkbOcraIeGcZd/lrPF74o0pCOb1+LricEqJodyqKCosNEedtjYvOAeoUKM990ZoFAvzrE8lU7XLt6XZnCg9y5LUN1KnYxAQgp7LzuxCngNthr7PKb21S3Os+idyguxGXfWXUySKLbrGFB5kkvIs2gM+yfwhuP9vXA==
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

