Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3110CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811A46B00BC; Fri, 26 Jun 2026 05:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9DD6B00BE; Fri, 26 Jun 2026 05:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726CC6B00BF; Fri, 26 Jun 2026 05:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46D526B00BC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:00:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0C571A03C9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:00:05 +0000 (UTC)
X-FDA: 84921466770.15.DA8F009
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9CC3A140004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:00:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BZC2sX83;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782464404;
	b=r19hhe3+6swVg1XQw55zJFQp9q+svg65JzBYlb5oqtkZw/tLAZMPVYPsXosNIWyzZpCZ7b
	oNU4peFHJntltZbvXkYQVFtQEjbEbVjcWYfY/XAzk5m/tTHZdOq3QlVQm0TZTJA09ctGA+
	jBCYlRwkkzY7Iz2jF0Y3urI/k3i7X0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782464404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiF+ZZp+CVU1sZqeDDRKvFPYiBeZ08llaMDiB0IH+P0=;
	b=jB/3nzJ7yViTHXtJ5pWU7TJtw4oh0BTeI1bVfdRZkwNJ99wH08mvERUj0+4KBUn5wrG+db
	mu8BWc7UXGT9hRn1FrT6OfJsXH7bomA+C28nWItxJkzYFRcJXECRefXd+Ls9VhqpCXCgjb
	R3AVneX6M04h7lGexklEnHS3lKKtFe4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BZC2sX83;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782464402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RiF+ZZp+CVU1sZqeDDRKvFPYiBeZ08llaMDiB0IH+P0=;
	b=BZC2sX83iCPGiP8u4V/j2JFHHAvan3ttXTMNSWEawRTRc+lBxqRdNidDx4QEoApuNeJhAT
	BgdopX6rtN9K9+8I+cLEXF9ye8+IOW3/ZuUeXXpWrpCbv6N7VonvJYEtiyZ43uTJ3qsC3P
	ZqY5ujY+QkxJyy2C1NoBP7ZADQVxNFU=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/damon/tests/core-kunit: test split above max_nr_regions/2
Date: Fri, 26 Jun 2026 16:58:38 +0800
Message-ID: <20260626085851.70754-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260626085851.70754-1-jiayuan.chen@linux.dev>
References: <20260626085851.70754-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CC3A140004
X-Stat-Signature: pr5dfacuogon99nmsbgf8danxpqm7ph6
X-HE-Tag: 1782464403-254549
X-HE-Meta: U2FsdGVkX1+wrrDjooo2PBnCfpYGqBSGJlXY5YABxDRP3UQhS+51U5jatDsrb5JSnlpyP5O1jKlSUrkI9h0YnPYAPKr3nZTkLvYK+6CvOeQqAFAkFJ6Z6lzMJ36ZF5vWbbLR97nI07RTaVThGNKW4b1d0nwNwi8HOLIEIaPoFAC7Frh6R9L550Fa4Iir3l0AtW3IPiMe4OmZNtrnmJE0Uo/J76/KQzId92dt7yLbQzbPa64lVxWuWd/DJBWdOPzAqN8AFW9u/jzmBw7euiUgxMpwHtY3SWltrtRj5HW0V/cPYRKB9hnW3+hM24vH3jiUH4jOYXkxdNSLLmMgi2GhqiWwchgzaARGoAEu8vAut5lZqUvd/ia/Uc2vG4IqpQV7w5APw6Ac9CyJEu7HX4Td1qRliqlil3hywJZEWDV+jggofwLbGf3p+nqikZLoWBwzyZQpJQs0/syOiIZTjZm0g+IFqqq5fPvpOLiVptw1mXgZSLYXs9k21V7LcyFWzWkdxP0JSDbYUvvHqLmS/alAPl6UKqxXQjs3zwSm0kdKjZXQS/6bRErxX5WAY+dPukDr8N54S7p9w2tYzzkvtQ9b1MVbi/5rIR2vmJ2YgwBobWDdoXmIFy+Pzz9h6d0OIf2UewYFuFcPv8j45WRn9wK7IC7wOACxeZG2k6nzP16d1qv0AbQfAnjcUgOtQAXP2DdszAUHCUZQDvxlTGy1ju9o9ZKoJv/PD4NwY+E8meyAx0fv8s+CjwO8NaNfGDGs+oVv+A8ktr457DDbrk+K5eaaflZmA7iYiwmbsqpdnhammH4STL1hvM14fufqRB/I1Lhd41CehZMqGwO5lXi8WWSNB/NX+JoJcav1DSuATjWcOID8QmTPXgvf8QvdaKprADMAUlV61ef0niY+4hVdYg9dqQDlga9jCWN7CiUCGdHYz8BZu/kens2/6Ae4XgNVbGdr5kEjzwEIwBSUfjCoG0C
 mVftsSzX
 wTa0GB31MbpDs5OCKkIiz0oGe8LdTYVsq7+u90k/rIWc1BsVTmlNhwuc08wr14KvqT8WV5OBJbc08OFQ1Y49KWvo869/PIzy4B5UVSeaTA4uP+kJyOsqRQBrrArHF7qMETnuHSseWHljW5EIPTjeD/kkyElIUNMEv3XoIijB0EZgWVr1ZrOIJQ6umpzbMUrBDtrc9Ex/O5chV9Um9gG5BVgSwgX8eIsZJpHGZLK0Z0OgAgXSMKrls2FggXt2BI/CpJGep4PxOa4dwmgNdk20oTmbEtEvw2Ph8K1zWIywOe7IJwFO/PVTAnjTF5LMvtVWN+r4gIYc9BM1QgGJSY+rRcwNgvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Add a test that exercises kdamond_split_regions() when the total
