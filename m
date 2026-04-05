Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0EEE9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62EA76B009B; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605CB6B009D; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4596B009F; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2A56B009B
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C2BCE2431
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
X-FDA: 84624844038.11.2073978
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 193FDA000E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AnFboUzK;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26ljzZzdNWvYY5hsuCOLrXPuPu6fOJjxiFmxWXjWsFs=;
	b=ytdQC50u1NczTH+V+gfQZAxHRf4lj/NtGoNEAr8rPIIHCEqdJek/m3KebkH7VlthhZ9yED
	uLSal04sY2lRUR9+1E5KkCp1+VQ8R8zB/Ui5LTWw+BrNt9kxDmrAvQQNx01ek1BKG5FRlk
	9cUFNV7eSbUJvKyAn+7avdf2+XW+b4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401958; a=rsa-sha256;
	cv=none;
	b=ArB7zzrDPqDDTguzgDvU8U7L6smHixm3TH8hLqYs3Pc/7JZxg/Qz8Svn4gAvXZzQ2+BMb/
	FOJfEgtIRqx3Du/+vnWijs5uWmH8FZRHLKhhM5bc9HVXMmDKm0ZFUxkUUBiQXeJmRowwxy
	sxCmG3IQVND3yckteP/brdLzCtUjneE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AnFboUzK;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 943E960120;
	Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222D9C2BCB0;
	Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401957;
	bh=9Nwo+bW0ZeePwq2iK6IWWxk1khfaf4AjvqsrcmsSnWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnFboUzKa6Jy5pP3gMeQgWFk9sXZwGRiVVQKmGf1UbLYkAsibRq/XKPUwbVsVDGo3
	 tilB5M5yv8RjXOg0ksSydC+WQcdxLsYBGC5RQOfTUnAXJBvUyfDUj7xA7uyWgpkfzw
	 mALAk1fj8YPEb8ADsh2mFbtTC/jXzv2LrdeCj7+uJkZcyWRwLlQ6HC7TFvgBn18vpf
	 rd/bMnHHOOJzuIEzwGK16Xtmnw3UOp5tZqApuN6NEuG5Mlo8qNjqPY/thNajYUBWWs
	 gE1cQlczKN7Vr1HXT+T1MYfmCISNQxj2bIPuOKQSTb7URMaCMwowV4JEXA4tFIyyZW
	 J8AUjkHj/odmg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/9] mm/damon/core: introduce failed region quota charge ratio
Date: Sun,  5 Apr 2026 08:12:19 -0700
Message-ID: <20260405151232.102690-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 193FDA000E
X-Stat-Signature: jxwdjw4hoy4kugqputktjfo9cpjwwdc9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775401957-731503
X-HE-Meta: U2FsdGVkX1+bZjYDNwlooh+2G1ROSWjfeexrq71Ttk8OctlVNQ9qVBicfVp9eI7mfPwlV/4gg0F6bd9Y96MhHeS/2t24bu9iZfwBc5GlEDWAmEgk0W1mT7eLlj/xdLKz1V1ZxbzRFfy5LI0x4cktS9NA5r6hmwTXX2wNo3KY1lUlJE5nhuKw6dvMs31wBQOUTsC5578mcIKctsNJBujZEGO8EdN76xdsh3mlQN9Txwmj2x/Yw2OLrPx1tE7q8EyUca9ri9ExVk4aa+JsPL6YXHfPDdKfUcKxUPvceuSuA8STuFTFG1rHPzvqzwgmlggZnrp5Itu/MT5y2gZnWTMjMId3KUW69cGXqlhyzPXFJIGMoPNcnv/97SiZEpAhztMyI2lCCo0etVLakGsHcO/zKvvkXwQX1G+bLpTlqvMUe/R1DYyGh/lfrsFkvUs6LOf5QkWh3WSDBc4bws+K65xY18KlupO/AxZaQtBSOaD+9MlsSx7dfK4yHxp3LEySn81tJpzLt4CNGKajKy99/uKbMnbo7vbq921eaM8eeH46QcgM1chOGoVAPdVduoEk3rCYsQKUeHPcA1UMhF+KzwLH+NBu0LUjQ2REg/IqdD18K6Ohr9Cf2V4nUets+sPa+GlZ56hJGWMREyUFDWcNlQv7FEnOdT8o4dywioLUgJZdls+lO8v+xu5iY2CEMMqdBSznVgpKqU7HidLpSKVVAIKWF1UuMa/DHIB1sS2BygVtL3z0hrsPZtmbLO+GwoghjT2gKf6TBtlFiquktJvvJ0W/MSowrBy/H7Xjw0w1CJckf6g3WIp5Se7MRsjjj4LvfJu/SI4hR0wso5fixu9wca08em2JCOa6EpomI97dcunkLSKvpK1hN/AUwbJ0Mutyz1zaEDoKLBjgNmUzO5sqlpEWKb3Y/KrM6r+NAgfjIW+Jv8B6yYM+97s5OemQuUjuBxnNbkkQtQ866t9iIv7TI0d
 3UxS97eC
 YJDzVynmICGYBANcgSWbPtE/GLtnsGCTECLhSyGI1Ps7o4e3/mopSpHcacpoQvN/4cW7nIpQn4sQF15wK9usLdBXqzu3xvzTE8B7L3ZUlAuaggoftmUMC/aKB69AS25s3j8XaSLr1778vLLR4at4PJOX/PIvEcaUn/syg2UetwHpjnxHEUU+C88f3bsZCdzkrGMNihX0AjjVph1d2T8+sNBJcdfL6lEneO0ZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota is charged to all DAMOS action application attempted memory,
