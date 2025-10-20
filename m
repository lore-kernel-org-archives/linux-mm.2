Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD3FCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EF98E0017; Mon, 20 Oct 2025 09:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D520E8E0002; Mon, 20 Oct 2025 09:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41018E0017; Mon, 20 Oct 2025 09:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B03788E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:17:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78FF01A016C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:17:11 +0000 (UTC)
X-FDA: 84018543462.27.01B9EA2
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4790F120005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:17:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0VsxutGC;
	spf=pass (imf29.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760966229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGywFmiSziGA+dzPphRNfH4Y/ZZUvdraDxQ2WUrBU/0=;
	b=lKCdEVQdrunFZlablHnJlPL8p2VD2DX1LiYlIdN55dpOP65K23fMT4mkOdUHcWfyVcOb90
	kTFj8+kLbEOEWyv4vrSYNKdRrNbwYM0SF6HFp0iMeTDopiJuskGXvSdGv2LthWZ2GJOWNl
	Cx6ntCMxGJeIfA/u5VoI1g7MQbApghA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0VsxutGC;
	spf=pass (imf29.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760966229; a=rsa-sha256;
	cv=none;
	b=rwwUB1BErmQR//3LTRELQB7IM31MfFBoBicsdBSAphPvyj6Qp3AXHNz/HSvNu8OA25iRhK
	7w/rAVtmKLc8Yy5/HM9f9lDM7fyR1TAOGbybQfzP4qljVY+YDUmzMAtGZ2jZI+2YtSzTj9
	z5SHRKX4JrbDUYQADLglSW41D1EmOcg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tGywFmiSziGA+dzPphRNfH4Y/ZZUvdraDxQ2WUrBU/0=;
	b=0VsxutGCqGQW4jtqWjaZUUbbFGZPhdE86CgBoCtRq/pzPgRj5wzqb070klI1+qzeMNamfY5D0
	s9J0SVX8Z8abFKU3zzzvke6TPPU3ylbZUpRsrJjbXoFbtorrlu/iyvM3pWBlRf31pfc6f1uIKg4
	IzSe2duFzv0A+5Xn6dQoRRk=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cqwtb1pl5zLlVc;
	Mon, 20 Oct 2025 21:16:39 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id B27751400CB;
	Mon, 20 Oct 2025 21:17:02 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Oct
 2025 21:17:02 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 1/2] mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
Date: Mon, 20 Oct 2025 21:01:24 +0800
Message-ID: <20251020130125.2875164-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251020130125.2875164-1-yanquanmin1@huawei.com>
References: <20251020130125.2875164-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 4790F120005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ru39ohyszdcuwzrr48i78fq1o4wwuzkq
X-HE-Tag: 1760966226-464496
X-HE-Meta: U2FsdGVkX19NfqKrP2gLzgG+tQFEj12zbgZ+RQss5wUvTmy0+IXg/FEWydW1/VOvQLRepVdZexVYQa0R1NbPPiMtFWx43DLLYVi1VHPYveCTJd6EopTv15EYCvcNt1lCjYEU9PG1/uvI1KRwoYVErbo/VHB67nl4aRTpAUE8iuz8vZvqmvb9IRzV/wSVT4lmGRJDAx9TGlWg4f5KKSvLX+bu+hi7YQA0z95mQuxMvyLeqbmAyR6/2tcs4X6cElXN551nF6dKEI3gKgDgwxbSBx4W1fUSIJIs6t1FmrCdcz9+mAJAQQju0km9TL9KtOonhSIEnhuMn1lr7RbPR7T2/dZG8GFwFMYp9HcN2w/Nn3O6yxCCpEsKbMwXLqsrKsakdJqAcWbw+okvI+NdN6bpEjqzy1/atP7xfScxEcHx8PD/p45pqJnxY+3XyC+AVynOPqJVABcuf13AerWzQ6BBOs0ZtyoGBBpyQq1V8kfjRt5t40Soh9rB6j3iw6DomZRllifdFFRB4XVP0NiBu4RS0DLO7VIXtRHI3lEAArSPn0pV8bj9jXTQqrUW/IzBpx5cRULkAzJcHA3fayFcC/M+2TA65y9fNae6pdFmBEcpYGncwetRNMnwBw33cTAdiaLchHnxXFlRYLPAMxIaPG3cmyOdB8oncuROzNtCI7Bli8mGbutkQ5fP0IKV5GDcR9KDNSjLb2FCqVjhIwdjZx8SIBjm6H/kWNs03EE7ur9XmA+CXrVdxn7ID4Hr6sHa2B4jM+Sb/751LrU241KlI71CAM0Ug/HiWvte7QUBEj1eSxjYX0wbjMKsmMZAMDjyMDU3K2fL8m2EzXWguxJcE98jfsYGzLvES13RMLOX491HjB5JR5MEkD+E5/dxvk2DTLfJV7EMKaxw30EFg1IgP3BKENDiyDDiU7AuhnaZFksIwqkSBdVzJh0zC1xAC02wQ0YlXbJuoqyEjnkVMiBjaUJ
 sZndaLu1
 8CAhKEvcelTHdX5eDvo1guCz1nY4mI71BE1FgSQv3kib8DFtVEsjT4lWbdbKzhpSXjoo/ZkphizKlwk82b3NsNAbnwudCOPhJxOuYaKpGKsUbuXkVz+uf9j4KP+mY9pAd1yh7V4POhSNb8q7HRAZAFvkrLU6y1yRkb7aPZd7w50QR7Jb41YWjuC7zKhY55goZ3MvCQcucT5758DVbXlzFaqqMXLercZ7ti+qoZYtKB0rdPP/h3KAjDIgOx1s9QA64qpKnQZ6R+xCNhRzGq05GUcxvGOpzioHQXa4dnbfZftUh8qE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In DAMON_LRU_SORT, damon_set_regions() will apply DAMON_MIN_REGION as
the core address alignment, and the monitoring target address ranges
would be aligned on DAMON_MIN_REGION * addr_unit. When users 1) set
addr_unit to a value larger than 1, and 2) set the monitoring target
address range as not aligned on DAMON_MIN_REGION * addr_unit, it will
cause DAMON_LRU_SORT to operate on unexpectedly large physical address
ranges.

