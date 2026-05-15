Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A8CCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189F16B00A2; Thu, 14 May 2026 20:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114956B00A3; Thu, 14 May 2026 20:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82AB6B00A5; Thu, 14 May 2026 20:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE9006B00A2
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B747120777
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:55 +0000 (UTC)
X-FDA: 84767809350.02.FC3C483
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B32DF2000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j3/e5RwA";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHtkIk+l5LQTSVPz2TABk/cqeqTifAhTHxYzH1TaTKw=;
	b=7vfBiup+u+lRrOvWLsoiqhFIsdoJ9O9eArQDVUPyuU9MdEkyuDce3vNdC7OQh1xPsslZes
	MAPJZvQbH/ZaNxKhlWDBwU1bFquBa8P3aXANdPDHhN0XJbmwWK2C1+VJKLLUl8f/6sOEbY
	zpIj6bV4m+no5hnADcEUWaGI6RsLnUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805894; a=rsa-sha256;
	cv=none;
	b=hPlP0vmqBJ5cUzywisee4eQVaelfkYLwlsWlu51wJPWqa+qz11RFtDuCU0RF2QMxaer/Fw
	T/jPg8+U6rs13O5qfSh3UnrkSOQYq5QDdozQuk1WtK3+3r8KPUAQdgHPTSiTC8staYgLM6
	vlu3+WecwB6Qf+5XwicHWLyvKCifRAM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j3/e5RwA";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A36C41522;
	Fri, 15 May 2026 00:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14454C2BCC6;
	Fri, 15 May 2026 00:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805893;
	bh=rUXZhhkUyhoASr+I1V97zRttl+YyiYZ2jO89PPSgO8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3/e5RwA1b6Hy/2xe1W2XH6bFcrFZAkW74uKjFasvF99Q/diLqtyvSx85SKjW3j7R
	 R4VRFzM85NgHLMfv4MccxejgU3IaNfJh0RSe9VJPPgaCntfUoJCDXA9px9nI4R5FL8
	 4WtHqARGUUhDAy+/pDy+kpnBMWfvgrzA7ir7fRWsLCKiV8Yrrakf60+LoPVAFmIcfe
	 ENnIHUMPRMRWLp4EDkH5dQun01j5e+xUngyjlofj1C2BtyFzw3Gvg0CYr9W7jtUwsI
	 pYr5F5ElVVhMnZ38ZdT3iy0F/SygNADH11l6rJvbk8bD3aW873joyGathO6QIQPasi
	 k9Qd/wWBkpjPg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 17/28] mm/damon/sysfs-schemes: implement probe/hits file
Date: Thu, 14 May 2026 17:44:18 -0700
Message-ID: <20260515004433.128933-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B32DF2000D
X-Stat-Signature: xcoocrngy8tu85tt73hid4iwegkgsipg
X-Rspam-User: 
X-HE-Tag: 1778805893-709911
X-HE-Meta: U2FsdGVkX1+10MUuT/I9GclmfRKMZJff1/78oUme+bYsjMDN2YDcKQJtnBf/U5ETjefZXv8c0pL4Jg3Zo61BfcTQf8vEm6QUnoKH7nP/ZFzZRKb6S025An6g++Qc6dIR1bE3ueBZwbVWd0VkVoYjOOUMXPYB0onfN6H791zm7tWrlNC8TqlLI+j3RW56PdzSery9Yu8xYSZM/HGwqnVuFDw5/GMKHU13fPlpOyAER1aoUjMCu1KxXtALMEJLglbe2mg56v44CHWxjpME5B9xbvOWXQiAyqKMrOQKuNvLS+AXyWigkCXT+vpdEmanihlvhlmwdQrnKNfsfV7vviZ1ONRchKvjv0fvvhNv974Q7MsSoBZ+x0oUv2uTpEqJuZd4p+hAX5ibnI+msrf7SrZ8hFtT8dqskAEz4p7Xx6t4RFX6RXaVOyXUPIZqCdkAFrj6aEAwfDjCim76LEgRZZD4Llo6tUR+NkEHpCgFbsSuddCXjHmr1VBp6Ld4qCKECLeIC9RBUGWjfF38r1jzNJ5+DSdv5uSvs+3eerMlZzzVorrjLc7+rRoB5q0Ii/s2w5xs9fXGYkt69ut2Ma/QNGXHrVgYGPmRisia1Edjj/emmqqod75/DJjbylDGWpi+W4TuizZ1H+/CF6kfTOeJBfGJpwHwqcEKTUsdVM3qaWbAGXcPD8cigC6MwgKMTCG8WE258243nJVljlxp9UvLpJ7TrdZLPbHZBwZ5tTNxkrQJdLIYPHZTP+siABvKh6GHmKktUqGINFpOBSDT329KQWoBQHuEtmR/I06PTzDGVPJnH/YhJmXvlsvt6df1EBbm7EaiVSGvP8qB6pIN59yKzB7VSFjwluqRUooyfq7fu4knZ3djVxGEEja4tI9YdtbQut/DcPlmfFEM8fxBD4Jk56ByJrKMeLdLnbylryxz4h79SVEzyBBlhZLmXDxbof3rlyTAwok61olEEN+26uNCf8m
 kos63hIs
 SFp6E+a9VmAlTlX7hkwL8M4qW6TPIdmYFS5nQJKvECPRLv6z4K6g0Qq3JmKcXDMYnxPlUTvCEubQxD+pYbB0zqmk9p+dGA79i/rp1DLlDgxXACOJyXEbX3b8f8NTJ1G4kx4GLpSsCHvo0frHchGD+xJBBDK6LXoNISwIym+H9cbCh34902/uN3AdLXnf8e2CpENQRv0caf06seEL3twKsBlcQ9eq1gixC/DCza0zBVl1w1YM=
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
index a83512f28c022..36f6e4bc57ba7 100644
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
 
@@ -3077,7 +3104,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region, ctx))
+	if (damos_sysfs_region_add_dirs(region, ctx, r))
 		goto out;
 	return;
 
-- 
2.47.3