regardless of how much of the memory the action was successful and
failed.  This makes understanding quota behavior without DAMOS stat but
only with end level metrics (e.g., increased amount of free memory for
DAMOS_PAGEOUT action) difficult.  Also, charging action-failed memory
same as action-successful memory is somewhat unfair, as successful
action application will induce more overhead in most cases.

Introduce DAMON core API for setting the charge ratio for such
action-failed memory.  It allows API callers to specify the ratio in a
flexible way, by setting the numerator and the denominator.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  9 +++++++++
 mm/damon/core.c       | 21 ++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4b69f4553267d..9ab7331775b9e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -233,6 +233,8 @@ enum damos_quota_goal_tuner {
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
+ * @fail_charge_num:	Failed regions charge rate numerator.
+ * @fail_charge_denom:	Failed regions charge rate denominator.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
  * @weight_nr_accesses:	Weight of the region's nr_accesses for prioritization.
@@ -262,6 +264,10 @@ enum damos_quota_goal_tuner {
  *
  * The resulting effective size quota in bytes is set to @esz.
  *
+ * For DAMOS action applying failed amount of regions, charging those same to
+ * those that the action has successfully applied may be unfair.  For the
+ * reason, 'the size * @fail_charge_num / @fail_charge_denom' is charged.
+ *
  * For selecting regions within the quota, DAMON prioritizes current scheme's
  * target memory regions using the &struct damon_operations->get_scheme_score.
  * You could customize the prioritization logic by setting &weight_sz,
@@ -276,6 +282,9 @@ struct damos_quota {
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
+
 	unsigned int weight_sz;
 	unsigned int weight_nr_accesses;
 	unsigned int weight_age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index fe5a4a8d5b294..fdeab474b7456 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -918,6 +918,8 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	if (err)
 		return err;
 	dst->goal_tuner = src->goal_tuner;
+	dst->fail_charge_num = src->fail_charge_num;
+	dst->fail_charge_denom = src->fail_charge_denom;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
@@ -2042,6 +2044,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static void damos_charge_quota(struct damos_quota *quota,
+		unsigned long sz_region, unsigned long sz_applied)
+{
+	/*
+	 * sz_applied could be bigger than sz_region, depending on ops
+	 * implementation of the action, e.g., damos_pa_pageout().  Charge only
+	 * the region size in the case.
+	 */
+	if (!quota->fail_charge_denom || sz_applied > sz_region)
+		quota->charged_sz += sz_region;
+	else
+		quota->charged_sz += sz_applied + mult_frac(
+				(sz_region - sz_applied),
+				quota->fail_charge_num,
+				quota->fail_charge_denom);
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2098,7 +2117,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
-		quota->charged_sz += sz;
+		damos_charge_quota(quota, sz, sz_applied);
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
-- 
2.47.3

