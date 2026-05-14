Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A920CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50126B00A9; Thu, 14 May 2026 10:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2DB6B00A8; Thu, 14 May 2026 10:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634166B00AA; Thu, 14 May 2026 10:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 351356B00A6
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2434401B5
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
X-FDA: 84766207890.17.4055E05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46FD180012
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FjWa/rXb";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/fj8aSFxwa/0msX8/IeC4AgPBxncesR5Kkb2DuF7SQ=;
	b=N7MRKkOx49mJBx+XHrCPoCjZcwdVHWGjArTS4PGgN90S0NNiPjzFpphDrnjxaByonCmVEx
	zbAzjT/e+Hg/9iSI6yz3uZoCm5q29mkPHF/1VXEtjraxNO+HwkB+N/mwFRW2DbNWLM0rXd
	RyEciGpdOnnFCSkXczdVpd+27OjtX8o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FjWa/rXb";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767764; a=rsa-sha256;
	cv=none;
	b=6jA9VC65JRBWhzyvsL//XcleNgmq51B/j21UT1K+sIZLmmn1iYkAWjVyHmBjU0cfOC5noQ
	URi24kAHD1D4wM4FLHZpa0yDOyIoKti6hrcm1xh7DkuBfosWd5PZcgwAQmeEqP/8QE/vkL
	k/b+8qPRuhnn37RFnOwlu6O6j+RZeW0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03FB24430D;
	Thu, 14 May 2026 14:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3CAC2BCC9;
	Thu, 14 May 2026 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767763;
	bh=89p7VKEE57qMrXeaBH1JYG+SiM8t+cBg5/D++ThSauo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjWa/rXb1qoH8kypKKJ7p3MzG43B5n2MeSMwpEg9YCyPXz2pzJC6zrJOwaYU9QGwF
	 fgEnGaeQFHdopwLnGWEboGXYkbEWCcG9kRE3ju7mfvkDicroFQKFTffZPzZXbIev8r
	 3GjMRDLJZ95aI2kMmgRU9cmNw2RofGx/nnRgiZ/OPzA2i/70kgG8ULnOsphn73Odm1
	 6gEPS+w+plg/Yr8d5qnCTPotG+EGlasug8lABtwSSPEENNm1TULmcjqge2BRpLUV6g
	 0uXZSQacT1Jg06codaDwW284ruPk74U1uK02Hk8Rcxdpb4xkTFojVbqWD6EBEV0PjU
	 upgN5hz+0G79A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 17/28] mm/damon/sysfs-schemes: implement probe/hits file
Date: Thu, 14 May 2026 07:08:50 -0700
Message-ID: <20260514140904.119781-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 46FD180012
X-Rspam-User: 
X-Stat-Signature: a657jy11hkkjkhwsp1w74zty3pcwnr77
X-HE-Tag: 1778767764-884309
X-HE-Meta: U2FsdGVkX1/UMJPwLftMVKkH6VaeqBNrJ75UG2ak6zEOnLdskYxV6cypgcyul7/C1bfjf23Mz4RJWUZe8SxSopTLDVAXnjq6j9dtZIXGkP/rqm1xFSZWYfEMJHN6NZhNIkR7AoKEVySyjOLhlPOw3odhCXfc4KI4QBOKkcI2DF9cDd2ky8Fz5pFwcawmq/9JZ2lMiMl6r/NTEPSrePxrLK9NWVOaKTSq/yj4f0XytPk9TvxROR0PUiYB9ttKSpC7XLTa9n0B4r4Ms2DR+FE0bSeGIompy9hhHyfipPTone3we80MtwDpuLudLIJmQCgEf+ghQUckbIxiAn7XWAluQpFphbJtK03D78dnz3YD1cTxQ7jBoj4iP/sa73caKyXiuqiREhbEWI4TQLLKzuVUloUJDutONC+AbEIfL12/0HIPx4TxTUrhXBCaWRAGqLNbVHcAHT1sqp1gDc8w1xS4lxyMBjoeAdwmyV0Z9w2n/WH2yRmf5bZj/I6foDsoEmpKMn1CJkBV2sF9M0knx3yyB8NJhiqewdqi/WKBg6OoTQgQimjzR415kg7JWsC+nJG3ahHzHIVbl9SkQ8LFHzsYCVJrP1PQfX6OUarbx3RssvBWcS23hNlpAEe7J5e1h4wwpMIX+8kc82ILUC0QkjJVQElK7zgxwosE+jQbBGvyXGfK682GLaWnw04wq9nymmMc0JaZLkGIjzL05W4w2r14wrdRM0wYNkFI46moWuDBHOKXrhZt/rcIJNX+Vv1rBWh21AS7oOVxURp7TE6savq0lGy8z13eRpsowIaoHRWv50+Z6V+s87UxDi8m41Ot4y+I8JE6rAle5VFSggPXDItutZzBD4KOHfSUJHaPYzs1mwTKPOOWd0tkONgEffl4q8fNy0UmJSolzc024ONw1IxWu85mpy+2gr19o/ZqHKia/MMRsHk7vHnV4BJQkVUey3P/zOAePQ5E3UHWjQJ7TWN
 GjQBARa1
 TUhDLiXSYgmDOik2ba8TCsAF/7A7jvPXu1jGN6LavVG1AzZIig1Pr5nk5C5Y2BdUnmsJgZZpb7acIJxn5OQdJFyi1qI2fY/hICzANG7qyFt7N5lktmwb0fhZKjfDkMj/nBjkuRc3/8ZUsxGgSWzxvtMJ6+KeilWxei1DwvUKmWsekijfTJDJSf5hwKiqdz2ix8CTGk4y7ekTi4h4ILVDGlZ9a1oGyqhlERB+OyRnC/ByxHWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs file for showing the per-region per-probe hits count.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 41 +++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 91d6ddcf1b32d..43a8224d991e8 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -16,11 +16,27 @@
 
 struct damos_sysfs_probe {
 	struct kobject kobj;
+	unsigned char hits;
 };
 
