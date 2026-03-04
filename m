Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E40EEDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3926B0092; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FAA6B0088; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7513B6B008C; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 520C46B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED90E58B95
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
X-FDA: 84507131940.27.79F22E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 772E480007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EV931DHA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSV3q4t4xvceQ2BHDp+PG6T2nK1hUMRvUbVJFWnQ8lY=;
	b=G2NQlhod4ztVw6gd45bU5N5C3lHZglNWrQaSPCqz/CyTXqokCVU3g6Cp+LODgkqLIV6uK3
	G1ArZu29NeZGG7BzOfobvIzw1e8MPQMW02tDaT137KQa8JPj1+5ES/Z0HXTcM7ZjoQ8LA0
	N0tKeuVA5eg3WsZQKht3vXqgLDFm2bk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EV931DHA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599289; a=rsa-sha256;
	cv=none;
	b=Fi6D6cYwSIzGOn01L5XGKpFqv2D5wjOwXsmH3P2rL6UbWDqJuh8M+Y7Hek/GI/CjwT0jS4
	9snml+R+ZPYNM2/3a17rgsiZSOuA9dsnmWXVrMMDY07sXFpmyZp1A6d1K5Y9FUYfvDZH9m
	vsXyQtMiDDqupmEPoyctFUrmw2dO73Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C88A440A5;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089FDC2BC9E;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599288;
	bh=nTnfRhRJMckp340lWLTDQoIkY6mvLW+nk013FmeqEz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EV931DHAiKMtwvkYfYmHhfhN/0FZek1fgBPfYn8g0n4wNHd/3yS5HXIwPl784LK07
	 O8tH1R+5W8pA7orBtjjHjWKFfgNpVXDuNGiJ5Ate34Wtptf7lp6CNA5bVDa4KfBn6n
	 w586nH+D6+FOhoCTRbyGCBZbipUfv9Xeo78JGAOdkpeFBElLqODU8Y7J/sZqpUCPfm
	 Z2rtDXs/Q6ccq8kNK6Aj34+CtClK7qxRkChUpJkPKSs6JVZIhblbPuMaxnzYSH9vQO
	 wWj0ag5TI0aGnwofyTUFgDWsqMZ3X93ADOFI7/4oQd9sU4DQCRbRQiMkEbp4Er22P4
	 dawZMVXPcsENg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/10] mm/damon/core: introduce damos_quota_goal_tuner
Date: Tue,  3 Mar 2026 20:41:10 -0800
Message-ID: <20260304044122.79394-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 772E480007
X-Stat-Signature: gdy4hhq71h4gyu6cgtom5ado4f84p1ew
X-Rspam-User: 
X-HE-Tag: 1772599289-209909
X-HE-Meta: U2FsdGVkX1+ImjNZ7kOG7idAe6KbDcRjNDNftA9Ug0SPjrsm//wsY76GDiyvRhSofPBXs2ut3JnchLj7CAzwXyZu/jKmoSOIwFgGWfe2fhYKZ8QcTWT14PLpj8LB8i71n5IFM0zld6dD5hiqRLnPOASPzoL8Rare5Mm5ANhbjV6yHwM9poWVcIYmUCP+GZQCLRX+mAgxz13AoAbvMq4MGwaB92IcFJbGftdc1ujuxx25ux/wIBwYQWZn+0gonSIiYhwHRsAX0Hbit1bPez4qE4F6qILbwKzUDlTKo1PIQwwHU7dTQV44j7ifIrHPnBB4v0yW8U9gvlswrxtT933RSo2xgljAgJUTeEzBDRDICsS3k17SkQEr2C896Gap75+ZWXq5+hDhZxNxjObNsxpsM1Cf03dERzvnHFhNIFcCYCFJie/XTqsjz3taiu/N5sNKsd4A6eedA4Bltg8QK6LnKLYJMLYD7DiIeDsQkMfMSpuLqPLla1duvkOemZPmnads1P8q6YHLCV5gIVGXkU/sac0xQLg1kEi8mmQr/4cRHmD8O7ZJyM2wPyYcq2+2++FpW3eEsOeg7L6lK5mUjDW/osfGtB16Rr/wkEJ/03A/WQ4nWPuH3DIq0vje50C4LzrvtBfJep9pk5OCPUwMuyuy2FnVqzi39QV5vhYzhY0GweDI3r7cjfCH9liUcZRSUQGgiBasHKxAvjZdqo1yxt0oJSkLd1l2er59OqBsHrUqDu4mRYwFgtmEsqRIzlAiYprC13L7l0lCwxmEi9E0U0eB/fpI90rd35SnrMMehYjFmHXUAzR+UF15Auz2aO1DzgBmURKGd3aoq6B8/5zCZB+GzblCWF6xhkVc+sTiSjzbUHBwUkrfBhzShJ4DruBJqiOHabHBgiwTimOTapow5HI+Abx6NAK+GMbGKU3dFGhNW8oS0FK4IvfI8MDIzoxLb+l7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently DAMOS quota goal feature utilizes a single feedback loop based
algorithm for automatic tuning of the effective quota.  It is useful in
dynamic environments that operate systems with only kernels in the long
term.  But, no one fits all.  It is not very easy to control in
environments having more controlled characteristics and user-space
control towers.  We actually got multiple reports [1,2] of use cases
that the algorithm is not optimal.

Introduce a new field of 'struct damos_quotas', namely 'goal_tuner'.  It
specifies what tuning algorithm the given scheme should use, and allows
DAMON API callers to set it as they want.  Nonetheless, this commit
introduces no new tuning algorithm but only the interface.  This commit
hence makes no behavioral change.  A new algorithm will be added by the
following commit.

[1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
[2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 mm/damon/core.c       | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9a88cf8d152d8..63f1e3fdd3866 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -213,6 +213,14 @@ struct damos_quota_goal {
 	struct list_head list;
 };
 
+/**
+ * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
+ * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ */
+enum damos_quota_goal_tuner {
+	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+};
+
 /**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
  * @reset_interval:	Charge reset interval in milliseconds.
@@ -260,6 +268,7 @@ struct damos_quota {
 	unsigned long ms;
 	unsigned long sz;
 	struct list_head goals;
+	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
 	unsigned int weight_sz;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e8c44541754f7..c5503fdb10bb7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -432,6 +432,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	scheme->quota = *(damos_quota_init(quota));
 	/* quota.goals should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
+	scheme->quota.goal_tuner = quota->goal_tuner;
 
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
@@ -904,6 +905,7 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	err = damos_commit_quota_goals(dst, src);
 	if (err)
 		return err;
+	dst->goal_tuner = src->goal_tuner;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
-- 
2.47.3

