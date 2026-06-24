Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 851A5CDE004
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F7A6B00A6; Wed, 24 Jun 2026 10:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0466B00A7; Wed, 24 Jun 2026 10:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208566B00A8; Wed, 24 Jun 2026 10:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E52BA6B00A6
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70E7D1C5179
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:38 +0000 (UTC)
X-FDA: 84915016956.12.EA8ECC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D2CDB1C000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHvS5sZv;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310836;
	b=j/9g589hNwt9A3Qh3iT6CaxK2+cF4xgKQUns9bEFDzHnqK/MMooRtZk5ex+lGkgUTCTcn6
	12cyT8DDhtrI1q3M8+WEh+oSAtMdfmio5drlJyK0dg4gDaFi5DkI+79CFtG2y58Bobftmf
	Jglnxq1DdWWERolWjBEBBvxoq4U/29Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XnY6JlGmHDm9EPC8r6m1olyqqXaV+5C6iqLBZxkBgc=;
	b=3MVSz6ez+yjQ64ZQzMssMABXgKOv4pJfc8HBjGNXBN+7EbF9Dz4awKBecKEMGRDwxW85UG
	bar01Q0Ah24muvYhU7BKs6Gcu+Xz+/bg8SL1psUBVRKoSFNdM7qv/WnXQGXd5XJYRaCNiK
	gy6UpDIjJIn3PgtLtp9n0jLDueInz8M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHvS5sZv;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23A6E44167;
	Wed, 24 Jun 2026 14:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4031C1F00A3E;
	Wed, 24 Jun 2026 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310836;
	bh=7XnY6JlGmHDm9EPC8r6m1olyqqXaV+5C6iqLBZxkBgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHvS5sZvbu6AMpXrSj9t69t+7pcsUYEI+ma72cqQP5jzjOOGtA0QPX47XCx6c8V81
	 Z2niPSXaVrB+sLfQhh5QBjAtrULh1oLX9Z/A8As7GFi9agOt+c9LOM/Bu/L9srgKvN
	 z/1ki0kxptxnW6PfLIINFwHLFBPt8W3IRu4mxydgChlJ1kK9vOS+s+9LZxICu+w3F3
	 E+8IcqPs2+l4b+ZiWD+hWxghtj/QBxkGpE8ep0arwZofOj04t0I0EHxUZDlywFOvek
	 jXIiCRDpWZlqIRSPRTnWOojwqx69WDK+oFArv3ytOmYVycrWwY2g/YWIf/k4KUL+oh
	 nHR4nXPzP0xfQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/11] mm/damon/sysfs: split out filters setup function
Date: Wed, 24 Jun 2026 07:20:06 -0700
Message-ID: <20260624142008.87180-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2CDB1C000A
X-Stat-Signature: imnq695infwycutq14dobeh6d9kxx3h5
X-HE-Tag: 1782310836-417615
X-HE-Meta: U2FsdGVkX19bplUvA04omGCilusnvhk0PjLTtXvkO7ljxVHaCJhChM25SUBaMl3h94atNGEwlwZTj7BuNpFveBMHp5zSD9YPo8Vchtl4Wio5nfpUxEZ9GHyRvWc0AuXkMFU+pN1VE8lv2JhBm/ahajn/3Jp87JWzB+2ReAelA/yJO37svDY/D4RR1yUAhfJTg9LntBpl0NbNodZg8Cgv8tt41jobFzgmySWUcRLSvm15wFwCvi79aEMDvHOSOsQs2NshqZ1PRs0tt7nPE6oy4nFQuwi3U2HTJhcH46hDvrLaAQwGdmABLOClNauA0SHHoXGC/iEIJ8gCpaa62ed3Dnl1vy4inJ9OsCYYJa9xy5qFtPi+tkmqORIebI+DXeZRPEB94s5nTQd/UXZEZQrdiWN+F3lBSP/Xsy/uooz1I+oh1eLqfuSaVs/82XmVxHPZr8EvYsUsBRS4x2ab0FGbpbS8mkrnee0k/0FbO3ORnaaLeC7NETsJ4l9HgDdOQ9cxrMClqDfCTDiwDcIpMx+zNBeFFaaHpqfLjQktvYZs7T7PW+u4ox1+X1GxknK8TtzuGxgvwRb2XzgwRhR/XrscC5NVIwRiy/MzrtK9YgIEZ+zlMkoQfzCk2VWK24nOz5G1b/XwUPZS12fM89ivQcnmW+UjW2dmh9NmMGez5fE8v1obp4DUSI7IGQuOosI6AvJErabV5++Mr3SameeepHC1YvCBZKFRKcGp5nbAJ6kVuurRsmid6UofgxwCr6kzCd8CIMn2j3PWvSo8ILr7yejxE7yR0UOHQTQnZZsgFEoS1uiB508x9zAhrZYC2QNc8WLIa883t3RpiNgiYHpxkqJ1KkOjEhg5BSlBtCxlw8es8k4giX847RNpZaCk6+2x5EYfi/ESmSJXz1kWfhi3OIaaRDqEveg0emBGhEMjChGqJxaeSpi7R/twpMWKwuk03TjwWuipdX3GyevOJjpvkRD
 dNjgt3fX
 e5fr5F6Rqo73GjfB59+B7M7Nec9Nm3TJ0gso11aaVHfX7bP5qWiyXal1ke8HF2N8YaWMILzO7wOug4CB/1jL2VHv503YAdFOtOY0GZHD6dNUFNZQkaKJ/2Wx6moNCRSGbxd393AyFoqWvr+SLHwiRUuyET6UZA4KMRjkGZBKxKpxn/9DHe5F9r6sRtG2YBjzFXqNlufnNToTm0gAsfirikM+qokFZIBkTOFT28lWJ1I1z5jI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probe() is doing not only probe setup but also filters
setup.  Split out filters setup for readability.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b662afd41791d..92de341827cab 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1911,16 +1911,11 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probe(struct damon_probe *probe,
-		struct damon_sysfs_probe *sys_probe)
+static int damon_sysfs_set_filters(struct damon_probe *probe,
+		struct damon_sysfs_filters *sys_filters)
 {
-	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	sys_filters = sys_probe->filters;
-	if (!sys_filters)
-		return 0;
-
 	for (i = 0; i < sys_filters->nr; i++) {
 		struct damon_sysfs_filter *sys_filter =
 			sys_filters->filters_arr[i];
@@ -1947,6 +1942,17 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 	return 0;
 }
 
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
+{
+	struct damon_sysfs_filters *sys_filters;
+
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
+	return damon_sysfs_set_filters(probe, sys_filters);
+}
+
 static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 		struct damon_sysfs_probes *sys_probes)
 {
-- 
2.47.3