region count is already above max_nr_regions / 2, asserting that the
function still splits a fraction of the regions (makes progress) and
does not overshoot max_nr_regions.

The region size and min_region_sz are picked so the split arithmetic
does not depend on the page size.

All tests pass:
  damon: pass:31 fail:0 skip:0 total:31
  Totals: pass:31 fail:0 skip:0 total:31

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 29fbe495e532..6fe7abcd670d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -341,6 +341,69 @@ static void damon_test_split_regions_of(struct kunit *test)
 	damon_destroy_ctx(c);
 }
 
+/*
+ * When the total region count is already above max_nr_regions / 2,
+ * kdamond_split_regions() must keep refining the resolution by splitting a
+ * fraction of the regions (making progress), without exceeding
+ * max_nr_regions.
+ */
+static void damon_test_split_above_half_progresses(struct kunit *test)
+{
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long start;
+	unsigned int nr_before, nr_after, i;
+	const unsigned int nr_init = 760;
+	const unsigned long region_sz = 100;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	/* Keep the split arithmetic independent of the page size */
+	c->min_region_sz = 1;
+	c->attrs.min_nr_regions = 10;
+	c->attrs.max_nr_regions = 1500;
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+
+	for (i = 0; i < nr_init; i++) {
+		start = i * region_sz;
+		r = damon_new_region(start, start + region_sz);
+		if (!r) {
+			damon_free_target(t);
+			damon_destroy_ctx(c);
+			kunit_skip(test, "region alloc fail");
+		}
+		r->nr_accesses = (i & 1) ? 0 : 100;
+		r->age = 5;
+		damon_add_region(r, t);
+	}
+
+	damon_add_target(c, t);
+
+	nr_before = damon_nr_regions(t);
+	/* Above max_nr_regions / 2, so the blanket-split path is skipped */
+	KUNIT_EXPECT_GT(test, (unsigned long)nr_before,
+			c->attrs.max_nr_regions / 2);
+
+	kdamond_split_regions(c);
+
+	nr_after = damon_nr_regions(t);
+	/* Still made progress ... */
+	KUNIT_EXPECT_GT(test, nr_after, nr_before);
+	/* ... but did not overshoot the configured maximum */
+	KUNIT_EXPECT_LE(test, (unsigned long)nr_after,
+			c->attrs.max_nr_regions);
+
+	damon_destroy_ctx(c);
+}
+
 static void damon_test_ops_registration(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
@@ -1521,6 +1584,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_merge_two),
 	KUNIT_CASE(damon_test_merge_regions_of),
 	KUNIT_CASE(damon_test_split_regions_of),
+	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
-- 
2.43.0


