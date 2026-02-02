Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B98E7DEF3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A34C6B00B9; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539AB6B00C0; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2B96B00BA; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14A206B00BC
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:57:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA54456581
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:37 +0000 (UTC)
X-FDA: 84399820554.25.5D3A787
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 71B1B4000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:57:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770044254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NT9B2yEmkPfOUbgBh9P3S+SiYnDAT53sgvaEGPSgZ6Y=;
	b=S0P0Pksh+5qWu/kPjIKmStlZqAtsd+FuVvUhbym9DYPb1XARBCf45wLSRZdt44N/Gu5bL+
	GEaGqyl6j9I8ZyEtPTWpmrr1XhmeSYQOHkn9U95F8yRJPfHanBxI95WHt7Jn1kYUiirzhi
	nQPYT5gt+fBseQrd7KiLrR23a+0V3UI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770044254; a=rsa-sha256;
	cv=none;
	b=vKSIsQ5v4BwzVFiGPDo31EEESSZKFa7fMv8eYPV034lpsmjswC2hhSQwh4woObSxB/63ia
	md/jsJtInapyIv1ANprDC9BcKE8MiUwcNGDnTsix1JCpVCguUhvZighYqKq29ODP68Oh4R
	j9icHmvkibn5YqBLh+2HrT6bcS7EWkc=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4V7Q6JvLzHnH83;
	Mon,  2 Feb 2026 22:56:34 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 6F48440584;
	Mon,  2 Feb 2026 22:57:32 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 2 Feb 2026 17:57:32 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <sj@kernel.org>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 1/4] mm/damon: Generic context creation for modules
Date: Mon, 2 Feb 2026 14:56:46 +0000
Message-ID: <20260202145650.1795854-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
References: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71B1B4000F
X-Stat-Signature: 8ytfmejrcst4ggfsd7kbcoaif4ndo71o
X-Rspam-User: 
X-HE-Tag: 1770044254-424384
X-HE-Meta: U2FsdGVkX19FUXq9NhLar6STnSisr6H0moH4bStKyyk0LmYH2V8rPGy11wqAjUwEwdIdZvA9671aaQOTnzdqD5xqVI/BqsA97yHhxGSGKytD1MX0p9x6YZMfiApyOUx0EKPEGDD/cflDeeKcHxySslPI+uas0aOoqT1OhOqgsO+EKlPj2m92LeXMHZpUqbcS1mJTVrradc3rf99pJD9hncc9kiM64ZvT1oiMNaah4hgsnwlo2tAn9rrGfE4wZtc8+m341PS4Uzp4g6SulgTatnp4E7lwbPP2P1MQ3WhjRDarU7cZ407ZZ+tKiRaYi5d5LGVfXKyUphUQGMi9h3pPDbDcLubxgeOznI1tHtlizBOOxmNGUV4D0UvBCXDO+EnqPblgBLH9B7b09uepz2B73+tqZUDwAi7OEHt9Fp1zZDPdhuwUrXCkYB9HSZosp9m+f/k1SYb3p/wUVVE6lC/5kscV2VOUKoOqKDVv7oKOkkXWDXQFr4S9rzT+YrOX2gAX6DYDtnT4F6526cuqco78whjFOmONWktLqlMiPmWRJFOy9gWFnD1gxCRhJ6gCZpSS4TH8eOYzxAACDyB/CkR6y0lmxd379jGoWSMcQGvXxaRLDV56zzuJWiHNFcZpp6RjNdz8aa2YP240fejfrwM1Aly+Um4ycTyYW+dFg5H7d/7yBDHlgAbv5k5toCRrE2dGUghrNwxytHR3gxCx9/IOuogNbUIwKE1qkvT8slrO4F38u0N+/hkX8xhhM2zVOawqyyMx0GjkB/lDy+if79i7ftmHPSnedNP+DBJSrhAZtFTMrJNwI2ngJ/metf3XRZ/WNA7s/crlG3CZiXecIkJ6DSuPq8atqVXkjJ0i/Tv9sTYQYklaaQS4xmENhUlZ1oi2ElEqLU1vx3z8FChqZOznMunqHWveSZD96FnTD9fHqmRxEJkErPokmE6EhV3mVdibP0tDt4txefQ4bvEi3E5
 TiDRvcf6
 b8PyvHHKMGYcemWr8UzpZkrFdG6aKxc0ApRNxF+rGwWS/sk64drQBbM+aHyklKO8zmQs9IdzZtslbe3zQzIIFQ9j18Vqootu0Gq1PtE1ElkqrbJUgzr9vvViDRlrjEOrin81Ek228eMTX7X4L4LQTKgMM8gwWHuqZM4a9G5laks6PS5dDKsitwBa1VViWOpG+To4+Oq7DHB7gvmgq91ves7IkmWKBmhCCRLHK6OfBy5qBm2GbDgtAANeTXA+R23UPm3gt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Damon_modules_new_paddr_ctx_target. This works  only for physical contexts.
In case of virtual addresses, we should  duplicate the code.

It is more elegant to have a generic version of new context creation which
receives the mode as a parameter.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 mm/damon/lru_sort.c       | 6 ++++--
 mm/damon/modules-common.c | 7 ++++---
 mm/damon/modules-common.h | 5 +++--
 mm/damon/reclaim.c        | 5 +++--
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 49b4bc294f4e..ac34b02dace8 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -201,7 +201,8 @@ static int damon_lru_sort_apply_parameters(void)
 	unsigned int hot_thres, cold_thres;
 	int err;
 
-	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
+	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
+				DAMON_OPS_PADDR);
 	if (err)
 		return err;
 
@@ -375,7 +376,8 @@ static int __init damon_lru_sort_init(void)
 		err = -ENOMEM;
 		goto out;
 	}
-	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	err = damon_modules_new_ctx_target(&ctx, &target,
+				DAMON_OPS_PADDR);
 	if (err)
 		goto out;
 
diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
index 86d58f8c4f63..5ba24e0ad9a1 100644
--- a/mm/damon/modules-common.c
+++ b/mm/damon/modules-common.c
@@ -14,8 +14,9 @@
  * @ctxp:	Pointer to save the point to the newly created context
  * @targetp:	Pointer to save the point to the newly created target
  */
-int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp)
+int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
+				struct damon_target **targetp,
+				enum damon_ops_id mode)
 {
 	struct damon_ctx *ctx;
 	struct damon_target *target;
@@ -24,7 +25,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 	if (!ctx)
 		return -ENOMEM;
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+	if (damon_select_ops(ctx, mode)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
index f103ad556368..87d8058d7d85 100644
--- a/mm/damon/modules-common.h
+++ b/mm/damon/modules-common.h
@@ -45,5 +45,6 @@
 	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
 			0400);
 
-int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp);
+int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
+				struct damon_target **targetp,
+				enum damon_ops_id mode);
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 36a582e09eae..b64fb810e096 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -197,7 +197,8 @@ static int damon_reclaim_apply_parameters(void)
 	struct damos_filter *filter;
 	int err;
 
-	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
+	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
+				DAMON_OPS_PADDR);
 	if (err)
 		return err;
 
@@ -379,7 +380,7 @@ static int __init damon_reclaim_init(void)
 		err = -ENOMEM;
 		goto out;
 	}
-	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	err = damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_PADDR);
 	if (err)
 		goto out;
 
-- 
2.43.0


