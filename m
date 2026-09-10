Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC9FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59CE26B0098; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483FC6B0095; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B556B009B; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFF006B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D56A403D7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:31 +0000 (UTC)
X-FDA: 85196508222.13.44B1902
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C68E1180005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDap9z8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013009;
	b=2SdvTI4bkAuE/QjBX4+qO1jpObrlM6M4N1sRcwrvYCsemPCtc1wQshdMjS/z92XNV8/6Y2
	hEvEVUFF1bdO9V5M2m1MHMdp77b88CSN+67d4KPtOZ2AJDrJJOvaE2wqJhSpXMe3k9teFJ
	QVUcZwJoyYG9kARHSnxsNISPHiNUsSc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDap9z8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	b=Rsxjru9lhXzFCJK6iQsx2qcwTlOSzylAqmpIDvV9zqK0wG0qzaVVsRs8uCzrSo0uJBIDeH
	mizOQQaeulWMbosOEtr0p1GzOBHYlqilCxRf3mNRVAf8t5JK0dKqfp1dPQFWs+9BwgYE5G
	achOjdWTPm8pNaf5ZEuEZbNivHiho6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 125EC601EF;
	Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F621F00899;
	Thu, 10 Sep 2026 04:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013008;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDap9z8tXSYMRFqJcTR2+2LWN0F8KtxSoMDyfpWrMAEYHMgXYjB93N+sAdNSZvoEo
	 sswyULLoD6tjT9KS3Weqt5Th3y1MBo3IPwwjECHFQ6mRgRBy7Qh4YkonrqfXOGS/SJ
	 QTduxzxke8czAC9kMFM4y814onveJqixv7hk3wllq1SLIEbSIeACRTt93BtvDmjRp2
	 ASaWUnd2n4GE1kSj1hdBboygwnmobwMgTR26A3mSPOYiAgvzgxzrSWtuBFM/8TihcI
	 UkZs2qp/ghCE0YrCTc9M5ebgYXVh0lwqOsmQqnkCKuoucyWS9EIS2ojLxPc3p028g5
	 wJqBLLtXrV2xA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 4/7] mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to range_{min,max}
Date: Wed,  9 Sep 2026 21:03:15 -0700
Message-ID: <20260910040319.147037-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040319.147037-1-sj@kernel.org>
References: <20260910040319.147037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C68E1180005
X-Stat-Signature: es8upg6847ictjw1em7d4r35kt9m88qb
X-HE-Tag: 1789013009-569794
X-HE-Meta: U2FsdGVkX1/dT4gFpXrvaZMCw9Hkg3Ezz3U5HmDm59364sndZx/aN9gjf7QInAuSJ23Ao69924cMB5tFokenLEk8YWJMpLn8xBpJWhzc/VngAUImQQqP7VyiEQ0z27ilqjBx3xmaa3RXRzSNw7Bp3wpPbTPU0muIAXw81IKcvXT8moB8aOh+GM3PQKBko+rHZLNk0majdjz1qCMHmkEFxkViAAKgSxEkpTpzGZISpv9DWqqfkODW7vv2H+0EwgpBMuIK8arHqgRSwWdvAaBD2L0o9T/hmRcswH3rQOWZTf8kSRRQluXn/smBIzfL0RISXweH1cyXI5dyBnllG3/P3Ufe91/CYHPZ+1h0iM/HaRRifKGN5M/B/UXH0Y91HxBeVSbdbTji4DsjzUGxVamSe4t85FBSV4QrFfcPTzR/TIn1Fr/A1s8UHnZenYIZ6yIbxSMYPyNlY/jj4qtl5GVmt4lYGCo/be4ZT7+AzqukU9auLqfeBhMr6M3EaAU2xsvgzvxSgdy3DpuZyUxN9XeWFYt7Z+zdRZ2tyWbatjdZQEY+sds6AUXWGlyGNxUkl8SAOSfgt1eiBp8bw7BST/R7wL1LZJ/7yZ+kXmBAiV3knij7SWwQdo5IFbYlH807ku925pIRGNtF2Di5R6BYRShWlFOMRPxlEu9z8qG5eEzQxRkB4SkFNNNSYh3W7RZCi7+zzwks45ZLAIxI7OhuXIOCp9R6uHGXT/p9l7KmEsoYxCxKnkb9Rqq8KiPiZ1rhaRrjYFOyhZ2LQiuBbVRfeEAkdRzFT4FMsALdko9PRsdV2LrKyyfUNdIyuF97Imc+bdOktTSB78bMSNnGUQlswl/+FuqTchEPZikTQfVS89v4uzxCCEWvVXf7XMo2ekvFzrzTchlwWMsIMnT670RdXSsxixc0Y8jgwlwel91V8mdLCxgSUwpJVKJRmz4LBEO6DWlzOFaOoGD83cw9aX7WcYb
 VKcW7Ma6
 ZKBegVb6jRaMVOjIv/4lN/vNheNk3+s0LS+OQOoZW1dbiFkHo4hoWA/o2pDvR0JWDI/h0DvNk+lY5TdjnR5xjHNNS40x+zbthga1AGfAlN0DZ1sBWfPwQ1Ue4FWt24H889hSJqwzw7AzBB91O4HUBC3eQnUFmYfVsCws20EEE6lR5A+6nBs+GqQpd/8xoMBbTYuMUIcV0ejCz/YnA2zE73cxzEhXKwKJzwmCt+AXyLJNQPHt2IxMyFviHKbBRaPhVjOiMlX6voKpJ16ZWAzluvXAiOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface provides 'min' and 'max' files under the DAMOS
