Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599F5CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E789C6B00D0; Mon, 18 May 2026 19:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BEE6B00D4; Mon, 18 May 2026 19:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D1A6B00D3; Mon, 18 May 2026 19:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1FC6B00D0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A3D216182E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:35 +0000 (UTC)
X-FDA: 84782164950.05.737C469
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C3911160009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx7Y6cJy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnFUMAPn6Nxe82j0DD4iYxpeHnbPeZwFXaeXqNFVjac=;
	b=sbXmrVqArJ5nXLC0d1Zt7EW2dsdJp1RZlGqGmzD7EL5p68Tp+Hc/H0OecB6h4nvkIp8Exp
	9aZwwojjKJrPV5mSqHSPQV0GZDjqyr1lPUibsGFKRcHHm6f3IJO5mzWgUtlbkbou7TLUj5
	LEQ6RttHqYOU2cXUnVQTG5WH8Jlejf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147693; a=rsa-sha256;
	cv=none;
	b=ZpJe/qvljXy9QBuIz+oZcSvHKh55z9pkfVIlz/n7F0+Eo8c0ow9kBIrfbqhRehJdf9m/+Y
	IJIcmWGbNeWCxjCuRbJrjV3KwbN8HHZs3jrTN0LABaUS0GGkxs6C0xZ5S9EJAigqjkF7cH
	eBWm2D3Tj0mDDsbxEmOnI7KHLZuW7ws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx7Y6cJy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B45E41AC9;
	Mon, 18 May 2026 23:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47486C2BCC7;
	Mon, 18 May 2026 23:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147693;
	bh=6WMqOvniCqDfChPfJlN5gPjmRV0oSVQC/3h1Awn27/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nx7Y6cJyf/Z+FfDkjViLsnVZQjjR/x4a6hle29GtyefXQ8KOem/yZu9D84oeZkCow
	 brJZMwLSkRV1s8PEP7ICJK8cV9yF++/3ijIGWnetTeohbFfslS94JTfBuFhXwrVxT/
	 Frb08HxyZLHkS6S3ta+POYFOs25hy0wZu0f5XGnF4zHqeOSI3E1UrNt9R1S1XLo5t+
	 i1wwT+vcb22AacRZzfhL51l1M/DMvkkOV6n0HZ52/UZn7K8U3rPpL5tyuxPI2Odffq
	 0h3YXuE7nU7USn9cHzsNr3Fhj1SyHj22LCAjZafvWPufwfP9V2+FHWXj54xXvBS7yl
	 VR8Gq+H7tF8gw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 26/28] mm/damon/sysfs: setup damon_filter->memcg_id from path
Date: Mon, 18 May 2026 16:41:14 -0700
Message-ID: <20260518234119.97569-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C3911160009
X-Stat-Signature: 3ghdmb5gn17zzyutt44duno79xy8dz8g
X-Rspam-User: 
X-HE-Tag: 1779147693-686557
X-HE-Meta: U2FsdGVkX18R1FaNlQ+x/8sAdux5PiZx/OPVdtwGEMgS3q/6EZy2yA0NkZ6ey2wxVWJNY5ed0pRWySbnNBBfRMgFS89MpXVYr5LPPu5IAg4GSgzR81ja7ifTMKlEHaCLdiNFUg3FC2k0BUZ8R/7/j4LbfRWjqipwyrBFXyDTfldotUCbg0/nU5vs7Hv9vgzsblA+owvWg5t0XZIuWgF7i3+GyHIRiFxTqSghhLBvUl1e4WI3tuVlvuiZaht2dSkVTIklaJSIhYe4h3flCywrSpkYZ1xuxMlb/znknom1TTiFeAZzHBOnAj92Ptb5TLp9dyQH8hDGCEow8ud3PZsq95ItTvs8SEtIvhe8SNdZEwNOy3Nl04Hnd+7I5TVzRv8Ara+fi06dNAWeci0RoQBoQ7PTUwMQ8OpxCMoFxIpzV6p91rKGTCHTo8zrqkqgsri/7NsJfIXZ4ihOQNyUY8MFuiFI1NT8lhCoa/4r7MBxpJdfTCsWeqKU6xB01qs80xlf2WyduhpMqqmIP3nTLrsmNATBPoz8LtDZeB5Q4ejKNjpQZlYXh8hCZBjO1zkVQMMePZ8dHSsqRmSmKPrEFA3wSWUmPF454pBNeexSu7vwB9WLvgrAjCr2lqTFXLE3PSNffm1THxJbgu7RguorHbcZBRUythZnUevVjpe4xWmgEIp6rMK/X9CD4CsfVKKYvMyDO/VuTDl5Pb0iYidZ1UoJf/m2HTJL2rjVjEJ2nIIU+UFiCCVr+SRHTerEzANaK4lGRpXrh6usfhRNaRWaJL5zloynFb2PI/li0X5/o3pcTG/i4erdeKQHUK7ETJ8dp4Bt3gUA1ywe9aUETeNHQi3pa2FX9eGVtCELQHspLwvEdo3hciGkEW8hEWMMxbjO3xFW0p4PSF+NUolAeXaC0UT3tEufQ4Kz38Te8sl/JKfwD6M5qHri0Er8pA+ZucJvfSvTz/DoVkoMpGQsrfSxIHh
 YeIhxt8R
 Fi753Dx6vVqE0n1VdwR2XgZO0LPNVIpYsxBp10Qbq31Mw8cEAWrLMl/u+w2ox8Y2VltJOEW9tlGpQX4zhBuQT79KFebZeozpYQeshaa8MWgDHGRUh6vXnDQr0adBfyUduvb0qgsHacO5n0QisJokRwZtIcmaItQSkrRhkGQaT9gtw+fRxz8GYf8MUuFmB3VLmOdaK/XeYX19v8iDOk9S6x2CrjJbv5wno7aOo1MjE2vkLFiXf72uy2Wtd5uPmSzkNS5xTkCkBmwVyCh+QYzWwjASY6wdrmTOUG/GU3pavEok0sjN1gDHTruTrwG4wvPsnt5CE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Find and set the memcg_id for damon_filter from the user-passed memory
cgroup path when updating the DAMON input parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       |  2 +-
 mm/damon/sysfs.c      | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6a54c601889bd..4014fd0d463cb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1006,6 +1006,7 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4fc90b0bdac88..68b3b4bbc8fc9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -143,7 +143,7 @@ static void damon_free_filter(struct damon_filter *f)
 	kfree(f);
 }
 
-static void damon_destroy_filter(struct damon_filter *f)
+void damon_destroy_filter(struct damon_filter *f)
 {
 	damon_del_filter(f);
 	damon_free_filter(f);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 0f6379caf4816..2e95e3bac774d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1927,6 +1927,17 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 					sys_filter->allow);
 			if (!filter)
 				return -ENOMEM;
+			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+				int err;
+
+				err = damon_sysfs_memcg_path_to_id(
+						sys_filter->path,
+						&filter->memcg_id);
+				if (err) {
+					damon_destroy_filter(filter);
+					return err;
+				}
+			}
 			damon_add_filter(c, filter);
 		}
 	}
-- 
2.47.3

