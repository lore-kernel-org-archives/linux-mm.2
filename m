Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02840C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44C46B009B; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5C06B009D; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9326B009F; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 632BD6B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92FC1140207
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:22 +0000 (UTC)
X-FDA: 85201628484.24.EF419B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E46BCC0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osZpkO6j;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	b=JiWqAQUCcRykGnsui+X37u408JfblLKqgEgLvV1g0O0Hch077TdAW4/jdQaftfgU8GaKzf
	RfCPmhN5s0xf9VqX6hYLGO6GSFKZ1YuzYdqlSTGoZ1DPJTS5JKRLsRLg87fs3ralHBfkvo
	WK+RuFxksu/WXsZamgzstNI+34+JHFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134921;
	b=8LTKe2NYR+W6eX8XTnEH0+n5tQ0j3PSBC16Ku64LjOBtkgceIiM/QrR6dv0LY6QTPoAany
	3izXDanFxCE1kl7+DeQddQ38rdQ0My3RcwLIvrQ/NiGQsj9CdDOcRGP/4HJdWAVNi763Yv
	H8ud+HjDwJjtFg+j/v+E2llNp/pa9gc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osZpkO6j;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CF9C43DD5;
	Fri, 11 Sep 2026 13:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBD61F0089A;
	Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134920;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osZpkO6j+lDPrVvIVvfAUoPUsjgBiXNuYnxJgSDRd6gQuBx1JlI6m3WUWl9JzMvas
	 GEeDlS0UvMSKHeynJx3438h1oq0WsS+0138vL1Yp01xPWKvD7TExkdxis7VKrskexz
	 nB7EeaV84ZGN3bqn9LC+eIckIkLvUlPl1NA+7LtmNJkEaV0aTpVqK7ghC4pxyYHs1t
	 is/d9RCdIj7OciUlVkKSBgMLEuFOlFtONhkdjgUZDTPOgYEMvqt8om4EqnSzLv1vUj
	 b0sg3jUrWpWooGixRfh+SzGUPerdYAkiVynvUdcbrU+RhufHtG+tHqrcIG00IrnyPG
	 vv30g5mqHJN/Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 4/7] mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to range_{min,max}
Date: Fri, 11 Sep 2026 06:55:06 -0700
Message-ID: <20260911135510.96914-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jfogd38pjj4ctrezo4m9bh6d3j8an8bx
X-Rspam-User: 
X-Rspamd-Queue-Id: E46BCC0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789134920-205422
X-HE-Meta: U2FsdGVkX19dYStRKF7vw6DUzx1+apUkRf6vOY9SNhUfiA0gbyl977H1p/ov34qlzCyE2e9kq5N58GEYgDlhq6vl4+1BC+06kls3E9iXYABuXvysGhGBQqqClk55H4UjWhxh/F8Vax8ye5324+jy6QyhWBB+Y8RZmxWDBgka3ETEAb1zJ/MK1Wgg6kQL0IM04NZBMkCeygCk9++6S45P4cFN2WR0r/TyUPsD0ikThecC/Tgok2LSbIuK2vbImmkWm5sWfNUPQaGFKCFH5ke+KyPyXA3VDfvbgU1jVzdTdYGflK6irsVkwZhjeaqFWaCwCSWeSbVu81lv4HYLlLC4uNKA5AUAxfCn3XXzzQIvxMltZsmOhgwAreLJDJ3/pIIo9onztLP+RmmddIR5heVHOXvxmPLOpPki7T3QunxjSfaGRL+o8xlwL+vJSEONCphKhADnif1mCQS6gv/IZB10cE03ohI3jFvpXlGLy2YhKAbZzqe72OtBx1L1NDZElGrmVIhHgSWj1fXMMp2+jYQBfcXYDoGiOCRNqLF3rejsJH+jD6K8qDJwSMgnVqON1iRBB1HsEl+YPegcPmnLmjPkP/RX/AEpWVcxUeV+znWG9pi4HU4EduCLGCVAlE/XW2SABWLpsvGWzQnvRAr1+ofPef4Ge97GpFQ+MUsZORS7wjseygG6TMMNpCrTqfJ5MhG7SELbVS/uGS1ntqq7Fefb0FwlPtR1nSmCtDzsanJ/+rg9ikgcfjMiVxMxiG2mCb3gDPCRc0GpmADxWDHB/jOE3is3j4FW5PBRizxXZlyLWXTRXX3fRNxf9eET0JNdP1hQlblzZI3RZXrNmqBtua/sye6AIRjJ/UcLiUle9vVzG7KVPXlfIZnKQFN+Tyl8/KlncfTmSY3+zZYCvU0BnPuoVZOCQWREfKgcims1CHs0iWQlxaz5Vtx/+yz3+S9RHNoMM3pnl/j1UuLE0ynQ3L5
 acZ0GJT6
 QrbK7SJCIYp4VWPw6IQ23Fp/dkpU347RBFgW4SBqzs6eR+IpGJQlFkilqUR0PLMq1BhgMNGf/nfmCwGX162eZxV3ObyM40QTKVZbYoGUxfj9SQ8ZEl0QM4tNoXWe57CHbxY5L9qZkCin+V87RELCzyZSi9cCVIzBSvT8LDgizfr5qlvQIfnYZqauDrbqMVXYnaIeUX7wn62N3o//aKxKDwtU9RLM8gRpDrIKn5kvR/hkR2N4TcmBtVwjFkPa/Lmp4F7uE/x0iB9UvzfSn7AI0EUNXQcj60xsZ8to5stHYX0yXnLUQIutI00sFnoNugvAXsoCU4vC0i/jY1uwEi/4QErtmtPuGE5nVJScFkLazQHZtC5v2ZnIHvbrcTw==
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