-static struct damos_sysfs_probe *damos_sysfs_probe_alloc(void)
+static struct damos_sysfs_probe *damos_sysfs_probe_alloc(unsigned char hits)
 {
-	return kzalloc_obj(struct damos_sysfs_probe);
+	struct damos_sysfs_probe *probe;
+
+	probe = kzalloc_obj(*probe);
+	if (!probe)
+		return NULL;
+	probe->hits = hits;
+	return probe;
+}
+
+static ssize_t hits_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damos_sysfs_probe *probe = container_of(kobj,
+			struct damos_sysfs_probe, kobj);
+
+	return sysfs_emit(buf, "%hhu\n", probe->hits);
 }
 
 static void damos_sysfs_probe_release(struct kobject *kobj)
@@ -31,9 +47,19 @@ static void damos_sysfs_probe_release(struct kobject *kobj)
 	kfree(probe);
 }
 
+static struct kobj_attribute damos_sysfs_probe_hits_attr =
+		__ATTR_RO_MODE(hits, 0400);
+
+static struct attribute *damos_sysfs_probe_attrs[] = {
+	&damos_sysfs_probe_hits_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damos_sysfs_probe);
+
 static const struct kobj_type damos_sysfs_probe_ktype = {
 	.release = damos_sysfs_probe_release,
 	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damos_sysfs_probe_groups,
 };
 
 /*
@@ -64,7 +90,7 @@ static void damos_sysfs_probes_rm_dirs(struct damos_sysfs_probes *probes)
 }
 
 static int damos_sysfs_probes_add_dirs(struct damos_sysfs_probes *probes,
-		struct damon_ctx *ctx)
+		struct damon_ctx *ctx, struct damon_region *region)
 {
 	struct damon_probe *probe;
 	struct damos_sysfs_probe **probes_arr;
@@ -86,7 +112,7 @@ static int damos_sysfs_probes_add_dirs(struct damos_sysfs_probes *probes,
 		struct damos_sysfs_probe *sys_probe;
 		int err;
 
-		sys_probe = damos_sysfs_probe_alloc();
+		sys_probe = damos_sysfs_probe_alloc(region->probe_hits[i]);
 		if (!sys_probe) {
 			damos_sysfs_probes_rm_dirs(probes);
 			return -ENOMEM;
@@ -150,7 +176,8 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 
 static int damos_sysfs_region_add_dirs(
 		struct damon_sysfs_scheme_region *region,
-		struct damon_ctx *ctx)
+		struct damon_ctx *ctx,
+		struct damon_region *dregion)
 {
 	struct damos_sysfs_probes *probes = damos_sysfs_probes_alloc();
 	int err;
@@ -161,7 +188,7 @@ static int damos_sysfs_region_add_dirs(
 			&region->kobj, "probes");
 	if (err)
 		goto fail;
-	err = damos_sysfs_probes_add_dirs(probes, ctx);
+	err = damos_sysfs_probes_add_dirs(probes, ctx, dregion);
 	if (err)
 		goto fail;
 
@@ -3143,7 +3170,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region, ctx))
+	if (damos_sysfs_region_add_dirs(region, ctx, r))
 		goto out;
 	return;
 
-- 
2.47.3

