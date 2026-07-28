Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD50AC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB776B0098; Tue, 28 Jul 2026 01:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1E76B0099; Tue, 28 Jul 2026 01:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C686B009B; Tue, 28 Jul 2026 01:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 238F16B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CBFE1C0270
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:19 +0000 (UTC)
X-FDA: 85037054718.02.7FAA137
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 015AFC0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWKgF+b5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+iR0WBRty/9e25KNHH96FJIzOaYrwS/QZZkMmGIIoI=;
	b=UBrhhOKF9ZIRU+XuvMAqYBLx1hy9tBvJy8ynwueU4LxB+h3RQ+RSeLGwmhipdzqswt0Yzs
	EjIC5afc2sQy3lkLIS1ua2zQoyw/Vru7EGZ8l9ROLiGTpAsIidbXFlv5aLnEAW7P65NEHh
	G21uZk6bdeM1OQkS6s20aZi/nFJsaSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216498;
	b=w1Z1aKMO9gyXGF2Xf2dCR9BCHPZK5EtZ1/6nyTT1st4I4RD9FTkyPxqIIu+8QMH+Zag3rj
	cLTHqXXEVhIQUghMMLws6apwyd8FQu7NQ9oWGFbIX6r2ZS6W02d2QMPIv6VuBf/pXC+bc8
	6JgmcKn+vT55Hq2TQ8tG4P6UcQIqtng=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWKgF+b5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C77360A6F;
	Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E12D1F00ACF;
	Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216497;
	bh=Q+iR0WBRty/9e25KNHH96FJIzOaYrwS/QZZkMmGIIoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWKgF+b568A7QXZBkiF6lBSFi8YLqZvmU8wFu/o14NdL5JyEo2ZNhbjRpC8EJn1xW
	 gJ+aItnXdaYO3v5jdY/kKKNPFsYntTrHQffTswsvCIhrMAWMkbTOAURt1hhGTYUOtO
	 DUgta5B9pZCYoyWRUMa1rVv9CYtI+/Dr6BusFHeKSqnwGbnKHVzwKHiSwTz+UhpgBi
	 y1fHXM1jXSn1UhwVCGAv2wsUG48f7ZvWZg6+p+d6k0wBXL9TNs2zswV+h6HzJkk2Sr
	 1rCtZHnrtHNR12Hz+qz577qmJyNZw4Vp0S/SLt9ti5gWwKda7pX5tmUkUkkAaXe3Zd
	 qBrNad4sl8izw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/10] mm/damon/tests/core-kunit: extend set_regions() test for error case
