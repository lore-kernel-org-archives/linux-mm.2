Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A9B606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIdDMbG/
Received: by kanga.kvack.org (Postfix)
	id EED116B05BB; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56416B05C1; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF00C6B05C0; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A936B6B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25CA5A7C8D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:42 +0000 (UTC)
X-FDA: 85466718204.26.27D05D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E6E5C0013
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QIdDMbG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446580;
	b=6HtmpaLASoZjM7W9Q8Q8ACZeTnpllx2Ht0vomTm7PsQxf1EY78ydeWRfq8MbxuRi10v5/q
	1zHIgcUT8AVfBbHuqJxxfMyMbCXDKCrEMYxPoHbQIHq67oee7hqTltaMGqQw94tFj7z5bF
	u99v24Vr6lrZIlUpsWIPIEvU69rnh44=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igCnFkq85PtXTzPTihkjUCAGagjzIDBLSi4DcEpO1aQ=;
	b=FezyHa7X0R6do7/UXafYHBFuQet40LUJX2Ux5V+rxAFCwdlRUjvJX6Wplpn79FJT4RRAtC
	wT7gGN6fKQvmycvVK1r/HUQmKR+pF+Ws6wunPtx9vH2/UTaRkan02iK7q8M8JzyKU4MRTo
	Hyz5vy3+nzdaelFukkMPzuH1E63rEEE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QIdDMbG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B936862264;
	Mon, 23 Nov 2026 15:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A131F0093E;
	Mon, 23 Nov 2026 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446579;
	bh=igCnFkq85PtXTzPTihkjUCAGagjzIDBLSi4DcEpO1aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIdDMbG/kg4G2W1A8LDPx+KOs+3+nO2itXMq+Ov2xdx1oMkPZ3+E7yuDBrXYCwlAa
	 LORfl1vwLIGP+bTVHJn99XId7S++FjlB1tGfqwGeLIgKI0mmd7t2M5bCnXJ56ipWE7
	 6luqsk/wKjOUNv8UNM1MlxuL1/ovgEqcp/IdWbSYiK6C+kLtwXo3oe18GIbFLYh82c
	 CzlV+IIRwV+C71kuesj3HSrGI7WbeEDHrcAKaWl2Ny7uSVqdT0yqL80WcLbjCIH8mi
	 JwFrZ8iOGTZ03yew5Xu4T/x9U3EVxfG6fs+SxWvCh7E1GYZVMKgyhpjByYxC0lWtIr
	 Vizljy8yGWpXA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Angelov <jasonangelov@ucla.edu>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v3 2/3] mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
Date: Mon, 23 Nov 2026 07:09:26 -0800
Message-ID: <20261123150929.81797-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123150929.81797-1-sj@kernel.org>
References: <20261123150929.81797-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E6E5C0013
X-Stat-Signature: e7z7ydqdon84z46x9sfiq44xpf6iwqkb
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795446579-346747
X-HE-Meta: U2FsdGVkX19SDMjRkg64+CibLTJasFSheg7o/jbWJqX4cj9LPaw0WorXDRXd4mLhv4tnLuD2uqnoht/SsVu0nnMSOm8WoMUE7XwlPOb2NPqwQaYa6wj2wP1hO/5wo0NM9w2cX8Kb5BJK6MjaW+fZFeC94X9pupPk0ZYAJVFz5WUyVkgI0k6G5ncCu70ev+0Q6jc4IsL9Nl4O151ClCrxnliYMeitMI/vHOsW6CSMRksRrqkOdj0S/UL0+xFtisG1uyhMeU3n1jdCSjMued+41Vq6K1lS5MpxOgRuaMA6jbAfJSMYuD7PH2Fuij1QP0h/tiGRvQHWTQxgrzN8M9c+p9+qdER8vwztkr2qMIVGyQ1I3zQAH/Ax26xyqvp3YV/3NSbfKxIhUca8+9OxDitRSZo4UeFq1Rzx/ETJa62VZBkJXydus61P7mUCdmONMOCfETnBvwOeOPiNOwTS1GKZEzSO1sAtrOu0ZgpNeNwxG3lMAY4iyS7yPVHO7bSo1MC9Lz+7CwkA7grP1FFrLbuA9NwxLY8wQUa3xM1SO09YmS7s2ozzbQSg6ZOuvKS6qYJ+IPem1mgtex27B9XVvN4cKYiTKkNH/AetJ9xgENQz3vbjXwKXRhgyGl1sx1uKQ4Fii1lny2hQc3ynPRBb6hWkJaHoWeZXNpYr8ZFymWDl6xcsABG6oN/uc8g5fcLZWbskS7wGTi4n5Kk7gic0KmobKkzaOjYxOKmV77WaLmvOCZ9+ONvNCGuy/bRvsDt3eehI1u8kW4XqesCq+gY/6VydNYd8Dh0ghMNx1iHjtX9eB8bdWgf4mddkCaWv2AlAaEJVPiu22w1PzYhir4XJ4+v4BhEqxNoU+QXSCtpjHbwxxJozS3EVAKOlmYHkC2Q9SkCREV+QpfhXZ9kZUIbnmxujAN5VRvlM6BUgFJ9DKxN23OoJf66fZw3RN/DvYbQdrRUBscZXhJbhwCTCypKqvv6
 Coi5W9O6
 iELgfBL7X1RbjytYX2silf3iO9Onc5ENaWsQ9k5lMNK563FdaNWf3f4GmiyRbajU2XLjaHbrUw2WDUSZYRSNS7zHR8MkUAD4EM9KZl34zd3EaNgjfQlKzAhT46wtPemyAnHHq/UQT2upi7WJU3JRUWA/ib7l0rtcwDtmri5m7VGENYf6+6caURQlMpG0cffz8q3XcxSMdg8NJ1TYQS+NmKfXvDpPQU5+pgNp9TRh5KWyF8Rnt8CzfFzCdRBTIpo5Yk2fYHm93Dhq5QMz5ujS+jViZjbQ4t3B4CUSA60sRo4eOX8kEeCcDPSr9ntA9siBE6vFsRDe/Mig0Z4ZZb0oHv1KXSYGGDPu9UG1cS14/t99sZoiUiwToa2i0UpK3NeBQQYMu6tTCHAwIW4of8DRh9XRXGLpsnDYzqz02HziJftXk92szbhxOSpMTD7rCG7+KnPq4umNJSTvcV+w/K6JI+LInsrbVzvPbx1wuPMTjN+iDO6dZ0JcimI9z7019yIGK80rQpX5OAlB/tuc1YRg5PTXScA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jason Angelov <jasonangelov@ucla.edu>

DAMOS_FILTER_TYPE_AGE_MS is core filter, not ops filter.
Add kunit test covering this rejection.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0eb5dcdba0ae9..156f74832c405 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1832,6 +1832,12 @@ static void damon_test_valid_probe_params(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+static void damos_test_age_ms_filter_is_core(struct kunit *test)
+{
+	KUNIT_EXPECT_FALSE(test,
+			damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2593,6 +2599,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
+	KUNIT_CASE(damos_test_age_ms_filter_is_core),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),
-- 
2.47.3

