Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC087FCC9A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C816B008C; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFAC6B0089; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3CF6B0093; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 449B06B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD03513AC45
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
X-FDA: 84528360882.17.AED9D93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13DB7C0012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JwHQBb75;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJYAtc3OIsoelg3S40q0HjEY3cuw4xk4wN4pHk6YaH0=;
	b=JdDor6KUNv4q5ddMR1cnCvaEQqyzWx22N/iSa4P9QyG/B5mZFphqtxgI+70Zmzv46kTGBQ
	Fvpp/ysKweOUm/4L5R23G0V6EVoC96MXuMV+Swh9eMWhS+lZvLikvXKq3L3GAbtixve4U3
	yV/0cw6qRjg//5zDa9DiO76d31fdKAU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JwHQBb75;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104740; a=rsa-sha256;
	cv=none;
	b=qBGNflBL3a02L7C8umosJVLVx4YUDBjwtE1GrWMKi5B/kWACRs4/JCiEfwV2y7lbJ9jEXI
	iHnJAwTvBegn2xXfDl7NYbH+btke/kX4Qwr6ieeCSmtbxSdZl/Rh8d5IZ8P/0KgSiDn1CY
	UjDdGurqPDhrqXiwScU/3ZwHWLAGrDw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D02F44182;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C506C2BCAF;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104739;
	bh=L8f/ifxCU2NPf0V1A0Et6pf5vfY3OtYSlSoZEdh8jTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwHQBb75BCYx3628Zxc7T+Zu7KR5tq2xk1nZTwDdDxBbqgbplC7OkjNBj7MMlW7ZM
	 LB1wwsCjxl/y9HM4kkxf6lHsvgWZBKZbKk7q0H7y0a8R7qDqGhR7Rgmgongi6RxHAW
	 hbFIeMezZBsnj/i/tponGizAAugNueUtKN/8Oeg7YpJji5Fd2wDDclB/Jq/Q7g/Nb0
	 xMPcV2kruZHaqsrTijWC6Oob73912ZbNlLS9HOn5mzhrlq8lAsSD8AwXUPFrnDrZrP
	 ad0wz24W24FIfBZ/U52FUnSigozYkRza7zPOXaDrOQ8T5/4YE11Q3BRfBDetveZKKb
	 SOpTYoAY+OZjQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/11] mm/damon/core: allow quota goals set zero effective size quota
