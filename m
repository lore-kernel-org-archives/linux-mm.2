Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE6DCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EE28E0051; Wed, 17 Sep 2025 12:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16548E003B; Wed, 17 Sep 2025 12:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53448E0051; Wed, 17 Sep 2025 12:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 938D08E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:00:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A59759E83
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:00:49 +0000 (UTC)
X-FDA: 83899205418.02.6884AB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2862940014
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:00:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rjphx54c;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758124847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiQ4GiKGpa3/5fWxgFr75vNNOju778Z6qrSXjnhrFw8=;
	b=xUkZZn8tDgQxzWlREUYtvqSECWFCxzg96zLPLpcjue1eVrWwasJZetZkCyoix3sMc2sF3+
	mAuuE90epGaT9AAKgB74+jQPoVdqyoH7kzJJlQM7Gx+sF4ZKKOX3rKeG/VB0jaSiH9tt8O
	YfMAkKaFafaGulnO+VW+HtlnJs54bEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758124847; a=rsa-sha256;
	cv=none;
	b=F1GiISfIgVqHgwf33tM3bDergJQbJmqZZUdSdP7g6MqWIECCZv2oLhMEJ4UqRLkCysId89
	Xdo3K8OWCKPKgkwzbsaK0jn+Cu/T5l9AMlL9eY+yk+kUsgkKsyP7fYDnQrUNDcdX9ZfWPo
	5x+mAlpZINRGHm9Vd4T8m7iNPgt7ulo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rjphx54c;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08AF0434BD;
	Wed, 17 Sep 2025 16:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CA2C4CEE7;
	Wed, 17 Sep 2025 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758124845;
	bh=Xn5cUrhSlYfU8D+L9SzM1MDf0JSuHHuyW2CfS7ldx4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjphx54ch07/tjRjFKkF3By6vtvpnEoUncKbAEpNlvByUm0k6NJiK3Av1UQUAvA7/
	 LneouAJG8afb9GBos2X2/BHT0+7oWwtTWaYdMGOH27C/1vsA8vR5XCj9KCRigfP3Bo
	 7ad72wYPbbvz18kBhYzdme8W+ABuQfkCcb/v0HGDCCeUNmkyXDIU8/Cwy0Njj9wTV5
	 Wt1hoamLPijmJsp5rkEo1Cnd2gpQGLnwFJLpr5vW83Y4IneF8pEqWZhH4R0jD5kiZb
	 AtwYwkRHy3ufNQZWQM/Ikvip8S9PgWIOiSxcdZ1uHjRAI4dMhBWDg1s/ormnLgbIwE
	 bLEcc8txhbO6w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3 11/11] mm/damon: add damon_ctx->min_sz_region
