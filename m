Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B061EB48EE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230096B0005; Thu, 12 Feb 2026 04:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA1B6B0089; Thu, 12 Feb 2026 04:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC126B008A; Thu, 12 Feb 2026 04:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEACF6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:44:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66FF714071F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:44:24 +0000 (UTC)
X-FDA: 84435319248.28.CFD8AEF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8295140004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:44:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf23.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770889462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Niy9S2y2X5Fd9Fz/5TFkqyDDqIwBZlzMWlHo9EnUF6w=;
	b=fa3RWBp3vqQNOPFdzg+9HG2z9N/iq/yaZj5v16st2grrkiOY9YBXR8KjdYoPori28xHYRd
	8L/Q1aHZSzKnbZitmtwg3XjlqI4ncWkDDgSQyOnJo7Zjh2N6ThM6SmN0a+6MSFWUJNjyUd
	mxTdvDelP5oba7mRjgshIGiAQ2k2XWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770889462; a=rsa-sha256;
	cv=none;
	b=S/D0WKGLDS+hsvV9Yja/6XzTg5dl/XlNeV2Ja+brcaOD9UbMqr6GroVw3A8R/IyncsQXg/
	ErEnrVlzb0cs+7cNjKnWXNghDlQCDrAz79V9u1x631yLSnAiQP/Gaf900ZgpSm4/tLsxj1
	Ve8uP6q4l5c/dIyOP6gnNtttqRxmirk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf23.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fBVkR3nKtzJ46cC;
	Thu, 12 Feb 2026 17:44:15 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 33AE840569;
	Thu, 12 Feb 2026 17:44:17 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Feb 2026 12:44:16 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <sj@kernel.org>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1] mm/damon: remove unused code
Date: Thu, 12 Feb 2026 09:43:26 +0000
Message-ID: <20260212094326.906497-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: A8295140004
X-Stat-Signature: dzkh1q7em4db6cqgibjsqe6azpzjfthr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770889461-968271
X-HE-Meta: U2FsdGVkX19Sipuicsd+BONE83Pi//1jXhalaNJKgBET+ncHIUFYaZXx2T90nYqagD3DPOYx52+AHhbqE5+in0mZt8qCxXh1Anngaz3REo9lEroq5nEDCCUP9WOgZPgFJpo0fYK7oYlq+Wm/VaCeZJIkoj72GY/f7Tmm/oXoCUjpNBmQj2o+2X4W8rxRyihb8v6Xo8vcjMcGmCSDIfvhVfykM3oVhQWdtR/aALdeBjUB17pApmXcXzfCb6tLy3JnVUukKgjsvOUP9ZxahvUf5GK7VkbddvBs3541BXHHB9NA+kK4LxQUcuVbtE19SmOo761RnIp6pAhWWx/hDHREoRd/8DJg6VzkjQ3KIxOF/guPUXi76UVBsc/c0d0eLR39AZ5OG2zf+f5OwUnRRWAq000rLHWZGyBT9w8hoEswFOy9PhpTCG0NKhUJRB/YhlQxJOAa0ohO+HXTurfcIAopDXAQc6gMGCtzXen0JAzStrUnIpNuTw78DgmHRe1nnvRCvyTIp4yHSAxTPlH7wUJxvMpfY/0XHomEcw34j1IkA7YJe2dkz9y2N3t/knxTX2r57mRd5i+jf4hjiL4TmpCAk+DkPCSDWD8Hs7DVSAaIhL7D9A/N9ZHXcHUU+x6P5WHDiZLOdV30m9o4UKCko8lgVciQDKLcVmqoUvnf0oaYiZ/z5lI16cWyhNpDu0B0Ngn/PrvrLdJXm3W2AsFke4NEr1sFC8dRUVCWTGs/coOTbGVgR56AavW1gX/lZ4NR7Ndea4ybkfi/QPnfq7b6amvaYhJBFJWzuM3bRSM5zXJlV9f6GDlZ9Ibte8LmvIHNjp4bwq5YShwq4RnCrwxQ3YH5kIgk5Jhvxo9nl9HUJcwazCbCvq82KZNnp5t4Oh9HJCgvxjE0iWl+s2eCBWuc08vepB9cpLVtkNNIKRaPBiOrgyCs//SrnakL9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

damon_target is not used by get_scheme_score operations, nor with
virtual neither with physical addresses.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

---
 include/linux/damon.h |  3 +--
 mm/damon/core.c       | 10 +++++-----
 mm/damon/paddr.c      |  3 +--
 mm/damon/vaddr.c      |  3 +--
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3813373a9200..34b68f5af425 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -639,8 +639,7 @@ struct damon_operations {
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
-			struct damon_target *t, struct damon_region *r,
-			struct damos *scheme);
+			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme, unsigned long *sz_filter_passed);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 84f80a20f233..cc4cc953f3a4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1651,15 +1651,15 @@ static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 		r->age <= s->pattern.max_age_region;
 }
 
-static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
-		struct damon_region *r, struct damos *s)
+static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
+			struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
 	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
 		return ret;
 
-	return c->ops.get_scheme_score(c, t, r, s) >= s->quota.min_score;
+	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
 }
 
 /*
@@ -1978,7 +1978,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
 			continue;
 
-		if (!damos_valid_target(c, t, r, s))
+		if (!damos_valid_target(c, r, s))
 			continue;
 
 		damos_apply_scheme(c, t, r, s);
@@ -2256,7 +2256,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
-			score = c->ops.get_scheme_score(c, t, r, s);
+			score = c->ops.get_scheme_score(c, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
 			if (score > max_score)
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 07a8aead439e..7b4b1e27beb7 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -345,8 +345,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 }
 
 static int damon_pa_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 23ed738a0bd6..757b9e18847a 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -986,8 +986,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 }
 
 static int damon_va_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 
 	switch (scheme->action) {
-- 
2.43.0