Date: Mon,  9 Mar 2026 18:05:18 -0700
Message-ID: <20260310010529.91162-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13DB7C0012
X-Rspamd-Server: rspam07
X-Stat-Signature: q1q8nxmg5nw4xtqfdm4pr3nazngf59ih
X-Rspam-User: 
X-HE-Tag: 1773104739-425256
X-HE-Meta: U2FsdGVkX188F2DsH9c8rtkQRPaUOfRK7Hq3ZDp0AI+ziqIYjrYjB70zslwJAMyKcXzVVCYene3XYhHDQuoJdhl0V3pdywEp6Puu/X7Drp6joObUs3HQaQy9qQwb2F3bgEGqXWs8xHBnTZgOPF00SVUoUnhW9apSJxhBxYNe5/F6ADK6o6IVX0jqRHZM2j2KaYuiXaqcdyGQqgrVDgCD0aJIeQWl6UDrOWvsBCv2lD7kfOy/41tEaZ3qRWFhmDFCT9l3y2FzR+6i7qR0GFpkf6nI6OrMhjqYFbB5uhdD/LsgWpSqInI6Fm89iJpo5p7MRtw3jDkXGM5MddaYaRZiV3z45vfBufBVV/jV3TndTbOCWqUxgl2X6RKHjCGNSv98yTTn/BPQd/CG3RfdUYrQSrwepTO0Wh7A3OEJRR3XsOInEg5W/T7fzBvm3KF8T5SaLGXeg1ZAkpvQgLpprjAF+iHAJh9oQwmYvEFe0d5NlsRBOU1xoVx4Nf7rXYHB4wnWVNGKY6XmFPS7n+l/IQp/OV1ZgsaeY/HwXz4nPue8fFAhUP7DDh6pVGgFFnflW14yAWOj/27xfs5L/di5L/7kw0aqLSqNLtpqt8/CqAf6XYPrttmr9UP/KugNYN3IhTlKQyXEd0eEyBO+lKshzWdC4aQ1Opv5QbVBdrGJywElUD1NBp3Hr5pDXMU4+0US9zOjxnHtqZfS0rJc9LlACFQVgF9E8xSBPEMfMsbrZ0pKQD0In8l/hhM28VYiY5uzExS22LeV/4PcVGikWH/+v37rIB7B2rDC2MF2iHS2FRNdgi6EviPBkJZvdlDJzIn9hgT1oAid3/YrLNBBThjdD/t17ZR/RIoHm+WNSYsjt4pN3q+Oj6R+3SkJIcqGjvd3msZOfbopZB1bkR/jJ6ewrSj3/QKmTR4t20iDItRDF0rF/fs/qbIJYb419M2MYFaQoGM5MnohadGXQWcyDwhBYdz
 6vWzgNE/
 GjR2XYP3dru/iHYkA7P1TM4m4ZY8UJeHcBKwS72nruO/pi3VzrXjAa40nUYi1N5WjPSSWs9jMM9mJdd5gYMD0cVap+l+DRu4B/0pr0ohtAZxL55KkQ2poEMMIIGj0niNCdZFVOLAJHKE5i1Q0T5MIjMZCJL28KY20QkEbVzh0kYSutPE48HnjZWqS//I29ecr0rtGQ9rEuc7q5i9c9KLoheGo4h9fcEIkpipYEUnLhQOlJ8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

User-explicit quotas (size and time quotas) having zero value means the
quotas are unset.  And, effective size quota is set as the minimum value
of the explicit quotas.  When quota goals are set, the goal-based quota
tuner can make it lower.  But the existing only single tuner never sets
the effective size quota zero.  Because of the fact, DAMON core assumes
zero effective quota means the user has set no quota.

Multiple tuners are now allowed, though.  In the future, some tuners
might want to set a zero effective size quota.  There is no reason to
restrict that.  Meanwhile, because of the current implementation, it
will only deactivate all quotas and make the scheme work at its full
speed.

Introduce a dedicated function for checking if no quota is set.  The
function checks the fact by showing if the user-set explicit quotas are
zero and no goal is installed.  It is decoupled from zero effective
quota, and hence allows future tuners set zero effective quota for
intentionally deactivating the scheme by a purpose.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c16a390152790..d351ef3bcf4e9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -387,6 +387,11 @@ void damos_destroy_quota_goal(struct damos_quota_goal *g)
 	damos_free_quota_goal(g);
 }
 
+static bool damos_quota_goals_empty(struct damos_quota *q)
+{
+	return list_empty(&q->goals);
+}
+
 /* initialize fields of @quota that normally API users wouldn't set */
 static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
@@ -1789,12 +1794,24 @@ static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 		r->age <= s->pattern.max_age_region;
 }
 
+/*
+ * damos_quota_is_set() - Return if the given quota is actually set.
+ * @quota:	The quota to check.
+ *
+ * Returns true if the quota is set, false otherwise.
+ */
+static bool damos_quota_is_set(struct damos_quota *quota)
+{
+	return quota->esz || quota->sz || quota->ms ||
+		!damos_quota_goals_empty(quota);
+}
+
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
-	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
+	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
 
 	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
@@ -2064,7 +2081,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	}
 
 	if (c->ops.apply_scheme) {
-		if (quota->esz && quota->charged_sz + sz > quota->esz) {
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
 					c->min_region_sz);
 			if (!sz)
@@ -2083,7 +2101,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (quota->esz && quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2111,7 +2130,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2396,7 +2416,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
-- 
2.47.3

