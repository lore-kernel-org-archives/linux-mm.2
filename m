Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7583ACD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD196B00A1; Thu, 14 May 2026 20:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E1D6B00A4; Thu, 14 May 2026 20:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEE96B00A3; Thu, 14 May 2026 20:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8FA6B00A1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A95F8D100
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:55 +0000 (UTC)
X-FDA: 84767809350.25.C743277
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6B402000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y9cLFs9R;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTbOPt0ZD1t+Kc7eW7TucI4LvhmaqFoiC2YXm6isUC0=;
	b=MC1baFiYlEe5afTmcBVXM2vD8o+TF0YfP7w4QKnSMD00BTI014+IXE69tOPZGf/g6WxcSJ
	RfqIokCruIvIrw7FN6FfLoirCqBRZvxXbOE+dUQDk9sz6IxTH3kmD/gV627XwIKFwLrv1q
	szbxX8zCipZWhffVdsEkRpNLPpFMytw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805893; a=rsa-sha256;
	cv=none;
	b=Lri35l826kAcOqDdv6nf/WYIEPrqW+UAGGEYlNW8KLDEs/MRMJYsOP6c0bFo6GqnzTr2RW
	7q+vGbv7YxcNSLMi8r3uHI4MIBU59iwCuPPonXauhDQa9jumzivYxUFc1z3uUsGhz+9/2n
	5Fc9w2RxUGBr68r6vMIXTfhUpyd7B8s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y9cLFs9R;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38BA960583;
	Fri, 15 May 2026 00:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF43C2BCF6;
	Fri, 15 May 2026 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805892;
	bh=6D8hmFjtpBEFiNcmlc/Or4zrb+jvjV5kcWaJtrDEa+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9cLFs9REkUW0Ex027pN3iBAc3ahwOa0LFkVQCgEkDxSV2YClH0+OzvaFHjTQWkBH
	 HjqGgtuVj5gzIkkhVjMjFrmjgpgMbkz0AVzOnKDNA0z/NbcDwkeyr9NE1usd3PLHay
	 9FX3t4ouo9kiY5nyTs7iMEH5Dbt6vjLTP1dcVQlnZ21toqQtIDOEGp3GQulsalRWR1
	 R0TH8YI2DCXJXBpJMwSsJ0h+e0Sv4OIdpoLygvSaZYYRjnXiQ2S8DLDjthsg0vfpGV
	 DjJ7mcA81iM6IS1/LZteN2XWpVf+rj8tWxT59bLCP+wwKImxOhNbk8dEKYVioc6cYw
	 STevlKXwIny3Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 16/28] mm/damon/sysfs-schemes: implement probe dir
Date: Thu, 14 May 2026 17:44:17 -0700
Message-ID: <20260515004433.128933-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6B402000D
X-Stat-Signature: oz5ahfyci19ny13kh68d9wwbh4ea8x5o
X-Rspam-User: 
X-HE-Tag: 1778805893-451579
X-HE-Meta: U2FsdGVkX1+TsD2vJ++vYdly0WavYYw+sOO2+c6TgFVFSx6ApTbfGHLWfxRA8eg2zwdqIorKb/Tp0PG/PQTmiIqavtWsrrBqXdwFlAnE2FMtRn/qSYzDFaMU1oAP+kb9VtNS9adjF6gDvmSToQHY3RqWlvOf6F+dOyhqv4YXQwWPXnzG2gIktZvjPkcBoxdrVwniMOEDj2GRelSxrvwCK+7DD3Yof99skz51wyUFRFt7tpUXSe5jySnS47KJtBTiL9D1HH3Cc9ERpKoJ03L3ULZrc5oWBatcRPx6+h6aEHUErYp87UnuimNP64oxqmnml8HpddPg9VD0Y4cYlpq9LYYjUXqqBNqYujN88e2R2ZFtVz0X/oJ/OTXURg22bSoatoH5/tDSkVykkbPQtnFRy0tmYm9SBXSIBuh1mdJhBPjsec67VnxyFhdYq6RGRBksWQ3kdiS1JqeS6B2F9Nr1C1JGBmOyGF2STzSxvcPD9cxupEQ74LHicbUr88wk1PI6lzSJBqbpN0o6xUheDpF8bsgXKOl3bKMg0CLGEMD9eh/uH1O8T25oxbsLI71zX+4xav6tAJnMsXrn7s6U7XzFm0LTfsx31YV5PfBaXrMd6tPno1bqG+g7Mfpm2lqjqsTpNjwU42mRQKuX0wTzliGVN+W+lfNcR1oqsFycu9lqwenuEeuEfixGu7TycIggxREcZb61Vi5YNE67sg10Ez6M6wrYkn6ja39aJaiEIZ8nGnSlid5elEr1784deeH/NN2DR2VgbH5QiZgIIGFJlCQddUlswSzXSUPjfGEgMaMtkvcDFTeCXBFyy/iv2JdyRGSJGjTu1JxJ3m7o5S89gx7n+ssGlBX+9ArHU0CJX/amrRX1HoYO4ygdNucU6LT3r7tbyaTNgZRsh6ssyDJNx3wcQJ+FoNgPc65XjLcYHbxiNAwCaR45P1HftLMaQJsRpL3ll0xLC2Naz4Ffj1eusbW
 yMB9uKCO
 Dt1u/GAPUxLtD22tOuvo3G/IBoAsZGwVQJGouxVAF/eDN48Xw77rRglCmMIM97kqzZwQmIaglGL+8urWraf7TZ5o78a4dMSiJBejgTro4IioGZ8XL7nQ4TJcdlgQ+G+CxIJzznzO7NCON/NMOSlRax2KrPAiirZbnKdCRnoTPddQmSkp0ravr2rLuoh55udp2ZPEMf6EMzQnjqzut3urthJhyQ950mZz6tgAnLZMTN474xoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory for showing per-probe hits count of each
