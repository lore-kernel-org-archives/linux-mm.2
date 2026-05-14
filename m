Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CCA8CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC36C6B00A6; Thu, 14 May 2026 10:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27336B00A8; Thu, 14 May 2026 10:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B246B00A6; Thu, 14 May 2026 10:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 592BD6B00A9
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E1C81C103A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:26 +0000 (UTC)
X-FDA: 84766207932.04.0BDCB72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6DB011C0008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DPIdtOI1;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBly/+7gvuRZzFtW40QeTCf+qgsB3N01RFLKodU74cs=;
	b=FIvh91xemyBZSFx+C5aSRkyToLbQYazJJwifBrEaW9Fv0brH1pX1Gp3KyVF8VZZnISVmXO
	qaSGmY+fsWscaxnIDBfK6CB1jCRizVgE7vBJ99JYW2JjcCcjWHI/VDEM7ZkDouWJFtit/l
	oxn3iF23dARliYwoQ2Zb3PFlTmFi09M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767764; a=rsa-sha256;
	cv=none;
	b=PqX+Us7eU1toLpYZdppsJoJPkgfvV7M02Fc2DGA5svGn/2MF9Cj2ulXD7NR3CFC5S3OI0w
	76x6Ui0foWwQvSSRpyzZ9lIPBINVKGHaVVmRYLNAUoooPYi/PgHak22+YCWwOEEOv9KW11
	RXJraCcJI3gnMNn1WkqKD4Exg1UJC3A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DPIdtOI1;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A41454442A;
	Thu, 14 May 2026 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE20C2BCF5;
	Thu, 14 May 2026 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767763;
	bh=TC56CsSb/enHtMc5P6wnTRbCZbDbhhiRuOMQ+HlenHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPIdtOI11VedNArYqgABM8KViGb+Tl46KlqZY8s3PmEaeDqi5lx7aI4EGLdk1Fu2o
	 SUeK4s+XpL3FiBxOeI+1GefxQwRoVrinQVKkF7wrNnNZsULos2ODtr7PE+5dzoC1jq
	 id1P/A6fy6W/Ul0+JtoGvIqrACK2zy3+C9u0HMgxyE3ZiOfwrsfWO3QsmngEB23Rzv
	 gHgrIj8hoSgq4PJu7J7oTqaTuLIt0EJVM3n41TsAJo4ZaFvVJMyI2XGIiAEQRLbE+s
	 GyZfzjSmNrPBWMmmzrhf2H2b+1OjL92PS0+2qKYpIGpZxnHS58XAR8h9OdajC49Gfd
	 p561RQ1Q0oteQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 16/28] mm/damon/sysfs-schemes: implement probe dir
Date: Thu, 14 May 2026 07:08:49 -0700
Message-ID: <20260514140904.119781-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6DB011C0008
X-Stat-Signature: bxsoqe8z8ka5796mzkmmqw7xpk99hito
X-Rspam-User: 
X-HE-Tag: 1778767764-470640
X-HE-Meta: U2FsdGVkX19TTck2kFTtqqbFxvcx1W/8jH6syvXJ3UThlwmEocFwbWr78dgFlgXZTl9eRhK/QhSc9KjDeJnsr5tdAZed48bfON/g6MeIBE0zsyFVGUmhbJlX+Kzu9780k0oJn9HGOx4jU9myqGV0ZbRGz7dgDfAUPojpxlK3hlQutHsWbc/SNtE9ORTpv9AAb4K80UNAUoONfaMgi4p/yneLSHC3ADGE2ZbRkVsVHOHjo5BcGJlMDxy5yFmSJgEw7ZbNDMJcfAgeCD8bmcGzJDyHbLzyuxW6TU9lj/vqfA/bkX5JI4GC7zIpK36GMTYqIH6JqXJcU2szoUjGtI0TcEv1kmqLGmgZAxW7mO1SEVmNrFImKQs2Lrn7/yaD12Kr6hA5EUwWZkwu9JO+CKQQz6SUzxMYll5XyIBk3SJNHMUA8t2+PjGese0iWz1KHjBwU5dKHQNo/ycsXMidapI1yKAlaSMTF6qYFdlDd6jZJ+w/r/3f7MOuP1ahIB4J8TdhaCYf11+RyMdHI1zDAe9FJZEaOuchBdMFX7jJtFucbeq+Wb+aiEUobfhZf3eWJVQ5WyLl9NXXYuiPTUIn0NJYhMp6AaGRMXDwb1XVJmZEvMy4Qa0vxNjY8NjR5xMR4z6z/VdqtGN62YCDCM7bRAox4T87Fc6oG2/ukAuBa+hvgqs8YkXXN0ofBwSsWEMwb2MkzwDyLy4BF14UvEP3wAExGs640bCgcmBN0wES0NloWmEimH6i6QsDwO1KSDxqhW68XZNfzDfl5O7e6h1ibFlPbLSUcUZi+tkZX8frRkd74jpXT2Q5kN+ZFd4eJBILG79smMiOZnw0Sc8I2YPIiQs3KjTUKAO56dmA2tcZchCsw2V3hGgcIvgPun9uoB7uHhCEic35QpV/vDc4OUVGw4N8DDjjYmEvwm5yrXd/QA1ibFWoylYEsoEHxuM81L4BSWudQX79K59rXc0bSDUHG3B
 vFFEKWVR
 ihzeXCn+6KayU5s/HRGbGnhPQCHlw4lAtEReazuhKeCsyv+QYS1TOZj0N9iSOnfYf1q/kWTTzRXnkHh20i15PVkuKjNOM6DfcC56lJL4gd/3b/QahOHAW8ETAvQGihaKCufQaLtZcd8eBMeby+0alZctpOqNfS9pazMkFffm9orzq6lV0O1EvfM2iNXr93JJG1/gxsjZfheR9o4zLs163/6IkH2W0lbcr7anCfGccxNMfytI=
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
index b2dcbdf1840e4..91d6ddcf1b32d 100644
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
 
@@ -3054,7 +3143,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region))
+	if (damos_sysfs_region_add_dirs(region, ctx))
 		goto out;
 	return;
 
-- 
2.47.3

