Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 974F0CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942066B0095; Fri, 19 Jun 2026 15:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A276B0096; Fri, 19 Jun 2026 15:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8082B6B0098; Fri, 19 Jun 2026 15:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57B096B0095
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFCBE1A0520
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
X-FDA: 84897664068.03.D3452AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36D4D180005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2c3r13Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5x+9CpZ9d2FO068E6zHl4d9tkv4JzmSmiMeF2MwjyZI=;
	b=aNvUJfc8s5FCsxgq0NX6q8sdiNi545OZc6uh39gaifvaNq5IC3D2x3VVK9I2XN5tt80/Of
	9RbnGIJ4OQFllAdZfyb/SrIpObP/5dt2wGFqgywA6ZpdYiGrC+ncKdmYliTcaj8WXsPZu0
	A5iPyOJdcV8mvXemuO0a0uf+uH0pEhk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897673;
	b=GfU02r7gn/biaCKKwTHVBF09RXX2ObsDfx+cGKhcifArGb3sxsA8/1Ag9a8OfkODklCvtW
	ZbyY2Fbp+HluOOEXemHynr9LmgkfPfn2MzbteVQw/l3HGvz4tWvbgSc7sDG3u4149lOUd7
	7znV/lJKry2xz3QBKV3Cm3Hoorm/Kb0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2c3r13Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69F0E406EB;
	Fri, 19 Jun 2026 19:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E768C1F00A3D;
	Fri, 19 Jun 2026 19:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897672;
	bh=5x+9CpZ9d2FO068E6zHl4d9tkv4JzmSmiMeF2MwjyZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2c3r13Zy1XW8Qda6rMF/lRYXRZ13GQFRZL6BlrWo6S7BUgystLOnkMtMCgiOH7p+
	 2B75iOiW0U6MfmSjfXawwSrOp+iSuFDHTWbmUx8nCBpdyKl8Zl3zekxPNndSFftylr
	 JmIJnlXuiGpaj9VFoPeYF3v7mAP8RjdLRSBkV7Qn5b2BzUeJKO8Gb0YCwr7Ul4s59l
	 XJ9iGLiZkEdvfWom0b0YF1iVQgEamb0w9xP+8Sgk7twsg6TVNWVbRTSfEp5cJkVucE
	 b/vGy1jvu/YDbhsmWuq0YhUrOQOVebpiaTvbMumq7JHcgKWViZ0H3XxEHs2W+xxA4Q
	 aaNXnhYqSIT4A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/13] mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
Date: Fri, 19 Jun 2026 12:33:48 -0700
Message-ID: <20260619193415.73833-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36D4D180005
X-Stat-Signature: 871bq17kwjfmdjmtfa3m1mrjqq18wz1u
X-HE-Tag: 1781897673-823717
X-HE-Meta: U2FsdGVkX1+jAE6erD40HN/VoVLTWvERiH5WV1M/CUpiggMFM1wqZiD/Hiilkjhv1C+3zQP530aHT6Uj2yFdigvEPT2L42+R0TnPsLY5x0Jp+OgfOUGTKj1sjvQprBBGkxzA5olLos8C8hH1+SQXbCOCN8JgF0gLxdcGf3KabASmRLUcWSxO2SBobSXUlSbYHGKX/AKksctc5j8pvarUCV+O7mQhO5PbWgMz6s7R2xDkLQs/W57lh17hAibpQT9zGWwJ6/+cbeBUFVu/zv60mWctx+LQXRPPRbesEQ4Bqi/T594vKdrzwA7jLa/HAiaP7d8+DhNJeoV/+BvDQV7C7F8a368F3FP9KYRHmsWDdoLa5IEVz5MriMWLwRRNV4yj6IMpV/K7M/uGkO8Uj3bQKBsfUM40roAP2Xd3QXqzpzz/NWZQgTpQLw90a+w+45lVvYuMrp9/hC8KwUSIeUZG5Kd7klBBkGJtW5hhOhXZ+82j3bv4/4FqcuMlIZF4Z1D/VsGi6ZDlNnKpoYCS5b12+4qXz+aN6znLpK4y/4Wszgpwky1XZj0bwmZZPkGzbrh2AJWGUXp2aRU0Z3SmeCe8hqZNpKDqFjeCyfVDvR7QGzBN20HFq7808AGnK7MjkzXsjtCl8HR7hqi36mmAgWAuvZXdqyMaZBcUBAc617c+V4RR2Jq/9X/eYIC9jSumAL53NG3KrstR/p922sSs1XkaNwGA4Uq4ogxGzztIImmJ0HYjgOfGFgOhlQD30CLBaC1Z4UCdNPO8AfO2YGTQMgeqvAovTf0tFUzcJ4UbCh79IZ6msy8sxH9ZnDAVrqiAN3IZS6H0mctuBhEwbbiLNXIikcL+tJh8jSwmdvxvNXO2vQDm+UASmjsuZuLi6YUHnkx/whq4gO4Zy+L1UKpKi3Jq1LLh1KGKwRW/W56cenXsjU6yXU3K5yXQ2Lt1r1KFnLu6LTMC+0Hqf/jot659Gw8
 7OGj6QKU
 dcFuiU3II/h7GhMVVObWijOE3KVRoNjwvrqqLmRZNV+XcRIkBg6ywH2onv8WkDSW2jpIQMCg2URG2FyekRVHBaXrYuGS7zYqRrijuoQgBVB9odnI7EXFmKDHhlKkOqMAjFA3uTLNxWxH/dA671CtinZXCXiQK5S6EJo8UHcsLMlTfp8nBVxgPNuYg7IZfUumF8vwLiGTIeGUKyA+pypoGGb1QsWNRpoTJDTrbxGud0jy/0pUePSgxOTBkkzA9UOecdzDpYixAjG5Z81tLH/rHsjIx6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in __damos_valid_target() instead of the
nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index afb00f9bf7856..3a6df10ba8548 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2118,10 +2118,11 @@ static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static bool __damos_valid_target(struct damon_region *r, struct damos *s)
+static bool __damos_valid_target(struct damon_region *r, struct damos *s,
+		struct damon_ctx *c)
 {
 	unsigned long sz;
-	unsigned int nr_accesses = r->nr_accesses_bp / 10000;
+	unsigned int nr_accesses = damon_nr_accesses_mvsum(r, c);
 
 	sz = damon_sz_region(r);
 	return s->pattern.min_sz_region <= sz &&
@@ -2147,7 +2148,7 @@ static bool damos_quota_is_set(struct damos_quota *quota)
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
-	bool ret = __damos_valid_target(r, s);
+	bool ret = __damos_valid_target(r, s, c);
 
 	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
@@ -2733,7 +2734,7 @@ static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
 		damon_for_each_region(r, t) {
 			phys_addr_t addr, end_addr;
 
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 
 			/* Convert from core address units to physical bytes */
@@ -3022,7 +3023,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			(DAMOS_MAX_SCORE + 1));
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 			if (damos_core_filter_out(c, t, r, s))
 				continue;
-- 
2.47.3