Date: Mon, 27 Jul 2026 22:28:03 -0700
Message-ID: <20260728052811.192712-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 015AFC0006
X-Stat-Signature: n8em45dcyb7qoqkezg45b6t8gz4iyej7
X-Rspam-User: 
X-HE-Tag: 1785216497-320602
X-HE-Meta: U2FsdGVkX19Zwm9kmmiVQgsLwh/RzE0RXAllpzJLWwIopqs+T+CiKNFFdm1WOCP4hjnj2+1KXoUI4wiceWsAcVdARcSyayN728pm+FQxtuqsUZ/SrLcA+kGSflvSKIqU3T1pCP9RoTkC7UVBREA6KqJmMPvoyrke2TyzaPcJljUMyjfboVY6CeB3EYtNn9sDxa+vNVdOUXd6HIXh2jQY0SOknV+r4bSaza4uPYKWm9Wwpja5xF7is2m/vAduYN2rMIxXSmP87oWeAM5m5y3u/cvPggj3zmRrzildhdEG3N+ZNxLXNKxlZqk7cOkDjPHLyVPLC9N4GY8G75LSSkfvXjKOLHRyY8PuKSYPZtmHlt9GZmY7mWgWsJMh+VEEfUvYkoXo0EZcvL/M9TJd8skFPAUCdLb9Mr1ooBVadZhxtDuQ0aTHX1ONd6ZR87zK6ahPcIKNNhTvAfsU0uVLZThpl4VxcRI86ELdUtLhlQzQBDaKLzopV/7OvK2xwpcKIpMSgWfwAyb6MSIXBkIKmWn4iQ4/ftlQXLkzXOqRSzZCm2dpbpMUciLFLCHf0KZ78hDpbuFbg9c9OIILxed3I2NVfG9E6IOlIVxQzRXI/1LL+6XDqSZxy81uNLKLQMZ0j25xlmgrS4izkC5VifBrwaHcmW+sHM3Pc5OZeHO0stgNIegTFebIGjIWVCUkyv+v4bv6Zomf+QMJswAKJuiHRlzB6ZnFFKCgYWamzWmJFQMtyN+aVDVb/NOInIVIY7nsntNgPF+DKXzWgMz1IoLDZY9YlrhE0GF4glYGXJGv5FWXr7yoIpTZW5k3ARRxxHFMXYB67cnaABJsMmVjDsnKWC/8w6dkCEpaVPVcAeLsQiYQiauozQ5+i0msYkwnthu6qL8lcKzKdmLsdeJhLQ0jeeIbLArMg4ZXMWBb13BdrYVS99fG8pz9SgPdbzYYm499jMe4l8CGPO2UA6ouFe0qyVY
 oaDVCLRO
 JrzGZ2/aTWbS+UV19BqXCrVG+USK8tS8Nqu9ixchoU6/6jwHA9yEtqHLsVZvJMDsF1Kx9v53BPKRNkdr/8g1wTpofZJ7zISMHDCPybKD70lXZOcCfjerLNMWqyr35IM6h7xkbvRpYKDUHgs+Adcb0ZE7+JLbo1wMWgGZtwgxQeM4aqBvxkkLbF+q9HoCHNKoCtw+tgnwcW2bZ5H40ZAKl7vvCxiT5s/tp12fvs7+eD7MmmEXzrVv7Ypob9amUO/GqZAakqi2VzkyAzVPCohHYFY7YYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_set_regions_for() is designed to test only success-expected
damon_set_regions() calls.  Extend it to cover error-expected calls,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2d..befc1196d6d60 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -463,11 +463,12 @@ static void damon_test_set_regions_for(struct kunit *test,
 		struct damon_addr_range *old_ranges, int sz_old_ranges,
 		struct damon_addr_range *new_ranges, int sz_new_ranges,
 		unsigned long min_region_sz,
-		struct damon_addr_range *expect_ranges, int sz_expect_ranges)
+		struct damon_addr_range *expect_ranges, int sz_expect_ranges,
+		int expect_err)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	int i;
+	int i, err;
 
 	t = damon_new_target();
 	if (!t)
@@ -481,7 +482,8 @@ static void damon_test_set_regions_for(struct kunit *test,
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	err = damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	KUNIT_EXPECT_EQ(test, err, expect_err);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), sz_expect_ranges);
 	if (damon_nr_regions(t) != sz_expect_ranges) {
@@ -510,7 +512,7 @@ static void damon_test_set_regions(struct kunit *test)
 			(struct damon_addr_range[]){
 			{.start = 5, .end = 15},
 			{.start = 15, .end = 25},
-			}, 2);
+			}, 2, 0);
 	/* Un-intersecting regions should be removed. */
 	damon_test_set_regions_for(test,
 			(struct damon_addr_range[]){
@@ -523,7 +525,7 @@ static void damon_test_set_regions(struct kunit *test)
 			1,
 			(struct damon_addr_range[]){
 			{.start = 18, .end = 23},
-			}, 1);
+			}, 1, 0);
 	/*
 	 * Holes should be filled up with new regions.
 	 *
@@ -544,7 +546,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 8, .end = 16},
 			{.start = 16, .end = 24},
 			{.start = 24, .end = 28},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be appended.
 	 *
@@ -566,7 +568,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 4},
 			{.start = 4, .end = 15},
 			{.start = 25, .end = 40},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be inserted.
 	 *
@@ -589,7 +591,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 15},
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
-			}, 3);
+			}, 3, 0);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