filter directory.  The purpose is setting the general range arguments
for hugepage_size like filters that require range arguments.  So far,
hugepage_size was the only filter using it.  Hence sz_range field of
damon_sysfs_scheme_filter struct was connected to the files.

In future, we could add a new filter that can reuse the 'min' and 'max'
files.  And the filter might use a range of a type that is not size. For
example, probe_hits weighted sum.  In this case, simply reusing the
sz_range field would make it a little confusing.  Rename sz_range to
range_{min,max} to avoid such confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index d9b81d7b5910e..4d9147d2a269e 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -534,7 +534,8 @@ struct damon_sysfs_scheme_filter {
 	bool allow;
 	char *memcg_path;
 	struct damon_addr_range addr_range;
-	struct damon_size_range sz_range;
+	unsigned long range_min;
+	unsigned long range_max;
 	int target_idx;
 };
 
@@ -588,6 +589,7 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
+
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -778,7 +780,7 @@ static ssize_t min_show(struct kobject *kobj,
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
 
-	return sysfs_emit(buf, "%lu\n", filter->sz_range.min);
+	return sysfs_emit(buf, "%lu\n", filter->range_min);
 }
 
 static ssize_t min_store(struct kobject *kobj,
@@ -786,7 +788,7 @@ static ssize_t min_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	int err = kstrtoul(buf, 0, &filter->sz_range.min);
+	int err = kstrtoul(buf, 0, &filter->range_min);
 
 	return err ? err : count;
 }
@@ -797,7 +799,7 @@ static ssize_t max_show(struct kobject *kobj,
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
 
-	return sysfs_emit(buf, "%lu\n", filter->sz_range.max);
+	return sysfs_emit(buf, "%lu\n", filter->range_max);
 }
 
 static ssize_t max_store(struct kobject *kobj,
@@ -805,7 +807,7 @@ static ssize_t max_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	int err = kstrtoul(buf, 0, &filter->sz_range.max);
+	int err = kstrtoul(buf, 0, &filter->range_max);
 
 	return err ? err : count;
 }
@@ -2835,12 +2837,13 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->sz_range.min >
-					sysfs_filter->sz_range.max) {
+			if (sysfs_filter->range_min >
+					sysfs_filter->range_max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range = sysfs_filter->sz_range;
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