Date: Wed, 17 Sep 2025 09:00:41 -0700
Message-Id: <20250917160041.53187-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-12-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2862940014
X-Stat-Signature: jrinbjqyr8j4xje1p549zmibug4h8trk
X-Rspam-User: 
X-HE-Tag: 1758124846-57376
X-HE-Meta: U2FsdGVkX1+zkgDBpaDyvuQtaRdj7+7Fvsy8YBX8EOfIUR66wD8TSOxBr2M2ZRRFlJq9a7sG4A05MLZ0kdyEpaMNQOvRpuCKOQ4DdBneVi7tuE+1+SXalTeTPvVys6Wus7hN0d4LxsyDgJ5pNuvrCZ0409QanKM+Wfo4vj5cvQWKMozT5RXw6n+Tj2D1iGmi7XTA7gbZuzWzO8YAaJ3o4FHyJIKUiOOM2Hnhw1vOn1zXv6MT9udT3Dd6GtYW+VwmSk+2MangNrc9guPUheHjzyyp4cArz4HRzBHWN6XKx9IA6n0tDp5wfMl3OojDXl7T0JA+XBp5j5rQ/3PmnEqcPysHxJ0ITSOeORXx9zrQ/8lvWjC0eSUnCKSTaMfr4zc4mwkkG+lYLdrER1XwGzqIyIErOn/n5WkS1P5S8vKl/+uOX+E24UvBz8JB1nPiIYkR3w373h+EtpsHisFlN3toESoj4peFu9FIVBmq2o12bYAZjlDuY0WevI0Nz8D92JeGJTdCqOxl+VHQz6hysFvaCOtztCdHO3xMhKpIH0XZWRNmabgIm48ca+N80E04tsQl4L6S5GGMw/ev4y3yOmaujOMLJQigy731dVozbTbrh+zN0riKINnFYEdjuXSeA6If6ffJwqvAp9DoUQCsO+M2I5yzQCGzQ4+G8pVHsxZxG448pXraENXuiO/3Mxwvh8c7SvUsapOu1W14Cou9CXcxE1NBtF1mZqydZWzexnT77vvoCSaXbDDuEYv5WfM+rn3BZFz16hmqoPCf37w5tR63sU1iuQBhpQx5KtUdZWdl6qnZks0iXkrVurK06DSP2yWCt/2T0hLy/S/56mEh93Nad+E7oBBcoRizJOxYJBHxeetHi2YiMCkCnVLLmVTB4Oeo1Y0kSdFPSm/cvnm3kggNwYOf9Spu42IOR1+qoM+ktbqWRMQc4SvbCXXz+WX3GDA2eNhoIbDfDEQ6KlRGCck
 7ppFTecu
 I5H4yx+BXGB6wibvevJ/NEHJTG8heiUZbjzyP1vkpPsICpH3aXMEHABKLNK5B1KAqHuhLW1dDb5MO3gtB1O1mX1uEsa0swwOMy450T7/oyT4rZYweV7grtAXxbJ+id1LJKF989ZTBf1GWDmXzRHlu2BXArKIleCrVylEOjF1pGklBjhQNaqHnDBEVHQh5/88rvZ+AlFBTRIhvePuDCMSYuJ2lPkqCtJHUlr2Gbs5HafsZyttf9gzZk3Jo4CQ45LWbT8VrSwFjP+dhs1CLeK/Zr/DbbrnIojgxx1RSfTt8ySPMKMMJrFpj1PjT+Avpw5/vCy1sM0pvQTDe2MM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025 10:12:42 -0700 SeongJae Park <sj@kernel.org> wrote:

> From: Quanmin Yan <yanquanmin1@huawei.com>
> 
> Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
> bytes and cause data alignment issues[1].
> 
> Add damon_ctx->min_sz_region to change DAMON_MIN_REGION from a global
> macro value to per-context variable.
> 
> [1] https://lore.kernel.org/all/527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com

I think I found an issue of this patch.  Please refer to the attaching patch
for details.

This patch is in the mm tree and not yet merged into the mainline.  Andrew,
could you please add the attached patch as a fixup of this one?


Thanks,
SJ

==== Attachment 0 (0001-mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-.patch) ====
From af4a31405f4d8c4e5b32f7244f0cdcf960dce30f Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 17 Sep 2025 08:31:54 -0700
Subject: [PATCH] mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr
 use case

damon_ctx->addr_unit is respected only for physical address space
monitoring use case.  Meanwhile, damon_ctx->min_sz_region is used by the
core layer for aligning regions, regardless of whether it is set for
physical address space monitoring or virtual address spaces monitoring.
And it is set as 'DAMON_MIN_REGION / damon_ctx->addr_unit'.  Hence, if
user sets ->addr_unit on virtual address spaces monitoring mode, regions
can be unexpectedly aligned in <PAGE_SIZE granularity.  It shouldn't
cause crash-like issues but make monitoring and DAMOS behavior difficult
to understand.

Fix the unexpected behavior by setting ->min_sz_region only when it is
configured for physical address space monitoring.

The issue was found from a result of Chris' experiments that thankfully
shared with me off-list.

Cc: Chris Mason <clm@fb.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index fe4e73d0ebbb..883b0d886d68 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1435,7 +1435,10 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	if (err)
 		return err;
 	ctx->addr_unit = sys_ctx->addr_unit;
-	ctx->min_sz_region = max(DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
+	/* addr_unit is respected by only DAMON_OPS_PADDR */
+	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+		ctx->min_sz_region = max(
+				DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
-- 
2.39.5


