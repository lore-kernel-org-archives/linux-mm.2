Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76EA5EDF16D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 14:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A2C6B0005; Fri, 13 Feb 2026 09:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27D46B0088; Fri, 13 Feb 2026 09:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A156B008A; Fri, 13 Feb 2026 09:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EAF16B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:51:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18B87C203E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:51:32 +0000 (UTC)
X-FDA: 84439722024.24.3C83590
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id EB6D11C0006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:51:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770994290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=/FM0Wiq/ZeKBX91tuQ16UlDgomzVlMPfBN2i8g1Yk18=;
	b=lUHpN6+U3YgepkE8kE8M7oKT4EpMQuKTNJBslrf+HoPtEk1YMJufvBu9gVLiXDWeYm3dVK
	KulOEAhOGVBb7y3LDsqj7Gy9kRSYSIp4++zPFukGkX2G1AzZacjNuRqQWMc1KKX5ecsUIL
	hFaY0N80m/SbWGljNbrG8q6eWoPSyhE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770994290; a=rsa-sha256;
	cv=none;
	b=RWdO2Gv2UuDvpzTksG7xQAPW2aWNcjCHLTYlISJwXJwHf2X1bRTPKn5iEVXqPM7c+II/qB
	vEpjItaBvaYntgDNbMT+PuFYK9VlV3xW3wPg4JzSVB5hTKKG2elSfTNVyc65darPliUUXq
	nFyR50RQYuaiuUFvYr0vZjDHdBWpqOQ=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fCFV20nGMzHnGgv;
	Fri, 13 Feb 2026 22:51:06 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E3AE40569;
	Fri, 13 Feb 2026 22:51:24 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Feb 2026 17:51:23 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] mm/damon: remove unused target param of get_scheme_score()
Date: Fri, 13 Feb 2026 14:50:32 +0000
Message-ID: <20260213145032.1740407-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB6D11C0006
X-Stat-Signature: dc48g1nu1bdgmny6wsajufex6ztitqps
X-Rspam-User: 
X-HE-Tag: 1770994289-601910
X-HE-Meta: U2FsdGVkX1+UX/w9iqi8GlBfwW/SiqOsr3cPUsjOw4Tbs9uobqby/A6RtL9xU+d5pCdYVPx2zKu3yIDKxSdqjS6ecMH4QIISPSl9UfXdLDNEa3fn6jYE9gQw6a224QugIOeUru2i1n0J4FOVqoWHNN+gcHtneWUAou42Jl9uAmlzRwEIRpFpWODc1pYDVPUmtHxX9lVfWjgnZtZyqclgdUeC+tqesHOx9jzgn/w2jbcZSjWNPlPRdxSsZMG6MUvQWcwN07qAKZxCdz/HPe0t4gMkE1aLKbrZm6clDJl9FkwIDpukoI/9ByjfqDeYYzykW8w/XERGp/G7tEt3adkTIzN87ACyO6Q5vu3G5aFb+emy6gzG+xNMth+uG52C+q/eq/nFtC3fWRkURVSdIW/x4CSBeUyD7Gl+kCUkGBn1xdKtNUHmxzQ7x0ttnAhpuE7zyGyTtr3QqRVAOYEDF6rRw/YDeZtild0Uu6gmd3C0xBqAp30owA6/qxmnfKFgUVJtVLtPF1KfgReenJuYBEwuurQWjvKwTsEaXcbF0Dj3kelUGMAWVaLfTSaR6h8eP0f1CyO+4/lV3JgxSbCWgRSSp0sd+LeqRgdtNlMZBnlOnY/7F3EnR3aWjLrfmA/xVN11HvfjUec5n5rEsvLrJnjFazKjZnEZHBfVm4cPjGiBncliXc7xMq4UdPbuCOxzdJRndrPY7iJLOo+KjcGxKdSfbt0MUmVCrPHEVwJ79ERGcKa61jALoh5yuuwWFozCCAxdd8Ik5mwJGD+G81k40MCOYXf1adi8uxlVrBhS8PkkzA/PFd4ZLE6yI6amERw50lpLoQp980awGg9wFMR4ru6oi1JYpdWP/G/3Foid04hUs73nbaS3z376q66aVwfEC0ZAPAVBA4Su/umdiflXs6Ic9U6R1aN4YVtbet0TYnfFjNYTJBizDPjPOhs4obFG8PIg74X/lsw1wH14htSsu/Z
 4hunHI76
 NT9jF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

damon_target is not used by get_scheme_score operations,
nor with virtual neither with physical addresses.

Changes in v2:
 - Patch against mm-next

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  3 +--
 mm/damon/core.c       | 10 +++++-----
 mm/damon/paddr.c      |  3 +--
 mm/damon/vaddr.c      |  3 +--
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a4fea23da857..9a88cf8d152d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -647,8 +647,7 @@ struct damon_operations {
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
index 5e2724a4f285..925908415a04 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1679,15 +1679,15 @@ static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 		r->age <= s->pattern.max_age_region;
 }
 
-static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
-		struct damon_region *r, struct damos *s)
+static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
+		struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
 	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
 		return ret;
 
-	return c->ops.get_scheme_score(c, t, r, s) >= s->quota.min_score;
+	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
 }
 
 /*
@@ -2011,7 +2011,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 				s->max_nr_snapshots <= s->stat.nr_snapshots)
 			continue;
 
-		if (damos_valid_target(c, t, r, s))
+		if (damos_valid_target(c, r, s))
 			damos_apply_scheme(c, t, r, s);
 
 		if (damon_is_last_region(r, t))
@@ -2309,7 +2309,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
-			score = c->ops.get_scheme_score(c, t, r, s);
+			score = c->ops.get_scheme_score(c, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
 			if (score > max_score)
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 9bfe48826840..5cdcc5037cbc 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -343,8 +343,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 }
 
 static int damon_pa_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 83ab3d8c3792..4e3430d4191d 100644
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