For example, if the user sets the monitoring target address range to
[4, 8) and addr_unit as 1024, the aimed monitoring target address range
is [4 KiB, 8 KiB). Assuming DAMON_MIN_REGION is 4096, so resulting
target address range will be [0, 4096) in the DAMON core layer address
system, and [0, 4 MiB) in the physical address space, which is an
unexpected range.

To fix the issue, add a min_sz_region parameter to
damon_set_region_biggest_system_ram_default() and use it when calling
damon_set_regions(), replacing the direct use of DAMON_MIN_REGION.

Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 include/linux/damon.h | 3 ++-
 mm/damon/core.c       | 6 ++++--
 mm/damon/lru_sort.c   | 3 ++-
 mm/damon/reclaim.c    | 3 ++-
 mm/damon/stat.c       | 3 ++-
 5 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cae8c613c5fc..1ce75a20febf 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -947,7 +947,8 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-				unsigned long *start, unsigned long *end);
+				unsigned long *start, unsigned long *end,
+				unsigned long min_sz_region);
 
 #endif	/* CONFIG_DAMON */
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 109b050c795a..dbe48e43682b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2770,6 +2770,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @min_sz_region:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds the biggest
@@ -2780,7 +2781,8 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-			unsigned long *start, unsigned long *end)
+			unsigned long *start, unsigned long *end,
+			unsigned long min_sz_region)
 {
 	struct damon_addr_range addr_range;
 
@@ -2793,7 +2795,7 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, DAMON_MIN_REGION);
+	return damon_set_regions(t, &addr_range, 1, min_sz_region);
 }
 
 /*
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 42b9a656f9de..49b4bc294f4e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -242,7 +242,8 @@ static int damon_lru_sort_apply_parameters(void)
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					param_ctx->min_sz_region);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 7ba3d0f9a19a..e30811cafe90 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -250,7 +250,8 @@ static int damon_reclaim_apply_parameters(void)
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					DAMON_MIN_REGION);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index d8010968bbed..6c4503d2aee3 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -187,7 +187,8 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
+	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
+							ctx->min_sz_region))
 		goto free_out;
 	return ctx;
 free_out:
-- 
2.43.0


