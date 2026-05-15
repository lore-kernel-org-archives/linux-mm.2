Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666BACD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310A06B009D; Thu, 14 May 2026 20:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2056B009E; Thu, 14 May 2026 20:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162AA6B00A0; Thu, 14 May 2026 20:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02EE76B009D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B40FF140645
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:52 +0000 (UTC)
X-FDA: 84767809224.23.FAE90FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 03E2A4000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8b11s5J;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSKQdopr8LBxFgRLnjTjNyI1EvBwyvtoG+NhfreRfkY=;
	b=NpjuvMfGMIvyTyEg+NSLbRFFZBqnHRGi2HxXcqhKgMRT81nwSK/kDpoL0SOR8ZJ6JrnJhz
	yU55B1bcKvMwJXkptG4aIzbsmg3O6GTas6mJ3qJ5hQSWTealFNPqyxJmNVI1YQJZK/Ri2E
	fNlYMFJubsRrZlZZTVsyAHXyIYreVZg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8b11s5J;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805891; a=rsa-sha256;
	cv=none;
	b=xMWM6ZVmQhLYZtKMN6QcNluegqas+zrSNtFxeJ5LpIFkqFI0vDzLqGCDPjQCBDKORJ5IbJ
	rkM4Fv9IemRc9tPc5dKX/VZbxODH9FYxAR449WNXvIo1X87SROBKGxLwgYWT1e440Qtvev
	iFfVWP70oTyI2SH4qJe0xCGz0P1wdKs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCF8643A28;
	Fri, 15 May 2026 00:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7219EC2BCC9;
	Fri, 15 May 2026 00:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805890;
	bh=S1XmGP9+Xcb1Qcew2IaauTokk0V1jo5N6xOnyHaorjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8b11s5JMpFrUIzpDhCudJPn4MMM6r3CMpRyKtuWDNsH5IyPQxJxS8WbqEUyzxOjW
	 IHuE5Bk7riC9mLpURRk6/dneEp3+LHSPHRVrCoN4yyyoNdeQk2hNX0jri9ScjD5kFY
	 xa4yp0Rw85l55uH+ExRSUnHKuieXyU8L66/LafrQ/T9+c2ZNQ2iGJtBKOG5mb3rfSD
	 sEaq5s12o6sK69gF/ed+yw+XyRP+truly6hTAdM4+aOi0iZ8YydPcECCP4S5zHAZu3
	 +F9sMO0wAOdP+qElgTAwzy4JC1GtL6pFALxwNHzo9LxJWSpvg0IW4Ba5bjicXWXhsN
	 XS3yG7Ahh6CMA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 11/28] mm/damon/sysfs: implement filters directory
Date: Thu, 14 May 2026 17:44:12 -0700
Message-ID: <20260515004433.128933-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03E2A4000A
X-Rspam-User: 
X-Stat-Signature: o1h8swydo7z6tagxky9wdgun5x1tz4s6
X-HE-Tag: 1778805890-605502
X-HE-Meta: U2FsdGVkX18+kbhqgG3AOn+T2Bwf9amJ/dmHWFf0fkTP51Ygt8ipWbzgHq/r+CcOcnoC1Lq76e2oQcnR6NNj7Aakq9/LR8PfgQkkz/58rPii30NvcGzrizU0Hu8SqYAdvoPCh4maYPuSuUPsfK3DrvSeaKmolc3xnABi7FnbGtn8mgS4rAaq6xYu6LwltGcsQXS3A7lcAVC1mMT9EmIQ+XuAciMGv/MIbxiz++8Am0qxwZhD6BqGoRC4+W26fjtukac5LnC+iwE/zBhnw9fdAAf88YVCw7dxLKCAln9sYkGLQEDCKqjM3yAJHT/7slHy08fUDZSo1klIim10yB8d8RG7SNai/p3Kr6ISeVPPg4nEM8MIfn1znpq7Mb9yfkD+DutGsq2kV0hI1uwSx0qXzkDggJg+JJ6NwAJzoOGYdxHJNsrQ9MTPy/17IY1ROjIndf/4SkAPKN2o8pFD7D5jtbGvQeHpb0lNzp3Xt0+4cBIUSMBmNZi0GwoJmg1I90BwIRRpPcnwOm6IunFPX+r/SHso9UWhKPuqzfauL4Jf66Liyicsq3+qZzCaRugbSGZpOHSeBVPuFXR09qJoAHOjaJk2vzkgV6cKPzXHbUGX3NsdjX6FN5rhqzibatagjXIL871DxdZuFsvP0IYxj3x9O1BKHHbsWTm/n/Weyfn2tzDp8kd2irgHgj0/yo0+yU1iU3blYqDDVRoYcOVG+ucCvksqE3ayDwhRXk1rFlMgAk7pPTFOh7j4CPoD7b49DOgVA473YSS7LwnFK4ZHNStRtEC7nk28m8bWdurf9lfyCeZCt7L/UrJViIx6lkVo/j6Vy/yp4L9m42vMsbJGAEj4zbGaryEY1WyluH2uNEcag6KYK6tucjyLPw89j1tdz7sJ2pHMvpoDiHdxkTt7ZelaIcBi1grWohdif+1b0BuLvI72uw1w4/2u91uK6Z6Yko5IIaxq9o7ellBTK3Wa1+7
 GrmhRCBT
 lGFXYA7n5pnZbGQ1JaRIA6hMp6WG+QWoww1rExN1UxFQwObS6SVo49w+Gk0gnGG+sGISi294b3xixFHyC8Pp/sc/H2y760qKbLwvVdHEvd6P6ddCAMUBRXACDQkct/KeYUmokl4xk0ij/9fIm882cvPmilUEiyw6VRkV4X4vMNW5jT8aEjMvpZnShbnMF+7IhytNXlA/aHHbSCzCJWX/x0AZxN1Ju9diZeed3JKLRmu5jdOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a directory for letting users to install data probe filters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index c028e4b1281e6..6b15886190545 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,42 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * filters directory
+ */
+
+struct damon_sysfs_filters {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_filters);
+}
+
+static void damon_sysfs_filters_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_filters, kobj));
+}
+
+static struct attribute *damon_sysfs_filters_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_filters);
+
+static const struct kobj_type damon_sysfs_filters_ktype = {
+	.release = damon_sysfs_filters_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_filters_groups,
+};
+
 /*
  * probe directory
  */
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	struct damon_sysfs_filters *filters;
 };
 
 static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
@@ -760,6 +790,30 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+{
+	struct damon_sysfs_filters *filters;
+	int err;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters)
+		return -ENOMEM;
+	attr->filters = filters;
+
+	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
+			&attr->kobj, "filters");
+	if (err) {
+		kobject_put(&filters->kobj);
+		attr->filters = NULL;
+	}
+	return err;
+}
+
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+{
+	kobject_put(&attr->filters->kobj);
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
@@ -797,8 +851,10 @@ static void damon_sysfs_probes_rm_dirs(
 	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
 	int i;
 
-	for (i = 0; i < probes->nr; i++)
+	for (i = 0; i < probes->nr; i++) {
+		damon_sysfs_probe_rm_dirs(probes_arr[i]);
 		kobject_put(&probes_arr[i]->kobj);
+	}
 	probes->nr = 0;
 	kfree(probes_arr);
 	probes->probes_arr = NULL;
@@ -836,6 +892,13 @@ static int damon_sysfs_probes_add_dirs(
 			return err;
 		}
 
+		err = damon_sysfs_probe_add_dirs(probe);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
 		probes_arr[i] = probe;
 		probes->nr++;
 	}
-- 
2.47.3

