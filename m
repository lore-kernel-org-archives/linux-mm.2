Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C01CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080A16B00A7; Wed, 24 Jun 2026 10:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F259E6B00A8; Wed, 24 Jun 2026 10:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14A16B00A9; Wed, 24 Jun 2026 10:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE3916B00A7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A327120390
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:39 +0000 (UTC)
X-FDA: 84915016998.08.F08B488
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B3FB180002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3bN8dry;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310837;
	b=gt4PvOSGshNGq98wgZDR5BRlWTzsfDsv8F8F1+BEEMGRc3scFPSlApiDXkAVgzW6LiKPV+
	710BXKFCVjR5FYKNc3kYeHV+UVKm7hSKdWPHVXZnlsrymVloyI3p0uOHqqczqvJeeZg+e0
	7UHCAyFMrPGSCVXr/YdQpHiRdMprdfM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylwB5zdu1NHhRReJOXLk7elKhlAtTFYQ/4nqZ6xirqs=;
	b=wsRb+U+OXwzRqj/zKA9ECYoyLGXZ8ZUrx9jXVkLy/Gixhd84EgOumgG8BFNDZa1vmqgysG
	QtpQqdkySbT4gEw9YmfirE3TGliKbP+ib8PJxl5yruya43HqXFN7WL9GuIm2aF1shtAYtY
	G9ZBjPSb9x12hafUm3sRHplpbxmSTNM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3bN8dry;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C9F6601FC;
	Wed, 24 Jun 2026 14:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6E91F00A3F;
	Wed, 24 Jun 2026 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310837;
	bh=ylwB5zdu1NHhRReJOXLk7elKhlAtTFYQ/4nqZ6xirqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3bN8dryW7lpe9N75LEbz7v99EVRjLVRpRFWHC6iUyCR64+VbmlHXGZVPxt1agkNI
	 pVXmot8z5C1u1EwNwEnjop1lpMEnfJSpdKivn3TXJ/Rjadr4UgozMuOLJSbCFgXK8a
	 lkbU3EAF+O1+NrMRjynA3Iq9hEONjQ0Ue8SoAvGjNjEtKtUPJdR1JTtnbUjL/UamoN
	 IBU1v6WMZ5TlA8Lc2Iy+rQSzkkyeZfUBEnDPqjhTN0LIaOOA2D20EeoP+KpsJ5sqTI
	 +OzsxhvEXYBB4UdrBinAPPIKzZclbjJiBr0pzsRZ5+K9EhQaClqtyjtYsXkEAv136q
	 io4+K8JKMk5Hg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/11] mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
Date: Wed, 24 Jun 2026 07:20:07 -0700
Message-ID: <20260624142008.87180-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B3FB180002
X-Rspam-User: 
X-Stat-Signature: borw6fnkzkzaruhd5ud3caffx8cbk57q
X-HE-Tag: 1782310837-782304
X-HE-Meta: U2FsdGVkX18fLR6XacdKE4YjOcddoafEgw+7qL+3ZfShLAqVprCh45RTvHNTLIVJ/3//YAt0ozEAYfwu8X9oWz1yrHNXEg2/3sLYWTi8iu+lc5YEqjylFDOheGJyL0zvDr9BCX64Xw93Jz+96RHrga/hC158w6zhu57kQS7Fcd11qNYO3GQZMf8bKEhbRzp1bNvgTnNCUp/akWjTcFMrGHmAo9/MNcM1gXjtx/HxUrtpHBzKd2G14gpokQM1L6Ts7xU2KQeeensEtMgsfQ6m9ldyld2X8xKmgWhM7PC7dOnN/fjwqWG7Twd4blgzP5bCWasyssocnf5dGEFFtHiWS2RVT9Gr2BKVlsUyklXoPlNxuVv6vBe0B1P+7Buulc+LyJV4RB0I7s1yCNdoPSJqor5SZh7R+NM0S6lCaGcz2RmJt9zxs5DXvxd4yrcH/MtC80vyPznVVo4ajr4KkMdgjukTp8NfrLg9AR4f6cgbMZh6HaCk15EPnSWBnyPLwlguWDYSymP22iAEmoSHzQ5H37LxU+TfE4GZNxrQEoTKh+oQvfgEzfHHOLSpJzOgZ2PHiN8OtCGtxZCloo7fhwePQakuqqowANvnzMXsH01aNBJXPg2yOJtxWRFyVn36RbqzI6edpC4SGQmbKMljK+kuqzFwTB7B2mkk4OU3yt6ae8zfl7o4Ig4+Ap09FvF0EYbtVfXP8Dsazu4xP8dU7jYL8DrfyNEDtoko7B++kQeJ4x02YP8jcd1JpqimTb75zOFflmyldy3XG/vGHWqQy7rfRzODAPL8ROuJUki2C/gNCw/+mra1NK0XjyTMWQk6rbSxlYSURG4blkCTFCDXkIA20KRy8Ee9FXQgs33FrwCy9GP48duDxuusfyf6quNscgUmyApk2Alg/DDGywp2E0WAyjtDjLd6YBv3H6mFMBXhBTSHIJzXttCqRLeGlfSjLsGKrYsC7ZN5YURuXlzUO0z
 TG9PYKFB
 8PGnWqrxrtQT5Ijg2cAhhw/KWY+RhKGGMrhK4JkY6s+htdU8anjCo6dZS9QXITTGq/HPImuEdrT70eTYbBu5SjGrKl9DSxB11aIWK1EHlwgVUIl9Hu1aJSF76ztVVLJjNXsoEHkhepuJ0LmBN69YbmJn77WDg3rLhUzS2bZRCGiwrk1x2dtBnm1vUYZkEzxy+z5Pr3wVAFDyO0lUAAFaW4FAHJ7rq19kW4yZhS98sKx5PbmemK+Ih8cnebFeo74sP5lckQ2c0Xq7bzN2SDVyiXeRKPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_probe_{add,rm}_dirs names a variable for damon_sysf_probe
as 'attr'.  Probably a trivial copy-pasta error, but it makes the code
not pleasant to read.  Fix those.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 92de341827cab..9f9262c9b99ba 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1075,7 +1075,7 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
-static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
 	struct damon_sysfs_filters *filters;
 	int err;
@@ -1083,22 +1083,22 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
 	filters = damon_sysfs_filters_alloc();
 	if (!filters)
 		return -ENOMEM;
-	attr->filters = filters;
+	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
-			&attr->kobj, "filters");
+			&probe->kobj, "filters");
 	if (err) {
 		kobject_put(&filters->kobj);
-		attr->filters = NULL;
+		probe->filters = NULL;
 	}
 	return err;
 }
 
-static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (attr->filters) {
-		damon_sysfs_filters_rm_dirs(attr->filters);
-		kobject_put(&attr->filters->kobj);
+	if (probe->filters) {
+		damon_sysfs_filters_rm_dirs(probe->filters);
+		kobject_put(&probe->filters->kobj);
 	}
 }
 
-- 
2.47.3

