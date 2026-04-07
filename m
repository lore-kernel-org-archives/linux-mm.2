Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3679FB5173
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7266B008C; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658786B0092; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C5D6B0093; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 376256B008C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5D8A1A0414
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:42 +0000 (UTC)
X-FDA: 84629967324.22.392A3AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 509581C0004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ya6Chy+5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcxv33lghW61b4st1drLuKg/Jla5+4dgRu+THBhOI0I=;
	b=nrzadB0bznlDVeoKzc9mqHVFWEbbGQvOmQBhroTxYXblxAWnY74f+OTaJTkhpZXhqL/kNQ
	i2f+1MdA4GnF8UfacKQ+gQm/CpypZNXPlJu1ujTV+18l5FeOmxoMRvcfg456/i+UBj737S
	brn6UNU7PLHencxv4jpUNx0pcPnQgyM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ya6Chy+5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523941; a=rsa-sha256;
	cv=none;
	b=pZ2cFczUPrM+qtWv2MPB83G2MzoD2OhKfBNGxVlCBlMSN+pUVD+qcGiFlwSCSBtqVvhwPF
	A+bqutfN425PQqsK+M+yw9TQQXAeAjO5RTRgC65tN4mIGdZRCd7ONDVj2HdNJOJin5/vt2
	Zs8w0CgT6HRtId8aktd7m6fE834ELhY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF5A66132B;
	Tue,  7 Apr 2026 01:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8DCC19421;
	Tue,  7 Apr 2026 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523940;
	bh=ko23dhUOeztzOmVblh0gxDT/VcNWr6MRn18sxx/Qqy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya6Chy+5b3AebJKh3STXePoVOGUxWFgrjd1qoDrE7IZae/39lqP/O5feNr/nVI0+v
	 0KSt5+PKiIhaRJ40NE6UFdKjMP3AOWkvT0cEdC1t/egxInP1+IASHyFric1AAiNjNz
	 bU5sWR/NNJ7zXB8wTNcSLulIXuRaLTOI2OKXRCeYBZnqwGQDMskHPSmKwuiI+Twou2
	 FdOowLAakZVG05bgpfzIPSx2SNNOtX4FNPaYC7kGqbPjkPQrU50thV+oHlXQxKSlEt
	 fu7TvY/ACbFsmWY5IF2qPZDuID143627GwzGrFnO0UHJY+yDJQCmyYFgvFf7Basl93
	 8+MecnNwyizig==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 02/10] mm/damon/core: introduce failed region quota charge ratio
Date: Mon,  6 Apr 2026 18:05:24 -0700
Message-ID: <20260407010536.83603-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 509581C0004
X-Stat-Signature: wkrhj1b5enz1z9jrspz375fhobdgkm6d
X-Rspamd-Server: rspam06
X-HE-Tag: 1775523941-131491
X-HE-Meta: U2FsdGVkX18wej6o9coViLT31sHHnNqTi7Mj/8EqlxR+25Td4YH2kRSDgaagCuJjbEFZobVywyI/f672eaEIRTKTF4uIPjUbgzGEv9NR9NTAgFB5cCktn1F47nSMx1OI3OzHbNSioGmSuZoWvdKMGn9ZLQe9rQ71/ZDwV6j2AIJrN/hmENO41UXfbXJDIZ3h02p1W2aapl5j4bLdVMP0W+Odln+pH1bhl3MjG2NhCzuQLVXDcNbgl9roS/Su5w6l4UT701fbiRJL06Tp71q2pJvFx0SCaNxETHdIB5j7GrB25Do6b2cbI75efsQ0yy1ixOsGjtt8ZDKScSZ5EzD+D9ugEf5kY09BZ+Dd+COsGoa3Lk2OS4EUHiySmeNp0lAqMHspmmvTrM40vZl8etgJOBy3vBbphYNLAYi3K846VWI6A13CLVA1L5dFdvD8YwhKb3rEw+2DydPk5oos+pfFv7Mzkp8nx3MVj4mbipycD++lC0rsClksAMhYSes6npR7u7p2eFcY7GmBU1oXTls831qHyXfVK/VDR2nq1l6ZN7W/RxRRHlKuJko3gG6XhZTzjRCT/tDRAvESM3DmmiHzV9M4HMtaEOlWJ3si2eiUofEM5q5CfK0wqggwA7L/9MK/0ibD6UKox4OQidWRjXPq7i87z4G9xU7yneJs4VrKmkOWPtthPF5Oz7op0seE9BROfAkIKC8ABoNvJIyULM3zI7foBmHNZ61uQPAub2FIFKydxFqCd5mEGLrET6XaRTumvHqW5BTCAmTRFZLkpGxQnzSigmISJ7WOselqIILPTd89GFTRg4PIKT081qCI4pAWL/TzfLswfkI5jtsCDoEE+tmmEkGKLkNRiT3mWNxOBnlSkTW0aTen9TZyMUoiyYnN7QS+bprxTNfszqTcH5OMAISfmmqSGJDFHNuwrURwotp8ALeJ9RgnvdCWbqouWSd6zZccWxg4XEyMhO6aBUM
 KduRtWBa
 AvRLiapDD6ZyRjrobNYsAN9iTwrVqit3oTLjPGIakM52xaIePtKdnk71yzoJOqPIVw1VmG+akanTX+rWTt6BiF6Vc1P7OaXfFxhgaW6UEjDzRoKFY/GcTNKS0D5TZQ/Ano7nDVzEgX1ULQx09yLe6saOCTim7fjnVbMCl+2gd3ftePdPyNuUWY14vMX7x6OGhhxYJZOCWA6xaB+hfeGDAm5ONmkME70OgjdGJ
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
index 2a2f767d1a46e..692bd3e5dfe09 100644
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
 static bool damos_quota_is_full(struct damos_quota *quota,
 		unsigned long min_region_sz)
 {
@@ -2106,7 +2125,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
-		quota->charged_sz += sz;
+		damos_charge_quota(quota, sz, sz_applied);
 		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
-- 
2.47.3

