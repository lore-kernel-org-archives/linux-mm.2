Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4242BCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235756B00B0; Tue, 29 Sep 2026 04:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7646B00B1; Tue, 29 Sep 2026 04:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8146B00B2; Tue, 29 Sep 2026 04:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF1966B00B0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C891B1C2F7E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:24 +0000 (UTC)
X-FDA: 85266054888.22.816EFDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2853940010
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfZcgTFV;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJFs0NvNZ8hUk1hfwQ3orhYzP7yFUljqu63649S25T8=;
	b=WWlkl6S3rKljHlmmwehfswBY5ZGm3PcVwl3HnQM4gbrvJHBicsDj5bUvI/fb3qhs9VhYqz
	JMS6Q43QLNGjWHQtQ57NgUe0tBhb/lVyXMYqCYt4TEqeunp7WfrllHiw38lPTZRZoC2Mht
	fZIX/Q2g7FdVYRwkaEx9shIGBpImabQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfZcgTFV;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668883;
	b=R/hrpyQXdWRu5Amoie5U1arzSFTcXAG6hZyRUchYefOgIDXwTDi9GWF5dUIPY+seoLUvey
	KVR084OgaH8X1tGUcSae5sQ4zN2SR3o0gqe6sgI1+yR3pza71XzSPtxDcrWo7qAUdWMvJB
	wiM9ohLa04tRFXRVkB1ryoZYm/uLeo8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAC5A60A59;
	Tue, 29 Sep 2026 08:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DC61F00893;
	Tue, 29 Sep 2026 08:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668882;
	bh=GJFs0NvNZ8hUk1hfwQ3orhYzP7yFUljqu63649S25T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfZcgTFVpeMixc3iS2iGLfivqdjh5dOsP6COae6tkm0lNZQKr9RdSPxkgJH7t9xdU
	 MAStqiK9uG/H4l0qsfEj7sMHl4Siz2s77e/IMjNy8Aq+nWscLs2J5P09T8heMBovYu
	 fdapuf/Sk7ARot7B1cNrIYO3UxI1DmOiCw5S5iGbOd5GoAkb3zJo+CTSjiDDzbW6pl
	 SOjiu/s5fl3Y/Js67b7YN4TvzgCLIUQWUNW0akm0sVb7bUAFwXHYdjJT42YICEeIOs
	 3nzDgb2WwwcWPQEfJz0sCu5R2/uwEsevltP06YNo0YTfx10lBmMZplfNBAXntHRaF0
	 smYfUqfe/lymA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mm/damon/core: introduce damos_quota_goal->complement
