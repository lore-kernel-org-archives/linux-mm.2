Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13AAC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 21:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C03B6B0092; Sun,  6 Sep 2026 17:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171316B0095; Sun,  6 Sep 2026 17:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0F96B0098; Sun,  6 Sep 2026 17:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2EF76B0095
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6517A805E0
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:25 +0000 (UTC)
X-FDA: 85184568210.17.A8DB9FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE17B40006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sz9smd3K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788728723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	b=NfbNVyGbtcUcUsuPaDYDqS6RaBsH+1M1cS9Yp/uRNW6Cw5G2dw7V2pbGT8NtOIRW2PyqqL
	EvUvtDn4yHI2OFDL7oPP4WV3U69usXThyBdj25qvTLf3xp1E5QAl6s0k3hhf6sWbs5HAiH
	CTb+OTxxFFc5EnERU1cOMiSt2F81/as=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788728723;
	b=F72N1Q+wU0j/5kJBNeF6igutb+AQbHnx+tUruzj89VCtrpYWqOTpyYroxomTzKlnLT8OZK
	F6rMY4oGpQkar4Hr1ntWDgBHSJ/Xvt/sc3+xZrsXnuoc/pJ2D93jef9ti/AZAVrjRwhPAX
	vA6yBHC8EZxIyA2pBlhEyCGoGAsUK18=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sz9smd3K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E005944095;
	Sun,  6 Sep 2026 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3411F00AC4;
	Sun,  6 Sep 2026 21:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788728722;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz9smd3K0kdpamyBM7yfwtN1T/yGLSKh6HIwF0592pndbKJYo92wSM89pOpSKGpv7
	 gSVM4PjNlbzIV7Ab0D7KROaeL6RObir5GFu4jRkC43c6JQMYK5NEVF917pv3QqxP6R
	 jJwYD3fEIbxNOp0nr4iCbyB5G71GNWkDBOXaPGSKxHRYBUBRNodhk8/ZRWj0uzNUt2
	 Yls5FAzE6gytZm2ePvbhcIRoU4RpIGGIUMV877iR11qP66zBKrQCH7L34JIdTVIy2C
	 y7qrb2bI3Toy6tSDMiw/5oXeIuRGieBOPj3zsE8Af/1cmJ/Qh8Hkubm+KAZW9VwP4/
	 usA5kqJdejTXQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/6] mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to range_{min,max}
Date: Sun,  6 Sep 2026 14:05:09 -0700
Message-ID: <20260906210513.106895-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906210513.106895-1-sj@kernel.org>
References: <20260906210513.106895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE17B40006
X-Stat-Signature: ap6k4tfnpak16gyweeueisy4iadpxnmx
X-Rspam-User: 
X-HE-Tag: 1788728723-638543
X-HE-Meta: U2FsdGVkX1828s4859YvMkLJI1dqfMgrWNw5hq6ZPR6/UXkMQ8u68rXrOQs1eqk6GA78D+j0adrvuo2NdOv8wlBVxLa9fhGs37UYmgzTa7if8iRuCW6gIYfAzS6upZSQh/yoQCZpZmFPg4XDMEcZg+5DQbfWSWnKFvS/nPDjDdhQopBKyjMxYQk9Pjh5n1NrHtCZa1qGUqKAxFkVFvBSaxpoSy2x3+F7pbEhfnYqBrkAOPbiNk0ozZNTvufkpYH7lpJx696AdcHz0NAxDY8ODiny3Swv15qz6etsj/1LUStppmyO0CBUcgQz+7KCyxUB7rfT86oZ9oEQUE4ZgSQatsYtKF74ufo/PfyC6DpFumQuhmcbg2G7JEjjKmciKBCWNf/bmKuBHTkmDtg6bt8HaqNcD/6/apa/OaFKeg3pjsSEvqZYnCAHisacf6JQ2JXY4y2IeUCdaixg5bKN0C7L0BlReTzE3JdWnsmzEjJpcKhRYy7mdpfGoUiAIEGDfXxCutSg8nRpKs7wnSTtJQ2lA/V9WPDUmdGLHEqmJ7esDMrmLtUn1sU8HtBJe+dLoPdj4Kf2BclHmqQbEqtz3wWryHnH1jFH/QeZ8+kK7IAj6R8/v/2cOgkyr8bt60ebqqgZr5vQQXyFMW4NMFPfJJViiNWHNykXlS1kvM81RvwLs9ParhVQEShUHvra9Jao/I+FycMjXUg2kbvZd+iap12jyLEQPw2dNBOwyFlfOnp+u0U7QM2O7hNFsrUPp+KTf+47zDyXAtDtjpITpNSDm6jllCG9PBiJLw0K93VoeJ9AhpKdy0aIFmLUD8sw1jC4ahjpr7KMVABaUVjwbryAfIdWYoR0JqNv53iD0x+phNED69lmaINlk6OBghJNxOuDewY8KInK+0boTmzIw6Qd2fH2nh/8OMy2v6A7M7k37ZFv/C2opKEpHWqnhPDIiEUzdN3BTQqiGnWrTPzeV5JlyWc
 uY42u/mh
 VKGE12LY4n2XZdoD8ekbXlHnCCgCxvzjcWvLJjpiJhzWXKWLsdjoxOYt4GkQe09U5Qan5hqtQ9YQpQhScqWePEil0+IEE/9Bu1UfTqTCgay55LWnLAQymHhlsvdUAJ1zPmna3H5BmNQtGZJr11Kk4BF5wqRbGQaqP4VQdNTUY9IJrvlxJsWFEwxdIoQ9DxkD5QWrb2Z4Q8DOCTdwoUhtqq0lkVQ8zvVaB1QOvUwBAK7GWFz2VMcNSFOYbe2UhvYREyewY0j5mR7S9GgKJHcpKOtRiCw==
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

