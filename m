Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A3ACD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948886B00BC; Mon, 18 May 2026 19:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC0F6B00C2; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4666B00BC; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E72166B00BE
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0FDC1C1E2C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:31 +0000 (UTC)
X-FDA: 84782164782.20.C28F220
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0457A0003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FjR/lpox";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+HqmkrUtd2EK9Cm8uNxhCjq/zdTYHja45ERcabek0E=;
	b=mEhbiqjk9YdSycZ4GRex3D+qseLv2CWjgVjUBVDCHcyT6vcI0aCuPoPMsbEkeLjsDHSr9S
	T39lDNiuCOdFVFaUOaEbIQABE/dK8JhivCLEE0MU/K3oXHOR9IGmHKozEKzqBr5odA23qY
	TxnYJ7PBhxXt9x1Pzqt2kU1zAzXtGko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147690; a=rsa-sha256;
	cv=none;
	b=6PLjHytK5/H3yCU1kvXqPnEl8IGonVgywhcBwnQNrK+28SbCw6paA9p5sDkMTtT1v/Wapn
	QSrCus6HVLs3Tnj2n6nD+s3Vu/iCqXokgrzX1UWwwW3ljgLbzRBKLM7O97zAd7DM+Mql/v
	XKoROwhXDlYMRBW0rTou+yKGpjNvdBc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FjR/lpox";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE1FB409B8;
	Mon, 18 May 2026 23:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68752C2BCB7;
	Mon, 18 May 2026 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147689;
	bh=n2uNzQcVMV3fWGsTPMWuHPA3jhhhlDZQTIQ6T7mMfXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjR/lpoxix/85FF+0PAloLY57l8+Q19co9p89ktpyNPf+wpZhbsqlUmDHamtH1aMN
	 kzcpPe+2Sfwk+ryGfm8N0axxC37D3K6DL/G3uEUeg0aXI6NwcKRlWxUYq1QiEyZu0M
	 wzScwkrVtYfpmlPcjQG5U39FoWMWjDB9dMY7cG427SnloDZvTemSJyY9TP+0aFDKeM
	 Cg2X7bqWqUMU7bdoIompn3sOdM0GDgUmCNBSQsVtv53htkHeScZjOme9DlYC5F3kZh
	 eXz/+HYqVbQSEbvpQvi0W1nee0dH8/zbRHE5apH1dfj9nhqpjvfVoYxRRPIIDE65TK
	 suRhmy7cERGIQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/28] mm/damon/sysfs-schemes: implement probe/hits file
Date: Mon, 18 May 2026 16:41:05 -0700
Message-ID: <20260518234119.97569-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0457A0003
X-Stat-Signature: hfub4qg8a3cyjsdfmznh1u3bmg11ruxc
X-Rspam-User: 
X-HE-Tag: 1779147689-928082
X-HE-Meta: U2FsdGVkX1+8GKLWMhCY4tnppHpSSEBof8NGKpc0OQLeyyXs9afC9UvgytWt+0kAi8FAzUuEcPITJGiaRKTCl6v7ZEIRMWo6LD7wOdU1IpJ4ODJ8dZdRqQLIq3NR000yLzYpC1ZS0KiJCVZZuymWKfnGxONIXdufISLq7kRcT8t8eUUqdlO38UTSGp21qZ9QEpt4oVWf8mAiES0+FLf3GojqSNRLtpn2LDjrmRFDVYvehh11jfVGF55/+dYshMN7BzAR0aofSedmUQwWoHklMK9O2mFJFmOwXJ+v3g2QV0fsUgVSaQoruJhYOXXfHGCW0z9r1FY/DNKeUTQE8VTGzT1WGDsOjoAtfkB6IXae6xCjvwJ1bk2pvHnwUz54MiJ1P/8HY4GpTlRS7JFEYmHMIUEVnnL3n8tWxYAJFkbWmf0193ASmSRxdr1JvGMh5mUxRQDjh4N3tEFTnWjxdmPNoD0wjtwV3nfttoQ3U646KdSamYV0v+qAGkZef7vM5pYwLp3GRFx/GJqJgLbNx7Lvry08ciBMFvM2UmSQndjfo/HA182qKm0qlSyvjl7j4Ao9dEc6x+mQssViFc9E+Bz9idDcZeasV8lJ8kZwRdnaFRYWl1Gd11Sb0e1oTZSNIf9dY++5cRp5klOwCrNytI0zZhGpi9R/8liXWJSgAzzwvDRA3rFgD917fzCcL7EVpwmOpXwBBIvIxGaKVnxttdf8c3CtJwCQl+TaWZ2EarrKGgWfiilzKgo89872BJ30iNt+yt6i0Udr1uHcy1CQ+Pqao/d1Hnptc+3ZKAN8vTb2yoKFXH0tW+XBLTUVDkShEWepG3U1z/5+Dw3TJmV2mENrW1lqKUY2fsm2uNk64FQycfzKgmnrD1Sea9GkBW/SUVp8sJy5VD47KaadsXjR8yug6w+0rvFRQjN8OiOs9ChbsIj8gGr4Q4t269l6yLIKT0UjvpWUmpqm6MGBs5R3gLL
 qEUNsRZ1
 O+X623gPrzM2FY6uumEiCmpAw216+l+cRc8U7dpkr9JPYoy+HOMxZBJ0+YDO45vrLgbpT/WsQrpErzwbRhX4yUqgIip07oVNBm7HEWGzvP5onVRVssLhneju9PuF0//W9HHQnjElixkYDRtVxsKTEz7AX5Sdb4d58pCGlk24GUbgwNDFOQ7Ys9K/4NakvqFbu5rMakAjQuZEM+IYruHDu+t7JNUw7frA0ubcFGTUWuu4Qlpw=
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
index 7e21e78d77512..e25f4824b72fd 100644
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
 
@@ -3140,7 +3167,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region, ctx))
+	if (damos_sysfs_region_add_dirs(region, ctx, r))
 		goto out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
-- 
2.47.3

