Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29929CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500356B00BE; Mon, 18 May 2026 19:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A15D6B00C1; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2BD6B00BF; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E28EB6B00BC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A585240B25
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:31 +0000 (UTC)
X-FDA: 84782164782.15.E4A5409
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D01281C000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eRj3FgSG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fozK5zRsbO/r7tnUkGxmAwjGogw0rnl/R48rQEaM2Y=;
	b=ldFR2js2gbGmeLVsJjWPJy2+0Gev+0UikdA+S8CTTD73ufPIXIkh7lOvUdOxAUbnzgvdXD
	RrW7yd7Pmfo6mrEr4R6znPsa3RExaBTRd8stKvvE3paoTkMnWOTWEf58IjhzN3aZQmibVV
	bjR8hw2yqukwmv3bsvTsBIx2RC6Dgyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147690; a=rsa-sha256;
	cv=none;
	b=e3pz6uNX0x+0gYH/sTKNDFq0uka5JCie8YrVzEIa9RzAZDrlTD7AZc2xk1QBFgwzZaQ6NP
	0MdEwuj03iC3MxdY3LVbHkxjQaW+Ly+hq80lCDFr2EMonJIBwU45Yn5mp7a2HbimSP56Jv
	M1fdVZ0NqPoiAa7mPLVrylhHPq1wSL0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eRj3FgSG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B58C445BA;
	Mon, 18 May 2026 23:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5D7C2BD01;
	Mon, 18 May 2026 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147688;
	bh=KKZL2OHisyq4/jWatQDQLTgpqORuvrm8mIvvroFoPfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRj3FgSGn0QTuJ4QtADEn6UIsfBkFbNKw1QGeKV170zq2UZZUtpuMFxtI7Bu6gB+j
	 duhpkUPWlGHjjibjtIaZqpwvh8i8J0TGl0mcFno0V1HQNdTxh2xCGvPAAtGj1wl05Y
	 pwYj14brGvx13Fikk2FvZ4uj2nw8lTXWm8+FukXlrqsKTvS7psYO1OY8gHvCebp0F9
	 um0MZTICJlSEovyZJ+0LicqDLejx0BGzLZjh0XXXEaFClDBSYFXD8BDA8WeZA0XnE3
	 fr9DNSYyITyMGpUIHh9LmyGnLnBIUkfOy1f99wZrsR12Eqr/qVpk2Sdej8Tb+EVvw8
	 EUbVDg4/KY1ww==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/28] mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
Date: Mon, 18 May 2026 16:41:03 -0700
Message-ID: <20260518234119.97569-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D01281C000D
X-Rspamd-Server: rspam04
X-Stat-Signature: txjeba17ea5y431ra8gytrxmihz57rkd
X-HE-Tag: 1779147689-47640
X-HE-Meta: U2FsdGVkX1/q/sKaHm8UEOplhUFqKN1PwVLNudMW4TbaU0Yv83j2rel/LUotWAErRjVSiIrCqT18fMOv2hvEy6J4s7CHRsUmd8b1iyY5n8JIYR0x5KQa960YeF4J1FJwZGegfag73WSIdvWvyIka67Far+vbieR9JQ12+ec84zvZrviy4gGJrPjKkA2v2NgL7IJ7zXHPwj5N67uaJkc7rP5gIJACSyF7YzNX79DpawcFvnW+2j95SnapilR0ZvMjBME0YkUb9Ng/iANXYqGluZ8nLqL1BIjWt/otZxvLCqnfVMwiXbhymN5s2l1vumVipTrjWFOy4SZR81rg8t2wcV0nbiDEjDznx0Mvd51647qCXbZY9gmwE9u5nsR2RHeTVaT0QQ3QMO8K1rwIyZcFeet90sp/v3m/TOciJNX6V5JavQIoJhGFEjU/1sRwTpR6uARg3nMTJMPuvN3SCPs0+/O/lox06SsaW/VeQRZQ9qPNxt6FJ2y3QpvqDVm8eg0jpMobDS4e8YtI6msaFf6NxQSiaivhyMciNcHlH+Y8J4hh8r9tTUMWN/4Y3liy0hVs1tsiDtfBeBil0QIIY7//S5U1iK37vKY7B2cT4Ld3aZaqdwgUaJdE3SxQTKaAI009y93SuH20hp2O2iitFYmkiFAFG3Pj4/IWR/M3tkUX2l5SrRn7pHk2W9vG2mGMwiA6NPsTCxf7Z5QMGdGyDJvrvgmWoefJErVuB8nUc9lubfyXitzgWmLUdR+jFpPh1VfjauDuiHQKZj+amYGzBpmLFY8nO2VpX/px6IgWA1BA9f2AgvPtTk4sJH8xdKNHqctVNfGVIs7Vgy/pKjPBw3cyODjXrAMD8f1baOFSHQ9zFzd0Epuwv/O19ZJ9y/yRIW3PcRbcG0beVTlADRBnvhFiuS2RIEWZULIN35snSIDu3QQygDTE72kVjAninO/njlwcGhCaFT+ZnzL/aOZ6jfd
 6FMjQyr6
 apeo8EFXgHQUGq3v1knXtAZqmJ5Jacxd/PyPaYQ+3Xh/ILNBC4OnEXDJ5tycl9ZTY3gsNqP7kABWcdpiPtcLgRUiKxcpuekE3+445+BWA1zpehAvwMWdr1pl/4u7My0eIKudoRAmxF6tJef/LbOzbd5xIokrSAvFCl+f2y/KE+p36U0Ih5+u4dtpPFo0DzATt3MhY6gVJA/pi/tN59SW76CGwraf9J8wCJZ2lwFW9tfwrkHt1fooV60JWdPWjmw/2j66aArsfX4+UiX/mQRz7RfaMcg==
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
 mm/damon/sysfs-schemes.c | 67 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 0d3021db0b99b..3b66c3a757b2a 100644
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
@@ -163,6 +216,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	struct damon_sysfs_scheme_region *r, *next;
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
+		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
@@ -2995,12 +3049,17 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions)) {
-		kobject_put(&region->kobj);
-		return;
-	}
+				sysfs_regions->nr_regions))
+		goto out;
+	if (damos_sysfs_region_add_dirs(region))
+		goto out;
+
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
+	return;
+
+out:
+	kobject_put(&region->kobj);
 }
 
 int damon_sysfs_schemes_clear_regions(
-- 
2.47.3

