Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1342ECD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2136C6B00A4; Sat, 16 May 2026 14:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19BE46B00A6; Sat, 16 May 2026 14:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1486B00A7; Sat, 16 May 2026 14:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBCB46B00A4
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A01D0403C9
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:32 +0000 (UTC)
X-FDA: 84774141144.12.80D09B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E09CD40002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2ZbBgpJ;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sehC0s1waBCTqbkgqCjK7OdBYDaSgTBIR3RQGmKE6c=;
	b=G2ueLpfA69fxdP1my4qQlYEat4TNSlU51eBUy+OUfy+ynFCxfjAa02rPe3sLJtWndndkhM
	wynUeJO1b+Hi9CXM9KPuOHFdPo6eSyO+HkhWvheWQB2E8CBjSaCAUm7eNTTVs+xlfWJX4L
	V9u4MV+aKagPq83414C66IpS8Qas/K8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956651; a=rsa-sha256;
	cv=none;
	b=ZI/e9hIVKGxD1kFcLCmRj+IRrW/6t+TKd2z69nnkdr1pMvSHj/z1AtOYxZa4H1zAAYR48c
	SPTficskRMZObXReATKWJ4+g7D/TcQaTH6DjaY2gwlI7E1+TBX1fAI8OX7bDVyKqImmLH+
	JUZ58IfdUY/PwoUGpKxP5954VbxHgJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2ZbBgpJ;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95837445FD;
	Sat, 16 May 2026 18:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45153C19425;
	Sat, 16 May 2026 18:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956650;
	bh=fhpPTTL5Cgz/6UBMQvvRgY5W5vyidcWD3uwslkT9fjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2ZbBgpJ8olKE27odkZebC5/h5tsS5QOYOeGMs1MGsgSOdsPmqp5BTNCfipUHWyQz
	 KTxrWeymw4RQGBqFZrh7NwY9sGzEg9eHs+nxXWp1R9m731/Mdhrj1nbX3dEIxVoq90
	 e0eVD11P5OyXxnFo4Vtid8npOdkdMkJGwzSH47mgO5ASmdo4mLzz8oLwql2xDXE3I5
	 LK8w/uNb740KQR6ByWdHNGePThkrCT1jXYPLUbdZkcUnxX+BDSfndhThoDCuuptKd5
	 m6CyBWe3wFKr5bdYY5iyIZvmOS3yWGzxTS1SPjfp+/FWOTMzHXQPbNAKtXHE9zUZeY
	 fQ3eNuRvqjMpQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 17/28] mm/damon/sysfs-schemes: implement probe/hits file
Date: Sat, 16 May 2026 11:36:58 -0700
Message-ID: <20260516183712.81393-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E09CD40002
X-Stat-Signature: 9f86rjedxohmu6abgu9ejuizhc37zrzk
X-Rspam-User: 
X-HE-Tag: 1778956650-484677
X-HE-Meta: U2FsdGVkX1/bE/1a7JN+pS7e6wYZ9HqrZPtrJF2KAcai0IYETSfN9GWTGKBZ53YyEh8UrSQXPpZmaP6ICvfmMqkNz++nGkWaS617C9CdB4RKBCk44jK9tsZHsYMR7CG9HvaLxB5hdxd0qei1ATb/l34z+QNEwz9S29/OJ+jCjMWHZ5cC/keIFGaHwumzkSYhuygsRmaZbImm/ysLzlHKnBKNqz4pJ/4p7wLJMOiYIlBMG+iiPXR+P2j2gcxBavu0X6rgjDyPKBUGuzQ8vMzM5CmzO0fqROJLV3izsSWueJArWqlambL7uqSEMIB15GM4YeoXFkP+gKkjxzM/gN2pLotNl1e3CbHA7fwioG/Lpi4NqhzppVPaaqU5jYAg/SrcuZRdQKOu027EcWCRYL/Fmmfv81hZBSxrAL+i5y0Fk6QEVXfGHFN0zEt8z6bWEnLk/eZkAfdy8nH08pfK/92K8LwAFIx6/EjZPlsY82nf18tyhMJQs+Go1PBW2iRM1uBVzDdqRwcfbpfhSgfEINlVU1Qz4xMcRAWEGE5Atpy+Nvj1PmGpY7gYPggGvsRt2LJEBtP7r8Q4qIklcFUeWTQhlTuiRLXuDFuAm0GcO0rrGBvlTgNjo+ww/3+o/mWBMhLMGiEPknXRVVrQb3hQnC+0LoB5n6xpGWoJk226g3i6I8VxqiftNKTAizzBQfcNL1lHt5pzJeR1UTSuNzS6s44oHSFG7kGRIShMGmgNFkMlZmKJYZZfM3VhZHjjknRDn6Z9eFD0fJ3Y9wYKTTfnfj65twlAqh0HuaL8oDp+7tA6WuFBFMWXYU5D8PIk6L+hGVfC0Lu0feULDGt4HRamPs+A6EDu7KdWHvI4mrzHz3GPqLuNBEp4moEJErCL+TUyXQbYAsudSG0w2iQ1bFRUtHX0uRvCEetHcuXxr77bXPDqHJc1ig5bg2m6CfnaXPhfsoe3cpECN4PCsys35PFpsHn
 ykjBGjMC
 /1O0wyVt4QfsHQAdizBu+ON2XbOZ37Rp5qZ4xwnAyfX3Kpbn5ToiWw0JsAEGe6dhidsPq+qzvwR0kfuT+pGKFHbFXHvx+LgdF5wLcraiRfU9rNmxDMfv3jjX/GsFoPAUz6AOOEinqbF7+usISnchS8CxJ/fibN+nKc0ROBdpS4GekciMpVuJ1AyMVqr1JsYRyhEDFMJ18yLn3fopfx8iqb/lO57Ba/ONWmlTt3UwvsQ3gbbw=
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
index c8123c62bbd48..d680c785770a9 100644
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
 
@@ -3075,7 +3102,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++))
 		goto out;
-	if (damos_sysfs_region_add_dirs(region, ctx))
+	if (damos_sysfs_region_add_dirs(region, ctx, r))
 		goto out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
-- 
2.47.3

