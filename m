Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 501B8CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3740F6B00A5; Sat, 16 May 2026 14:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2869E6B00A2; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1267D6B00A4; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F17D66B00A2
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9CE61C0FA9
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:31 +0000 (UTC)
X-FDA: 84774141102.03.766F348
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1620C10000B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc6CQKYd;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1bvc7e5/K/xoPgHgWH3hVhXwUWQE99A2m0qi3Dsyqs=;
	b=4lo/bRwufN20HzhfYfMoHHIGdfKVEty310KZ57Jzm+tAxf4801FTQjiZLW7SQHnGDWNmii
	+OljFCTOElFwM81Q0S6tRpsfkxukvDBmhzwyuo3pMk5aW5evVnY++A7ibSTGaLaMptDVdc
	SDBaMXlUD91Itct2vyQmy/06uX2zmxw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc6CQKYd;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956650; a=rsa-sha256;
	cv=none;
	b=3H3nxS0jSQYQAz45XTJwAi/cHaGlAgDZCdCHphr+mHWiPrW4s4nIsbuJJZufj+03+eVVVa
	UbFcT5bOs7G23LwdPnqQlkhqFLCC4tbchitjjTDFfJsCg0qowI+VdDjD/j655s+PBjnU9/
	6ya+aMK5Fi9grlV40+okPxMzjsNI/XA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3AD84454E;
	Sat, 16 May 2026 18:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8D1C2BD04;
	Sat, 16 May 2026 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956649;
	bh=uBWhjIohq11XfMogSOrNzs3xASVaFicaEYRMR65bdGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qc6CQKYdFQbvC3v2l7Z69OzjNq2n3nvs/9lwdPFXtPNbXoPox1kL1R67loOoA3lEN
	 aGICXkkdk/4hk9QmC6u7J3/Y4ckHNR6Yj/X411FGYphmw9oObyNJsji2YAzKV+u86g
	 wa+K/GfKwlZrI4SzdF1PDxMxY38uJbEBJHE2gkW5bAxyMAai43hmqXgEVKTCx4bmxE
	 EWkY83RopMO+aqT7qSLyWw626UunmvGaAetHm2Nlzxn/OaYHcbcVtSR8q6cNgDy0xX
	 mVkxG+LguCUZLb6b+R377HwluHwHRgviUFCvTnVU4FViCWlWMnAzeizDmpVrEcXu1O
	 6N2X0fmLhp62A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 15/28] mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
Date: Sat, 16 May 2026 11:36:56 -0700
Message-ID: <20260516183712.81393-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1620C10000B
X-Stat-Signature: qi9keubhb7za34iuzqnwm3pt89jtbji4
X-HE-Tag: 1778956649-399947
X-HE-Meta: U2FsdGVkX1/hyiDnlmXDyT26RGsMew5e7d2z7SU9oBV4/LkjbUSs21QUEOcjqNIZIZrgHyNYa3tG8i/fsNRgV6an5UhRt0tOKaTRxsuEdBHZQea524EfZ0mVVTlw9kHn24fKqsLelbND06zFjBAEg2GGgR1Hodq3QGIatEQAYqxFxOfuSRVG4YRaWKoGwVkwe+k9eDhJcAJ3oJ9poR7qoTFAfDL4el8+jMOWG2yo744eSQzva/btDQzK+1QwKVOTQsH+d3EyuKEm4aklkYGsAT5nOH4sjrUoGcvpLxcRim0tgKLZT0u9mS8XWL4UEljUvkQsfPa5aRpkp4jnhpCEIArE1OSgSCdNJzQcsVLeoqpuCjwAHgULv0WdO3EyRH3kFMu42V+XF363AZ/H3v7EbvGtn/Y2XWcwKZNW5smXjq/n3QJHnOImR9letrXFrL6nnUOn6m/cB/yZnagZPwH30CzKlwVJJgW1Mpw9GGGvw0RWscnMAcHKEPhEkwvrVwB10ZcVJc3wveBJlgRwmpkjxeIMCUD3mOa22EAeeoC5iAveihEeSyupiTMNVRjdSEenaas93sRsqUoFJL5Ic01YNGoiPO8ToHywiSPHAqcxjyCNxsvVvVwi7mq6wR90+5Ap4tRGZnPYg0I43l73A+5M32hx+hkTYzLXoxcDUug2dHtNWVTeBw46YHVFTOSbY8JcoYhYNMPzeMm1aU77Dsub+n2VkTtUvlbk3WUkz/onevapt1cY4EzwJY05Q5h2DgB5BJHnB2tYCQjrJ2LZk+USolcqURhs1Y/srTyu5sk68I8b3RDI7Pue5OI8BeCgznyqtPZaDLhATjdgq1rg3cwFXiz0L24SW3oPS2x7smtiwq6tUk0dooOYj5ZrzxrjmvN0IMHnOFbZMO2/SgpU1h64a7kr59FIZMos+n2VyhMjwtp515zuU6t9DhCjqXYQf+y+FIaDO7d/d4WHHHiw6u2
 sha5P/pw
 YhG6JgXYz3lr6PWBcsJb4x2ZaLOvvandaHjC5K5cjJKwHXUm565nyJdU8zUVko6kTwjWGIbaqNCZHgSfr3uFQjwuI3hzbmRXFGG06rdQx5nqC4J30IpdsxG9rjcMhrQninNCQXVYvh/KF5x2afz6oqjeHJgUWd+xfC7ct+puiQwNUDHqwP09JposCdbOKHH4lTUOLRNXKC2NK2KLQNo/LS98i7HituO6p2XAdU06BDvLki/a2a8mMzNzhKg9M7mptb16mL0OrWlZmhaXBOE5aAA2aoQ==
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
 mm/damon/sysfs-schemes.c | 70 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 245d63808411a..8998df5bdc5c8 100644
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
@@ -2927,14 +2981,20 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions++)) {
-		kobject_put(&region->kobj);
-	}
+				sysfs_regions->nr_regions++))
+		goto out;
+	if (damos_sysfs_region_add_dirs(region))
+		goto out;
+
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
+	return;
+
+out:
+	kobject_put(&region->kobj);
 }
 
 int damon_sysfs_schemes_clear_regions(
-- 
2.47.3

