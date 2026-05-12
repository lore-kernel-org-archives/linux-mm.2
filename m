Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD6BCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBE26B00A9; Tue, 12 May 2026 10:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007B56B00AA; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9C56B00A9; Tue, 12 May 2026 10:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4B7E6B00A6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81B1E120502
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
X-FDA: 84759020010.28.39B0C29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C708818000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CyMgSyua;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBly/+7gvuRZzFtW40QeTCf+qgsB3N01RFLKodU74cs=;
	b=cOHDiqbShSZrUaWYzlqvfLkOVJ/OFeGcLZ1Dk25mqbLOJEWIhcCfuCHurzsMx3rKDkCTPM
	dhi0qOggyDa99N01MbWtICBB1x8rnKsytiCUxo3xhkqHSDqx/ro3AbQ7RnL9BTzfBPZbPL
	b+O1ZSZ7ks7zxibNqtDoA7pvrznN06c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596623; a=rsa-sha256;
	cv=none;
	b=G1J/H+W8t+WF/pU4ObqKaFqPNQH4ypCIlE949gljmUE79lnp6anGWLLZrHiAj+rpQeXPwa
	hQ7nLQQXmbaTHv2HAW39Jp0NhJz8Tu9z1fBrhXXIDOqaBZrKOCg+n7MZq9tYweG9UNrbss
	G07UK8w35k5KLnYwNAFwiYGJ4f5+NhQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CyMgSyua;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C86F44AC9;
	Tue, 12 May 2026 14:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE4C2BCF7;
	Tue, 12 May 2026 14:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596623;
	bh=TC56CsSb/enHtMc5P6wnTRbCZbDbhhiRuOMQ+HlenHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyMgSyuaR+Dqi3/VepjfWdFo15Kk5zbPgy/fMmKJFbS8jSYnhLPqkoejsBCUY1YPl
	 q0aUfb8AnuXqI2h57l4/XgjvgsE7zbw6iN7bO2AxS27T9I9w88PUPiEgPvXMGpg4Vm
	 c0o4sK74Oia7MbFr/nq+3RQiDHo0Pc7pqVsnHXR+Nua7hjJVjIODwXZ0vE6JUKmicr
	 FgEdyF8Ot2baM0DnkApa4/eoXIXBe3AFMOqdsbvHZyMgNTKmjUvO1quQNI7I2NIYT/
	 EzJ2oR1h6zaw5d1ePflhA71KYmLPNQoraZcavp5vz9xoCDhMTfmoI2iYciU3mNGx1Y
	 SNBx9wmYarKWw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 16/28] mm/damon/sysfs-schemes: implement probe dir
Date: Tue, 12 May 2026 07:36:31 -0700
Message-ID: <20260512143645.113201-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C708818000C
X-Stat-Signature: dern4jcb49drhj7epdt8sc5uyjz9es7r
X-Rspam-User: 
X-HE-Tag: 1778596623-113500
X-HE-Meta: U2FsdGVkX1/XyNAoZT1k59n/O/9mGwEAzC8MvBzdRoruni4DfW2dYMNla1e2/A+l/FAun0UA6vjjxAqIYAzsJIfYq/gBw9eviY8Z1ZdVlbeveXDEhQdaJfziZuWKrdXs/+nr1ovNn6eje5SltkXVAFcP10usfyjz4/Y8eNR7bdfLMSk0ayOREMtK91VTISWr7aTn1/1N/uh1LVuYkGx1q+t00NfqDhf/NBK2W+wTQiJGIZmYeii0I80vT7ELSjYo8K3G5MysI5Qqs3KCpGhq2SGMJPU/g8gR5X+U2mD/KkGwVQ2JDrVn/JOhFGxNp5ZEma6FP0leqOVEkuCzKv7AwPtVhsvw6kjTI2xWEWgNCO8Y3gY2RzdTNG/SrURYa47XKtnwwAk8Gi0EGgFMQyOF9U8wYkPzJaQ3DhtLTyIAhoWPl291i8yh/gr2m0g+qHyEuP2h2ACTa6IBhYHEWIzqul/0MiUH6elZEE7gvNJT70a0zlGPzIS7kgUoLHG6m2Hl8tgMdRI4CLm+SQJNeyOVUgey0eV6ai3DBRbk5GuxnQIsxvruq6ncP4s7XSmJkSjQ7HFu+A+ERGAOlz20U7jx7OwIhUM9eDRr8FH6EPtbgREkAiXQiKu3MrM7ZSAvEYp2MhmWhiH5mqCvnYdrpd5cJpdGSvV0nGjxPPOU7w5dMakM1z7ytUMX4qqn/t7+nDOGzzxn0QLzw2bAcCf8HGEYSqYr5Kfbm2fprLDW0vFEef5tqayeaXw0q4nrRTrOYWX0CH1lpsNxmXftP7Dw4Wwne2SSLC43u5Iow3fNv0syofNxjiwjETMlngJAS0d5aO7+m9N1A9vDLpDUBCpnZIDVFz4NnzhN5VyfW8d/2n4D8s0u6LhI0ai/SGbmg1ybp7UI85K9JDp/wOYzy+9NJ65neSbJFGPbhBSYBxNQIGl/poc4X3Y+yAsVCmH4cMN5JvV1M5g7Klg5wnB2LHdUxTL
 lfLheYf8
 6tAnuu1iRYyKQzRd2gcDrRi06yFSDV7260x2lJI6gMDeWng6cVGXvLNcvlDH2Qu+gu1ZYMvZn8WOXGES/JSslD2vp35bUJ9vwt51aIEiJf31v2ttJV1mNjY1h0sxPsxUzCNti+dl0Nou+N8HSm+ImhqBvYnS2m5o1+GpeLoZ2aVZFZ6MD73b3riGkUs//I3CfcBewj/V9ecMSVoR8RiHTtJT0zyqgIzTih08kOraAdF6Qu+Y=
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

