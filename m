Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF38C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D226B009E; Mon, 28 Sep 2026 04:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4826B009F; Mon, 28 Sep 2026 04:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A496B00A0; Mon, 28 Sep 2026 04:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 927416B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:48:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0606DA3D86
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:30 +0000 (UTC)
X-FDA: 85262544780.25.E6705EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 256A5C0002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMjaCbTk;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8DaDbB8ZQKuqKU9oeD4+Afniur8EUd6QsbN8UoqPQM=;
	b=h35p/Rmnay6aVVjWeMJ994MqlwJCkBlZzXVL++kEGbF686SI1reH6eVMr54SvFhuCS7yER
	hBAv5CyBM+dfEkGIQ2/COqiESQffFb4wl4fXEbFS90SfyxPhjpj+2SC+9m8AdjgmC173Rg
	XNPY7BOIKjnJhFr5SNmcMriRrofmtsk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMjaCbTk;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585307;
	b=PsIjfP4Pb4GSDJOSt8clsd68qOHdSMhQwsTXohbJeE7yeokO5xt5O7C5D5/6927N4IAVnV
	2b7pDcG3Y1zQ2iwc5a3C8jQdVv9/vKDtzmRrG4jndmYx0Hz7baJZoCo+ZHtsbd4E3MhfQL
	fhUHOjoKLkQ8aJ0tpDn6xzzSSaOId4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C5CB6020A;
	Mon, 28 Sep 2026 08:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E491F000FF;
	Mon, 28 Sep 2026 08:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585306;
	bh=u8DaDbB8ZQKuqKU9oeD4+Afniur8EUd6QsbN8UoqPQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMjaCbTkzMFB49B+wdgtKL4qKys8VbvfkDsQOxvkodGnJPZwYWjHX3u7MbtWVPVDl
	 iPt9/Nql44ZfEL+pBq7j79WiMzAUzMwZrIHoKyZTgbME8/RyqKBuiQxMXQch6+zDgT
	 Jekt1qFlVYGH0jqatHqcI4fEJQnhvAsEH83iJDhxR/OLRT8gxP43ScnoqAPpsL1bjL
	 q8ZnOOhzNOFtK4cy57Q7LW/t9SWuhVeky05qH6K/Gm9KRBxWHCmNYY3NIvZyVNgqkU
	 lDmttwxSVmwrUgjReFjkB7DIL9+cvg5tBYscLAD2Abz6XP1Crbf/3z4YJrEmTFwYZM
	 gneuqZQP4+QKA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 2/2] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Mon, 28 Sep 2026 01:48:15 -0700
Message-ID: <20260928084816.5575-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928084816.5575-1-sj@kernel.org>
References: <20260928084816.5575-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yccrqeegfgwabjsxrh7rrbjz9e6bii9h
X-Rspamd-Queue-Id: 256A5C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790585306-424327
X-HE-Meta: U2FsdGVkX19O5aF3hUg4YlYOmzpg7tCkDpTp0ZRyUJub/28vQGzGDfGqOLVB3Qyo72L1w7SeLh33Jo4vhZWRCFn+y3461MXvr0/JkvviGPt841b6gwHnrcI65wWwmHGHzi9x1ZB99oNbdsPa5iucTIcTPxDKUCe324pNcOnsp1ZXNhvQuHt8P5ENNFwJ4p+rxIZYykHHplzQiX0s0fgEamE9Gd5z0rtEuvuCd8sq4xzCvzuGV/SL1RhG4y3NNfWM9VAtPw3zgnPXk0fsBingmh0k9KcsHiNhPj/36xr4geOjPhGS2BPMygD3bV+dZuEQpFOk0hD4zIir+rXe9hfkNGfH/YQlri3TIMvnGZVl6FMyP2VBOdXnbnp6h5hqWiYrS2Zh9LECYOk3KBvlHZF7ZQOlB603aAMHrmnBTx8bS7RUM0uRX+Y1ufcDautpiyH5RCr4DjSU0wXjjNc4kL/oPsskQLT0Trn7+MmGDsD0IVr9xVytGKp+XJ2MMAeZRgLtztZzgcV0S+iGzAIbhPzJgWtK+lzORW2zuJgxsvSVeofQRatlRXsLlb6w9/iIkMPUuIpKwjqjTs5gtVavph510N4veVvNYnZ/ZOTB+TAn6E9jkj1J6ZGEh8c9dGWHFY9yxYjwutX5wv6pMS4DoiiyCDhEivTtq3sXZmTZYnb9bm8FTV2cm9GN4hzk9AzJrnTgkCvKuPR+oW4uKWIkLCCgl9YV224TtH87oCoAUQgCW0svbvvKIUw7QdgoLHBYdImpcG9ZBnr1q6O/+a34N6nwkxfEGuNJTLa0XEZX/zYN2S351Xflmt3P/WWhUlY9Cp0ZnbJGVTnNSzGh8XGO8x0ojNnO4owh2AtPjW8zd/IPGW+nkU94viFpdggITX2h155LBD44htZQS/+IkVSCI8vhASoWCZkKm39ai+Tii+oheB8igDe/Z6hLgad7HZ4AuOGHFhnORnGNqT7n4zgpXKe
 FdGYeHCN
 46DSnJBM4o7zoGM9tBYqYt1ClliJsmeupqHAhird92Z7CNNtcFhLKYgtg1ga7QHCyudg3koTBMhZ4QsXGIjgg+gpndhG3qSGpf6eXsS9+kltQmERZeloKAn1lxIKtEsg3Kfl+l/H0qXYHuW7v5pi+MxM/SxVVsjYxMd2kkH0+zn06c7XDKJ5u0f35rb015IOGt2IAuk3AmRDaieEodm5ayCL1e17IPWVU3OJhkvWQriEPJUzO+BdI3VUeykYyU60vu416QGoJDNjzowNj7zUO4zM1dhitwy8r4Dl0nLi1Q+zyuTQGOxHKjBGZ/qL+AbTSz1YEl7+KefmomHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

damos_goal_tune_esz_bp_temporal() encodes the size quota in basis
points, so the conversion is exact only up to ULONG_MAX / 10000.  Pin
the three sizes around that boundary: the largest one that fits, the
first one that does not, and ULONG_MAX.

Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ef4b8b85d67b..caf582882f5f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2284,6 +2284,53 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damos_test_esz_goal_temporal(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+	};
+	struct damos_quota_goal *goal;
+	struct damon_ctx *ctx;
+	struct damos *s;
+
+	ctx = damon_new_ctx();
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(ctx, s);
+
+	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+	if (!goal) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "quota goal alloc fail");
+	}
+	goal->current_value = 0;
+	damos_add_quota_goal(&s->quota, goal);
+
+	/* The largest size quota the basis-point conversion can hold. */
+	s->quota.sz = ULONG_MAX / 10000;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	/* Any larger one saturates instead of wrapping. */
+	s->quota.sz = ULONG_MAX / 10000 + 1;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	s->quota.sz = ULONG_MAX;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2324,6 +2371,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damos_test_esz_goal_temporal),
 	{},
 };
 
-- 
2.47.3

