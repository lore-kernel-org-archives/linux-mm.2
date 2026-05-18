Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F873CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFA56B00BD; Mon, 18 May 2026 19:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661216B00BF; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A3D6B00C0; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8B996B00B9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5BB41C09C7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:31 +0000 (UTC)
X-FDA: 84782164782.14.AED468A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C847880005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4hbttl0;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PWRASfT9e9/mcjgsKVt5lAtF8CvM/Szk8jOJw10vvk=;
	b=RqLKjZeE5x6WSuv2oXtHwB2NUCc5iJ9+lMCGWiGU2ERlC+xv+XAB8InR0vXMYn5jOa83sX
	CjZjCNn/CiZLqDsmF5XskQP+C8GzLHwN9OlJ/2WgbmmAt7rlbJ+f3G74mDrpwtC+RbjfIH
	z2FEO/TXHvGFKFWPL7szDivGmziyrII=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4hbttl0;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147689; a=rsa-sha256;
	cv=none;
	b=LWENDpZrMlgcdf/6bOwQadmSm+3C0T0J99R07yUUYUhWTu5C5ROi7lzTt82V6tvrI8SkH2
	4llf0GaBcRN4dVKxVSkB65gNY7BQcDcUOL5Qbctn9aDojdb7vceOvu6VmHGkkMz0ikHpOc
	bk5BaYtO4EzvDQ+KN1OzX9FRIEeDszs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BFF044486;
	Mon, 18 May 2026 23:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175B5C2BCF7;
	Mon, 18 May 2026 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147689;
	bh=BCYfbcH/9towdlHTij0N6UcZ7TWGSKJGOLSMnWOdmwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4hbttl01KlVHAccJUJlTI7Lx+yd5GzHlfIu5lkYfLn+PHZM0DDyYQQH2go4XlrfO
	 WVXptW7kLGlJs6NdDHV4KEeDLrEjOoSDnP37W8FIyRvL8hWbazC55jgwSDBWS6gEWe
	 EcvNRGyNgVYtfja1xn+S/z7zmNBH1HQUuTqFC4orI0H1L5zWYC4sqGEswBXYBchg1P
	 J4cLJAqSHylRlg3ymLFateXna2+DA5ZWyB/jjdtw1tjy2G2Rbd8mu0dPh1IaHWWMfq
	 eo6XdF5dk3vykg0/ORVvXuhBElUgudckLagVsPHWD+Q895/DQS8Tqav7D6eDNBq2QA
	 HmhyniNte5EDQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 16/28] mm/damon/sysfs-schemes: implement probe dir
Date: Mon, 18 May 2026 16:41:04 -0700
Message-ID: <20260518234119.97569-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C847880005
X-Stat-Signature: mf8x5o5igu1g8uggzs9pjda8twykjbgw
X-HE-Tag: 1779147689-589940
X-HE-Meta: U2FsdGVkX1+tLK5jKBZ3ldy70T1FtJG9S2hXIsEEGdNu7IYRPRpGwm4ewdZoU9ZFAM50/uGrFPMuI9PEvN75umKZ6/lboUdCBVBAPmPrGCo6lBWgovMU/LoaCW31KvBrhN+p78qaTj2pFKKzEX+ApJr1scCmQBSN9tNaLauWZyrD09yw75kkGCv5RZYFDGy9An5PzyUXJozaoiOAh03QjLCrw8qr105BbPig4zADbNdpFnupKO1IuppdxKirSy8hwtKJ7fcsiFvkriglucfTAHVONgXStWDLavEYCaA4mbUbzHeVIO7ULTbJPcWOe/i7RCv0XhM2Jk+D/uRsuYZSDwxxQNz7rRoyqkuMoEzsRjK0cD9oC1e5kWnbepSQzcf0bwZ43xBa4FWpQLfsXFLhBBwNnfhIMy9ELYtABAKLOQYSRwTf8RTz1FUaUMkuaDB+86llC1RaBz2xAUoEnmtsn9oXAdanxmKQ3z8h3G7uT/NktwSG3R7TXflw9Hp6noKWUiAYIvDzHZyjPrCXOq4tTmfh1yitOjPLcQypRh5Uwxr/fU+6wLqqUNihTHvycocDYdpFjtVmf6CfKFz8E+WVtfoV5HNJ8eHyeJJBYPfz0GH3gjE+6qV7RxuIqEcJOWUc8MKKryc5+ND6ZvOThc82quBKXLg8/3CvnAWd6wDmaMMHw5WB51JZNps/4cQT7NcOc+84u9LUO54DoPJQxsJUB0GXQuVVr0myds1WIMiPkmPNDHuaKjQrr58IhD9S8ZerD/ANS+kZUjmronuP0jHTlC9o/dU+O61W52sRuAcEGlKY+WUmlLCxBVD60nNRnVmIICUT6FWYfl9bQp4tb9Wf3w4xcImorLob+bcfIWMNqKdFSCFm//+NdJNAmJ+OgW3m7BVAbNGc16iqIemS/kINl9ecuj6cT4gPzE6fXB2oFjWTTnRD+Ur2KJGqd/mezmocxn3YcFxdx3VhtfDHdiF
 HXgY2mRf
 1Pl2nWER2oHxryYKReBMfP41SqTfhypyOxodDHESkXkb9FzkXE0tyMXqFHpSvFiqdaVH/TMZnOsHim/sXdlBnSeC0TtC5rUhvZHqzwgC0vX22LRr94kFTL+TOWhZRGluBrkcF2T3cgcF+7K68VgD75k5DzoyxOEq48rqyBkIQQHG9Hdo7xQz7gE1Xn/uCi0G1aVZrw/bdwcVogP6fGSftnTrKwZ4JJ1UdmDltj7oYnO0iw2Q=
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
index 3b66c3a757b2a..7e21e78d77512 100644
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
 
@@ -3051,7 +3140,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region))
+	if (damos_sysfs_region_add_dirs(region, ctx))
 		goto out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
-- 
2.47.3