Date: Tue, 29 Sep 2026 01:01:04 -0700
Message-ID: <20260929080113.41708-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2853940010
X-Stat-Signature: 53iky9ns8cpue1zh1hk7qnzfmwh496qu
X-Rspam-User: 
X-HE-Tag: 1790668882-659384
X-HE-Meta: U2FsdGVkX19WU7TXOBtNR8RehPUaMu2aRSMKhlne2KiTWpNz3pKac/+1kZ+m3Fbg+PbXKMfWHqMIQtJkwQSyoJTAMeOSJtSxDtznbr5JXeRRZP1IVJnHDAOxc65Nd36mcCC3APcG/4WG/pis2Xg1tEDgVfY7gPfrqVo1BCeyHM7KLrISiiGAh/zG4+Xd9jqfMA+9WlESi0KpLIyoyjgm6cufvSuyMUymaw8b+lSYB4D1u4G6uk3A9YAzCNs/D2s4XkzPyw6eGK55+g0fq3IJ1giuNhSLrb305iqWFqimF83ecgqvGvh8tGGIZC4BGscbtLpIn4pi3L80p1EsvA2nnN/1Gmp+uBIpafHeYNRE2j9uOo0PQ5y+cOkFQrpKymyWgmVFG7SM+K8yxBNrxYtRim/ByvE0Kx9xIaz88diWzglDkR2YW45ipmnAQBgtzRIjxvjqYTCOsSr5sk9l6HAXen/qpJr85JcSJsfuictWZW1FPURd5wicPWNtBizfNPhHlDDiDsNZKzR6kidvSIiorcFPy7t17y2xgp6ycv/cUDde80kqBiSegBcGIafFGR/KOjZlaMfBJ9pU7XBDCaFarstX6rs4wSwyrrmzOp/x6XGIkyAKR9Q5mlB36NfQRpmZDxHx8yyr9eFCAkWqfa2Q75BBSc1EMNnAzHO2H1pw7VNodeo/8mUnDvUaKKdbtxZk4rI3bnzqINmRqsMInITKhfZ9HOsc+EQ4ahmIbhb8/v5nCjw+HsHCpqgq3ov9AD3pxDybp6C1mPFHpBD9H/mMe3yqx+OAJimjDn07pv4kHjFrSRmzfi9zwN10MqIIqUu4sW5mMUoHdXdCppKfBUs006reV7tkTGcnzjY9zzB9whqJdXc67U4e4xWYxwlCjLcnudyxV+wSMzMx3kL1aq+fhWRqSW0cT9yADdvi4OhZHe1SDeO5xHeE4+/Hj+cdkr8zwfvg8AtKvVGW06+Dhsx
 b6l78D6n
 wKY3UOO3fNliJQvWLJaitRQrln+D/ZJ62QoWfsf/AoB66clLotrAhtUWMDr22x5LJay9EVoD4vZwipoihJvda9rXWxd2KhTKQrnk/GKPcwLSmdxm4kUBFr+XH5KReQvd9i2Lf9SkxXTfXA7T+2J/tq0jW+qJOgRD3Ieun/1ZwXV47m855kVLVNXTp720cOZTO2/gMaWBD4jxH5HT89vPHBgw1oCrNwPyMs7nPqJ9Ka/qlbbCVtBs/nKDX3q+A713nTq6qHMGfmP5rdIZ0WnKHFEAhVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce damos_quota_goal->complement for specifying whether to use a
complemented value of the given goal target metric.  Add the field to
the data structure and implement essential core support.  Handle the
flag in the quota goal commit and current quota goal metric value
retrieval.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 26 +++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6a29dc2ac8db..42234839ce29 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -169,6 +169,7 @@ enum damos_quota_goal_metric {
 /**
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
  * @metric:		Metric to be used for representing the goal.
+ * @complement:		Use the complement of the metric.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
  * @nid:		Node id.
@@ -191,6 +192,7 @@ enum damos_quota_goal_metric {
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
+	bool complement;
 	unsigned long target_value;
 	unsigned long current_value;
 	/* metric-dependent fields */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5ecbea5d71e1..1ab5154511e6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1224,6 +1224,7 @@ static int damos_commit_quota_goal(
 	if (!src->target_value)
 		return  -EINVAL;
 	dst->metric = src->metric;
+	dst->complement = src->complement;
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
@@ -2960,10 +2961,18 @@ static void damos_set_psi_current_val(u64 now_psi_total,
 		struct damos_quota_goal *goal, struct damos *s)
 {
 	u64 last_psi_total = goal->last_psi_total;
+	unsigned long val;
 
 	goal->last_psi_total = now_psi_total;
 	if (last_psi_total != U64_MAX) {
-		goal->current_value = now_psi_total - last_psi_total;
+		val = now_psi_total - last_psi_total;
+		if (goal->complement) {
+			if (val < s->quota.reset_interval * 1000)
+				val = s->quota.reset_interval * 1000 - val;
+			else
+				val = 0;
+		}
+		goal->current_value = val;
 		return;
 	}
 	/* uninitialized last_psi_total; make no effect this round */
@@ -3255,6 +3264,21 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 	default:
 		break;
 	}
+	if (!goal->complement)
+		return;
+
+	/* updte current_value to complemented value */
+
+	/* for user_input, users set complemented value on their own */
+	if (goal->metric == DAMOS_QUOTA_USER_INPUT)
+		return;
+	/* damos_set_psi_current_val() handles complement flag itself */
+	if (goal->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		return;
+	if (goal->current_value < 10000)
+		goal->current_value = 10000 - goal->current_value;
+	else
+		goal->current_value = 0;
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-- 
2.47.3

