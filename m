Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE4BCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4222B6B00A0; Thu, 14 May 2026 20:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384406B00A1; Thu, 14 May 2026 20:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C18D6B00A2; Thu, 14 May 2026 20:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 186BE6B00A0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D60561A0689
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:54 +0000 (UTC)
X-FDA: 84767809308.03.210913E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 521E1120009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=plApqCsO;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4wODKW5T5d0khwDjngs67eQGDFWn8+zM2u/GVY2CWg=;
	b=QnYTEMIPNkxV6dj2hZMqb7R5AP46YNTQJATpx+aMuAzqwsKa5enBVi4HJmKrOd9fYPEC+Q
	Hozul9ozgI3wmUt6KGlXZa/kiY/qmd2Uc3ujLuF2GwLHe/7eOsNklfNqlJ6PCTJ5p8F+LP
	DhP8aq8OZda0ubSFMXY2r89pnb6kJfg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=plApqCsO;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805893; a=rsa-sha256;
	cv=none;
	b=3a0SztHDb2M6KQv0l5W72LxgH9usL047AidbnpCDPxmKfGlMr9o8LST3yLdOLvdLZXhnAp
	mJMq/2Ja2aUXGKQbs0xQSQXYvmDVSk2PZycyqc169C3G/g5woWKymL+9lGGcYYiFY+dCt9
	WhLN+Q1GP4G/9CBEpp4Os52+PSZi918=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D01576132B;
	Fri, 15 May 2026 00:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3D2C2BCC9;
	Fri, 15 May 2026 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805892;
	bh=gPP1MpPsz1Lrp/c7Vr+Jm9rt+Mkaxs1c5q78AGxoKeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plApqCsOdeUT7NjjgR+S/Eajn1mRGLh69PSPsqEDmT2Tt8gf68FjmoPWSkg6/pxt0
	 yq6taQ9CouP2+9yClhfDgf3ijc04JeMjctCcExL4X5N22LuwL6l49zQJjGU5GxBLBF
	 yyS0PtyYMj9sW7ZMCTcm9gatTGlPwcD0fjp6TpfNyD33vmUirD7c/lR/myDw6GOWfs
	 EC5fT+Thf9gC3Nu/hHojFqfuw6yv6fDylAoaDEcoH3FzDf044An5NyzVM5vzT8Uj/B
	 m1DcTgYA6j6LMW3jlp6u1gSL0I/wCfuzzMxfcNaHllx9Sy8R+q1fxOllK5Ld1ZAe3L
	 gRbNnw4IIdbaA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 15/28] mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
Date: Thu, 14 May 2026 17:44:16 -0700
Message-ID: <20260515004433.128933-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aat6e799ruformzd9oyy8f4dbfftxdfr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 521E1120009
X-Rspam-User: 
X-HE-Tag: 1778805893-313742
X-HE-Meta: U2FsdGVkX18oLWsr7mv6rhvj45vTPzRR+s+Nxr8pcB3F6pgYGAKWakyaG874l0iOMT+ImoTmcXK65wqNshI72/kWrh2VaRQKlpY1zjYVS4cBn2b1lmCZg/0RPuhjo+LGjhSAUXj5tB5fDn1O4jQEKlGR4TPzjlQxFVejOhkOgkvlQE3D8JBoLHem11Z7xRx/hHPs9uqUpVhuokD/xvVom48eBsCduF+Il5jI8ogSLFEqJ0GhtlTV/2APA6UDJeO6ZJ7y152P68djrYwyCHFyc2AHF0Ot/4KvTl3NXa+17+2biyN8Kxu3FwDLUghkvruqz0f7ICt/T8s+M/5/FgXe8vThplkuUYalFnzI8MUiyrhv65TNC4xFdlNDJqHVxJlwVSDxkeDB5/GCKKf1xwnF9u2dnpGqd+36ooRji//3PqRQsnb9qMC3/NuRTiMGW/kX9Vp5h1gANXS4koPCUDBgCXljxtJOLYXvY5PUeV/NRk9LtMMfxl1XHj+a0Wf1KvZQC9U6ujR5tvf8BBH2WQz+4xtK92BaBo/YBOSW7S2vjDUkkrGWhWQGxQ0x9QxhD3hxJEgzP7HnG587aoyINhBe1uQpxOR2SSoO7xPJ0acmm4/Ia2bKE2chCg56R8lvYl+M2zogrP6WUantIDv53pAnlbsJ51Wrr7d3KAqgBwHypIfgTCFutXXcaF3fcsz3X4MeL/3J63FYwz9z6VY+n0pvwcxfBs0mWfRyRwGxmWb+jwwLR9uYqJrM4zbexRjAOniFP/lFYkdjgwHm2+ZmS3aUm4MRQhdCfSUkGMLJf32d2EGmNgTVjJHnGtsJRFQ1KRR8Sy/UDdpnDJJz7FfssMR19kQKwv5rhdcTMZkTtZxORarzdCwcQNEty7Z+Ahk+fc5s6UoipkCtI56u7hATeBtfChMTp0mpzgUw9yyJzl8dLOTq5r40INfozIg5ohtVxtNSe+NHhWcyWcn+eNJ5vOO
 EB4efF+W
 FrugIEKmOW3MxyCyLUk5VCO7lBzd/eIRr3E5jKfyvhjEeNbsQVBHITsHNIqH2+EgzJxIUMbHTMebaUJesub6/wJFiPKjHqw5XHsaOppzUk0nwPWokq3U3VDBb3jP8Op7VM0Q+G3MF8ZHBOnD1NthhaZImsyBDENe8Wd4sNMnmsS2WGDPhQwQhJWV+7WxU42N5doiOQXuCgmgOoBQ3iIT7L0CR4qCJ2pnOfIcelVT/9UVDm9EHoFSEvgUnJSBsZDZNeBgq8CBodsHoTctSmvmuiDsuiA==
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
index 245d63808411a..0bca89217b8fa 100644
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
@@ -2932,9 +2986,14 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
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
+	return;
+
+out:
+	kobject_put(&region->kobj);
 }
 
 int damon_sysfs_schemes_clear_regions(
-- 
2.47.3