region.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 101 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 0bca89217b8fa..a83512f28c022 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -10,12 +10,40 @@
 
 #include "sysfs-common.h"
 
+/*
+ * probe directory
+ */
+
+struct damos_sysfs_probe {
+	struct kobject kobj;
+};
+
+static struct damos_sysfs_probe *damos_sysfs_probe_alloc(void)
+{
+	return kzalloc_obj(struct damos_sysfs_probe);
+}
+
+static void damos_sysfs_probe_release(struct kobject *kobj)
+{
+	struct damos_sysfs_probe *probe = container_of(kobj,
+			struct damos_sysfs_probe, kobj);
+
+	kfree(probe);
+}
+
+static const struct kobj_type damos_sysfs_probe_ktype = {
+	.release = damos_sysfs_probe_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+};
+
 /*
  * probes directory
  */
 
 struct damos_sysfs_probes {
 	struct kobject kobj;
+	struct damos_sysfs_probe **probes_arr;
+	int nr;
 };
 
 static struct damos_sysfs_probes *damos_sysfs_probes_alloc(void)
@@ -23,6 +51,60 @@ static struct damos_sysfs_probes *damos_sysfs_probes_alloc(void)
 	return kzalloc_obj(struct damos_sysfs_probes);
 }
 
+static void damos_sysfs_probes_rm_dirs(struct damos_sysfs_probes *probes)
+{
+	struct damos_sysfs_probe **probes_arr = probes->probes_arr;
+	int i;
+
+	for (i = 0; i < probes->nr; i++)
+		kobject_put(&probes_arr[i]->kobj);
+	probes->nr = 0;
+	kfree(probes_arr);
+	probes->probes_arr = NULL;
+}
+
+static int damos_sysfs_probes_add_dirs(struct damos_sysfs_probes *probes,
+		struct damon_ctx *ctx)
+{
+	struct damon_probe *probe;
+	struct damos_sysfs_probe **probes_arr;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx)
+		i++;
+
+	if (!i)
+		return 0;
+
+	probes_arr = kmalloc_objs(*probes_arr, i);
+	if (!probes_arr)
+		return -ENOMEM;
+	probes->probes_arr = probes_arr;
+
+	i = 0;
+	damon_for_each_probe(probe, ctx) {
+		struct damos_sysfs_probe *sys_probe;
+		int err;
+
+		sys_probe = damos_sysfs_probe_alloc();
+		if (!sys_probe) {
+			damos_sysfs_probes_rm_dirs(probes);
+			return -ENOMEM;
+		}
+		err = kobject_init_and_add(&sys_probe->kobj,
+				&damos_sysfs_probe_ktype, &probes->kobj, "%d",
+				i);
+		if (err) {
+			kobject_put(&sys_probe->kobj);
+			damos_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+		probes_arr[i++] = sys_probe;
+		probes->nr++;
+	}
+	return 0;
+}
+
 static void damos_sysfs_probes_release(struct kobject *kobj)
 {
 	struct damos_sysfs_probes *probes = container_of(kobj,
@@ -67,7 +149,8 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 }
 
 static int damos_sysfs_region_add_dirs(
-		struct damon_sysfs_scheme_region *region)
+		struct damon_sysfs_scheme_region *region,
+		struct damon_ctx *ctx)
 {
 	struct damos_sysfs_probes *probes = damos_sysfs_probes_alloc();
 	int err;
@@ -76,18 +159,24 @@ static int damos_sysfs_region_add_dirs(
 		return -ENOMEM;
 	err = kobject_init_and_add(&probes->kobj, &damos_sysfs_probes_ktype,
 			&region->kobj, "probes");
-	if (err) {
-		kobject_put(&probes->kobj);
-		return err;
-	}
+	if (err)
+		goto fail;
+	err = damos_sysfs_probes_add_dirs(probes, ctx);
+	if (err)
+		goto fail;
 
 	region->probes = probes;
 	return 0;
+
+fail:
+	kobject_put(&probes->kobj);
+	return err;
 }
 
 static void damos_sysfs_region_rm_dirs(
 		struct damon_sysfs_scheme_region *region)
 {
+	damos_sysfs_probes_rm_dirs(region->probes);
 	kobject_put(&region->probes->kobj);
 }
 
@@ -2988,7 +3077,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region))
+	if (damos_sysfs_region_add_dirs(region, ctx))
 		goto out;
 	return;
 
-- 
2.47.3

