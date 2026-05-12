Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37FCCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6506B00A5; Tue, 12 May 2026 10:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7604C6B00AA; Tue, 12 May 2026 10:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C0B6B00A6; Tue, 12 May 2026 10:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28C376B00AA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4DD21404F7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
X-FDA: 84759020010.23.8279B30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A03A14000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JP1u2VxR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/fj8aSFxwa/0msX8/IeC4AgPBxncesR5Kkb2DuF7SQ=;
	b=7kmw9EGAWtEIBaqqaI8csgDNQtUAFLoIdLziCevyembQKtXVQ0Dn6Pq6wnMSle3s9bAtpm
	gN0hJCyNuFpopUyo2HWgwwHQge4bzqecpEIOBaLh+YO+3gl9O+heB+XWzGEaexXZ7gO71Z
	NTx8xl3+12VU+OVYooyYmLOUQtUDCTw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JP1u2VxR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596624; a=rsa-sha256;
	cv=none;
	b=5H4/2EVfIZXN3i+yyu+Kou+6T7qez5jH2IuxTItKj4wA7w5VA2Kad3v4GNoFz3KD34+pnR
	W8tTF7Cfsm/E4n+hwis+wkUErUHHj1w2R4I/eDiPPwzGcDfINTmzc38fh/uHRVNudCjCdO
	bED42LTP4YL8//GkJO7L5xuRSqh7qZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E356144A94;
	Tue, 12 May 2026 14:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D44C2BCFA;
	Tue, 12 May 2026 14:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596623;
	bh=89p7VKEE57qMrXeaBH1JYG+SiM8t+cBg5/D++ThSauo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JP1u2VxRyoXl5WrUPagJC9d9rn8nyHY8H4jDSwk1qH+qEKcY/q4QSCXDTq7ct/VcV
	 APhVghtuetxSJFrgQiNkwJ4KqddJFjPwAcuziaE1BA7GVKTuROIqJ339i38H+hDZxr
	 Oz+t4IpQh6YpiTa5HHddBqV/N3y2IDNCJWUaCO9PBlvdRpe7bO8zAQQ5oyEyIfd5sf
	 DHn4iIq78MV3mwpepwc+QWt/yxclCYyn1rdeSArUdI4Dlzz0VmiWNtGdL/6Hllg6yp
	 MkYgU352Ae+bdWw5mYyHZoJYfGldeLVIpmLt7rU5IfF7+oU0G1JBlSjsa1MEOC39c5
	 ENh3RK6oPEzVg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 17/28] mm/damon/sysfs-schemes: implement probe/hits file
Date: Tue, 12 May 2026 07:36:32 -0700
Message-ID: <20260512143645.113201-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A03A14000F
X-Stat-Signature: 3gy87wh559spfu5dk3koumwq8n9j1hea
X-HE-Tag: 1778596624-94873
X-HE-Meta: U2FsdGVkX1+up/3RLQXgQ6jTnX5nO8eZIi9+qsEgnsqTwI0T2yEDC3l2tRnSOUYM1Tn+54lZolkyC5EQ87/iLtZzLC76X8dbclfSK3BUwuBoINpgo+c4qWEDLOhYdtGQPKSEGctEDb0+hqjw0vxiJU+J6powY1SciRDg5EVtyztpsnxJumU7exObxpuIz2rQO+qMWcLd9yVWQFGXqg5kn1CR7UyArdreGPo85WpG6AOGM70x75vuTb0/MUUXTtrMXtAmbqnTcN5EwER3bDtcIUCp8IgnnWw3IruBSeKw4XA2Pw8gHaAl53brmQHWLggrT+F4V27zeQWCftgtrjNaLF6rpCY/WZzYYT49/id0wLKtoaqqNAmbsH1wGDeg3ZfIdmrPmDj01wG+28m099ojNcxb54uBIRnL/zV2NPcQvK1LIRaQQSJ+n7A7npVwUPEYTfD9NG4Aelrfm3RdO7+qZMfh567EDkuXy2pPjnDhjz7oLyebZF/qlVgd9BooJiksk9/+x6os/907lqooXI4hRXczSFb5WuPlbeLK8j8fzJ3QtRi9gYa1fF8OYy9U2MIT84zcevwmXCUslXykUviai0nP4lT33VR/CL41vtFRNm0ixHdLcBu51MFzIyUxyInLRY2PyPtzlnogqWjGZGeefBnJHTKErImEVbSRAz1xH0I3rF1riTincQ29K6RDb3k7RMGqODg/rtbbuTNH/l3ZST0sjSTAVtHVK8QP/zn0hSIXxGR/7WMFA3j6f4D9eLsZFHVAoSDCHzsweiwD5pBaRBKCZtKZ7/ACfliZ/qpQGEwYY3UhG4ah4nbN2TSRcYmbVgSV6HTr4qAQ7QsLWgWLAEJfTWqjyqVlW3NaxOEBvdzV5EPIOvQ30Wfk5ydfki8TWKlfjRAV3Onbc0qJU8RXzysLK1e/eN992EARukxWbEGxa0CGJMLo9mX9LJT+EI5gCnXuJwJjklcX13vOOLl
 1schVxMV
 bxxIcG+52RtJvRHACQQHXaDUyYnFucoPUyk6nv8sLfDwJUP2ElQFYZ3HGwp1b7ipgee+zvWZ7AghZLCZIJU1GeUptL6sBcUd+7B8F5NFbH9fEFFtt9NCXv7iZ6J3vFK24lnP+7zHToW+Kqjk7c1tVq170tau2eEvFmYncTSTGyw6ks5s0pnQORB9sB0nl2QKGcbxqUfDzi70J9QpKda65vblS2Tuomn0o6rkbfn++mFF0K04=
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

